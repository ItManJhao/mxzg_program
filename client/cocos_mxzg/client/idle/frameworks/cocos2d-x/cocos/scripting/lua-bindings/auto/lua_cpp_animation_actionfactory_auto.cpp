#include "lua_cpp_animation_actionfactory_auto.hpp"
#include "../../../../../runtime-src/Classes/Animation/ActionFactory.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"


int lua_cpp_animation_actionfactory_ActionFactory_createRepeatForever(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"ActionFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 3)
    {
        const char* arg0;
        std::string arg1;
        double arg2;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "ActionFactory:createRepeatForever"); arg0 = arg0_tmp.c_str();
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "ActionFactory:createRepeatForever");
        ok &= luaval_to_number(tolua_S, 4,&arg2, "ActionFactory:createRepeatForever");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_animation_actionfactory_ActionFactory_createRepeatForever'", nullptr);
            return 0;
        }
        cocos2d::RepeatForever* ret = ActionFactory::createRepeatForever(arg0, arg1, arg2);
        object_to_luaval<cocos2d::RepeatForever>(tolua_S, "cc.RepeatForever",(cocos2d::RepeatForever*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "ActionFactory:createRepeatForever",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_animation_actionfactory_ActionFactory_createRepeatForever'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_animation_actionfactory_ActionFactory_createLuaAnimateWithDuration(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"ActionFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 3)
    {
        const char* arg0;
        std::string arg1;
        double arg2;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "ActionFactory:createLuaAnimateWithDuration"); arg0 = arg0_tmp.c_str();
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "ActionFactory:createLuaAnimateWithDuration");
        ok &= luaval_to_number(tolua_S, 4,&arg2, "ActionFactory:createLuaAnimateWithDuration");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_animation_actionfactory_ActionFactory_createLuaAnimateWithDuration'", nullptr);
            return 0;
        }
        cocos2d::ActionInterval* ret = ActionFactory::createLuaAnimateWithDuration(arg0, arg1, arg2);
        object_to_luaval<cocos2d::ActionInterval>(tolua_S, "cc.ActionInterval",(cocos2d::ActionInterval*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "ActionFactory:createLuaAnimateWithDuration",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_animation_actionfactory_ActionFactory_createLuaAnimateWithDuration'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_animation_actionfactory_ActionFactory_createAnimation(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"ActionFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 3)
    {
        const char* arg0;
        std::string arg1;
        double arg2;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "ActionFactory:createAnimation"); arg0 = arg0_tmp.c_str();
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "ActionFactory:createAnimation");
        ok &= luaval_to_number(tolua_S, 4,&arg2, "ActionFactory:createAnimation");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_animation_actionfactory_ActionFactory_createAnimation'", nullptr);
            return 0;
        }
        cocos2d::Animation* ret = ActionFactory::createAnimation(arg0, arg1, arg2);
        object_to_luaval<cocos2d::Animation>(tolua_S, "cc.Animation",(cocos2d::Animation*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "ActionFactory:createAnimation",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_animation_actionfactory_ActionFactory_createAnimation'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_animation_actionfactory_ActionFactory_createBeattackAction(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"ActionFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        cocos2d::Point arg0;
        ok &= luaval_to_point(tolua_S, 2, &arg0, "ActionFactory:createBeattackAction");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_animation_actionfactory_ActionFactory_createBeattackAction'", nullptr);
            return 0;
        }
        cocos2d::ActionInterval* ret = ActionFactory::createBeattackAction(arg0);
        object_to_luaval<cocos2d::ActionInterval>(tolua_S, "cc.ActionInterval",(cocos2d::ActionInterval*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "ActionFactory:createBeattackAction",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_animation_actionfactory_ActionFactory_createBeattackAction'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_animation_actionfactory_ActionFactory_createLuaAnimate(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"ActionFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 3)
    {
        const char* arg0;
        std::string arg1;
        double arg2;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "ActionFactory:createLuaAnimate"); arg0 = arg0_tmp.c_str();
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "ActionFactory:createLuaAnimate");
        ok &= luaval_to_number(tolua_S, 4,&arg2, "ActionFactory:createLuaAnimate");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_animation_actionfactory_ActionFactory_createLuaAnimate'", nullptr);
            return 0;
        }
        cocos2d::ActionInterval* ret = ActionFactory::createLuaAnimate(arg0, arg1, arg2);
        object_to_luaval<cocos2d::ActionInterval>(tolua_S, "cc.ActionInterval",(cocos2d::ActionInterval*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "ActionFactory:createLuaAnimate",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_animation_actionfactory_ActionFactory_createLuaAnimate'.",&tolua_err);
#endif
    return 0;
}
static int lua_cpp_animation_actionfactory_ActionFactory_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (ActionFactory)");
    return 0;
}

int lua_register_cpp_animation_actionfactory_ActionFactory(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"ActionFactory");
    tolua_cclass(tolua_S,"ActionFactory","ActionFactory","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"ActionFactory");
        tolua_function(tolua_S,"createRepeatForever", lua_cpp_animation_actionfactory_ActionFactory_createRepeatForever);
        tolua_function(tolua_S,"createLuaAnimateWithDuration", lua_cpp_animation_actionfactory_ActionFactory_createLuaAnimateWithDuration);
        tolua_function(tolua_S,"createAnimation", lua_cpp_animation_actionfactory_ActionFactory_createAnimation);
        tolua_function(tolua_S,"createBeattackAction", lua_cpp_animation_actionfactory_ActionFactory_createBeattackAction);
        tolua_function(tolua_S,"createLuaAnimate", lua_cpp_animation_actionfactory_ActionFactory_createLuaAnimate);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(ActionFactory).name();
    g_luaType[typeName] = "ActionFactory";
    g_typeCast["ActionFactory"] = "ActionFactory";
    return 1;
}
TOLUA_API int register_all_cpp_animation_actionfactory(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_animation_actionfactory_ActionFactory(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

