#import "BPAboutListController.h"

@implementation BPAboutListController

#pragma mark - Constants

+ (NSString *)hb_supportEmailAddress {
	return @"tweaks@tapsharp.com";
}

- (NSArray *)aboutSpecifiers {
	return @[
		@{
			@"cell": @"PSGroupCell",
			@"condensed": @(NO),
			@"headerCellClass": @"HBPackageNameHeaderCell",
			@"icon": @"icon.png",
			@"packageIdentifier": BPBundleID,
			@"packageNameOverride": @"BBM+",
			@"showVersion": @(YES),
			@"showAuthor": @(NO),
		},

		@{
			@"cell": @"PSGroupCell"
		},
		@{
			@"cell": @"PSTitleValueCell",
			@"big": @(YES),
			@"cellClass": @"HBTwitterCell",
			@"height": @"62",
			@"label": @"TapSharp Interactive",
			@"user": @"TapSharp"
		},

		@{
			@"cell": @"PSGroupCell",
			@"label": @"DEVELOPER"
		},
		@{
			@"cell": @"PSTitleValueCell",
			@"cellClass": @"HBTwitterCell",
			@"label": @"Neo Ighodaro",
			@"user": @"NeoIghodaro"
		},


		@{
			@"cell": @"PSGroupCell",
			@"footerText": @"EMAIL_SUPPORT_TEXT"
		},
		@{
			@"cell": @"PSTitleValueCell",
			@"action": @"hb_sendSupportEmail",
			@"cell": @"PSButtonCell",
			@"cellClass": @"HBTintedTableCell",
			@"label": @"EMAIL_SUPPORT"
		}

	];
}

- (id)specifiers {
	if (_specifiers == nil) {
		_specifiers = BPParseSpecifiersFromArray(self, [self aboutSpecifiers]);
	}

	return _specifiers;
}

@end