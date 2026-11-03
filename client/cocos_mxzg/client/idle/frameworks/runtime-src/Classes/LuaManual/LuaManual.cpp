//
//  LuaManual.cpp
//  cleck
//
//  Created by hua on 2019/4/4.
//

#include "LuaManual.h"

#include "cocos2d.h"
#include "../../cocos2d-x/cocos/scripting/lua-bindings/manual/tolua_fix.h"
#include "../../cocos2d-x/cocos/scripting/lua-bindings/manual/LuaBasicConversions.h"
#include "../../cocos2d-x/cocos/scripting/lua-bindings/manual/CCLuaValue.h"
#include "cocos-ext.h"
#include "../../cocos2d-x/cocos/scripting/lua-bindings/manual/CCLuaEngine.h"
//#include "LuaScriptHandlerMgr.h"

#include "../Ctrl/Layer/LuaLayerCtr.h"
#include "../Ctrl/LuaNodeCtr.h"
#include "../Ctrl/Scene/MainSceneCtr.h"
#include "../Comp/Menu/UIMenuGeneral.h"
#include "../Net/PlatformApi.h"
#include "../Model/ByteArray.h"

#pragma mark --------LuaLayer---------
static int tolua_cocos2d_LuaLayer_registerLoadScriptHandler(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    LuaLayer* self = nullptr;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S,1,"LuaLayer",0,&tolua_err)) goto tolua_lerror;
#endif
    
    self = static_cast<LuaLayer*>(tolua_tousertype(tolua_S,1,0));
    
#if COCOS2D_DEBUG >= 1
    if (nullptr == self) {
        tolua_error(tolua_S,"invalid 'self' in function 'tolua_cocos2d_LuaLayer_registerLoadScriptHandler'\n", NULL);
        return 0;
    }
#endif
    argc = lua_gettop(tolua_S) - 1;
    if (1 == argc)
    {
#if COCOS2D_DEBUG >= 1
        if (!toluafix_isfunction(tolua_S,2,"LUA_FUNCTION",0,&tolua_err))
        {
            goto tolua_lerror;
        }
#endif
        LUA_FUNCTION handler = (  toluafix_ref_function(tolua_S,2,0));
        ScriptHandlerMgr::HandlerType handlerType = (ScriptHandlerMgr::HandlerType::EVENT_CUSTOM_BEGAN);//((int)tolua_tonumber(tolua_S,2,0) + (int)ScriptHandlerMgr::HandlerType::SCROLLVIEW_SCROLL);;
        ScriptHandlerMgr::getInstance()->addObjectHandler((void*)self, handler, handlerType);
        return 0;
    }
    
    luaL_error(tolua_S, "%s function of ScrollView has wrong number of arguments: %d, was expecting %d\n", "cpp.LuaLayer:registerLoadScriptHandler",argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_cocos2d_LuaLayer_registerLoadScriptHandler'.",&tolua_err);
    return 0;
#endif
}

static int tolua_cocos2d_LuaLayer_unregisterLoadScriptHandler(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    LuaLayer* self = nullptr;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S,1,"LuaLayer",0,&tolua_err)) goto tolua_lerror;
#endif
    
    self = static_cast<LuaLayer*>(tolua_tousertype(tolua_S,1,0));
    
#if COCOS2D_DEBUG >= 1
    if (nullptr == self) {
        tolua_error(tolua_S,"invalid 'self' in function 'tolua_cocos2d_LuaLayer_unregisterLoadScriptHandler'\n", NULL);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S) - 1;
    
    if (1 == argc)
    {
#if COCOS2D_DEBUG >= 1
        if (!tolua_isnumber(tolua_S, 2, 0, &tolua_err))
            goto tolua_lerror;
#endif
        ScriptHandlerMgr::HandlerType handlerType = (ScriptHandlerMgr::HandlerType::EVENT_CUSTOM_BEGAN);// ((int)tolua_tonumber(tolua_S,2,0) + (int)ScriptHandlerMgr::HandlerType::SCROLLVIEW_SCROLL);
        ScriptHandlerMgr::getInstance()->removeObjectHandler((void*)self, handlerType);
        return 0;
    }
    
    luaL_error(tolua_S, "%s function of LuaLayer  has wrong number of arguments: %d, was expecting %d\n", "cc.LuaLayer:unregisterScriptHandler", argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_cocos2d_LuaLayer_unregisterLoadScriptHandler'.",&tolua_err);
    return 0;
#endif
}

