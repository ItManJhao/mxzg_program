#include "scripting/lua-bindings/auto/lua_cpp_person_hero_auto.hpp"
#include "../../../../../runtime-src/Classes/Person/Hero.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_cpp_person_hero_UIMenuItemBattle_initDone(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemBattle* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UIMenuItemBattle",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UIMenuItemBattle*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_UIMenuItemBattle_initDone'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_UIMenuItemBattle_initDone'", nullptr);
            return 0;
        }
        cobj->initDone();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UIMenuItemBattle:initDone",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_UIMenuItemBattle_initDone'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_UIMenuItemBattle_createWithSpriteFrameName(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UIMenuItemBattle",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 4)
    {
        const char* arg0;
        std::function<void (cocos2d::Ref *)> arg1;
        int arg2;
        int arg3;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "UIMenuItemBattle:createWithSpriteFrameName"); arg0 = arg0_tmp.c_str();
        do {
			// Lambda binding for lua is not supported.
			assert(false);
		} while(0)
		;
        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "UIMenuItemBattle:createWithSpriteFrameName");
        ok &= luaval_to_int32(tolua_S, 5,(int *)&arg3, "UIMenuItemBattle:createWithSpriteFrameName");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_UIMenuItemBattle_createWithSpriteFrameName'", nullptr);
            return 0;
        }
        UIMenuItemBattle* ret = UIMenuItemBattle::createWithSpriteFrameName(arg0, arg1, arg2, arg3);
        object_to_luaval<UIMenuItemBattle>(tolua_S, "UIMenuItemBattle",(UIMenuItemBattle*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UIMenuItemBattle:createWithSpriteFrameName",argc, 4);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_UIMenuItemBattle_createWithSpriteFrameName'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_person_hero_UIMenuItemBattle_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UIMenuItemBattle* cobj = nullptr;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

    argc = lua_gettop(tolua_S)-1;
    do{
        if (argc == 2) {
            int arg0;
            ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "UIMenuItemBattle:UIMenuItemBattle");

            if (!ok) { break; }
            int arg1;
            ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "UIMenuItemBattle:UIMenuItemBattle");

            if (!ok) { break; }
            cobj = new UIMenuItemBattle(arg0, arg1);
            tolua_pushusertype(tolua_S,(void*)cobj,"UIMenuItemBattle");
            tolua_register_gc(tolua_S,lua_gettop(tolua_S));
            return 1;
        }
    }while(0);
    ok  = true;
    do{
        if (argc == 0) {
            cobj = new UIMenuItemBattle();
            tolua_pushusertype(tolua_S,(void*)cobj,"UIMenuItemBattle");
            tolua_register_gc(tolua_S,lua_gettop(tolua_S));
            return 1;
        }
    }while(0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n",  "UIMenuItemBattle:UIMenuItemBattle",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_UIMenuItemBattle_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_person_hero_UIMenuItemBattle_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UIMenuItemBattle)");
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (
    !tolua_isusertype(tolua_S,1,"UIMenuItemBattle",0,&tolua_err) ||
    !tolua_isnoobj(tolua_S,2,&tolua_err)
    )
        goto tolua_lerror;
    else
#endif
    {
        UIMenuItemBattle* self = (UIMenuItemBattle*)  tolua_tousertype(tolua_S,1,0);
#if COCOS2D_DEBUG >= 1
        if (!self) tolua_error(tolua_S,"invalid 'self' in function 'delete'", nullptr);
#endif
        delete self;
    }
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'delete'.",&tolua_err);
    return 0;
#endif
    return 0;
}

int lua_register_cpp_person_hero_UIMenuItemBattle(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UIMenuItemBattle");
    tolua_cclass(tolua_S,"UIMenuItemBattle","UIMenuItemBattle","UIMenuItemImage",lua_cpp_person_hero_UIMenuItemBattle_finalize);

    tolua_beginmodule(tolua_S,"UIMenuItemBattle");
        tolua_function(tolua_S,"new",lua_cpp_person_hero_UIMenuItemBattle_constructor);
        tolua_function(tolua_S,"initDone",lua_cpp_person_hero_UIMenuItemBattle_initDone);
        tolua_function(tolua_S,"createWithSpriteFrameName", lua_cpp_person_hero_UIMenuItemBattle_createWithSpriteFrameName);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UIMenuItemBattle).name();
    g_luaType[typeName] = "UIMenuItemBattle";
    g_typeCast["UIMenuItemBattle"] = "UIMenuItemBattle";
    return 1;
}

