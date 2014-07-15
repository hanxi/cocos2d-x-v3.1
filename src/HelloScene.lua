local HelloScene = {}

MainMenuScene = require("src/MainMenuScene")
ChooseHeroScene = require("src/ChooseHeroScene")
GameScene = require("src/GameScene")
GameOverScene = require("src/GameOverScene")
RankScene = require("src/RankScene")
util = require("src/util")

function HelloScene.newScene()
    util.loadData()
    util.playInit()

    globalMsgCount = tostring(tonumber(globalMsgCount) + 1)
    util.saveData()

    local winSize = cc.Director:getInstance():getWinSize()
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()
    
    local scene = cc.Director:getInstance():getRunningScene()

    local layer = cc.Layer:create()
    scene:addChild(layer,1)
    util.registerExitGame(layer)
    layer:setPosition(origin.x,origin.y)
    local progressLable = util.createLabel(STR_UPDATE_MSG,18)
    layer:addChild(progressLable,5)
    progressLable:setPosition(cc.p(visibleSize.width/2,visibleSize.height*0.18))
    progressLable:setColor(cc.c3b(0,0,255))

    -- update layer
    local block            = nil
    local assetsManager    = nil
    local xhr              = nil
    local needDownloadSize = 0
    local updateSavePath   = createDownloadDir()

    local function reloadModule(moduleName)
        package.loaded[moduleName] = nil
        return require(moduleName)
    end

    local function reload()
        reloadModule("src/conf")
        HelloScene = reloadModule("src/HelloScene")
        MainMenuScene = reloadModule("src/MainMenuScene")
        ChooseHeroScene = reloadModule("src/ChooseHeroScene")
        GameScene = reloadModule("src/GameScene")
        GameOverScene = reloadModule("src/GameOverScene")
        util = reloadModule("src/util")
        util.loadData()
        util.playInit()
    end

    local function onError(errorCode)
        if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
            --progressLable:setString("no new version")
            print("no new version")
        elseif errorCode == cc.ASSETSMANAGER_NETWORK then
            --progressLable:setString("network error")
            print("network error")
        end
        --util.toScene(MainMenuScene.newScene())
        util.toScene(RankScene.newScene())
    end

    local function onProgress( percent )
        if block==nil then 
            local updateLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 255), visibleSize.width*0.8,18)
            layer:addChild(updateLayer,3)
            updateLayer:setPosition(cc.p(visibleSize.width*0.1,visibleSize.height*0.08))
            local blockLength = visibleSize.width*0.8
            block = cc.LayerColor:create(cc.c4b(255, 0, 0, 255), blockLength,12)
            block:setAnchorPoint(cc.p(0,0.5))
            updateLayer:addChild(block)
            block:setPosition(cc.p(0,3))
            block:setScaleX(0.01)

            local function callBackFunc()
                print("statusText:",xhr.statusText)
                print("response:",xhr.response)
                if string.find(xhr.statusText,"OK") then
                    local s = string.gsub(xhr.response, "(%d.*%.)", "")
                    print(s)
                    needDownloadSize = tonumber(s)
                end
            end
            xhr = util.requestHttp(UPDATE_VESION_PATH,callBackFunc)
        else
            block:setScaleX(percent/100)
        end
        local function sizeToStr(size)
            local str = ""
            local s = 0
            local s1 = size/1024
            local s2 = s1/1024
            if s2>1 then
                str = "M"
                s = s2
            else
                str = "K"
                s = s1
            end
            return string.format("%.1f%s",s,str)
        end
        if percent>=0 and percent<=100 and needDownloadSize>0 then
            local sizeStr = sizeToStr(needDownloadSize)
            local progress = string.format(STR_UPDATE_NOTICE,sizeStr,percent)
            progressLable:setString(progress)
            print("onProgress:",progress)
        end
    end

    local function onSuccess()
        --progressLable:setString("downloading ok")
        print("downloading ok")
        reload()
        --util.toScene(MainMenuScene.newScene())
        util.toScene(RankScene.newScene())
    end

    local function getAssetsManager()
        if nil == assetsManager then
            print(UPDATE_PACK_PATH,UPDATE_VESION_PATH)
            assetsManager = cc.AssetsManager:new(UPDATE_PACK_PATH,
                                                 UPDATE_VESION_PATH,
                                                 updateSavePath)
            assetsManager:retain()
            assetsManager:setDelegate(onError, cc.ASSETSMANAGER_PROTOCOL_ERROR )
            assetsManager:setDelegate(onProgress, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
            assetsManager:setDelegate(onSuccess, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )
            assetsManager:setConnectionTimeout(5)
        end
        return assetsManager
    end

    local function onNodeEvent(event)
        if "exit" == event then
            if nil ~= assetsManager then
                assetsManager:release()
                assetsManager = nil 
            end 
        end
    end 
    layer:registerScriptHandler(onNodeEvent)

    if util.isNetConnect() then
        getAssetsManager():update()
    else
        util.toScene(MainMenuScene.newScene())
    end

    local t = cc.FileUtils:getInstance():getSearchPaths()
    for k,v in ipairs(t) do
        print(k,v)
    end

    return scene
end

return HelloScene

