
PRODUCT_PACKAGES := \
	rild_sp \
	libril_sp \
	libreference-ril_sp \
	sprd_monitor \
	phoneserver \
	phoneserver_2sim


ifneq ($(shell ls  vendor/sprd/proprietories/sp6821a/prop.list 2>/dev/null),)
# for spreadtrum internal proprietories modules: only support package module names

#OPENCORE :=  libopencore_common libomx_sharedlibrary libomx_m4vdec_sharedlibrary libomx_m4venc_sharedlibrary \
	libomx_avcdec_sharedlibrary pvplayer.cfg

OPENMAX := libomx_m4vh263dec_hw_sprd libomx_m4vh263dec_sw_sprd libomx_m4vh263enc_hw_sprd libomx_avcdec_hw_sprd libomx_avcdec_sw_sprd \
	libstagefright_sprd_soft_mpeg4dec libstagefright_sprd_soft_h264dec

PRODUCT_PACKAGES += \
	$(OPENMAX)

else

# for spreadtrum customer proprietories modules: only support direct copy

PROPMODS := \
	system/lib/libomx_m4vh263dec_hw_sprd.so \
	system/lib/libomx_m4vh263dec_sw_sprd.so \
	system/lib/libomx_m4vh263enc_hw_sprd.so \
	system/lib/libomx_avcdec_hw_sprd.so \
	system/lib/libomx_avcdec_sw_sprd.so \
	system/lib/libstagefright_sprd_soft_mpeg4dec.so \
	system/lib/libstagefright_sprd_soft_h264dec.so

PRODUCT_COPY_FILES := $(foreach f,$(PROPMODS),vendor/sprd/proprietories/sp6821a/$(f):$(f))

endif
