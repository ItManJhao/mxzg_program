#include "scripting/lua-bindings/auto/lua_cpp_comp_uilabel_auto.hpp"
#include "../../../../../runtime-src/Classes/Comp/UILabel.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_comp_uilabel_UILabel_runActionFromTo(lua_State* tolua_S)
{
    int argc = 0;
    UILabel* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UILabel",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UILabel*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uilabel_UILabel_runActionFromTo'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        long long arg0;
        long long arg1;
        double arg2;

        ok &= luaval_to_long_long(tolua_S, 2,&arg0, "UILabel:runActionFromTo");

        ok &= luaval_to_long_long(tolua_S, 3,&arg1, "UILabel:runActionFromTo");

        ok &= luaval_to_number(tolua_S, 4,&arg2, "UILabel:runActionFromTo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabel_runActionFromTo'", nullptr);
            return 0;
        }
        cobj->runActionFromTo(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UILabel:runActionFromTo",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uilabel_UILabel_runActionFromTo'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uilabel_UILabel_createWithBMFont(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UILabel",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        std::string arg0;
        std::string arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UILabel:createWithBMFont");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "UILabel:createWithBMFont");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabel_createWithBMFont'", nullptr);
            return 0;
        }
        UILabel* ret = UILabel::createWithBMFont(arg0, arg1);
        object_to_luaval<UILabel>(tolua_S, "UILabel",(UILabel*)ret);
        return 1;
    }
    if (argc == 3)
    {
        std::string arg0;
        std::string arg1;
        cocos2d::TextHAlignment arg2;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UILabel:createWithBMFont");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "UILabel:createWithBMFont");
        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "UILabel:createWithBMFont");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabel_createWithBMFont'", nullptr);
            return 0;
        }
        UILabel* ret = UILabel::createWithBMFont(arg0, arg1, arg2);
        object_to_luaval<UILabel>(tolua_S, "UILabel",(UILabel*)ret);
        return 1;
    }
    if (argc == 4)
    {
        std::string arg0;
        std::string arg1;
        cocos2d::TextHAlignment arg2;
        int arg3;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UILabel:createWithBMFont");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "UILabel:createWithBMFont");
        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "UILabel:createWithBMFont");
        ok &= luaval_to_int32(tolua_S, 5,(int *)&arg3, "UILabel:createWithBMFont");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabel_createWithBMFont'", nullptr);
            return 0;
        }
        UILabel* ret = UILabel::createWithBMFont(arg0, arg1, arg2, arg3);
        object_to_luaval<UILabel>(tolua_S, "UILabel",(UILabel*)ret);
        return 1;
    }
    if (argc == 5)
    {
        std::string arg0;
        std::string arg1;
        cocos2d::TextHAlignment arg2;
        int arg3;
        cocos2d::Vec2 arg4;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UILabel:createWithBMFont");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "UILabel:createWithBMFont");
        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "UILabel:createWithBMFont");
        ok &= luaval_to_int32(tolua_S, 5,(int *)&arg3, "UILabel:createWithBMFont");
        ok &= luaval_to_vec2(tolua_S, 6, &arg4, "UILabel:createWithBMFont");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabel_createWithBMFont'", nullptr);
            return 0;
        }
        UILabel* ret = UILabel::createWithBMFont(arg0, arg1, arg2, arg3, arg4);
        object_to_luaval<UILabel>(tolua_S, "UILabel",(UILabel*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UILabel:createWithBMFont",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uilabel_UILabel_createWithBMFont'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_uilabel_UILabel_createWithSystemFont(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UILabel",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 3)
    {
        std::string arg0;
        std::string arg1;
        double arg2;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UILabel:createWithSystemFont");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "UILabel:createWithSystemFont");
        ok &= luaval_to_number(tolua_S, 4,&arg2, "UILabel:createWithSystemFont");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabel_createWithSystemFont'", nullptr);
            return 0;
        }
        UILabel* ret = UILabel::createWithSystemFont(arg0, arg1, arg2);
        object_to_luaval<UILabel>(tolua_S, "UILabel",(UILabel*)ret);
        return 1;
    }
    if (argc == 4)
    {
        std::string arg0;
        std::string arg1;
        double arg2;
        cocos2d::Size arg3;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UILabel:createWithSystemFont");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "UILabel:createWithSystemFont");
        ok &= luaval_to_number(tolua_S, 4,&arg2, "UILabel:createWithSystemFont");
        ok &= luaval_to_size(tolua_S, 5, &arg3, "UILabel:createWithSystemFont");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabel_createWithSystemFont'", nullptr);
            return 0;
        }
        UILabel* ret = UILabel::createWithSystemFont(arg0, arg1, arg2, arg3);
        object_to_luaval<UILabel>(tolua_S, "UILabel",(UILabel*)ret);
        return 1;
    }
    if (argc == 5)
    {
        std::string arg0;
        std::string arg1;
        double arg2;
        cocos2d::Size arg3;
        cocos2d::TextHAlignment arg4;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UILabel:createWithSystemFont");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "UILabel:createWithSystemFont");
        ok &= luaval_to_number(tolua_S, 4,&arg2, "UILabel:createWithSystemFont");
        ok &= luaval_to_size(tolua_S, 5, &arg3, "UILabel:createWithSystemFont");
        ok &= luaval_to_int32(tolua_S, 6,(int *)&arg4, "UILabel:createWithSystemFont");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabel_createWithSystemFont'", nullptr);
            return 0;
        }
        UILabel* ret = UILabel::createWithSystemFont(arg0, arg1, arg2, arg3, arg4);
        object_to_luaval<UILabel>(tolua_S, "UILabel",(UILabel*)ret);
        return 1;
    }
    if (argc == 6)
    {
        std::string arg0;
        std::string arg1;
        double arg2;
        cocos2d::Size arg3;
        cocos2d::TextHAlignment arg4;
        cocos2d::TextVAlignment arg5;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UILabel:createWithSystemFont");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "UILabel:createWithSystemFont");
        ok &= luaval_to_number(tolua_S, 4,&arg2, "UILabel:createWithSystemFont");
        ok &= luaval_to_size(tolua_S, 5, &arg3, "UILabel:createWithSystemFont");
        ok &= luaval_to_int32(tolua_S, 6,(int *)&arg4, "UILabel:createWithSystemFont");
        ok &= luaval_to_int32(tolua_S, 7,(int *)&arg5, "UILabel:createWithSystemFont");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabel_createWithSystemFont'", nullptr);
            return 0;
        }
        UILabel* ret = UILabel::createWithSystemFont(arg0, arg1, arg2, arg3, arg4, arg5);
        object_to_luaval<UILabel>(tolua_S, "UILabel",(UILabel*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UILabel:createWithSystemFont",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uilabel_UILabel_createWithSystemFont'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_uilabel_UILabel_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UILabel* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabel_constructor'", nullptr);
            return 0;
        }
        cobj = new UILabel();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UILabel");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UILabel:UILabel",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uilabel_UILabel_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_comp_uilabel_UILabel_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UILabel)");
    return 0;
}

