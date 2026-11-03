#include "scripting/lua-bindings/auto/lua_cpp_comp_menu_uimenuround_auto.hpp"
#include "../../../../../runtime-src/Classes/Comp/Menu/UIMenuRound.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_comp_menu_uimenuround_UIMenuRound_setSelected(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuRound* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuRound",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuRound*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_setSelected'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "UIMenuRound:setSelected");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_setSelected'", nullptr);
            return 0;
        }
        cobj->setSelected(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuRound:setSelected",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_setSelected'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuround_UIMenuRound_getItemSize(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuRound* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuRound",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuRound*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_getItemSize'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_getItemSize'", nullptr);
            return 0;
        }
        int ret = cobj->getItemSize();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuRound:getItemSize",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_getItemSize'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuround_UIMenuRound_getSelectIndex(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuRound* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuRound",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuRound*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_getSelectIndex'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_getSelectIndex'", nullptr);
            return 0;
        }
        int ret = cobj->getSelectIndex();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuRound:getSelectIndex",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_getSelectIndex'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuround_UIMenuRound_setMaxScale(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuRound* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuRound",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuRound*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_setMaxScale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenuRound:setMaxScale");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_setMaxScale'", nullptr);
            return 0;
        }
        cobj->setMaxScale(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuRound:setMaxScale",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_setMaxScale'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuround_UIMenuRound_setRoundLength(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuRound* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuRound",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuRound*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_setRoundLength'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenuRound:setRoundLength");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_setRoundLength'", nullptr);
            return 0;
        }
        cobj->setRoundLength(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuRound:setRoundLength",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_setRoundLength'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuround_UIMenuRound_roundLimit(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuRound* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuRound",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuRound*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_roundLimit'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        double arg0;
        double arg1;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenuRound:roundLimit");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "UIMenuRound:roundLimit");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_roundLimit'", nullptr);
            return 0;
        }
        double ret = cobj->roundLimit(arg0, arg1);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuRound:roundLimit",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_roundLimit'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuround_UIMenuRound_setMinScale(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuRound* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuRound",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuRound*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_setMinScale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenuRound:setMinScale");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_setMinScale'", nullptr);
            return 0;
        }
        cobj->setMinScale(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuRound:setMinScale",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_setMinScale'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuround_UIMenuRound_getRoundLength(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuRound* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuRound",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuRound*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_getRoundLength'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_getRoundLength'", nullptr);
            return 0;
        }
        double ret = cobj->getRoundLength();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuRound:getRoundLength",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_getRoundLength'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuround_UIMenuRound_setRoundHeight(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuRound* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuRound",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuRound*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_setRoundHeight'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenuRound:setRoundHeight");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_setRoundHeight'", nullptr);
            return 0;
        }
        cobj->setRoundHeight(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuRound:setRoundHeight",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_setRoundHeight'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuround_UIMenuRound_stopSomewhere(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuRound* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuRound",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuRound*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_stopSomewhere'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenuRound:stopSomewhere");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_stopSomewhere'", nullptr);
            return 0;
        }
        cobj->stopSomewhere(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuRound:stopSomewhere",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_stopSomewhere'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuround_UIMenuRound_openOpacity(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuRound* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuRound",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuRound*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_openOpacity'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_openOpacity'", nullptr);
            return 0;
        }
        cobj->openOpacity();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuRound:openOpacity",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_openOpacity'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuround_UIMenuRound_getItem(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuRound* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuRound",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuRound*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_getItem'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "UIMenuRound:getItem");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_getItem'", nullptr);
            return 0;
        }
        cocos2d::MenuItem* ret = cobj->getItem(arg0);
        object_to_luaval<cocos2d::MenuItem>(tolua_S, "cc.MenuItem",(cocos2d::MenuItem*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuRound:getItem",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_getItem'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuround_UIMenuRound_deaccelerateScrolling(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuRound* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuRound",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuRound*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_deaccelerateScrolling'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenuRound:deaccelerateScrolling");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_deaccelerateScrolling'", nullptr);
            return 0;
        }
        cobj->deaccelerateScrolling(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuRound:deaccelerateScrolling",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_deaccelerateScrolling'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuround_UIMenuRound_pushItem(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuRound* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuRound",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuRound*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_pushItem'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::MenuItem* arg0;

        ok &= luaval_to_object<cocos2d::MenuItem>(tolua_S, 2, "cc.MenuItem",&arg0, "UIMenuRound:pushItem");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_pushItem'", nullptr);
            return 0;
        }
        cobj->pushItem(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuRound:pushItem",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_pushItem'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuround_UIMenuRound_updateRound(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuRound* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuRound",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuRound*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_updateRound'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_updateRound'", nullptr);
            return 0;
        }
        cobj->updateRound();
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenuRound:updateRound");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_updateRound'", nullptr);
            return 0;
        }
        cobj->updateRound(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuRound:updateRound",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_updateRound'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuround_UIMenuRound_scrollToPoint(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuRound* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuRound",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuRound*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_scrollToPoint'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenuRound:scrollToPoint");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_scrollToPoint'", nullptr);
            return 0;
        }
        cobj->scrollToPoint(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuRound:scrollToPoint",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_scrollToPoint'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuround_UIMenuRound_setMinOpacity(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuRound* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuRound",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuRound*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_setMinOpacity'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenuRound:setMinOpacity");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_setMinOpacity'", nullptr);
            return 0;
        }
        cobj->setMinOpacity(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuRound:setMinOpacity",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_setMinOpacity'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuround_UIMenuRound_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UIMenuRound",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_create'", nullptr);
            return 0;
        }
        UIMenuRound* ret = UIMenuRound::create();
        object_to_luaval<UIMenuRound>(tolua_S, "UIMenuRound",(UIMenuRound*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UIMenuRound:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_menu_uimenuround_UIMenuRound_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuRound* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_constructor'", nullptr);
            return 0;
        }
        cobj = new UIMenuRound();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UIMenuRound");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuRound:UIMenuRound",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuround_UIMenuRound_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_comp_menu_uimenuround_UIMenuRound_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UIMenuRound)");
    return 0;
}

