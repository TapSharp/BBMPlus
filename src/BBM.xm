#import "BBM.h"


void BBMPreferencesReloaded() {
	preferences = [NSDictionary dictionaryWithContentsOfFile:BBMPLUS_PREFS_FILE];
	HBLogDebug(@"New Preferences: %@", preferences);
}


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Constructor
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ctor {
	@autoreleasepool {
		if (IS_IN_BUNDLE(@"com.blackberry.bbm1")) {
		    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)BBMPreferencesReloaded, (CFStringRef)BBMPLUS_PREFS_NOTIFICATION, NULL, kNilOptions);
			BBMPreferencesReloaded();

			if (preferenceKeyBool(@"Enabled")) {
				%init;
				HBLogDebug(@"Initialized: %@", BBMPLUS_BUNDLE_ID);
			}
		}
	}
}