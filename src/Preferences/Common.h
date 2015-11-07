#import "../Common.h"
#import <CaptainHook/CaptainHook.h>
#import <Preferences/PSSPecifier.h>
#import <Preferences/PSListController.h>

@interface PSSpecifier (Actions)
- (SEL)action;
- (void)setAction:(SEL)action;
@end

@implementation PSSpecifier (Actions)
- (SEL)action { return action; }
- (void)setAction:(SEL)a { action = a; }
@end

@interface UIImage (ImageNamed)
+ (UIImage *)imageNamed:(NSString*)arg1 inBundle:(id)arg2;
@end

CHInline int BPPSTableCellTypeFromString(NSString* str) {
    if ([str isEqual:@"PSGroupCell"])
        return PSGroupCell;
    if ([str isEqual:@"PSLinkCell"])
        return PSLinkCell;
    if ([str isEqual:@"PSLinkListCell"])
        return PSLinkListCell;
    if ([str isEqual:@"PSListItemCell"])
        return PSListItemCell;
    if ([str isEqual:@"PSTitleValueCell"])
        return PSTitleValueCell;
    if ([str isEqual:@"PSSliderCell"])
        return PSSliderCell;
    if ([str isEqual:@"PSSwitchCell"])
        return PSSwitchCell;
    if ([str isEqual:@"PSStaticTextCell"])
        return PSStaticTextCell;
    if ([str isEqual:@"PSEditTextCell"])
        return PSEditTextCell;
    if ([str isEqual:@"PSSegmentCell"])
        return PSSegmentCell;
    if ([str isEqual:@"PSGiantIconCell"])
        return PSGiantIconCell;
    if ([str isEqual:@"PSGiantCell"])
        return PSGiantCell;
    if ([str isEqual:@"PSSecureEditTextCell"])
        return PSSecureEditTextCell;
    if ([str isEqual:@"PSButtonCell"])
        return PSButtonCell;
    if ([str isEqual:@"PSEditTextViewCell"])
        return PSEditTextViewCell;

    return PSGroupCell;
}

CHInline NSArray* BPParseSpecifiersFromArray(PSListController* target, NSArray* array) {
    NSMutableArray *specifiers = [NSMutableArray array];

    for (NSDictionary* dict in array) {
        NSString* cellType = dict[@"cell"];
        PSSpecifier *spec = nil;

        if ([cellType isEqual:@"PSGroupCell"]) {
            if (dict[@"label"] != nil) {
                spec = [PSSpecifier groupSpecifierWithName:dict[@"label"]];
                [spec setProperty:dict[@"label"] forKey:@"label"];
            }
            else
                spec = [PSSpecifier emptyGroupSpecifier];

            for (NSString *key in dict) {
                [spec setProperty:dict[key] forKey:key];
            }
        }
        else {
            NSString *label = dict[@"label"] == nil ? @"" : dict[@"label"];
            Class detail = dict[@"detail"] == nil ? nil : NSClassFromString(dict[@"detail"]);
            Class edit = dict[@"edit"] == nil ? nil : NSClassFromString(dict[@"edit"]);
            SEL set = dict[@"set"] == nil ? @selector(setPreferenceValue:specifier:) : NSSelectorFromString(dict[@"set"]);
            SEL get = dict[@"get"] == nil ? @selector(readPreferenceValue:) : NSSelectorFromString(dict[@"get"]);
            SEL action = dict[@"action"] == nil ? nil : NSSelectorFromString(dict[@"action"]);
            int cell = BPPSTableCellTypeFromString(cellType);

            //HBLogDebug(@"Label: %@, Cell: %@", label, cellType);

            spec = [PSSpecifier preferenceSpecifierNamed:label target:target set:set get:get detail:detail cell:cell edit:edit];
            [spec setAction:action];
            // spec->action = action;

            if (dict[@"validTitles"] && dict[@"validValues"])
                [spec setValues:dict[@"validValues"] titles:dict[@"validTitles"]];

            for (NSString *key in dict) {
                if ([key isEqual:@"validValues"] || [key isEqual:@"validTitles"])
                    continue;

                if ([key isEqual:@"cellClass"] && dict[key] != nil) {
                    [spec setProperty:NSClassFromString(dict[key]) forKey:key];
                    continue;
                }

                [spec setProperty:dict[key] forKey:key];
            }
        }

        if (dict[@"icon"]) {
            UIImage *image = [dict[@"icon"] isKindOfClass:[UIImage class]] ? dict[@"icon"] : nil;

            if (image == nil) {
                image = [UIImage imageNamed:dict[@"icon"] inBundle:[NSBundle bundleForClass:target.class]];
            }

            // @TODO
            // if ([target respondsToSelector:@selector(iconColor)])
            //     image = [image changeImageColor:target.iconColor];
            // else if ([target respondsToSelector:@selector(tintColor)])
            //     image = [image changeImageColor:target.tintColor];

            [spec setProperty:image forKey:@"iconImage"];
        }

        if (dict[@"leftImage"]) {
            UIImage *image = [UIImage imageNamed:dict[@"leftImage"] inBundle:[NSBundle bundleForClass:target.class]];
            [spec setProperty:image forKey:@"leftImage"];
        }

        if (dict[@"rightImage"]) {
            UIImage *image = [UIImage imageNamed:dict[@"rightImage"] inBundle:[NSBundle bundleForClass:target.class]];
            [spec setProperty:image forKey:@"rightImage"];
        }

        [spec setIdentifier:(dict[@"id"] != nil ? dict[@"id"] : dict[@"label"])];
        spec.target = target;

        [specifiers addObject:spec];
    }

    return [specifiers copy];
}