static void extendLuaLayer(lua_State* tolua_S)
{
    lua_pushstring(tolua_S, "LuaLayer");
    lua_rawget(tolua_S, LUA_REGISTRYINDEX);
    if (lua_istable(tolua_S,-1))
    {
        lua_pushstring(tolua_S,"registerLoadScriptHandler");
        lua_pushcfunction(tolua_S, tolua_cocos2d_LuaLayer_registerLoadScriptHandler );
        lua_rawset(tolua_S,-3);
        lua_pushstring(tolua_S,"unregisterLoadScriptHandler");
        lua_pushcfunction(tolua_S, tolua_cocos2d_LuaLayer_unregisterLoadScriptHandler );
        lua_rawset(tolua_S,-3);
    }
    lua_pop(tolua_S, 1);
}

#pragma mark --------LuaNodeCtr---------
static int tolua_cocos2d_LuaNodeCtr_registerLoadScriptHandler(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    LuaNodeCtr* self = nullptr;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S,1,"LuaNodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif
    
    self = static_cast<LuaNodeCtr*>(tolua_tousertype(tolua_S,1,0));
    
#if COCOS2D_DEBUG >= 1
    if (nullptr == self) {
        tolua_error(tolua_S,"invalid 'self' in function 'tolua_cocos2d_LuaNodeCtr_registerLoadScriptHandler'\n", NULL);
        return 0;
    }
#endif
    argc = lua_gettop(tolua_S) - 1;
    if (1 == argc)
    {
#if COCOS2D_DEBUG >= 1
        if (!toluafix_isfunction(tolua_S,2,"LUA_FUNCTION",0,&tolua_err))
        {
            goto tolua_lerror;
        }
#endif
        LUA_FUNCTION handler = (  toluafix_ref_function(tolua_S,2,0));
        ScriptHandlerMgr::HandlerType handlerType = (ScriptHandlerMgr::HandlerType::EVENT_CUSTOM_BEGAN);//((int)tolua_tonumber(tolua_S,2,0) + (int)ScriptHandlerMgr::HandlerType::SCROLLVIEW_SCROLL);;
        ScriptHandlerMgr::getInstance()->addObjectHandler((void*)self, handler, handlerType);
        return 0;
    }
    
    luaL_error(tolua_S, "%s function of ScrollView has wrong number of arguments: %d, was expecting %d\n", "cpp.LuaNodeCtr:registerLoadScriptHandler",argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_cocos2d_LuaNodeCtr_registerLoadScriptHandler'.",&tolua_err);
    return 0;
#endif
}

static int tolua_cocos2d_LuaNodeCtr_unregisterLoadScriptHandler(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    LuaNodeCtr* self = nullptr;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S,1,"LuaNodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif
    
    self = static_cast<LuaNodeCtr*>(tolua_tousertype(tolua_S,1,0));
    
#if COCOS2D_DEBUG >= 1
    if (nullptr == self) {
        tolua_error(tolua_S,"invalid 'self' in function 'tolua_cocos2d_LuaNodeCtr_unregisterLoadScriptHandler'\n", NULL);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S) - 1;
    
    if (1 == argc)
    {
#if COCOS2D_DEBUG >= 1
        if (!tolua_isnumber(tolua_S, 2, 0, &tolua_err))
            goto tolua_lerror;
#endif
        ScriptHandlerMgr::HandlerType handlerType = (ScriptHandlerMgr::HandlerType::EVENT_CUSTOM_BEGAN);// ((int)tolua_tonumber(tolua_S,2,0) + (int)ScriptHandlerMgr::HandlerType::SCROLLVIEW_SCROLL);
        ScriptHandlerMgr::getInstance()->removeObjectHandler((void*)self, handlerType);
        return 0;
    }
    
    luaL_error(tolua_S, "%s function of LuaLayer  has wrong number of arguments: %d, was expecting %d\n", "cc.LuaNodeCtr:unregisterScriptHandler", argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_cocos2d_LuaNodeCtr_unregisterLoadScriptHandler'.",&tolua_err);
    return 0;
#endif
}

static void extendLuaNodeCtr(lua_State* tolua_S)
{
    lua_pushstring(tolua_S, "LuaNodeCtr");
    lua_rawget(tolua_S, LUA_REGISTRYINDEX);
    if (lua_istable(tolua_S,-1))
    {
        lua_pushstring(tolua_S,"registerLoadScriptHandler");
        lua_pushcfunction(tolua_S, tolua_cocos2d_LuaNodeCtr_registerLoadScriptHandler );
        lua_rawset(tolua_S,-3);
        lua_pushstring(tolua_S,"unregisterLoadScriptHandler");
        lua_pushcfunction(tolua_S, tolua_cocos2d_LuaNodeCtr_unregisterLoadScriptHandler );
        lua_rawset(tolua_S,-3);
    }
    lua_pop(tolua_S, 1);
}

#pragma mark --------UIMenu---------
static int tolua_cocos2d_UIMenu_registerTouchScriptHandler(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    UIMenu* self = nullptr;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S,1,"UIMenu",0,&tolua_err)) goto tolua_lerror;
#endif
    
    self = static_cast<UIMenu*>(tolua_tousertype(tolua_S,1,0));
    
#if COCOS2D_DEBUG >= 1
    if (nullptr == self) {
        tolua_error(tolua_S,"invalid 'self' in function 'tolua_cocos2d_UIMenu_registerTouchScriptHandler'\n", NULL);
        return 0;
    }
#endif
    argc = lua_gettop(tolua_S) - 1;
    if (1 == argc)
    {
#if COCOS2D_DEBUG >= 1
        if (!toluafix_isfunction(tolua_S,2,"LUA_FUNCTION",0,&tolua_err))
        {
            goto tolua_lerror;
        }
#endif
        LUA_FUNCTION handler = (  toluafix_ref_function(tolua_S,2,0));
        ScriptHandlerMgr::HandlerType handlerType = (ScriptHandlerMgr::HandlerType::EVENT_CUSTOM_BEGAN);//((int)tolua_tonumber(tolua_S,2,0) + (int)ScriptHandlerMgr::HandlerType::SCROLLVIEW_SCROLL);;
        ScriptHandlerMgr::getInstance()->addObjectHandler((void*)self, handler, handlerType);
        return 0;
    }
    
    luaL_error(tolua_S, "%s function of ScrollView has wrong number of arguments: %d, was expecting %d\n", "cpp.UIMenu:registerTouchScriptHandler",argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_cocos2d_UIMenu_registerTouchScriptHandler'.",&tolua_err);
    return 0;
#endif
}

static int tolua_cocos2d_UIMenu_unregisterTouchScriptHandler(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    UIMenu* self = nullptr;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S,1,"UIMenu",0,&tolua_err)) goto tolua_lerror;
#endif
    
    self = static_cast<UIMenu*>(tolua_tousertype(tolua_S,1,0));
    
