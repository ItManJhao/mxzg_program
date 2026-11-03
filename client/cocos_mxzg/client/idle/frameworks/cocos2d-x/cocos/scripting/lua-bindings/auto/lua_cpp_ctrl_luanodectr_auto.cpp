#include "scripting/lua-bindings/auto/lua_cpp_ctrl_luanodectr_auto.hpp"
#include "../../../../../runtime-src/Classes/Ctrl/Layer/LuaLayerCtr.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_ctrl_luanodectr_NodeCtr_onNodeLoaded(lua_State* tolua_S)
{
    int argc = 0;
    NodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_NodeCtr_onNodeLoaded'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Node* arg0;
        cocosbuilder::NodeLoader* arg1;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "NodeCtr:onNodeLoaded");

        ok &= luaval_to_object<cocosbuilder::NodeLoader>(tolua_S, 3, "cc.NodeLoader",&arg1, "NodeCtr:onNodeLoaded");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_NodeCtr_onNodeLoaded'", nullptr);
            return 0;
        }
        cobj->onNodeLoaded(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NodeCtr:onNodeLoaded",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_NodeCtr_onNodeLoaded'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_NodeCtr_asynUserData(lua_State* tolua_S)
{
    int argc = 0;
    NodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_NodeCtr_asynUserData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        void* arg0;

        #pragma warning NO CONVERSION TO NATIVE FOR void*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_NodeCtr_asynUserData'", nullptr);
            return 0;
        }
        cobj->asynUserData(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NodeCtr:asynUserData",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_NodeCtr_asynUserData'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_NodeCtr_isOpened(lua_State* tolua_S)
{
    int argc = 0;
    NodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_NodeCtr_isOpened'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_NodeCtr_isOpened'", nullptr);
            return 0;
        }
        bool ret = cobj->isOpened();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NodeCtr:isOpened",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_NodeCtr_isOpened'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_NodeCtr_isSingle(lua_State* tolua_S)
{
    int argc = 0;
    NodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_NodeCtr_isSingle'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_NodeCtr_isSingle'", nullptr);
            return 0;
        }
        bool ret = cobj->isSingle();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NodeCtr:isSingle",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_NodeCtr_isSingle'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_NodeCtr_onExit(lua_State* tolua_S)
{
    int argc = 0;
    NodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_NodeCtr_onExit'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_NodeCtr_onExit'", nullptr);
            return 0;
        }
        cobj->onExit();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NodeCtr:onExit",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_NodeCtr_onExit'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_NodeCtr_setIsSingle(lua_State* tolua_S)
{
    int argc = 0;
    NodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_NodeCtr_setIsSingle'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "NodeCtr:setIsSingle");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_NodeCtr_setIsSingle'", nullptr);
            return 0;
        }
        cobj->setIsSingle(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NodeCtr:setIsSingle",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_NodeCtr_setIsSingle'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_NodeCtr_setIsAlways(lua_State* tolua_S)
{
    int argc = 0;
    NodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_NodeCtr_setIsAlways'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "NodeCtr:setIsAlways");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_NodeCtr_setIsAlways'", nullptr);
            return 0;
        }
        cobj->setIsAlways(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NodeCtr:setIsAlways",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_NodeCtr_setIsAlways'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_NodeCtr_fastClose(lua_State* tolua_S)
{
    int argc = 0;
    NodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_NodeCtr_fastClose'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_NodeCtr_fastClose'", nullptr);
            return 0;
        }
        cobj->fastClose();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NodeCtr:fastClose",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_NodeCtr_fastClose'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_NodeCtr_isAlways(lua_State* tolua_S)
{
    int argc = 0;
    NodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_NodeCtr_isAlways'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_NodeCtr_isAlways'", nullptr);
            return 0;
        }
        bool ret = cobj->isAlways();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NodeCtr:isAlways",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_NodeCtr_isAlways'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_NodeCtr_getCCBIPath(lua_State* tolua_S)
{
    int argc = 0;
    NodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_NodeCtr_getCCBIPath'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_NodeCtr_getCCBIPath'", nullptr);
            return 0;
        }
        const char* ret = cobj->getCCBIPath();
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NodeCtr:getCCBIPath",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_NodeCtr_getCCBIPath'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_NodeCtr_remove(lua_State* tolua_S)
{
    int argc = 0;
    NodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_NodeCtr_remove'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_NodeCtr_remove'", nullptr);
            return 0;
        }
        cobj->remove();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NodeCtr:remove",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_NodeCtr_remove'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_NodeCtr_close(lua_State* tolua_S)
{
    int argc = 0;
    NodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_NodeCtr_close'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_NodeCtr_close'", nullptr);
            return 0;
        }
        cobj->close(NULL);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "NodeCtr:close");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_NodeCtr_close'", nullptr);
            return 0;
        }
        cobj->close(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NodeCtr:close",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_NodeCtr_close'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_NodeCtr_getLayer(lua_State* tolua_S)
{
    int argc = 0;
    NodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_NodeCtr_getLayer'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_NodeCtr_getLayer'", nullptr);
            return 0;
        }
        LayerBase* ret = cobj->getLayer();
        object_to_luaval<LayerBase>(tolua_S, "LayerBase",(LayerBase*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NodeCtr:getLayer",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_NodeCtr_getLayer'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_NodeCtr_open(lua_State* tolua_S)
{
    int argc = 0;
    NodeCtr* cobj = nullptr;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif
    cobj = (NodeCtr*)tolua_tousertype(tolua_S,1,0);
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_NodeCtr_open'", nullptr);
        return 0;
    }
#endif
    argc = lua_gettop(tolua_S)-1;
    do{
        if (argc == 1) {
            cocos2d::Node* arg0;
            ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "NodeCtr:open");

            if (!ok) { break; }
            cobj->open(arg0);
            lua_settop(tolua_S, 1);
            return 1;
        }
    }while(0);
    ok  = true;
    do{
        if (argc == 0) {
            cobj->open();
            lua_settop(tolua_S, 1);
            return 1;
        }
    }while(0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n",  "NodeCtr:open",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_NodeCtr_open'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_NodeCtr_onAssignCCBMemberVariable(lua_State* tolua_S)
{
    int argc = 0;
    NodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_NodeCtr_onAssignCCBMemberVariable'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        cocos2d::Ref* arg0;
        const char* arg1;
        cocos2d::Node* arg2;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "NodeCtr:onAssignCCBMemberVariable");

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "NodeCtr:onAssignCCBMemberVariable"); arg1 = arg1_tmp.c_str();

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 4, "cc.Node",&arg2, "NodeCtr:onAssignCCBMemberVariable");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_NodeCtr_onAssignCCBMemberVariable'", nullptr);
            return 0;
        }
        bool ret = cobj->onAssignCCBMemberVariable(arg0, arg1, arg2);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NodeCtr:onAssignCCBMemberVariable",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_NodeCtr_onAssignCCBMemberVariable'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_NodeCtr_isOpenWindow(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"NodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "NodeCtr:isOpenWindow"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_NodeCtr_isOpenWindow'", nullptr);
            return 0;
        }
        bool ret = NodeCtr::isOpenWindow(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "NodeCtr:isOpenWindow",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_NodeCtr_isOpenWindow'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_ctrl_luanodectr_NodeCtr_allChildrenFade(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"NodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 3)
    {
        cocos2d::Node* arg0;
        double arg1;
        bool arg2;
        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "NodeCtr:allChildrenFade");
        ok &= luaval_to_number(tolua_S, 3,&arg1, "NodeCtr:allChildrenFade");
        ok &= luaval_to_boolean(tolua_S, 4,&arg2, "NodeCtr:allChildrenFade");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_NodeCtr_allChildrenFade'", nullptr);
            return 0;
        }
        NodeCtr::allChildrenFade(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "NodeCtr:allChildrenFade",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_NodeCtr_allChildrenFade'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_ctrl_luanodectr_NodeCtr_closeOtherWindow(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"NodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_NodeCtr_closeOtherWindow'", nullptr);
            return 0;
        }
        bool ret = NodeCtr::closeOtherWindow();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "NodeCtr:closeOtherWindow",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_NodeCtr_closeOtherWindow'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_ctrl_luanodectr_NodeCtr_constructor(lua_State* tolua_S)
{
    int argc = 0;
    NodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_NodeCtr_constructor'", nullptr);
            return 0;
        }
        cobj = new NodeCtr();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"NodeCtr");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NodeCtr:NodeCtr",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_NodeCtr_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_ctrl_luanodectr_NodeCtr_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (NodeCtr)");
    return 0;
}

