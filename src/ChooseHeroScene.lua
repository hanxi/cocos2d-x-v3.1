local ChooseHeroScene = {}

local ACTIONJUMP_TAG = 0x86
local heroIdx = 7

local function createActionJump(h)
    local actionBy = cc.JumpBy:create(0.5, cc.p(0,0), h, 1)
    local actionJump = cc.RepeatForever:create(actionBy)
    actionJump:setTag(ACTIONJUMP_TAG)
    return actionJump
end

function ChooseHeroScene.newScene(preSceneFunc,gameLevel)
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()
    local scene  = cc.Scene:create()
    local layer  = cc.Layer:create()
    layer:setPosition(origin.x,origin.y)

    local h = visibleSize.height/9
    local x = visibleSize.width/2
    
    local heros = {}

    for i=1,5 do
        local line = util.createLine()
        local h1 = h*5.5
        local h0 = h*1.5
        local ph = (h1+h0)/5
        local y = h0+(i-1)*ph
        if i==5 then
            line:setContentSize(cc.size(visibleSize.width*0.6, 2))
            line:setPosition(cc.p(x,y-h*0.15))
        else
            -- create hero
            local herol = util.createHero(i*2-1)
            herol.x = x/2
            herol.y = y+herol.height/2
            herol:setPosition(cc.p(herol.x,herol.y))
            layer:addChild(herol, 1)
            herol.content = {x=origin.x,y=origin.y+herol.y-herol.height/2,width=visibleSize.width/2,height=ph}
            heros[i*2-1] = herol

            local heror = util.createHero(i*2)
            heror.x = x*1.5
            heror.y = y+heror.height/2
            heror:setPosition(cc.p(heror.x,heror.y))
            layer:addChild(heror, 1)
            heror.content = {x=origin.x+visibleSize.width/2,y=origin.y+heror.y-heror.height/2,width=visibleSize.width/2,height=ph}
            heros[i*2] = heror

            line:setContentSize(cc.size(visibleSize.width, 2))
            line:setPosition(cc.p(x,y))
        end
        layer:addChild(line, 1)
    end

    -- Title
    local titleLabel = util.createLabel(STR_CHOOSE_HERO,38)
    titleLabel:setPosition(cc.p(x, h*7.3))
    titleLabel:setColor(cc.c3b(0,0,0))
    layer:addChild(titleLabel, 5)

    local function backToPreScene()
        util.playSound()
        local scene = preSceneFunc()
        if scene ~= nil then
            util.toScene(scene)
        end
    end
    local btnl = util.creatButtun(STR_BACK)
    btnl:setPosition(cc.p(x/2,h))
    layer:addChild(btnl,6)
    btnl:registerControlEventHandler(backToPreScene,cc.CONTROL_EVENTTYPE_TOUCH_DOWN )
    local function onClickStartButton()
        print("click start")
        util.playSound()
        local scene = GameScene.newScene(heroIdx,gameLevel)
        scene.dontShowAdsBanner = true
        util.toScene(scene)
    end
    local btnr = util.creatButtun(STR_START)
    btnr:setPosition(cc.p(3*x/2,h))
    layer:addChild(btnr,6)
    btnr:registerControlEventHandler(onClickStartButton,cc.CONTROL_EVENTTYPE_TOUCH_DOWN )

    local background = cc.LayerColor:create(cc.c4b(255, 255, 255, 255), visibleSize.width,visibleSize.height)
    layer:addChild(background, 0)

    local actionJump = createActionJump(h/2)
    heros[7]:runAction(actionJump)

    local function onTouchBegan(touch, event)
        local tl = touch:getLocation()
        --print("touch:",tl.x, tl.y,event)
        local idx = nil
        for i,hero in ipairs(heros) do
            hero:stopActionByTag(ACTIONJUMP_TAG)
            hero:setPosition(cc.p(hero.x,hero.y))
            print("tl=",tl.x,tl.y)
            print("content=",hero.content.x,hero.content.y,hero.content.width,hero.content.height)
            if cc.rectContainsPoint(hero.content,tl) then
                idx=i
                print("idx=",idx)
            end
        end
        if idx then
            heroIdx = idx
            local actionJump = createActionJump(h/2)
            heros[idx]:runAction(actionJump)
        else
            local actionJump = createActionJump(h/2)
            heros[heroIdx]:runAction(actionJump)
        end
        return true
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    local function onKeyReleased(keyCode, event)
        if keyCode == 0x06 then
            local scene = preSceneFunc()
            if scene ~= nil then
                util.toScene(scene)
            end
        end
    end
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)


    scene:addChild(layer)
    return scene
end

return ChooseHeroScene

