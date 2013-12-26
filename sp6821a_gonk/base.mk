
MALI := libUMP libEGL_mali.so libGLESv1_CM_mali.so libGLESv2_mali.so libMali.so ump.ko mali.ko



SPRD_FM_APP := FMPlayer

BRCM_FM := \
    fm.$(TARGET_PLATFORM) \
    FmDaemon \
    FmTest

#FFOS specific macros, may move into a new file someday
ENABLE_LIBRECOVERY := true
PRODUCT_PROPERTY_OVERRIDES := \
	ro.moz.omx.hw.max_width=720 \
	ro.moz.omx.hw.max_height=576 \
	ro.moz.ril.query_icc_count=true \
	ro.moz.mute.call.to_ril=true \
	ro.moz.ril.numclients=2 \
	ro.moz.ril.data_reg_on_demand=true


# original apps copied from generic_no_telephony.mk
PRODUCT_PACKAGES := \
	librecovery \
	charge \
	vcharged \
	poweroff_alarm \
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
	audio.a2dp.default \
	hostapd \
	wpa_supplicant.conf \
	hciconfig \
	hcitool \
	hcidump \
	bttest\
	calibration_init \
	rawdatad \
	nvm_daemon \
	modemd \
	usbmond \
	mfserial

# own copyright packages files
PRODUCT_PACKAGES += \
    AppBackup \
    AudioProfile \
    SprdNote \
    CallFireWall \
    ValidationTools \
    libvalidationtoolsjni \
    libstagefright_soft_mpeg4dec_sprd \
    libstagefright_soft_h264dec_sprd

# prebuild files
#PRODUCT_PACKAGES += \
#    ES_File_Explorer.apk

PRODUCT_PACKAGES += \
	gralloc.$(TARGET_PLATFORM) \
	hwcomposer.$(TARGET_PLATFORM) \
	camera.$(TARGET_PLATFORM) \
	lights.$(TARGET_PLATFORM) \
	audio.primary.$(TARGET_PLATFORM) \
	audio_policy.$(TARGET_PLATFORM) \
	tinymix \
	sensors.$(TARGET_BOARD)  \
	$(MALI)\
	zram.sh\
	modem_control

PRODUCT_PACKAGES += \
            $(BRCM_FM) \
            $(SPRD_FM_APP)
PRODUCT_COPY_FILES := \
	$(BOARDDIR)/init.rc:root/init.rc \
	$(BOARDDIR)/init.sp8810.rc:root/init.sp8810.rc \
	$(BOARDDIR)/init.sp8810.usb.rc:root/init.sp8810.usb.rc \
	$(BOARDDIR)/ueventd.sp8810.rc:root/ueventd.sp8810.rc \
	$(BOARDDIR)/fstab.sp8810:root/fstab.sp8810 \
	$(BOARDDIR)/vold.fstab:system/etc/vold.fstab \
        $(BOARDDIR)/hw_params/tiny_hw.xml:system/etc/tiny_hw.xml \
        $(BOARDDIR)/hw_params/codec_pga.xml:system/etc/codec_pga.xml \
        $(BOARDDIR)/hw_params/audio_para:system/etc/audio_para \
	$(BOARDDIR)/scripts/ext_symlink.sh:system/bin/ext_symlink.sh \
	$(BOARDDIR)/scripts/ext_data.sh:system/bin/ext_data.sh \
	$(BOARDDIR)/scripts/ext_kill.sh:system/bin/ext_kill.sh \
	$(BOARDDIR)/scripts/ext_chown.sh:system/bin/ext_chown.sh \
	device/sprd/common/libs/mali/egl.cfg:system/lib/egl/egl.cfg \
	device/sprd/common/libs/audio/audio_policy.conf:system/etc/audio_policy.conf \
	device/sprd/common/res/media/media_codecs.xml:system/etc/media_codecs.xml \
	device/sprd/common/res/media/media_profiles.xml:system/etc/media_profiles.xml \
	device/sprd/common/res/apn/apns-conf.xml:system/etc/apns-conf.xml \
	frameworks/base/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
	frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml

$(call inherit-product, $(BOARDDIR)/../common/apps/engineeringmodel/module.mk)
BOARD_WLAN_DEVICE_REV       := bcm4330_b1
$(call inherit-product, hardware/broadcom/wlan/bcmdhd/firmware/bcm4330/device-bcm.mk)

