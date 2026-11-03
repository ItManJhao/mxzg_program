#include "lua_cpp_comp_messageview_auto.hpp"
#include "../../../../../runtime-src/Classes/Comp/MessageView.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"


int lua_cpp_comp_messageview_MessageView_addNotice(lua_State* tolua_S)
{
    int argc = 0;
    MessageView* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MessageView",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MessageView*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_messageview_MessageView_addNotice'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "MessageView:addNotice");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_messageview_MessageView_addNotice'", nullptr);
            return 0;
        }
        cobj->addNotice(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MessageView:addNotice",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_messageview_MessageView_addNotice'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_messageview_MessageView_add(lua_State* tolua_S)
{
    int argc = 0;
    MessageView* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MessageView",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MessageView*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_messageview_MessageView_add'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "MessageView:add");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_messageview_MessageView_add'", nullptr);
            return 0;
        }
        cobj->add(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        int32_t arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "MessageView:add");

        ok &= luaval_to_int32(tolua_S, 3,&arg1, "MessageView:add");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_messageview_MessageView_add'", nullptr);
            return 0;
        }
        cobj->add(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MessageView:add",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_messageview_MessageView_add'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_messageview_MessageView_clear(lua_State* tolua_S)
{
    int argc = 0;
    MessageView* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MessageView",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MessageView*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_comp_messageview_MessageView_clear'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_messageview_MessageView_clear'", nullptr);
            return 0;
        }
        cobj->clear();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MessageView:clear",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_messageview_MessageView_clear'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_comp_messageview_MessageView_instance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"MessageView",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_messageview_MessageView_instance'", nullptr);
            return 0;
        }
        MessageView* ret = MessageView::instance();
        object_to_luaval<MessageView>(tolua_S, "MessageView",(MessageView*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "MessageView:instance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_messageview_MessageView_instance'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_comp_messageview_MessageView_constructor(lua_State* tolua_S)
{
    int argc = 0;
    MessageView* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_comp_messageview_MessageView_constructor'", nullptr);
            return 0;
        }
        cobj = new MessageView();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"MessageView");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MessageView:MessageView",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_comp_messageview_MessageView_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_comp_messageview_MessageView_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (MessageView)");
    return 0;
}

int lua_register_cpp_comp_messageview_MessageView(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"MessageView");
    tolua_cclass(tolua_S,"MessageView","MessageView","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"MessageView");
        tolua_function(tolua_S,"new",lua_cpp_comp_messageview_MessageView_constructor);
        tolua_function(tolua_S,"addNotice",lua_cpp_comp_messageview_MessageView_addNotice);
        tolua_function(tolua_S,"add",lua_cpp_comp_messageview_MessageView_add);
        tolua_function(tolua_S,"clear",lua_cpp_comp_messageview_MessageView_clear);
        tolua_function(tolua_S,"instance", lua_cpp_comp_messageview_MessageView_instance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(MessageView).name();
    g_luaType[typeName] = "MessageView";
    g_typeCast["MessageView"] = "MessageView";
    return 1;
}
TOLUA_API int register_all_cpp_comp_messageview(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_comp_messageview_MessageView(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