int lua_register_cpp_comp_menu_uimenuround_UIMenuRound(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UIMenuRound");
    tolua_cclass(tolua_S,"UIMenuRound","UIMenuRound","cc.Layer",nullptr);

    tolua_beginmodule(tolua_S,"UIMenuRound");
        tolua_function(tolua_S,"new",lua_cpp_comp_menu_uimenuround_UIMenuRound_constructor);
        tolua_function(tolua_S,"setSelected",lua_cpp_comp_menu_uimenuround_UIMenuRound_setSelected);
        tolua_function(tolua_S,"getItemSize",lua_cpp_comp_menu_uimenuround_UIMenuRound_getItemSize);
        tolua_function(tolua_S,"getSelectIndex",lua_cpp_comp_menu_uimenuround_UIMenuRound_getSelectIndex);
        tolua_function(tolua_S,"setMaxScale",lua_cpp_comp_menu_uimenuround_UIMenuRound_setMaxScale);
        tolua_function(tolua_S,"setRoundLength",lua_cpp_comp_menu_uimenuround_UIMenuRound_setRoundLength);
        tolua_function(tolua_S,"roundLimit",lua_cpp_comp_menu_uimenuround_UIMenuRound_roundLimit);
        tolua_function(tolua_S,"setMinScale",lua_cpp_comp_menu_uimenuround_UIMenuRound_setMinScale);
        tolua_function(tolua_S,"getRoundLength",lua_cpp_comp_menu_uimenuround_UIMenuRound_getRoundLength);
        tolua_function(tolua_S,"setRoundHeight",lua_cpp_comp_menu_uimenuround_UIMenuRound_setRoundHeight);
        tolua_function(tolua_S,"stopSomewhere",lua_cpp_comp_menu_uimenuround_UIMenuRound_stopSomewhere);
        tolua_function(tolua_S,"openOpacity",lua_cpp_comp_menu_uimenuround_UIMenuRound_openOpacity);
        tolua_function(tolua_S,"getItem",lua_cpp_comp_menu_uimenuround_UIMenuRound_getItem);
        tolua_function(tolua_S,"deaccelerateScrolling",lua_cpp_comp_menu_uimenuround_UIMenuRound_deaccelerateScrolling);
        tolua_function(tolua_S,"pushItem",lua_cpp_comp_menu_uimenuround_UIMenuRound_pushItem);
        tolua_function(tolua_S,"updateRound",lua_cpp_comp_menu_uimenuround_UIMenuRound_updateRound);
        tolua_function(tolua_S,"scrollToPoint",lua_cpp_comp_menu_uimenuround_UIMenuRound_scrollToPoint);
        tolua_function(tolua_S,"setMinOpacity",lua_cpp_comp_menu_uimenuround_UIMenuRound_setMinOpacity);
        tolua_function(tolua_S,"create", lua_cpp_comp_menu_uimenuround_UIMenuRound_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UIMenuRound).name();
    g_luaType[typeName] = "UIMenuRound";
    g_typeCast["UIMenuRound"] = "UIMenuRound";
    return 1;
}
TOLUA_API int register_all_cpp_comp_menu_uimenuround(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_comp_menu_uimenuround_UIMenuRound(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

