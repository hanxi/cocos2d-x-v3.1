local GameOverScene = {}

function GameOverScene.newScene(heroIdx,gameLevel,nowScore)
    local winSize = cc.Director:getInstance():getWinSize()
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()
    
    local scene = cc.Scene:create()
    local layer = cc.Layer:create()
    layer:setPosition(origin.x,origin.y)

    local h = visibleSize.height/9
    local x = visibleSize.width/2

    -- Title
    local titleTxt = STR_MENUS[gameLevel]..STR_MO_SHI
    local titleLabel = util.createLabel(titleTxt,38)
    layer:addChild(titleLabel, 5)
    titleLabel:setPosition(cc.p(x, h*7))
    -- label game name
    local gameNameLabel = util.createLabel(STR_GAME_NAME, 20)
    layer:addChild(gameNameLabel,5)
    local tSize = gameNameLabel:getContentSize()
    gameNameLabel:setPosition(cc.p(visibleSize.width-tSize.width/2,visibleSize.height-tSize.height/2))

    -- score label
    local nowScoreTxt = util.scoreToStrName(nowScore)
    local scoreLabel = util.createLabel(nowScoreTxt, 38)
    layer:addChild(scoreLabel,5)
    scoreLabel:setPosition(cc.p(x,h*5))
    local bestScoreTxt = STR_BEST..util.scoreToStrName(globalBestScore[gameLevel])
    local bestScoreLabel = util.createLabel(bestScoreTxt,20)
    layer:addChild(bestScoreLabel,5)
    bestScoreLabel:setPosition(cc.p(x,h*4))

    local line1 = util.createLine()
    line1:setContentSize(cc.size(visibleSize.width*0.7, 2))
    line1:setPosition(cc.p(x,h*6.5))
    layer:addChild(line1, 5)
    local line2 = util.createLine()
    line2:setContentSize(cc.size(visibleSize.width, 2))
    line2:setPosition(cc.p(x,h*2))
    layer:addChild(line2, 5)
 
    -- buttons 
    local function onClickShareButton()
        print("click share")
        util.playSound()
        util.screenShare()
    end
    local btnl = util.creatButtun(STR_SHARE_SCORE)
    btnl:setPosition(cc.p(visibleSize.width*0.2,h))
    layer:addChild(btnl,6)
    btnl:registerControlEventHandler(onClickShareButton,cc.CONTROL_EVENTTYPE_TOUCH_DOWN )

    local function onClickBack()
        print("click back")
        util.playSound()
        local scene = MainMenuScene.newScene()
        util.toScene(scene)
    end
    local btnm = util.creatButtun(STR_BACK)
    btnm:setPosition(cc.p(visibleSize.width*0.5,h))
    layer:addChild(btnm,6)
    btnm:registerControlEventHandler(onClickBack,cc.CONTROL_EVENTTYPE_TOUCH_DOWN )

    local function onClickAgain()
        print("click again")
        util.playSound()
        local scene = GameScene.newScene(heroIdx,gameLevel)
        scene.dontShowAdsBanner = true
        util.toScene(scene)
    end
    local btnr = util.creatButtun(STR_AGAIN)
    btnr:setPosition(cc.p(visibleSize.width*0.8,h))
    layer:addChild(btnr,6)
    btnr:registerControlEventHandler(onClickAgain,cc.CONTROL_EVENTTYPE_TOUCH_DOWN )


    local background = cc.LayerColor:create(cc.c4b(255, 0, 0, 255), visibleSize.width,visibleSize.height)
    layer:addChild(background, 0)

    local function onKeyReleased(keyCode, event)
        if keyCode == 0x06 then
            local scene = MainMenuScene.newScene()
            util.toScene(scene)
        end
    end
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    scene:addChild(layer)

    if nowScore == globalBestScore[gameLevel] then
        util.showAdsFull(true)
    end

    return scene
end

return GameOverScene

