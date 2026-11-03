#include "scripting/lua-bindings/auto/lua_cpp_model_utils_auto.hpp"
#include "../../../../../runtime-src/Classes/Model/Utils.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_model_utils_StringUtil_trim(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "StringUtil:trim");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_trim'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::trim(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:trim",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_trim'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_convertStringToInt64(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "StringUtil:convertStringToInt64");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertStringToInt64'", nullptr);
            return 0;
        }
        long long ret = StringUtil::convertStringToInt64(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:convertStringToInt64",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_convertStringToInt64'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_convertIntToAboutTime(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        unsigned int arg0;
        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "StringUtil:convertIntToAboutTime");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertIntToAboutTime'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::convertIntToAboutTime(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:convertIntToAboutTime",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_convertIntToAboutTime'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_getLatterSize(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "StringUtil:getLatterSize"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_getLatterSize'", nullptr);
            return 0;
        }
        unsigned short ret = StringUtil::getLatterSize(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:getLatterSize",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_getLatterSize'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_convertToHowLong(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 5)
    {
        const char* arg0;
        const char* arg1;
        const char* arg2;
        const char* arg3;
        long long arg4;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "StringUtil:convertToHowLong"); arg0 = arg0_tmp.c_str();
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "StringUtil:convertToHowLong"); arg1 = arg1_tmp.c_str();
        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "StringUtil:convertToHowLong"); arg2 = arg2_tmp.c_str();
        std::string arg3_tmp; ok &= luaval_to_std_string(tolua_S, 5, &arg3_tmp, "StringUtil:convertToHowLong"); arg3 = arg3_tmp.c_str();
        ok &= luaval_to_long_long(tolua_S, 6,&arg4, "StringUtil:convertToHowLong");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertToHowLong'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::convertToHowLong(arg0, arg1, arg2, arg3, arg4);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:convertToHowLong",argc, 5);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_convertToHowLong'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_sign(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::map<std::string, std::string> arg0;
        ok &= luaval_to_std_map_string_string(tolua_S, 2, &arg0, "StringUtil:sign");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_sign'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::sign(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:sign",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_sign'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_convertIntToTimeWithColon(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        unsigned int arg0;
        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "StringUtil:convertIntToTimeWithColon");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertIntToTimeWithColon'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::convertIntToTimeWithColon(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:convertIntToTimeWithColon",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_convertIntToTimeWithColon'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_convertToMinute(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        const char* arg0;
        int arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "StringUtil:convertToMinute"); arg0 = arg0_tmp.c_str();
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "StringUtil:convertToMinute");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertToMinute'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::convertToMinute(arg0, arg1);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:convertToMinute",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_convertToMinute'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_getStringLetterCount(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "StringUtil:getStringLetterCount");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_getStringLetterCount'", nullptr);
            return 0;
        }
        unsigned int ret = StringUtil::getStringLetterCount(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:getStringLetterCount",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_getStringLetterCount'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_convertIntKBMScientific(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        long long arg0;
        ok &= luaval_to_long_long(tolua_S, 2,&arg0, "StringUtil:convertIntKBMScientific");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertIntKBMScientific'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::convertIntKBMScientific(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:convertIntKBMScientific",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_convertIntKBMScientific'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_convertIntScientific(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        long long arg0;
        ok &= luaval_to_long_long(tolua_S, 2,&arg0, "StringUtil:convertIntScientific");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertIntScientific'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::convertIntScientific(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:convertIntScientific",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_convertIntScientific'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_convertIntToTime(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        unsigned int arg0;
        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "StringUtil:convertIntToTime");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertIntToTime'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::convertIntToTime(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    if (argc == 2)
    {
        unsigned int arg0;
        const char* arg1;
        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "StringUtil:convertIntToTime");
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "StringUtil:convertIntToTime"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertIntToTime'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::convertIntToTime(arg0, arg1);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:convertIntToTime",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_convertIntToTime'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_lTrim(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "StringUtil:lTrim");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_lTrim'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::lTrim(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:lTrim",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_lTrim'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_convertToDate(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        int arg0;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "StringUtil:convertToDate");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertToDate'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::convertToDate(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:convertToDate",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_convertToDate'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_convertIntKScientific(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        long long arg0;
        ok &= luaval_to_long_long(tolua_S, 2,&arg0, "StringUtil:convertIntKScientific");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertIntKScientific'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::convertIntKScientific(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:convertIntKScientific",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_convertIntKScientific'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_rTrim(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "StringUtil:rTrim");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_rTrim'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::rTrim(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:rTrim",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_rTrim'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_convertIntToTimeTest(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        unsigned int arg0;
        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "StringUtil:convertIntToTimeTest");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertIntToTimeTest'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::convertIntToTimeTest(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    if (argc == 2)
    {
        unsigned int arg0;
        const char* arg1;
        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "StringUtil:convertIntToTimeTest");
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "StringUtil:convertIntToTimeTest"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertIntToTimeTest'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::convertIntToTimeTest(arg0, arg1);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:convertIntToTimeTest",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_convertIntToTimeTest'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_cutStringWithLength(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        std::string arg0;
        int arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "StringUtil:cutStringWithLength");
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "StringUtil:cutStringWithLength");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_cutStringWithLength'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::cutStringWithLength(arg0, arg1);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    if (argc == 3)
    {
        std::string arg0;
        int arg1;
        int arg2;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "StringUtil:cutStringWithLength");
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "StringUtil:cutStringWithLength");
        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "StringUtil:cutStringWithLength");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_cutStringWithLength'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::cutStringWithLength(arg0, arg1, arg2);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:cutStringWithLength",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_cutStringWithLength'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_convertIntToDetailTime(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        unsigned int arg0;
        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "StringUtil:convertIntToDetailTime");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertIntToDetailTime'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::convertIntToDetailTime(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    if (argc == 2)
    {
        unsigned int arg0;
        const char* arg1;
        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "StringUtil:convertIntToDetailTime");
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "StringUtil:convertIntToDetailTime"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertIntToDetailTime'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::convertIntToDetailTime(arg0, arg1);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:convertIntToDetailTime",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_convertIntToDetailTime'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_getStringLength(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "StringUtil:getStringLength");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_getStringLength'", nullptr);
            return 0;
        }
        unsigned int ret = StringUtil::getStringLength(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:getStringLength",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_getStringLength'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_splitStringIntoVector(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 3)
    {
        std::vector<std::string> arg0;
        std::string arg1;
        std::string arg2;
        ok &= luaval_to_std_vector_string(tolua_S, 2, &arg0, "StringUtil:splitStringIntoVector");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "StringUtil:splitStringIntoVector");
        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "StringUtil:splitStringIntoVector");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_splitStringIntoVector'", nullptr);
            return 0;
        }
        StringUtil::splitStringIntoVector(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:splitStringIntoVector",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_splitStringIntoVector'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_getFileMd5WithFilePath(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "StringUtil:getFileMd5WithFilePath"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_getFileMd5WithFilePath'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::getFileMd5WithFilePath(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:getFileMd5WithFilePath",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_getFileMd5WithFilePath'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_convertIntToMinute(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        const char* arg0;
        int arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "StringUtil:convertIntToMinute"); arg0 = arg0_tmp.c_str();
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "StringUtil:convertIntToMinute");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertIntToMinute'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::convertIntToMinute(arg0, arg1);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:convertIntToMinute",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_convertIntToMinute'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_getUnits(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 5)
    {
        const char* arg0;
        const char* arg1;
        const char* arg2;
        const char* arg3;
        long long arg4;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "StringUtil:getUnits"); arg0 = arg0_tmp.c_str();
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "StringUtil:getUnits"); arg1 = arg1_tmp.c_str();
        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "StringUtil:getUnits"); arg2 = arg2_tmp.c_str();
        std::string arg3_tmp; ok &= luaval_to_std_string(tolua_S, 5, &arg3_tmp, "StringUtil:getUnits"); arg3 = arg3_tmp.c_str();
        ok &= luaval_to_long_long(tolua_S, 6,&arg4, "StringUtil:getUnits");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_getUnits'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::getUnits(arg0, arg1, arg2, arg3, arg4);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:getUnits",argc, 5);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_getUnits'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_replaceAll(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 3)
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "StringUtil:replaceAll");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "StringUtil:replaceAll");
        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "StringUtil:replaceAll");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_replaceAll'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::replaceAll(arg0, arg1, arg2);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:replaceAll",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_replaceAll'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_cutNameWithLength(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 4)
    {
        std::string arg0;
        int arg1;
        double arg2;
        double arg3;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "StringUtil:cutNameWithLength");
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "StringUtil:cutNameWithLength");
        ok &= luaval_to_number(tolua_S, 4,&arg2, "StringUtil:cutNameWithLength");
        ok &= luaval_to_number(tolua_S, 5,&arg3, "StringUtil:cutNameWithLength");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_cutNameWithLength'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::cutNameWithLength(arg0, arg1, arg2, arg3);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:cutNameWithLength",argc, 4);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_cutNameWithLength'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_itoa(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        long long arg0;
        ok &= luaval_to_long_long(tolua_S, 2,&arg0, "StringUtil:itoa");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_itoa'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::itoa(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:itoa",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_itoa'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_convertIntToTimeCN(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        unsigned int arg0;
        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "StringUtil:convertIntToTimeCN");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertIntToTimeCN'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::convertIntToTimeCN(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    if (argc == 2)
    {
        unsigned int arg0;
        const char* arg1;
        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "StringUtil:convertIntToTimeCN");
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "StringUtil:convertIntToTimeCN"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertIntToTimeCN'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::convertIntToTimeCN(arg0, arg1);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:convertIntToTimeCN",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_convertIntToTimeCN'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_convertDoubleScientific(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        double arg0;
        bool arg1;
        ok &= luaval_to_number(tolua_S, 2,&arg0, "StringUtil:convertDoubleScientific");
        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "StringUtil:convertDoubleScientific");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertDoubleScientific'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::convertDoubleScientific(arg0, arg1);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:convertDoubleScientific",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_convertDoubleScientific'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_length(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "StringUtil:length"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_length'", nullptr);
            return 0;
        }
        int ret = StringUtil::length(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:length",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_length'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_convertScientific(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        long long arg0;
        ok &= luaval_to_long_long(tolua_S, 2,&arg0, "StringUtil:convertScientific");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_convertScientific'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::convertScientific(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:convertScientific",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_convertScientific'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_utils_StringUtil_left(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"StringUtil",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        const char* arg0;
        int arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "StringUtil:left"); arg0 = arg0_tmp.c_str();
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "StringUtil:left");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_utils_StringUtil_left'", nullptr);
            return 0;
        }
        std::string ret = StringUtil::left(arg0, arg1);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "StringUtil:left",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_utils_StringUtil_left'.",&tolua_err);
