#import "BBM.h"


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - Constructor
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ctor {
	@autoreleasepool {
		BPLoadPreferencesAndAddChangesObserver();

		if ( ! IN_BBM || ! preferences[@"Enabled"]) {
			return;
		}

		%init;
	}
}