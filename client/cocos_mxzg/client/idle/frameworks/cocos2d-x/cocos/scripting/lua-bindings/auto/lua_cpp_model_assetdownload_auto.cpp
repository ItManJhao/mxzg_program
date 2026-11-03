#include "scripting/lua-bindings/auto/lua_cpp_model_assetdownload_auto.hpp"
#include "../../../../../runtime-src/Classes/Model/AssetDownload.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_model_assetdownload_AssetDownload_getCurDownloadFile(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_getCurDownloadFile'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_getCurDownloadFile'", nullptr);
            return 0;
        }
        std::string ret = cobj->getCurDownloadFile();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:getCurDownloadFile",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_getCurDownloadFile'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_getMd5(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_getMd5'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_getMd5'", nullptr);
            return 0;
        }
        std::string ret = cobj->getMd5();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:getMd5",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_getMd5'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_basename(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_basename'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "AssetDownload:basename");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_basename'", nullptr);
            return 0;
        }
        std::string ret = cobj->basename(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:basename",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_basename'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_getDownloadStatus(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_getDownloadStatus'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_getDownloadStatus'", nullptr);
            return 0;
        }
        int ret = (int)cobj->getDownloadStatus();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:getDownloadStatus",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_getDownloadStatus'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_setNowUploaded(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_setNowUploaded'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "AssetDownload:setNowUploaded");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_setNowUploaded'", nullptr);
            return 0;
        }
        cobj->setNowUploaded(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:setNowUploaded",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_setNowUploaded'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_getTotalUpload(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_getTotalUpload'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_getTotalUpload'", nullptr);
            return 0;
        }
        double ret = cobj->getTotalUpload();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:getTotalUpload",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_getTotalUpload'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_stopDownload(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_stopDownload'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_stopDownload'", nullptr);
            return 0;
        }
        cobj->stopDownload();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:stopDownload",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_stopDownload'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_download(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_download'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        std::string arg0;
        std::string arg1;
        bool arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "AssetDownload:download");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "AssetDownload:download");

        ok &= luaval_to_boolean(tolua_S, 4,&arg2, "AssetDownload:download");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_download'", nullptr);
            return 0;
        }
        int ret = cobj->download(arg0, arg1, arg2);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:download",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_download'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_getNowUploaded(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_getNowUploaded'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_getNowUploaded'", nullptr);
            return 0;
        }
        double ret = cobj->getNowUploaded();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:getNowUploaded",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_getNowUploaded'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_startDownload(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_startDownload'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_startDownload'", nullptr);
            return 0;
        }
        cobj->startDownload();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:startDownload",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_startDownload'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_setSaveFile(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_setSaveFile'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "AssetDownload:setSaveFile");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_setSaveFile'", nullptr);
            return 0;
        }
        cobj->setSaveFile(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:setSaveFile",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_setSaveFile'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_setDownloadStatus(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_setDownloadStatus'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        ADL_STATUS arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "AssetDownload:setDownloadStatus");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_setDownloadStatus'", nullptr);
            return 0;
        }
        cobj->setDownloadStatus(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:setDownloadStatus",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_setDownloadStatus'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_setIsStop(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_setIsStop'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "AssetDownload:setIsStop");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_setIsStop'", nullptr);
            return 0;
        }
        cobj->setIsStop(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:setIsStop",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_setIsStop'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_setDecompressStatus(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_setDecompressStatus'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        ADL_STATUS arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "AssetDownload:setDecompressStatus");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_setDecompressStatus'", nullptr);
            return 0;
        }
        cobj->setDecompressStatus(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:setDecompressStatus",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_setDecompressStatus'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_decompressAsyn(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_decompressAsyn'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_decompressAsyn'", nullptr);
            return 0;
        }
        cobj->decompressAsyn();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:decompressAsyn",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_decompressAsyn'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_destroy(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_destroy'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_destroy'", nullptr);
            return 0;
        }
        cobj->destroy();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:destroy",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_destroy'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_setMd5(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_setMd5'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "AssetDownload:setMd5");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_setMd5'", nullptr);
            return 0;
        }
        cobj->setMd5(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:setMd5",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_setMd5'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_urlProgress(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_urlProgress'", nullptr);
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

        ok &= luaval_to_number(tolua_S, 2,&arg0, "AssetDownload:urlProgress");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "AssetDownload:urlProgress");

        ok &= luaval_to_number(tolua_S, 4,&arg2, "AssetDownload:urlProgress");

        ok &= luaval_to_number(tolua_S, 5,&arg3, "AssetDownload:urlProgress");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_urlProgress'", nullptr);
            return 0;
        }
        int ret = cobj->urlProgress(arg0, arg1, arg2, arg3);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:urlProgress",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_urlProgress'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_getUrl(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_getUrl'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_getUrl'", nullptr);
            return 0;
        }
        std::string ret = cobj->getUrl();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:getUrl",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_getUrl'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_getDecompressStatus(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_getDecompressStatus'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_getDecompressStatus'", nullptr);
            return 0;
        }
        int ret = (int)cobj->getDecompressStatus();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:getDecompressStatus",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_getDecompressStatus'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_setUrl(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_setUrl'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "AssetDownload:setUrl");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_setUrl'", nullptr);
            return 0;
        }
        cobj->setUrl(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:setUrl",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_setUrl'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_decompress(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_decompress'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "AssetDownload:decompress");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_decompress'", nullptr);
            return 0;
        }
        bool ret = cobj->decompress(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:decompress",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_decompress'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_getDecompressFile(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_getDecompressFile'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_getDecompressFile'", nullptr);
            return 0;
        }
        std::string ret = cobj->getDecompressFile();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:getDecompressFile",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_getDecompressFile'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_downloadByURL(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_downloadByURL'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        std::string arg0;
        std::string arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "AssetDownload:downloadByURL");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "AssetDownload:downloadByURL");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_downloadByURL'", nullptr);
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

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "AssetDownload:downloadByURL");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "AssetDownload:downloadByURL");

        ok &= luaval_to_boolean(tolua_S, 4,&arg2, "AssetDownload:downloadByURL");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_downloadByURL'", nullptr);
            return 0;
        }
        cobj->downloadByURL(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:downloadByURL",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_downloadByURL'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_setIsDecompress(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_setIsDecompress'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "AssetDownload:setIsDecompress");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_setIsDecompress'", nullptr);
            return 0;
        }
        cobj->setIsDecompress(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:setIsDecompress",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_setIsDecompress'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_setNowDownloaded(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_setNowDownloaded'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "AssetDownload:setNowDownloaded");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_setNowDownloaded'", nullptr);
            return 0;
        }
        cobj->setNowDownloaded(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:setNowDownloaded",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_setNowDownloaded'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_getSaveFile(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_getSaveFile'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_getSaveFile'", nullptr);
            return 0;
        }
        std::string ret = cobj->getSaveFile();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:getSaveFile",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_getSaveFile'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_getNowDownloaded(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_getNowDownloaded'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_getNowDownloaded'", nullptr);
            return 0;
        }
        double ret = cobj->getNowDownloaded();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:getNowDownloaded",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_getNowDownloaded'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_getTotalDownload(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_getTotalDownload'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_getTotalDownload'", nullptr);
            return 0;
        }
        double ret = cobj->getTotalDownload();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:getTotalDownload",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_getTotalDownload'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_setCurDownloadFile(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_setCurDownloadFile'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "AssetDownload:setCurDownloadFile");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_setCurDownloadFile'", nullptr);
            return 0;
        }
        cobj->setCurDownloadFile(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:setCurDownloadFile",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_setCurDownloadFile'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_getIsDecompress(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_getIsDecompress'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_getIsDecompress'", nullptr);
            return 0;
        }
        bool ret = cobj->getIsDecompress();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:getIsDecompress",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_getIsDecompress'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_setDecompressFile(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_setDecompressFile'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "AssetDownload:setDecompressFile");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_setDecompressFile'", nullptr);
            return 0;
        }
        cobj->setDecompressFile(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:setDecompressFile",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_setDecompressFile'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_setTotalUpload(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_setTotalUpload'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "AssetDownload:setTotalUpload");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_setTotalUpload'", nullptr);
            return 0;
        }
        cobj->setTotalUpload(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:setTotalUpload",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_setTotalUpload'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_getIsStop(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_getIsStop'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_getIsStop'", nullptr);
            return 0;
        }
        bool ret = cobj->getIsStop();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:getIsStop",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_getIsStop'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_setTotalDownload(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (AssetDownload*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_assetdownload_AssetDownload_setTotalDownload'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "AssetDownload:setTotalDownload");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_setTotalDownload'", nullptr);
            return 0;
        }
        cobj->setTotalDownload(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:setTotalDownload",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_setTotalDownload'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_instance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"AssetDownload",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_instance'", nullptr);
            return 0;
        }
        AssetDownload* ret = AssetDownload::instance();
        object_to_luaval<AssetDownload>(tolua_S, "AssetDownload",(AssetDownload*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "AssetDownload:instance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_instance'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_assetdownload_AssetDownload_constructor(lua_State* tolua_S)
{
    int argc = 0;
    AssetDownload* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_assetdownload_AssetDownload_constructor'", nullptr);
            return 0;
        }
        cobj = new AssetDownload();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"AssetDownload");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "AssetDownload:AssetDownload",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_assetdownload_AssetDownload_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_model_assetdownload_AssetDownload_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (AssetDownload)");
    return 0;
}

