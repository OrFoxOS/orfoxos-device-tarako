
# for spreadtrum internal proprietories modules: only support package module names

PRODUCT_PACKAGES := \
	rild_sp \
	libril_sp \
	libreference-ril_sp \
	sprd_monitor \
	phoneserver \
	phoneserver_2sim

# for spreadtrum customer proprietories modules: only support direct copy

PROPMODS := \
	system/lib/libopencore_common.so \
	system/lib/libomx_sharedlibrary.so \
	system/lib/libomx_m4vdec_sharedlibrary.so \
	system/lib/libomx_m4venc_sharedlibrary.so \
	system/lib/libomx_avcdec_sharedlibrary.so \
	system/etc/pvplayer.cfg \

PRODUCT_COPY_FILES := $(foreach f,$(PROPMODS),vendor/sprd/proprietories/mint/$(f):$(f))

