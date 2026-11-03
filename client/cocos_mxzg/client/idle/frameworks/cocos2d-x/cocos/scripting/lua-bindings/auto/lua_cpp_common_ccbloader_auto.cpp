#include "scripting/lua-bindings/auto/lua_cpp_common_ccbloader_auto.hpp"
#include "../../../../../runtime-src/Classes/Common/CCBLoader.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_common_ccbloader_CCBLoader_addLuaLoaderLibrary(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CCBLoader",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCBLoader:addLuaLoaderLibrary"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_common_ccbloader_CCBLoader_addLuaLoaderLibrary'", nullptr);
            return 0;
        }
        CCBLoader::addLuaLoaderLibrary(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCBLoader:addLuaLoaderLibrary",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_common_ccbloader_CCBLoader_addLuaLoaderLibrary'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_common_ccbloader_CCBLoader_readNodeGraphFromFile(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CCBLoader",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S)-1;

    do 
    {
        if (argc == 2)
        {
            const char* arg0;
            std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCBLoader:readNodeGraphFromFile"); arg0 = arg0_tmp.c_str();
            if (!ok) { break; }
            NodeCtr* arg1;
            ok &= luaval_to_object<NodeCtr>(tolua_S, 3, "NodeCtr",&arg1, "CCBLoader:readNodeGraphFromFile");
            if (!ok) { break; }
            cocos2d::Node* ret = CCBLoader::readNodeGraphFromFile(arg0, arg1);
            object_to_luaval<cocos2d::Node>(tolua_S, "cc.Node",(cocos2d::Node*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    do 
    {
        if (argc == 1)
        {
            const char* arg0;
            std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCBLoader:readNodeGraphFromFile"); arg0 = arg0_tmp.c_str();
            if (!ok) { break; }
            cocos2d::Node* ret = CCBLoader::readNodeGraphFromFile(arg0);
            object_to_luaval<cocos2d::Node>(tolua_S, "cc.Node",(cocos2d::Node*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    do 
    {
        if (argc == 3)
        {
            const char* arg0;
            std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCBLoader:readNodeGraphFromFile"); arg0 = arg0_tmp.c_str();
            if (!ok) { break; }
            NodeCtr* arg1;
            ok &= luaval_to_object<NodeCtr>(tolua_S, 3, "NodeCtr",&arg1, "CCBLoader:readNodeGraphFromFile");
            if (!ok) { break; }
            bool arg2;
            ok &= luaval_to_boolean(tolua_S, 4,&arg2, "CCBLoader:readNodeGraphFromFile");
            if (!ok) { break; }
            cocos2d::Node* ret = CCBLoader::readNodeGraphFromFile(arg0, arg1, arg2);
            object_to_luaval<cocos2d::Node>(tolua_S, "cc.Node",(cocos2d::Node*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d", "CCBLoader:readNodeGraphFromFile",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_common_ccbloader_CCBLoader_readNodeGraphFromFile'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_common_ccbloader_CCBLoader_addNodeLoaderLibrary(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CCBLoader",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCBLoader:addNodeLoaderLibrary"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_common_ccbloader_CCBLoader_addNodeLoaderLibrary'", nullptr);
            return 0;
        }
        CCBLoader::addNodeLoaderLibrary(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCBLoader:addNodeLoaderLibrary",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_common_ccbloader_CCBLoader_addNodeLoaderLibrary'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_common_ccbloader_CCBLoader_createSceneWithNodeGraphFromFile(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CCBLoader",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        const char* arg0;
        NodeCtr* arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCBLoader:createSceneWithNodeGraphFromFile"); arg0 = arg0_tmp.c_str();
        ok &= luaval_to_object<NodeCtr>(tolua_S, 3, "NodeCtr",&arg1, "CCBLoader:createSceneWithNodeGraphFromFile");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_common_ccbloader_CCBLoader_createSceneWithNodeGraphFromFile'", nullptr);
            return 0;
        }
        cocos2d::Scene* ret = CCBLoader::createSceneWithNodeGraphFromFile(arg0, arg1);
        object_to_luaval<cocos2d::Scene>(tolua_S, "cc.Scene",(cocos2d::Scene*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCBLoader:createSceneWithNodeGraphFromFile",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_common_ccbloader_CCBLoader_createSceneWithNodeGraphFromFile'.",&tolua_err);
#endif
    return 0;
}
static int lua_cpp_common_ccbloader_CCBLoader_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CCBLoader)");
    return 0;
}

int lua_register_cpp_common_ccbloader_CCBLoader(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"CCBLoader");
    tolua_cclass(tolua_S,"CCBLoader","CCBLoader","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"CCBLoader");
        tolua_function(tolua_S,"addLuaLoaderLibrary", lua_cpp_common_ccbloader_CCBLoader_addLuaLoaderLibrary);
        tolua_function(tolua_S,"readNodeGraphFromFile", lua_cpp_common_ccbloader_CCBLoader_readNodeGraphFromFile);
        tolua_function(tolua_S,"addNodeLoaderLibrary", lua_cpp_common_ccbloader_CCBLoader_addNodeLoaderLibrary);
        tolua_function(tolua_S,"createSceneWithNodeGraphFromFile", lua_cpp_common_ccbloader_CCBLoader_createSceneWithNodeGraphFromFile);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CCBLoader).name();
    g_luaType[typeName] = "CCBLoader";
    g_typeCast["CCBLoader"] = "CCBLoader";
    return 1;
}
TOLUA_API int register_all_cpp_common_ccbloader(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_common_ccbloader_CCBLoader(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

