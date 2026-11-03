//
//  LuaManual.h
//  cleck
//
//  Created by hua on 2019/4/4.
//

#ifndef LuaManual_h
#define LuaManual_h

#ifdef __cplusplus
extern "C" {
#endif
#include "tolua++.h"
#ifdef __cplusplus
}
#endif



TOLUA_API int  register_cpp_module(lua_State* tolua_S);


/// @cond
TOLUA_API int  register_all_cpp_manual(lua_State* tolua_S);
/// @endcond

#endif /* LuaManual_h */
