#include "BBMRootListController.h"

@implementation BBMRootListController

#pragma mark - Constants

-(id)init {
    self = [super init];
    if (self) {
	    preferences = [HBPreferences preferencesForIdentifier:BBMPLUS_BUNDLE_ID];
    }
    return self;
}

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

// - (id)readPreferenceValue:(PSSpecifier *)specifier {
//     return [preferences objectForKey:[specifier identifier]];
// }

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
	//[super setPreferenceValue:value specifier:specifier];
    [preferences setObject:value forKey:[specifier propertyForKey:@"key"]];
    [preferences synchronize];
}


#pragma mark - Prefs Header and Footer

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationItem setTitle:@""];
}

@end
