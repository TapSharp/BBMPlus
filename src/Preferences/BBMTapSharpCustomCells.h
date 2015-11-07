#import <Preferences/PSTableCell.h>

@interface UIImage (TapSharp)
+ (UIImage *)imageNamed:(NSString *)named inBundle:(NSBundle *)bundle;
@end

@interface BBMTapSharpHeaderCell : PSTableCell {
    UILabel *tweakNameLabel;
    UILabel *tweakDescriptionLabel;
}
- (NSString *) tweakName;
- (UIColor *) tweakNameColor;
- (NSString *) tweakDescription;
@end

@interface BBMTapSharpFooterCell : PSTableCell {
	UILabel* copyrightLabel;
	UIImageView* logoImageView;
}
- (NSString *) copyrightText;
@end