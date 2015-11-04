#import "BBM.h"


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Constructor
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ctor {
	@autoreleasepool {

		preferences = [HBPreferences preferencesForIdentifier:BBMPLUS_BUNDLE_ID];

		[preferences registerDefaults:@{
			@"Enabled": @YES,
			@"Hide_Read_Typing_Status": @NO,
			@"Unlimited_Pings": @NO,
			@"Hide_Screenshot_Reporting": @NO,
			@"Disable_Retraction": @NO,
			@"Timed_Message_Forever": @NO,
			@"Dark_Mode": @NO
		}];

		if ([preferences boolForKey:@"Enabled"] && IS_IN_BUNDLE(@"com.blackberry.bbm1")) {
			%init;
			HBLogDebug(@"Initialized: %@", BBMPLUS_BUNDLE_ID);
		}
	}
}