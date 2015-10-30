#import "BBM.h"


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Constructor
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ctor {
	@autoreleasepool {
		HBPreferences* preferences = [HBPreferences preferencesForIdentifier:BBMPLUS_BUNDLE_ID];

		// Register defaults
		[preferences registerBool:&bbmplusEnabled default:YES forKey:@"Enabled"];

		if (bbmplusEnabled) {
			%init;
			HBLogDebug(@"Initialized: %@", BBMPLUS_BUNDLE_ID);
		}
	}
}