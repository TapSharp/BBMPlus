#import "BBM.h"
#import <CoreLocation/CoreLocation.h>

NSMutableDictionary* preferences;

#define BBMPLUS_RESEARCH YES

// Europe/London, GMT +1
// America/New_York, GMT -5
#define SPOOFED_TIMEZONE @"America/New_York"
#define SPOOFED_LATITUDE  38.89876
#define SPOOFED_LONGITUDE -77.036679


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Research
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%group BBM_RESEARCH

%hook BBMConversationViewController
- (BOOL)canHaveCall {
	%log; BOOL res = %orig; HBLogDebug(@"%@", res ? @YES : @NO) return res;
}
- (void)checkIfTimeLimitSupported {
	%log; %orig;
}
- (id)entitlementsMonitor {
	%log; id res = %orig; HBLogDebug(@"%@", res); return res;
}
- (BOOL)isTimeLimitAvailableForCurrentContent {
	%log; BOOL res = %orig; HBLogDebug(@"%@", res ? @YES : @NO) return res;
}
- (void)sendScreenshotTakenMessage:(BOOL)arg1 {
	%log; %orig;
}
%end


%hook BBMCoreAccess

-(id)getLocations {
	%log; id res = %orig; HBLogDebug(@"%@", res); return res;
}
-(void)setLocationReportingInCore:(BOOL)arg1 {
	%log; %orig;
}
-(void)reportLocation:(id)arg1 {
	return;
	%log; %orig(NULL);
}
-(void)addLocationWithInfo:(id)arg1 {
	%log; %orig;
}

%end


%hook BBMGenUser

-(void)setShowLocationTimezone:(NSNumber *)arg1 {
	%log; %orig;
}

-(void)setTimezone:(NSString *)arg1 {
	%log;
	%orig(SPOOFED_TIMEZONE);
}

-(id)getLocation {
	%log; id res = %orig; HBLogDebug(@"%@", res); return @"US"; // return res;
}

%end


%hook PPRiskDeviceData
- (id)currentLocation {
	%log; id res = %orig; HBLogDebug(@"%@", res); return res;
}

%end


%hook BBMLocalSettings

+(id)locationCountryCode {
	%log; id res = %orig; HBLogDebug(@"%@", res); return res;
}

+(void)setLocationCountryCode:(id)arg1 {
	%log; %orig;
}

+(id)appVersion {
	%log; id res = %orig; HBLogDebug(@"%@", res); return res;
}

%end


%hook BBMUser

-(BOOL)isMessageRecallSupported {
	%log; BOOL res = %orig; HBLogDebug(@"%@", res ? @YES : @NO) return res;
}

-(BOOL)isPrivateChatSupported {
	%log; BOOL res = %orig; HBLogDebug(@"%@", res ? @YES : @NO) return res;
}

-(BOOL)isEphemeralMessagingSupported {
	%log; BOOL res = %orig; HBLogDebug(@"%@", res ? @YES : @NO) return res;
}

-(BOOL)isCurrentUser {
	%log; BOOL res = %orig; HBLogDebug(@"%@", res ? @YES : @NO) return res;
}

%end

%end






//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - General
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%group BBM_GENERAL

%hook GADDevice
- (bool)isJailbroken { return NO; }
%end

%hook PPRiskDeviceData
+(BOOL)isJailBroken { return NO; }
%end

%end



//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Spoof Location
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%group BBM_SPOOF_LOCATION

void spoof_updateLocations(id cls, SEL selector, CLLocationManager *locationManager, NSArray *locations) {
	HBLogDebug(@"spoof_updateLocations");
    static CLLocationCoordinate2D spoofedCoords;

    spoofedCoords.latitude = SPOOFED_LATITUDE;
    spoofedCoords.longitude = SPOOFED_LONGITUDE;

    CLLocation *realLocation = [locations lastObject];

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSTimeZone *tz = [NSTimeZone timeZoneWithName:SPOOFED_TIMEZONE];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
	[dateFormatter setTimeZone:tz];

	NSString *oldDate = [[dateFormatter stringFromDate:[realLocation timestamp]] copy];
	NSDate *newTimestamp = [dateFormatter dateFromString:oldDate];

    CLLocation *spoofedLocation = [[CLLocation alloc]   initWithCoordinate:spoofedCoords
                                                        altitude:0.00
                                                        horizontalAccuracy:[realLocation horizontalAccuracy]
                                                        verticalAccuracy:[realLocation verticalAccuracy]
                                                        course:[realLocation course]
                                                        speed:[realLocation speed]
                                                        timestamp:newTimestamp];

    if([cls respondsToSelector:@selector(locationManager:oldDidUpdateLocations:)]) {
        [cls performSelector:@selector(locationManager:oldDidUpdateLocations:) withObject:locationManager withObject:@[spoofedLocation]];
    }

    [dateFormatter release];
}

%hook CLLocationManager
-(void)setDelegate:(id)delegate {
    IMP old_updateLocationsMethod = class_replaceMethod(object_getClass(delegate), @selector(locationManager:didUpdateLocations:), (IMP)spoof_updateLocations, "@:@@");
    class_addMethod(object_getClass(delegate), @selector(locationManager:oldDidUpdateLocations:), old_updateLocationsMethod, "@:@@");
    %orig;
}
%end