#if COCOS2D_DEBUG >= 1
    if (nullptr == self) {
        tolua_error(tolua_S,"invalid 'self' in function 'tolua_cocos2d_UIMenu_unregisterLoadScriptHandler'\n", NULL);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S) - 1;
    
    if (1 == argc)
    {
#if COCOS2D_DEBUG >= 1
        if (!tolua_isnumber(tolua_S, 2, 0, &tolua_err))
            goto tolua_lerror;
#endif
        ScriptHandlerMgr::HandlerType handlerType = (ScriptHandlerMgr::HandlerType::EVENT_CUSTOM_BEGAN);
        ScriptHandlerMgr::getInstance()->removeObjectHandler((void*)self, handlerType);
        return 0;
    }
    
    luaL_error(tolua_S, "%s function of ScrollView  has wrong number of arguments: %d, was expecting %d\n", "cpp.UIMenu:tolua_cocos2d_UIMenu_unregisterLoadScriptHandler", argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_cocos2d_UIMenu_unregisterLoadScriptHandler'.",&tolua_err);
    return 0;
#endif
}

static void extendUIMenu(lua_State* tolua_S)
{
    lua_pushstring(tolua_S, "UIMenu");
    lua_rawget(tolua_S, LUA_REGISTRYINDEX);
    if (lua_istable(tolua_S,-1))
    {
        lua_pushstring(tolua_S,"registerTouchScriptHandler");
        lua_pushcfunction(tolua_S, tolua_cocos2d_UIMenu_registerTouchScriptHandler );
        lua_rawset(tolua_S,-3);
        lua_pushstring(tolua_S,"unregisterTouchScriptHandler");
        lua_pushcfunction(tolua_S, tolua_cocos2d_UIMenu_unregisterTouchScriptHandler );
        lua_rawset(tolua_S,-3);
    }
    lua_pop(tolua_S, 1);
}


