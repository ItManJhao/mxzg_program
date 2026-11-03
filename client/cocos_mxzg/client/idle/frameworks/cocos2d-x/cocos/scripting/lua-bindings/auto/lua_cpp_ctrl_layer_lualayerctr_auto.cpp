#include "scripting/lua-bindings/auto/lua_cpp_ctrl_layer_lualayerctr_auto.hpp"
#include "../../../../../runtime-src/Classes/Ctrl/Layer/LuaLayerCtr.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_ctrl_layer_lualayerctr_LayerBase_onNodeLoaded(lua_State* tolua_S)
{
    int argc = 0;
    LayerBase* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LayerBase",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LayerBase*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_onNodeLoaded'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Node* arg0;
        cocosbuilder::NodeLoader* arg1;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "LayerBase:onNodeLoaded");

        ok &= luaval_to_object<cocosbuilder::NodeLoader>(tolua_S, 3, "cc.NodeLoader",&arg1, "LayerBase:onNodeLoaded");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_onNodeLoaded'", nullptr);
            return 0;
        }
        cobj->onNodeLoaded(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LayerBase:onNodeLoaded",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_onNodeLoaded'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LayerBase_clearLoadedPlist(lua_State* tolua_S)
{
    int argc = 0;
    LayerBase* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LayerBase",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LayerBase*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_clearLoadedPlist'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_clearLoadedPlist'", nullptr);
            return 0;
        }
        cobj->clearLoadedPlist();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LayerBase:clearLoadedPlist",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_clearLoadedPlist'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LayerBase_isTouchInside(lua_State* tolua_S)
{
    int argc = 0;
    LayerBase* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LayerBase",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LayerBase*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_isTouchInside'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Touch* arg0;

        ok &= luaval_to_object<cocos2d::Touch>(tolua_S, 2, "cc.Touch",&arg0, "LayerBase:isTouchInside");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_isTouchInside'", nullptr);
            return 0;
        }
        bool ret = cobj->isTouchInside(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LayerBase:isTouchInside",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_isTouchInside'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LayerBase_getLoadedPlist(lua_State* tolua_S)
{
    int argc = 0;
    LayerBase* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LayerBase",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LayerBase*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_getLoadedPlist'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_getLoadedPlist'", nullptr);
            return 0;
        }
        std::vector<std::string> ret = cobj->getLoadedPlist();
        ccvector_std_string_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LayerBase:getLoadedPlist",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_getLoadedPlist'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LayerBase_onTouchBegan(lua_State* tolua_S)
{
    int argc = 0;
    LayerBase* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LayerBase",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LayerBase*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_onTouchBegan'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Touch* arg0;
        cocos2d::Event* arg1;

        ok &= luaval_to_object<cocos2d::Touch>(tolua_S, 2, "cc.Touch",&arg0, "LayerBase:onTouchBegan");

        ok &= luaval_to_object<cocos2d::Event>(tolua_S, 3, "cc.Event",&arg1, "LayerBase:onTouchBegan");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_onTouchBegan'", nullptr);
            return 0;
        }
        bool ret = cobj->onTouchBegan(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LayerBase:onTouchBegan",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_onTouchBegan'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LayerBase_shake(lua_State* tolua_S)
{
    int argc = 0;
    LayerBase* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LayerBase",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LayerBase*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_shake'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        double arg0;
        int arg1;
        double arg2;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "LayerBase:shake");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "LayerBase:shake");

        ok &= luaval_to_number(tolua_S, 4,&arg2, "LayerBase:shake");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_shake'", nullptr);
            return 0;
        }
        cobj->shake(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LayerBase:shake",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_shake'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LayerBase_setLoadedPlist(lua_State* tolua_S)
{
    int argc = 0;
    LayerBase* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LayerBase",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LayerBase*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_setLoadedPlist'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::vector<std::string> arg0;

        ok &= luaval_to_std_vector_string(tolua_S, 2, &arg0, "LayerBase:setLoadedPlist");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_setLoadedPlist'", nullptr);
            return 0;
        }
        cobj->setLoadedPlist(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LayerBase:setLoadedPlist",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_setLoadedPlist'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LayerBase_onAssignCCBMemberVariable(lua_State* tolua_S)
{
    int argc = 0;
    LayerBase* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LayerBase",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LayerBase*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_onAssignCCBMemberVariable'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        cocos2d::Ref* arg0;
        const char* arg1;
        cocos2d::Node* arg2;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "LayerBase:onAssignCCBMemberVariable");

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "LayerBase:onAssignCCBMemberVariable"); arg1 = arg1_tmp.c_str();

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 4, "cc.Node",&arg2, "LayerBase:onAssignCCBMemberVariable");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_onAssignCCBMemberVariable'", nullptr);
            return 0;
        }
        bool ret = cobj->onAssignCCBMemberVariable(arg0, arg1, arg2);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LayerBase:onAssignCCBMemberVariable",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_onAssignCCBMemberVariable'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LayerBase_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LayerBase",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_create'", nullptr);
            return 0;
        }
        LayerBase* ret = LayerBase::create();
        object_to_luaval<LayerBase>(tolua_S, "LayerBase",(LayerBase*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LayerBase:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LayerBase_constructor(lua_State* tolua_S)
{
    int argc = 0;
    LayerBase* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_constructor'", nullptr);
            return 0;
        }
        cobj = new LayerBase();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"LayerBase");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LayerBase:LayerBase",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBase_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_ctrl_layer_lualayerctr_LayerBase_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (LayerBase)");
    return 0;
}

