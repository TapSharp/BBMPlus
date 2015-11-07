#include "BPRootListController.h"

@implementation BPRootListController

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Constants
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

+ (NSString *)hb_shareText {
	NSString* formatString = BPLocalizedString(@"SHARE_TEXT");
	return [NSString stringWithFormat:formatString, [BPRootListController hb_shareURL]];
}

+ (NSURL *)hb_shareURL {
	return [NSURL URLWithString:@"http://repo.tapsharp.com/"];
}

+ (UIColor *)hb_tintColor {
	return BPTintColor;
}

- (NSArray *)rootSpecifiers {
	return @[

		@{
			@"cell": @"PSGroupCell",
			@"footerCellClass": @"BBMTapSharpHeaderCell"
		},

		@{
			@"cell": @"PSGroupCell",
			@"footerText": BPLocalizedString(@"GENERAL_FOOTER_TEXT"),
            @"id": @"GROUP_ENABLE_SPECIFIER"
		},
		@{
			@"cell": @"PSSwitchCell",
			@"default": @(NO),
			@"defaults": BPBundleID,
			@"enabled": @(YES),
			@"key": @"Enabled",
			@"label": BPLocalizedString(@"ENABLED"),
			@"PostNotification": BPPrefsChangedNotification
		},

		@{
			@"cell": @"PSGroupCell",
			@"label": BPLocalizedString(@"INDIVIDUAL_SETTINGS"),
			@"footerText": BPLocalizedString(@"INDIVIDUAL_SETTINGS_TEXT"),
            @"id": @"GROUP_INDIVIDUAL_SETTINGS_SPECIFIERS"
		},
        @{
            @"cell": @"PSLinkListCell",
            @"defaults": BPBundleID,
            @"default": @(NO),
            @"detail": @"HBListItemsController",
            @"key": @"Hide_Read_Typing_Status",
            @"label": BPLocalizedString(@"HIDE_READ_AND_TYPING_STATUS"),
            @"validTitles": @[ BPLocalizedString(@"ON"), BPLocalizedString(@"OFF") ],
            @"validValues": @[ @(YES), @(NO) ],
            @"PostNotification": BPPrefsChangedNotification
        },
		@{
            @"cell": @"PSLinkListCell",
            @"defaults": BPBundleID,
            @"default": @(NO),
            @"detail": @"HBListItemsController",
            @"key": @"Unlimited_Pings",
            @"label": BPLocalizedString(@"UNLIMITED_PINGS"),
            @"validTitles": @[BPLocalizedString(@"ON"), BPLocalizedString(@"OFF")],
            @"validValues": @[@(YES), @(NO)],
            @"PostNotification": BPPrefsChangedNotification,
        },
		@{
            @"cell": @"PSLinkListCell",
            @"defaults": BPBundleID,
            @"default": @(NO),
            @"detail": @"HBListItemsController",
            @"key": @"Disable_Ads",
            @"label": BPLocalizedString(@"DISABLE_ADS"),
            @"validTitles": @[BPLocalizedString(@"ON"), BPLocalizedString(@"OFF")],
            @"validValues": @[@(YES), @(NO)],
            @"PostNotification": BPPrefsChangedNotification,
        },
		@{
            @"cell": @"PSLinkListCell",
            @"defaults": BPBundleID,
            @"default": @(NO),
            @"detail": @"HBListItemsController",
            @"key": @"Hide_Screenshot_Reporting",
            @"label": BPLocalizedString(@"HIDE_SCREENSHOT_REPORT"),
            @"validTitles": @[BPLocalizedString(@"ON"), BPLocalizedString(@"OFF")],
            @"validValues": @[@(YES), @(NO)],
            @"PostNotification": BPPrefsChangedNotification,
        },
		@{
            @"cell": @"PSLinkListCell",
            @"defaults": BPBundleID,
            @"default": @(NO),
            @"detail": @"HBListItemsController",
            @"key": @"Disable_Retraction",
            @"label": BPLocalizedString(@"DISABLE_RETRACTION"),
            @"validTitles": @[BPLocalizedString(@"ON"), BPLocalizedString(@"OFF")],
            @"validValues": @[@(YES), @(NO)],
            @"PostNotification": BPPrefsChangedNotification,
        },
		@{
            @"cell": @"PSLinkListCell",
            @"defaults": BPBundleID,
            @"default": @(NO),
            @"detail": @"HBListItemsController",
            @"key": @"Timed_Message_Forever",
            @"label": BPLocalizedString(@"TIMED_MESSAGE_FOREVER"),
            @"validTitles": @[BPLocalizedString(@"ON"), BPLocalizedString(@"OFF")],
            @"validValues": @[@(YES), @(NO)],
            @"PostNotification": BPPrefsChangedNotification,
        },
		@{
            @"cell": @"PSLinkListCell",
            @"defaults": BPBundleID,
            @"default": @(NO),
            @"detail": @"HBListItemsController",
            @"key": @"Dark_Mode",
            @"enabled": @(NO),
            @"label": BPLocalizedString(@"DARK_MODE"),
            @"validTitles": @[BPLocalizedString(@"ON"), BPLocalizedString(@"OFF")],
            @"validValues": @[@(YES), @(NO)],
            @"PostNotification": BPPrefsChangedNotification,
        },

        @{
            @"cell": @"PSGroupCell",
            @"id": @"GROUP_ABOUT_SPECIFIERS"
        },
        @{
            @"cell": @"PSLinkCell",
            @"detail": @"BPAboutListController",
            @"isController": @(YES),
            @"label": BPLocalizedString(@"ABOUT")
        },

		@{
			@"cell": @"PSGroupCell",
			@"footerCellClass": @"BBMTapSharpFooterCell"
		}
	];
}

- (id)specifiers {
	if (_specifiers == nil) {
		_specifiers = BPParseSpecifiersFromArray(self, [self rootSpecifiers]);
	}

	return _specifiers;
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
	HBLogDebug(@"setPreferenceValue:%@ specifier:%@", value, specifier);
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:BPPrefsFilePath]];
	[defaults setObject:value forKey:[specifier properties][@"key"]];
	[defaults writeToFile:BPPrefsFilePath atomically:YES];
    [BPRootListController postPreferenceChangedNotification];
}


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - View events
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationItem setTitle:@""];
}

@end