#pragma mark --------UIMenuGeneral---------
static int tolua_cocos2d_UIMenuGeneral_registerTouchEventScriptHandler(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    UIMenuGeneral* self = nullptr;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S,1,"UIMenuGeneral",0,&tolua_err)) goto tolua_lerror;
#endif
    
    self = static_cast<UIMenuGeneral*>(tolua_tousertype(tolua_S,1,0));
    
#if COCOS2D_DEBUG >= 1
    if (nullptr == self) {
        tolua_error(tolua_S,"invalid 'self' in function 'tolua_cocos2d_UIMenuGeneral_registerTouchEventScriptHandler'\n", NULL);
        return 0;
    }
#endif
    argc = lua_gettop(tolua_S) - 1;
    if (1 == argc)
    {
#if COCOS2D_DEBUG >= 1
        if (!toluafix_isfunction(tolua_S,2,"LUA_FUNCTION",0,&tolua_err))
        {
            goto tolua_lerror;
        }
#endif
        LUA_FUNCTION handler = (  toluafix_ref_function(tolua_S,2,0));
        ScriptHandlerMgr::HandlerType handlerType = (ScriptHandlerMgr::HandlerType::EVENT_CUSTOM_BEGAN);//((int)tolua_tonumber(tolua_S,2,0) + (int)ScriptHandlerMgr::HandlerType::SCROLLVIEW_SCROLL);;
        ScriptHandlerMgr::getInstance()->addObjectHandler((void*)self, handler, handlerType);
        return 0;
    }
    
    luaL_error(tolua_S, "%s function of UIMenuGeneral has wrong number of arguments: %d, was expecting %d\n", "cpp.UIMenuGeneral:registerTouchEventScriptHandler",argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_cocos2d_UIMenuGeneral_registerTouchScriptHandler'.",&tolua_err);
    return 0;
#endif
}

static int tolua_cocos2d_UIMenuGeneral_unregisterTouchEventScriptHandler(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    UIMenuGeneral* self = nullptr;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S,1,"UIMenuGeneral",0,&tolua_err)) goto tolua_lerror;
#endif
    
    self = static_cast<UIMenuGeneral*>(tolua_tousertype(tolua_S,1,0));
    
#if COCOS2D_DEBUG >= 1
    if (nullptr == self) {
        tolua_error(tolua_S,"invalid 'self' in function 'tolua_cocos2d_UIMenuGeneral_unregisterLoadScriptHandler'\n", NULL);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S) - 1;
    
    if (1 == argc)
    {
#if COCOS2D_DEBUG >= 1
        if (!tolua_isnumber(tolua_S, 2, 0, &tolua_err))
            goto tolua_lerror;
#endif
        ScriptHandlerMgr::HandlerType handlerType = (ScriptHandlerMgr::HandlerType::EVENT_CUSTOM_BEGAN);
        ScriptHandlerMgr::getInstance()->removeObjectHandler((void*)self, handlerType);
        return 0;
    }
    
    luaL_error(tolua_S, "%s function of ScrollView  has wrong number of arguments: %d, was expecting %d\n", "cpp.UIMenuGeneral:tolua_cocos2d_UIMenuGeneral_unregisterLoadScriptHandler", argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_cocos2d_UIMenuGeneral_unregisterLoadScriptHandler'.",&tolua_err);
    return 0;
#endif
}

