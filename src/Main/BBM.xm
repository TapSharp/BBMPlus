#import "BBM.h"


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Constructor
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ctor {
	@autoreleasepool {
		BPLoadPreferencesAndAddChangesObserver();

		if (BPInBBMApplication && preferences[@"Enabled"]) {
			%init;
		}
	}
}