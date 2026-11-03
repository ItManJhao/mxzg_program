#include "scripting/lua-bindings/auto/lua_cpp_platform_socialplatform_auto.hpp"
#include "../../../../../runtime-src/Classes/Platform/SocialPlatform.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_platform_socialplatform_SocialPlatform_dz(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_dz'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_dz'", nullptr);
            return 0;
        }
        cobj->dz();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:dz",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_dz'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_setPfId(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_setPfId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "SocialPlatform:setPfId");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_setPfId'", nullptr);
            return 0;
        }
        cobj->setPfId(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:setPfId",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_setPfId'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_giftBagCallback(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_giftBagCallback'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        bool arg0;
        std::string arg1;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "SocialPlatform:giftBagCallback");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "SocialPlatform:giftBagCallback");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_giftBagCallback'", nullptr);
            return 0;
        }
        cobj->giftBagCallback(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:giftBagCallback",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_giftBagCallback'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_showUserCenter(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_showUserCenter'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_showUserCenter'", nullptr);
            return 0;
        }
        cobj->showUserCenter();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:showUserCenter",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_showUserCenter'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_initSDK(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_initSDK'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_initSDK'", nullptr);
            return 0;
        }
        cobj->initSDK();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:initSDK",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_initSDK'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_showAdCallback(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_showAdCallback'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "SocialPlatform:showAdCallback");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_showAdCallback'", nullptr);
            return 0;
        }
        cobj->showAdCallback(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:showAdCallback",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_showAdCallback'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_getServerId(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_getServerId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_getServerId'", nullptr);
            return 0;
        }
        int ret = cobj->getServerId();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:getServerId",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_getServerId'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_showCustomerService(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_showCustomerService'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_showCustomerService'", nullptr);
            return 0;
        }
        cobj->showCustomerService();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:showCustomerService",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_showCustomerService'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_setPlatform(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_setPlatform'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "SocialPlatform:setPlatform");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_setPlatform'", nullptr);
            return 0;
        }
        cobj->setPlatform(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:setPlatform",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_setPlatform'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_getPlatformUrl(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_getPlatformUrl'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        int arg0;
        std::string arg1;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "SocialPlatform:getPlatformUrl");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "SocialPlatform:getPlatformUrl");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_getPlatformUrl'", nullptr);
            return 0;
        }
        std::string ret = cobj->getPlatformUrl(arg0, arg1);
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:getPlatformUrl",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_getPlatformUrl'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_shareLink(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_shareLink'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_shareLink'", nullptr);
            return 0;
        }
        cobj->shareLink();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:shareLink",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_shareLink'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_realName(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_realName'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        int arg0;
        std::string arg1;
        int arg2;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "SocialPlatform:realName");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "SocialPlatform:realName");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "SocialPlatform:realName");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_realName'", nullptr);
            return 0;
        }
        cobj->realName(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:realName",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_realName'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_pay(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_pay'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "SocialPlatform:pay");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "SocialPlatform:pay");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "SocialPlatform:pay");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_pay'", nullptr);
            return 0;
        }
        cobj->pay(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:pay",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_pay'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_giftBag(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_giftBag'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_giftBag'", nullptr);
            return 0;
        }
        cobj->giftBag();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:giftBag",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_giftBag'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_setChannelId(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_setChannelId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "SocialPlatform:setChannelId");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_setChannelId'", nullptr);
            return 0;
        }
        cobj->setChannelId(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:setChannelId",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_setChannelId'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_discuss(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_discuss'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_discuss'", nullptr);
            return 0;
        }
        cobj->discuss();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:discuss",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_discuss'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_updateExtraData(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_updateExtraData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 12) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;
        std::string arg4;
        std::string arg5;
        std::string arg6;
        std::string arg7;
        std::string arg8;
        std::string arg9;
        std::string arg10;
        std::string arg11;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "SocialPlatform:updateExtraData");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "SocialPlatform:updateExtraData");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "SocialPlatform:updateExtraData");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "SocialPlatform:updateExtraData");

        ok &= luaval_to_std_string(tolua_S, 6,&arg4, "SocialPlatform:updateExtraData");

        ok &= luaval_to_std_string(tolua_S, 7,&arg5, "SocialPlatform:updateExtraData");

        ok &= luaval_to_std_string(tolua_S, 8,&arg6, "SocialPlatform:updateExtraData");

        ok &= luaval_to_std_string(tolua_S, 9,&arg7, "SocialPlatform:updateExtraData");

        ok &= luaval_to_std_string(tolua_S, 10,&arg8, "SocialPlatform:updateExtraData");

        ok &= luaval_to_std_string(tolua_S, 11,&arg9, "SocialPlatform:updateExtraData");

        ok &= luaval_to_std_string(tolua_S, 12,&arg10, "SocialPlatform:updateExtraData");

        ok &= luaval_to_std_string(tolua_S, 13,&arg11, "SocialPlatform:updateExtraData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_updateExtraData'", nullptr);
            return 0;
        }
        cobj->updateExtraData(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:updateExtraData",argc, 12);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_updateExtraData'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_getUserCode(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_getUserCode'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_getUserCode'", nullptr);
            return 0;
        }
        std::string ret = cobj->getUserCode();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:getUserCode",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_getUserCode'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_appDidFinishLaunchingWithOptions(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_appDidFinishLaunchingWithOptions'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        void* arg0;
        void* arg1;
        void* arg2;

        #pragma warning NO CONVERSION TO NATIVE FOR void*
		ok = false;

        #pragma warning NO CONVERSION TO NATIVE FOR void*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_appDidFinishLaunchingWithOptions'", nullptr);
            return 0;
        }
        cobj->appDidFinishLaunchingWithOptions(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:appDidFinishLaunchingWithOptions",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_appDidFinishLaunchingWithOptions'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_getChannelId(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_getChannelId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_getChannelId'", nullptr);
            return 0;
        }
        std::string ret = cobj->getChannelId();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:getChannelId",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_getChannelId'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_getPlatformId(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_getPlatformId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_getPlatformId'", nullptr);
            return 0;
        }
        std::string ret = cobj->getPlatformId();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:getPlatformId",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_getPlatformId'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_logOutCallback(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_logOutCallback'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_logOutCallback'", nullptr);
            return 0;
        }
        cobj->logOutCallback();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:logOutCallback",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_logOutCallback'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_getPfId(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_getPfId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_getPfId'", nullptr);
            return 0;
        }
        std::string ret = cobj->getPfId();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:getPfId",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_getPfId'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_getAgent(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_getAgent'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_getAgent'", nullptr);
            return 0;
        }
        std::string ret = cobj->getAgent();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:getAgent",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_getAgent'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_payConfirm(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_payConfirm'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "SocialPlatform:payConfirm");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "SocialPlatform:payConfirm");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "SocialPlatform:payConfirm");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_payConfirm'", nullptr);
            return 0;
        }
        cobj->payConfirm(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:payConfirm",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_payConfirm'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_showAd(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_showAd'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "SocialPlatform:showAd");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_showAd'", nullptr);
            return 0;
        }
        cobj->showAd(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:showAd",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_showAd'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_loginCallback(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_loginCallback'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        bool arg0;
        std::string arg1;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "SocialPlatform:loginCallback");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "SocialPlatform:loginCallback");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_loginCallback'", nullptr);
            return 0;
        }
        cobj->loginCallback(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 3) 
    {
        bool arg0;
        std::string arg1;
        std::string arg2;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "SocialPlatform:loginCallback");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "SocialPlatform:loginCallback");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "SocialPlatform:loginCallback");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_loginCallback'", nullptr);
            return 0;
        }
        cobj->loginCallback(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 4) 
    {
        bool arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "SocialPlatform:loginCallback");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "SocialPlatform:loginCallback");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "SocialPlatform:loginCallback");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "SocialPlatform:loginCallback");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_loginCallback'", nullptr);
            return 0;
        }
        cobj->loginCallback(arg0, arg1, arg2, arg3);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 5) 
    {
        bool arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;
        std::string arg4;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "SocialPlatform:loginCallback");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "SocialPlatform:loginCallback");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "SocialPlatform:loginCallback");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "SocialPlatform:loginCallback");

        ok &= luaval_to_std_string(tolua_S, 6,&arg4, "SocialPlatform:loginCallback");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_loginCallback'", nullptr);
            return 0;
        }
        cobj->loginCallback(arg0, arg1, arg2, arg3, arg4);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:loginCallback",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_loginCallback'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_payCallback(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_payCallback'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        bool arg0;
        std::string arg1;
        std::string arg2;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "SocialPlatform:payCallback");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "SocialPlatform:payCallback");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "SocialPlatform:payCallback");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_payCallback'", nullptr);
            return 0;
        }
        cobj->payCallback(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:payCallback",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_payCallback'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_isDebug(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_isDebug'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_isDebug'", nullptr);
            return 0;
        }
        bool ret = cobj->isDebug();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:isDebug",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_isDebug'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_logout(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_logout'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_logout'", nullptr);
            return 0;
        }
        cobj->logout();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:logout",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_logout'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_setPlatformUrl(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_setPlatformUrl'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        int arg0;
        std::string arg1;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "SocialPlatform:setPlatformUrl");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "SocialPlatform:setPlatformUrl");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_setPlatformUrl'", nullptr);
            return 0;
        }
        cobj->setPlatformUrl(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:setPlatformUrl",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_setPlatformUrl'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_getPlatformStr(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_getPlatformStr'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_getPlatformStr'", nullptr);
            return 0;
        }
        std::string ret = cobj->getPlatformStr();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:getPlatformStr",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_getPlatformStr'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_dzCallback(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_dzCallback'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        bool arg0;
        std::string arg1;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "SocialPlatform:dzCallback");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "SocialPlatform:dzCallback");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_dzCallback'", nullptr);
            return 0;
        }
        cobj->dzCallback(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:dzCallback",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_dzCallback'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_removeBillNoData(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_removeBillNoData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "SocialPlatform:removeBillNoData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_removeBillNoData'", nullptr);
            return 0;
        }
        cobj->removeBillNoData(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:removeBillNoData",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_removeBillNoData'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_getServerList(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_getServerList'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_getServerList'", nullptr);
            return 0;
        }
        cobj->getServerList();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:getServerList",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_getServerList'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_submitRoleInfo(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_submitRoleInfo'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "SocialPlatform:submitRoleInfo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_submitRoleInfo'", nullptr);
            return 0;
        }
        cobj->submitRoleInfo(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:submitRoleInfo",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_submitRoleInfo'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_setAgent(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_setAgent'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "SocialPlatform:setAgent");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_setAgent'", nullptr);
            return 0;
        }
        cobj->setAgent(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:setAgent",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_setAgent'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_payDone(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_payDone'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "SocialPlatform:payDone");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_payDone'", nullptr);
            return 0;
        }
        cobj->payDone(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:payDone",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_payDone'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_zhuXiao(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_zhuXiao'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_zhuXiao'", nullptr);
            return 0;
        }
        cobj->zhuXiao();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:zhuXiao",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_zhuXiao'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_getAppId(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_getAppId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_getAppId'", nullptr);
            return 0;
        }
        std::string ret = cobj->getAppId();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:getAppId",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_getAppId'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_getPackageVersion(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_getPackageVersion'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_getPackageVersion'", nullptr);
            return 0;
        }
        std::string ret = cobj->getPackageVersion();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:getPackageVersion",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_getPackageVersion'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_shareLinkCallback(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_shareLinkCallback'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        bool arg0;
        std::string arg1;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "SocialPlatform:shareLinkCallback");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "SocialPlatform:shareLinkCallback");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_shareLinkCallback'", nullptr);
            return 0;
        }
        cobj->shareLinkCallback(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:shareLinkCallback",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_shareLinkCallback'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_login(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_login'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "SocialPlatform:login");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_login'", nullptr);
            return 0;
        }
        cobj->login(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        bool arg0;
        int32_t arg1;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "SocialPlatform:login");

        ok &= luaval_to_int32(tolua_S, 3,&arg1, "SocialPlatform:login");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_login'", nullptr);
            return 0;
        }
        cobj->login(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:login",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_login'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_initPlatform(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SocialPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_platform_socialplatform_SocialPlatform_initPlatform'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_initPlatform'", nullptr);
            return 0;
        }
        cobj->initPlatform();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:initPlatform",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_initPlatform'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_instance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"SocialPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_instance'", nullptr);
            return 0;
        }
        SocialPlatform* ret = SocialPlatform::instance();
        object_to_luaval<SocialPlatform>(tolua_S, "SocialPlatform",(SocialPlatform*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "SocialPlatform:instance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_instance'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_platform_socialplatform_SocialPlatform_constructor(lua_State* tolua_S)
{
    int argc = 0;
    SocialPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_platform_socialplatform_SocialPlatform_constructor'", nullptr);
            return 0;
        }
        cobj = new SocialPlatform();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"SocialPlatform");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SocialPlatform:SocialPlatform",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_platform_socialplatform_SocialPlatform_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_platform_socialplatform_SocialPlatform_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (SocialPlatform)");
    return 0;
}