static void extendUIMenuGeneral(lua_State* tolua_S)
{
    lua_pushstring(tolua_S, "UIMenuGeneral");
    lua_rawget(tolua_S, LUA_REGISTRYINDEX);
    if (lua_istable(tolua_S,-1))
    {
        lua_pushstring(tolua_S,"registerTouchEventScriptHandler");
        lua_pushcfunction(tolua_S, tolua_cocos2d_UIMenuGeneral_registerTouchEventScriptHandler);
        lua_rawset(tolua_S,-3);
        lua_pushstring(tolua_S,"unregisterTouchEventScriptHandler");
        lua_pushcfunction(tolua_S, tolua_cocos2d_UIMenuGeneral_unregisterTouchEventScriptHandler);
        lua_rawset(tolua_S,-3);
    }
    lua_pop(tolua_S, 1);
}



#pragma mark --------PlatformApi---------
static int tolua_cocos2d_PlatformApi_registerHandler(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    PlatformApi* self = nullptr;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S,1,"PlatformApi",0,&tolua_err)) goto tolua_lerror;
#endif
    
    self = static_cast<PlatformApi*>(tolua_tousertype(tolua_S,1,0));
    
#if COCOS2D_DEBUG >= 1
    if (nullptr == self) {
        tolua_error(tolua_S,"invalid 'self' in function 'tolua_cocos2d_PlatformApi_registerHandler'\n", NULL);
        return 0;
    }
#endif
    argc = lua_gettop(tolua_S) - 1;
    if (1 == argc)
    {
#if COCOS2D_DEBUG >= 1
        if (!toluafix_isfunction(tolua_S,2,"LUA_FUNCTION",0,&tolua_err))
        {
            goto tolua_lerror;
        }
#endif
        LUA_FUNCTION handler = (  toluafix_ref_function(tolua_S,2,0));
        ScriptHandlerMgr::HandlerType handlerType = (ScriptHandlerMgr::HandlerType::EVENT_CUSTOM_BEGAN);//((int)tolua_tonumber(tolua_S,2,0) + (int)ScriptHandlerMgr::HandlerType::SCROLLVIEW_SCROLL);;
        ScriptHandlerMgr::getInstance()->addObjectHandler((void*)self, handler, handlerType);
        return 0;
    }
    
    luaL_error(tolua_S, "%s function of PlatformApi has wrong number of arguments: %d, was expecting %d\n", "cpp.PlatformApi:tolua_cocos2d_PlatformApi_registerHandler",argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_cocos2d_PlatformApi_registerHandler'.",&tolua_err);
    return 0;
#endif
}

static int tolua_cocos2d_PlatformApi_unregisterHandler(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    PlatformApi* self = nullptr;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S,1,"PlatformApi",0,&tolua_err)) goto tolua_lerror;
#endif
    
    self = static_cast<PlatformApi*>(tolua_tousertype(tolua_S,1,0));
    
#if COCOS2D_DEBUG >= 1
    if (nullptr == self) {
        tolua_error(tolua_S,"invalid 'self' in function 'tolua_cocos2d_LuaBattleLayer_unregisterLoadScriptHandler'\n", NULL);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S) - 1;
    
    if (1 == argc)
    {
#if COCOS2D_DEBUG >= 1
        if (!tolua_isnumber(tolua_S, 2, 0, &tolua_err))
            goto tolua_lerror;
#endif
        ScriptHandlerMgr::HandlerType handlerType = (ScriptHandlerMgr::HandlerType::EVENT_CUSTOM_BEGAN);// ((int)tolua_tonumber(tolua_S,2,0) + (int)ScriptHandlerMgr::HandlerType::SCROLLVIEW_SCROLL);
        ScriptHandlerMgr::getInstance()->removeObjectHandler((void*)self, handlerType);
        return 0;
    }
    
    luaL_error(tolua_S, "%s function of MSLBattle  has wrong number of arguments: %d, was expecting %d\n", "cc.PlatformApi:unregisterHandler", argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_cocos2d_PlatformApi_unregisterHandler'.",&tolua_err);
    return 0;
#endif
}

static void extendPlatformApi(lua_State* tolua_S)
{
    lua_pushstring(tolua_S, "PlatformApi");
    lua_rawget(tolua_S, LUA_REGISTRYINDEX);
    if (lua_istable(tolua_S,-1))
    {
        lua_pushstring(tolua_S,"registerHandler");
        lua_pushcfunction(tolua_S, tolua_cocos2d_PlatformApi_registerHandler );
        lua_rawset(tolua_S,-3);
        lua_pushstring(tolua_S,"unregisterHandler");
        lua_pushcfunction(tolua_S, tolua_cocos2d_PlatformApi_unregisterHandler );
        lua_rawset(tolua_S,-3);
    }
    lua_pop(tolua_S, 1);
}


