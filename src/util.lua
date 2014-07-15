require("AudioEngine")

util = {}

function util.createScale9Sprite()
    return cc.Scale9Sprite:create("block.9.png",cc.rect(1,1,4,4))
end

function util.createLine()
    return cc.Scale9Sprite:create("line.9.png",cc.rect(1,1,2,2))
end

function util.createLabel(str,fontsize)
    local label = cc.Label:createWithTTF(str, FONT_PATH, fontsize)
    label:setAnchorPoint(cc.p(0.5, 0.5))
    return label
end

function util.creatButtun(pStrTitle,fontsize)
    if not fontsize then
        fontsize = 24
    end
    local pBackgroundButton = util.createScale9Sprite()
    local pBackgroundHighlightedButton = util.createScale9Sprite()
    local pTitleButton = util.createLabel(pStrTitle, fontsize)
    pTitleButton:setColor(cc.c3b(255, 255, 255))
    local pButton = cc.ControlButton:create(pTitleButton, pBackgroundButton)
    pButton:setBackgroundSpriteForState(pBackgroundHighlightedButton, cc.CONTROL_STATE_HIGH_LIGHTED )
    pButton:setTitleColorForState(cc.c3b(192,255,255), cc.CONTROL_STATE_HIGH_LIGHTED )
    return pButton
end

