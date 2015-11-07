#import <Foundation/Foundation.h>
#import <CaptainHook/CaptainHook.h>

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Definitions
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#define BPBundleID @"com.tapsharp.bbmplus"
#define BPBundlePath @"/Library/PreferenceBundles/bbmplusprefs.bundle"
#define BPTintColor [UIColor colorWithWhite:74.f / 255.f alpha:1]
#define BPPrefsFilePath  [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", BPBundleID]
#define BPPrefsChangedNotification [NSString stringWithFormat:@"%@/ReloadPrefs", BPBundleID]
#define BPInBBMApplication ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.blackberry.bbm1"])



//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Variables
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NSDictionary* preferences;


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

CHInline BOOL preferenceKeyBool(NSString* key) {
	return [preferences[key] boolValue];
}

CHInline void BPPreferencesReloaded() {
	preferences = [NSDictionary dictionaryWithContentsOfFile:BPPrefsFilePath];
}

CHInline void BPLoadPreferencesAndAddChangesObserver(void) {
    CFNotificationCenterAddObserver(
    	CFNotificationCenterGetDarwinNotifyCenter(),
    	NULL, (CFNotificationCallback) BPPreferencesReloaded,
    	(CFStringRef) BPPrefsChangedNotification,
    	NULL,
    	CFNotificationSuspensionBehaviorCoalesce
   	);

	BPPreferencesReloaded();
}