int lua_cpp_person_hero_Unit_moveTo(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_moveTo'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        cocos2d::Point arg0;
        int arg1;
        ActionType arg2;

        ok &= luaval_to_point(tolua_S, 2, &arg0, "Unit:moveTo");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "Unit:moveTo");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "Unit:moveTo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_moveTo'", nullptr);
            return 0;
        }
        cobj->moveTo(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:moveTo",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_moveTo'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_activate(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_activate'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_activate'", nullptr);
            return 0;
        }
        cobj->activate();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:activate",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_activate'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_getUnuseSkillTag(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_getUnuseSkillTag'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_getUnuseSkillTag'", nullptr);
            return 0;
        }
        int ret = cobj->getUnuseSkillTag();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Unit:getUnuseSkillTag");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_getUnuseSkillTag'", nullptr);
            return 0;
        }
        int ret = cobj->getUnuseSkillTag(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:getUnuseSkillTag",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_getUnuseSkillTag'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_setSelected(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_setSelected'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "Unit:setSelected");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_setSelected'", nullptr);
            return 0;
        }
        cobj->setSelected(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:setSelected",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_setSelected'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_getAttackO(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_getAttackO'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_getAttackO'", nullptr);
            return 0;
        }
        int ret = cobj->getAttackO();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:getAttackO",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_getAttackO'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_reborn(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_reborn'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_reborn'", nullptr);
            return 0;
        }
        cobj->reborn();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:reborn",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_reborn'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_beattack(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_beattack'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 5) 
    {
        int arg0;
        int arg1;
        int arg2;
        bool arg3;
        double arg4;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Unit:beattack");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "Unit:beattack");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "Unit:beattack");

        ok &= luaval_to_boolean(tolua_S, 5,&arg3, "Unit:beattack");

        ok &= luaval_to_number(tolua_S, 6,&arg4, "Unit:beattack");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_beattack'", nullptr);
            return 0;
        }
        cobj->beattack(arg0, arg1, arg2, arg3, arg4);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:beattack",argc, 5);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_beattack'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_showHP(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_showHP'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_showHP'", nullptr);
            return 0;
        }
        cobj->showHP();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:showHP",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_showHP'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_skill(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_skill'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Point arg0;
        int arg1;

        ok &= luaval_to_point(tolua_S, 2, &arg0, "Unit:skill");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "Unit:skill");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_skill'", nullptr);
            return 0;
        }
        cobj->skill(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:skill",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_skill'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_setAttack(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_setAttack'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Unit:setAttack");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_setAttack'", nullptr);
            return 0;
        }
        cobj->setAttack(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:setAttack",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_setAttack'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_selected(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_selected'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_selected'", nullptr);
            return 0;
        }
        cobj->selected();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:selected",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_selected'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_setHp(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_setHp'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Unit:setHp");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_setHp'", nullptr);
            return 0;
        }
        cobj->setHp(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:setHp",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_setHp'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_hideHP(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_hideHP'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_hideHP'", nullptr);
            return 0;
        }
        cobj->hideHP();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:hideHP",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_hideHP'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_setHpO(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_setHpO'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Unit:setHpO");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_setHpO'", nullptr);
            return 0;
        }
        cobj->setHpO(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:setHpO",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_setHpO'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_attack(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_attack'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Point arg0;
        int arg1;

        ok &= luaval_to_point(tolua_S, 2, &arg0, "Unit:attack");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "Unit:attack");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_attack'", nullptr);
            return 0;
        }
        cobj->attack(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:attack",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_attack'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_getHpO(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_getHpO'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_getHpO'", nullptr);
            return 0;
        }
        int ret = cobj->getHpO();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:getHpO",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_getHpO'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_stand(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_stand'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Unit:stand");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_stand'", nullptr);
            return 0;
        }
        cobj->stand(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:stand",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_stand'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_getHp(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_getHp'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_getHp'", nullptr);
            return 0;
        }
        int ret = cobj->getHp();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:getHp",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_getHp'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_getAnger(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_getAnger'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_getAnger'", nullptr);
            return 0;
        }
        int ret = cobj->getAnger();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:getAnger",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_getAnger'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_setHpMax(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_setHpMax'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Unit:setHpMax");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_setHpMax'", nullptr);
            return 0;
        }
        cobj->setHpMax(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:setHpMax",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_setHpMax'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_isDie(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_isDie'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_isDie'", nullptr);
            return 0;
        }
        bool ret = cobj->isDie();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:isDie",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_isDie'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_die(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_die'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        Unit* arg0;

        ok &= luaval_to_object<Unit>(tolua_S, 2, "Unit",&arg0, "Unit:die");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_die'", nullptr);
            return 0;
        }
        cobj->die(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:die",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_die'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_getHpMax(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_getHpMax'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_getHpMax'", nullptr);
            return 0;
        }
        int ret = cobj->getHpMax();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:getHpMax",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_getHpMax'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_getSkillNode(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_getSkillNode'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Unit:getSkillNode");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_getSkillNode'", nullptr);
            return 0;
        }
        cocos2d::Node* ret = cobj->getSkillNode(arg0);
        object_to_luaval<cocos2d::Node>(tolua_S, "cc.Node",(cocos2d::Node*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:getSkillNode",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_getSkillNode'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_getAttack(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_getAttack'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_getAttack'", nullptr);
            return 0;
        }
        int ret = cobj->getAttack();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:getAttack",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_getAttack'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_setAnger(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_setAnger'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Unit:setAnger");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_setAnger'", nullptr);
            return 0;
        }
        cobj->setAnger(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:setAnger",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_setAnger'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_setAttackO(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_setAttackO'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Unit:setAttackO");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_setAttackO'", nullptr);
            return 0;
        }
        cobj->setAttackO(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:setAttackO",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_setAttackO'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_unselected(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Unit*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Unit_unselected'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_unselected'", nullptr);
            return 0;
        }
        cobj->unselected();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:unselected",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_unselected'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Unit_constructor(lua_State* tolua_S)
{
    int argc = 0;
    Unit* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Unit_constructor'", nullptr);
            return 0;
        }
        cobj = new Unit();
        tolua_pushusertype(tolua_S,(void*)cobj,"Unit");
        tolua_register_gc(tolua_S,lua_gettop(tolua_S));
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Unit:Unit",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Unit_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_person_hero_Unit_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (Unit)");
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (
    !tolua_isusertype(tolua_S,1,"Unit",0,&tolua_err) ||
    !tolua_isnoobj(tolua_S,2,&tolua_err)
    )
        goto tolua_lerror;
    else