int lua_register_cpp_comp_uilabel_UILabel(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UILabel");
    tolua_cclass(tolua_S,"UILabel","UILabel","cc.Label",nullptr);

    tolua_beginmodule(tolua_S,"UILabel");
        tolua_function(tolua_S,"new",lua_cpp_comp_uilabel_UILabel_constructor);
        tolua_function(tolua_S,"runActionFromTo",lua_cpp_comp_uilabel_UILabel_runActionFromTo);
        tolua_function(tolua_S,"createWithBMFont", lua_cpp_comp_uilabel_UILabel_createWithBMFont);
        tolua_function(tolua_S,"createWithSystemFont", lua_cpp_comp_uilabel_UILabel_createWithSystemFont);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UILabel).name();
    g_luaType[typeName] = "UILabel";
    g_typeCast["UILabel"] = "UILabel";
    return 1;
}

int lua_cpp_comp_uilabel_UILabelTimeCountdown_init(lua_State* tolua_S)
{
    int argc = 0;
    UILabelTimeCountdown* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UILabelTimeCountdown",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UILabelTimeCountdown*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uilabel_UILabelTimeCountdown_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 5) 
    {
        int arg0;
        std::string arg1;
        double arg2;
        std::string arg3;
        std::string arg4;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "UILabelTimeCountdown:init");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "UILabelTimeCountdown:init");

        ok &= luaval_to_number(tolua_S, 4,&arg2, "UILabelTimeCountdown:init");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "UILabelTimeCountdown:init");

        ok &= luaval_to_std_string(tolua_S, 6,&arg4, "UILabelTimeCountdown:init");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabelTimeCountdown_init'", nullptr);
            return 0;
        }
        bool ret = cobj->init(arg0, arg1, arg2, arg3, arg4);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UILabelTimeCountdown:init",argc, 5);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uilabel_UILabelTimeCountdown_init'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uilabel_UILabelTimeCountdown_setTime(lua_State* tolua_S)
{
    int argc = 0;
    UILabelTimeCountdown* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UILabelTimeCountdown",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UILabelTimeCountdown*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uilabel_UILabelTimeCountdown_setTime'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "UILabelTimeCountdown:setTime");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabelTimeCountdown_setTime'", nullptr);
            return 0;
        }
        cobj->setTime(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UILabelTimeCountdown:setTime",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uilabel_UILabelTimeCountdown_setTime'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uilabel_UILabelTimeCountdown_runTimeCountdown(lua_State* tolua_S)
{
    int argc = 0;
    UILabelTimeCountdown* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UILabelTimeCountdown",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UILabelTimeCountdown*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uilabel_UILabelTimeCountdown_runTimeCountdown'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabelTimeCountdown_runTimeCountdown'", nullptr);
            return 0;
        }
        cobj->runTimeCountdown();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UILabelTimeCountdown:runTimeCountdown",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uilabel_UILabelTimeCountdown_runTimeCountdown'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uilabel_UILabelTimeCountdown_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UILabelTimeCountdown",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 5)
    {
        int arg0;
        std::string arg1;
        double arg2;
        std::string arg3;
        std::string arg4;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "UILabelTimeCountdown:create");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "UILabelTimeCountdown:create");
        ok &= luaval_to_number(tolua_S, 4,&arg2, "UILabelTimeCountdown:create");
        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "UILabelTimeCountdown:create");
        ok &= luaval_to_std_string(tolua_S, 6,&arg4, "UILabelTimeCountdown:create");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabelTimeCountdown_create'", nullptr);
            return 0;
        }
        UILabelTimeCountdown* ret = UILabelTimeCountdown::create(arg0, arg1, arg2, arg3, arg4);
        object_to_luaval<UILabelTimeCountdown>(tolua_S, "UILabelTimeCountdown",(UILabelTimeCountdown*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UILabelTimeCountdown:create",argc, 5);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uilabel_UILabelTimeCountdown_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_uilabel_UILabelTimeCountdown_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UILabelTimeCountdown* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabelTimeCountdown_constructor'", nullptr);
            return 0;
        }
        cobj = new UILabelTimeCountdown();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UILabelTimeCountdown");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UILabelTimeCountdown:UILabelTimeCountdown",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uilabel_UILabelTimeCountdown_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_comp_uilabel_UILabelTimeCountdown_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UILabelTimeCountdown)");
    return 0;
}

