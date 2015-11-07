#import <Foundation/Foundation.h>
#import <CaptainHook/CaptainHook.h>

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Definitions
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#define BPBundleID @"com.tapsharp.bbmplus"
#define BPBundlePath @"/Library/PreferenceBundles/bbmplusprefs.bundle"

#define BPTintColor [UIColor colorWithWhite:(74.f/255.f) alpha:1.0f]
#define BPPrefsChangedNotification [NSString stringWithFormat:@"%@/ReloadPrefs", BPBundleID]
#define BPPrefsFilePath  [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", BPBundleID]

#define BPKeyForEnabled @"Enabled"
#define BPKeyForDarkMode @"Dark_Mode"
#define BPKeyForDisableAds @"Disable_Ads"
#define BPKeyForUnlimitedPings @"Unlimited_Pings"
#define BPKeyForNoRetraction @"Disable_Retraction"
#define BPKeyForTimedMessagesForever @"Timed_Message_Forever"
#define BPKeyForHideReadAndTypingKey @"Hide_Read_Typing_Status"
#define BPKeyForScreenshotReporting @"Hide_Screenshot_Reporting"

#define BBMApplicationIsBeingLoaded ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.blackberry.bbm1"])



//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Variables
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

extern NSMutableDictionary* preferences;



//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Functions
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CHInline NSBundle* BPBundle(void) {
    return [NSBundle bundleWithPath:BPBundlePath];
}

CHInline NSString* BPLocalizedString(NSString *languageKey) {
    return [BPBundle() localizedStringForKey:languageKey value:nil table:nil];
}

CHInline UIImage* BPBundleImage(NSString *imageName) {
    return [UIImage imageNamed:imageName inBundle:BPBundle() compatibleWithTraitCollection:nil];
}

CHInline void BPLoadPreferences(void) {
    preferences = [NSMutableDictionary dictionaryWithContentsOfFile:BPPrefsFilePath];
}

CHInline void BPLoadPreferencesAndAddObserver(void) {
    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(), NULL,
        (CFNotificationCallback) BPLoadPreferences,
        (CFStringRef) BPPrefsChangedNotification, NULL,
        CFNotificationSuspensionBehaviorCoalesce);

    BPLoadPreferences();
}
