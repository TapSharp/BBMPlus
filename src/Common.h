#import <Foundation/Foundation.h>
#import <Cephei/HBPreferences.h>

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Definitions
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#define logMessage(log) HBLogDebug(log)
#define BBMPLUS_BUNDLE_ID @"com.tapsharp.bbmplus"
#define BBMPLUS_PREFS_NOTIFICATION [NSString stringWithFormat:@"%@/ReloadPrefs", BBMPLUS_BUNDLE_ID]
#define BBMPLUS_PREFS_FILE [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", BBMPLUS_BUNDLE_ID]
#define IS_IN_BUNDLE(bundle) ([[NSBundle mainBundle].bundleIdentifier isEqualToString:bundle])


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Constants
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Variables
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NSDictionary* preferences;


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Functions
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BOOL preferenceKeyBool(NSString* key) {
	return [preferences[key] boolValue];
}
