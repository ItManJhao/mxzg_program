#include "scripting/lua-bindings/auto/lua_cpp_net_response_responsemanager_auto.hpp"
#include "../../../../../runtime-src/Classes/Net/Response/ResponseManager.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_net_response_responsemanager_ResponseManager_getLuaResponse(lua_State* tolua_S)
{
    int argc = 0;
    ResponseManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResponseManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResponseManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_net_response_responsemanager_ResponseManager_getLuaResponse'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "ResponseManager:getLuaResponse");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_net_response_responsemanager_ResponseManager_getLuaResponse'", nullptr);
            return 0;
        }
        long long ret = cobj->getLuaResponse(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResponseManager:getLuaResponse",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_net_response_responsemanager_ResponseManager_getLuaResponse'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_net_response_responsemanager_ResponseManager_addLuaResponse(lua_State* tolua_S)
{
    int argc = 0;
    ResponseManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResponseManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResponseManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_net_response_responsemanager_ResponseManager_addLuaResponse'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "ResponseManager:addLuaResponse");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_net_response_responsemanager_ResponseManager_addLuaResponse'", nullptr);
            return 0;
        }
        cobj->addLuaResponse(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResponseManager:addLuaResponse",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_net_response_responsemanager_ResponseManager_addLuaResponse'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_net_response_responsemanager_ResponseManager_getResponse(lua_State* tolua_S)
{
    int argc = 0;
    ResponseManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResponseManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResponseManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_net_response_responsemanager_ResponseManager_getResponse'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "ResponseManager:getResponse");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_net_response_responsemanager_ResponseManager_getResponse'", nullptr);
            return 0;
        }
        long long ret = cobj->getResponse(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResponseManager:getResponse",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_net_response_responsemanager_ResponseManager_getResponse'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_net_response_responsemanager_ResponseManager_clearLuaResponse(lua_State* tolua_S)
{
    int argc = 0;
    ResponseManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResponseManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResponseManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_net_response_responsemanager_ResponseManager_clearLuaResponse'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_net_response_responsemanager_ResponseManager_clearLuaResponse'", nullptr);
            return 0;
        }
        cobj->clearLuaResponse();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResponseManager:clearLuaResponse",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_net_response_responsemanager_ResponseManager_clearLuaResponse'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_net_response_responsemanager_ResponseManager_luaResponse(lua_State* tolua_S)
{
    int argc = 0;
    ResponseManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResponseManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResponseManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_net_response_responsemanager_ResponseManager_luaResponse'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        ByteArray* arg0;

        ok &= luaval_to_object<ByteArray>(tolua_S, 2, "ByteArray",&arg0, "ResponseManager:luaResponse");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_net_response_responsemanager_ResponseManager_luaResponse'", nullptr);
            return 0;
        }
        cobj->luaResponse(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResponseManager:luaResponse",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_net_response_responsemanager_ResponseManager_luaResponse'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_net_response_responsemanager_ResponseManager_response(lua_State* tolua_S)
{
    int argc = 0;
    ResponseManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResponseManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResponseManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_net_response_responsemanager_ResponseManager_response'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        ByteArray* arg0;

        ok &= luaval_to_object<ByteArray>(tolua_S, 2, "ByteArray",&arg0, "ResponseManager:response");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_net_response_responsemanager_ResponseManager_response'", nullptr);
            return 0;
        }
        cobj->response(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResponseManager:response",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_net_response_responsemanager_ResponseManager_response'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_net_response_responsemanager_ResponseManager_instance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"ResponseManager",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_net_response_responsemanager_ResponseManager_instance'", nullptr);
            return 0;
        }
        ResponseManager* ret = ResponseManager::instance();
        object_to_luaval<ResponseManager>(tolua_S, "ResponseManager",(ResponseManager*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "ResponseManager:instance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_net_response_responsemanager_ResponseManager_instance'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_net_response_responsemanager_ResponseManager_constructor(lua_State* tolua_S)
{
    int argc = 0;
    ResponseManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_net_response_responsemanager_ResponseManager_constructor'", nullptr);
            return 0;
        }
        cobj = new ResponseManager();
        tolua_pushusertype(tolua_S,(void*)cobj,"ResponseManager");
        tolua_register_gc(tolua_S,lua_gettop(tolua_S));
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResponseManager:ResponseManager",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_net_response_responsemanager_ResponseManager_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_net_response_responsemanager_ResponseManager_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (ResponseManager)");
    return 0;
}

int lua_register_cpp_net_response_responsemanager_ResponseManager(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"ResponseManager");
    tolua_cclass(tolua_S,"ResponseManager","ResponseManager","SingleInstance<ResponseManager>",nullptr);

    tolua_beginmodule(tolua_S,"ResponseManager");
        tolua_function(tolua_S,"new",lua_cpp_net_response_responsemanager_ResponseManager_constructor);
        tolua_function(tolua_S,"getLuaResponse",lua_cpp_net_response_responsemanager_ResponseManager_getLuaResponse);
        tolua_function(tolua_S,"addLuaResponse",lua_cpp_net_response_responsemanager_ResponseManager_addLuaResponse);
        tolua_function(tolua_S,"getResponse",lua_cpp_net_response_responsemanager_ResponseManager_getResponse);
        tolua_function(tolua_S,"clearLuaResponse",lua_cpp_net_response_responsemanager_ResponseManager_clearLuaResponse);
        tolua_function(tolua_S,"luaResponse",lua_cpp_net_response_responsemanager_ResponseManager_luaResponse);
        tolua_function(tolua_S,"response",lua_cpp_net_response_responsemanager_ResponseManager_response);
        tolua_function(tolua_S,"instance", lua_cpp_net_response_responsemanager_ResponseManager_instance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(ResponseManager).name();
    g_luaType[typeName] = "ResponseManager";
    g_typeCast["ResponseManager"] = "ResponseManager";
    return 1;
}
TOLUA_API int register_all_cpp_net_response_responsemanager(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_net_response_responsemanager_ResponseManager(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

