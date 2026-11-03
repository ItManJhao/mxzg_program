#include "scripting/lua-bindings/auto/lua_cpp_comp_menu_uimenuitem_auto.hpp"
#include "../../../../../runtime-src/Classes/Comp/Menu/UIMenuItem.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_activate(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemImage* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemImage",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemImage*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_activate'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_activate'", nullptr);
            return 0;
        }
        cobj->activate();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemImage:activate",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_activate'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_setEnableAction(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemImage* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemImage",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemImage*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_setEnableAction'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "UIMenuItemImage:setEnableAction");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_setEnableAction'", nullptr);
            return 0;
        }
        cobj->setEnableAction(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemImage:setEnableAction",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_setEnableAction'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_selected(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemImage* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemImage",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemImage*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_selected'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_selected'", nullptr);
            return 0;
        }
        cobj->selected();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemImage:selected",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_selected'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_initWithSpriteFrameName(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemImage* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemImage",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemImage*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_initWithSpriteFrameName'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        const char* arg0;
        const char* arg1;
        const char* arg2;
        std::function<void (cocos2d::Ref *)> arg3;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "UIMenuItemImage:initWithSpriteFrameName"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "UIMenuItemImage:initWithSpriteFrameName"); arg1 = arg1_tmp.c_str();

        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "UIMenuItemImage:initWithSpriteFrameName"); arg2 = arg2_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_initWithSpriteFrameName'", nullptr);
            return 0;
        }
        bool ret = cobj->initWithSpriteFrameName(arg0, arg1, arg2, NULL);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemImage:initWithSpriteFrameName",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_initWithSpriteFrameName'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_initWithNormalImage(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemImage* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemImage",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemImage*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_initWithNormalImage'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3)
    {
        const char* arg0;
        const char* arg1;
        const char* arg2;
        std::function<void (cocos2d::Ref *)> arg3;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "UIMenuItemImage:initWithNormalImage"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "UIMenuItemImage:initWithNormalImage"); arg1 = arg1_tmp.c_str();

        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "UIMenuItemImage:initWithNormalImage"); arg2 = arg2_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_initWithNormalImage'", nullptr);
            return 0;
        }
        bool ret = cobj->initWithNormalImage(arg0, arg1, arg2, NULL);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemImage:initWithNormalImage",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_initWithNormalImage'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_unselected(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemImage* cobj = nullptr;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemImage",0,&tolua_err)) goto tolua_lerror;
#endif
    cobj = (UIMenuItemImage*)tolua_tousertype(tolua_S,1,0);
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_unselected'", nullptr);
        return 0;
    }
#endif
    argc = lua_gettop(tolua_S)-1;
    do{
        if (argc == 1) {
            bool arg0;
            ok &= luaval_to_boolean(tolua_S, 2,&arg0, "UIMenuItemImage:unselected");

            if (!ok) { break; }
            cobj->unselected(arg0);
            lua_settop(tolua_S, 1);
            return 1;
        }
    }while(0);
    ok  = true;
    do{
        if (argc == 0) {
            cobj->unselected();
            lua_settop(tolua_S, 1);
            return 1;
        }
    }while(0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n",  "UIMenuItemImage:unselected",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_unselected'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UIMenuItemImage",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_create'", nullptr);
            return 0;
        }
        UIMenuItemImage* ret = UIMenuItemImage::create();
        object_to_luaval<UIMenuItemImage>(tolua_S, "UIMenuItemImage",(UIMenuItemImage*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UIMenuItemImage:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_createWithSpriteFrameName(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UIMenuItemImage",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 3)
    {
        const char* arg0;
        const char* arg1;
        const char* arg2;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "UIMenuItemImage:createWithSpriteFrameName"); arg0 = arg0_tmp.c_str();
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "UIMenuItemImage:createWithSpriteFrameName"); arg1 = arg1_tmp.c_str();
        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "UIMenuItemImage:createWithSpriteFrameName"); arg2 = arg2_tmp.c_str();

        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_createWithSpriteFrameName'", nullptr);
            return 0;
        }
        UIMenuItemImage* ret = UIMenuItemImage::createWithSpriteFrameName(arg0, arg1, arg2, NULL);
        object_to_luaval<UIMenuItemImage>(tolua_S, "UIMenuItemImage",(UIMenuItemImage*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UIMenuItemImage:createWithSpriteFrameName",argc, 4);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_createWithSpriteFrameName'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemImage* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_constructor'", nullptr);
            return 0;
        }
        cobj = new UIMenuItemImage();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UIMenuItemImage");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemImage:UIMenuItemImage",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UIMenuItemImage)");
    return 0;
}

