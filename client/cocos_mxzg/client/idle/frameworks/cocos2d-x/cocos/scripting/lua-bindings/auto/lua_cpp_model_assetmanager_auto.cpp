#include "scripting/lua-bindings/auto/lua_cpp_model_assetmanager_auto.hpp"
#include "../../../../../runtime-src/Classes/Model/AssetManager.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_model_assetmanager_AssetManager_setMaxDownloadSpeed(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_setMaxDownloadSpeed'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        long arg0;

        ok &= luaval_to_long(tolua_S, 2, &arg0, "AssetManager:setMaxDownloadSpeed");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_setMaxDownloadSpeed'", nullptr);
            return 0;
        }
        cobj->setMaxDownloadSpeed(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:setMaxDownloadSpeed",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_setMaxDownloadSpeed'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_getDownloadProgress(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_getDownloadProgress'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_getDownloadProgress'", nullptr);
            return 0;
        }
        int ret = cobj->getDownloadProgress();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:getDownloadProgress",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_getDownloadProgress'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_getDownloadStatus(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_getDownloadStatus'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_getDownloadStatus'", nullptr);
            return 0;
        }
        int ret = (int)cobj->getDownloadStatus();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:getDownloadStatus",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_getDownloadStatus'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_downloadByURL(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_downloadByURL'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        std::string arg0;
        std::string arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "AssetManager:downloadByURL");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "AssetManager:downloadByURL");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_downloadByURL'", nullptr);
            return 0;
        }
        cobj->downloadByURL(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 3) 
    {
        std::string arg0;
        std::string arg1;
        bool arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "AssetManager:downloadByURL");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "AssetManager:downloadByURL");

        ok &= luaval_to_boolean(tolua_S, 4,&arg2, "AssetManager:downloadByURL");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_downloadByURL'", nullptr);
            return 0;
        }
        cobj->downloadByURL(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:downloadByURL",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_downloadByURL'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_getDecompressFileCount(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_getDecompressFileCount'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_getDecompressFileCount'", nullptr);
            return 0;
        }
        int ret = cobj->getDecompressFileCount();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:getDecompressFileCount",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_getDecompressFileCount'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_stopDownload(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_stopDownload'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_stopDownload'", nullptr);
            return 0;
        }
        cobj->stopDownload();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:stopDownload",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_stopDownload'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_getConnectTimeOut(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_getConnectTimeOut'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_getConnectTimeOut'", nullptr);
            return 0;
        }
        int ret = cobj->getConnectTimeOut();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:getConnectTimeOut",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_getConnectTimeOut'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_getDownLoadSize(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_getDownLoadSize'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_getDownLoadSize'", nullptr);
            return 0;
        }
        long long ret = cobj->getDownLoadSize();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:getDownLoadSize",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_getDownLoadSize'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_startDownload(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_startDownload'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_startDownload'", nullptr);
            return 0;
        }
        cobj->startDownload();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:startDownload",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_startDownload'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_setWiFiTip(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_setWiFiTip'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "AssetManager:setWiFiTip");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_setWiFiTip'", nullptr);
            return 0;
        }
        cobj->setWiFiTip(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:setWiFiTip",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_setWiFiTip'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_isDownLoading(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_isDownLoading'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_isDownLoading'", nullptr);
            return 0;
        }
        bool ret = cobj->isDownLoading();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:isDownLoading",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_isDownLoading'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_getDownLoadLenght(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_getDownLoadLenght'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_getDownLoadLenght'", nullptr);
            return 0;
        }
        long long ret = cobj->getDownLoadLenght();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:getDownLoadLenght",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_getDownLoadLenght'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_setDownloadTimeOut(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_setDownloadTimeOut'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "AssetManager:setDownloadTimeOut");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_setDownloadTimeOut'", nullptr);
            return 0;
        }
        cobj->setDownloadTimeOut(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:setDownloadTimeOut",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_setDownloadTimeOut'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_setWiFiTipSize(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_setWiFiTipSize'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        long long arg0;

        ok &= luaval_to_long_long(tolua_S, 2,&arg0, "AssetManager:setWiFiTipSize");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_setWiFiTipSize'", nullptr);
            return 0;
        }
        cobj->setWiFiTipSize(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:setWiFiTipSize",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_setWiFiTipSize'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_destroy(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_destroy'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_destroy'", nullptr);
            return 0;
        }
        cobj->destroy();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:destroy",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_destroy'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_setVersionFile(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_setVersionFile'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "AssetManager:setVersionFile");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_setVersionFile'", nullptr);
            return 0;
        }
        cobj->setVersionFile(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:setVersionFile",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_setVersionFile'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_checkVersion(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_checkVersion'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_checkVersion'", nullptr);
            return 0;
        }
        cobj->checkVersion();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:checkVersion",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_checkVersion'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_getDownloadPackageURL(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_getDownloadPackageURL'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "AssetManager:getDownloadPackageURL");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_getDownloadPackageURL'", nullptr);
            return 0;
        }
        std::string ret = cobj->getDownloadPackageURL(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:getDownloadPackageURL",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_getDownloadPackageURL'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_hasDownloadFile(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_hasDownloadFile'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_hasDownloadFile'", nullptr);
            return 0;
        }
        std::string ret = cobj->hasDownloadFile();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:hasDownloadFile",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_hasDownloadFile'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_decompressDownloadedZip(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_decompressDownloadedZip'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_decompressDownloadedZip'", nullptr);
            return 0;
        }
        cobj->decompressDownloadedZip();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:decompressDownloadedZip",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_decompressDownloadedZip'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_setConnectTimeOut(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_setConnectTimeOut'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "AssetManager:setConnectTimeOut");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_setConnectTimeOut'", nullptr);
            return 0;
        }
        cobj->setConnectTimeOut(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:setConnectTimeOut",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_setConnectTimeOut'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_isNeedDownLoad(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_isNeedDownLoad'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_isNeedDownLoad'", nullptr);
            return 0;
        }
        bool ret = cobj->isNeedDownLoad();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:isNeedDownLoad",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_isNeedDownLoad'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_getDownloadFileFileCount(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_getDownloadFileFileCount'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_getDownloadFileFileCount'", nullptr);
            return 0;
        }
        int ret = cobj->getDownloadFileFileCount();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:getDownloadFileFileCount",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_getDownloadFileFileCount'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_isUpdatedMainAsset(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_isUpdatedMainAsset'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_isUpdatedMainAsset'", nullptr);
            return 0;
        }
        bool ret = cobj->isUpdatedMainAsset();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:isUpdatedMainAsset",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_isUpdatedMainAsset'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_urlProgress(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_urlProgress'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        double arg0;
        double arg1;
        double arg2;
        double arg3;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "AssetManager:urlProgress");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "AssetManager:urlProgress");

        ok &= luaval_to_number(tolua_S, 4,&arg2, "AssetManager:urlProgress");

        ok &= luaval_to_number(tolua_S, 5,&arg3, "AssetManager:urlProgress");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_urlProgress'", nullptr);
            return 0;
        }
        int ret = cobj->urlProgress(arg0, arg1, arg2, arg3);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:urlProgress",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_urlProgress'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_getDownloadTimeOut(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetmanager_AssetManager_getDownloadTimeOut'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_getDownloadTimeOut'", nullptr);
            return 0;
        }
        int ret = cobj->getDownloadTimeOut();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:getDownloadTimeOut",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_getDownloadTimeOut'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_instance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_instance'", nullptr);
            return 0;
        }
        AssetManager* ret = AssetManager::instance();
        object_to_luaval<AssetManager>(tolua_S, "AssetManager",(AssetManager*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AssetManager:instance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_instance'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_unzip(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 4)
    {
        const char* arg0;
        const char* arg1;
        const char* arg2;
        bool arg3;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "AssetManager:unzip"); arg0 = arg0_tmp.c_str();
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "AssetManager:unzip"); arg1 = arg1_tmp.c_str();
        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "AssetManager:unzip"); arg2 = arg2_tmp.c_str();
        ok &= luaval_to_boolean(tolua_S, 5,&arg3, "AssetManager:unzip");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_unzip'", nullptr);
            return 0;
        }
        int ret = AssetManager::unzip(arg0, arg1, arg2, arg3);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AssetManager:unzip",argc, 4);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_unzip'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_test_encrypt(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_test_encrypt'", nullptr);
            return 0;
        }
        AssetManager::test_encrypt();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AssetManager:test_encrypt",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_test_encrypt'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_getDownloadUrl(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AssetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_getDownloadUrl'", nullptr);
            return 0;
        }
        std::string ret = AssetManager::getDownloadUrl();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AssetManager:getDownloadUrl",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_getDownloadUrl'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_assetmanager_AssetManager_constructor(lua_State* tolua_S)
{
    int argc = 0;
    AssetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetmanager_AssetManager_constructor'", nullptr);
            return 0;
        }
        cobj = new AssetManager();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"AssetManager");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetManager:AssetManager",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetmanager_AssetManager_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_model_assetmanager_AssetManager_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (AssetManager)");
    return 0;
}