function util.scoreToStr(score)
    local s = tostring(score)
    local s1 = string.sub(s,1,#s-3)
    local s2 = string.sub(s,#s-2,#s)
    if #s<=3 then
        s1 = "0"
        s2 = s
    end
    local str = string.format("%s.%s ''",s1,s2)
    return str
end

function util.scoreToStrName(score)
    local s = tostring(score)
    local s1 = string.sub(s,1,#s-3)
    local s2 = string.sub(s,#s-2,#s)
    if #s<=3 then
        s1 = "0"
        s2 = s
    end
    local str = string.format("%s.%s %s",s1,s2,STR_SECOND)
    return str
end

function util.toScene(scene)
    util.closeAdsBanner()
    if not scene.dontShowAdsBanner then
        util.showAdsBanner()
    end
    scene = cc.TransitionSlideInR:create(0.5, scene)
    print("scene",scene)
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(scene)
    else
        cc.Director:getInstance():runWithScene(scene)
    end
end

local iconlistcount = {
    [1] = 4,
    [2] = 4,
    [3] = 17,
    [4] = 14,
    [5] = 7,
    [6] = 2,
    [7] = 7,
    [8] = 5,
}
function util.createHero(idx)
    local cache = cc.SpriteFrameCache:getInstance()
    cache:addSpriteFrames("icon.plist")

    local sprite = cc.Sprite:createWithSpriteFrameName(string.format("icon_%d_01.png",idx))
    local sSize = sprite:getContentSize()

    local animFrames = {}
    for i=1,iconlistcount[idx] do
        local frame = cache:getSpriteFrame(string.format("icon_%d_%02d.png",idx,i))
        animFrames[i] = frame
    end
    local animation = cc.Animation:createWithSpriteFrames(animFrames, 0.1)
    sprite:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))
    sprite:setTag(MAN_BODYS_TAG)

    sprite.width = sSize.width
    sprite.height = sSize.height
    return sprite,sSize
end

function util.playInit()
    local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename(MUSIC_PATH)
    local effectPath1 = cc.FileUtils:getInstance():fullPathForFilename(SOUND_JUMP_PATH)
    local effectPath2 = cc.FileUtils:getInstance():fullPathForFilename(SOUND_PONG_PATH)
    local effectPath3 = cc.FileUtils:getInstance():fullPathForFilename(SOUND_CLICK_PATH)
    AudioEngine.preloadMusic(bgMusicPath)
    AudioEngine.preloadEffect(effectPath1)
    AudioEngine.preloadEffect(effectPath2)
    AudioEngine.preloadEffect(effectPath3)
end

function util.playMusic()
    if globalVoiceState=="off" then return end
    AudioEngine.setMusicVolume(0.5)
    if AudioEngine.isMusicPlaying() then
        return AudioEngine.resumeMusic()
    end

    local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename(MUSIC_PATH)
    AudioEngine.playMusic(bgMusicPath, true)
end

function util.playSound(what)
    if globalVoiceState=="off" then return end

    local effectPath = nil
    if what=="jump" then
        effectPath = cc.FileUtils:getInstance():fullPathForFilename(SOUND_JUMP_PATH)
    elseif what=="pong" then
        effectPath = cc.FileUtils:getInstance():fullPathForFilename(SOUND_PONG_PATH)
    else
        effectPath = cc.FileUtils:getInstance():fullPathForFilename(SOUND_CLICK_PATH)
    end
    local effectId = AudioEngine.playEffect(effectPath)
end

function util.playPauseAll()
    AudioEngine.pauseAllEffects()
    AudioEngine.pauseMusic()
    AudioEngine.setMusicVolume(0.0)
end

function util.playStopAll()
    AudioEngine.stopAllEffects()
    AudioEngine.stopMusic()
end

local dialogLayer = nil
local function removeDialogLayer()
    local function remove()
        if dialogLayer then
            dialogLayer:removeFromParent()
            dialogLayer = nil
        end
    end
    if dialogLayer then
        local action = cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(remove))
        dialogLayer:setVisible(false)
        dialogLayer:runAction(action)
    end
end

-- msg box
function util.msgBox(title,txt,pbtns)
    --title = "是否"
    --txt = "哥哥哥哥哥哥哥哥哥哥哥哥哥哥哥哥"
    --pbtns = {{"A",function()end},{"B",function()end}}

    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()
    local rect = {
        x = visibleSize.width*0.2,
        y = visibleSize.height*0.3,
        width = visibleSize.width*0.6,
        height = visibleSize.height*0.3,
    }
    local function callBackFunc1()
        print("click ".. STR_CONFIRM)
        util.playSound()
        pbtns[1][2]()
        removeDialogLayer()
    end
    local function callBackFunc2()
        print("click ".. STR_CANCEL)
        if pbtns[2] then
            util.playSound()
            pbtns[2][2]()
        end
        removeDialogLayer()
    end
    local btns = {[1] = {pbtns[1][1],callBackFunc1}}
    if pbtns[2] then
        btns[2] = {pbtns[2][1],callBackFunc2}
    end

    local scene = cc.Director:getInstance():getRunningScene()
    if scene and not dialogLayer then
        print("show dialog")
        dialogLayer = cc.LayerColor:create(cc.c4b(255,255,255,100), visibleSize.width,visibleSize.height)

        scene:addChild(dialogLayer,129)
        dialogLayer:setPosition(origin)
        local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 255), rect.width,rect.height)
        dialogLayer:addChild(layer)

        local titleLabel = util.createLabel(title,25)
        local txtLabel = util.createLabel(txt,20)
        local titleHight = titleLabel:getContentSize().height
        local bg = cc.LayerColor:create(cc.c4b(255, 255, 255, 255), rect.width-4,rect.height-4-titleHight)
        local btnCount = #btns
        if btnCount==1 then
            local btn = util.creatButtun(btns[1][1])
            layer:addChild(btn,6)
            local h = btn:getContentSize().height
            btn:setPosition(cc.p(rect.width/2,h))
            btn:registerControlEventHandler(btns[1][2],cc.CONTROL_EVENTTYPE_TOUCH_DOWN)
        elseif btnCount==2 then
            local btn1 = util.creatButtun(btns[1][1])
            layer:addChild(btn1,6)
            local h = btn1:getContentSize().height
            btn1:setPosition(cc.p(rect.width*0.25,h))
            btn1:registerControlEventHandler(btns[1][2],cc.CONTROL_EVENTTYPE_TOUCH_DOWN)

            local btn2 = util.creatButtun(btns[2][1])
            layer:addChild(btn2,6)
            local h = btn2:getContentSize().height
            btn2:setPosition(cc.p(rect.width*0.75,h))
            btn2:registerControlEventHandler(btns[2][2],cc.CONTROL_EVENTTYPE_TOUCH_DOWN)
        end

        layer:setPosition(rect.x,rect.y)

        layer:addChild(bg,0)
        layer:addChild(titleLabel,2)
        layer:addChild(txtLabel,2)

        bg:setPosition(2,2)
        titleLabel:setPosition(rect.width/2,rect.height-titleHight/2)
        titleLabel:setWidth(rect.width)
        titleLabel:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)

        txtLabel:setColor(cc.c3b(0,0,0))
        txtLabel:setPosition(rect.width/2+5,rect.height-titleHight*1.5-txtLabel:getContentSize().height/2)
        txtLabel:setWidth(rect.width-10)

        local function onTouchBegan(touch, event)
            print("ontouch")
            return true
        end
        local dialogListener = cc.EventListenerTouchOneByOne:create()
        dialogListener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
        dialogListener:setSwallowTouches(true)
        local eventDispatcher = dialogLayer:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(dialogListener, dialogLayer)

    else
        print("scene not exit")
    end