#endif
    {
        Unit* self = (Unit*)  tolua_tousertype(tolua_S,1,0);
#if COCOS2D_DEBUG >= 1
        if (!self) tolua_error(tolua_S,"invalid 'self' in function 'delete'", nullptr);
#endif
        delete self;
    }
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'delete'.",&tolua_err);
    return 0;
#endif
    return 0;
}

int lua_register_cpp_person_hero_Unit(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"Unit");
    tolua_cclass(tolua_S,"Unit","Unit","UIMenuItemBattle",lua_cpp_person_hero_Unit_finalize);

    tolua_beginmodule(tolua_S,"Unit");
        tolua_function(tolua_S,"new",lua_cpp_person_hero_Unit_constructor);
        tolua_function(tolua_S,"moveTo",lua_cpp_person_hero_Unit_moveTo);
        tolua_function(tolua_S,"activate",lua_cpp_person_hero_Unit_activate);
        tolua_function(tolua_S,"getUnuseSkillTag",lua_cpp_person_hero_Unit_getUnuseSkillTag);
        tolua_function(tolua_S,"setSelected",lua_cpp_person_hero_Unit_setSelected);
        tolua_function(tolua_S,"getAttackO",lua_cpp_person_hero_Unit_getAttackO);
        tolua_function(tolua_S,"reborn",lua_cpp_person_hero_Unit_reborn);
        tolua_function(tolua_S,"beattack",lua_cpp_person_hero_Unit_beattack);
        tolua_function(tolua_S,"showHP",lua_cpp_person_hero_Unit_showHP);
        tolua_function(tolua_S,"skill",lua_cpp_person_hero_Unit_skill);
        tolua_function(tolua_S,"setAttack",lua_cpp_person_hero_Unit_setAttack);
        tolua_function(tolua_S,"selected",lua_cpp_person_hero_Unit_selected);
        tolua_function(tolua_S,"setHp",lua_cpp_person_hero_Unit_setHp);
        tolua_function(tolua_S,"hideHP",lua_cpp_person_hero_Unit_hideHP);
        tolua_function(tolua_S,"setHpO",lua_cpp_person_hero_Unit_setHpO);
        tolua_function(tolua_S,"attack",lua_cpp_person_hero_Unit_attack);
        tolua_function(tolua_S,"getHpO",lua_cpp_person_hero_Unit_getHpO);
        tolua_function(tolua_S,"stand",lua_cpp_person_hero_Unit_stand);
        tolua_function(tolua_S,"getHp",lua_cpp_person_hero_Unit_getHp);
        tolua_function(tolua_S,"getAnger",lua_cpp_person_hero_Unit_getAnger);
        tolua_function(tolua_S,"setHpMax",lua_cpp_person_hero_Unit_setHpMax);
        tolua_function(tolua_S,"isDie",lua_cpp_person_hero_Unit_isDie);
        tolua_function(tolua_S,"die",lua_cpp_person_hero_Unit_die);
        tolua_function(tolua_S,"getHpMax",lua_cpp_person_hero_Unit_getHpMax);
        tolua_function(tolua_S,"getSkillNode",lua_cpp_person_hero_Unit_getSkillNode);
        tolua_function(tolua_S,"getAttack",lua_cpp_person_hero_Unit_getAttack);
        tolua_function(tolua_S,"setAnger",lua_cpp_person_hero_Unit_setAnger);
        tolua_function(tolua_S,"setAttackO",lua_cpp_person_hero_Unit_setAttackO);
        tolua_function(tolua_S,"unselected",lua_cpp_person_hero_Unit_unselected);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(Unit).name();
    g_luaType[typeName] = "Unit";
    g_typeCast["Unit"] = "Unit";
    return 1;
}

