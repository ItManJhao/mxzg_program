#include "scripting/lua-bindings/auto/lua_cpp_comp_menu_uimenuitemscale_auto.hpp"
#include "../../../../../runtime-src/Classes/Comp/Menu/UIMenuItemScale.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_getScaleStep(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemScale* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemScale",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemScale*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_getScaleStep'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_getScaleStep'", nullptr);
            return 0;
        }
        double ret = cobj->getScaleStep();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemScale:getScaleStep",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_getScaleStep'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_initDone(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemScale* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemScale",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemScale*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_initDone'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenuItemScale:initDone");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_initDone'", nullptr);
            return 0;
        }
        cobj->initDone(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemScale:initDone",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_initDone'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setChecked(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemScale* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemScale",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemScale*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setChecked'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "UIMenuItemScale:setChecked");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setChecked'", nullptr);
            return 0;
        }
        cobj->setChecked(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemScale:setChecked",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setChecked'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_update(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemScale* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemScale",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemScale*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_update'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenuItemScale:update");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_update'", nullptr);
            return 0;
        }
        cobj->update(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemScale:update",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_update'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setInitPos(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemScale* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemScale",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemScale*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setInitPos'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Vec2 arg0;

        ok &= luaval_to_vec2(tolua_S, 2, &arg0, "UIMenuItemScale:setInitPos");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setInitPos'", nullptr);
            return 0;
        }
        cobj->setInitPos(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemScale:setInitPos",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setInitPos'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_getOScale(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemScale* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemScale",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemScale*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_getOScale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_getOScale'", nullptr);
            return 0;
        }
        double ret = cobj->getOScale();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemScale:getOScale",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_getOScale'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setOScale(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemScale* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemScale",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemScale*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setOScale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenuItemScale:setOScale");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setOScale'", nullptr);
            return 0;
        }
        cobj->setOScale(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemScale:setOScale",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setOScale'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setScaleStep(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemScale* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemScale",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemScale*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setScaleStep'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenuItemScale:setScaleStep");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setScaleStep'", nullptr);
            return 0;
        }
        cobj->setScaleStep(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemScale:setScaleStep",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setScaleStep'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UIMenuItemScale",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S)-1;

    do 
    {
        if (argc == 4)
        {
            std::string arg0;
            ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UIMenuItemScale:create");
            if (!ok) { break; }
            std::string arg1;
            ok &= luaval_to_std_string(tolua_S, 3,&arg1, "UIMenuItemScale:create");
            if (!ok) { break; }
            double arg2;
            ok &= luaval_to_number(tolua_S, 4,&arg2, "UIMenuItemScale:create");
            if (!ok) { break; }
            std::function<void (cocos2d::Ref *)> arg3;
            do {
			// Lambda binding for lua is not supported.
//            assert(false);
		} while(0)
		;
            if (!ok) { break; }
            UIMenuItemScale* ret = UIMenuItemScale::create(arg0, arg1, arg2, arg3);
            object_to_luaval<UIMenuItemScale>(tolua_S, "UIMenuItemScale",(UIMenuItemScale*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    do 
    {
        if (argc == 0)
        {
            UIMenuItemScale* ret = UIMenuItemScale::create();
            object_to_luaval<UIMenuItemScale>(tolua_S, "UIMenuItemScale",(UIMenuItemScale*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d", "UIMenuItemScale:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemScale* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_constructor'", nullptr);
            return 0;
        }
        cobj = new UIMenuItemScale();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UIMenuItemScale");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemScale:UIMenuItemScale",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UIMenuItemScale)");
    return 0;
}

int lua_register_cpp_comp_menu_uimenuitemscale_UIMenuItemScale(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UIMenuItemScale");
    tolua_cclass(tolua_S,"UIMenuItemScale","UIMenuItemScale","UIMenuItemTab",nullptr);

    tolua_beginmodule(tolua_S,"UIMenuItemScale");
        tolua_function(tolua_S,"new",lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_constructor);
        tolua_function(tolua_S,"getScaleStep",lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_getScaleStep);
        tolua_function(tolua_S,"initDone",lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_initDone);
        tolua_function(tolua_S,"setChecked",lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setChecked);
        tolua_function(tolua_S,"update",lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_update);
        tolua_function(tolua_S,"setInitPos",lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setInitPos);
        tolua_function(tolua_S,"getOScale",lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_getOScale);
        tolua_function(tolua_S,"setOScale",lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setOScale);
        tolua_function(tolua_S,"setScaleStep",lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_setScaleStep);
        tolua_function(tolua_S,"create", lua_cpp_comp_menu_uimenuitemscale_UIMenuItemScale_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UIMenuItemScale).name();
    g_luaType[typeName] = "UIMenuItemScale";
    g_typeCast["UIMenuItemScale"] = "UIMenuItemScale";
    return 1;
}
TOLUA_API int register_all_cpp_comp_menu_uimenuitemscale(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_comp_menu_uimenuitemscale_UIMenuItemScale(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