int lua_register_cpp_ctrl_luanodectr_NodeCtr(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"NodeCtr");
    tolua_cclass(tolua_S,"NodeCtr","NodeCtr","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"NodeCtr");
        tolua_function(tolua_S,"new",lua_cpp_ctrl_luanodectr_NodeCtr_constructor);
        tolua_function(tolua_S,"onNodeLoaded",lua_cpp_ctrl_luanodectr_NodeCtr_onNodeLoaded);
        tolua_function(tolua_S,"asynUserData",lua_cpp_ctrl_luanodectr_NodeCtr_asynUserData);
        tolua_function(tolua_S,"isOpened",lua_cpp_ctrl_luanodectr_NodeCtr_isOpened);
        tolua_function(tolua_S,"isSingle",lua_cpp_ctrl_luanodectr_NodeCtr_isSingle);
        tolua_function(tolua_S,"onExit",lua_cpp_ctrl_luanodectr_NodeCtr_onExit);
        tolua_function(tolua_S,"setIsSingle",lua_cpp_ctrl_luanodectr_NodeCtr_setIsSingle);
        tolua_function(tolua_S,"setIsAlways",lua_cpp_ctrl_luanodectr_NodeCtr_setIsAlways);
        tolua_function(tolua_S,"fastClose",lua_cpp_ctrl_luanodectr_NodeCtr_fastClose);
        tolua_function(tolua_S,"isAlways",lua_cpp_ctrl_luanodectr_NodeCtr_isAlways);
        tolua_function(tolua_S,"getCCBIPath",lua_cpp_ctrl_luanodectr_NodeCtr_getCCBIPath);
        tolua_function(tolua_S,"remove",lua_cpp_ctrl_luanodectr_NodeCtr_remove);
        tolua_function(tolua_S,"close",lua_cpp_ctrl_luanodectr_NodeCtr_close);
        tolua_function(tolua_S,"getLayer",lua_cpp_ctrl_luanodectr_NodeCtr_getLayer);
        tolua_function(tolua_S,"open",lua_cpp_ctrl_luanodectr_NodeCtr_open);
        tolua_function(tolua_S,"onAssignCCBMemberVariable",lua_cpp_ctrl_luanodectr_NodeCtr_onAssignCCBMemberVariable);
        tolua_function(tolua_S,"isOpenWindow", lua_cpp_ctrl_luanodectr_NodeCtr_isOpenWindow);
        tolua_function(tolua_S,"allChildrenFade", lua_cpp_ctrl_luanodectr_NodeCtr_allChildrenFade);
        tolua_function(tolua_S,"closeOtherWindow", lua_cpp_ctrl_luanodectr_NodeCtr_closeOtherWindow);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(NodeCtr).name();
    g_luaType[typeName] = "NodeCtr";
    g_typeCast["NodeCtr"] = "NodeCtr";
    return 1;
}

