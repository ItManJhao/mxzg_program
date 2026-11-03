#include "scripting/lua-bindings/auto/lua_cpp_data_roledata_auto.hpp"
#include "../../../../../runtime-src/Classes/Data/RoleData.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_data_roledata_RoleData_isFirstCharge(lua_State* tolua_S)
{
    int argc = 0;
    RoleData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"RoleData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (RoleData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_data_roledata_RoleData_isFirstCharge'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_data_roledata_RoleData_isFirstCharge'", nullptr);
            return 0;
        }
        bool ret = cobj->isFirstCharge();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RoleData:isFirstCharge",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_data_roledata_RoleData_isFirstCharge'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_data_roledata_RoleData_instance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"RoleData",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_data_roledata_RoleData_instance'", nullptr);
            return 0;
        }
        RoleData* ret = RoleData::instance();
        object_to_luaval<RoleData>(tolua_S, "RoleData",(RoleData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "RoleData:instance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_data_roledata_RoleData_instance'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_data_roledata_RoleData_constructor(lua_State* tolua_S)
{
    int argc = 0;
    RoleData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_data_roledata_RoleData_constructor'", nullptr);
            return 0;
        }
        cobj = new RoleData();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"RoleData");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "RoleData:RoleData",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_data_roledata_RoleData_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_data_roledata_RoleData_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (RoleData)");
    return 0;
}

int lua_register_cpp_data_roledata_RoleData(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"RoleData");
    tolua_cclass(tolua_S,"RoleData","RoleData","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"RoleData");
        tolua_function(tolua_S,"new",lua_cpp_data_roledata_RoleData_constructor);
        tolua_function(tolua_S,"isFirstCharge",lua_cpp_data_roledata_RoleData_isFirstCharge);
        tolua_function(tolua_S,"instance", lua_cpp_data_roledata_RoleData_instance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(RoleData).name();
    g_luaType[typeName] = "RoleData";
    g_typeCast["RoleData"] = "RoleData";
    return 1;
}
TOLUA_API int register_all_cpp_data_roledata(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_data_roledata_RoleData(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

