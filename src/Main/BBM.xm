#import "BBM.h"

NSMutableDictionary* preferences;



//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - General
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%group BBM_GENERAL

%hook GADDevice
- (bool)isJailbroken { return NO; }
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
- (void)markEphemeralMessageAsScreenshotted:(id)convoId { %orig(NULL); }
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

%ctor {
	@autoreleasepool {
		if (BBMApplicationIsBeingLoaded) {
			BPLoadPreferencesAndAddObserver();
			HBLogDebug(@"%@", preferences);

			if (BBMApplicationIsBeingLoaded && preferences[BPKeyForEnabled]) {
				%init(BBM_GENERAL);

				if (preferences[BPKeyForDarkMode]) %init(BBM_DARK_MODE);
				if (preferences[BPKeyForDisableAds]) %init(BBM_DISABLE_ADS);
				if (preferences[BPKeyForNoRetraction]) %init(BBM_NO_RETRACTION);
				if (preferences[BPKeyForUnlimitedPings]) %init(BBM_UNLIMITED_PINGS);
				if (preferences[BPKeyForTimedMessagesForever]) %init(BBM_TIMED_MSGS_FOREVER);
				if (preferences[BPKeyForScreenshotReporting]) %init(BBM_SCREENSHOT_REPORTING);
				if (preferences[BPKeyForHideReadAndTypingKey]) %init(BBM_HIDE_READ_AND_TYPING);
			}
		}


	}
}