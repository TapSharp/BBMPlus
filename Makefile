TWEAK_NAME = bbmplus
BUNDLE_NAME = bbmplusprefs

bbmplus_FILES  = $(wildcard src/Main/*.xm)
bbmplus_LIBRARIES = cephei
bbmplus_PRIVATE_FRAMEWORKS = CoreLocation

bbmplusprefs_FILES = $(wildcard src/Preferences/*.m)
bbmplusprefs_INSTALL_PATH = /Library/PreferenceBundles
bbmplusprefs_FRAMEWORKS = UIKit QuartzCore CoreGraphics
bbmplusprefs_PRIVATE_FRAMEWORKS = Preferences
bbmplusprefs_LIBRARIES = cephei cepheiprefs
bbmplusprefs_RESOURCE_DIRS = resources

export ARCHS = armv7 arm64
export TARGET = iphone:clang:latest:latest
export THEOS_DEVICE_IP=iphone
export THEOS_DEVICE_PORT=22

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp bbmplusprefs.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/bbmplus.plist$(ECHO_END)
	@(echo "Generating localization resources..."; i18n/generate.sh "$(THEOS_STAGING_DIR)/Library/PreferenceBundles/bbmplusprefs.bundle/")