int lua_cpp_person_hero_Hero_showAnger(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_showAnger'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_showAnger'", nullptr);
            return 0;
        }
        cobj->showAnger();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:showAnger",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_showAnger'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_setSelected(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_setSelected'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "Hero:setSelected");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_setSelected'", nullptr);
            return 0;
        }
        cobj->setSelected(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:setSelected",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_setSelected'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_setFlippedX(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_setFlippedX'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "Hero:setFlippedX");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_setFlippedX'", nullptr);
            return 0;
        }
        cobj->setFlippedX(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:setFlippedX",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_setFlippedX'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_updateZOrder(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_updateZOrder'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "Hero:updateZOrder");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_updateZOrder'", nullptr);
            return 0;
        }
        cobj->updateZOrder(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:updateZOrder",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_updateZOrder'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_setAnimationNode(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_setAnimationNode'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        spine::SkeletonAnimation* arg0;

        ok &= luaval_to_object<spine::SkeletonAnimation>(tolua_S, 2, "sp.SkeletonAnimation",&arg0, "Hero:setAnimationNode");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_setAnimationNode'", nullptr);
            return 0;
        }
        cobj->setAnimationNode(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:setAnimationNode",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_setAnimationNode'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_reborn(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_reborn'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_reborn'", nullptr);
            return 0;
        }
        cobj->reborn();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:reborn",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_reborn'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_setShowDamage(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_setShowDamage'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "Hero:setShowDamage");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_setShowDamage'", nullptr);
            return 0;
        }
        cobj->setShowDamage(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:setShowDamage",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_setShowDamage'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_getAnimationNode(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_getAnimationNode'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_getAnimationNode'", nullptr);
            return 0;
        }
        spine::SkeletonAnimation* ret = cobj->getAnimationNode();
        object_to_luaval<spine::SkeletonAnimation>(tolua_S, "sp.SkeletonAnimation",(spine::SkeletonAnimation*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:getAnimationNode",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_getAnimationNode'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_beattack(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_beattack'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 8) 
    {
        long long arg0;
        int arg1;
        int arg2;
        int arg3;
        int arg4;
        int arg5;
        bool arg6;
        double arg7;

        ok &= luaval_to_long_long(tolua_S, 2,&arg0, "Hero:beattack");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "Hero:beattack");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "Hero:beattack");

        ok &= luaval_to_int32(tolua_S, 5,(int *)&arg3, "Hero:beattack");

        ok &= luaval_to_int32(tolua_S, 6,(int *)&arg4, "Hero:beattack");

        ok &= luaval_to_int32(tolua_S, 7,(int *)&arg5, "Hero:beattack");

        ok &= luaval_to_boolean(tolua_S, 8,&arg6, "Hero:beattack");

        ok &= luaval_to_number(tolua_S, 9,&arg7, "Hero:beattack");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_beattack'", nullptr);
            return 0;
        }
        cobj->beattack(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:beattack",argc, 8);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_beattack'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_showHP(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_showHP'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_showHP'", nullptr);
            return 0;
        }
        cobj->showHP();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:showHP",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_showHP'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_setAnimation(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_setAnimation'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        int arg0;
        std::string arg1;
        bool arg2;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Hero:setAnimation");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "Hero:setAnimation");

        ok &= luaval_to_boolean(tolua_S, 4,&arg2, "Hero:setAnimation");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_setAnimation'", nullptr);
            return 0;
        }
        spTrackEntry* ret = cobj->setAnimation(arg0, arg1, arg2);
        #pragma warning NO CONVERSION FROM NATIVE FOR spTrackEntry*;
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:setAnimation",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_setAnimation'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_hideElem(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_hideElem'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_hideElem'", nullptr);
            return 0;
        }
        cobj->hideElem();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:hideElem",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_hideElem'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_setShadowVisible(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_setShadowVisible'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "Hero:setShadowVisible");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_setShadowVisible'", nullptr);
            return 0;
        }
        cobj->setShadowVisible(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:setShadowVisible",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_setShadowVisible'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_updateBuffIcon(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_updateBuffIcon'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_updateBuffIcon'", nullptr);
            return 0;
        }
        cobj->updateBuffIcon();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:updateBuffIcon",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_updateBuffIcon'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_hideLevel(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_hideLevel'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_hideLevel'", nullptr);
            return 0;
        }
        cobj->hideLevel();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:hideLevel",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_hideLevel'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_hideHP(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_hideHP'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_hideHP'", nullptr);
            return 0;
        }
        cobj->hideHP();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:hideHP",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_hideHP'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_attack(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_attack'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_attack'", nullptr);
            return 0;
        }
        cobj->attack();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:attack",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_attack'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_setHeroAnimationByType(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_setHeroAnimationByType'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Hero:setHeroAnimationByType");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_setHeroAnimationByType'", nullptr);
            return 0;
        }
        cobj->setHeroAnimationByType(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:setHeroAnimationByType",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_setHeroAnimationByType'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_isShowDamage(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_isShowDamage'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_isShowDamage'", nullptr);
            return 0;
        }
        bool ret = cobj->isShowDamage();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:isShowDamage",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_isShowDamage'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_startUpdateZOrder(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_startUpdateZOrder'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_startUpdateZOrder'", nullptr);
            return 0;
        }
        cobj->startUpdateZOrder();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:startUpdateZOrder",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_startUpdateZOrder'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_setShader(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_setShader'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        ShaderType arg0;
        bool arg1;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Hero:setShader");

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "Hero:setShader");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_setShader'", nullptr);
            return 0;
        }
        cobj->setShader(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 3) 
    {
        ShaderType arg0;
        bool arg1;
        std::string arg2;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Hero:setShader");

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "Hero:setShader");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "Hero:setShader");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_setShader'", nullptr);
            return 0;
        }
        cobj->setShader(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 4) 
    {
        ShaderType arg0;
        bool arg1;
        std::string arg2;
        bool arg3;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Hero:setShader");

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "Hero:setShader");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "Hero:setShader");

        ok &= luaval_to_boolean(tolua_S, 5,&arg3, "Hero:setShader");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_setShader'", nullptr);
            return 0;
        }
        cobj->setShader(arg0, arg1, arg2, arg3);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:setShader",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_setShader'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_mergeDamage(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_mergeDamage'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_mergeDamage'", nullptr);
            return 0;
        }
        cobj->mergeDamage();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:mergeDamage",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_mergeDamage'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_isRunAction(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_isRunAction'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_isRunAction'", nullptr);
            return 0;
        }
        bool ret = cobj->isRunAction();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:isRunAction",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_isRunAction'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_setRunAction(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_setRunAction'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "Hero:setRunAction");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_setRunAction'", nullptr);
            return 0;
        }
        cobj->setRunAction(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:setRunAction",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_setRunAction'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_update(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_update'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "Hero:update");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_update'", nullptr);
            return 0;
        }
        cobj->update(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:update",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_update'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_initHero(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_initHero'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_initHero'", nullptr);
            return 0;
        }
        cobj->initHero();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:initHero",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_initHero'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_showLevel(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_showLevel'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Hero:showLevel");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_showLevel'", nullptr);
            return 0;
        }
        cocos2d::Label* ret = cobj->showLevel(arg0);
        object_to_luaval<cocos2d::Label>(tolua_S, "cc.Label",(cocos2d::Label*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:showLevel",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_showLevel'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_hideAnger(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_hideAnger'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_hideAnger'", nullptr);
            return 0;
        }
        cobj->hideAnger();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:hideAnger",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_hideAnger'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_showAbilityTip(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_showAbilityTip'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_showAbilityTip'", nullptr);
            return 0;
        }
        cobj->showAbilityTip();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:showAbilityTip",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_showAbilityTip'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_stopUpdateZOrder(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_stopUpdateZOrder'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Hero:stopUpdateZOrder");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_stopUpdateZOrder'", nullptr);
            return 0;
        }
        cobj->stopUpdateZOrder(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:stopUpdateZOrder",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_stopUpdateZOrder'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_addAbilityTip(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_addAbilityTip'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        int arg0;
        int arg1;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Hero:addAbilityTip");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "Hero:addAbilityTip");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_addAbilityTip'", nullptr);
            return 0;
        }
        cobj->addAbilityTip(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:addAbilityTip",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_addAbilityTip'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_addAnimation(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_addAnimation'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        int arg0;
        std::string arg1;
        bool arg2;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Hero:addAnimation");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "Hero:addAnimation");

        ok &= luaval_to_boolean(tolua_S, 4,&arg2, "Hero:addAnimation");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_addAnimation'", nullptr);
            return 0;
        }
        spTrackEntry* ret = cobj->addAnimation(arg0, arg1, arg2);
        #pragma warning NO CONVERSION FROM NATIVE FOR spTrackEntry*;
        return 1;
    }
    if (argc == 4) 
    {
        int arg0;
        std::string arg1;
        bool arg2;
        double arg3;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Hero:addAnimation");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "Hero:addAnimation");

        ok &= luaval_to_boolean(tolua_S, 4,&arg2, "Hero:addAnimation");

        ok &= luaval_to_number(tolua_S, 5,&arg3, "Hero:addAnimation");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_addAnimation'", nullptr);
            return 0;
        }
        spTrackEntry* ret = cobj->addAnimation(arg0, arg1, arg2, arg3);
        #pragma warning NO CONVERSION FROM NATIVE FOR spTrackEntry*;
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:addAnimation",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_addAnimation'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_addAbilityTextTip(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_addAbilityTextTip'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "Hero:addAbilityTextTip");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_addAbilityTextTip'", nullptr);
            return 0;
        }
        cobj->addAbilityTextTip(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:addAbilityTextTip",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_addAbilityTextTip'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_die(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_die'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        Unit* arg0;

        ok &= luaval_to_object<Unit>(tolua_S, 2, "Unit",&arg0, "Hero:die");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_die'", nullptr);
            return 0;
        }
        cobj->die(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:die",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_die'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_resetTimeScale(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_resetTimeScale'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_resetTimeScale'", nullptr);
            return 0;
        }
        cobj->resetTimeScale();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:resetTimeScale",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_resetTimeScale'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_showElem(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_showElem'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "Hero:showElem");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_showElem'", nullptr);
            return 0;
        }
        cocos2d::Sprite* ret = cobj->showElem(arg0);
        object_to_luaval<cocos2d::Sprite>(tolua_S, "cc.Sprite",(cocos2d::Sprite*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:showElem",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_showElem'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_isFlippedX(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_isFlippedX'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_isFlippedX'", nullptr);
            return 0;
        }
        bool ret = cobj->isFlippedX();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:isFlippedX",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_isFlippedX'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_stand(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_stand'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_stand'", nullptr);
            return 0;
        }
        cobj->stand();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:stand",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_stand'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_showDamage(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Hero*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cpp_person_hero_Hero_showDamage'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_showDamage'", nullptr);
            return 0;
        }
        cobj->showDamage();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Hero:showDamage",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_showDamage'.",&tolua_err);
