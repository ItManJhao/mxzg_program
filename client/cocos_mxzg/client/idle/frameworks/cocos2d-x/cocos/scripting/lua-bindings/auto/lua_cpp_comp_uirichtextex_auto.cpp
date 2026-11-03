#include "scripting/lua-bindings/auto/lua_cpp_comp_uirichtextex_auto.hpp"
#include "../../../../../runtime-src/Classes/Comp/UIRichTextEx.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_comp_uirichtextex_RichTextEx_insertElement(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_insertElement'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        RichElementEx* arg0;
        int arg1;

        ok &= luaval_to_object<RichElementEx>(tolua_S, 2, "RichElementEx",&arg0, "RichTextEx:insertElement");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "RichTextEx:insertElement");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_insertElement'", nullptr);
            return 0;
        }
        cobj->insertElement(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:insertElement",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_insertElement'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextOutline(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextOutline'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "RichTextEx:setAnchorTextOutline");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextOutline'", nullptr);
            return 0;
        }
        cobj->setAnchorTextOutline(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        bool arg0;
        cocos2d::Color3B arg1;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "RichTextEx:setAnchorTextOutline");

        ok &= luaval_to_color3b(tolua_S, 3, &arg1, "RichTextEx:setAnchorTextOutline");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextOutline'", nullptr);
            return 0;
        }
        cobj->setAnchorTextOutline(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 3) 
    {
        bool arg0;
        cocos2d::Color3B arg1;
        int arg2;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "RichTextEx:setAnchorTextOutline");

        ok &= luaval_to_color3b(tolua_S, 3, &arg1, "RichTextEx:setAnchorTextOutline");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "RichTextEx:setAnchorTextOutline");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextOutline'", nullptr);
            return 0;
        }
        cobj->setAnchorTextOutline(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:setAnchorTextOutline",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextOutline'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_getFontSize(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_getFontSize'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_getFontSize'", nullptr);
            return 0;
        }
        double ret = cobj->getFontSize();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:getFontSize",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_getFontSize'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_pushBackElement(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_pushBackElement'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        RichElementEx* arg0;

        ok &= luaval_to_object<RichElementEx>(tolua_S, 2, "RichElementEx",&arg0, "RichTextEx:pushBackElement");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_pushBackElement'", nullptr);
            return 0;
        }
        cobj->pushBackElement(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:pushBackElement",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_pushBackElement'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextBold(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextBold'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "RichTextEx:setAnchorTextBold");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextBold'", nullptr);
            return 0;
        }
        cobj->setAnchorTextBold(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:setAnchorTextBold",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextBold'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_getAnchorFontColor(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorFontColor'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorFontColor'", nullptr);
            return 0;
        }
        std::string ret = cobj->getAnchorFontColor();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:getAnchorFontColor",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorFontColor'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextShadowBlurRadius(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextShadowBlurRadius'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextShadowBlurRadius'", nullptr);
            return 0;
        }
        int ret = cobj->getAnchorTextShadowBlurRadius();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:getAnchorTextShadowBlurRadius",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextShadowBlurRadius'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextShadow(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextShadow'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "RichTextEx:setAnchorTextShadow");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextShadow'", nullptr);
            return 0;
        }
        cobj->setAnchorTextShadow(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        bool arg0;
        cocos2d::Color3B arg1;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "RichTextEx:setAnchorTextShadow");

        ok &= luaval_to_color3b(tolua_S, 3, &arg1, "RichTextEx:setAnchorTextShadow");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextShadow'", nullptr);
            return 0;
        }
        cobj->setAnchorTextShadow(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 3) 
    {
        bool arg0;
        cocos2d::Color3B arg1;
        cocos2d::Size arg2;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "RichTextEx:setAnchorTextShadow");

        ok &= luaval_to_color3b(tolua_S, 3, &arg1, "RichTextEx:setAnchorTextShadow");

        ok &= luaval_to_size(tolua_S, 4, &arg2, "RichTextEx:setAnchorTextShadow");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextShadow'", nullptr);
            return 0;
        }
        cobj->setAnchorTextShadow(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 4) 
    {
        bool arg0;
        cocos2d::Color3B arg1;
        cocos2d::Size arg2;
        int arg3;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "RichTextEx:setAnchorTextShadow");

        ok &= luaval_to_color3b(tolua_S, 3, &arg1, "RichTextEx:setAnchorTextShadow");

        ok &= luaval_to_size(tolua_S, 4, &arg2, "RichTextEx:setAnchorTextShadow");

        ok &= luaval_to_int32(tolua_S, 5,(int *)&arg3, "RichTextEx:setAnchorTextShadow");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextShadow'", nullptr);
            return 0;
        }
        cobj->setAnchorTextShadow(arg0, arg1, arg2, arg3);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:setAnchorTextShadow",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextShadow'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextItalicEnabled(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextItalicEnabled'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextItalicEnabled'", nullptr);
            return 0;
        }
        bool ret = cobj->isAnchorTextItalicEnabled();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:isAnchorTextItalicEnabled",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextItalicEnabled'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_setAnchorFontColor(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorFontColor'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "RichTextEx:setAnchorFontColor");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorFontColor'", nullptr);
            return 0;
        }
        cobj->setAnchorFontColor(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:setAnchorFontColor",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorFontColor'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_setFontFace(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_setFontFace'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "RichTextEx:setFontFace");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setFontFace'", nullptr);
            return 0;
        }
        cobj->setFontFace(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:setFontFace",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_setFontFace'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextGlow(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextGlow'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "RichTextEx:setAnchorTextGlow");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextGlow'", nullptr);
            return 0;
        }
        cobj->setAnchorTextGlow(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        bool arg0;
        cocos2d::Color3B arg1;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "RichTextEx:setAnchorTextGlow");

        ok &= luaval_to_color3b(tolua_S, 3, &arg1, "RichTextEx:setAnchorTextGlow");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextGlow'", nullptr);
            return 0;
        }
        cobj->setAnchorTextGlow(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:setAnchorTextGlow",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextGlow'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_setXmlTextLua(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_setXmlTextLua'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "RichTextEx:setXmlTextLua");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setXmlTextLua'", nullptr);
            return 0;
        }
        cobj->setXmlTextLua(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:setXmlTextLua",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_setXmlTextLua'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextOutlineColor3B(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextOutlineColor3B'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextOutlineColor3B'", nullptr);
            return 0;
        }
        cocos2d::Color3B ret = cobj->getAnchorTextOutlineColor3B();
        color3b_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:getAnchorTextOutlineColor3B",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextOutlineColor3B'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_stringWithColor4B(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_stringWithColor4B'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Color4B arg0;

        ok &=luaval_to_color4b(tolua_S, 2, &arg0, "RichTextEx:stringWithColor4B");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_stringWithColor4B'", nullptr);
            return 0;
        }
        std::string ret = cobj->stringWithColor4B(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:stringWithColor4B",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_stringWithColor4B'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_getAnchorFontColor3B(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorFontColor3B'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorFontColor3B'", nullptr);
            return 0;
        }
        cocos2d::Color3B ret = cobj->getAnchorFontColor3B();
        color3b_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:getAnchorFontColor3B",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorFontColor3B'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_formatText(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_formatText'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_formatText'", nullptr);
            return 0;
        }
        cobj->formatText();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:formatText",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_formatText'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextGlowColor3B(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextGlowColor3B'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextGlowColor3B'", nullptr);
            return 0;
        }
        cocos2d::Color3B ret = cobj->getAnchorTextGlowColor3B();
        color3b_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:getAnchorTextGlowColor3B",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextGlowColor3B'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextUnderline(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextUnderline'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "RichTextEx:setAnchorTextUnderline");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextUnderline'", nullptr);
            return 0;
        }
        cobj->setAnchorTextUnderline(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:setAnchorTextUnderline",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextUnderline'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_openUrl(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_openUrl'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "RichTextEx:openUrl");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_openUrl'", nullptr);
            return 0;
        }
        cobj->openUrl(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:openUrl",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_openUrl'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_getFontFace(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_getFontFace'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_getFontFace'", nullptr);
            return 0;
        }
        std::string ret = cobj->getFontFace();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:getFontFace",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_getFontFace'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_setFontColor(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_setFontColor'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "RichTextEx:setFontColor");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setFontColor'", nullptr);
            return 0;
        }
        cobj->setFontColor(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:setFontColor",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_setFontColor'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextGlowEnabled(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextGlowEnabled'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextGlowEnabled'", nullptr);
            return 0;
        }
        bool ret = cobj->isAnchorTextGlowEnabled();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:isAnchorTextGlowEnabled",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextGlowEnabled'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_getDefaults(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_getDefaults'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_getDefaults'", nullptr);
            return 0;
        }
        cocos2d::ValueMap ret = cobj->getDefaults();
        ccvaluemap_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:getDefaults",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_getDefaults'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextUnderlineEnabled(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextUnderlineEnabled'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextUnderlineEnabled'", nullptr);
            return 0;
        }
        bool ret = cobj->isAnchorTextUnderlineEnabled();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:isAnchorTextUnderlineEnabled",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextUnderlineEnabled'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_getFontColor(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_getFontColor'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_getFontColor'", nullptr);
            return 0;
        }
        std::string ret = cobj->getFontColor();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:getFontColor",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_getFontColor'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextShadowEnabled(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextShadowEnabled'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextShadowEnabled'", nullptr);
            return 0;
        }
        bool ret = cobj->isAnchorTextShadowEnabled();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:isAnchorTextShadowEnabled",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextShadowEnabled'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextOutlineSize(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextOutlineSize'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextOutlineSize'", nullptr);
            return 0;
        }
        int ret = cobj->getAnchorTextOutlineSize();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:getAnchorTextOutlineSize",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextOutlineSize'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_setVerticalSpace(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_setVerticalSpace'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "RichTextEx:setVerticalSpace");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setVerticalSpace'", nullptr);
            return 0;
        }
        cobj->setVerticalSpace(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:setVerticalSpace",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_setVerticalSpace'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextDelEnabled(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextDelEnabled'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextDelEnabled'", nullptr);
            return 0;
        }
        bool ret = cobj->isAnchorTextDelEnabled();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:isAnchorTextDelEnabled",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextDelEnabled'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_enableOutline(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_enableOutline'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Color4B arg0;

        ok &=luaval_to_color4b(tolua_S, 2, &arg0, "RichTextEx:enableOutline");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_enableOutline'", nullptr);
            return 0;
        }
        cobj->enableOutline(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        cocos2d::Color4B arg0;
        int arg1;

        ok &=luaval_to_color4b(tolua_S, 2, &arg0, "RichTextEx:enableOutline");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "RichTextEx:enableOutline");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_enableOutline'", nullptr);
            return 0;
        }
        cobj->enableOutline(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:enableOutline",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_enableOutline'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_setDefaults(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_setDefaults'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::ValueMap arg0;

        ok &= luaval_to_ccvaluemap(tolua_S, 2, &arg0, "RichTextEx:setDefaults");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setDefaults'", nullptr);
            return 0;
        }
        cobj->setDefaults(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:setDefaults",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_setDefaults'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_setWrapMode(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_setWrapMode'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "RichTextEx:setWrapMode");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setWrapMode'", nullptr);
            return 0;
        }
        cobj->setWrapMode((RichTextEx::WrapMode)arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:setWrapMode",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_setWrapMode'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_setFontSize(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_setFontSize'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "RichTextEx:setFontSize");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setFontSize'", nullptr);
            return 0;
        }
        cobj->setFontSize(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:setFontSize",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_setFontSize'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_removeElement(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif
    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_removeElement'", nullptr);
        return 0;
    }
