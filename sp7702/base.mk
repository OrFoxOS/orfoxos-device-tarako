
MALI := libUMP libEGL_mali.so libGLESv1_CM_mali.so libGLESv2_mali.so libMali.so ump.ko mali.ko

BRCMFM := \
	com.broadcom.bt.service \
	libfmpmservice \
	libfmservice \
	BtFmServiceReg \
	FmRadio

PRODUCT_PROPERTY_OVERRIDES :=

# original apps copied from generic_no_telephony.mk
PRODUCT_PACKAGES := \
	DeskClock \
	Bluetooth \
	Calculator \
	Calendar \
	CertInstaller \
	DrmProvider \
	Email \
	Exchange2 \
	Gallery2 \
	InputDevices \
	LatinIME \
	Launcher2 \
	Music \
	MusicFX \
	Provision \
	QuickSearchBox \
	SystemUI \
	CalendarProvider \
	bluetooth-health \
	hciconfig \
	hcitool \
	hcidump \
	FMPlayer \
	bttest\
	hostapd \
	wpa_supplicant.conf \
	audio.a2dp.default \
    SoundRecorder

PRODUCT_PACKAGES += \
	modem_control\
	nvitemd \
	charge \
	vcharged \
	modemd \
	calibration_init \
	gralloc.$(TARGET_PLATFORM) \
	hwcomposer.$(TARGET_PLATFORM) \
	camera.$(TARGET_PLATFORM) \
	lights.$(TARGET_PLATFORM) \
	audio.primary.$(TARGET_PLATFORM) \
	tinymix \
	sensors.$(TARGET_BOARD)  \
	fm.$(TARGET_PLATFORM)  \
	libmbbms_tel_jni.so\
	$(MALI)

ifeq ($(BOARD_HAVE_FM_BCM),true)
BRCMFM := \
	FmDaemon \
	FmTest

PRODUCT_PACKAGES += $(BRCMFM)
endif

ifeq ($(BOARD_CMMB_HW), mxd)
PRODUCT_PACKAGES += $(MXD_CMMB_PLAYER)
else
PRODUCT_PACKAGES += $(SIANOMTV)
endif

PRODUCT_COPY_FILES := \
	$(BOARDDIR)/init.rc:root/init.rc \
	$(BOARDDIR)/init.sp8810.rc:root/init.sp8810.rc \
	$(BOARDDIR)/init.sp8810.usb.rc:root/init.sp8810.usb.rc \
	$(BOARDDIR)/ueventd.sp8810.rc:root/ueventd.sp8810.rc \
	$(BOARDDIR)/fstab.sp8810:root/fstab.sp8810 \
	$(BOARDDIR)/vold.fstab:system/etc/vold.fstab \
	device/sprd/common/libs/audio/apm/devicevolume.xml:system/etc/devicevolume.xml \
	device/sprd/common/libs/audio/apm/formatvolume.xml:system/etc/formatvolume.xml \
        $(BOARDDIR)/hw_params/tiny_hw.xml:system/etc/tiny_hw.xml \
        $(BOARDDIR)/hw_params/codec_pga.xml:system/etc/codec_pga.xml \
        $(BOARDDIR)/hw_params/audio_para:system/etc/audio_para \
        $(BOARDDIR)/features/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
        $(BOARDDIR)/features/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
	device/sprd/common/libs/mali/egl.cfg:system/lib/egl/egl.cfg \
	device/sprd/common/libs/audio/audio_policy.conf:system/etc/audio_policy.conf \
	device/sprd/common/res/media/media_codecs.xml:system/etc/media_codecs.xml \
	device/sprd/common/res/media/media_profiles.xml:system/etc/media_profiles.xml \
	frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
	device/sprd/common/res/apn/apns-conf.xml:system/etc/apns-conf.xml

BOARD_WLAN_DEVICE_REV       := bcm4330_b2
$(call inherit-product, $(BOARDDIR)/../common/apps/engineeringmodel/module.mk)
$(call inherit-product, hardware/broadcom/wlan/bcmdhd/firmware/bcm4330/device-bcm.mk)
