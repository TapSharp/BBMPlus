#include "BBMRootListController.h"

@implementation BBMRootListController

#pragma mark - Constants

+ (NSString *)hb_shareText {
	NSString *formatString = NSLocalizedStringFromTableInBundle(@"SHARE_TEXT", @"Root", [NSBundle bundleForClass:self.class], nil);
	return [NSString stringWithFormat:formatString, [BBMRootListController hb_shareURL]];
}

+ (NSURL *)hb_shareURL {
	return [NSURL URLWithString:@"http://repo.tapsharp.com/"];
}

+ (UIColor *)hb_tintColor {
	return [UIColor colorWithWhite:74.f / 255.f alpha:1];
}

+ (NSString *)hb_specifierPlist {
	return @"Root";
}

+ (void)postPreferenceChangedNotification {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)BBMPLUS_PREFS_NOTIFICATION, NULL, NULL, YES);
}

- (id)readPreferenceValue:(PSSpecifier *)specifier {
	NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:BBMPLUS_PREFS_FILE];

	if ( ! prefs[[specifier propertyForKey:@"key"]]) {
		return [specifier propertyForKey:@"default"];
	}

	return prefs[[specifier propertyForKey:@"key"]];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:BBMPLUS_PREFS_FILE]];
	[defaults setObject:value forKey:[specifier properties][@"key"]];
	[defaults writeToFile:BBMPLUS_PREFS_FILE atomically:YES];
    [BBMRootListController postPreferenceChangedNotification];
}


#pragma mark - Prefs Header and Footer

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationItem setTitle:@""];
}

@end
