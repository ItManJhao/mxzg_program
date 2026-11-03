#include "scripting/lua-bindings/auto/lua_cpp_model_game_auto.hpp"
#include "../../../../../runtime-src/Classes/Model/Game.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_model_game_Game_getDeviceString(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_getDeviceString'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_getDeviceString'", nullptr);
            return 0;
        }
        std::string ret = cobj->getDeviceString();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:getDeviceString",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_getDeviceString'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_getDeviceOrientation(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_getDeviceOrientation'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_getDeviceOrientation'", nullptr);
            return 0;
        }
        int ret = (int)cobj->getDeviceOrientation();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:getDeviceOrientation",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_getDeviceOrientation'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_reLogin(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_reLogin'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_reLogin'", nullptr);
            return 0;
        }
        cobj->reLogin();
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Game:reLogin");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_reLogin'", nullptr);
            return 0;
        }
        cobj->reLogin(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:reLogin",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_reLogin'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_getBundleId(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_getBundleId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_getBundleId'", nullptr);
            return 0;
        }
        std::string ret = cobj->getBundleId();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:getBundleId",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_getBundleId'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_downloadApp(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_downloadApp'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_downloadApp'", nullptr);
            return 0;
        }
        cobj->downloadApp();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:downloadApp",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_downloadApp'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_confirmDevice(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_confirmDevice'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_confirmDevice'", nullptr);
            return 0;
        }
        cobj->confirmDevice();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:confirmDevice",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_confirmDevice'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_setClipboard(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_setClipboard'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "Game:setClipboard");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_setClipboard'", nullptr);
            return 0;
        }
        cobj->setClipboard(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:setClipboard",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_setClipboard'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_getDeviceToken(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_getDeviceToken'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_getDeviceToken'", nullptr);
            return 0;
        }
        std::string ret = cobj->getDeviceToken();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:getDeviceToken",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_getDeviceToken'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_setResLogin(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_setResLogin'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_setResLogin'", nullptr);
            return 0;
        }
        cobj->setResLogin();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:setResLogin",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_setResLogin'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_updatePushId(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_updatePushId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_updatePushId'", nullptr);
            return 0;
        }
        cobj->updatePushId();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:updatePushId",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_updatePushId'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_getNetworkState(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_getNetworkState'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_getNetworkState'", nullptr);
            return 0;
        }
        int ret = cobj->getNetworkState();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:getNetworkState",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_getNetworkState'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_getCurrentLanguageCodeFull(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_getCurrentLanguageCodeFull'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_getCurrentLanguageCodeFull'", nullptr);
            return 0;
        }
        std::string ret = cobj->getCurrentLanguageCodeFull();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:getCurrentLanguageCodeFull",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_getCurrentLanguageCodeFull'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_onInconsistentData(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_onInconsistentData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_onInconsistentData'", nullptr);
            return 0;
        }
        cobj->onInconsistentData();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:onInconsistentData",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_onInconsistentData'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_getNotchHeight(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_getNotchHeight'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_getNotchHeight'", nullptr);
            return 0;
        }
        double ret = cobj->getNotchHeight();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:getNotchHeight",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_getNotchHeight'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_openURL(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_openURL'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "Game:openURL"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_openURL'", nullptr);
            return 0;
        }
        cobj->openURL(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:openURL",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_openURL'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_getEGLViewRect(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_getEGLViewRect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_getEGLViewRect'", nullptr);
            return 0;
        }
        cocos2d::Rect ret = cobj->getEGLViewRect();
        rect_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:getEGLViewRect",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_getEGLViewRect'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_updateDeviceUUID(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_updateDeviceUUID'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_updateDeviceUUID'", nullptr);
            return 0;
        }
        std::string ret = cobj->updateDeviceUUID();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:updateDeviceUUID",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_updateDeviceUUID'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_setServerTime(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_setServerTime'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        long long arg0;

        ok &= luaval_to_long_long(tolua_S, 2,&arg0, "Game:setServerTime");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_setServerTime'", nullptr);
            return 0;
        }
        cobj->setServerTime(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:setServerTime",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_setServerTime'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_getServerMillisecond(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_getServerMillisecond'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_getServerMillisecond'", nullptr);
            return 0;
        }
        long long ret = cobj->getServerMillisecond();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:getServerMillisecond",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_getServerMillisecond'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_stopCheckNetwork(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_stopCheckNetwork'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_stopCheckNetwork'", nullptr);
            return 0;
        }
        cobj->stopCheckNetwork();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:stopCheckNetwork",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_stopCheckNetwork'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_getDeviceLanguage(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_getDeviceLanguage'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_getDeviceLanguage'", nullptr);
            return 0;
        }
        std::string ret = cobj->getDeviceLanguage();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:getDeviceLanguage",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_getDeviceLanguage'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_stopTheGame(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_stopTheGame'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_stopTheGame'", nullptr);
            return 0;
        }
        cobj->stopTheGame();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:stopTheGame",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_stopTheGame'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_getServerTime(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_getServerTime'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_getServerTime'", nullptr);
            return 0;
        }
        int ret = cobj->getServerTime();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:getServerTime",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_getServerTime'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_getVersion(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_getVersion'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_getVersion'", nullptr);
            return 0;
        }
        std::string ret = cobj->getVersion();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:getVersion",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_getVersion'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_updateXingeToken(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_updateXingeToken'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "Game:updateXingeToken");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_updateXingeToken'", nullptr);
            return 0;
        }
        cobj->updateXingeToken(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:updateXingeToken",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_updateXingeToken'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_onOffline(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_onOffline'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_onOffline'", nullptr);
            return 0;
        }
        cobj->onOffline();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:onOffline",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_onOffline'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_deviceUUID(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_deviceUUID'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_deviceUUID'", nullptr);
            return 0;
        }
        std::string ret = cobj->deviceUUID();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:deviceUUID",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_deviceUUID'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_startCheckNetwork(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_startCheckNetwork'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_startCheckNetwork'", nullptr);
            return 0;
        }
        cobj->startCheckNetwork();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:startCheckNetwork",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_startCheckNetwork'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_showExitTheGame(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_showExitTheGame'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_showExitTheGame'", nullptr);
            return 0;
        }
        cobj->showExitTheGame();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:showExitTheGame",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_showExitTheGame'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_exitTheGame(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Game*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_game_Game_exitTheGame'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_exitTheGame'", nullptr);
            return 0;
        }
        cobj->exitTheGame();
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "Game:exitTheGame");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_exitTheGame'", nullptr);
            return 0;
        }
        cobj->exitTheGame(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:exitTheGame",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_exitTheGame'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_game_Game_setEffectsVisible(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        bool arg0;
        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "Game:setEffectsVisible");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_setEffectsVisible'", nullptr);
            return 0;
        }
        Game::setEffectsVisible(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:setEffectsVisible",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_setEffectsVisible'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_orientationChange(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        int arg0;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Game:orientationChange");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_orientationChange'", nullptr);
            return 0;
        }
        Game::orientationChange(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:orientationChange",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_orientationChange'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_getEffectsVolume(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_getEffectsVolume'", nullptr);
            return 0;
        }
        int ret = Game::getEffectsVolume();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:getEffectsVolume",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_getEffectsVolume'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_second(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_second'", nullptr);
            return 0;
        }
        int ret = Game::second();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:second",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_second'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_exitTheGameNoParam(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_exitTheGameNoParam'", nullptr);
            return 0;
        }
        Game::exitTheGameNoParam();
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 1)
    {
        int arg0;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Game:exitTheGameNoParam");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_exitTheGameNoParam'", nullptr);
            return 0;
        }
        Game::exitTheGameNoParam(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:exitTheGameNoParam",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_exitTheGameNoParam'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_getReverseScale(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_getReverseScale'", nullptr);
            return 0;
        }
        double ret = Game::getReverseScale();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:getReverseScale",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_getReverseScale'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_millisecond(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_millisecond'", nullptr);
            return 0;
        }
        long long ret = Game::millisecond();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:millisecond",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_millisecond'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_setBackgroundMusicVolume(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        int arg0;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Game:setBackgroundMusicVolume");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_setBackgroundMusicVolume'", nullptr);
            return 0;
        }
        Game::setBackgroundMusicVolume(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:setBackgroundMusicVolume",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_setBackgroundMusicVolume'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_shutDownKeyBoard(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_shutDownKeyBoard'", nullptr);
            return 0;
        }
        Game::shutDownKeyBoard();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:shutDownKeyBoard",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_shutDownKeyBoard'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_setBackgroundMusicVisible(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        bool arg0;
        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "Game:setBackgroundMusicVisible");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_setBackgroundMusicVisible'", nullptr);
            return 0;
        }
        Game::setBackgroundMusicVisible(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:setBackgroundMusicVisible",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_setBackgroundMusicVisible'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_stopBackgroundMusic(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_stopBackgroundMusic'", nullptr);
            return 0;
        }
        Game::stopBackgroundMusic();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:stopBackgroundMusic",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_stopBackgroundMusic'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_getBackgroundMusicVolume(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_getBackgroundMusicVolume'", nullptr);
            return 0;
        }
        int ret = Game::getBackgroundMusicVolume();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:getBackgroundMusicVolume",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_getBackgroundMusicVolume'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_instance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_instance'", nullptr);
            return 0;
        }
        Game* ret = Game::instance();
        object_to_luaval<Game>(tolua_S, "Game",(Game*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:instance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_instance'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_makeLuaId(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_makeLuaId'", nullptr);
            return 0;
        }
        std::string ret = Game::makeLuaId();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:makeLuaId",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_makeLuaId'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_getEffectsVisible(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_getEffectsVisible'", nullptr);
            return 0;
        }
        bool ret = Game::getEffectsVisible();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:getEffectsVisible",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_getEffectsVisible'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_preloadBackgroundMusic(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "Game:preloadBackgroundMusic"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_preloadBackgroundMusic'", nullptr);
            return 0;
        }
        Game::preloadBackgroundMusic(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:preloadBackgroundMusic",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_preloadBackgroundMusic'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_playBackgroundMusic(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "Game:playBackgroundMusic"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_playBackgroundMusic'", nullptr);
            return 0;
        }
        Game::playBackgroundMusic(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:playBackgroundMusic",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_playBackgroundMusic'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_sendLog(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "Game:sendLog"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_sendLog'", nullptr);
            return 0;
        }
        Game::sendLog(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:sendLog",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_sendLog'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_isKeyBoardShown(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_isKeyBoardShown'", nullptr);
            return 0;
        }
        bool ret = Game::isKeyBoardShown();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:isKeyBoardShown",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_isKeyBoardShown'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_playEffect(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "Game:playEffect"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_playEffect'", nullptr);
            return 0;
        }
        Game::playEffect(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2)
    {
        const char* arg0;
        bool arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "Game:playEffect"); arg0 = arg0_tmp.c_str();
        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "Game:playEffect");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_playEffect'", nullptr);
            return 0;
        }
        Game::playEffect(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:playEffect",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_playEffect'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_preloadEffect(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "Game:preloadEffect"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_preloadEffect'", nullptr);
            return 0;
        }
        Game::preloadEffect(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:preloadEffect",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_preloadEffect'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_getBackgroundMusicVisible(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_getBackgroundMusicVisible'", nullptr);
            return 0;
        }
        bool ret = Game::getBackgroundMusicVisible();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:getBackgroundMusicVisible",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_getBackgroundMusicVisible'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_isInVisible(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        cocos2d::Node* arg0;
        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "Game:isInVisible");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_isInVisible'", nullptr);
            return 0;
        }
        bool ret = Game::isInVisible(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:isInVisible",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_isInVisible'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_setEffectsVolume(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Game",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        int arg0;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Game:setEffectsVolume");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_setEffectsVolume'", nullptr);
            return 0;
        }
        Game::setEffectsVolume(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Game:setEffectsVolume",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_setEffectsVolume'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_game_Game_constructor(lua_State* tolua_S)
{
    int argc = 0;
    Game* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_game_Game_constructor'", nullptr);
            return 0;
        }
        cobj = new Game();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"Game");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Game:Game",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_game_Game_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_model_game_Game_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (Game)");
    return 0;
}

