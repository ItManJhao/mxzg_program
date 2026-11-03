#include "scripting/lua-bindings/auto/lua_cpp_comp_protectednodeex_auto.hpp"
#include "../../../../../runtime-src/Classes/Comp/ProtectedNodeEx.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_comp_protectednodeex_ProtectedNodeEx_destroy(lua_State* tolua_S)
{
    int argc = 0;
    ProtectedNodeEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ProtectedNodeEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ProtectedNodeEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_protectednodeex_ProtectedNodeEx_destroy'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "ProtectedNodeEx:destroy");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_protectednodeex_ProtectedNodeEx_destroy'", nullptr);
            return 0;
        }
        cobj->destroy(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ProtectedNodeEx:destroy",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_protectednodeex_ProtectedNodeEx_destroy'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_protectednodeex_ProtectedNodeEx_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"ProtectedNodeEx",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_protectednodeex_ProtectedNodeEx_create'", nullptr);
            return 0;
        }
        ProtectedNodeEx* ret = ProtectedNodeEx::create();
        object_to_luaval<ProtectedNodeEx>(tolua_S, "ProtectedNodeEx",(ProtectedNodeEx*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "ProtectedNodeEx:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_protectednodeex_ProtectedNodeEx_create'.",&tolua_err);
#endif
    return 0;
}
static int lua_cpp_comp_protectednodeex_ProtectedNodeEx_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (ProtectedNodeEx)");
    return 0;
}

int lua_register_cpp_comp_protectednodeex_ProtectedNodeEx(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"ProtectedNodeEx");
    tolua_cclass(tolua_S,"ProtectedNodeEx","ProtectedNodeEx","cc.ProtectedNode",nullptr);

    tolua_beginmodule(tolua_S,"ProtectedNodeEx");
        tolua_function(tolua_S,"destroy",lua_cpp_comp_protectednodeex_ProtectedNodeEx_destroy);
        tolua_function(tolua_S,"create", lua_cpp_comp_protectednodeex_ProtectedNodeEx_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(ProtectedNodeEx).name();
    g_luaType[typeName] = "ProtectedNodeEx";
    g_typeCast["ProtectedNodeEx"] = "ProtectedNodeEx";
    return 1;
}
TOLUA_API int register_all_cpp_comp_protectednodeex(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_comp_protectednodeex_ProtectedNodeEx(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

