#include "lua_cpp_comp_menu_uimenu_auto.hpp"
#include "../../../../../runtime-src/Classes/Comp/Menu/UIMenu.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"


int lua_cpp_comp_menu_uimenu_UIMenu_initWithArray(lua_State* tolua_S)
{
    int argc = 0;
    UIMenu* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenu",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenu*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenu_UIMenu_initWithArray'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Vector<cocos2d::MenuItem *> arg0;

        ok &= luaval_to_ccvector(tolua_S, 2, &arg0, "UIMenu:initWithArray");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenu_UIMenu_initWithArray'", nullptr);
            return 0;
        }
        bool ret = cobj->initWithArray(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenu:initWithArray",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenu_UIMenu_initWithArray'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenu_UIMenu_onTouchMoved(lua_State* tolua_S)
{
    int argc = 0;
    UIMenu* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenu",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenu*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenu_UIMenu_onTouchMoved'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Touch* arg0;
        cocos2d::Event* arg1;

        ok &= luaval_to_object<cocos2d::Touch>(tolua_S, 2, "cc.Touch",&arg0, "UIMenu:onTouchMoved");

        ok &= luaval_to_object<cocos2d::Event>(tolua_S, 3, "cc.Event",&arg1, "UIMenu:onTouchMoved");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenu_UIMenu_onTouchMoved'", nullptr);
            return 0;
        }
        cobj->onTouchMoved(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenu:onTouchMoved",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenu_UIMenu_onTouchMoved'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenu_UIMenu_onTouchEnded(lua_State* tolua_S)
{
    int argc = 0;
    UIMenu* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenu",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenu*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenu_UIMenu_onTouchEnded'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Touch* arg0;
        cocos2d::Event* arg1;

        ok &= luaval_to_object<cocos2d::Touch>(tolua_S, 2, "cc.Touch",&arg0, "UIMenu:onTouchEnded");

        ok &= luaval_to_object<cocos2d::Event>(tolua_S, 3, "cc.Event",&arg1, "UIMenu:onTouchEnded");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenu_UIMenu_onTouchEnded'", nullptr);
            return 0;
        }
        cobj->onTouchEnded(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenu:onTouchEnded",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenu_UIMenu_onTouchEnded'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenu_UIMenu_longPress(lua_State* tolua_S)
{
    int argc = 0;
    UIMenu* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenu",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenu*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenu_UIMenu_longPress'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenu:longPress");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenu_UIMenu_longPress'", nullptr);
            return 0;
        }
        cobj->longPress(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenu:longPress",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenu_UIMenu_longPress'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenu_UIMenu_enableLongPress(lua_State* tolua_S)
{
    int argc = 0;
    UIMenu* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenu",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenu*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenu_UIMenu_enableLongPress'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "UIMenu:enableLongPress");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenu_UIMenu_enableLongPress'", nullptr);
            return 0;
        }
        cobj->enableLongPress(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenu:enableLongPress",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenu_UIMenu_enableLongPress'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenu_UIMenu_enableDoubleClick(lua_State* tolua_S)
{
    int argc = 0;
    UIMenu* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenu",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenu*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenu_UIMenu_enableDoubleClick'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "UIMenu:enableDoubleClick");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenu_UIMenu_enableDoubleClick'", nullptr);
            return 0;
        }
        cobj->enableDoubleClick(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenu:enableDoubleClick",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenu_UIMenu_enableDoubleClick'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenu_UIMenu_doubleClickTimeOut(lua_State* tolua_S)
{
    int argc = 0;
    UIMenu* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenu",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenu*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenu_UIMenu_doubleClickTimeOut'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenu:doubleClickTimeOut");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenu_UIMenu_doubleClickTimeOut'", nullptr);
            return 0;
        }
        cobj->doubleClickTimeOut(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenu:doubleClickTimeOut",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenu_UIMenu_doubleClickTimeOut'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenu_UIMenu_onTouchBegan(lua_State* tolua_S)
{
    int argc = 0;
    UIMenu* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenu",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenu*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenu_UIMenu_onTouchBegan'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Touch* arg0;
        cocos2d::Event* arg1;

        ok &= luaval_to_object<cocos2d::Touch>(tolua_S, 2, "cc.Touch",&arg0, "UIMenu:onTouchBegan");

        ok &= luaval_to_object<cocos2d::Event>(tolua_S, 3, "cc.Event",&arg1, "UIMenu:onTouchBegan");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenu_UIMenu_onTouchBegan'", nullptr);
            return 0;
        }
        bool ret = cobj->onTouchBegan(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenu:onTouchBegan",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenu_UIMenu_onTouchBegan'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenu_UIMenu_setIsTouchInsideNode(lua_State* tolua_S)
{
    int argc = 0;
    UIMenu* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenu",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenu*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenu_UIMenu_setIsTouchInsideNode'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::extension::ScrollView* arg0;

        ok &= luaval_to_object<cocos2d::extension::ScrollView>(tolua_S, 2, "cc.ScrollView",&arg0, "UIMenu:setIsTouchInsideNode");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenu_UIMenu_setIsTouchInsideNode'", nullptr);
            return 0;
        }
        cobj->setIsTouchInsideNode(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenu:setIsTouchInsideNode",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenu_UIMenu_setIsTouchInsideNode'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenu_UIMenu_setSwallowsTouches(lua_State* tolua_S)
{
    int argc = 0;
    UIMenu* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenu",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenu*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenu_UIMenu_setSwallowsTouches'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "UIMenu:setSwallowsTouches");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenu_UIMenu_setSwallowsTouches'", nullptr);
            return 0;
        }
        cobj->setSwallowsTouches(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenu:setSwallowsTouches",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenu_UIMenu_setSwallowsTouches'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenu_UIMenu_longPressSelected(lua_State* tolua_S)
{
    int argc = 0;
    UIMenu* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenu",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenu*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenu_UIMenu_longPressSelected'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenu:longPressSelected");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenu_UIMenu_longPressSelected'", nullptr);
            return 0;
        }
        cobj->longPressSelected(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenu:longPressSelected",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenu_UIMenu_longPressSelected'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenu_UIMenu_enableLongPressRepeat(lua_State* tolua_S)
{
    int argc = 0;
    UIMenu* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenu",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenu*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenu_UIMenu_enableLongPressRepeat'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "UIMenu:enableLongPressRepeat");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenu_UIMenu_enableLongPressRepeat'", nullptr);
            return 0;
        }
        cobj->enableLongPressRepeat(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenu:enableLongPressRepeat",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenu_UIMenu_enableLongPressRepeat'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenu_UIMenu_cancelLongPressSelected(lua_State* tolua_S)
{
    int argc = 0;
    UIMenu* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenu",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenu*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenu_UIMenu_cancelLongPressSelected'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenu_UIMenu_cancelLongPressSelected'", nullptr);
            return 0;
        }
        cobj->cancelLongPressSelected();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenu:cancelLongPressSelected",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenu_UIMenu_cancelLongPressSelected'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenu_UIMenu_setLuaModel(lua_State* tolua_S)
{
    int argc = 0;
    UIMenu* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenu",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenu*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenu_UIMenu_setLuaModel'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "UIMenu:setLuaModel");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenu_UIMenu_setLuaModel'", nullptr);
            return 0;
        }
        cobj->setLuaModel(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenu:setLuaModel",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenu_UIMenu_setLuaModel'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenu_UIMenu_enableWhenMoving(lua_State* tolua_S)
{
    int argc = 0;
    UIMenu* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenu",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenu*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenu_UIMenu_enableWhenMoving'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "UIMenu:enableWhenMoving");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenu_UIMenu_enableWhenMoving'", nullptr);
            return 0;
        }
        cobj->enableWhenMoving(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenu:enableWhenMoving",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenu_UIMenu_enableWhenMoving'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenu_UIMenu_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UIMenu",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenu_UIMenu_create'", nullptr);
            return 0;
        }
        UIMenu* ret = UIMenu::create();
        object_to_luaval<UIMenu>(tolua_S, "UIMenu",(UIMenu*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UIMenu:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenu_UIMenu_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_menu_uimenu_UIMenu_createWithArray(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UIMenu",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        cocos2d::Vector<cocos2d::MenuItem *> arg0;
        ok &= luaval_to_ccvector(tolua_S, 2, &arg0, "UIMenu:createWithArray");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenu_UIMenu_createWithArray'", nullptr);
            return 0;
        }
        UIMenu* ret = UIMenu::createWithArray(arg0);
        object_to_luaval<UIMenu>(tolua_S, "UIMenu",(UIMenu*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UIMenu:createWithArray",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenu_UIMenu_createWithArray'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_menu_uimenu_UIMenu_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UIMenu* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenu_UIMenu_constructor'", nullptr);
            return 0;
        }
        cobj = new UIMenu();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UIMenu");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenu:UIMenu",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenu_UIMenu_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_comp_menu_uimenu_UIMenu_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UIMenu)");
    return 0;
}

int lua_register_cpp_comp_menu_uimenu_UIMenu(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UIMenu");
    tolua_cclass(tolua_S,"UIMenu","UIMenu","cc.Menu",nullptr);

    tolua_beginmodule(tolua_S,"UIMenu");
        tolua_function(tolua_S,"new",lua_cpp_comp_menu_uimenu_UIMenu_constructor);
        tolua_function(tolua_S,"initWithArray",lua_cpp_comp_menu_uimenu_UIMenu_initWithArray);
        tolua_function(tolua_S,"onTouchMoved",lua_cpp_comp_menu_uimenu_UIMenu_onTouchMoved);
        tolua_function(tolua_S,"onTouchEnded",lua_cpp_comp_menu_uimenu_UIMenu_onTouchEnded);
        tolua_function(tolua_S,"longPress",lua_cpp_comp_menu_uimenu_UIMenu_longPress);
        tolua_function(tolua_S,"enableLongPress",lua_cpp_comp_menu_uimenu_UIMenu_enableLongPress);
        tolua_function(tolua_S,"enableDoubleClick",lua_cpp_comp_menu_uimenu_UIMenu_enableDoubleClick);
        tolua_function(tolua_S,"doubleClickTimeOut",lua_cpp_comp_menu_uimenu_UIMenu_doubleClickTimeOut);
        tolua_function(tolua_S,"onTouchBegan",lua_cpp_comp_menu_uimenu_UIMenu_onTouchBegan);
        tolua_function(tolua_S,"setIsTouchInsideNode",lua_cpp_comp_menu_uimenu_UIMenu_setIsTouchInsideNode);
        tolua_function(tolua_S,"setSwallowsTouches",lua_cpp_comp_menu_uimenu_UIMenu_setSwallowsTouches);
        tolua_function(tolua_S,"longPressSelected",lua_cpp_comp_menu_uimenu_UIMenu_longPressSelected);
        tolua_function(tolua_S,"enableLongPressRepeat",lua_cpp_comp_menu_uimenu_UIMenu_enableLongPressRepeat);
        tolua_function(tolua_S,"cancelLongPressSelected",lua_cpp_comp_menu_uimenu_UIMenu_cancelLongPressSelected);
        tolua_function(tolua_S,"setLuaModel",lua_cpp_comp_menu_uimenu_UIMenu_setLuaModel);
        tolua_function(tolua_S,"enableWhenMoving",lua_cpp_comp_menu_uimenu_UIMenu_enableWhenMoving);
        tolua_function(tolua_S,"create", lua_cpp_comp_menu_uimenu_UIMenu_create);
        tolua_function(tolua_S,"createWithArray", lua_cpp_comp_menu_uimenu_UIMenu_createWithArray);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UIMenu).name();
    g_luaType[typeName] = "UIMenu";
    g_typeCast["UIMenu"] = "UIMenu";
    return 1;
}
TOLUA_API int register_all_cpp_comp_menu_uimenu(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_comp_menu_uimenu_UIMenu(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

