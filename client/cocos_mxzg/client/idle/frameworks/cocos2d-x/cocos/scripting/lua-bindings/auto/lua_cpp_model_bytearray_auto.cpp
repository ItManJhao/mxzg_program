#include "scripting/lua-bindings/auto/lua_cpp_model_bytearray_auto.hpp"
#include "../../../../../runtime-src/Classes/Model/ByteArray.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_model_bytearray_ByteArray_writeString(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_writeString'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        std::string arg0;
        int arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "ByteArray:writeString");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "ByteArray:writeString");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_writeString'", nullptr);
            return 0;
        }
        cobj->writeString(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:writeString",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_writeString'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_readBool(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_readBool'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_readBool'", nullptr);
            return 0;
        }
        bool ret = cobj->readBool();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:readBool",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_readBool'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_pushCallBackData(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_pushCallBackData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        LuaCallBackData* arg0;

        ok &= luaval_to_object<LuaCallBackData>(tolua_S, 2, "LuaCallBackData",&arg0, "ByteArray:pushCallBackData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_pushCallBackData'", nullptr);
            return 0;
        }
        cobj->pushCallBackData(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:pushCallBackData",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_pushCallBackData'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_readByte(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_readByte'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_readByte'", nullptr);
            return 0;
        }
        int32_t ret = cobj->readByte();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:readByte",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_readByte'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_pushData(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_pushData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        void* arg0;
        int arg1;

        #pragma warning NO CONVERSION TO NATIVE FOR void*
		ok = false;

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "ByteArray:pushData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_pushData'", nullptr);
            return 0;
        }
        cobj->pushData(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:pushData",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_pushData'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_readInt8(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_readInt8'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_readInt8'", nullptr);
            return 0;
        }
        int ret = cobj->readInt8();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:readInt8",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_readInt8'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_getLength(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_getLength'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_getLength'", nullptr);
            return 0;
        }
        int ret = cobj->getLength();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:getLength",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_getLength'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_readInt64(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_readInt64'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_readInt64'", nullptr);
            return 0;
        }
        std::string ret = cobj->readInt64();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:readInt64",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_readInt64'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_readString(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_readString'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "ByteArray:readString");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_readString'", nullptr);
            return 0;
        }
        std::string ret = cobj->readString(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:readString",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_readString'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_writeBool(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_writeBool'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "ByteArray:writeBool");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_writeBool'", nullptr);
            return 0;
        }
        cobj->writeBool(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:writeBool",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_writeBool'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_print(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_print'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_print'", nullptr);
            return 0;
        }
        cobj->print();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:print",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_print'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_getData(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_getData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_getData'", nullptr);
            return 0;
        }
        void* ret = cobj->getData();
        #pragma warning NO CONVERSION FROM NATIVE FOR void*;
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:getData",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_getData'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_readInt(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_readInt'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_readInt'", nullptr);
            return 0;
        }
        int ret = cobj->readInt();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:readInt",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_readInt'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_writeInt64(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_writeInt64'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "ByteArray:writeInt64");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_writeInt64'", nullptr);
            return 0;
        }
        cobj->writeInt64(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:writeInt64",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_writeInt64'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_resetPos(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_resetPos'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_resetPos'", nullptr);
            return 0;
        }
        cobj->resetPos();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:resetPos",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_resetPos'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_writeByte(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_writeByte'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int32_t arg0;

        ok &= luaval_to_int32(tolua_S, 2,&arg0, "ByteArray:writeByte");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_writeByte'", nullptr);
            return 0;
        }
        cobj->writeByte(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:writeByte",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_writeByte'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_readCallBackData(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_readCallBackData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_readCallBackData'", nullptr);
            return 0;
        }
        LuaCallBackData* ret = cobj->readCallBackData();
        object_to_luaval<LuaCallBackData>(tolua_S, "LuaCallBackData",(LuaCallBackData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:readCallBackData",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_readCallBackData'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_writeInt16(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_writeInt16'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "ByteArray:writeInt16");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_writeInt16'", nullptr);
            return 0;
        }
        cobj->writeInt16(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:writeInt16",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_writeInt16'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_writeInt8(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_writeInt8'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "ByteArray:writeInt8");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_writeInt8'", nullptr);
            return 0;
        }
        cobj->writeInt8(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:writeInt8",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_writeInt8'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_readInt16(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_readInt16'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_readInt16'", nullptr);
            return 0;
        }
        int ret = cobj->readInt16();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:readInt16",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_readInt16'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_writeInt(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_ByteArray_writeInt'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "ByteArray:writeInt");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_writeInt'", nullptr);
            return 0;
        }
        cobj->writeInt(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:writeInt",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_writeInt'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_ByteArray_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"ByteArray",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_create'", nullptr);
            return 0;
        }
        ByteArray* ret = ByteArray::create();
        object_to_luaval<ByteArray>(tolua_S, "ByteArray",(ByteArray*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "ByteArray:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_model_bytearray_ByteArray_constructor(lua_State* tolua_S)
{
    int argc = 0;
    ByteArray* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_ByteArray_constructor'", nullptr);
            return 0;
        }
        cobj = new ByteArray();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"ByteArray");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ByteArray:ByteArray",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_ByteArray_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_model_bytearray_ByteArray_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (ByteArray)");
    return 0;
}

