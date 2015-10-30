TWEAK_NAME = bbmplus

bbmplus_FILES = $(wildcard src/*.xm)
bbmplus_FRAMEWORKS = Foundation
bbmplus_LIBRARIES = cephei

export ARCHS = armv7 arm64
export TARGET = iphone:clang

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