#endif
    argc = lua_gettop(tolua_S)-1;
    do{
        if (argc == 1) {
            RichElementEx* arg0;
            ok &= luaval_to_object<RichElementEx>(tolua_S, 2, "RichElementEx",&arg0, "RichTextEx:removeElement");

            if (!ok) { break; }
            cobj->removeElement(arg0);
            lua_settop(tolua_S, 1);
            return 1;
        }
    }while(0);
    ok  = true;
    do{
        if (argc == 1) {
            int arg0;
            ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "RichTextEx:removeElement");

            if (!ok) { break; }
            cobj->removeElement(arg0);
            lua_settop(tolua_S, 1);
            return 1;
        }
    }while(0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n",  "RichTextEx:removeElement",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_removeElement'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextItalic(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextItalic'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "RichTextEx:setAnchorTextItalic");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextItalic'", nullptr);
            return 0;
        }
        cobj->setAnchorTextItalic(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:setAnchorTextItalic",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextItalic'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextShadowOffset(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextShadowOffset'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextShadowOffset'", nullptr);
            return 0;
        }
        cocos2d::Size ret = cobj->getAnchorTextShadowOffset();
        size_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:getAnchorTextShadowOffset",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextShadowOffset'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextBoldEnabled(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextBoldEnabled'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextBoldEnabled'", nullptr);
            return 0;
        }
        bool ret = cobj->isAnchorTextBoldEnabled();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:isAnchorTextBoldEnabled",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextBoldEnabled'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextShadowColor3B(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextShadowColor3B'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextShadowColor3B'", nullptr);
            return 0;
        }
        cocos2d::Color3B ret = cobj->getAnchorTextShadowColor3B();
        color3b_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:getAnchorTextShadowColor3B",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextShadowColor3B'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_stringWithColor3B(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_stringWithColor3B'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Color3B arg0;

        ok &= luaval_to_color3b(tolua_S, 2, &arg0, "RichTextEx:stringWithColor3B");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_stringWithColor3B'", nullptr);
            return 0;
        }
        std::string ret = cobj->stringWithColor3B(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:stringWithColor3B",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_stringWithColor3B'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextOutlineEnabled(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextOutlineEnabled'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextOutlineEnabled'", nullptr);
            return 0;
        }
        bool ret = cobj->isAnchorTextOutlineEnabled();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:isAnchorTextOutlineEnabled",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextOutlineEnabled'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_getFontColor3B(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_getFontColor3B'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_getFontColor3B'", nullptr);
            return 0;
        }
        cocos2d::Color3B ret = cobj->getFontColor3B();
        color3b_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:getFontColor3B",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_getFontColor3B'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_getWrapMode(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_getWrapMode'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_getWrapMode'", nullptr);
            return 0;
        }
        int ret = cobj->getWrapMode();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:getWrapMode",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_getWrapMode'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_setXmlText(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_setXmlText'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        std::string arg0;
        cocos2d::ValueMap arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "RichTextEx:setXmlText");

        ok &= luaval_to_ccvaluemap(tolua_S, 3, &arg1, "RichTextEx:setXmlText");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setXmlText'", nullptr);
            return 0;
        }
        cobj->setXmlText(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 3) 
    {
        std::string arg0;
        cocos2d::ValueMap arg1;
        std::function<void (const std::basic_string<char> &)> arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "RichTextEx:setXmlText");

        ok &= luaval_to_ccvaluemap(tolua_S, 3, &arg1, "RichTextEx:setXmlText");

        do {
			// Lambda binding for lua is not supported.
			assert(false);
		} while(0)
		;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setXmlText'", nullptr);
            return 0;
        }
        cobj->setXmlText(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:setXmlText",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_setXmlText'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextDel(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextDel'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "RichTextEx:setAnchorTextDel");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextDel'", nullptr);
            return 0;
        }
        cobj->setAnchorTextDel(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:setAnchorTextDel",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextDel'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_enableShadow(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_enableShadow'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_enableShadow'", nullptr);
            return 0;
        }
        cobj->enableShadow();
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 1) 
    {
        cocos2d::Color4B arg0;

        ok &=luaval_to_color4b(tolua_S, 2, &arg0, "RichTextEx:enableShadow");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_enableShadow'", nullptr);
            return 0;
        }
        cobj->enableShadow(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        cocos2d::Color4B arg0;
        cocos2d::Size arg1;

        ok &=luaval_to_color4b(tolua_S, 2, &arg0, "RichTextEx:enableShadow");

        ok &= luaval_to_size(tolua_S, 3, &arg1, "RichTextEx:enableShadow");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_enableShadow'", nullptr);
            return 0;
        }
        cobj->enableShadow(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 3) 
    {
        cocos2d::Color4B arg0;
        cocos2d::Size arg1;
        int arg2;

        ok &=luaval_to_color4b(tolua_S, 2, &arg0, "RichTextEx:enableShadow");

        ok &= luaval_to_size(tolua_S, 3, &arg1, "RichTextEx:enableShadow");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "RichTextEx:enableShadow");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_enableShadow'", nullptr);
            return 0;
        }
        cobj->enableShadow(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:enableShadow",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_enableShadow'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_color3BWithString(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RichTextEx*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_uirichtextex_RichTextEx_color3BWithString'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "RichTextEx:color3BWithString");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_color3BWithString'", nullptr);
            return 0;
        }
        cocos2d::Color3B ret = cobj->color3BWithString(arg0);
        color3b_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:color3BWithString",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_color3BWithString'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_removeTagDescription(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "RichTextEx:removeTagDescription");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_removeTagDescription'", nullptr);
            return 0;
        }
        RichTextEx::removeTagDescription(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "RichTextEx:removeTagDescription",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_removeTagDescription'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_create'", nullptr);
            return 0;
        }
        RichTextEx* ret = RichTextEx::create();
        object_to_luaval<RichTextEx>(tolua_S, "RichTextEx",(RichTextEx*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "RichTextEx:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_createWithXMLLua(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "RichTextEx:createWithXMLLua");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_createWithXMLLua'", nullptr);
            return 0;
        }
        RichTextEx* ret = RichTextEx::createWithXMLLua(arg0);
        object_to_luaval<RichTextEx>(tolua_S, "RichTextEx",(RichTextEx*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "RichTextEx:createWithXMLLua",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_createWithXMLLua'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_createWithXML(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"RichTextEx",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        std::string arg0;
        cocos2d::ValueMap arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "RichTextEx:createWithXML");
        ok &= luaval_to_ccvaluemap(tolua_S, 3, &arg1, "RichTextEx:createWithXML");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_createWithXML'", nullptr);
            return 0;
        }
        RichTextEx* ret = RichTextEx::createWithXML(arg0, arg1);
        object_to_luaval<RichTextEx>(tolua_S, "RichTextEx",(RichTextEx*)ret);
        return 1;
    }
    if (argc == 3)
    {
        std::string arg0;
        cocos2d::ValueMap arg1;
        std::function<void (const std::basic_string<char> &)> arg2;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "RichTextEx:createWithXML");
        ok &= luaval_to_ccvaluemap(tolua_S, 3, &arg1, "RichTextEx:createWithXML");
        do {
			// Lambda binding for lua is not supported.
			assert(false);
		} while(0)
		;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_createWithXML'", nullptr);
            return 0;
        }
        RichTextEx* ret = RichTextEx::createWithXML(arg0, arg1, arg2);
        object_to_luaval<RichTextEx>(tolua_S, "RichTextEx",(RichTextEx*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "RichTextEx:createWithXML",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_createWithXML'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_uirichtextex_RichTextEx_constructor(lua_State* tolua_S)
{
    int argc = 0;
    RichTextEx* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_uirichtextex_RichTextEx_constructor'", nullptr);
            return 0;
        }
        cobj = new RichTextEx();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"RichTextEx");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RichTextEx:RichTextEx",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_uirichtextex_RichTextEx_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_comp_uirichtextex_RichTextEx_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (RichTextEx)");
    return 0;
}

