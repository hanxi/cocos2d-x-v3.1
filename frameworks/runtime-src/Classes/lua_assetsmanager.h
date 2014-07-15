#ifndef COCOS2DX_COCOS_SCRIPTING_LUA_BINDINGS_LUA_ASSETSMANAGER_H
#define COCOS2DX_COCOS_SCRIPTING_LUA_BINDINGS_LUA_ASSETSMANAGER_H

#ifdef __cplusplus
extern "C" {
#endif
#include "tolua++.h"
#ifdef __cplusplus
}
#endif

TOLUA_API int register_assetsmanager(lua_State* tolua_S);

#endif // #ifndef COCOS2DX_COCOS_SCRIPTING_LUA_BINDINGS_LUA_ASSETSMANAGER_H
