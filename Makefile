TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = ru.mes.dnevnik.fgis


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AmoledDnevnik

AmoledDnevnik_FILES = Tweak.x
AmoledDnevnik_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