int lua_register_cpp_comp_menu_uimenuitem_UIMenuItemImage(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UIMenuItemImage");
    tolua_cclass(tolua_S,"UIMenuItemImage","UIMenuItemImage","cc.MenuItemImage",nullptr);

    tolua_beginmodule(tolua_S,"UIMenuItemImage");
        tolua_function(tolua_S,"new",lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_constructor);
        tolua_function(tolua_S,"activate",lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_activate);
        tolua_function(tolua_S,"setEnableAction",lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_setEnableAction);
        tolua_function(tolua_S,"selected",lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_selected);
        tolua_function(tolua_S,"initWithSpriteFrameName",lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_initWithSpriteFrameName);
        tolua_function(tolua_S,"initWithNormalImage",lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_initWithNormalImage);
        tolua_function(tolua_S,"unselected",lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_unselected);
        tolua_function(tolua_S,"create", lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_create);
        tolua_function(tolua_S,"createWithSpriteFrameName", lua_cpp_comp_menu_uimenuitem_UIMenuItemImage_createWithSpriteFrameName);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UIMenuItemImage).name();
    g_luaType[typeName] = "UIMenuItemImage";
    g_typeCast["UIMenuItemImage"] = "UIMenuItemImage";
    return 1;
}

int lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_onNodeLoaded(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemLabel* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemLabel",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemLabel*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_onNodeLoaded'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Node* arg0;
        cocosbuilder::NodeLoader* arg1;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "UIMenuItemLabel:onNodeLoaded");

        ok &= luaval_to_object<cocosbuilder::NodeLoader>(tolua_S, 3, "cc.NodeLoader",&arg1, "UIMenuItemLabel:onNodeLoaded");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_onNodeLoaded'", nullptr);
            return 0;
        }
        cobj->onNodeLoaded(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemLabel:onNodeLoaded",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_onNodeLoaded'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelText(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemLabel* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemLabel",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemLabel*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelText'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UIMenuItemLabel:setLabelText");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelText'", nullptr);
            return 0;
        }
        cobj->setLabelText(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemLabel:setLabelText",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelText'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_getLabel(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemLabel* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemLabel",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemLabel*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_getLabel'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_getLabel'", nullptr);
            return 0;
        }
        cocos2d::Label* ret = cobj->getLabel();
        object_to_luaval<cocos2d::Label>(tolua_S, "cc.Label",(cocos2d::Label*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemLabel:getLabel",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_getLabel'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_getLabelText(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemLabel* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemLabel",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemLabel*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_getLabelText'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_getLabelText'", nullptr);
            return 0;
        }
        std::string ret = cobj->getLabelText();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemLabel:getLabelText",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_getLabelText'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelFont(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemLabel* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemLabel",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemLabel*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelFont'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UIMenuItemLabel:setLabelFont");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelFont'", nullptr);
            return 0;
        }
        cobj->setLabelFont(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemLabel:setLabelFont",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelFont'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelOutLine(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemLabel* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemLabel",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemLabel*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelOutLine'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelOutLine'", nullptr);
            return 0;
        }
        cobj->setLabelOutLine();
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 1) 
    {
        cocos2d::Color4B arg0;

        ok &=luaval_to_color4b(tolua_S, 2, &arg0, "UIMenuItemLabel:setLabelOutLine");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelOutLine'", nullptr);
            return 0;
        }
        cobj->setLabelOutLine(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2)
    {
        cocos2d::Color4B arg0;
        int32_t arg1;

        ok &=luaval_to_color4b(tolua_S, 2, &arg0, "UIMenuItemLabel:setLabelOutLine");
        ok &= luaval_to_int32(tolua_S, 3,&arg1, "UIMenuItemLabel:setLabelOutLine");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelOutLine'", nullptr);
            return 0;
        }
        cobj->setLabelOutLine(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemLabel:setLabelOutLine",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelOutLine'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelScale(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemLabel* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemLabel",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemLabel*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelScale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenuItemLabel:setLabelScale");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelScale'", nullptr);
            return 0;
        }
        cobj->setLabelScale(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemLabel:setLabelScale",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelScale'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelShadow(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemLabel* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemLabel",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemLabel*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelShadow'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelShadow'", nullptr);
            return 0;
        }
        cobj->setLabelShadow();
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 1) 
    {
        cocos2d::Color4B arg0;

        ok &=luaval_to_color4b(tolua_S, 2, &arg0, "UIMenuItemLabel:setLabelShadow");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelShadow'", nullptr);
            return 0;
        }
        cobj->setLabelShadow(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        cocos2d::Color4B arg0;
        cocos2d::Size arg1;

        ok &=luaval_to_color4b(tolua_S, 2, &arg0, "UIMenuItemLabel:setLabelShadow");

        ok &= luaval_to_size(tolua_S, 3, &arg1, "UIMenuItemLabel:setLabelShadow");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelShadow'", nullptr);
            return 0;
        }
        cobj->setLabelShadow(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 3) 
    {
        cocos2d::Color4B arg0;
        cocos2d::Size arg1;
        int arg2;

        ok &=luaval_to_color4b(tolua_S, 2, &arg0, "UIMenuItemLabel:setLabelShadow");

        ok &= luaval_to_size(tolua_S, 3, &arg1, "UIMenuItemLabel:setLabelShadow");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "UIMenuItemLabel:setLabelShadow");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelShadow'", nullptr);
            return 0;
        }
        cobj->setLabelShadow(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemLabel:setLabelShadow",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelShadow'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelColor(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemLabel* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemLabel",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemLabel*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelColor'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Color3B arg0;

        ok &= luaval_to_color3b(tolua_S, 2, &arg0, "UIMenuItemLabel:setLabelColor");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelColor'", nullptr);
            return 0;
        }
        cobj->setLabelColor(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemLabel:setLabelColor",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelColor'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelSize(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemLabel* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemLabel",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemLabel*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelSize'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenuItemLabel:setLabelSize");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelSize'", nullptr);
            return 0;
        }
        cobj->setLabelSize(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemLabel:setLabelSize",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelSize'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelOffset(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemLabel* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemLabel",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemLabel*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelOffset'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Point arg0;

        ok &= luaval_to_point(tolua_S, 2, &arg0, "UIMenuItemLabel:setLabelOffset");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelOffset'", nullptr);
            return 0;
        }
        cobj->setLabelOffset(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemLabel:setLabelOffset",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelOffset'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setType(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemLabel* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemLabel",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemLabel*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setType'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int32_t arg0;

        ok &= luaval_to_int32(tolua_S, 2,&arg0, "UIMenuItemLabel:setType");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setType'", nullptr);
            return 0;
        }
        cobj->setType(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemLabel:setType",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setType'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UIMenuItemLabel",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S)-1;

    do 
    {
        if (argc == 4)
        {
            const char* arg0;
            std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "UIMenuItemLabel:create"); arg0 = arg0_tmp.c_str();
            if (!ok) { break; }
            const char* arg1;
            std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "UIMenuItemLabel:create"); arg1 = arg1_tmp.c_str();
            if (!ok) { break; }
            const char* arg2;
            std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "UIMenuItemLabel:create"); arg2 = arg2_tmp.c_str();
            if (!ok) { break; }

            UIMenuItemLabel* ret = UIMenuItemLabel::create(arg0, arg1, arg2, NULL);
            object_to_luaval<UIMenuItemLabel>(tolua_S, "UIMenuItemLabel",(UIMenuItemLabel*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    do 
    {
        if (argc == 5)
        {
            const char* arg0;
            std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "UIMenuItemLabel:create"); arg0 = arg0_tmp.c_str();
            if (!ok) { break; }
            const char* arg1;
            std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "UIMenuItemLabel:create"); arg1 = arg1_tmp.c_str();
            if (!ok) { break; }
            const char* arg2;
            std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "UIMenuItemLabel:create"); arg2 = arg2_tmp.c_str();
            if (!ok) { break; }
        
            int32_t arg4;
            ok &= luaval_to_int32(tolua_S, 6,&arg4, "UIMenuItemLabel:create");
            if (!ok) { break; }
            UIMenuItemLabel* ret = UIMenuItemLabel::create(arg0, arg1, arg2, NULL, arg4);
            object_to_luaval<UIMenuItemLabel>(tolua_S, "UIMenuItemLabel",(UIMenuItemLabel*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    do 
    {
        if (argc == 0)
        {
            UIMenuItemLabel* ret = UIMenuItemLabel::create();
            object_to_luaval<UIMenuItemLabel>(tolua_S, "UIMenuItemLabel",(UIMenuItemLabel*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    do 
    {
        if (argc == 5)
        {
            const char* arg0;
            std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "UIMenuItemLabel:create"); arg0 = arg0_tmp.c_str();
            if (!ok) { break; }
            const char* arg1;
            std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "UIMenuItemLabel:create"); arg1 = arg1_tmp.c_str();
            if (!ok) { break; }
            const char* arg2;
            std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "UIMenuItemLabel:create"); arg2 = arg2_tmp.c_str();
            if (!ok) { break; }
            const char* arg3;
            std::string arg3_tmp; ok &= luaval_to_std_string(tolua_S, 5, &arg3_tmp, "UIMenuItemLabel:create"); arg3 = arg3_tmp.c_str();
            if (!ok) { break; }
            UIMenuItemLabel* ret = UIMenuItemLabel::create(arg0, arg1, arg2, arg3, NULL);
            object_to_luaval<UIMenuItemLabel>(tolua_S, "UIMenuItemLabel",(UIMenuItemLabel*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    do 
    {
        if (argc == 6)
        {
            const char* arg0;
            std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "UIMenuItemLabel:create"); arg0 = arg0_tmp.c_str();
            if (!ok) { break; }
            const char* arg1;
            std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "UIMenuItemLabel:create"); arg1 = arg1_tmp.c_str();
            if (!ok) { break; }
            const char* arg2;
            std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "UIMenuItemLabel:create"); arg2 = arg2_tmp.c_str();
            if (!ok) { break; }
            const char* arg3;
            std::string arg3_tmp; ok &= luaval_to_std_string(tolua_S, 5, &arg3_tmp, "UIMenuItemLabel:create"); arg3 = arg3_tmp.c_str();
            if (!ok) { break; }
            int32_t arg5;
            ok &= luaval_to_int32(tolua_S, 7,&arg5, "UIMenuItemLabel:create");
            if (!ok) { break; }
            UIMenuItemLabel* ret = UIMenuItemLabel::create(arg0, arg1, arg2, arg3, NULL, arg5);
            object_to_luaval<UIMenuItemLabel>(tolua_S, "UIMenuItemLabel",(UIMenuItemLabel*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d", "UIMenuItemLabel:create",argc, 5);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemLabel* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_constructor'", nullptr);
            return 0;
        }
        cobj = new UIMenuItemLabel();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UIMenuItemLabel");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemLabel:UIMenuItemLabel",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UIMenuItemLabel)");
    return 0;
}

int lua_register_cpp_comp_menu_uimenuitem_UIMenuItemLabel(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UIMenuItemLabel");
    tolua_cclass(tolua_S,"UIMenuItemLabel","UIMenuItemLabel","UIMenuItemImage",nullptr);

    tolua_beginmodule(tolua_S,"UIMenuItemLabel");
        tolua_function(tolua_S,"new",lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_constructor);
        tolua_function(tolua_S,"onNodeLoaded",lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_onNodeLoaded);
        tolua_function(tolua_S,"setLabelText",lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelText);
        tolua_function(tolua_S,"getLabel",lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_getLabel);
        tolua_function(tolua_S,"getLabelText",lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_getLabelText);
        tolua_function(tolua_S,"setLabelFont",lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelFont);
        tolua_function(tolua_S,"setLabelOutLine",lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelOutLine);
        tolua_function(tolua_S,"setLabelScale",lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelScale);
        tolua_function(tolua_S,"setLabelShadow",lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelShadow);
        tolua_function(tolua_S,"setLabelColor",lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelColor);
        tolua_function(tolua_S,"setLabelSize",lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelSize);
        tolua_function(tolua_S,"setLabelOffset",lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setLabelOffset);
        tolua_function(tolua_S,"setType",lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_setType);
        tolua_function(tolua_S,"create", lua_cpp_comp_menu_uimenuitem_UIMenuItemLabel_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UIMenuItemLabel).name();
    g_luaType[typeName] = "UIMenuItemLabel";
    g_typeCast["UIMenuItemLabel"] = "UIMenuItemLabel";
    return 1;
}

int lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_setChecked(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemCheckBox* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemCheckBox",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemCheckBox*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_setChecked'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "UIMenuItemCheckBox:setChecked");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_setChecked'", nullptr);
            return 0;
        }
        cobj->setChecked(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemCheckBox:setChecked",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_setChecked'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_isChecked(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemCheckBox* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemCheckBox",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemCheckBox*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_isChecked'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_isChecked'", nullptr);
            return 0;
        }
        bool ret = cobj->isChecked();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemCheckBox:isChecked",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_isChecked'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_selected(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemCheckBox* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemCheckBox",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemCheckBox*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_selected'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_selected'", nullptr);
            return 0;
        }
        cobj->selected();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemCheckBox:selected",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_selected'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_unselected(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemCheckBox* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemCheckBox",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemCheckBox*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_unselected'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_unselected'", nullptr);
            return 0;
        }
        cobj->unselected();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemCheckBox:unselected",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_unselected'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_activate(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemCheckBox* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemCheckBox",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemCheckBox*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_activate'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_activate'", nullptr);
            return 0;
        }
        cobj->activate();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemCheckBox:activate",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_activate'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UIMenuItemCheckBox",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S)-1;

    do 
    {
        if (argc == 3)
        {
            const char* arg0;
            std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "UIMenuItemCheckBox:create"); arg0 = arg0_tmp.c_str();
            if (!ok) { break; }
            const char* arg1;
            std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "UIMenuItemCheckBox:create"); arg1 = arg1_tmp.c_str();
            if (!ok) { break; }
            UIMenuItemCheckBox* ret = UIMenuItemCheckBox::create(arg0, arg1, NULL);
            object_to_luaval<UIMenuItemCheckBox>(tolua_S, "UIMenuItemCheckBox",(UIMenuItemCheckBox*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    do 
    {
        if (argc == 0)
        {
            UIMenuItemCheckBox* ret = UIMenuItemCheckBox::create();
            object_to_luaval<UIMenuItemCheckBox>(tolua_S, "UIMenuItemCheckBox",(UIMenuItemCheckBox*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d", "UIMenuItemCheckBox:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_create'.",&tolua_err);
#endif
    return 0;
}
static int lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UIMenuItemCheckBox)");
    return 0;
}

int lua_register_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UIMenuItemCheckBox");
    tolua_cclass(tolua_S,"UIMenuItemCheckBox","UIMenuItemCheckBox","UIMenuItemImage",nullptr);

    tolua_beginmodule(tolua_S,"UIMenuItemCheckBox");
        tolua_function(tolua_S,"setChecked",lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_setChecked);
        tolua_function(tolua_S,"isChecked",lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_isChecked);
        tolua_function(tolua_S,"selected",lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_selected);
        tolua_function(tolua_S,"unselected",lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_unselected);
        tolua_function(tolua_S,"activate",lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_activate);
        tolua_function(tolua_S,"create", lua_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UIMenuItemCheckBox).name();
    g_luaType[typeName] = "UIMenuItemCheckBox";
    g_typeCast["UIMenuItemCheckBox"] = "UIMenuItemCheckBox";
    return 1;
}

int lua_cpp_comp_menu_uimenuitem_UIMenuItemRadio_activate(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemRadio* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemRadio",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemRadio*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemRadio_activate'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemRadio_activate'", nullptr);
            return 0;
        }
        cobj->activate();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemRadio:activate",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemRadio_activate'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemRadio_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UIMenuItemRadio",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemRadio_create'", nullptr);
            return 0;
        }
        UIMenuItemRadio* ret = UIMenuItemRadio::create();
        object_to_luaval<UIMenuItemRadio>(tolua_S, "UIMenuItemRadio",(UIMenuItemRadio*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UIMenuItemRadio:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemRadio_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemRadio_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemRadio* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemRadio_constructor'", nullptr);
            return 0;
        }
        cobj = new UIMenuItemRadio();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UIMenuItemRadio");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemRadio:UIMenuItemRadio",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemRadio_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_comp_menu_uimenuitem_UIMenuItemRadio_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UIMenuItemRadio)");
    return 0;
}

