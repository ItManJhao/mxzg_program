#include "scripting/lua-bindings/auto/lua_cpp_ctrl_scene_mainscenectr_auto.hpp"
#include "../../../../../runtime-src/Classes/Ctrl/Scene/MainSceneCtr.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_ctrl_scene_mainscenectr_TownScene_onNodeLoaded(lua_State* tolua_S)
{
    int argc = 0;
    TownScene* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"TownScene",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (TownScene*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_TownScene_onNodeLoaded'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Node* arg0;
        cocosbuilder::NodeLoader* arg1;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "TownScene:onNodeLoaded");

        ok &= luaval_to_object<cocosbuilder::NodeLoader>(tolua_S, 3, "cc.NodeLoader",&arg1, "TownScene:onNodeLoaded");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_TownScene_onNodeLoaded'", nullptr);
            return 0;
        }
        cobj->onNodeLoaded(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "TownScene:onNodeLoaded",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_TownScene_onNodeLoaded'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_TownScene_checkScrollViewOffset(lua_State* tolua_S)
{
    int argc = 0;
    TownScene* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"TownScene",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (TownScene*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_TownScene_checkScrollViewOffset'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Point arg0;

        ok &= luaval_to_point(tolua_S, 2, &arg0, "TownScene:checkScrollViewOffset");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_TownScene_checkScrollViewOffset'", nullptr);
            return 0;
        }
        cocos2d::Point ret = cobj->checkScrollViewOffset(arg0);
        point_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "TownScene:checkScrollViewOffset",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_TownScene_checkScrollViewOffset'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_TownScene_setViewToCenterWithPos(lua_State* tolua_S)
{
    int argc = 0;
    TownScene* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"TownScene",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (TownScene*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_TownScene_setViewToCenterWithPos'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Point arg0;

        ok &= luaval_to_point(tolua_S, 2, &arg0, "TownScene:setViewToCenterWithPos");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_TownScene_setViewToCenterWithPos'", nullptr);
            return 0;
        }
        cobj->setViewToCenterWithPos(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "TownScene:setViewToCenterWithPos",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_TownScene_setViewToCenterWithPos'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_TownScene_initForMainScene(lua_State* tolua_S)
{
    int argc = 0;
    TownScene* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"TownScene",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (TownScene*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_TownScene_initForMainScene'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_TownScene_initForMainScene'", nullptr);
            return 0;
        }
        cobj->initForMainScene();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "TownScene:initForMainScene",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_TownScene_initForMainScene'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_TownScene_initForBattleScene(lua_State* tolua_S)
{
    int argc = 0;
    TownScene* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"TownScene",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (TownScene*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_TownScene_initForBattleScene'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_TownScene_initForBattleScene'", nullptr);
            return 0;
        }
        cobj->initForBattleScene();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "TownScene:initForBattleScene",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_TownScene_initForBattleScene'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_TownScene_constructor(lua_State* tolua_S)
{
    int argc = 0;
    TownScene* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_TownScene_constructor'", nullptr);
            return 0;
        }
        cobj = new TownScene();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"TownScene");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "TownScene:TownScene",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_TownScene_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_ctrl_scene_mainscenectr_TownScene_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (TownScene)");
    return 0;
}

int lua_register_cpp_ctrl_scene_mainscenectr_TownScene(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"TownScene");
    tolua_cclass(tolua_S,"TownScene","TownScene","LayerBase",nullptr);

    tolua_beginmodule(tolua_S,"TownScene");
        tolua_function(tolua_S,"new",lua_cpp_ctrl_scene_mainscenectr_TownScene_constructor);
        tolua_function(tolua_S,"onNodeLoaded",lua_cpp_ctrl_scene_mainscenectr_TownScene_onNodeLoaded);
        tolua_function(tolua_S,"checkScrollViewOffset",lua_cpp_ctrl_scene_mainscenectr_TownScene_checkScrollViewOffset);
        tolua_function(tolua_S,"setViewToCenterWithPos",lua_cpp_ctrl_scene_mainscenectr_TownScene_setViewToCenterWithPos);
        tolua_function(tolua_S,"initForMainScene",lua_cpp_ctrl_scene_mainscenectr_TownScene_initForMainScene);
        tolua_function(tolua_S,"initForBattleScene",lua_cpp_ctrl_scene_mainscenectr_TownScene_initForBattleScene);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(TownScene).name();
    g_luaType[typeName] = "TownScene";
    g_typeCast["TownScene"] = "TownScene";
    return 1;
}

int lua_cpp_ctrl_scene_mainscenectr_MainScene_onNodeCreated(lua_State* tolua_S)
{
    int argc = 0;
    MainScene* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainScene",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainScene*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainScene_onNodeCreated'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainScene_onNodeCreated'", nullptr);
            return 0;
        }
        cobj->onNodeCreated();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainScene:onNodeCreated",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainScene_onNodeCreated'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainScene_update(lua_State* tolua_S)
{
    int argc = 0;
    MainScene* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainScene",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainScene*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainScene_update'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "MainScene:update");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainScene_update'", nullptr);
            return 0;
        }
        cobj->update(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainScene:update",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainScene_update'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainScene_onExit(lua_State* tolua_S)
{
    int argc = 0;
    MainScene* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainScene",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainScene*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainScene_onExit'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainScene_onExit'", nullptr);
            return 0;
        }
        cobj->onExit();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainScene:onExit",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainScene_onExit'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainScene_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"MainScene",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainScene_create'", nullptr);
            return 0;
        }
        MainScene* ret = MainScene::create();
        object_to_luaval<MainScene>(tolua_S, "MainScene",(MainScene*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "MainScene:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainScene_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainScene_constructor(lua_State* tolua_S)
{
    int argc = 0;
    MainScene* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainScene_constructor'", nullptr);
            return 0;
        }
        cobj = new MainScene();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"MainScene");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainScene:MainScene",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainScene_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_ctrl_scene_mainscenectr_MainScene_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (MainScene)");
    return 0;
}

