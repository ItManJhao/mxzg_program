#include "scripting/lua-bindings/auto/lua_cpp_comp_menu_uimenugeneral_auto.hpp"
#include "../../../../../runtime-src/Classes/Comp/Menu/UIMenuGeneral.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_addChild(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuGeneral* cobj = nullptr;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuGeneral",0,&tolua_err)) goto tolua_lerror;
#endif
    cobj = (UIMenuGeneral*)tolua_tousertype(tolua_S,1,0);
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_addChild'", nullptr);
        return 0;
    }
#endif
    argc = lua_gettop(tolua_S)-1;
    do{
        if (argc == 2) {
            cocos2d::Node* arg0;
            ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "UIMenuGeneral:addChild");

            if (!ok) { break; }
            int arg1;
            ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "UIMenuGeneral:addChild");

            if (!ok) { break; }
            cobj->addChild(arg0, arg1);
            lua_settop(tolua_S, 1);
            return 1;
        }
    }while(0);
    ok  = true;
    do{
        if (argc == 1) {
            cocos2d::Node* arg0;
            ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "UIMenuGeneral:addChild");

            if (!ok) { break; }
            cobj->addChild(arg0);
            lua_settop(tolua_S, 1);
            return 1;
        }
    }while(0);
    ok  = true;
    do{
        if (argc == 3) {
            cocos2d::Node* arg0;
            ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "UIMenuGeneral:addChild");

            if (!ok) { break; }
            int arg1;
            ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "UIMenuGeneral:addChild");

            if (!ok) { break; }
            int arg2;
            ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "UIMenuGeneral:addChild");

            if (!ok) { break; }
            cobj->addChild(arg0, arg1, arg2);
            lua_settop(tolua_S, 1);
            return 1;
        }
    }while(0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n",  "UIMenuGeneral:addChild",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_addChild'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchEnded(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuGeneral* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuGeneral",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuGeneral*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchEnded'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Touch* arg0;
        cocos2d::Event* arg1;

        ok &= luaval_to_object<cocos2d::Touch>(tolua_S, 2, "cc.Touch",&arg0, "UIMenuGeneral:onTouchEnded");

        ok &= luaval_to_object<cocos2d::Event>(tolua_S, 3, "cc.Event",&arg1, "UIMenuGeneral:onTouchEnded");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchEnded'", nullptr);
            return 0;
        }
        cobj->onTouchEnded(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuGeneral:onTouchEnded",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchEnded'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchMoved(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuGeneral* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuGeneral",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuGeneral*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchMoved'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Touch* arg0;
        cocos2d::Event* arg1;

        ok &= luaval_to_object<cocos2d::Touch>(tolua_S, 2, "cc.Touch",&arg0, "UIMenuGeneral:onTouchMoved");

        ok &= luaval_to_object<cocos2d::Event>(tolua_S, 3, "cc.Event",&arg1, "UIMenuGeneral:onTouchMoved");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchMoved'", nullptr);
            return 0;
        }
        cobj->onTouchMoved(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuGeneral:onTouchMoved",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchMoved'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchCancelled(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuGeneral* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuGeneral",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuGeneral*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchCancelled'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Touch* arg0;
        cocos2d::Event* arg1;

        ok &= luaval_to_object<cocos2d::Touch>(tolua_S, 2, "cc.Touch",&arg0, "UIMenuGeneral:onTouchCancelled");

        ok &= luaval_to_object<cocos2d::Event>(tolua_S, 3, "cc.Event",&arg1, "UIMenuGeneral:onTouchCancelled");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchCancelled'", nullptr);
            return 0;
        }
        cobj->onTouchCancelled(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuGeneral:onTouchCancelled",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchCancelled'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchBegan(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuGeneral* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuGeneral",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuGeneral*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchBegan'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Touch* arg0;
        cocos2d::Event* arg1;

        ok &= luaval_to_object<cocos2d::Touch>(tolua_S, 2, "cc.Touch",&arg0, "UIMenuGeneral:onTouchBegan");

        ok &= luaval_to_object<cocos2d::Event>(tolua_S, 3, "cc.Event",&arg1, "UIMenuGeneral:onTouchBegan");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchBegan'", nullptr);
            return 0;
        }
        bool ret = cobj->onTouchBegan(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuGeneral:onTouchBegan",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchBegan'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_removeChild(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuGeneral* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuGeneral",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuGeneral*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_removeChild'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Node* arg0;
        bool arg1;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "UIMenuGeneral:removeChild");

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "UIMenuGeneral:removeChild");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_removeChild'", nullptr);
            return 0;
        }
        cobj->removeChild(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuGeneral:removeChild",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_removeChild'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_reorderChild(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuGeneral* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuGeneral",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuGeneral*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_reorderChild'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Node* arg0;
        int arg1;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "UIMenuGeneral:reorderChild");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "UIMenuGeneral:reorderChild");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_reorderChild'", nullptr);
            return 0;
        }
        cobj->reorderChild(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuGeneral:reorderChild",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_reorderChild'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UIMenuGeneral",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_create'", nullptr);
            return 0;
        }
        UIMenuGeneral* ret = UIMenuGeneral::create();
        object_to_luaval<UIMenuGeneral>(tolua_S, "UIMenuGeneral",(UIMenuGeneral*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UIMenuGeneral:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuGeneral* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_constructor'", nullptr);
            return 0;
        }
        cobj = new UIMenuGeneral();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UIMenuGeneral");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuGeneral:UIMenuGeneral",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UIMenuGeneral)");
    return 0;
}

int lua_register_cpp_comp_menu_uimenugeneral_UIMenuGeneral(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UIMenuGeneral");
    tolua_cclass(tolua_S,"UIMenuGeneral","UIMenuGeneral","UIMenu",nullptr);

    tolua_beginmodule(tolua_S,"UIMenuGeneral");
        tolua_function(tolua_S,"new",lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_constructor);
        tolua_function(tolua_S,"addChild",lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_addChild);
        tolua_function(tolua_S,"onTouchEnded",lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchEnded);
        tolua_function(tolua_S,"onTouchMoved",lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchMoved);
        tolua_function(tolua_S,"onTouchCancelled",lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchCancelled);
        tolua_function(tolua_S,"onTouchBegan",lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_onTouchBegan);
        tolua_function(tolua_S,"removeChild",lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_removeChild);
        tolua_function(tolua_S,"reorderChild",lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_reorderChild);
        tolua_function(tolua_S,"create", lua_cpp_comp_menu_uimenugeneral_UIMenuGeneral_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UIMenuGeneral).name();
    g_luaType[typeName] = "UIMenuGeneral";
    g_typeCast["UIMenuGeneral"] = "UIMenuGeneral";
    return 1;
}
TOLUA_API int register_all_cpp_comp_menu_uimenugeneral(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_comp_menu_uimenugeneral_UIMenuGeneral(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

