#import <Foundation/Foundation.h>
#import <CaptainHook/CaptainHook.h>

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Definitions
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#define BPBundleID @"com.ck.bbmplus"
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

//NSMutableDictionary* preferences;



//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Functions
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

static NSBundle* BPBundle(void) {
    return [NSBundle bundleWithPath:BPBundlePath];
}

static NSString* BPLocalizedString(NSString *languageKey) {
    return [BPBundle() localizedStringForKey:languageKey value:nil table:nil];
}

// static UIImage* BPBundleImage(NSString *imageName) {
//     return [UIImage imageNamed:imageName inBundle:BPBundle() compatibleWithTraitCollection:nil];
// }
