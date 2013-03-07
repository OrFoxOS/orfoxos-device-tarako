
PRODUCT_PACKAGES := \
	rild_sp \
	libril_sp \
	libreference-ril_sp \
	sprd_monitor \
	phoneserver \
	phoneserver_2sim


ifneq ($(shell ls  vendor/sprd/proprietories/ss7710g/prop.list 2>/dev/null),)
# for spreadtrum internal proprietories modules: only support package module names

OPENCORE :=  libopencore_common libomx_sharedlibrary libomx_m4vdec_sharedlibrary libomx_m4venc_sharedlibrary \
	libomx_avcdec_sharedlibrary pvplayer.cfg

PRODUCT_PACKAGES += \
	$(OPENCORE)

else

# for spreadtrum customer proprietories modules: only support direct copy

PROPMODS := \
	system/lib/libopencore_common.so \
	system/lib/libomx_sharedlibrary.so \
	system/lib/libomx_m4vdec_sharedlibrary.so \
	system/lib/libomx_m4venc_sharedlibrary.so \
	system/lib/libomx_avcdec_sharedlibrary.so \
	system/etc/pvplayer.cfg

PRODUCT_COPY_FILES := $(foreach f,$(PROPMODS),vendor/sprd/proprietories/ss7710g/$(f):$(f))

endif