#endif
    return 0;
}
static int lua_cpp_model_utils_StringUtil_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (StringUtil)");
    return 0;
}

int lua_register_cpp_model_utils_StringUtil(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"StringUtil");
    tolua_cclass(tolua_S,"StringUtil","StringUtil","",nullptr);

    tolua_beginmodule(tolua_S,"StringUtil");
        tolua_function(tolua_S,"trim", lua_cpp_model_utils_StringUtil_trim);
        tolua_function(tolua_S,"convertStringToInt64", lua_cpp_model_utils_StringUtil_convertStringToInt64);
        tolua_function(tolua_S,"convertIntToAboutTime", lua_cpp_model_utils_StringUtil_convertIntToAboutTime);
        tolua_function(tolua_S,"getLatterSize", lua_cpp_model_utils_StringUtil_getLatterSize);
        tolua_function(tolua_S,"convertToHowLong", lua_cpp_model_utils_StringUtil_convertToHowLong);
        tolua_function(tolua_S,"sign", lua_cpp_model_utils_StringUtil_sign);
        tolua_function(tolua_S,"convertIntToTimeWithColon", lua_cpp_model_utils_StringUtil_convertIntToTimeWithColon);
        tolua_function(tolua_S,"convertToMinute", lua_cpp_model_utils_StringUtil_convertToMinute);
        tolua_function(tolua_S,"getStringLetterCount", lua_cpp_model_utils_StringUtil_getStringLetterCount);
        tolua_function(tolua_S,"convertIntKBMScientific", lua_cpp_model_utils_StringUtil_convertIntKBMScientific);
        tolua_function(tolua_S,"convertIntScientific", lua_cpp_model_utils_StringUtil_convertIntScientific);
        tolua_function(tolua_S,"convertIntToTime", lua_cpp_model_utils_StringUtil_convertIntToTime);
        tolua_function(tolua_S,"lTrim", lua_cpp_model_utils_StringUtil_lTrim);
        tolua_function(tolua_S,"convertToDate", lua_cpp_model_utils_StringUtil_convertToDate);
        tolua_function(tolua_S,"convertIntKScientific", lua_cpp_model_utils_StringUtil_convertIntKScientific);
        tolua_function(tolua_S,"rTrim", lua_cpp_model_utils_StringUtil_rTrim);
        tolua_function(tolua_S,"convertIntToTimeTest", lua_cpp_model_utils_StringUtil_convertIntToTimeTest);
        tolua_function(tolua_S,"cutStringWithLength", lua_cpp_model_utils_StringUtil_cutStringWithLength);
        tolua_function(tolua_S,"convertIntToDetailTime", lua_cpp_model_utils_StringUtil_convertIntToDetailTime);
        tolua_function(tolua_S,"getStringLength", lua_cpp_model_utils_StringUtil_getStringLength);
        tolua_function(tolua_S,"splitStringIntoVector", lua_cpp_model_utils_StringUtil_splitStringIntoVector);
        tolua_function(tolua_S,"getFileMd5WithFilePath", lua_cpp_model_utils_StringUtil_getFileMd5WithFilePath);
        tolua_function(tolua_S,"convertIntToMinute", lua_cpp_model_utils_StringUtil_convertIntToMinute);
        tolua_function(tolua_S,"getUnits", lua_cpp_model_utils_StringUtil_getUnits);
        tolua_function(tolua_S,"replaceAll", lua_cpp_model_utils_StringUtil_replaceAll);
        tolua_function(tolua_S,"cutNameWithLength", lua_cpp_model_utils_StringUtil_cutNameWithLength);
        tolua_function(tolua_S,"itoa", lua_cpp_model_utils_StringUtil_itoa);
        tolua_function(tolua_S,"convertIntToTimeCN", lua_cpp_model_utils_StringUtil_convertIntToTimeCN);
        tolua_function(tolua_S,"convertDoubleScientific", lua_cpp_model_utils_StringUtil_convertDoubleScientific);
        tolua_function(tolua_S,"length", lua_cpp_model_utils_StringUtil_length);
        tolua_function(tolua_S,"convertScientific", lua_cpp_model_utils_StringUtil_convertScientific);
        tolua_function(tolua_S,"left", lua_cpp_model_utils_StringUtil_left);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(StringUtil).name();
    g_luaType[typeName] = "StringUtil";
    g_typeCast["StringUtil"] = "StringUtil";
    return 1;
}
TOLUA_API int register_all_cpp_model_utils(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_model_utils_StringUtil(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