int lua_register_cpp_platform_socialplatform_SocialPlatform(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"SocialPlatform");
    tolua_cclass(tolua_S,"SocialPlatform","SocialPlatform","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"SocialPlatform");
        tolua_function(tolua_S,"new",lua_cpp_platform_socialplatform_SocialPlatform_constructor);
        tolua_function(tolua_S,"dz",lua_cpp_platform_socialplatform_SocialPlatform_dz);
        tolua_function(tolua_S,"setPfId",lua_cpp_platform_socialplatform_SocialPlatform_setPfId);
        tolua_function(tolua_S,"giftBagCallback",lua_cpp_platform_socialplatform_SocialPlatform_giftBagCallback);
        tolua_function(tolua_S,"showUserCenter",lua_cpp_platform_socialplatform_SocialPlatform_showUserCenter);
        tolua_function(tolua_S,"initSDK",lua_cpp_platform_socialplatform_SocialPlatform_initSDK);
        tolua_function(tolua_S,"showAdCallback",lua_cpp_platform_socialplatform_SocialPlatform_showAdCallback);
        tolua_function(tolua_S,"getServerId",lua_cpp_platform_socialplatform_SocialPlatform_getServerId);
        tolua_function(tolua_S,"showCustomerService",lua_cpp_platform_socialplatform_SocialPlatform_showCustomerService);
        tolua_function(tolua_S,"setPlatform",lua_cpp_platform_socialplatform_SocialPlatform_setPlatform);
        tolua_function(tolua_S,"getPlatformUrl",lua_cpp_platform_socialplatform_SocialPlatform_getPlatformUrl);
        tolua_function(tolua_S,"shareLink",lua_cpp_platform_socialplatform_SocialPlatform_shareLink);
        tolua_function(tolua_S,"realName",lua_cpp_platform_socialplatform_SocialPlatform_realName);
        tolua_function(tolua_S,"pay",lua_cpp_platform_socialplatform_SocialPlatform_pay);
        tolua_function(tolua_S,"giftBag",lua_cpp_platform_socialplatform_SocialPlatform_giftBag);
        tolua_function(tolua_S,"setChannelId",lua_cpp_platform_socialplatform_SocialPlatform_setChannelId);
        tolua_function(tolua_S,"discuss",lua_cpp_platform_socialplatform_SocialPlatform_discuss);
        tolua_function(tolua_S,"updateExtraData",lua_cpp_platform_socialplatform_SocialPlatform_updateExtraData);
        tolua_function(tolua_S,"getUserCode",lua_cpp_platform_socialplatform_SocialPlatform_getUserCode);
        tolua_function(tolua_S,"appDidFinishLaunchingWithOptions",lua_cpp_platform_socialplatform_SocialPlatform_appDidFinishLaunchingWithOptions);
        tolua_function(tolua_S,"getChannelId",lua_cpp_platform_socialplatform_SocialPlatform_getChannelId);
        tolua_function(tolua_S,"getPlatformId",lua_cpp_platform_socialplatform_SocialPlatform_getPlatformId);
        tolua_function(tolua_S,"logOutCallback",lua_cpp_platform_socialplatform_SocialPlatform_logOutCallback);
        tolua_function(tolua_S,"getPfId",lua_cpp_platform_socialplatform_SocialPlatform_getPfId);
        tolua_function(tolua_S,"getAgent",lua_cpp_platform_socialplatform_SocialPlatform_getAgent);
        tolua_function(tolua_S,"payConfirm",lua_cpp_platform_socialplatform_SocialPlatform_payConfirm);
        tolua_function(tolua_S,"showAd",lua_cpp_platform_socialplatform_SocialPlatform_showAd);
        tolua_function(tolua_S,"loginCallback",lua_cpp_platform_socialplatform_SocialPlatform_loginCallback);
        tolua_function(tolua_S,"payCallback",lua_cpp_platform_socialplatform_SocialPlatform_payCallback);
        tolua_function(tolua_S,"isDebug",lua_cpp_platform_socialplatform_SocialPlatform_isDebug);
        tolua_function(tolua_S,"logout",lua_cpp_platform_socialplatform_SocialPlatform_logout);
        tolua_function(tolua_S,"setPlatformUrl",lua_cpp_platform_socialplatform_SocialPlatform_setPlatformUrl);
        tolua_function(tolua_S,"getPlatformStr",lua_cpp_platform_socialplatform_SocialPlatform_getPlatformStr);
        tolua_function(tolua_S,"dzCallback",lua_cpp_platform_socialplatform_SocialPlatform_dzCallback);
        tolua_function(tolua_S,"removeBillNoData",lua_cpp_platform_socialplatform_SocialPlatform_removeBillNoData);
        tolua_function(tolua_S,"getServerList",lua_cpp_platform_socialplatform_SocialPlatform_getServerList);
        tolua_function(tolua_S,"submitRoleInfo",lua_cpp_platform_socialplatform_SocialPlatform_submitRoleInfo);
        tolua_function(tolua_S,"setAgent",lua_cpp_platform_socialplatform_SocialPlatform_setAgent);
        tolua_function(tolua_S,"payDone",lua_cpp_platform_socialplatform_SocialPlatform_payDone);
        tolua_function(tolua_S,"zhuXiao",lua_cpp_platform_socialplatform_SocialPlatform_zhuXiao);
        tolua_function(tolua_S,"getAppId",lua_cpp_platform_socialplatform_SocialPlatform_getAppId);
        tolua_function(tolua_S,"getPackageVersion",lua_cpp_platform_socialplatform_SocialPlatform_getPackageVersion);
        tolua_function(tolua_S,"shareLinkCallback",lua_cpp_platform_socialplatform_SocialPlatform_shareLinkCallback);
        tolua_function(tolua_S,"login",lua_cpp_platform_socialplatform_SocialPlatform_login);
        tolua_function(tolua_S,"initPlatform",lua_cpp_platform_socialplatform_SocialPlatform_initPlatform);
        tolua_function(tolua_S,"instance", lua_cpp_platform_socialplatform_SocialPlatform_instance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(SocialPlatform).name();
    g_luaType[typeName] = "SocialPlatform";
    g_typeCast["SocialPlatform"] = "SocialPlatform";
    return 1;
}
TOLUA_API int register_all_cpp_platform_socialplatform(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_platform_socialplatform_SocialPlatform(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

