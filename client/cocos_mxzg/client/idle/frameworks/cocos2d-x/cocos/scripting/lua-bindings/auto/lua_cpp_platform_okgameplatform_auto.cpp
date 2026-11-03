#include "scripting/lua-bindings/auto/lua_cpp_platform_okgameplatform_auto.hpp"
#include "../../../../../runtime-src/Classes/Platform/SocialPlatform.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"
TOLUA_API int register_all_cpp_platform_okgameplatform(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cpp",0);
	tolua_beginmodule(tolua_S,"cpp");


	tolua_endmodule(tolua_S);
	return 1;
}

