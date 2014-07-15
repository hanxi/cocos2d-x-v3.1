require "Cocos2d"
require "Cocos2dConstants"

-- cclog
cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end

math.randomseed(os.time())

local updateSavePath = createDownloadDir()
addSearchPath(updateSavePath,true)

require("src/conf")
HelloScene = require("src/HelloScene")

local function main()
    cc.FileUtils:getInstance():addSearchResolutionsOrder("src")
    cc.FileUtils:getInstance():addSearchResolutionsOrder("res")

    HelloScene.newScene()
end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end