int lua_register_cpp_model_game_Game(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"Game");
    tolua_cclass(tolua_S,"Game","Game","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"Game");
        tolua_function(tolua_S,"new",lua_cpp_model_game_Game_constructor);
        tolua_function(tolua_S,"getDeviceString",lua_cpp_model_game_Game_getDeviceString);
        tolua_function(tolua_S,"getDeviceOrientation",lua_cpp_model_game_Game_getDeviceOrientation);
        tolua_function(tolua_S,"reLogin",lua_cpp_model_game_Game_reLogin);
        tolua_function(tolua_S,"getBundleId",lua_cpp_model_game_Game_getBundleId);
        tolua_function(tolua_S,"downloadApp",lua_cpp_model_game_Game_downloadApp);
        tolua_function(tolua_S,"confirmDevice",lua_cpp_model_game_Game_confirmDevice);
        tolua_function(tolua_S,"setClipboard",lua_cpp_model_game_Game_setClipboard);
        tolua_function(tolua_S,"getDeviceToken",lua_cpp_model_game_Game_getDeviceToken);
        tolua_function(tolua_S,"setResLogin",lua_cpp_model_game_Game_setResLogin);
        tolua_function(tolua_S,"updatePushId",lua_cpp_model_game_Game_updatePushId);
        tolua_function(tolua_S,"getNetworkState",lua_cpp_model_game_Game_getNetworkState);
        tolua_function(tolua_S,"getCurrentLanguageCodeFull",lua_cpp_model_game_Game_getCurrentLanguageCodeFull);
        tolua_function(tolua_S,"onInconsistentData",lua_cpp_model_game_Game_onInconsistentData);
        tolua_function(tolua_S,"getNotchHeight",lua_cpp_model_game_Game_getNotchHeight);
        tolua_function(tolua_S,"openURL",lua_cpp_model_game_Game_openURL);
        tolua_function(tolua_S,"getEGLViewRect",lua_cpp_model_game_Game_getEGLViewRect);
        tolua_function(tolua_S,"updateDeviceUUID",lua_cpp_model_game_Game_updateDeviceUUID);
        tolua_function(tolua_S,"setServerTime",lua_cpp_model_game_Game_setServerTime);
        tolua_function(tolua_S,"getServerMillisecond",lua_cpp_model_game_Game_getServerMillisecond);
        tolua_function(tolua_S,"stopCheckNetwork",lua_cpp_model_game_Game_stopCheckNetwork);
        tolua_function(tolua_S,"getDeviceLanguage",lua_cpp_model_game_Game_getDeviceLanguage);
        tolua_function(tolua_S,"stopTheGame",lua_cpp_model_game_Game_stopTheGame);
        tolua_function(tolua_S,"getServerTime",lua_cpp_model_game_Game_getServerTime);
        tolua_function(tolua_S,"getVersion",lua_cpp_model_game_Game_getVersion);
        tolua_function(tolua_S,"updateXingeToken",lua_cpp_model_game_Game_updateXingeToken);
        tolua_function(tolua_S,"onOffline",lua_cpp_model_game_Game_onOffline);
        tolua_function(tolua_S,"deviceUUID",lua_cpp_model_game_Game_deviceUUID);
        tolua_function(tolua_S,"startCheckNetwork",lua_cpp_model_game_Game_startCheckNetwork);
        tolua_function(tolua_S,"showExitTheGame",lua_cpp_model_game_Game_showExitTheGame);
        tolua_function(tolua_S,"exitTheGame",lua_cpp_model_game_Game_exitTheGame);
        tolua_function(tolua_S,"setEffectsVisible", lua_cpp_model_game_Game_setEffectsVisible);
        tolua_function(tolua_S,"orientationChange", lua_cpp_model_game_Game_orientationChange);
        tolua_function(tolua_S,"getEffectsVolume", lua_cpp_model_game_Game_getEffectsVolume);
        tolua_function(tolua_S,"second", lua_cpp_model_game_Game_second);
        tolua_function(tolua_S,"exitTheGameNoParam", lua_cpp_model_game_Game_exitTheGameNoParam);
        tolua_function(tolua_S,"getReverseScale", lua_cpp_model_game_Game_getReverseScale);
        tolua_function(tolua_S,"millisecond", lua_cpp_model_game_Game_millisecond);
        tolua_function(tolua_S,"setBackgroundMusicVolume", lua_cpp_model_game_Game_setBackgroundMusicVolume);
        tolua_function(tolua_S,"shutDownKeyBoard", lua_cpp_model_game_Game_shutDownKeyBoard);
        tolua_function(tolua_S,"setBackgroundMusicVisible", lua_cpp_model_game_Game_setBackgroundMusicVisible);
        tolua_function(tolua_S,"stopBackgroundMusic", lua_cpp_model_game_Game_stopBackgroundMusic);
        tolua_function(tolua_S,"getBackgroundMusicVolume", lua_cpp_model_game_Game_getBackgroundMusicVolume);
        tolua_function(tolua_S,"instance", lua_cpp_model_game_Game_instance);
        tolua_function(tolua_S,"makeLuaId", lua_cpp_model_game_Game_makeLuaId);
        tolua_function(tolua_S,"getEffectsVisible", lua_cpp_model_game_Game_getEffectsVisible);
        tolua_function(tolua_S,"preloadBackgroundMusic", lua_cpp_model_game_Game_preloadBackgroundMusic);
        tolua_function(tolua_S,"playBackgroundMusic", lua_cpp_model_game_Game_playBackgroundMusic);
        tolua_function(tolua_S,"sendLog", lua_cpp_model_game_Game_sendLog);
        tolua_function(tolua_S,"isKeyBoardShown", lua_cpp_model_game_Game_isKeyBoardShown);
        tolua_function(tolua_S,"playEffect", lua_cpp_model_game_Game_playEffect);
        tolua_function(tolua_S,"preloadEffect", lua_cpp_model_game_Game_preloadEffect);
        tolua_function(tolua_S,"getBackgroundMusicVisible", lua_cpp_model_game_Game_getBackgroundMusicVisible);
        tolua_function(tolua_S,"isInVisible", lua_cpp_model_game_Game_isInVisible);
        tolua_function(tolua_S,"setEffectsVolume", lua_cpp_model_game_Game_setEffectsVolume);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(Game).name();
    g_luaType[typeName] = "Game";
    g_typeCast["Game"] = "Game";
    return 1;
}
TOLUA_API int register_all_cpp_model_game(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_model_game_Game(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