#pragma mark --------RichTextEx---------
static int tolua_cocos2d_RichTextEx_registerHandler(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    RichTextEx* self = nullptr;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif
    
    self = static_cast<RichTextEx*>(tolua_tousertype(tolua_S,1,0));
    
#if COCOS2D_DEBUG >= 1
    if (nullptr == self) {
        tolua_error(tolua_S,"invalid 'self' in function 'tolua_cocos2d_RichTextEx_registerHandler'\n", NULL);
        return 0;
    }
#endif
    argc = lua_gettop(tolua_S) - 1;
    if (1 == argc)
    {
#if COCOS2D_DEBUG >= 1
        if (!toluafix_isfunction(tolua_S,2,"LUA_FUNCTION",0,&tolua_err))
        {
            goto tolua_lerror;
        }
#endif
        LUA_FUNCTION handler = (  toluafix_ref_function(tolua_S,2,0));
        ScriptHandlerMgr::HandlerType handlerType = (ScriptHandlerMgr::HandlerType::EVENT_CUSTOM_BEGAN);//((int)tolua_tonumber(tolua_S,2,0) + (int)ScriptHandlerMgr::HandlerType::SCROLLVIEW_SCROLL);;
        ScriptHandlerMgr::getInstance()->addObjectHandler((void*)self, handler, handlerType);
        return 0;
    }
    
    luaL_error(tolua_S, "%s function of RichTextEx has wrong number of arguments: %d, was expecting %d\n", "cpp.PlatformApi:tolua_cocos2d_RichTextEx_registerHandler",argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_cocos2d_RichTextEx_registerHandler'.",&tolua_err);
    return 0;
#endif
}

static int tolua_cocos2d_RichTextEx_unregisterHandler(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    RichTextEx* self = nullptr;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif
    
    self = static_cast<RichTextEx*>(tolua_tousertype(tolua_S,1,0));
    
#if COCOS2D_DEBUG >= 1
    if (nullptr == self) {
        tolua_error(tolua_S,"invalid 'self' in function 'tolua_cocos2d_RichTextEx_unregisterLoadScriptHandler'\n", NULL);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S) - 1;
    
    if (1 == argc)
    {
#if COCOS2D_DEBUG >= 1
        if (!tolua_isnumber(tolua_S, 2, 0, &tolua_err))
            goto tolua_lerror;
#endif
        ScriptHandlerMgr::HandlerType handlerType = (ScriptHandlerMgr::HandlerType::EVENT_CUSTOM_BEGAN);// ((int)tolua_tonumber(tolua_S,2,0) + (int)ScriptHandlerMgr::HandlerType::SCROLLVIEW_SCROLL);
        ScriptHandlerMgr::getInstance()->removeObjectHandler((void*)self, handlerType);
        return 0;
    }
    
    luaL_error(tolua_S, "%s function of MSLBattle  has wrong number of arguments: %d, was expecting %d\n", "cc.RichTextEx:unregisterHandler", argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_cocos2d_RichTextEx_unregisterHandler'.",&tolua_err);
    return 0;
#endif
}

static void extendRichTextEx(lua_State* tolua_S)
{
    lua_pushstring(tolua_S, "RichTextEx");
    lua_rawget(tolua_S, LUA_REGISTRYINDEX);
    if (lua_istable(tolua_S,-1))
    {
        lua_pushstring(tolua_S,"registerHandler");
        lua_pushcfunction(tolua_S, tolua_cocos2d_RichTextEx_registerHandler );
        lua_rawset(tolua_S,-3);
        lua_pushstring(tolua_S,"unregisterHandler");
        lua_pushcfunction(tolua_S, tolua_cocos2d_RichTextEx_unregisterHandler );
        lua_rawset(tolua_S,-3);
    }
    lua_pop(tolua_S, 1);
}

#pragma mark --------ByteArray---------
// ByteArray
int lua_cpp_model_bytearray_ByteArray_readByteArray(lua_State* tolua_S)
{
    int argc = 0;
    ByteArray* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ByteArray",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (ByteArray*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_readByteArray'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 2)
    {
        int arg0;
        int arg1;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "ByteArray:readByteArray");
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "ByteArray:readByteArray");

        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_readByteArray'", nullptr);
            return 0;
        }
//        std::string ret = cobj->readString(arg0);
//        tolua_pushcppstring(tolua_S,ret);
        void* data = cobj->getData();
//        tolua_pushfieldstring(tolua_S, arg0, arg1, data);
//        char data[20];
//        memcpy(data, "1234567891223211133", 10);
//        data[3] = '\0';
//        void* data = (void*)"123\04567891233";
        lua_pushlstring(tolua_S, (const char*)data + arg0, arg1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:readByteArray",argc, 2);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_readByteArray'.",&tolua_err);
#endif
    
    return 0;
}



