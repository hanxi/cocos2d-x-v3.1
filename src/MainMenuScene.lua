local MainMenuScene = {}

local TAG_CIRCLE = 0xff01
local TAG_COUNT  = 0xff02

local function changeVoiceIcon(voice,what)
    if what~="init" then
        if globalVoiceState=="on" then
            globalVoiceState = "off"
            util.saveData()
            util.playPauseAll()
        else
            globalVoiceState = "on"
            util.saveData()
            util.playMusic()
        end
    end
    local voiceSprite = nil
    if globalVoiceState=="on" then
        voiceSprite = cc.Sprite:create("voice_on.png")
        util.playMusic()
    else
        voiceSprite = cc.Sprite:create("voice_off.png")
    end
    if not voice then
        voice = cc.MenuItemSprite:create(voiceSprite,voiceSprite)
        print("init voice")
    else
        voice:setNormalImage(voiceSprite)
        voice:setSelectedImage(voiceSprite)
    end
    local vRect = voiceSprite:getTextureRect()
    return voice,vRect.width*2,vRect.height*2
end
 
function MainMenuScene.newScene()
    local winSize = cc.Director:getInstance():getWinSize()
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()
    
    local scene = cc.Scene:create()
    local layer    = cc.Layer:create()
    layer:setPosition(origin.x,origin.y)

    local menus = STR_MENUS
    local function menuCallback(pSender)
        local gameLevel = pSender:getTag()
        print("gameLevel",gameLevel)
        local scene = ChooseHeroScene.newScene(MainMenuScene.newScene,gameLevel)
        util.playSound()
        util.toScene(scene)
    end

    local h = visibleSize.height/(#menus+4)
    local x = visibleSize.width/2
   
    --Create Menu
    for i=1,#menus do
        local y = h*(#menus-i+2)
        local button = util.creatButtun(menus[i])
        button:setTag(i)
        button:setPosition(cc.p(x,y))
        button:registerControlEventHandler(menuCallback,cc.CONTROL_EVENTTYPE_TOUCH_DOWN )
        layer:addChild(button,6)
    end

    -- Title
    local titleLabel = util.createLabel(STR_GAME_NAME,38)
    titleLabel:setPosition(cc.p(x, h*7.3))
    titleLabel:setColor(cc.c3b(0,0,0))
    layer:addChild(titleLabel, 5)

    -- Voice button
    local function onClickVoiceButton(tag,pSender)
        util.playSound()
        changeVoiceIcon(pSender)
    end
    local voice,iw,ih = changeVoiceIcon(voice,"init")
    voice:registerScriptTapHandler(onClickVoiceButton)
    voice:setPosition(cc.p(visibleSize.width-iw/2,h*6.5))
    local voiceM = cc.Menu:create()
    voiceM:setPosition(cc.p(0,0))
    voiceM:addChild(voice)
    layer:addChild(voiceM,6)

    local line1 = util.createLine()
    line1:setContentSize(cc.size(visibleSize.width, 2))
    line1:setPosition(cc.p(x,h*6.8))
    layer:addChild(line1, 5)
    local line2 = util.createLine()
    line2:setContentSize(cc.size(visibleSize.width, 2))
    line2:setPosition(cc.p(x,h*1.5))
    layer:addChild(line2, 5)
 
    local function onClickMsgButton()
        print("click msg")
        util.playSound()
        util.showAdsAppWall()
        globalMsgCount = "0"
        util.saveData()
        layer:removeChildByTag(TAG_CIRCLE)
        layer:removeChildByTag(TAG_COUNT)
    end
    local btnl = util.creatButtun(STR_MSG)
    btnl:setPosition(cc.p(x/2,h))
    layer:addChild(btnl,6)
    btnl:registerControlEventHandler(onClickMsgButton,cc.CONTROL_EVENTTYPE_TOUCH_DOWN )

    if globalMsgCount~="0" then
        local circle = cc.Scale9Sprite:create("circle.9.png")
        layer:addChild(circle,20)
        local bS = btnl:getContentSize()
        circle:setAnchorPoint(cc.p(0.5,0.5))
        circle:setContentSize(300,200)
        circle:setScale(0.1)
        circle:setPosition(cc.p(x*0.5+0.5*bS.width,h+0.5*bS.height))
        circle:setTag(TAG_CIRCLE)

        print("globalMsgCount:",globalMsgCount)
        local sC = globalMsgCount
        if tonumber(globalMsgCount)>99 then
            sC = "99+"
        end
        local msgCount = util.createLabel(sC,15)
        print("sC:",sC)
        msgCount:setColor(cc.c3b(255,255,255))
        layer:addChild(msgCount,21)
        msgCount:setAnchorPoint(cc.p(0.5,0.5))
        msgCount:setPosition(cc.p(x*0.5+0.5*bS.width,h+0.5*bS.height))
        msgCount:setTag(TAG_COUNT)
    end
    
    local function onClickShareButton()
        print("click share")
        util.playSound()
        util.screenShare()
    end
    local btnr = util.creatButtun(STR_SHARE)
    btnr:setPosition(cc.p(3*x/2,h))
    layer:addChild(btnr,6)
    btnr:registerControlEventHandler(onClickShareButton,cc.CONTROL_EVENTTYPE_TOUCH_DOWN )

    local background = cc.LayerColor:create(cc.c4b(255, 255, 255, 255), visibleSize.width,visibleSize.height)
    layer:addChild(background, 0)

    scene:addChild(layer)

    util.registerExitGame(layer)
    
    if not isShowAdsFullThisStart then
        isShowAdsFullThisStart = 0
    end
    isShowAdsFullThisStart = isShowAdsFullThisStart + 1
    if isShowAdsFullThisStart%2==0 then
        util.showAdsFull()
    end
    return scene
end

return MainMenuScene