int lua_register_cpp_model_bytearray_ByteArray(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"ByteArray");
    tolua_cclass(tolua_S,"ByteArray","ByteArray","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"ByteArray");
        tolua_function(tolua_S,"new",lua_cpp_model_bytearray_ByteArray_constructor);
        tolua_function(tolua_S,"writeString",lua_cpp_model_bytearray_ByteArray_writeString);
        tolua_function(tolua_S,"readBool",lua_cpp_model_bytearray_ByteArray_readBool);
        tolua_function(tolua_S,"pushCallBackData",lua_cpp_model_bytearray_ByteArray_pushCallBackData);
        tolua_function(tolua_S,"readByte",lua_cpp_model_bytearray_ByteArray_readByte);
        tolua_function(tolua_S,"pushData",lua_cpp_model_bytearray_ByteArray_pushData);
        tolua_function(tolua_S,"readInt8",lua_cpp_model_bytearray_ByteArray_readInt8);
        tolua_function(tolua_S,"getLength",lua_cpp_model_bytearray_ByteArray_getLength);
        tolua_function(tolua_S,"readInt64",lua_cpp_model_bytearray_ByteArray_readInt64);
        tolua_function(tolua_S,"readString",lua_cpp_model_bytearray_ByteArray_readString);
        tolua_function(tolua_S,"writeBool",lua_cpp_model_bytearray_ByteArray_writeBool);
        tolua_function(tolua_S,"print",lua_cpp_model_bytearray_ByteArray_print);
        tolua_function(tolua_S,"getData",lua_cpp_model_bytearray_ByteArray_getData);
        tolua_function(tolua_S,"readInt",lua_cpp_model_bytearray_ByteArray_readInt);
        tolua_function(tolua_S,"writeInt64",lua_cpp_model_bytearray_ByteArray_writeInt64);
        tolua_function(tolua_S,"resetPos",lua_cpp_model_bytearray_ByteArray_resetPos);
        tolua_function(tolua_S,"writeByte",lua_cpp_model_bytearray_ByteArray_writeByte);
        tolua_function(tolua_S,"readCallBackData",lua_cpp_model_bytearray_ByteArray_readCallBackData);
        tolua_function(tolua_S,"writeInt16",lua_cpp_model_bytearray_ByteArray_writeInt16);
        tolua_function(tolua_S,"writeInt8",lua_cpp_model_bytearray_ByteArray_writeInt8);
        tolua_function(tolua_S,"readInt16",lua_cpp_model_bytearray_ByteArray_readInt16);
        tolua_function(tolua_S,"writeInt",lua_cpp_model_bytearray_ByteArray_writeInt);
        tolua_function(tolua_S,"create", lua_cpp_model_bytearray_ByteArray_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(ByteArray).name();
    g_luaType[typeName] = "ByteArray";
    g_typeCast["ByteArray"] = "ByteArray";
    return 1;
}

int lua_cpp_model_bytearray_LuaCallBackData_setUserData(lua_State* tolua_S)
{
    int argc = 0;
    LuaCallBackData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaCallBackData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaCallBackData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_LuaCallBackData_setUserData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        ByteArray* arg0;

        ok &= luaval_to_object<ByteArray>(tolua_S, 2, "ByteArray",&arg0, "LuaCallBackData:setUserData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_LuaCallBackData_setUserData'", nullptr);
            return 0;
        }
        cobj->setUserData(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaCallBackData:setUserData",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_LuaCallBackData_setUserData'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_LuaCallBackData_setNode(lua_State* tolua_S)
{
    int argc = 0;
    LuaCallBackData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaCallBackData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaCallBackData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_LuaCallBackData_setNode'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Node* arg0;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "LuaCallBackData:setNode");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_LuaCallBackData_setNode'", nullptr);
            return 0;
        }
        cobj->setNode(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaCallBackData:setNode",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_LuaCallBackData_setNode'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_LuaCallBackData_setCaller(lua_State* tolua_S)
{
    int argc = 0;
    LuaCallBackData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaCallBackData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaCallBackData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_LuaCallBackData_setCaller'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Node* arg0;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "LuaCallBackData:setCaller");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_LuaCallBackData_setCaller'", nullptr);
            return 0;
        }
        cobj->setCaller(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaCallBackData:setCaller",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_LuaCallBackData_setCaller'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_LuaCallBackData_getUserData(lua_State* tolua_S)
{
    int argc = 0;
    LuaCallBackData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaCallBackData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaCallBackData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_LuaCallBackData_getUserData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_LuaCallBackData_getUserData'", nullptr);
            return 0;
        }
        ByteArray* ret = cobj->getUserData();
        object_to_luaval<ByteArray>(tolua_S, "ByteArray",(ByteArray*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaCallBackData:getUserData",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_LuaCallBackData_getUserData'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_LuaCallBackData_setNodeName(lua_State* tolua_S)
{
    int argc = 0;
    LuaCallBackData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaCallBackData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaCallBackData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_LuaCallBackData_setNodeName'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LuaCallBackData:setNodeName");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_LuaCallBackData_setNodeName'", nullptr);
            return 0;
        }
        cobj->setNodeName(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaCallBackData:setNodeName",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_LuaCallBackData_setNodeName'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_LuaCallBackData_getCaller(lua_State* tolua_S)
{
    int argc = 0;
    LuaCallBackData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaCallBackData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaCallBackData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_LuaCallBackData_getCaller'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_LuaCallBackData_getCaller'", nullptr);
            return 0;
        }
        cocos2d::Node* ret = cobj->getCaller();
        object_to_luaval<cocos2d::Node>(tolua_S, "cc.Node",(cocos2d::Node*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaCallBackData:getCaller",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_LuaCallBackData_getCaller'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_LuaCallBackData_getNodeName(lua_State* tolua_S)
{
    int argc = 0;
    LuaCallBackData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaCallBackData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaCallBackData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_LuaCallBackData_getNodeName'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_LuaCallBackData_getNodeName'", nullptr);
            return 0;
        }
        std::string ret = cobj->getNodeName();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaCallBackData:getNodeName",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_LuaCallBackData_getNodeName'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_LuaCallBackData_getNode(lua_State* tolua_S)
{
    int argc = 0;
    LuaCallBackData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"LuaCallBackData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (LuaCallBackData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_model_bytearray_LuaCallBackData_getNode'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_LuaCallBackData_getNode'", nullptr);
            return 0;
        }
        cocos2d::Node* ret = cobj->getNode();
        object_to_luaval<cocos2d::Node>(tolua_S, "cc.Node",(cocos2d::Node*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaCallBackData:getNode",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_LuaCallBackData_getNode'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_model_bytearray_LuaCallBackData_constructor(lua_State* tolua_S)
{
    int argc = 0;
    LuaCallBackData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_model_bytearray_LuaCallBackData_constructor'", nullptr);
            return 0;
        }
        cobj = new LuaCallBackData();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"LuaCallBackData");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "LuaCallBackData:LuaCallBackData",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_model_bytearray_LuaCallBackData_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_model_bytearray_LuaCallBackData_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (LuaCallBackData)");
    return 0;
}

int lua_register_cpp_model_bytearray_LuaCallBackData(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"LuaCallBackData");
    tolua_cclass(tolua_S,"LuaCallBackData","LuaCallBackData","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"LuaCallBackData");
        tolua_function(tolua_S,"new",lua_cpp_model_bytearray_LuaCallBackData_constructor);
        tolua_function(tolua_S,"setUserData",lua_cpp_model_bytearray_LuaCallBackData_setUserData);
        tolua_function(tolua_S,"setNode",lua_cpp_model_bytearray_LuaCallBackData_setNode);
        tolua_function(tolua_S,"setCaller",lua_cpp_model_bytearray_LuaCallBackData_setCaller);
        tolua_function(tolua_S,"getUserData",lua_cpp_model_bytearray_LuaCallBackData_getUserData);
        tolua_function(tolua_S,"setNodeName",lua_cpp_model_bytearray_LuaCallBackData_setNodeName);
        tolua_function(tolua_S,"getCaller",lua_cpp_model_bytearray_LuaCallBackData_getCaller);
        tolua_function(tolua_S,"getNodeName",lua_cpp_model_bytearray_LuaCallBackData_getNodeName);
        tolua_function(tolua_S,"getNode",lua_cpp_model_bytearray_LuaCallBackData_getNode);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(LuaCallBackData).name();
    g_luaType[typeName] = "LuaCallBackData";
    g_typeCast["LuaCallBackData"] = "LuaCallBackData";
    return 1;
}
TOLUA_API int register_all_cpp_model_bytearray(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_model_bytearray_ByteArray(tolua_S);
	lua_register_cpp_model_bytearray_LuaCallBackData(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