int lua_cpp_ctrl_luanodectr_WindowCtr_openActionEnd(lua_State* tolua_S)
{
    int argc = 0;
    WindowCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"WindowCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (WindowCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_WindowCtr_openActionEnd'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_WindowCtr_openActionEnd'", nullptr);
            return 0;
        }
        cobj->openActionEnd();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "WindowCtr:openActionEnd",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_WindowCtr_openActionEnd'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_WindowCtr_runAction(lua_State* tolua_S)
{
    int argc = 0;
    WindowCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"WindowCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (WindowCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_WindowCtr_runAction'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "WindowCtr:runAction");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_WindowCtr_runAction'", nullptr);
            return 0;
        }
        cobj->runAction(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "WindowCtr:runAction",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_WindowCtr_runAction'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_WindowCtr_closeActionEnd(lua_State* tolua_S)
{
    int argc = 0;
    WindowCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"WindowCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (WindowCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_WindowCtr_closeActionEnd'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_WindowCtr_closeActionEnd'", nullptr);
            return 0;
        }
        cobj->closeActionEnd();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "WindowCtr:closeActionEnd",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_WindowCtr_closeActionEnd'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_WindowCtr_close(lua_State* tolua_S)
{
    int argc = 0;
    WindowCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"WindowCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (WindowCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_WindowCtr_close'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "WindowCtr:close");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_WindowCtr_close'", nullptr);
            return 0;
        }
        cobj->close(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "WindowCtr:close",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_WindowCtr_close'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_WindowCtr_open(lua_State* tolua_S)
{
    int argc = 0;
    WindowCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"WindowCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (WindowCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_WindowCtr_open'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_WindowCtr_open'", nullptr);
            return 0;
        }
        cobj->open();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "WindowCtr:open",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_WindowCtr_open'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_WindowCtr_constructor(lua_State* tolua_S)
{
    int argc = 0;
    WindowCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_WindowCtr_constructor'", nullptr);
            return 0;
        }
        cobj = new WindowCtr();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"WindowCtr");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "WindowCtr:WindowCtr",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_WindowCtr_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_ctrl_luanodectr_WindowCtr_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (WindowCtr)");
    return 0;
}

