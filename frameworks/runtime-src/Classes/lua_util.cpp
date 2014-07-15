#include "lua_util.h"

#ifdef __cplusplus
extern "C" {
#endif
#include  "tolua_fix.h"
#ifdef __cplusplus
}
#endif

#include "cocos2d.h"
#include "extensions/cocos-ext.h"

#include <string>
#include <cstring>

static int lua_millisecondNow(lua_State * luastate)
{
    struct timeval v;
    gettimeofday(&v, (struct timezone *) NULL);
    /* Unix Epoch time (time since January 1, 1970 (UTC)) */
    long t = v.tv_sec*1000 + v.tv_usec/1000;
    lua_pushnumber(luastate,t);
    return 1;
}

int register_util(lua_State* L)
{
    tolua_open(L);
    tolua_module(L, NULL, 0);
    tolua_beginmodule(L, NULL);
    tolua_function(L, "millisecondNow", lua_millisecondNow);
    tolua_endmodule(L);
    return 0;
}