int lua_register_cpp_comp_uilabel_UILabelTimeCountdown(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UILabelTimeCountdown");
    tolua_cclass(tolua_S,"UILabelTimeCountdown","UILabelTimeCountdown","cc.Label",nullptr);

    tolua_beginmodule(tolua_S,"UILabelTimeCountdown");
        tolua_function(tolua_S,"new",lua_cpp_comp_uilabel_UILabelTimeCountdown_constructor);
        tolua_function(tolua_S,"init",lua_cpp_comp_uilabel_UILabelTimeCountdown_init);
        tolua_function(tolua_S,"setTime",lua_cpp_comp_uilabel_UILabelTimeCountdown_setTime);
        tolua_function(tolua_S,"runTimeCountdown",lua_cpp_comp_uilabel_UILabelTimeCountdown_runTimeCountdown);
        tolua_function(tolua_S,"create", lua_cpp_comp_uilabel_UILabelTimeCountdown_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UILabelTimeCountdown).name();
    g_luaType[typeName] = "UILabelTimeCountdown";
    g_typeCast["UILabelTimeCountdown"] = "UILabelTimeCountdown";
    return 1;
}

int lua_cpp_comp_uilabel_UILabelTTF_setCustom(lua_State* tolua_S)
{
    int argc = 0;
    UILabelTTF* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UILabelTTF",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UILabelTTF*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uilabel_UILabelTTF_setCustom'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::vector<std::string> arg0;

        ok &= luaval_to_std_vector_string(tolua_S, 2, &arg0, "UILabelTTF:setCustom");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabelTTF_setCustom'", nullptr);
            return 0;
        }
        cobj->setCustom(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UILabelTTF:setCustom",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uilabel_UILabelTTF_setCustom'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uilabel_UILabelTTF_clearCustom(lua_State* tolua_S)
{
    int argc = 0;
    UILabelTTF* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UILabelTTF",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UILabelTTF*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uilabel_UILabelTTF_clearCustom'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabelTTF_clearCustom'", nullptr);
            return 0;
        }
        cobj->clearCustom();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UILabelTTF:clearCustom",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uilabel_UILabelTTF_clearCustom'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uilabel_UILabelTTF_setFontSize(lua_State* tolua_S)
{
    int argc = 0;
    UILabelTTF* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UILabelTTF",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UILabelTTF*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uilabel_UILabelTTF_setFontSize'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "UILabelTTF:setFontSize");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabelTTF_setFontSize'", nullptr);
            return 0;
        }
        cobj->setFontSize(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UILabelTTF:setFontSize",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uilabel_UILabelTTF_setFontSize'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uilabel_UILabelTTF_getCustom(lua_State* tolua_S)
{
    int argc = 0;
    UILabelTTF* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UILabelTTF",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UILabelTTF*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uilabel_UILabelTTF_getCustom'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabelTTF_getCustom'", nullptr);
            return 0;
        }
        std::vector<std::string> ret = cobj->getCustom();
        ccvector_std_string_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UILabelTTF:getCustom",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uilabel_UILabelTTF_getCustom'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uilabel_UILabelTTF_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UILabelTTF",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabelTTF_create'", nullptr);
            return 0;
        }
        UILabelTTF* ret = UILabelTTF::create();
        object_to_luaval<UILabelTTF>(tolua_S, "UILabelTTF",(UILabelTTF*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UILabelTTF:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uilabel_UILabelTTF_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_uilabel_UILabelTTF_setDefaultFontName(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UILabelTTF",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UILabelTTF:setDefaultFontName");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabelTTF_setDefaultFontName'", nullptr);
            return 0;
        }
        UILabelTTF::setDefaultFontName(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UILabelTTF:setDefaultFontName",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uilabel_UILabelTTF_setDefaultFontName'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_uilabel_UILabelTTF_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UILabelTTF* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uilabel_UILabelTTF_constructor'", nullptr);
            return 0;
        }
        cobj = new UILabelTTF();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UILabelTTF");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UILabelTTF:UILabelTTF",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uilabel_UILabelTTF_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_comp_uilabel_UILabelTTF_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UILabelTTF)");
    return 0;
}