int lua_register_cpp_ctrl_luanodectr_WindowCtr(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"WindowCtr");
    tolua_cclass(tolua_S,"WindowCtr","WindowCtr","NodeCtr",nullptr);

    tolua_beginmodule(tolua_S,"WindowCtr");
        tolua_function(tolua_S,"new",lua_cpp_ctrl_luanodectr_WindowCtr_constructor);
        tolua_function(tolua_S,"openActionEnd",lua_cpp_ctrl_luanodectr_WindowCtr_openActionEnd);
        tolua_function(tolua_S,"runAction",lua_cpp_ctrl_luanodectr_WindowCtr_runAction);
        tolua_function(tolua_S,"closeActionEnd",lua_cpp_ctrl_luanodectr_WindowCtr_closeActionEnd);
        tolua_function(tolua_S,"close",lua_cpp_ctrl_luanodectr_WindowCtr_close);
        tolua_function(tolua_S,"open",lua_cpp_ctrl_luanodectr_WindowCtr_open);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(WindowCtr).name();
    g_luaType[typeName] = "WindowCtr";
    g_typeCast["WindowCtr"] = "WindowCtr";
    return 1;
}

int lua_cpp_ctrl_luanodectr_LuaNodeCtr_resolveCCBCCMenuItemSelector(lua_State* tolua_S)
{
    int argc = 0;
    LuaNodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaNodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaNodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_resolveCCBCCMenuItemSelector'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_resolveCCBCCMenuItemSelector'", nullptr);
            return 0;
        }
        cobj->resolveCCBCCMenuItemSelector();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaNodeCtr:resolveCCBCCMenuItemSelector",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_resolveCCBCCMenuItemSelector'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_LuaNodeCtr_remove(lua_State* tolua_S)
{
    int argc = 0;
    LuaNodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaNodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaNodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_remove'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_remove'", nullptr);
            return 0;
        }
        cobj->remove();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaNodeCtr:remove",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_remove'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_LuaNodeCtr_setLayer(lua_State* tolua_S)
{
    int argc = 0;
    LuaNodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaNodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaNodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_setLayer'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Node* arg0;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "LuaNodeCtr:setLayer");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_setLayer'", nullptr);
            return 0;
        }
        cobj->setLayer(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaNodeCtr:setLayer",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_setLayer'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_LuaNodeCtr_close(lua_State* tolua_S)
{
    int argc = 0;
    LuaNodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaNodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaNodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_close'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "LuaNodeCtr:close");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_close'", nullptr);
            return 0;
        }
        cobj->close(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaNodeCtr:close",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_close'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_LuaNodeCtr_setCCBIPath(lua_State* tolua_S)
{
    int argc = 0;
    LuaNodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaNodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaNodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_setCCBIPath'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LuaNodeCtr:setCCBIPath");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_setCCBIPath'", nullptr);
            return 0;
        }
        cobj->setCCBIPath(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaNodeCtr:setCCBIPath",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_setCCBIPath'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_LuaNodeCtr_onMenuItemSelector(lua_State* tolua_S)
{
    int argc = 0;
    LuaNodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaNodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaNodeCtr*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_onMenuItemSelector'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0, "LuaNodeCtr:onMenuItemSelector");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_onMenuItemSelector'", nullptr);
            return 0;
        }
        cobj->onMenuItemSelector(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaNodeCtr:onMenuItemSelector",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_onMenuItemSelector'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_ctrl_luanodectr_LuaNodeCtr_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LuaNodeCtr",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_create'", nullptr);
            return 0;
        }
        LuaNodeCtr* ret = LuaNodeCtr::create();
        object_to_luaval<LuaNodeCtr>(tolua_S, "LuaNodeCtr",(LuaNodeCtr*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LuaNodeCtr:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_ctrl_luanodectr_LuaNodeCtr_constructor(lua_State* tolua_S)
{
    int argc = 0;
    LuaNodeCtr* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_constructor'", nullptr);
            return 0;
        }
        cobj = new LuaNodeCtr();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"LuaNodeCtr");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaNodeCtr:LuaNodeCtr",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_ctrl_luanodectr_LuaNodeCtr_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_ctrl_luanodectr_LuaNodeCtr_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (LuaNodeCtr)");
    return 0;
}

int lua_register_cpp_ctrl_luanodectr_LuaNodeCtr(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"LuaNodeCtr");
    tolua_cclass(tolua_S,"LuaNodeCtr","LuaNodeCtr","WindowCtr",nullptr);

    tolua_beginmodule(tolua_S,"LuaNodeCtr");
        tolua_function(tolua_S,"new",lua_cpp_ctrl_luanodectr_LuaNodeCtr_constructor);
        tolua_function(tolua_S,"resolveCCBCCMenuItemSelector",lua_cpp_ctrl_luanodectr_LuaNodeCtr_resolveCCBCCMenuItemSelector);
        tolua_function(tolua_S,"remove",lua_cpp_ctrl_luanodectr_LuaNodeCtr_remove);
        tolua_function(tolua_S,"setLayer",lua_cpp_ctrl_luanodectr_LuaNodeCtr_setLayer);
        tolua_function(tolua_S,"close",lua_cpp_ctrl_luanodectr_LuaNodeCtr_close);
        tolua_function(tolua_S,"setCCBIPath",lua_cpp_ctrl_luanodectr_LuaNodeCtr_setCCBIPath);
        tolua_function(tolua_S,"onMenuItemSelector",lua_cpp_ctrl_luanodectr_LuaNodeCtr_onMenuItemSelector);
        tolua_function(tolua_S,"create", lua_cpp_ctrl_luanodectr_LuaNodeCtr_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(LuaNodeCtr).name();
    g_luaType[typeName] = "LuaNodeCtr";
    g_typeCast["LuaNodeCtr"] = "LuaNodeCtr";
    return 1;
}
TOLUA_API int register_all_cpp_ctrl_luanodectr(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_ctrl_luanodectr_NodeCtr(tolua_S);
	lua_register_cpp_ctrl_luanodectr_WindowCtr(tolua_S);
	lua_register_cpp_ctrl_luanodectr_LuaNodeCtr(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

