#include "scripting/lua-bindings/auto/lua_cpp_net_platformapi_auto.hpp"
#include "../../../../../runtime-src/Classes/Net/PlatformApi.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_net_platformapi_PlatformApi_setCallback(lua_State* tolua_S)
{
    int argc = 0;
    PlatformApi* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"PlatformApi",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (PlatformApi*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_net_platformapi_PlatformApi_setCallback'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::function<void (CSJson::Value)> arg0;

        do {
			// Lambda binding for lua is not supported.
			assert(false);
		} while(0)
		;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_net_platformapi_PlatformApi_setCallback'", nullptr);
            return 0;
        }
        cobj->setCallback(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "PlatformApi:setCallback",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_net_platformapi_PlatformApi_setCallback'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_net_platformapi_PlatformApi_luaSendGet(lua_State* tolua_S)
{
    int argc = 0;
    PlatformApi* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"PlatformApi",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (PlatformApi*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_net_platformapi_PlatformApi_luaSendGet'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "PlatformApi:luaSendGet");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_net_platformapi_PlatformApi_luaSendGet'", nullptr);
            return 0;
        }
        cobj->luaSendGet(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        int arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "PlatformApi:luaSendGet");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "PlatformApi:luaSendGet");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_net_platformapi_PlatformApi_luaSendGet'", nullptr);
            return 0;
        }
        cobj->luaSendGet(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "PlatformApi:luaSendGet",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_net_platformapi_PlatformApi_luaSendGet'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_net_platformapi_PlatformApi_luaSendGetWithUrl(lua_State* tolua_S)
{
    int argc = 0;
    PlatformApi* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"PlatformApi",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (PlatformApi*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_net_platformapi_PlatformApi_luaSendGetWithUrl'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "PlatformApi:luaSendGetWithUrl");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_net_platformapi_PlatformApi_luaSendGetWithUrl'", nullptr);
            return 0;
        }
        cobj->luaSendGetWithUrl(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        int arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "PlatformApi:luaSendGetWithUrl");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "PlatformApi:luaSendGetWithUrl");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_net_platformapi_PlatformApi_luaSendGetWithUrl'", nullptr);
            return 0;
        }
        cobj->luaSendGetWithUrl(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "PlatformApi:luaSendGetWithUrl",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_net_platformapi_PlatformApi_luaSendGetWithUrl'.",&tolua_err);
#endif

    return 0;
}

int lua_cpp_net_platformapi_PlatformApi_luaSendPostWithUrl(lua_State* tolua_S)
{
    int argc = 0;
    PlatformApi* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"PlatformApi",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (PlatformApi*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_net_platformapi_PlatformApi_luaSendPostWithUrl'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "PlatformApi:luaSendPostWithUrl");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_net_platformapi_PlatformApi_luaSendPostWithUrl'", nullptr);
            return 0;
        }
        cobj->luaSendPostWithUrl(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        int arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "PlatformApi:luaSendPostWithUrl");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "PlatformApi:luaSendPostWithUrl");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_net_platformapi_PlatformApi_luaSendPostWithUrl'", nullptr);
            return 0;
        }
        cobj->luaSendPostWithUrl(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "PlatformApi:luaSendPostWithUrl",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_net_platformapi_PlatformApi_luaSendPostWithUrl'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_net_platformapi_PlatformApi_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"PlatformApi",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_net_platformapi_PlatformApi_create'", nullptr);
            return 0;
        }
        PlatformApi* ret = PlatformApi::create();
        object_to_luaval<PlatformApi>(tolua_S, "PlatformApi",(PlatformApi*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "PlatformApi:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_net_platformapi_PlatformApi_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_net_platformapi_PlatformApi_constructor(lua_State* tolua_S)
{
    int argc = 0;
    PlatformApi* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_net_platformapi_PlatformApi_constructor'", nullptr);
            return 0;
        }
        cobj = new PlatformApi();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"PlatformApi");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "PlatformApi:PlatformApi",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_net_platformapi_PlatformApi_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_net_platformapi_PlatformApi_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (PlatformApi)");
    return 0;
}

int lua_register_cpp_net_platformapi_PlatformApi(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"PlatformApi");
    tolua_cclass(tolua_S,"PlatformApi","PlatformApi","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"PlatformApi");
        tolua_function(tolua_S,"new",lua_cpp_net_platformapi_PlatformApi_constructor);
        tolua_function(tolua_S,"setCallback",lua_cpp_net_platformapi_PlatformApi_setCallback);
        tolua_function(tolua_S,"luaSendGet",lua_cpp_net_platformapi_PlatformApi_luaSendGet);
        tolua_function(tolua_S,"luaSendGetWithUrl",lua_cpp_net_platformapi_PlatformApi_luaSendGetWithUrl);
        tolua_function(tolua_S,"luaSendPostWithUrl",lua_cpp_net_platformapi_PlatformApi_luaSendPostWithUrl);
        tolua_function(tolua_S,"create", lua_cpp_net_platformapi_PlatformApi_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(PlatformApi).name();
    g_luaType[typeName] = "PlatformApi";
    g_typeCast["PlatformApi"] = "PlatformApi";
    return 1;
}
TOLUA_API int register_all_cpp_net_platformapi(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_net_platformapi_PlatformApi(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

