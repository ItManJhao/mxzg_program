#include "scripting/lua-bindings/auto/lua_cpp_animation_shaderfactory_auto.hpp"
#include "../../../../../runtime-src/Classes/Animation/ShaderFactory.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_animation_shaderfactory_ShaderFactory_addGLProgram(lua_State* tolua_S)
{
    int argc = 0;
    ShaderFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ShaderFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ShaderFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_animation_shaderfactory_ShaderFactory_addGLProgram'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        int arg0;
        std::string arg1;
        std::string arg2;
        bool arg3;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "ShaderFactory:addGLProgram");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "ShaderFactory:addGLProgram");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "ShaderFactory:addGLProgram");

        ok &= luaval_to_boolean(tolua_S, 5,&arg3, "ShaderFactory:addGLProgram");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_animation_shaderfactory_ShaderFactory_addGLProgram'", nullptr);
            return 0;
        }
        cocos2d::GLProgram* ret = cobj->addGLProgram(arg0, arg1, arg2, arg3);
        object_to_luaval<cocos2d::GLProgram>(tolua_S, "cc.GLProgram",(cocos2d::GLProgram*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ShaderFactory:addGLProgram",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_animation_shaderfactory_ShaderFactory_addGLProgram'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_animation_shaderfactory_ShaderFactory_setAllChildren(lua_State* tolua_S)
{
    int argc = 0;
    ShaderFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ShaderFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ShaderFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_animation_shaderfactory_ShaderFactory_setAllChildren'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Node* arg0;
        ShaderType arg1;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "ShaderFactory:setAllChildren");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "ShaderFactory:setAllChildren");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_animation_shaderfactory_ShaderFactory_setAllChildren'", nullptr);
            return 0;
        }
        cobj->setAllChildren(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ShaderFactory:setAllChildren",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_animation_shaderfactory_ShaderFactory_setAllChildren'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_animation_shaderfactory_ShaderFactory_getGLProgram(lua_State* tolua_S)
{
    int argc = 0;
    ShaderFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ShaderFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ShaderFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_animation_shaderfactory_ShaderFactory_getGLProgram'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        ShaderType arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "ShaderFactory:getGLProgram");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_animation_shaderfactory_ShaderFactory_getGLProgram'", nullptr);
            return 0;
        }
        cocos2d::GLProgram* ret = cobj->getGLProgram(arg0);
        object_to_luaval<cocos2d::GLProgram>(tolua_S, "cc.GLProgram",(cocos2d::GLProgram*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ShaderFactory:getGLProgram",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_animation_shaderfactory_ShaderFactory_getGLProgram'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_animation_shaderfactory_ShaderFactory_loadDefaultGLProgram(lua_State* tolua_S)
{
    int argc = 0;
    ShaderFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ShaderFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ShaderFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_animation_shaderfactory_ShaderFactory_loadDefaultGLProgram'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::GLProgram* arg0;
        ShaderType arg1;

        ok &= luaval_to_object<cocos2d::GLProgram>(tolua_S, 2, "cc.GLProgram",&arg0, "ShaderFactory:loadDefaultGLProgram");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "ShaderFactory:loadDefaultGLProgram");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_animation_shaderfactory_ShaderFactory_loadDefaultGLProgram'", nullptr);
            return 0;
        }
        cobj->loadDefaultGLProgram(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ShaderFactory:loadDefaultGLProgram",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_animation_shaderfactory_ShaderFactory_loadDefaultGLProgram'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_animation_shaderfactory_ShaderFactory_registerGLProgram(lua_State* tolua_S)
{
    int argc = 0;
    ShaderFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ShaderFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ShaderFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_animation_shaderfactory_ShaderFactory_registerGLProgram'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_animation_shaderfactory_ShaderFactory_registerGLProgram'", nullptr);
            return 0;
        }
        cobj->registerGLProgram();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ShaderFactory:registerGLProgram",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_animation_shaderfactory_ShaderFactory_registerGLProgram'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_animation_shaderfactory_ShaderFactory_instance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"ShaderFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_animation_shaderfactory_ShaderFactory_instance'", nullptr);
            return 0;
        }
        ShaderFactory* ret = ShaderFactory::instance();
        object_to_luaval<ShaderFactory>(tolua_S, "ShaderFactory",(ShaderFactory*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "ShaderFactory:instance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_animation_shaderfactory_ShaderFactory_instance'.",&tolua_err);
#endif
    return 0;
}
static int lua_cpp_animation_shaderfactory_ShaderFactory_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (ShaderFactory)");
    return 0;
}

int lua_register_cpp_animation_shaderfactory_ShaderFactory(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"ShaderFactory");
    tolua_cclass(tolua_S,"ShaderFactory","ShaderFactory","SingleInstance<ShaderFactory>",nullptr);

    tolua_beginmodule(tolua_S,"ShaderFactory");
        tolua_function(tolua_S,"addGLProgram",lua_cpp_animation_shaderfactory_ShaderFactory_addGLProgram);
        tolua_function(tolua_S,"setAllChildren",lua_cpp_animation_shaderfactory_ShaderFactory_setAllChildren);
        tolua_function(tolua_S,"getGLProgram",lua_cpp_animation_shaderfactory_ShaderFactory_getGLProgram);
        tolua_function(tolua_S,"loadDefaultGLProgram",lua_cpp_animation_shaderfactory_ShaderFactory_loadDefaultGLProgram);
        tolua_function(tolua_S,"registerGLProgram",lua_cpp_animation_shaderfactory_ShaderFactory_registerGLProgram);
        tolua_function(tolua_S,"instance", lua_cpp_animation_shaderfactory_ShaderFactory_instance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(ShaderFactory).name();
    g_luaType[typeName] = "ShaderFactory";
    g_typeCast["ShaderFactory"] = "ShaderFactory";
    return 1;
}
TOLUA_API int register_all_cpp_animation_shaderfactory(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_animation_shaderfactory_ShaderFactory(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

