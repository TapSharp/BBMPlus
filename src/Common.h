#import <Foundation/Foundation.h>
#import <Cephei/HBPreferences.h>

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Definitions
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#define logMessage(log) HBLogDebug(log)
#define BBMPLUS_BUNDLE_ID @"com.tapsharp.bbmplus"
#define BBMPLUS_PREFS_FILE [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", BBMPLUS_BUNDLE_ID]
#define IS_IN_BUNDLE(bundle) ([[NSBundle mainBundle].bundleIdentifier isEqualToString:bundle])


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Constants
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Variables
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

HBPreferences* preferences;


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Functions
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

