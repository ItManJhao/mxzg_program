LOCAL_PATH := $(call my-dir)


# --- libBugly.so --
include $(CLEAR_VARS)
LOCAL_MODULE := bugly_native_prebuilt

LOCAL_SRC_FILES := prebuilt/$(TARGET_ARCH_ABI)/libBugly.so
include $(PREBUILT_SHARED_LIBRARY)

 # --- end --



include $(CLEAR_VARS)

LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libcocos2dlua

#traverse all the directory and subdirectory  
define walk  
  $(wildcard $(1)) $(foreach e, $(wildcard $(1)/*), $(call walk, $(e)))  
endef  
   
#traverse Classes Directory  
ALLFILES = $(call walk, $(LOCAL_PATH)/../../../Classes)
ALLFILES += $(call walk, $(LOCAL_PATH)/idle)

FILE_LIST := hellolua/main.cpp \
FILE_LIST += $(filter %.cpp, $(ALLFILES))
FILE_LIST += $(filter %.c, $(ALLFILES))


FILE_INCLUDES := $(shell find $(LOCAL_PATH)/../../../Classes -type d)
LOCAL_SRC_FILES := $(FILE_LIST:$(LOCAL_PATH)/%=%)  

LOCAL_C_INCLUDES := $(FILE_INCLUDES) \


# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END


LOCAL_STATIC_LIBRARIES := cocos2d_lua_static
LOCAL_STATIC_LIBRARIES += cocos_curl_static
LOCAL_STATIC_LIBRARIES += bugly_crashreport_cocos_static
LOCAL_STATIC_LIBRARIES += bugly_agent_cocos_static_lua

# _COCOS_LIB_ANDROID_BEGIN
# _COCOS_LIB_ANDROID_END

# change dir
include $(BUILD_SHARED_LIBRARY)
#include $(LOCAL_PATH)/../xgsdk/Android.mk
#include $(LOCAL_PATH)/../kysdk/Android.mk

$(call import-module,scripting/lua-bindings/proj.android)
$(call import-module,tools/simulator/libsimulator/proj.android)

$(call import-module,.)
$(call import-module,./curl/prebuilt/android)  
# $(call import-module,./prebuilt-mk)
$(call import-module,external/bugly)
$(call import-module,external/bugly/lua)

# _COCOS_LIB_IMPORT_ANDROID_BEGIN
# _COCOS_LIB_IMPORT_ANDROID_END
