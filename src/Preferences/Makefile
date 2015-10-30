BUNDLE_NAME = bbmplus

bbmplus_FILES = $(wildcard *.m)
bbmplus_INSTALL_PATH = /Library/PreferenceBundles
bbmplus_FRAMEWORKS = UIKit
bbmplus_PRIVATE_FRAMEWORKS = Preferences
bbmplus_LIBRARIES = cepheiprefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/bbmplus.plist$(ECHO_END)
