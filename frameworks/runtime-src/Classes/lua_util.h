#ifndef COCOS2DX_COCOS_SCRIPTING_LUA_BINDINGS_LUA_UTIL_H
#define COCOS2DX_COCOS_SCRIPTING_LUA_BINDINGS_LUA_UTIL_H

#ifdef __cplusplus
extern "C" {
#endif
#include "tolua++.h"
#ifdef __cplusplus
}
#endif

TOLUA_API int register_util(lua_State* tolua_S);

#endif // #ifdef COCOS2DX_COCOS_SCRIPTING_LUA_BINDINGS_LUA_UTIL_H
