#include "scripting/lua-bindings/auto/lua_cpp_model_resmanager_auto.hpp"
#include "../../../../../runtime-src/Classes/Model/ResManager.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_model_resmanager_ResManager_copyInitRes(lua_State* tolua_S)
{
    int argc = 0;
    ResManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_resmanager_ResManager_copyInitRes'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_resmanager_ResManager_copyInitRes'", nullptr);
            return 0;
        }
        cobj->copyInitRes();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResManager:copyInitRes",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_resmanager_ResManager_copyInitRes'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_resmanager_ResManager_decodeFilename(lua_State* tolua_S)
{
    int argc = 0;
    ResManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_resmanager_ResManager_decodeFilename'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "ResManager:decodeFilename");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_resmanager_ResManager_decodeFilename'", nullptr);
            return 0;
        }
        std::string ret = cobj->decodeFilename(arg0);
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResManager:decodeFilename",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_resmanager_ResManager_decodeFilename'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_resmanager_ResManager_isInit(lua_State* tolua_S)
{
    int argc = 0;
    ResManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_resmanager_ResManager_isInit'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_resmanager_ResManager_isInit'", nullptr);
            return 0;
        }
        bool ret = cobj->isInit();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResManager:isInit",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_resmanager_ResManager_isInit'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_resmanager_ResManager_setDecodeKey(lua_State* tolua_S)
{
    int argc = 0;
    ResManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_resmanager_ResManager_setDecodeKey'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        std::string arg0;
        std::string arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "ResManager:setDecodeKey");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "ResManager:setDecodeKey");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_resmanager_ResManager_setDecodeKey'", nullptr);
            return 0;
        }
        cobj->setDecodeKey(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResManager:setDecodeKey",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_resmanager_ResManager_setDecodeKey'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_resmanager_ResManager_initMap(lua_State* tolua_S)
{
    int argc = 0;
    ResManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_resmanager_ResManager_initMap'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_resmanager_ResManager_initMap'", nullptr);
            return 0;
        }
        bool ret = cobj->initMap();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResManager:initMap",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_resmanager_ResManager_initMap'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_resmanager_ResManager_isXXTeaFile(lua_State* tolua_S)
{
    int argc = 0;
    ResManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_resmanager_ResManager_isXXTeaFile'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "ResManager:isXXTeaFile"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_resmanager_ResManager_isXXTeaFile'", nullptr);
            return 0;
        }
        bool ret = cobj->isXXTeaFile(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResManager:isXXTeaFile",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_resmanager_ResManager_isXXTeaFile'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_resmanager_ResManager_instance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"ResManager",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_resmanager_ResManager_instance'", nullptr);
            return 0;
        }
        ResManager* ret = ResManager::instance();
        object_to_luaval<ResManager>(tolua_S, "ResManager",(ResManager*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "ResManager:instance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_resmanager_ResManager_instance'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_resmanager_ResManager_constructor(lua_State* tolua_S)
{
    int argc = 0;
    ResManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_resmanager_ResManager_constructor'", nullptr);
            return 0;
        }
        cobj = new ResManager();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"ResManager");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResManager:ResManager",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_resmanager_ResManager_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_model_resmanager_ResManager_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (ResManager)");
    return 0;
}

int lua_register_cpp_model_resmanager_ResManager(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"ResManager");
    tolua_cclass(tolua_S,"ResManager","ResManager","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"ResManager");
        tolua_function(tolua_S,"new",lua_cpp_model_resmanager_ResManager_constructor);
        tolua_function(tolua_S,"copyInitRes",lua_cpp_model_resmanager_ResManager_copyInitRes);
        tolua_function(tolua_S,"decodeFilename",lua_cpp_model_resmanager_ResManager_decodeFilename);
        tolua_function(tolua_S,"isInit",lua_cpp_model_resmanager_ResManager_isInit);
        tolua_function(tolua_S,"setDecodeKey",lua_cpp_model_resmanager_ResManager_setDecodeKey);
        tolua_function(tolua_S,"initMap",lua_cpp_model_resmanager_ResManager_initMap);
        tolua_function(tolua_S,"isXXTeaFile",lua_cpp_model_resmanager_ResManager_isXXTeaFile);
        tolua_function(tolua_S,"instance", lua_cpp_model_resmanager_ResManager_instance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(ResManager).name();
    g_luaType[typeName] = "ResManager";
    g_typeCast["ResManager"] = "ResManager";
    return 1;
}
TOLUA_API int register_all_cpp_model_resmanager(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_model_resmanager_ResManager(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