bool luaval_to_char(lua_State* L, int lo, char* outValue, size_t length, const char* funcName)
{
    if (NULL == L || NULL == outValue)
        return false;
    
    bool ok = true;
    
    tolua_Error tolua_err;
    if (!tolua_iscppstring(L,lo,0,&tolua_err))
    {
#if COCOS2D_DEBUG >=1
        luaval_to_native_err(L,"#ferror:",&tolua_err,funcName);
#endif
        ok = false;
    }
    
    if (ok)
    {
        auto tmpValue = lua_tolstring(L, lo, &length);
        memcpy(outValue, tmpValue, length);
        
    }
    return ok;
}

// ByteArray
int lua_cpp_model_bytearray_ByteArray_writeByteArray(lua_State* tolua_S)
{
    int argc = 0;
    ByteArray* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ByteArray",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (ByteArray*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_writeByteArray'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 2)
    {
        int arg1;
//        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "ByteArray:writeByteArray");
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "ByteArray:writeByteArray");
        
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_writeByteArray'", nullptr);
            return 0;
        }
        
        char* buffer = (char*)malloc(arg1);
        ok &= luaval_to_char(tolua_S, 2, buffer, arg1, "ByteArray:writeString");

        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_writeByteArray'", nullptr);
            return 0;
        }
        
        
//        ok &= luaval_to_char(tolua_S, 1, &arg0, "ByteArray:writeString");
        //        std::string ret = cobj->readString(arg0);
        //        tolua_pushcppstring(tolua_S,ret);
//        void* data = cobj->getData();
        //        tolua_pushfieldstring(tolua_S, arg0, arg1, data);
        //        char data[20];
        //        memcpy(data, "1234567891223211133", 10);
        //        data[3] = '\0';
        //        void* data = (void*)"123\04567891233";
//        lua_pushlstring(tolua_S, (const char*)data + arg0, arg1);
        
        cobj->pushData(buffer, arg1);
        
        free(buffer);
        
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:writeByteArray",argc, 2);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_writeByteArray'.",&tolua_err);
#endif
    
    return 0;
}


static void extendByteArray(lua_State* tolua_S)
{
    lua_pushstring(tolua_S, "ByteArray");
    lua_rawget(tolua_S, LUA_REGISTRYINDEX);
    if (lua_istable(tolua_S,-1))
    {
        lua_pushstring(tolua_S,"readByteArray");
        lua_pushcfunction(tolua_S, lua_cpp_model_bytearray_ByteArray_readByteArray );
        lua_rawset(tolua_S,-3);
        
        lua_pushstring(tolua_S,"writeByteArray");
        lua_pushcfunction(tolua_S, lua_cpp_model_bytearray_ByteArray_writeByteArray );
        lua_rawset(tolua_S,-3);
    }
    lua_pop(tolua_S, 1);
}



#pragma mark --------register---------
int register_all_cpp_manual(lua_State* tolua_S)
{
    extendLuaLayer(tolua_S);
    extendLuaNodeCtr(tolua_S);
    extendUIMenu(tolua_S);
    extendUIMenuGeneral(tolua_S);
    extendPlatformApi(tolua_S);
    extendRichTextEx(tolua_S);
    extendByteArray(tolua_S);
    return 0;
}

int register_cpp_module(lua_State* tolua_S)
{
    lua_getglobal(tolua_S, "_G");
    if (lua_istable(tolua_S,-1))//stack:...,_G,
    {
        register_all_cpp_manual(tolua_S);
    }
    lua_pop(tolua_S, 1);
    return 1;
}