int lua_register_cpp_model_assetdownload_AssetDownload(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"AssetDownload");
    tolua_cclass(tolua_S,"AssetDownload","AssetDownload","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"AssetDownload");
        tolua_function(tolua_S,"new",lua_cpp_model_assetdownload_AssetDownload_constructor);
        tolua_function(tolua_S,"getCurDownloadFile",lua_cpp_model_assetdownload_AssetDownload_getCurDownloadFile);
        tolua_function(tolua_S,"getMd5",lua_cpp_model_assetdownload_AssetDownload_getMd5);
        tolua_function(tolua_S,"basename",lua_cpp_model_assetdownload_AssetDownload_basename);
        tolua_function(tolua_S,"getDownloadStatus",lua_cpp_model_assetdownload_AssetDownload_getDownloadStatus);
        tolua_function(tolua_S,"setNowUploaded",lua_cpp_model_assetdownload_AssetDownload_setNowUploaded);
        tolua_function(tolua_S,"getTotalUpload",lua_cpp_model_assetdownload_AssetDownload_getTotalUpload);
        tolua_function(tolua_S,"stopDownload",lua_cpp_model_assetdownload_AssetDownload_stopDownload);
        tolua_function(tolua_S,"download",lua_cpp_model_assetdownload_AssetDownload_download);
        tolua_function(tolua_S,"getNowUploaded",lua_cpp_model_assetdownload_AssetDownload_getNowUploaded);
        tolua_function(tolua_S,"startDownload",lua_cpp_model_assetdownload_AssetDownload_startDownload);
        tolua_function(tolua_S,"setSaveFile",lua_cpp_model_assetdownload_AssetDownload_setSaveFile);
        tolua_function(tolua_S,"setDownloadStatus",lua_cpp_model_assetdownload_AssetDownload_setDownloadStatus);
        tolua_function(tolua_S,"setIsStop",lua_cpp_model_assetdownload_AssetDownload_setIsStop);
        tolua_function(tolua_S,"setDecompressStatus",lua_cpp_model_assetdownload_AssetDownload_setDecompressStatus);
        tolua_function(tolua_S,"decompressAsyn",lua_cpp_model_assetdownload_AssetDownload_decompressAsyn);
        tolua_function(tolua_S,"destroy",lua_cpp_model_assetdownload_AssetDownload_destroy);
        tolua_function(tolua_S,"setMd5",lua_cpp_model_assetdownload_AssetDownload_setMd5);
        tolua_function(tolua_S,"urlProgress",lua_cpp_model_assetdownload_AssetDownload_urlProgress);
        tolua_function(tolua_S,"getUrl",lua_cpp_model_assetdownload_AssetDownload_getUrl);
        tolua_function(tolua_S,"getDecompressStatus",lua_cpp_model_assetdownload_AssetDownload_getDecompressStatus);
        tolua_function(tolua_S,"setUrl",lua_cpp_model_assetdownload_AssetDownload_setUrl);
        tolua_function(tolua_S,"decompress",lua_cpp_model_assetdownload_AssetDownload_decompress);
        tolua_function(tolua_S,"getDecompressFile",lua_cpp_model_assetdownload_AssetDownload_getDecompressFile);
        tolua_function(tolua_S,"downloadByURL",lua_cpp_model_assetdownload_AssetDownload_downloadByURL);
        tolua_function(tolua_S,"setIsDecompress",lua_cpp_model_assetdownload_AssetDownload_setIsDecompress);
        tolua_function(tolua_S,"setNowDownloaded",lua_cpp_model_assetdownload_AssetDownload_setNowDownloaded);
        tolua_function(tolua_S,"getSaveFile",lua_cpp_model_assetdownload_AssetDownload_getSaveFile);
        tolua_function(tolua_S,"getNowDownloaded",lua_cpp_model_assetdownload_AssetDownload_getNowDownloaded);
        tolua_function(tolua_S,"getTotalDownload",lua_cpp_model_assetdownload_AssetDownload_getTotalDownload);
        tolua_function(tolua_S,"setCurDownloadFile",lua_cpp_model_assetdownload_AssetDownload_setCurDownloadFile);
        tolua_function(tolua_S,"getIsDecompress",lua_cpp_model_assetdownload_AssetDownload_getIsDecompress);
        tolua_function(tolua_S,"setDecompressFile",lua_cpp_model_assetdownload_AssetDownload_setDecompressFile);
        tolua_function(tolua_S,"setTotalUpload",lua_cpp_model_assetdownload_AssetDownload_setTotalUpload);
        tolua_function(tolua_S,"getIsStop",lua_cpp_model_assetdownload_AssetDownload_getIsStop);
        tolua_function(tolua_S,"setTotalDownload",lua_cpp_model_assetdownload_AssetDownload_setTotalDownload);
        tolua_function(tolua_S,"instance", lua_cpp_model_assetdownload_AssetDownload_instance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(AssetDownload).name();
    g_luaType[typeName] = "AssetDownload";
    g_typeCast["AssetDownload"] = "AssetDownload";
    return 1;
}
TOLUA_API int register_all_cpp_model_assetdownload(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_model_assetdownload_AssetDownload(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