int lua_register_cpp_comp_uirichtextex_RichTextEx(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"RichTextEx");
    tolua_cclass(tolua_S,"RichTextEx","RichTextEx","ccui.Widget",nullptr);

    tolua_beginmodule(tolua_S,"RichTextEx");
        tolua_function(tolua_S,"new",lua_cpp_comp_uirichtextex_RichTextEx_constructor);
        tolua_function(tolua_S,"insertElement",lua_cpp_comp_uirichtextex_RichTextEx_insertElement);
        tolua_function(tolua_S,"setAnchorTextOutline",lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextOutline);
        tolua_function(tolua_S,"getFontSize",lua_cpp_comp_uirichtextex_RichTextEx_getFontSize);
        tolua_function(tolua_S,"pushBackElement",lua_cpp_comp_uirichtextex_RichTextEx_pushBackElement);
        tolua_function(tolua_S,"setAnchorTextBold",lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextBold);
        tolua_function(tolua_S,"getAnchorFontColor",lua_cpp_comp_uirichtextex_RichTextEx_getAnchorFontColor);
        tolua_function(tolua_S,"getAnchorTextShadowBlurRadius",lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextShadowBlurRadius);
        tolua_function(tolua_S,"setAnchorTextShadow",lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextShadow);
        tolua_function(tolua_S,"isAnchorTextItalicEnabled",lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextItalicEnabled);
        tolua_function(tolua_S,"setAnchorFontColor",lua_cpp_comp_uirichtextex_RichTextEx_setAnchorFontColor);
        tolua_function(tolua_S,"setFontFace",lua_cpp_comp_uirichtextex_RichTextEx_setFontFace);
        tolua_function(tolua_S,"setAnchorTextGlow",lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextGlow);
        tolua_function(tolua_S,"setXmlTextLua",lua_cpp_comp_uirichtextex_RichTextEx_setXmlTextLua);
        tolua_function(tolua_S,"getAnchorTextOutlineColor3B",lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextOutlineColor3B);
        tolua_function(tolua_S,"stringWithColor4B",lua_cpp_comp_uirichtextex_RichTextEx_stringWithColor4B);
        tolua_function(tolua_S,"getAnchorFontColor3B",lua_cpp_comp_uirichtextex_RichTextEx_getAnchorFontColor3B);
        tolua_function(tolua_S,"formatText",lua_cpp_comp_uirichtextex_RichTextEx_formatText);
        tolua_function(tolua_S,"getAnchorTextGlowColor3B",lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextGlowColor3B);
        tolua_function(tolua_S,"setAnchorTextUnderline",lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextUnderline);
        tolua_function(tolua_S,"openUrl",lua_cpp_comp_uirichtextex_RichTextEx_openUrl);
        tolua_function(tolua_S,"getFontFace",lua_cpp_comp_uirichtextex_RichTextEx_getFontFace);
        tolua_function(tolua_S,"setFontColor",lua_cpp_comp_uirichtextex_RichTextEx_setFontColor);
        tolua_function(tolua_S,"isAnchorTextGlowEnabled",lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextGlowEnabled);
        tolua_function(tolua_S,"getDefaults",lua_cpp_comp_uirichtextex_RichTextEx_getDefaults);
        tolua_function(tolua_S,"isAnchorTextUnderlineEnabled",lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextUnderlineEnabled);
        tolua_function(tolua_S,"getFontColor",lua_cpp_comp_uirichtextex_RichTextEx_getFontColor);
        tolua_function(tolua_S,"isAnchorTextShadowEnabled",lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextShadowEnabled);
        tolua_function(tolua_S,"getAnchorTextOutlineSize",lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextOutlineSize);
        tolua_function(tolua_S,"setVerticalSpace",lua_cpp_comp_uirichtextex_RichTextEx_setVerticalSpace);
        tolua_function(tolua_S,"isAnchorTextDelEnabled",lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextDelEnabled);
        tolua_function(tolua_S,"enableOutline",lua_cpp_comp_uirichtextex_RichTextEx_enableOutline);
        tolua_function(tolua_S,"setDefaults",lua_cpp_comp_uirichtextex_RichTextEx_setDefaults);
        tolua_function(tolua_S,"setWrapMode",lua_cpp_comp_uirichtextex_RichTextEx_setWrapMode);
        tolua_function(tolua_S,"setFontSize",lua_cpp_comp_uirichtextex_RichTextEx_setFontSize);
        tolua_function(tolua_S,"removeElement",lua_cpp_comp_uirichtextex_RichTextEx_removeElement);
        tolua_function(tolua_S,"setAnchorTextItalic",lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextItalic);
        tolua_function(tolua_S,"getAnchorTextShadowOffset",lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextShadowOffset);
        tolua_function(tolua_S,"isAnchorTextBoldEnabled",lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextBoldEnabled);
        tolua_function(tolua_S,"getAnchorTextShadowColor3B",lua_cpp_comp_uirichtextex_RichTextEx_getAnchorTextShadowColor3B);
        tolua_function(tolua_S,"stringWithColor3B",lua_cpp_comp_uirichtextex_RichTextEx_stringWithColor3B);
        tolua_function(tolua_S,"isAnchorTextOutlineEnabled",lua_cpp_comp_uirichtextex_RichTextEx_isAnchorTextOutlineEnabled);
        tolua_function(tolua_S,"getFontColor3B",lua_cpp_comp_uirichtextex_RichTextEx_getFontColor3B);
        tolua_function(tolua_S,"getWrapMode",lua_cpp_comp_uirichtextex_RichTextEx_getWrapMode);
        tolua_function(tolua_S,"setXmlText",lua_cpp_comp_uirichtextex_RichTextEx_setXmlText);
        tolua_function(tolua_S,"setAnchorTextDel",lua_cpp_comp_uirichtextex_RichTextEx_setAnchorTextDel);
        tolua_function(tolua_S,"enableShadow",lua_cpp_comp_uirichtextex_RichTextEx_enableShadow);
        tolua_function(tolua_S,"color3BWithString",lua_cpp_comp_uirichtextex_RichTextEx_color3BWithString);
        tolua_function(tolua_S,"removeTagDescription", lua_cpp_comp_uirichtextex_RichTextEx_removeTagDescription);
        tolua_function(tolua_S,"create", lua_cpp_comp_uirichtextex_RichTextEx_create);
        tolua_function(tolua_S,"createWithXMLLua", lua_cpp_comp_uirichtextex_RichTextEx_createWithXMLLua);
        tolua_function(tolua_S,"createWithXML", lua_cpp_comp_uirichtextex_RichTextEx_createWithXML);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(RichTextEx).name();
    g_luaType[typeName] = "RichTextEx";
    g_typeCast["RichTextEx"] = "RichTextEx";
    return 1;
}
TOLUA_API int register_all_cpp_comp_uirichtextex(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_comp_uirichtextex_RichTextEx(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