int lua_register_cpp_comp_menu_uimenuitem_UIMenuItemRadio(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UIMenuItemRadio");
    tolua_cclass(tolua_S,"UIMenuItemRadio","UIMenuItemRadio","UIMenuItemCheckBox",nullptr);

    tolua_beginmodule(tolua_S,"UIMenuItemRadio");
        tolua_function(tolua_S,"new",lua_cpp_comp_menu_uimenuitem_UIMenuItemRadio_constructor);
        tolua_function(tolua_S,"activate",lua_cpp_comp_menu_uimenuitem_UIMenuItemRadio_activate);
        tolua_function(tolua_S,"create", lua_cpp_comp_menu_uimenuitem_UIMenuItemRadio_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UIMenuItemRadio).name();
    g_luaType[typeName] = "UIMenuItemRadio";
    g_typeCast["UIMenuItemRadio"] = "UIMenuItemRadio";
    return 1;
}

int lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_onNodeLoaded(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemTab* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemTab",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemTab*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_onNodeLoaded'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Node* arg0;
        cocosbuilder::NodeLoader* arg1;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "UIMenuItemTab:onNodeLoaded");

        ok &= luaval_to_object<cocosbuilder::NodeLoader>(tolua_S, 3, "cc.NodeLoader",&arg1, "UIMenuItemTab:onNodeLoaded");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_onNodeLoaded'", nullptr);
            return 0;
        }
        cobj->onNodeLoaded(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemTab:onNodeLoaded",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_onNodeLoaded'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_resetOrder(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemTab* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemTab",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemTab*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_resetOrder'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "UIMenuItemTab:resetOrder");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_resetOrder'", nullptr);
            return 0;
        }
        cobj->resetOrder(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemTab:resetOrder",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_resetOrder'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelText(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemTab* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemTab",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemTab*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelText'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UIMenuItemTab:setLabelText");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelText'", nullptr);
            return 0;
        }
        cobj->setLabelText(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemTab:setLabelText",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelText'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelColor(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemTab* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemTab",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemTab*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelColor'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Color3B arg0;

        ok &= luaval_to_color3b(tolua_S, 2, &arg0, "UIMenuItemTab:setLabelColor");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelColor'", nullptr);
            return 0;
        }
        cobj->setLabelColor(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemTab:setLabelColor",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelColor'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_getLabelText(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemTab* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemTab",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemTab*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_getLabelText'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_getLabelText'", nullptr);
            return 0;
        }
        std::string ret = cobj->getLabelText();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemTab:getLabelText",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_getLabelText'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setChecked(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemTab* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemTab",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemTab*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setChecked'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "UIMenuItemTab:setChecked");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setChecked'", nullptr);
            return 0;
        }
        cobj->setChecked(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemTab:setChecked",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setChecked'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_selected(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemTab* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemTab",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemTab*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_selected'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_selected'", nullptr);
            return 0;
        }
        cobj->selected();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemTab:selected",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_selected'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelScale(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemTab* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemTab",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemTab*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelScale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        double arg0;
        double arg1;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenuItemTab:setLabelScale");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "UIMenuItemTab:setLabelScale");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelScale'", nullptr);
            return 0;
        }
        cobj->setLabelScale(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemTab:setLabelScale",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelScale'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_getLabel(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemTab* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemTab",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemTab*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_getLabel'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_getLabel'", nullptr);
            return 0;
        }
        cocos2d::Label* ret = cobj->getLabel();
        object_to_luaval<cocos2d::Label>(tolua_S, "cc.Label",(cocos2d::Label*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemTab:getLabel",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_getLabel'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_unselected(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemTab* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemTab",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemTab*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_unselected'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_unselected'", nullptr);
            return 0;
        }
        cobj->unselected();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemTab:unselected",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_unselected'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelOffset(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemTab* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemTab",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemTab*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelOffset'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Vec2 arg0;

        ok &= luaval_to_vec2(tolua_S, 2, &arg0, "UIMenuItemTab:setLabelOffset");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelOffset'", nullptr);
            return 0;
        }
        cobj->setLabelOffset(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemTab:setLabelOffset",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelOffset'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UIMenuItemTab",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S)-1;

    do 
    {
        if (argc == 5)
        {
            const char* arg0;
            std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "UIMenuItemTab:create"); arg0 = arg0_tmp.c_str();
            if (!ok) { break; }
            const char* arg1;
            std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "UIMenuItemTab:create"); arg1 = arg1_tmp.c_str();
            if (!ok) { break; }
            const char* arg2;
            std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "UIMenuItemTab:create"); arg2 = arg2_tmp.c_str();
            if (!ok) { break; }
            double arg3;
            ok &= luaval_to_number(tolua_S, 5,&arg3, "UIMenuItemTab:create");
            if (!ok) { break; }
            UIMenuItemTab* ret = UIMenuItemTab::create(arg0, arg1, arg2, arg3, NULL);
            object_to_luaval<UIMenuItemTab>(tolua_S, "UIMenuItemTab",(UIMenuItemTab*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    do 
    {
        if (argc == 0)
        {
            UIMenuItemTab* ret = UIMenuItemTab::create();
            object_to_luaval<UIMenuItemTab>(tolua_S, "UIMenuItemTab",(UIMenuItemTab*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d", "UIMenuItemTab:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemTab* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_constructor'", nullptr);
            return 0;
        }
        cobj = new UIMenuItemTab();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UIMenuItemTab");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemTab:UIMenuItemTab",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UIMenuItemTab)");
    return 0;
}

int lua_register_cpp_comp_menu_uimenuitem_UIMenuItemTab(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UIMenuItemTab");
    tolua_cclass(tolua_S,"UIMenuItemTab","UIMenuItemTab","UIMenuItemRadio",nullptr);

    tolua_beginmodule(tolua_S,"UIMenuItemTab");
        tolua_function(tolua_S,"new",lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_constructor);
        tolua_function(tolua_S,"onNodeLoaded",lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_onNodeLoaded);
        tolua_function(tolua_S,"resetOrder",lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_resetOrder);
        tolua_function(tolua_S,"setLabelText",lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelText);
        tolua_function(tolua_S,"setLabelColor",lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelColor);
        tolua_function(tolua_S,"getLabelText",lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_getLabelText);
        tolua_function(tolua_S,"setChecked",lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setChecked);
        tolua_function(tolua_S,"selected",lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_selected);
        tolua_function(tolua_S,"setLabelScale",lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelScale);
        tolua_function(tolua_S,"getLabel",lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_getLabel);
        tolua_function(tolua_S,"unselected",lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_unselected);
        tolua_function(tolua_S,"setLabelOffset",lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_setLabelOffset);
        tolua_function(tolua_S,"create", lua_cpp_comp_menu_uimenuitem_UIMenuItemTab_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UIMenuItemTab).name();
    g_luaType[typeName] = "UIMenuItemTab";
    g_typeCast["UIMenuItemTab"] = "UIMenuItemTab";
    return 1;
}

int lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_getItemId(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemIcon* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemIcon",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemIcon*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_getItemId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_getItemId'", nullptr);
            return 0;
        }
        long long ret = cobj->getItemId();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemIcon:getItemId",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_getItemId'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIconOffset(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemIcon* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemIcon",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemIcon*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIconOffset'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Point arg0;

        ok &= luaval_to_point(tolua_S, 2, &arg0, "UIMenuItemIcon:setIconOffset");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIconOffset'", nullptr);
            return 0;
        }
        cobj->setIconOffset(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemIcon:setIconOffset",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIconOffset'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setItemId(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemIcon* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemIcon",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemIcon*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setItemId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        long long arg0;

        ok &= luaval_to_long_long(tolua_S, 2,&arg0, "UIMenuItemIcon:setItemId");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setItemId'", nullptr);
            return 0;
        }
        cobj->setItemId(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemIcon:setItemId",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setItemId'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIconWithIndex(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemIcon* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemIcon",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemIcon*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIconWithIndex'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "UIMenuItemIcon:setIconWithIndex");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIconWithIndex'", nullptr);
            return 0;
        }
        cobj->setIconWithIndex(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemIcon:setIconWithIndex",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIconWithIndex'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIconScale(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemIcon* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemIcon",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemIcon*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIconScale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UIMenuItemIcon:setIconScale");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIconScale'", nullptr);
            return 0;
        }
        cobj->setIconScale(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemIcon:setIconScale",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIconScale'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIcon(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemIcon* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemIcon",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemIcon*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIcon'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "UIMenuItemIcon:setIcon"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIcon'", nullptr);
            return 0;
        }
        cobj->setIcon(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemIcon:setIcon",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIcon'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UIMenuItemIcon",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_create'", nullptr);
            return 0;
        }
        UIMenuItemIcon* ret = UIMenuItemIcon::create();
        object_to_luaval<UIMenuItemIcon>(tolua_S, "UIMenuItemIcon",(UIMenuItemIcon*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UIMenuItemIcon:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemIcon* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_constructor'", nullptr);
            return 0;
        }
        cobj = new UIMenuItemIcon();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UIMenuItemIcon");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemIcon:UIMenuItemIcon",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UIMenuItemIcon)");
    return 0;
}

