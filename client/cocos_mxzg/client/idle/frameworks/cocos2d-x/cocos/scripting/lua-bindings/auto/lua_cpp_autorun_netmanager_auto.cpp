#include "scripting/lua-bindings/auto/lua_cpp_autorun_netmanager_auto.hpp"
#include "../../../../../runtime-src/Classes/AutoRun/NetManager.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_autorun_netmanager_GameAutoRun_stopAndRelease(lua_State* tolua_S)
{
    int argc = 0;
    GameAutoRun* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"GameAutoRun",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (GameAutoRun*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_autorun_netmanager_GameAutoRun_stopAndRelease'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_autorun_netmanager_GameAutoRun_stopAndRelease'", nullptr);
            return 0;
        }
        cobj->stopAndRelease();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "GameAutoRun:stopAndRelease",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_autorun_netmanager_GameAutoRun_stopAndRelease'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_autorun_netmanager_GameAutoRun_start(lua_State* tolua_S)
{
    int argc = 0;
    GameAutoRun* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"GameAutoRun",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (GameAutoRun*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_autorun_netmanager_GameAutoRun_start'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_autorun_netmanager_GameAutoRun_start'", nullptr);
            return 0;
        }
        cobj->start();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "GameAutoRun:start",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_autorun_netmanager_GameAutoRun_start'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_autorun_netmanager_GameAutoRun_init(lua_State* tolua_S)
{
    int argc = 0;
    GameAutoRun* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"GameAutoRun",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (GameAutoRun*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_autorun_netmanager_GameAutoRun_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_autorun_netmanager_GameAutoRun_init'", nullptr);
            return 0;
        }
        cobj->init();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "GameAutoRun:init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_autorun_netmanager_GameAutoRun_init'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_autorun_netmanager_GameAutoRun_stop(lua_State* tolua_S)
{
    int argc = 0;
    GameAutoRun* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"GameAutoRun",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (GameAutoRun*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_autorun_netmanager_GameAutoRun_stop'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_autorun_netmanager_GameAutoRun_stop'", nullptr);
            return 0;
        }
        cobj->stop();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "GameAutoRun:stop",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_autorun_netmanager_GameAutoRun_stop'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_autorun_netmanager_GameAutoRun_run(lua_State* tolua_S)
{
    int argc = 0;
    GameAutoRun* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"GameAutoRun",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (GameAutoRun*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_autorun_netmanager_GameAutoRun_run'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "GameAutoRun:run");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_autorun_netmanager_GameAutoRun_run'", nullptr);
            return 0;
        }
        cobj->run(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "GameAutoRun:run",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_autorun_netmanager_GameAutoRun_run'.",&tolua_err);
#endif

    return 0;
}
static int lua_cpp_autorun_netmanager_GameAutoRun_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (GameAutoRun)");
    return 0;
}

int lua_register_cpp_autorun_netmanager_GameAutoRun(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"GameAutoRun");
    tolua_cclass(tolua_S,"GameAutoRun","GameAutoRun","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"GameAutoRun");
        tolua_function(tolua_S,"stopAndRelease",lua_cpp_autorun_netmanager_GameAutoRun_stopAndRelease);
        tolua_function(tolua_S,"start",lua_cpp_autorun_netmanager_GameAutoRun_start);
        tolua_function(tolua_S,"init",lua_cpp_autorun_netmanager_GameAutoRun_init);
        tolua_function(tolua_S,"stop",lua_cpp_autorun_netmanager_GameAutoRun_stop);
        tolua_function(tolua_S,"run",lua_cpp_autorun_netmanager_GameAutoRun_run);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(GameAutoRun).name();
    g_luaType[typeName] = "GameAutoRun";
    g_typeCast["GameAutoRun"] = "GameAutoRun";
    return 1;
}

int lua_cpp_autorun_netmanager_NetManager_reset(lua_State* tolua_S)
{
    int argc = 0;
    NetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_autorun_netmanager_NetManager_reset'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_autorun_netmanager_NetManager_reset'", nullptr);
            return 0;
        }
        cobj->reset();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetManager:reset",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_autorun_netmanager_NetManager_reset'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_autorun_netmanager_NetManager_setUserId(lua_State* tolua_S)
{
    int argc = 0;
    NetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_autorun_netmanager_NetManager_setUserId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "NetManager:setUserId");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_autorun_netmanager_NetManager_setUserId'", nullptr);
            return 0;
        }
        cobj->setUserId(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetManager:setUserId",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_autorun_netmanager_NetManager_setUserId'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_autorun_netmanager_NetManager_setTimeStamp(lua_State* tolua_S)
{
    int argc = 0;
    NetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_autorun_netmanager_NetManager_setTimeStamp'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "NetManager:setTimeStamp");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_autorun_netmanager_NetManager_setTimeStamp'", nullptr);
            return 0;
        }
        cobj->setTimeStamp(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetManager:setTimeStamp",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_autorun_netmanager_NetManager_setTimeStamp'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_autorun_netmanager_NetManager_setSign(lua_State* tolua_S)
{
    int argc = 0;
    NetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_autorun_netmanager_NetManager_setSign'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "NetManager:setSign");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_autorun_netmanager_NetManager_setSign'", nullptr);
            return 0;
        }
        cobj->setSign(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetManager:setSign",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_autorun_netmanager_NetManager_setSign'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_autorun_netmanager_NetManager_sendReqLogin(lua_State* tolua_S)
{
    int argc = 0;
    NetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_autorun_netmanager_NetManager_sendReqLogin'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_autorun_netmanager_NetManager_sendReqLogin'", nullptr);
            return 0;
        }
        cobj->sendReqLogin();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetManager:sendReqLogin",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_autorun_netmanager_NetManager_sendReqLogin'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_autorun_netmanager_NetManager_sendByteArray(lua_State* tolua_S)
{
    int argc = 0;
    NetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_autorun_netmanager_NetManager_sendByteArray'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        ByteArray* arg0;

        ok &= luaval_to_object<ByteArray>(tolua_S, 2, "ByteArray",&arg0, "NetManager:sendByteArray");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_autorun_netmanager_NetManager_sendByteArray'", nullptr);
            return 0;
        }
        cobj->sendByteArray(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetManager:sendByteArray",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_autorun_netmanager_NetManager_sendByteArray'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_autorun_netmanager_NetManager_setServerId(lua_State* tolua_S)
{
    int argc = 0;
    NetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_autorun_netmanager_NetManager_setServerId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "NetManager:setServerId");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_autorun_netmanager_NetManager_setServerId'", nullptr);
            return 0;
        }
        cobj->setServerId(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetManager:setServerId",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_autorun_netmanager_NetManager_setServerId'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_autorun_netmanager_NetManager_isConnected(lua_State* tolua_S)
{
    int argc = 0;
    NetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_autorun_netmanager_NetManager_isConnected'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_autorun_netmanager_NetManager_isConnected'", nullptr);
            return 0;
        }
        bool ret = cobj->isConnected();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetManager:isConnected",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_autorun_netmanager_NetManager_isConnected'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_autorun_netmanager_NetManager_addHosts(lua_State* tolua_S)
{
    int argc = 0;
    NetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_autorun_netmanager_NetManager_addHosts'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        std::string arg0;
        int arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "NetManager:addHosts");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "NetManager:addHosts");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_autorun_netmanager_NetManager_addHosts'", nullptr);
            return 0;
        }
        cobj->addHosts(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetManager:addHosts",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_autorun_netmanager_NetManager_addHosts'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_autorun_netmanager_NetManager_close(lua_State* tolua_S)
{
    int argc = 0;
    NetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_autorun_netmanager_NetManager_close'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_autorun_netmanager_NetManager_close'", nullptr);
            return 0;
        }
        cobj->close();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetManager:close",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_autorun_netmanager_NetManager_close'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_autorun_netmanager_NetManager_getHostsNum(lua_State* tolua_S)
{
    int argc = 0;
    NetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_autorun_netmanager_NetManager_getHostsNum'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_autorun_netmanager_NetManager_getHostsNum'", nullptr);
            return 0;
        }
        int ret = cobj->getHostsNum();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetManager:getHostsNum",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_autorun_netmanager_NetManager_getHostsNum'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_autorun_netmanager_NetManager_clearHosts(lua_State* tolua_S)
{
    int argc = 0;
    NetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_autorun_netmanager_NetManager_clearHosts'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_autorun_netmanager_NetManager_clearHosts'", nullptr);
            return 0;
        }
        cobj->clearHosts();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetManager:clearHosts",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_autorun_netmanager_NetManager_clearHosts'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_autorun_netmanager_NetManager_instance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"NetManager",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_autorun_netmanager_NetManager_instance'", nullptr);
            return 0;
        }
        NetManager* ret = NetManager::instance();
        object_to_luaval<NetManager>(tolua_S, "NetManager",(NetManager*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "NetManager:instance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_autorun_netmanager_NetManager_instance'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_autorun_netmanager_NetManager_constructor(lua_State* tolua_S)
{
    int argc = 0;
    NetManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_autorun_netmanager_NetManager_constructor'", nullptr);
            return 0;
        }
        cobj = new NetManager();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"NetManager");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetManager:NetManager",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_autorun_netmanager_NetManager_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_autorun_netmanager_NetManager_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (NetManager)");
    return 0;
}

int lua_register_cpp_autorun_netmanager_NetManager(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"NetManager");
    tolua_cclass(tolua_S,"NetManager","NetManager","GameAutoRun",nullptr);

    tolua_beginmodule(tolua_S,"NetManager");
        tolua_function(tolua_S,"new",lua_cpp_autorun_netmanager_NetManager_constructor);
        tolua_function(tolua_S,"reset",lua_cpp_autorun_netmanager_NetManager_reset);
        tolua_function(tolua_S,"setUserId",lua_cpp_autorun_netmanager_NetManager_setUserId);
        tolua_function(tolua_S,"setTimeStamp",lua_cpp_autorun_netmanager_NetManager_setTimeStamp);
        tolua_function(tolua_S,"setSign",lua_cpp_autorun_netmanager_NetManager_setSign);
        tolua_function(tolua_S,"sendReqLogin",lua_cpp_autorun_netmanager_NetManager_sendReqLogin);
        tolua_function(tolua_S,"sendByteArray",lua_cpp_autorun_netmanager_NetManager_sendByteArray);
        tolua_function(tolua_S,"setServerId",lua_cpp_autorun_netmanager_NetManager_setServerId);
        tolua_function(tolua_S,"isConnected",lua_cpp_autorun_netmanager_NetManager_isConnected);
        tolua_function(tolua_S,"addHosts",lua_cpp_autorun_netmanager_NetManager_addHosts);
        tolua_function(tolua_S,"close",lua_cpp_autorun_netmanager_NetManager_close);
        tolua_function(tolua_S,"getHostsNum",lua_cpp_autorun_netmanager_NetManager_getHostsNum);
        tolua_function(tolua_S,"clearHosts",lua_cpp_autorun_netmanager_NetManager_clearHosts);
        tolua_function(tolua_S,"instance", lua_cpp_autorun_netmanager_NetManager_instance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(NetManager).name();
    g_luaType[typeName] = "NetManager";
    g_typeCast["NetManager"] = "NetManager";
    return 1;
}
TOLUA_API int register_all_cpp_autorun_netmanager(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_autorun_netmanager_GameAutoRun(tolua_S);
	lua_register_cpp_autorun_netmanager_NetManager(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