int lua_register_cpp_ctrl_layer_lualayerctr_LayerBase(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"LayerBase");
    tolua_cclass(tolua_S,"LayerBase","LayerBase","cc.Layer",nullptr);

    tolua_beginmodule(tolua_S,"LayerBase");
        tolua_function(tolua_S,"new",lua_cpp_ctrl_layer_lualayerctr_LayerBase_constructor);
        tolua_function(tolua_S,"onNodeLoaded",lua_cpp_ctrl_layer_lualayerctr_LayerBase_onNodeLoaded);
        tolua_function(tolua_S,"clearLoadedPlist",lua_cpp_ctrl_layer_lualayerctr_LayerBase_clearLoadedPlist);
        tolua_function(tolua_S,"isTouchInside",lua_cpp_ctrl_layer_lualayerctr_LayerBase_isTouchInside);
        tolua_function(tolua_S,"getLoadedPlist",lua_cpp_ctrl_layer_lualayerctr_LayerBase_getLoadedPlist);
        tolua_function(tolua_S,"onTouchBegan",lua_cpp_ctrl_layer_lualayerctr_LayerBase_onTouchBegan);
        tolua_function(tolua_S,"shake",lua_cpp_ctrl_layer_lualayerctr_LayerBase_shake);
        tolua_function(tolua_S,"setLoadedPlist",lua_cpp_ctrl_layer_lualayerctr_LayerBase_setLoadedPlist);
        tolua_function(tolua_S,"onAssignCCBMemberVariable",lua_cpp_ctrl_layer_lualayerctr_LayerBase_onAssignCCBMemberVariable);
        tolua_function(tolua_S,"create", lua_cpp_ctrl_layer_lualayerctr_LayerBase_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(LayerBase).name();
    g_luaType[typeName] = "LayerBase";
    g_typeCast["LayerBase"] = "LayerBase";
    return 1;
}

int lua_cpp_ctrl_layer_lualayerctr_LayerBaseLoader_loader(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LayerBaseLoader",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBaseLoader_loader'", nullptr);
            return 0;
        }
        LayerBaseLoader* ret = LayerBaseLoader::loader();
        object_to_luaval<LayerBaseLoader>(tolua_S, "LayerBaseLoader",(LayerBaseLoader*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LayerBaseLoader:loader",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LayerBaseLoader_loader'.",&tolua_err);
#endif
    return 0;
}
static int lua_cpp_ctrl_layer_lualayerctr_LayerBaseLoader_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (LayerBaseLoader)");
    return 0;
}

int lua_register_cpp_ctrl_layer_lualayerctr_LayerBaseLoader(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"LayerBaseLoader");
    tolua_cclass(tolua_S,"LayerBaseLoader","LayerBaseLoader","cc.LayerLoader",nullptr);

    tolua_beginmodule(tolua_S,"LayerBaseLoader");
        tolua_function(tolua_S,"loader", lua_cpp_ctrl_layer_lualayerctr_LayerBaseLoader_loader);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(LayerBaseLoader).name();
    g_luaType[typeName] = "LayerBaseLoader";
    g_typeCast["LayerBaseLoader"] = "LayerBaseLoader";
    return 1;
}

int lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_close(lua_State* tolua_S)
{
    int argc = 0;
    UIModelLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIModelLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIModelLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_close'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_close'", nullptr);
            return 0;
        }
        cobj->close();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIModelLayer:close",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_close'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_onTouchBegan(lua_State* tolua_S)
{
    int argc = 0;
    UIModelLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIModelLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIModelLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_onTouchBegan'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Touch* arg0;
        cocos2d::Event* arg1;

        ok &= luaval_to_object<cocos2d::Touch>(tolua_S, 2, "cc.Touch",&arg0, "UIModelLayer:onTouchBegan");

        ok &= luaval_to_object<cocos2d::Event>(tolua_S, 3, "cc.Event",&arg1, "UIModelLayer:onTouchBegan");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_onTouchBegan'", nullptr);
            return 0;
        }
        bool ret = cobj->onTouchBegan(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIModelLayer:onTouchBegan",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_onTouchBegan'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_onTouchEnded(lua_State* tolua_S)
{
    int argc = 0;
    UIModelLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIModelLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIModelLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_onTouchEnded'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Touch* arg0;
        cocos2d::Event* arg1;

        ok &= luaval_to_object<cocos2d::Touch>(tolua_S, 2, "cc.Touch",&arg0, "UIModelLayer:onTouchEnded");

        ok &= luaval_to_object<cocos2d::Event>(tolua_S, 3, "cc.Event",&arg1, "UIModelLayer:onTouchEnded");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_onTouchEnded'", nullptr);
            return 0;
        }
        cobj->onTouchEnded(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIModelLayer:onTouchEnded",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_onTouchEnded'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UIModelLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_constructor'", nullptr);
            return 0;
        }
        cobj = new UIModelLayer();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UIModelLayer");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIModelLayer:UIModelLayer",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UIModelLayer)");
    return 0;
}

int lua_register_cpp_ctrl_layer_lualayerctr_UIModelLayer(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UIModelLayer");
    tolua_cclass(tolua_S,"UIModelLayer","UIModelLayer","LayerBase",nullptr);

    tolua_beginmodule(tolua_S,"UIModelLayer");
        tolua_function(tolua_S,"new",lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_constructor);
        tolua_function(tolua_S,"close",lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_close);
        tolua_function(tolua_S,"onTouchBegan",lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_onTouchBegan);
        tolua_function(tolua_S,"onTouchEnded",lua_cpp_ctrl_layer_lualayerctr_UIModelLayer_onTouchEnded);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UIModelLayer).name();
    g_luaType[typeName] = "UIModelLayer";
    g_typeCast["UIModelLayer"] = "UIModelLayer";
    return 1;
}

int lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onNodeLoaded(lua_State* tolua_S)
{
    int argc = 0;
    UIWindowLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIWindowLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIWindowLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onNodeLoaded'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Node* arg0;
        cocosbuilder::NodeLoader* arg1;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "UIWindowLayer:onNodeLoaded");

        ok &= luaval_to_object<cocosbuilder::NodeLoader>(tolua_S, 3, "cc.NodeLoader",&arg1, "UIWindowLayer:onNodeLoaded");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onNodeLoaded'", nullptr);
            return 0;
        }
        cobj->onNodeLoaded(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIWindowLayer:onNodeLoaded",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onNodeLoaded'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onTouchMoved(lua_State* tolua_S)
{
    int argc = 0;
    UIWindowLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIWindowLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIWindowLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onTouchMoved'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Touch* arg0;
        cocos2d::Event* arg1;

        ok &= luaval_to_object<cocos2d::Touch>(tolua_S, 2, "cc.Touch",&arg0, "UIWindowLayer:onTouchMoved");

        ok &= luaval_to_object<cocos2d::Event>(tolua_S, 3, "cc.Event",&arg1, "UIWindowLayer:onTouchMoved");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onTouchMoved'", nullptr);
            return 0;
        }
        cobj->onTouchMoved(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIWindowLayer:onTouchMoved",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onTouchMoved'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onTouchEnded(lua_State* tolua_S)
{
    int argc = 0;
    UIWindowLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIWindowLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIWindowLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onTouchEnded'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Touch* arg0;
        cocos2d::Event* arg1;

        ok &= luaval_to_object<cocos2d::Touch>(tolua_S, 2, "cc.Touch",&arg0, "UIWindowLayer:onTouchEnded");

        ok &= luaval_to_object<cocos2d::Event>(tolua_S, 3, "cc.Event",&arg1, "UIWindowLayer:onTouchEnded");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onTouchEnded'", nullptr);
            return 0;
        }
        cobj->onTouchEnded(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIWindowLayer:onTouchEnded",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onTouchEnded'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onTouchBegan(lua_State* tolua_S)
{
    int argc = 0;
    UIWindowLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIWindowLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIWindowLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onTouchBegan'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Touch* arg0;
        cocos2d::Event* arg1;

        ok &= luaval_to_object<cocos2d::Touch>(tolua_S, 2, "cc.Touch",&arg0, "UIWindowLayer:onTouchBegan");

        ok &= luaval_to_object<cocos2d::Event>(tolua_S, 3, "cc.Event",&arg1, "UIWindowLayer:onTouchBegan");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onTouchBegan'", nullptr);
            return 0;
        }
        bool ret = cobj->onTouchBegan(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIWindowLayer:onTouchBegan",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onTouchBegan'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_setSwallowTouches(lua_State* tolua_S)
{
    int argc = 0;
    UIWindowLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIWindowLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIWindowLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_setSwallowTouches'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "UIWindowLayer:setSwallowTouches");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_setSwallowTouches'", nullptr);
            return 0;
        }
        cobj->setSwallowTouches(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIWindowLayer:setSwallowTouches",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_setSwallowTouches'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_setAutoClose(lua_State* tolua_S)
{
    int argc = 0;
    UIWindowLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIWindowLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIWindowLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_setAutoClose'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "UIWindowLayer:setAutoClose");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_setAutoClose'", nullptr);
            return 0;
        }
        cobj->setAutoClose(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIWindowLayer:setAutoClose",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_setAutoClose'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UIWindowLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_constructor'", nullptr);
            return 0;
        }
        cobj = new UIWindowLayer();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UIWindowLayer");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIWindowLayer:UIWindowLayer",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UIWindowLayer)");
    return 0;
}

int lua_register_cpp_ctrl_layer_lualayerctr_UIWindowLayer(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UIWindowLayer");
    tolua_cclass(tolua_S,"UIWindowLayer","UIWindowLayer","UIModelLayer",nullptr);

    tolua_beginmodule(tolua_S,"UIWindowLayer");
        tolua_function(tolua_S,"new",lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_constructor);
        tolua_function(tolua_S,"onNodeLoaded",lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onNodeLoaded);
        tolua_function(tolua_S,"onTouchMoved",lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onTouchMoved);
        tolua_function(tolua_S,"onTouchEnded",lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onTouchEnded);
        tolua_function(tolua_S,"onTouchBegan",lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_onTouchBegan);
        tolua_function(tolua_S,"setSwallowTouches",lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_setSwallowTouches);
        tolua_function(tolua_S,"setAutoClose",lua_cpp_ctrl_layer_lualayerctr_UIWindowLayer_setAutoClose);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UIWindowLayer).name();
    g_luaType[typeName] = "UIWindowLayer";
    g_typeCast["UIWindowLayer"] = "UIWindowLayer";
    return 1;
}

int lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onNodeLoaded(lua_State* tolua_S)
{
    int argc = 0;
    LuaLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onNodeLoaded'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Node* arg0;
        cocosbuilder::NodeLoader* arg1;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "LuaLayer:onNodeLoaded");

        ok &= luaval_to_object<cocosbuilder::NodeLoader>(tolua_S, 3, "cc.NodeLoader",&arg1, "LuaLayer:onNodeLoaded");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onNodeLoaded'", nullptr);
            return 0;
        }
        cobj->onNodeLoaded(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaLayer:onNodeLoaded",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onNodeLoaded'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LuaLayer_getMemberList(lua_State* tolua_S)
{
    int argc = 0;
    LuaLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_getMemberList'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_getMemberList'", nullptr);
            return 0;
        }
        cocos2d::Vector<cocos2d::Node *> ret = cobj->getMemberList();
        ccvector_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaLayer:getMemberList",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_getMemberList'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onExit(lua_State* tolua_S)
{
    int argc = 0;
    LuaLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onExit'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onExit'", nullptr);
            return 0;
        }
        cobj->onExit();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaLayer:onExit",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onExit'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LuaLayer_assignCCBMemberVariable(lua_State* tolua_S)
{
    int argc = 0;
    LuaLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_assignCCBMemberVariable'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_assignCCBMemberVariable'", nullptr);
            return 0;
        }
        cobj->assignCCBMemberVariable();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaLayer:assignCCBMemberVariable",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_assignCCBMemberVariable'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LuaLayer_clearMemberList(lua_State* tolua_S)
{
    int argc = 0;
    LuaLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_clearMemberList'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_clearMemberList'", nullptr);
            return 0;
        }
        cobj->clearMemberList();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaLayer:clearMemberList",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_clearMemberList'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LuaLayer_getItemList(lua_State* tolua_S)
{
    int argc = 0;
    LuaLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_getItemList'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_getItemList'", nullptr);
            return 0;
        }
        cocos2d::Vector<cocos2d::Node *> ret = cobj->getItemList();
        ccvector_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaLayer:getItemList",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_getItemList'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LuaLayer_clearItemList(lua_State* tolua_S)
{
    int argc = 0;
    LuaLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_clearItemList'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_clearItemList'", nullptr);
            return 0;
        }
        cobj->clearItemList();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaLayer:clearItemList",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_clearItemList'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LuaLayer_clearFunctionList(lua_State* tolua_S)
{
    int argc = 0;
    LuaLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_clearFunctionList'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_clearFunctionList'", nullptr);
            return 0;
        }
        cobj->clearFunctionList();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaLayer:clearFunctionList",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_clearFunctionList'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LuaLayer_getFunctionList(lua_State* tolua_S)
{
    int argc = 0;
    LuaLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_getFunctionList'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_getFunctionList'", nullptr);
            return 0;
        }
        std::vector<std::string> ret = cobj->getFunctionList();
        ccvector_std_string_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaLayer:getFunctionList",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_getFunctionList'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onMenuItemSelector(lua_State* tolua_S)
{
    int argc = 0;
    LuaLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onMenuItemSelector'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "LuaLayer:onMenuItemSelector");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onMenuItemSelector'", nullptr);
            return 0;
        }
        cobj->onMenuItemSelector(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaLayer:onMenuItemSelector",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onMenuItemSelector'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onAssignCCBMemberVariable(lua_State* tolua_S)
{
    int argc = 0;
    LuaLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaLayer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onAssignCCBMemberVariable'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        cocos2d::Ref* arg0;
        const char* arg1;
        cocos2d::Node* arg2;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "LuaLayer:onAssignCCBMemberVariable");

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "LuaLayer:onAssignCCBMemberVariable"); arg1 = arg1_tmp.c_str();

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 4, "cc.Node",&arg2, "LuaLayer:onAssignCCBMemberVariable");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onAssignCCBMemberVariable'", nullptr);
            return 0;
        }
        bool ret = cobj->onAssignCCBMemberVariable(arg0, arg1, arg2);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaLayer:onAssignCCBMemberVariable",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onAssignCCBMemberVariable'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LuaLayer_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LuaLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_create'", nullptr);
            return 0;
        }
        LuaLayer* ret = LuaLayer::create();
        object_to_luaval<LuaLayer>(tolua_S, "LuaLayer",(LuaLayer*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LuaLayer:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LuaLayer_createWithCCBIFile(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LuaLayer",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S)-1;

    do 
    {
        if (argc == 2)
        {
            std::string arg0;
            ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LuaLayer:createWithCCBIFile");
            if (!ok) { break; }
            NodeCtr* arg1;
            ok &= luaval_to_object<NodeCtr>(tolua_S, 3, "NodeCtr",&arg1, "LuaLayer:createWithCCBIFile");
            if (!ok) { break; }
            LuaLayer* ret = LuaLayer::createWithCCBIFile(arg0, arg1);
            object_to_luaval<LuaLayer>(tolua_S, "LuaLayer",(LuaLayer*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    do 
    {
        if (argc == 1)
        {
            std::string arg0;
            ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LuaLayer:createWithCCBIFile");
            if (!ok) { break; }
            LuaLayer* ret = LuaLayer::createWithCCBIFile(arg0);
            object_to_luaval<LuaLayer>(tolua_S, "LuaLayer",(LuaLayer*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d", "LuaLayer:createWithCCBIFile",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_createWithCCBIFile'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_ctrl_layer_lualayerctr_LuaLayer_constructor(lua_State* tolua_S)
{
    int argc = 0;
    LuaLayer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_constructor'", nullptr);
            return 0;
        }
        cobj = new LuaLayer();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"LuaLayer");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaLayer:LuaLayer",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayer_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_ctrl_layer_lualayerctr_LuaLayer_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (LuaLayer)");
    return 0;
}

int lua_register_cpp_ctrl_layer_lualayerctr_LuaLayer(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"LuaLayer");
    tolua_cclass(tolua_S,"LuaLayer","LuaLayer","UIWindowLayer",nullptr);

    tolua_beginmodule(tolua_S,"LuaLayer");
        tolua_function(tolua_S,"new",lua_cpp_ctrl_layer_lualayerctr_LuaLayer_constructor);
        tolua_function(tolua_S,"onNodeLoaded",lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onNodeLoaded);
        tolua_function(tolua_S,"getMemberList",lua_cpp_ctrl_layer_lualayerctr_LuaLayer_getMemberList);
        tolua_function(tolua_S,"onExit",lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onExit);
        tolua_function(tolua_S,"assignCCBMemberVariable",lua_cpp_ctrl_layer_lualayerctr_LuaLayer_assignCCBMemberVariable);
        tolua_function(tolua_S,"clearMemberList",lua_cpp_ctrl_layer_lualayerctr_LuaLayer_clearMemberList);
        tolua_function(tolua_S,"getItemList",lua_cpp_ctrl_layer_lualayerctr_LuaLayer_getItemList);
        tolua_function(tolua_S,"clearItemList",lua_cpp_ctrl_layer_lualayerctr_LuaLayer_clearItemList);
        tolua_function(tolua_S,"clearFunctionList",lua_cpp_ctrl_layer_lualayerctr_LuaLayer_clearFunctionList);
        tolua_function(tolua_S,"getFunctionList",lua_cpp_ctrl_layer_lualayerctr_LuaLayer_getFunctionList);
        tolua_function(tolua_S,"onMenuItemSelector",lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onMenuItemSelector);
        tolua_function(tolua_S,"onAssignCCBMemberVariable",lua_cpp_ctrl_layer_lualayerctr_LuaLayer_onAssignCCBMemberVariable);
        tolua_function(tolua_S,"create", lua_cpp_ctrl_layer_lualayerctr_LuaLayer_create);
        tolua_function(tolua_S,"createWithCCBIFile", lua_cpp_ctrl_layer_lualayerctr_LuaLayer_createWithCCBIFile);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(LuaLayer).name();
    g_luaType[typeName] = "LuaLayer";
    g_typeCast["LuaLayer"] = "LuaLayer";
    return 1;
}

int lua_cpp_ctrl_layer_lualayerctr_LuaLayerLoader_loader(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LuaLayerLoader",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayerLoader_loader'", nullptr);
            return 0;
        }
        LuaLayerLoader* ret = LuaLayerLoader::loader();
        object_to_luaval<LuaLayerLoader>(tolua_S, "LuaLayerLoader",(LuaLayerLoader*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LuaLayerLoader:loader",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_layer_lualayerctr_LuaLayerLoader_loader'.",&tolua_err);
#endif
    return 0;
}
static int lua_cpp_ctrl_layer_lualayerctr_LuaLayerLoader_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (LuaLayerLoader)");
    return 0;
}

int lua_register_cpp_ctrl_layer_lualayerctr_LuaLayerLoader(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"LuaLayerLoader");
    tolua_cclass(tolua_S,"LuaLayerLoader","LuaLayerLoader","cc.LayerLoader",nullptr);

    tolua_beginmodule(tolua_S,"LuaLayerLoader");
        tolua_function(tolua_S,"loader", lua_cpp_ctrl_layer_lualayerctr_LuaLayerLoader_loader);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(LuaLayerLoader).name();
    g_luaType[typeName] = "LuaLayerLoader";
    g_typeCast["LuaLayerLoader"] = "LuaLayerLoader";
    return 1;
}
TOLUA_API int register_all_cpp_ctrl_layer_lualayerctr(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_ctrl_layer_lualayerctr_LayerBase(tolua_S);
	lua_register_cpp_ctrl_layer_lualayerctr_UIModelLayer(tolua_S);
	lua_register_cpp_ctrl_layer_lualayerctr_UIWindowLayer(tolua_S);
	lua_register_cpp_ctrl_layer_lualayerctr_LuaLayer(tolua_S);
	lua_register_cpp_ctrl_layer_lualayerctr_LuaLayerLoader(tolua_S);
	lua_register_cpp_ctrl_layer_lualayerctr_LayerBaseLoader(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