int lua_register_cpp_comp_uilabel_UILabelTTF(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UILabelTTF");
    tolua_cclass(tolua_S,"UILabelTTF","UILabelTTF","cc.Label",nullptr);

    tolua_beginmodule(tolua_S,"UILabelTTF");
        tolua_function(tolua_S,"new",lua_cpp_comp_uilabel_UILabelTTF_constructor);
        tolua_function(tolua_S,"setCustom",lua_cpp_comp_uilabel_UILabelTTF_setCustom);
        tolua_function(tolua_S,"clearCustom",lua_cpp_comp_uilabel_UILabelTTF_clearCustom);
        tolua_function(tolua_S,"setFontSize",lua_cpp_comp_uilabel_UILabelTTF_setFontSize);
        tolua_function(tolua_S,"getCustom",lua_cpp_comp_uilabel_UILabelTTF_getCustom);
        tolua_function(tolua_S,"create", lua_cpp_comp_uilabel_UILabelTTF_create);
        tolua_function(tolua_S,"setDefaultFontName", lua_cpp_comp_uilabel_UILabelTTF_setDefaultFontName);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UILabelTTF).name();
    g_luaType[typeName] = "UILabelTTF";
    g_typeCast["UILabelTTF"] = "UILabelTTF";
    return 1;
}
TOLUA_API int register_all_cpp_comp_uilabel(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_comp_uilabel_UILabelTimeCountdown(tolua_S);
	lua_register_cpp_comp_uilabel_UILabelTTF(tolua_S);
	lua_register_cpp_comp_uilabel_UILabel(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