int lua_register_cpp_ctrl_scene_mainscenectr_MainScene(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"MainScene");
    tolua_cclass(tolua_S,"MainScene","MainScene","TownScene",nullptr);

    tolua_beginmodule(tolua_S,"MainScene");
        tolua_function(tolua_S,"new",lua_cpp_ctrl_scene_mainscenectr_MainScene_constructor);
        tolua_function(tolua_S,"onNodeCreated",lua_cpp_ctrl_scene_mainscenectr_MainScene_onNodeCreated);
        tolua_function(tolua_S,"update",lua_cpp_ctrl_scene_mainscenectr_MainScene_update);
        tolua_function(tolua_S,"onExit",lua_cpp_ctrl_scene_mainscenectr_MainScene_onExit);
        tolua_function(tolua_S,"create", lua_cpp_ctrl_scene_mainscenectr_MainScene_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(MainScene).name();
    g_luaType[typeName] = "MainScene";
    g_typeCast["MainScene"] = "MainScene";
    return 1;
}

int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_enter(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_enter'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_enter'", nullptr);
            return 0;
        }
        cobj->enter();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:enter",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_enter'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onSkin(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onSkin'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:onSkin");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onSkin'", nullptr);
            return 0;
        }
        cobj->onSkin(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onSkin",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onSkin'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_removeKeepLayer(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_removeKeepLayer'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        MainLayerType arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "MainSceneCtr:removeKeepLayer");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_removeKeepLayer'", nullptr);
            return 0;
        }
        cobj->removeKeepLayer(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:removeKeepLayer",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_removeKeepLayer'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_relogin(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_relogin'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_relogin'", nullptr);
            return 0;
        }
        cobj->relogin();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:relogin",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_relogin'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onClan(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onClan'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:onClan");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onClan'", nullptr);
            return 0;
        }
        cobj->onClan(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onClan",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onClan'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getKeepNodeType(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getKeepNodeType'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Node* arg0;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "MainSceneCtr:getKeepNodeType");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getKeepNodeType'", nullptr);
            return 0;
        }
        int ret = (int)cobj->getKeepNodeType(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:getKeepNodeType",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getKeepNodeType'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setNick(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setNick'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "MainSceneCtr:setNick");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setNick'", nullptr);
            return 0;
        }
        cobj->setNick(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:setNick",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setNick'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onFriend(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onFriend'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:onFriend");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onFriend'", nullptr);
            return 0;
        }
        cobj->onFriend(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onFriend",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onFriend'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onOther(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onOther'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:onOther");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onOther'", nullptr);
            return 0;
        }
        cobj->onOther(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onOther",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onOther'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getCurLayerType(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getCurLayerType'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getCurLayerType'", nullptr);
            return 0;
        }
        int ret = (int)cobj->getCurLayerType();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:getCurLayerType",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getCurLayerType'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onFriendChat(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onFriendChat'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        long long arg0;

        ok &= luaval_to_long_long(tolua_S, 2,&arg0, "MainSceneCtr:onFriendChat");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onFriendChat'", nullptr);
            return 0;
        }
        cobj->onFriendChat(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onFriendChat",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onFriendChat'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onChangeLayer(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onChangeLayer'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        MainLayerType arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "MainSceneCtr:onChangeLayer");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onChangeLayer'", nullptr);
            return 0;
        }
        cobj->onChangeLayer(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onChangeLayer",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onChangeLayer'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getKeepBuffer(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getKeepBuffer'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        MainLayerType arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "MainSceneCtr:getKeepBuffer");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getKeepBuffer'", nullptr);
            return 0;
        }
        cocos2d::Node* ret = cobj->getKeepBuffer(arg0);
        object_to_luaval<cocos2d::Node>(tolua_S, "cc.Node",(cocos2d::Node*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:getKeepBuffer",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getKeepBuffer'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_removeActionEnd(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_removeActionEnd'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Node* arg0;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "MainSceneCtr:removeActionEnd");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_removeActionEnd'", nullptr);
            return 0;
        }
        cobj->removeActionEnd(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:removeActionEnd",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_removeActionEnd'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setBattle(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setBattle'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        int arg0;
        int arg1;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "MainSceneCtr:setBattle");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "MainSceneCtr:setBattle");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setBattle'", nullptr);
            return 0;
        }
        cobj->setBattle(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:setBattle",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setBattle'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addGem(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addGem'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:addGem");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addGem'", nullptr);
            return 0;
        }
        cobj->addGem(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:addGem",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addGem'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_isChaning(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_isChaning'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_isChaning'", nullptr);
            return 0;
        }
        bool ret = cobj->isChaning();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:isChaning",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_isChaning'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBattleMission(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBattleMission'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:onBattleMission");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBattleMission'", nullptr);
            return 0;
        }
        cobj->onBattleMission(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onBattleMission",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBattleMission'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBattle(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBattle'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:onBattle");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBattle'", nullptr);
            return 0;
        }
        cobj->onBattle(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onBattle",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBattle'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onMainPage(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onMainPage'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:onMainPage");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onMainPage'", nullptr);
            return 0;
        }
        cobj->onMainPage(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onMainPage",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onMainPage'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_isKeepLayer(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_isKeepLayer'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        MainLayerType arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "MainSceneCtr:isKeepLayer");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_isKeepLayer'", nullptr);
            return 0;
        }
        bool ret = cobj->isKeepLayer(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:isKeepLayer",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_isKeepLayer'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_renameDone(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_renameDone'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_renameDone'", nullptr);
            return 0;
        }
        cobj->renameDone();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:renameDone",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_renameDone'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addKeepBuffer(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addKeepBuffer'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        MainLayerType arg0;
        cocos2d::Node* arg1;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "MainSceneCtr:addKeepBuffer");

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 3, "cc.Node",&arg1, "MainSceneCtr:addKeepBuffer");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addKeepBuffer'", nullptr);
            return 0;
        }
        cobj->addKeepBuffer(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:addKeepBuffer",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addKeepBuffer'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_resetScaleBtn(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_resetScaleBtn'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_resetScaleBtn'", nullptr);
            return 0;
        }
        cobj->resetScaleBtn();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:resetScaleBtn",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_resetScaleBtn'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setGem(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setGem'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        int arg0;
        int arg1;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "MainSceneCtr:setGem");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "MainSceneCtr:setGem");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setGem'", nullptr);
            return 0;
        }
        cobj->setGem(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:setGem",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setGem'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onPub(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onPub'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:onPub");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onPub'", nullptr);
            return 0;
        }
        cobj->onPub(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onPub",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onPub'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBuyGoldLua(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBuyGoldLua'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:onBuyGoldLua");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBuyGoldLua'", nullptr);
            return 0;
        }
        cobj->onBuyGoldLua(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onBuyGoldLua",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBuyGoldLua'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onRole(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onRole'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:onRole");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onRole'", nullptr);
            return 0;
        }
        cobj->onRole(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onRole",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onRole'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_didEnter(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_didEnter'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_didEnter'", nullptr);
            return 0;
        }
        cobj->didEnter();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:didEnter",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_didEnter'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getBottomHeight(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getBottomHeight'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getBottomHeight'", nullptr);
            return 0;
        }
        double ret = cobj->getBottomHeight();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:getBottomHeight",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getBottomHeight'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onMissionBattle(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onMissionBattle'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:onMissionBattle");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onMissionBattle'", nullptr);
            return 0;
        }
        cobj->onMissionBattle(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onMissionBattle",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onMissionBattle'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setLevel(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setLevel'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "MainSceneCtr:setLevel");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setLevel'", nullptr);
            return 0;
        }
        cobj->setLevel(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:setLevel",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setLevel'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_visibleMenuScale(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_visibleMenuScale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "MainSceneCtr:visibleMenuScale");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_visibleMenuScale'", nullptr);
            return 0;
        }
        cobj->visibleMenuScale(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:visibleMenuScale",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_visibleMenuScale'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addEnergy(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addEnergy'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:addEnergy");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addEnergy'", nullptr);
            return 0;
        }
        cobj->addEnergy(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:addEnergy",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addEnergy'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getMenuScaleHeight(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getMenuScaleHeight'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getMenuScaleHeight'", nullptr);
            return 0;
        }
        double ret = cobj->getMenuScaleHeight();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:getMenuScaleHeight",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getMenuScaleHeight'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onIdleTeam(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onIdleTeam'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:onIdleTeam");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onIdleTeam'", nullptr);
            return 0;
        }
        cobj->onIdleTeam(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onIdleTeam",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onIdleTeam'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onRoleLua(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onRoleLua'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:onRoleLua");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onRoleLua'", nullptr);
            return 0;
        }
        cobj->onRoleLua(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onRoleLua",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onRoleLua'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setExp(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setExp'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        int arg0;
        int arg1;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "MainSceneCtr:setExp");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "MainSceneCtr:setExp");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setExp'", nullptr);
            return 0;
        }
        cobj->setExp(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:setExp",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setExp'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addKeepLayer(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addKeepLayer'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        MainLayerType arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "MainSceneCtr:addKeepLayer");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addKeepLayer'", nullptr);
            return 0;
        }
        cobj->addKeepLayer(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:addKeepLayer",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addKeepLayer'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getCurLayer(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getCurLayer'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getCurLayer'", nullptr);
            return 0;
        }
        cocos2d::Node* ret = cobj->getCurLayer();
        object_to_luaval<cocos2d::Node>(tolua_S, "cc.Node",(cocos2d::Node*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:getCurLayer",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getCurLayer'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onChat(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onChat'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:onChat");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onChat'", nullptr);
            return 0;
        }
        cobj->onChat(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onChat",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onChat'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addGold(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addGold'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:addGold");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addGold'", nullptr);
            return 0;
        }
        cobj->addGold(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:addGold",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addGold'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_reloadConfigOne(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_reloadConfigOne'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "MainSceneCtr:reloadConfigOne");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_reloadConfigOne'", nullptr);
            return 0;
        }
        cobj->reloadConfigOne(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:reloadConfigOne",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_reloadConfigOne'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setGold(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setGold'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        long long arg0;
        long long arg1;

        ok &= luaval_to_long_long(tolua_S, 2,&arg0, "MainSceneCtr:setGold");

        ok &= luaval_to_long_long(tolua_S, 3,&arg1, "MainSceneCtr:setGold");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setGold'", nullptr);
            return 0;
        }
        cobj->setGold(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:setGold",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setGold'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setFriendShip(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setFriendShip'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "MainSceneCtr:setFriendShip");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setFriendShip'", nullptr);
            return 0;
        }
        cobj->setFriendShip(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:setFriendShip",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setFriendShip'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onExit(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onExit'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onExit'", nullptr);
            return 0;
        }
        cobj->onExit();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onExit",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onExit'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getSceneCtrType(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getSceneCtrType'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getSceneCtrType'", nullptr);
            return 0;
        }
        int ret = (int)cobj->getSceneCtrType();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:getSceneCtrType",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getSceneCtrType'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onChapterWorld(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onChapterWorld'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:onChapterWorld");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onChapterWorld'", nullptr);
            return 0;
        }
        cobj->onChapterWorld(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onChapterWorld",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onChapterWorld'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_resetChangeAct(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_resetChangeAct'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "MainSceneCtr:resetChangeAct");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_resetChangeAct'", nullptr);
            return 0;
        }
        cobj->resetChangeAct(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:resetChangeAct",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_resetChangeAct'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getMainScene(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getMainScene'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getMainScene'", nullptr);
            return 0;
        }
        MainScene* ret = cobj->getMainScene();
        object_to_luaval<MainScene>(tolua_S, "MainScene",(MainScene*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:getMainScene",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getMainScene'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBuyGemLua(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBuyGemLua'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:onBuyGemLua");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBuyGemLua'", nullptr);
            return 0;
        }
        cobj->onBuyGemLua(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onBuyGemLua",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBuyGemLua'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onIldeItemReward(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onIldeItemReward'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:onIldeItemReward");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onIldeItemReward'", nullptr);
            return 0;
        }
        cobj->onIldeItemReward(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onIldeItemReward",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onIldeItemReward'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_clearKeepLayer(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_clearKeepLayer'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_clearKeepLayer'", nullptr);
            return 0;
        }
        cobj->clearKeepLayer();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:clearKeepLayer",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_clearKeepLayer'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_reloadConfig(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_reloadConfig'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_reloadConfig'", nullptr);
            return 0;
        }
        cobj->reloadConfig();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:reloadConfig",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_reloadConfig'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onRoleInfo(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MainSceneCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onRoleInfo'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "MainSceneCtr:onRoleInfo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onRoleInfo'", nullptr);
            return 0;
        }
        cobj->onRoleInfo(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:onRoleInfo",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onRoleInfo'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_instance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_instance'", nullptr);
            return 0;
        }
        MainSceneCtr* ret = MainSceneCtr::instance();
        object_to_luaval<MainSceneCtr>(tolua_S, "MainSceneCtr",(MainSceneCtr*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "MainSceneCtr:instance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_instance'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_createTouch(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"MainSceneCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        cocos2d::Vec2 arg0;
        ok &= luaval_to_vec2(tolua_S, 2, &arg0, "MainSceneCtr:createTouch");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_createTouch'", nullptr);
            return 0;
        }
        MainSceneCtr::createTouch(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "MainSceneCtr:createTouch",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_createTouch'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_constructor(lua_State* tolua_S)
{
    int argc = 0;
    MainSceneCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_constructor'", nullptr);
            return 0;
        }
        cobj = new MainSceneCtr();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"MainSceneCtr");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MainSceneCtr:MainSceneCtr",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (MainSceneCtr)");
    return 0;
}