end

local function exitGameMsgBox()
    local function exitGame()
        cc.Director:getInstance():endToLua()
    end
    util.msgBox(STR_EXIT,STR_IS_EXIT,{{STR_CONFIRM,exitGame},{STR_CANCEL,function() util.closeAdsWidget() end}})
end
function util.registerExitGame(layer)
    local function onKeyReleased(keyCode, event)
        if keyCode == 0x06 then
            util.showAdsWidget()
            exitGameMsgBox()
        end
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
end

-- ads : appwall
function util.showAdsAppWall()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local args = {}
        local sigs = "()V"
        local luaj = require "luaj"
        local className = "org/cocos2dx/lua/AppActivity"
        local ok,ret  = luaj.callStaticMethod(className,"showAdsAppWall",args,sigs)
        if not ok then
            print("luaj error:", ret)
        end
    end
end

-- ads : fullscreen
function util.showAdsFull(best)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local s = STR_BEST_SCORE_NOTICE
        if not best then
            local r = math.random(1,#STR_TIPS)
            s = STR_TIPS[r]
        end
        local str = string.format("%s %s",STR_ADS_NOTICE,s)
        local args = {str}
        local sigs = "(Ljava/lang/String;)V"
        local luaj = require "luaj"
        local className = "org/cocos2dx/lua/AppActivity"
        local ok,ret  = luaj.callStaticMethod(className,"showAdsFull",args,sigs)
        if not ok then
            print("luaj error:", ret)
        end
    end
end

-- bottom
function util.showAdsWidget()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local args = {}
        local sigs = "()V"
        local luaj = require "luaj"
        local className = "org/cocos2dx/lua/AppActivity"
        local ok,ret  = luaj.callStaticMethod(className,"showAdsWidget",args,sigs)
        if not ok then
            print("luaj error:", ret)
        end
    end
end

function util.closeAdsWidget()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local args = {}
        local sigs = "()V"
        local luaj = require "luaj"
        local className = "org/cocos2dx/lua/AppActivity"
        local ok,ret  = luaj.callStaticMethod(className,"closeAdsWidget",args,sigs)
        if not ok then
            print("luaj error:", ret)
        end
    end
end

function util.showAdsBanner()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local args = {}
        local sigs = "()V"
        local luaj = require "luaj"
        local className = "org/cocos2dx/lua/AppActivity"
        local ok,ret  = luaj.callStaticMethod(className,"showAdsBanner",args,sigs)
        if not ok then
            print("luaj error:", ret)
        end
    end
end

function util.closeAdsBanner()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local args = {}
        local sigs = "()V"
        local luaj = require "luaj"
        local className = "org/cocos2dx/lua/AppActivity"
        local ok,ret  = luaj.callStaticMethod(className,"closeAdsBanner",args,sigs)
        if not ok then
            print("luaj error:", ret)
        end
    end
end

-- share
function util.screenShare()
    local size = cc.Director:getInstance():getWinSize()
    local screen = cc.RenderTexture:create(
        size.width,size.height,
        cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
    local scene = cc.Director:getInstance():getRunningScene()
    screen:begin()
    scene:visit()
    screen:endToLua()
    screen:saveToFile(STR_SHARE_IMG,cc.IMAGE_FORMAT_PNG)
    local sf = screen:getSprite():getSpriteFrame()
    local sprite = cc.Sprite:createWithSpriteFrame(sf)
    sprite:setAnchorPoint(0.5,0.5)
    sprite:setRotationSkewX(180)
    scene:addChild(sprite)
    sprite:setPosition(cc.p(size.width/2,size.height/2))
    local function endAction()
        sprite:removeFromParent()
    end
    local action = cc.Sequence:create(cc.ScaleTo:create(0.5,0.3),
        cc.CallFunc:create(endAction))
    sprite:runAction(action)

    local function delayToShare()
        local targetPlatform = cc.Application:getInstance():getTargetPlatform()
        if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
            local args = {STR_SHARE_TITLE,STR_SHARE,STR_SHARE_IMG,STR_SHARE_DTITLE}
            local sigs = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"
            local luaj = require "luaj"
            local className = "org/cocos2dx/lua/AppActivity"
            local ok,ret  = luaj.callStaticMethod(className,"share",args,sigs)
            if not ok then
                print("luaj error:", ret)
            end
        end
    end
    scene:runAction(cc.Sequence:create(cc.DelayTime:create(0.8),
        cc.CallFunc:create(delayToShare)))
end

local function bin2hex(s)
    s=string.gsub(s,"(.)",function (x) return string.format("%02X ",string.byte(x)) end)
    return s
end

local h2b = {
    ["0"] = 0,
    ["1"] = 1,
    ["2"] = 2,
    ["3"] = 3,
    ["4"] = 4,
    ["5"] = 5,
    ["6"] = 6,
    ["7"] = 7,
    ["8"] = 8,
    ["9"] = 9,
    ["A"] = 10,
    ["B"] = 11,
    ["C"] = 12,
    ["D"] = 13,
    ["E"] = 14,
    ["F"] = 15
}

local function hex2bin( hexstr )
    local s = string.gsub(hexstr, "(.)(.)%s", function ( h, l )
         return string.char(h2b[h]*16+h2b[l])
    end)
    return s
end

local keyToId = {
    globalVoiceState = 1,
    globalBestScore1 = 2,
    globalBestScore2 = 3,
    globalBestScore3 = 4,
    globalBestScore4 = 5,
    globalBestScore5 = 6,
    globalMsgCount   = 7,
}
local function setStringForKey(key,value)
    if not keyToId[key] then return end
    local id = string.format("hanxi%02d",keyToId[key])
    value = bin2hex(value)
    cc.UserDefault:getInstance():setStringForKey(id,value)
end

local function getStringForKey(key)
    if not keyToId[key] then return end
    local id = string.format("hanxi%02d",keyToId[key])
    local value = cc.UserDefault:getInstance():getStringForKey(id)
    if string.len(value)>0 then 
        value = hex2bin(value)
    end
    return value
end

-- savedata
function util.loadData()
    -- global variable
    globalMsgCount = "0"
    globalVoiceState = "on"
    globalBestScore = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0,
    }

    local voiceState = getStringForKey("globalVoiceState")
    if string.len(voiceState)>0 then
        globalVoiceState = voiceState
    else
        setStringForKey("globalVoiceState", globalVoiceState)
    end
    local mC = getStringForKey("globalMsgCount")
    if string.len(mC)>0 then
        globalMsgCount = mC
    else
        setStringForKey("globalMsgCount",globalMsgCount)
    end
    for i,v in ipairs(globalBestScore) do
        local score = getStringForKey("globalBestScore"..i)
        if string.len(score)>0 then
            globalBestScore[i] = tonumber(score)
        else
            setStringForKey("globalBestScore"..i,tostring(v))
        end
    end
    print("writeAblePath:",cc.FileUtils:getInstance():getWritablePath())
end

function util.saveData()
    setStringForKey("globalVoiceState", globalVoiceState)
    setStringForKey("globalMsgCount",globalMsgCount)
    for i,v in ipairs(globalBestScore) do
        setStringForKey("globalBestScore"..i,tostring(v))
    end
    cc.UserDefault:getInstance():flush()
end

function util.requestHttp(url,callBackFunc)
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open("GET", url)
    xhr:registerScriptHandler(callBackFunc)
    xhr:send()
    return xhr
end

function util.isNetConnect()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local args = {}
        local sigs = "()Z"
        local luaj = require "luaj"
        local className = "org/cocos2dx/lua/AppActivity"
        local ok,ret  = luaj.callStaticMethod(className,"isNetConnect",args,sigs)
        if ok then
            return ret
        end
    end
    return true
end

return util