%end


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Hide Typing and Read Status
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%group BBM_HIDE_READ_AND_TYPING

%hook BBMCoreAccess
- (void)markEphemeralMessageAsViewed:(id)msgId { %orig(NULL); }
- (void)markMessagesRead: (id)msgId withConversationURI:(id)convoURI { %orig(NULL, convoURI); }
- (void)sendTypingNotificationForConversationURI:(id)convoId isTyping:(BOOL)typing { %orig(convoId, NO); }
%end

%hook BBMMessage
- (BOOL)canBeMarkedRead { return NO; }
%end

%hook BBMMessageCell
+ (BOOL)automaticallyNotifiesObserversOfMessage { return NO; }
%end

%end



//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Unlimited Pings
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%group BBM_UNLIMITED_PINGS

%hook BBMPingLimitHelper
- (BOOL)isLimitReached { return NO; }
%end

%end



//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Screenshot Reporting
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%group BBM_SCREENSHOT_REPORTING

%hook BBMCoreAccess
- (void)markEphemeralMessageAsScreenshotted:(id)convoId { }
- (void)sendScreenshotDetectedMessageForConversationUri:(id)arg1 message:(id)arg2 { }
%end

%hook BBMGenEphemeralMetaData
- (BOOL)isScreenshot { return NO; }
- (void)setScreenshot:(bool)screenshot { %orig(NO); }
%end

%end



//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Timed Messages Forever
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%group BBM_TIMED_MSGS_FOREVER

%hook BBMEphemeralMetaData
- (void)expire { }
- (BOOL)messageTimerIsActive { return NO; }
- (float)remainingTime { return 10000000; }
%end

%end


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Disable Ads
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%group BBM_DISABLE_ADS

%hook BBMCoreAccess
- (id)getAllAds { return NULL; }
- (id)adsEnabled { return NULL; }
-(id)getSponsoredInvites { return NULL; }
%end

%hook BBMADSAd
- (BOOL)isInvite { return NO; }
- (BOOL)isExpired { return YES; }
- (BOOL)invitationIsIncoming { return NO; }
%end

%hook BBMRichUpdatesViewController
- (BOOL)allowScrollingAdInsertion { return NO; }
- (void)insertScrollingAd:(id)arg1 { }
%end

%end



//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - No Retraction
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%group BBM_NO_RETRACTION

%hook BBMGenMessage

- (NSString *)getMessage {
	NSString *msg = %orig;

	return [self isEmptyMsg:msg] ? BPLocalizedString(@"PREVIOUSLY_RETRACTED") : msg;
}

- (void)setMessage:(NSString *)message {
	if ( ! [self isEmptyMsg:message]) %orig;
}

- (void)setRecallStatus:(int)status {
	%orig((status == 3 ? 0 : status));
}

%new
- (BOOL)isEmptyMsg:(NSString *)string {
	if ((NSNull *) string == [NSNull null] || string == nil || [string length] == 0)
		return YES;

	if ([[string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
		return YES;

	return NO;
}

%end

%end



//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Dark Mode
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%group BBM_DARK_MODE
// @TODO - Not Yet Implemented
%end



//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Constructor
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

void BPLoadPreferences(void) {
	HBLogDebug(@"Load preferences");
    preferences = [NSMutableDictionary dictionaryWithContentsOfFile:BPPrefsFilePath];
}

void BPLoadPreferencesAndAddObserver(void) {
    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(), NULL,
        (CFNotificationCallback) BPLoadPreferences,
        (CFStringRef) BPPrefsChangedNotification, NULL,
        CFNotificationSuspensionBehaviorCoalesce);

    BPLoadPreferences();
}

%ctor {
	@autoreleasepool {
		if (BBMApplicationIsBeingLoaded) {
			BPLoadPreferencesAndAddObserver();

			if (BBMApplicationIsBeingLoaded && [preferences[BPKeyForEnabled] boolValue]) {
				%init(BBM_GENERAL);

				if (BBMPLUS_RESEARCH == YES) {
					%init(BBM_RESEARCH);
				}


				%init(BBM_SPOOF_LOCATION);

				if ([preferences[BPKeyForDarkMode] boolValue]) {
					%init(BBM_DARK_MODE);
				}

				if ([preferences[BPKeyForDisableAds] boolValue]) {
					%init(BBM_DISABLE_ADS);
				}

				if ([preferences[BPKeyForNoRetraction] boolValue]) {
					%init(BBM_NO_RETRACTION);
				}

				if ([preferences[BPKeyForUnlimitedPings] boolValue]) {
					%init(BBM_UNLIMITED_PINGS);
				}

				if ([preferences[BPKeyForTimedMessagesForever] boolValue]) {
					%init(BBM_TIMED_MSGS_FOREVER);
				}

				if ([preferences[BPKeyForScreenshotReporting] boolValue]) {
					%init(BBM_SCREENSHOT_REPORTING);
				}

				if ([preferences[BPKeyForHideReadAndTypingKey] boolValue]) {
					%init(BBM_HIDE_READ_AND_TYPING);
				}
			}
		}


	}
}