#endif

    return 0;
}
int lua_cpp_person_hero_Hero_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Hero",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 6)
    {
        long long arg0;
        long long arg1;
        int arg2;
        int arg3;
        int arg4;
        int arg5;
        ok &= luaval_to_long_long(tolua_S, 2,&arg0, "Hero:create");
        ok &= luaval_to_long_long(tolua_S, 3,&arg1, "Hero:create");
        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "Hero:create");
        ok &= luaval_to_int32(tolua_S, 5,(int *)&arg3, "Hero:create");
        ok &= luaval_to_int32(tolua_S, 6,(int *)&arg4, "Hero:create");
        ok &= luaval_to_int32(tolua_S, 7,(int *)&arg5, "Hero:create");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cpp_person_hero_Hero_create'", nullptr);
            return 0;
        }
        Hero* ret = Hero::create(arg0, arg1, arg2, arg3, arg4, arg5);
        object_to_luaval<Hero>(tolua_S, "Hero",(Hero*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Hero:create",argc, 6);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cpp_person_hero_Hero_constructor(lua_State* tolua_S)
{
    int argc = 0;
    Hero* cobj = nullptr;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

    argc = lua_gettop(tolua_S)-1;
    do{
        if (argc == 6) {
            long long arg0;
            ok &= luaval_to_long_long(tolua_S, 2,&arg0, "Hero:Hero");

            if (!ok) { break; }
            long long arg1;
            ok &= luaval_to_long_long(tolua_S, 3,&arg1, "Hero:Hero");

            if (!ok) { break; }
            int arg2;
            ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "Hero:Hero");

            if (!ok) { break; }
            int arg3;
            ok &= luaval_to_int32(tolua_S, 5,(int *)&arg3, "Hero:Hero");

            if (!ok) { break; }
            int arg4;
            ok &= luaval_to_int32(tolua_S, 6,(int *)&arg4, "Hero:Hero");

            if (!ok) { break; }
            int arg5;
            ok &= luaval_to_int32(tolua_S, 7,(int *)&arg5, "Hero:Hero");

            if (!ok) { break; }
            cobj = new Hero(arg0, arg1, arg2, arg3, arg4, arg5);
            tolua_pushusertype(tolua_S,(void*)cobj,"Hero");
            tolua_register_gc(tolua_S,lua_gettop(tolua_S));
            return 1;
        }
    }while(0);
    ok  = true;
    do{
        if (argc == 0) {
            cobj = new Hero();
            tolua_pushusertype(tolua_S,(void*)cobj,"Hero");
            tolua_register_gc(tolua_S,lua_gettop(tolua_S));
            return 1;
        }
    }while(0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n",  "Hero:Hero",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cpp_person_hero_Hero_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cpp_person_hero_Hero_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (Hero)");
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (
    !tolua_isusertype(tolua_S,1,"Hero",0,&tolua_err) ||
    !tolua_isnoobj(tolua_S,2,&tolua_err)
    )
        goto tolua_lerror;
    else
#endif
    {
        Hero* self = (Hero*)  tolua_tousertype(tolua_S,1,0);
#if COCOS2D_DEBUG >= 1
        if (!self) tolua_error(tolua_S,"invalid 'self' in function 'delete'", nullptr);
#endif
        delete self;
    }
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'delete'.",&tolua_err);
    return 0;
#endif
    return 0;
}

int lua_register_cpp_person_hero_Hero(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"Hero");
    tolua_cclass(tolua_S,"Hero","Hero","Unit",lua_cpp_person_hero_Hero_finalize);

    tolua_beginmodule(tolua_S,"Hero");
        tolua_function(tolua_S,"new",lua_cpp_person_hero_Hero_constructor);
        tolua_function(tolua_S,"showAnger",lua_cpp_person_hero_Hero_showAnger);
        tolua_function(tolua_S,"setSelected",lua_cpp_person_hero_Hero_setSelected);
        tolua_function(tolua_S,"setFlippedX",lua_cpp_person_hero_Hero_setFlippedX);
        tolua_function(tolua_S,"updateZOrder",lua_cpp_person_hero_Hero_updateZOrder);
        tolua_function(tolua_S,"setAnimationNode",lua_cpp_person_hero_Hero_setAnimationNode);
        tolua_function(tolua_S,"reborn",lua_cpp_person_hero_Hero_reborn);
        tolua_function(tolua_S,"setShowDamage",lua_cpp_person_hero_Hero_setShowDamage);
        tolua_function(tolua_S,"getAnimationNode",lua_cpp_person_hero_Hero_getAnimationNode);
        tolua_function(tolua_S,"beattack",lua_cpp_person_hero_Hero_beattack);
        tolua_function(tolua_S,"showHP",lua_cpp_person_hero_Hero_showHP);
        tolua_function(tolua_S,"setAnimation",lua_cpp_person_hero_Hero_setAnimation);
        tolua_function(tolua_S,"hideElem",lua_cpp_person_hero_Hero_hideElem);
        tolua_function(tolua_S,"setShadowVisible",lua_cpp_person_hero_Hero_setShadowVisible);
        tolua_function(tolua_S,"updateBuffIcon",lua_cpp_person_hero_Hero_updateBuffIcon);
        tolua_function(tolua_S,"hideLevel",lua_cpp_person_hero_Hero_hideLevel);
        tolua_function(tolua_S,"hideHP",lua_cpp_person_hero_Hero_hideHP);
        tolua_function(tolua_S,"attack",lua_cpp_person_hero_Hero_attack);
        tolua_function(tolua_S,"setHeroAnimationByType",lua_cpp_person_hero_Hero_setHeroAnimationByType);
        tolua_function(tolua_S,"isShowDamage",lua_cpp_person_hero_Hero_isShowDamage);
        tolua_function(tolua_S,"startUpdateZOrder",lua_cpp_person_hero_Hero_startUpdateZOrder);
        tolua_function(tolua_S,"setShader",lua_cpp_person_hero_Hero_setShader);
        tolua_function(tolua_S,"mergeDamage",lua_cpp_person_hero_Hero_mergeDamage);
        tolua_function(tolua_S,"isRunAction",lua_cpp_person_hero_Hero_isRunAction);
        tolua_function(tolua_S,"setRunAction",lua_cpp_person_hero_Hero_setRunAction);
        tolua_function(tolua_S,"update",lua_cpp_person_hero_Hero_update);
        tolua_function(tolua_S,"initHero",lua_cpp_person_hero_Hero_initHero);
        tolua_function(tolua_S,"showLevel",lua_cpp_person_hero_Hero_showLevel);
        tolua_function(tolua_S,"hideAnger",lua_cpp_person_hero_Hero_hideAnger);
        tolua_function(tolua_S,"showAbilityTip",lua_cpp_person_hero_Hero_showAbilityTip);
        tolua_function(tolua_S,"stopUpdateZOrder",lua_cpp_person_hero_Hero_stopUpdateZOrder);
        tolua_function(tolua_S,"addAbilityTip",lua_cpp_person_hero_Hero_addAbilityTip);
        tolua_function(tolua_S,"addAnimation",lua_cpp_person_hero_Hero_addAnimation);
        tolua_function(tolua_S,"addAbilityTextTip",lua_cpp_person_hero_Hero_addAbilityTextTip);
        tolua_function(tolua_S,"die",lua_cpp_person_hero_Hero_die);
        tolua_function(tolua_S,"resetTimeScale",lua_cpp_person_hero_Hero_resetTimeScale);
        tolua_function(tolua_S,"showElem",lua_cpp_person_hero_Hero_showElem);
        tolua_function(tolua_S,"isFlippedX",lua_cpp_person_hero_Hero_isFlippedX);
        tolua_function(tolua_S,"stand",lua_cpp_person_hero_Hero_stand);
        tolua_function(tolua_S,"showDamage",lua_cpp_person_hero_Hero_showDamage);
        tolua_function(tolua_S,"create", lua_cpp_person_hero_Hero_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(Hero).name();
    g_luaType[typeName] = "Hero";
    g_typeCast["Hero"] = "Hero";
    return 1;
}
TOLUA_API int register_all_cpp_person_hero(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");

	lua_register_cpp_person_hero_UIMenuItemBattle(tolua_S);
	lua_register_cpp_person_hero_Unit(tolua_S);
	lua_register_cpp_person_hero_Hero(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