int lua_register_cpp_ctrl_scene_mainscenectr_MainSceneCtr(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"MainSceneCtr");
    tolua_cclass(tolua_S,"MainSceneCtr","MainSceneCtr","TownSceneCtr",nullptr);

    tolua_beginmodule(tolua_S,"MainSceneCtr");
        tolua_function(tolua_S,"new",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_constructor);
        tolua_function(tolua_S,"enter",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_enter);
        tolua_function(tolua_S,"onSkin",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onSkin);
        tolua_function(tolua_S,"removeKeepLayer",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_removeKeepLayer);
        tolua_function(tolua_S,"relogin",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_relogin);
        tolua_function(tolua_S,"onClan",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onClan);
        tolua_function(tolua_S,"getKeepNodeType",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getKeepNodeType);
        tolua_function(tolua_S,"setNick",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setNick);
        tolua_function(tolua_S,"onFriend",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onFriend);
        tolua_function(tolua_S,"onOther",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onOther);
        tolua_function(tolua_S,"getCurLayerType",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getCurLayerType);
        tolua_function(tolua_S,"onFriendChat",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onFriendChat);
        tolua_function(tolua_S,"onChangeLayer",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onChangeLayer);
        tolua_function(tolua_S,"getKeepBuffer",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getKeepBuffer);
        tolua_function(tolua_S,"removeActionEnd",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_removeActionEnd);
        tolua_function(tolua_S,"setBattle",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setBattle);
        tolua_function(tolua_S,"addGem",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addGem);
        tolua_function(tolua_S,"isChaning",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_isChaning);
        tolua_function(tolua_S,"onBattleMission",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBattleMission);
        tolua_function(tolua_S,"onBattle",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBattle);
        tolua_function(tolua_S,"onMainPage",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onMainPage);
        tolua_function(tolua_S,"isKeepLayer",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_isKeepLayer);
        tolua_function(tolua_S,"renameDone",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_renameDone);
        tolua_function(tolua_S,"addKeepBuffer",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addKeepBuffer);
        tolua_function(tolua_S,"resetScaleBtn",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_resetScaleBtn);
        tolua_function(tolua_S,"setGem",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setGem);
        tolua_function(tolua_S,"onPub",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onPub);
        tolua_function(tolua_S,"onBuyGoldLua",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBuyGoldLua);
        tolua_function(tolua_S,"onRole",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onRole);
        tolua_function(tolua_S,"didEnter",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_didEnter);
        tolua_function(tolua_S,"getBottomHeight",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getBottomHeight);
        tolua_function(tolua_S,"onMissionBattle",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onMissionBattle);
        tolua_function(tolua_S,"setLevel",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setLevel);
        tolua_function(tolua_S,"visibleMenuScale",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_visibleMenuScale);
        tolua_function(tolua_S,"addEnergy",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addEnergy);
        tolua_function(tolua_S,"getMenuScaleHeight",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getMenuScaleHeight);
        tolua_function(tolua_S,"onIdleTeam",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onIdleTeam);
        tolua_function(tolua_S,"onRoleLua",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onRoleLua);
        tolua_function(tolua_S,"setExp",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setExp);
        tolua_function(tolua_S,"addKeepLayer",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addKeepLayer);
        tolua_function(tolua_S,"getCurLayer",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getCurLayer);
        tolua_function(tolua_S,"onChat",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onChat);
        tolua_function(tolua_S,"addGold",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_addGold);
        tolua_function(tolua_S,"reloadConfigOne",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_reloadConfigOne);
        tolua_function(tolua_S,"setGold",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setGold);
        tolua_function(tolua_S,"setFriendShip",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_setFriendShip);
        tolua_function(tolua_S,"onExit",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onExit);
        tolua_function(tolua_S,"getSceneCtrType",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getSceneCtrType);
        tolua_function(tolua_S,"onChapterWorld",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onChapterWorld);
        tolua_function(tolua_S,"resetChangeAct",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_resetChangeAct);
        tolua_function(tolua_S,"getMainScene",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_getMainScene);
        tolua_function(tolua_S,"onBuyGemLua",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onBuyGemLua);
        tolua_function(tolua_S,"onIldeItemReward",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onIldeItemReward);
        tolua_function(tolua_S,"clearKeepLayer",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_clearKeepLayer);
        tolua_function(tolua_S,"reloadConfig",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_reloadConfig);
        tolua_function(tolua_S,"onRoleInfo",lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_onRoleInfo);
        tolua_function(tolua_S,"instance", lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_instance);
        tolua_function(tolua_S,"createTouch", lua_cpp_ctrl_scene_mainscenectr_MainSceneCtr_createTouch);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(MainSceneCtr).name();
    g_luaType[typeName] = "MainSceneCtr";
    g_typeCast["MainSceneCtr"] = "MainSceneCtr";
    return 1;
}
TOLUA_API int register_all_cpp_ctrl_scene_mainscenectr(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_ctrl_scene_mainscenectr_TownScene(tolua_S);
	lua_register_cpp_ctrl_scene_mainscenectr_MainScene(tolua_S);
	lua_register_cpp_ctrl_scene_mainscenectr_MainSceneCtr(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

