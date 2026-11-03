#include "scripting/lua-bindings/auto/lua_cpp_comp_uiscrollviewzoom_auto.hpp"
#include "../../../../../runtime-src/Classes/Comp/UIScrollViewZoom.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getShowMaxScale(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIScrollViewZoom*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getShowMaxScale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getShowMaxScale'", nullptr);
            return 0;
        }
        double ret = cobj->getShowMaxScale();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:getShowMaxScale",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getShowMaxScale'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getShowMinScale(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIScrollViewZoom*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getShowMinScale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getShowMinScale'", nullptr);
            return 0;
        }
        double ret = cobj->getShowMinScale();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:getShowMinScale",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getShowMinScale'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getZoomViewRect(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIScrollViewZoom*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getZoomViewRect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getZoomViewRect'", nullptr);
            return 0;
        }
        cocos2d::Rect ret = cobj->getZoomViewRect();
        rect_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:getZoomViewRect",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getZoomViewRect'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchEnded(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIScrollViewZoom*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchEnded'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Touch* arg0;
        cocos2d::Event* arg1;

        ok &= luaval_to_object<cocos2d::Touch>(tolua_S, 2, "cc.Touch",&arg0, "UIScrollViewZoom:onTouchEnded");

        ok &= luaval_to_object<cocos2d::Event>(tolua_S, 3, "cc.Event",&arg1, "UIScrollViewZoom:onTouchEnded");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchEnded'", nullptr);
            return 0;
        }
        cobj->onTouchEnded(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:onTouchEnded",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchEnded'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setContentOffsetInDuration(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIScrollViewZoom*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setContentOffsetInDuration'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Point arg0;
        double arg1;

        ok &= luaval_to_point(tolua_S, 2, &arg0, "UIScrollViewZoom:setContentOffsetInDuration");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "UIScrollViewZoom:setContentOffsetInDuration");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setContentOffsetInDuration'", nullptr);
            return 0;
        }
        cobj->setContentOffsetInDuration(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:setContentOffsetInDuration",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setContentOffsetInDuration'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setShowMinScale(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIScrollViewZoom*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setShowMinScale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIScrollViewZoom:setShowMinScale");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setShowMinScale'", nullptr);
            return 0;
        }
        cobj->setShowMinScale(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:setShowMinScale",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setShowMinScale'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchMoved(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIScrollViewZoom*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchMoved'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Touch* arg0;
        cocos2d::Event* arg1;

        ok &= luaval_to_object<cocos2d::Touch>(tolua_S, 2, "cc.Touch",&arg0, "UIScrollViewZoom:onTouchMoved");

        ok &= luaval_to_object<cocos2d::Event>(tolua_S, 3, "cc.Event",&arg1, "UIScrollViewZoom:onTouchMoved");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchMoved'", nullptr);
            return 0;
        }
        cobj->onTouchMoved(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:onTouchMoved",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchMoved'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getMaxScale(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIScrollViewZoom*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getMaxScale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getMaxScale'", nullptr);
            return 0;
        }
        double ret = cobj->getMaxScale();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:getMaxScale",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getMaxScale'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setShowMaxScale(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIScrollViewZoom*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setShowMaxScale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIScrollViewZoom:setShowMaxScale");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setShowMaxScale'", nullptr);
            return 0;
        }
        cobj->setShowMaxScale(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:setShowMaxScale",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setShowMaxScale'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchCancelled(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIScrollViewZoom*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchCancelled'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Touch* arg0;
        cocos2d::Event* arg1;

        ok &= luaval_to_object<cocos2d::Touch>(tolua_S, 2, "cc.Touch",&arg0, "UIScrollViewZoom:onTouchCancelled");

        ok &= luaval_to_object<cocos2d::Event>(tolua_S, 3, "cc.Event",&arg1, "UIScrollViewZoom:onTouchCancelled");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchCancelled'", nullptr);
            return 0;
        }
        cobj->onTouchCancelled(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:onTouchCancelled",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchCancelled'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setMaxScale(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIScrollViewZoom*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setMaxScale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIScrollViewZoom:setMaxScale");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setMaxScale'", nullptr);
            return 0;
        }
        cobj->setMaxScale(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:setMaxScale",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setMaxScale'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getMoveSpeed(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIScrollViewZoom*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getMoveSpeed'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getMoveSpeed'", nullptr);
            return 0;
        }
        double ret = cobj->getMoveSpeed();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:getMoveSpeed",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getMoveSpeed'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setSwallowsTouches(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIScrollViewZoom*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setSwallowsTouches'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "UIScrollViewZoom:setSwallowsTouches");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setSwallowsTouches'", nullptr);
            return 0;
        }
        cobj->setSwallowsTouches(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:setSwallowsTouches",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setSwallowsTouches'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setMoveSpeed(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIScrollViewZoom*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setMoveSpeed'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIScrollViewZoom:setMoveSpeed");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setMoveSpeed'", nullptr);
            return 0;
        }
        cobj->setMoveSpeed(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:setMoveSpeed",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setMoveSpeed'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getCanHandle(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIScrollViewZoom*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getCanHandle'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getCanHandle'", nullptr);
            return 0;
        }
        bool ret = cobj->getCanHandle();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:getCanHandle",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getCanHandle'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setCanHandle(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIScrollViewZoom*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setCanHandle'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "UIScrollViewZoom:setCanHandle");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setCanHandle'", nullptr);
            return 0;
        }
        cobj->setCanHandle(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:setCanHandle",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setCanHandle'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setMinScale(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIScrollViewZoom*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setMinScale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIScrollViewZoom:setMinScale");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setMinScale'", nullptr);
            return 0;
        }
        cobj->setMinScale(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:setMinScale",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setMinScale'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchBegan(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIScrollViewZoom*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchBegan'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Touch* arg0;
        cocos2d::Event* arg1;

        ok &= luaval_to_object<cocos2d::Touch>(tolua_S, 2, "cc.Touch",&arg0, "UIScrollViewZoom:onTouchBegan");

        ok &= luaval_to_object<cocos2d::Event>(tolua_S, 3, "cc.Event",&arg1, "UIScrollViewZoom:onTouchBegan");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchBegan'", nullptr);
            return 0;
        }
        bool ret = cobj->onTouchBegan(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:onTouchBegan",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchBegan'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getMinScale(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIScrollViewZoom*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getMinScale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getMinScale'", nullptr);
            return 0;
        }
        double ret = cobj->getMinScale();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:getMinScale",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getMinScale'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UIScrollViewZoom",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S)-1;

    do 
    {
        if (argc == 1)
        {
            cocos2d::Size arg0;
            ok &= luaval_to_size(tolua_S, 2, &arg0, "UIScrollViewZoom:create");
            if (!ok) { break; }
            UIScrollViewZoom* ret = UIScrollViewZoom::create(arg0);
            object_to_luaval<UIScrollViewZoom>(tolua_S, "UIScrollViewZoom",(UIScrollViewZoom*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    do 
    {
        if (argc == 0)
        {
            UIScrollViewZoom* ret = UIScrollViewZoom::create();
            object_to_luaval<UIScrollViewZoom>(tolua_S, "UIScrollViewZoom",(UIScrollViewZoom*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d", "UIScrollViewZoom:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UIScrollViewZoom* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_constructor'", nullptr);
            return 0;
        }
        cobj = new UIScrollViewZoom();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UIScrollViewZoom");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIScrollViewZoom:UIScrollViewZoom",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UIScrollViewZoom)");
    return 0;
}

int lua_register_cpp_comp_uiscrollviewzoom_UIScrollViewZoom(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UIScrollViewZoom");
    tolua_cclass(tolua_S,"UIScrollViewZoom","UIScrollViewZoom","cc.ScrollView",nullptr);

    tolua_beginmodule(tolua_S,"UIScrollViewZoom");
        tolua_function(tolua_S,"new",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_constructor);
        tolua_function(tolua_S,"getShowMaxScale",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getShowMaxScale);
        tolua_function(tolua_S,"getShowMinScale",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getShowMinScale);
        tolua_function(tolua_S,"getZoomViewRect",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getZoomViewRect);
        tolua_function(tolua_S,"onTouchEnded",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchEnded);
        tolua_function(tolua_S,"setContentOffsetInDuration",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setContentOffsetInDuration);
        tolua_function(tolua_S,"setShowMinScale",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setShowMinScale);
        tolua_function(tolua_S,"onTouchMoved",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchMoved);
        tolua_function(tolua_S,"getMaxScale",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getMaxScale);
        tolua_function(tolua_S,"setShowMaxScale",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setShowMaxScale);
        tolua_function(tolua_S,"onTouchCancelled",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchCancelled);
        tolua_function(tolua_S,"setMaxScale",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setMaxScale);
        tolua_function(tolua_S,"getMoveSpeed",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getMoveSpeed);
        tolua_function(tolua_S,"setSwallowsTouches",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setSwallowsTouches);
        tolua_function(tolua_S,"setMoveSpeed",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setMoveSpeed);
        tolua_function(tolua_S,"getCanHandle",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getCanHandle);
        tolua_function(tolua_S,"setCanHandle",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setCanHandle);
        tolua_function(tolua_S,"setMinScale",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_setMinScale);
        tolua_function(tolua_S,"onTouchBegan",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_onTouchBegan);
        tolua_function(tolua_S,"getMinScale",lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_getMinScale);
        tolua_function(tolua_S,"create", lua_cpp_comp_uiscrollviewzoom_UIScrollViewZoom_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UIScrollViewZoom).name();
    g_luaType[typeName] = "UIScrollViewZoom";
    g_typeCast["UIScrollViewZoom"] = "UIScrollViewZoom";
    return 1;
}
TOLUA_API int register_all_cpp_comp_uiscrollviewzoom(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_comp_uiscrollviewzoom_UIScrollViewZoom(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