int lua_register_cpp_comp_menu_uimenuitem_UIMenuItemIcon(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UIMenuItemIcon");
    tolua_cclass(tolua_S,"UIMenuItemIcon","UIMenuItemIcon","UIMenuItemImage",nullptr);

    tolua_beginmodule(tolua_S,"UIMenuItemIcon");
        tolua_function(tolua_S,"new",lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_constructor);
        tolua_function(tolua_S,"getItemId",lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_getItemId);
        tolua_function(tolua_S,"setIconOffset",lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIconOffset);
        tolua_function(tolua_S,"setItemId",lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setItemId);
        tolua_function(tolua_S,"setIconWithIndex",lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIconWithIndex);
        tolua_function(tolua_S,"setIconScale",lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIconScale);
        tolua_function(tolua_S,"setIcon",lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_setIcon);
        tolua_function(tolua_S,"create", lua_cpp_comp_menu_uimenuitem_UIMenuItemIcon_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UIMenuItemIcon).name();
    g_luaType[typeName] = "UIMenuItemIcon";
    g_typeCast["UIMenuItemIcon"] = "UIMenuItemIcon";
    return 1;
}

int lua_cpp_comp_menu_uimenuitem_UIMenuItemScale9Sprite_initDone(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemScale9Sprite* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemScale9Sprite",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemScale9Sprite*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemScale9Sprite_initDone'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        std::string arg0;
        cocos2d::Rect arg1;
        cocos2d::Size arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UIMenuItemScale9Sprite:initDone");

        ok &= luaval_to_rect(tolua_S, 3, &arg1, "UIMenuItemScale9Sprite:initDone");

        ok &= luaval_to_size(tolua_S, 4, &arg2, "UIMenuItemScale9Sprite:initDone");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemScale9Sprite_initDone'", nullptr);
            return 0;
        }
        cobj->initDone(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemScale9Sprite:initDone",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemScale9Sprite_initDone'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemScale9Sprite_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UIMenuItemScale9Sprite",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S)-1;

    do 
    {
        if (argc == 4)
        {
            std::string arg0;
            ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UIMenuItemScale9Sprite:create");
            if (!ok) { break; }
            cocos2d::Rect arg1;
            ok &= luaval_to_rect(tolua_S, 3, &arg1, "UIMenuItemScale9Sprite:create");
            if (!ok) { break; }
            cocos2d::Size arg2;
            ok &= luaval_to_size(tolua_S, 4, &arg2, "UIMenuItemScale9Sprite:create");
            if (!ok) { break; }
            UIMenuItemScale9Sprite* ret = UIMenuItemScale9Sprite::create(arg0, arg1, arg2, NULL);
            object_to_luaval<UIMenuItemScale9Sprite>(tolua_S, "UIMenuItemScale9Sprite",(UIMenuItemScale9Sprite*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    do 
    {
        if (argc == 0)
        {
            UIMenuItemScale9Sprite* ret = UIMenuItemScale9Sprite::create();
            object_to_luaval<UIMenuItemScale9Sprite>(tolua_S, "UIMenuItemScale9Sprite",(UIMenuItemScale9Sprite*)ret);
            return 1;
        }
    } while (0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d", "UIMenuItemScale9Sprite:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemScale9Sprite_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_menu_uimenuitem_UIMenuItemScale9Sprite_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemScale9Sprite* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemScale9Sprite_constructor'", nullptr);
            return 0;
        }
        cobj = new UIMenuItemScale9Sprite();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UIMenuItemScale9Sprite");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemScale9Sprite:UIMenuItemScale9Sprite",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_menu_uimenuitem_UIMenuItemScale9Sprite_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_comp_menu_uimenuitem_UIMenuItemScale9Sprite_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UIMenuItemScale9Sprite)");
    return 0;
}

int lua_register_cpp_comp_menu_uimenuitem_UIMenuItemScale9Sprite(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UIMenuItemScale9Sprite");
    tolua_cclass(tolua_S,"UIMenuItemScale9Sprite","UIMenuItemScale9Sprite","UIMenuItemImage",nullptr);

    tolua_beginmodule(tolua_S,"UIMenuItemScale9Sprite");
        tolua_function(tolua_S,"new",lua_cpp_comp_menu_uimenuitem_UIMenuItemScale9Sprite_constructor);
        tolua_function(tolua_S,"initDone",lua_cpp_comp_menu_uimenuitem_UIMenuItemScale9Sprite_initDone);
        tolua_function(tolua_S,"create", lua_cpp_comp_menu_uimenuitem_UIMenuItemScale9Sprite_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UIMenuItemScale9Sprite).name();
    g_luaType[typeName] = "UIMenuItemScale9Sprite";
    g_typeCast["UIMenuItemScale9Sprite"] = "UIMenuItemScale9Sprite";
    return 1;
}
TOLUA_API int register_all_cpp_comp_menu_uimenuitem(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_comp_menu_uimenuitem_UIMenuItemImage(tolua_S);
	lua_register_cpp_comp_menu_uimenuitem_UIMenuItemCheckBox(tolua_S);
	lua_register_cpp_comp_menu_uimenuitem_UIMenuItemRadio(tolua_S);
	lua_register_cpp_comp_menu_uimenuitem_UIMenuItemIcon(tolua_S);
	lua_register_cpp_comp_menu_uimenuitem_UIMenuItemScale9Sprite(tolua_S);
	lua_register_cpp_comp_menu_uimenuitem_UIMenuItemTab(tolua_S);
	lua_register_cpp_comp_menu_uimenuitem_UIMenuItemLabel(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

