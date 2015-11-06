#include "BBMRootListController.h"

@implementation BBMRootListController

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Constants
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

+ (NSString *)hb_shareText {
	NSString* formatString = BPLocalizedString(@"SHARE_TEXT");
	return [NSString stringWithFormat:formatString, [BBMRootListController hb_shareURL]];
}

+ (NSURL *)hb_shareURL {
	return [NSURL URLWithString:@"http://repo.tapsharp.com/"];
}

+ (UIColor *)hb_tintColor {
	return BPTintColor;
}

+ (NSString *)hb_specifierPlist {
	return @"Root";
}


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Preference Value
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

+ (void)postPreferenceChangedNotification {
	CFNotificationCenterPostNotification(
		CFNotificationCenterGetDarwinNotifyCenter(),
		(CFStringRef) BPPrefsChangedNotification, NULL, NULL, YES
	);
}

- (id)readPreferenceValue:(PSSpecifier *)specifier {
	NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:BPPrefsFilePath];

	if ( ! prefs[[specifier propertyForKey:@"key"]]) {
		return [specifier propertyForKey:@"default"];
	}

	return prefs[[specifier propertyForKey:@"key"]];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:BPPrefsFilePath]];
	[defaults setObject:value forKey:[specifier properties][@"key"]];
	[defaults writeToFile:BPPrefsFilePath atomically:YES];
    [BBMRootListController postPreferenceChangedNotification];
}


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - View events
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationItem setTitle:@""];
}

@end