int lua_register_cpp_model_assetmanager_AssetManager(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"AssetManager");
    tolua_cclass(tolua_S,"AssetManager","AssetManager","SingleInstance<AssetManager>",nullptr);

    tolua_beginmodule(tolua_S,"AssetManager");
        tolua_function(tolua_S,"new",lua_cpp_model_assetmanager_AssetManager_constructor);
        tolua_function(tolua_S,"setMaxDownloadSpeed",lua_cpp_model_assetmanager_AssetManager_setMaxDownloadSpeed);
        tolua_function(tolua_S,"getDownloadProgress",lua_cpp_model_assetmanager_AssetManager_getDownloadProgress);
        tolua_function(tolua_S,"getDownloadStatus",lua_cpp_model_assetmanager_AssetManager_getDownloadStatus);
        tolua_function(tolua_S,"downloadByURL",lua_cpp_model_assetmanager_AssetManager_downloadByURL);
        tolua_function(tolua_S,"getDecompressFileCount",lua_cpp_model_assetmanager_AssetManager_getDecompressFileCount);
        tolua_function(tolua_S,"stopDownload",lua_cpp_model_assetmanager_AssetManager_stopDownload);
        tolua_function(tolua_S,"getConnectTimeOut",lua_cpp_model_assetmanager_AssetManager_getConnectTimeOut);
        tolua_function(tolua_S,"getDownLoadSize",lua_cpp_model_assetmanager_AssetManager_getDownLoadSize);
        tolua_function(tolua_S,"startDownload",lua_cpp_model_assetmanager_AssetManager_startDownload);
        tolua_function(tolua_S,"setWiFiTip",lua_cpp_model_assetmanager_AssetManager_setWiFiTip);
        tolua_function(tolua_S,"isDownLoading",lua_cpp_model_assetmanager_AssetManager_isDownLoading);
        tolua_function(tolua_S,"getDownLoadLenght",lua_cpp_model_assetmanager_AssetManager_getDownLoadLenght);
        tolua_function(tolua_S,"setDownloadTimeOut",lua_cpp_model_assetmanager_AssetManager_setDownloadTimeOut);
        tolua_function(tolua_S,"setWiFiTipSize",lua_cpp_model_assetmanager_AssetManager_setWiFiTipSize);
        tolua_function(tolua_S,"destroy",lua_cpp_model_assetmanager_AssetManager_destroy);
        tolua_function(tolua_S,"setVersionFile",lua_cpp_model_assetmanager_AssetManager_setVersionFile);
        tolua_function(tolua_S,"checkVersion",lua_cpp_model_assetmanager_AssetManager_checkVersion);
        tolua_function(tolua_S,"getDownloadPackageURL",lua_cpp_model_assetmanager_AssetManager_getDownloadPackageURL);
        tolua_function(tolua_S,"hasDownloadFile",lua_cpp_model_assetmanager_AssetManager_hasDownloadFile);
        tolua_function(tolua_S,"decompressDownloadedZip",lua_cpp_model_assetmanager_AssetManager_decompressDownloadedZip);
        tolua_function(tolua_S,"setConnectTimeOut",lua_cpp_model_assetmanager_AssetManager_setConnectTimeOut);
        tolua_function(tolua_S,"isNeedDownLoad",lua_cpp_model_assetmanager_AssetManager_isNeedDownLoad);
        tolua_function(tolua_S,"getDownloadFileFileCount",lua_cpp_model_assetmanager_AssetManager_getDownloadFileFileCount);
        tolua_function(tolua_S,"isUpdatedMainAsset",lua_cpp_model_assetmanager_AssetManager_isUpdatedMainAsset);
        tolua_function(tolua_S,"urlProgress",lua_cpp_model_assetmanager_AssetManager_urlProgress);
        tolua_function(tolua_S,"getDownloadTimeOut",lua_cpp_model_assetmanager_AssetManager_getDownloadTimeOut);
        tolua_function(tolua_S,"instance", lua_cpp_model_assetmanager_AssetManager_instance);
        tolua_function(tolua_S,"unzip", lua_cpp_model_assetmanager_AssetManager_unzip);
        tolua_function(tolua_S,"test_encrypt", lua_cpp_model_assetmanager_AssetManager_test_encrypt);
        tolua_function(tolua_S,"getDownloadUrl", lua_cpp_model_assetmanager_AssetManager_getDownloadUrl);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(AssetManager).name();
    g_luaType[typeName] = "AssetManager";
    g_typeCast["AssetManager"] = "AssetManager";
    return 1;
}
TOLUA_API int register_all_cpp_model_assetmanager(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_model_assetmanager_AssetManager(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

