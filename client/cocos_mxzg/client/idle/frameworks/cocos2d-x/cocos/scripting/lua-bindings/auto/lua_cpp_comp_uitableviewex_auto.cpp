#include "scripting/lua-bindings/auto/lua_cpp_comp_uitableviewex_auto.hpp"
#include "../../../../../runtime-src/Classes/Comp/UITableViewEx.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_comp_uitableviewex_UITableViewEx_getMoveSpeed(lua_State* tolua_S)
{
    int argc = 0;
    UITableViewEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UITableViewEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UITableViewEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uitableviewex_UITableViewEx_getMoveSpeed'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uitableviewex_UITableViewEx_getMoveSpeed'", nullptr);
            return 0;
        }
        double ret = cobj->getMoveSpeed();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UITableViewEx:getMoveSpeed",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uitableviewex_UITableViewEx_getMoveSpeed'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uitableviewex_UITableViewEx_deaccelerateScrolling(lua_State* tolua_S)
{
    int argc = 0;
    UITableViewEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UITableViewEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UITableViewEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uitableviewex_UITableViewEx_deaccelerateScrolling'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UITableViewEx:deaccelerateScrolling");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uitableviewex_UITableViewEx_deaccelerateScrolling'", nullptr);
            return 0;
        }
        cobj->deaccelerateScrolling(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UITableViewEx:deaccelerateScrolling",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uitableviewex_UITableViewEx_deaccelerateScrolling'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uitableviewex_UITableViewEx_setMoveSpeed(lua_State* tolua_S)
{
    int argc = 0;
    UITableViewEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UITableViewEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UITableViewEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uitableviewex_UITableViewEx_setMoveSpeed'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UITableViewEx:setMoveSpeed");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uitableviewex_UITableViewEx_setMoveSpeed'", nullptr);
            return 0;
        }
        cobj->setMoveSpeed(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UITableViewEx:setMoveSpeed",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uitableviewex_UITableViewEx_setMoveSpeed'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uitableviewex_UITableViewEx_onScrollViewTouchEnded(lua_State* tolua_S)
{
    int argc = 0;
    UITableViewEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UITableViewEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UITableViewEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uitableviewex_UITableViewEx_onScrollViewTouchEnded'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Touch* arg0;
        cocos2d::Event* arg1;

        ok &= luaval_to_object<cocos2d::Touch>(tolua_S, 2, "cc.Touch",&arg0, "UITableViewEx:onScrollViewTouchEnded");

        ok &= luaval_to_object<cocos2d::Event>(tolua_S, 3, "cc.Event",&arg1, "UITableViewEx:onScrollViewTouchEnded");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uitableviewex_UITableViewEx_onScrollViewTouchEnded'", nullptr);
            return 0;
        }
        cobj->onScrollViewTouchEnded(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UITableViewEx:onScrollViewTouchEnded",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uitableviewex_UITableViewEx_onScrollViewTouchEnded'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uitableviewex_UITableViewEx_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UITableViewEx",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        cocos2d::Size arg0;
        ok &= luaval_to_size(tolua_S, 2, &arg0, "UITableViewEx:create");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uitableviewex_UITableViewEx_create'", nullptr);
            return 0;
        }
        UITableViewEx* ret = UITableViewEx::create(arg0);
        object_to_luaval<UITableViewEx>(tolua_S, "UITableViewEx",(UITableViewEx*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UITableViewEx:create",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uitableviewex_UITableViewEx_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_uitableviewex_UITableViewEx_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UITableViewEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uitableviewex_UITableViewEx_constructor'", nullptr);
            return 0;
        }
        cobj = new UITableViewEx();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UITableViewEx");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UITableViewEx:UITableViewEx",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uitableviewex_UITableViewEx_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_comp_uitableviewex_UITableViewEx_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UITableViewEx)");
    return 0;
}

int lua_register_cpp_comp_uitableviewex_UITableViewEx(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UITableViewEx");
    tolua_cclass(tolua_S,"UITableViewEx","UITableViewEx","cc.TableView",nullptr);

    tolua_beginmodule(tolua_S,"UITableViewEx");
        tolua_function(tolua_S,"new",lua_cpp_comp_uitableviewex_UITableViewEx_constructor);
        tolua_function(tolua_S,"getMoveSpeed",lua_cpp_comp_uitableviewex_UITableViewEx_getMoveSpeed);
        tolua_function(tolua_S,"deaccelerateScrolling",lua_cpp_comp_uitableviewex_UITableViewEx_deaccelerateScrolling);
        tolua_function(tolua_S,"setMoveSpeed",lua_cpp_comp_uitableviewex_UITableViewEx_setMoveSpeed);
        tolua_function(tolua_S,"onScrollViewTouchEnded",lua_cpp_comp_uitableviewex_UITableViewEx_onScrollViewTouchEnded);
        tolua_function(tolua_S,"create", lua_cpp_comp_uitableviewex_UITableViewEx_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UITableViewEx).name();
    g_luaType[typeName] = "UITableViewEx";
    g_typeCast["UITableViewEx"] = "UITableViewEx";
    return 1;
}
TOLUA_API int register_all_cpp_comp_uitableviewex(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_comp_uitableviewex_UITableViewEx(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

