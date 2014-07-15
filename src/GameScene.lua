local GameScene = {}

local visibleSize = cc.Director:getInstance():getVisibleSize()
local origin = cc.Director:getInstance():getVisibleOrigin()
local blockSpeed = 2
local nowScore = 0
local gameLevel = 1
local heroIdx = 7
local jumpHeightMax = {
    [1] = visibleSize.height*0.3,
    [2] = visibleSize.height*0.25,
    [3] = visibleSize.height*0.25,
    [4] = visibleSize.height*0.2,
    [5] = visibleSize.height*0.16,
}
local schedulerIds = {}

local function runManJump(sprite,rect,touchPos)
    print("sprite.jumping",sprite.jumping)
    if sprite.jumping then return end
    sprite.jumping = true

    
    local h = jumpHeightMax[gameLevel]*0.9
    local x,y = sprite:getPosition()

    local function endJump()
        sprite.jumping = false
    end
    local ts = math.abs(touchPos.x-x)*0.01
    if ts<0.5 then ts=0.5 end
    local actionBy = cc.JumpBy:create(ts, cc.p(0,0), h-sprite.height/2, 1)
    print("jump height=",h-sprite.height/2)
    local actionJump = cc.Sequence:create(actionBy,cc.CallFunc:create(endJump))
    sprite:runAction(actionJump)
end

local function gameOver()
    if not globalBestScore[gameLevel] or nowScore>globalBestScore[gameLevel] then
        globalBestScore[gameLevel] = nowScore
    end
    -- 保存数据
    util.saveData()

    for _,schedulerId in ipairs(schedulerIds) do
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerId)
    end

    local scene = GameOverScene.newScene(heroIdx,gameLevel,nowScore)
    util.toScene(scene)
end

local function createBlock(rect)
    local block = cc.Sprite:create("juhua.png")
    local schedulerId = 0

    local function tick()
        local x, y = block:getPosition()
        if x < 0 then
            gameOver()
            return
        else
            x = x - blockSpeed
        end
        block:setPositionX(x)
    end
    schedulerId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick, 0, false)
    table.insert(schedulerIds,schedulerId)

    local function onNodeEvent(event)
        if "exit" == event then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerId)
        end
    end
    block:registerScriptHandler(onNodeEvent)

    local actionRotate = cc.RotateBy:create(0.1, 10)
    block:runAction(cc.RepeatForever:create(actionRotate))
    return block,r
end

local function randomBlock(block)
    local scale = math.random(4,6)/10
    block:setScale(scale)
    local rt = {
        [0.4]=10,
        [0.5]=13,
        [0.6]=15,
    }
    local sSize = block:getContentSize()
    block.width = sSize.width*scale
    block.height = sSize.height*scale
    local br = math.random(5,rt[scale])/10
    local h = jumpHeightMax[gameLevel]
    local by = h-br*block.height
    local r = math.random(12,15)/10
    block:setPosition(cc.p(visibleSize.width*r,by))
    local cr = math.random(100,200)
    local cg = math.random(100,200)
    local cb = math.random(100,200)
    block:setColor(cc.c3b(cr,cg,cb))
    print("block height=",by)
end

local function createLayerGame(rect,idx)
    local layerGame = cc.LayerColor:create(cc.c4b(255, 255, 255, 255), rect.width,rect.height)

    local block = createBlock(rect)
    layerGame:addChild(block)
    randomBlock(block)

    -- add hero
    local runMan = util.createHero(idx)
    layerGame:addChild(runMan)
    runMan:setPosition(rect.width/4,runMan.height/2)

    local line = util.createLine()
    line:setContentSize(cc.size(rect.width, 2))
    layerGame:addChild(line,0)
    line:setPosition(cc.p(rect.width/2,0))

    -- 碰撞
    local function tick()
        local p1x,p1y = block:getPosition()
        local rect1 = {
            x = p1x, y = p1y,
            width = block.width,
            height = block.height,
        }
        local p2x,p2y = runMan:getPosition()
        local rect2 = {
            x = p2x, y = p2y,
            width = runMan.width,
            height = runMan.height,
        }
        if cc.rectIntersectsRect(rect1,rect2) then
            -- partical 
            local partical = cc.ParticleSystemQuad:create("partical.plist")
            partical:setAutoRemoveOnFinish(true)
            partical:setPosition(cc.p(block:getPosition()))
            partical:setDuration(2)
            layerGame:addChild(partical,128)
            randomBlock(block)
            print("pong")
            util.playSound("pong")
        end
    end

    local schedulerId = 0
    schedulerId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick, 0, false)
    table.insert(schedulerIds,schedulerId)

    local function onNodeEvent(event)
        if "exit" == event then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerId)
        end
    end
    block:registerScriptHandler(onNodeEvent)


    -- handing touch events
    local function onTouchBegan(touch, event)
        local tl = touch:getLocation()
        if cc.rectContainsPoint(rect,tl) then
            print("jump")
            util.playSound("jump")
            runManJump(runMan,rect,tl)
        end
        -- CCTOUCHBEGAN event must return true
        return true
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    local eventDispatcher = layerGame:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layerGame)
    return layerGame
end

local gameLayerRects = {
    [1] = {
        [1] = {x=origin.x,y=origin.y+visibleSize.height*0.3,width=visibleSize.width,height=visibleSize.height*0.7},
    },
    [2] = {
        [1] = {x=origin.x,y=origin.y+visibleSize.height*0.1,width=visibleSize.width,height=visibleSize.height*0.4},
        [2] = {x=origin.x,y=origin.y+visibleSize.height*0.5,width=visibleSize.width,height=visibleSize.height*0.5},
    },
    [3] = {
        [1] = {x=origin.x,y=origin.y+visibleSize.height*0.1,width=visibleSize.width,height=visibleSize.height*0.25},
        [2] = {x=origin.x,y=origin.y+visibleSize.height*0.35,width=visibleSize.width,height=visibleSize.height*0.25},
        [3] = {x=origin.x,y=origin.y+visibleSize.height*0.6,width=visibleSize.width,height=visibleSize.height*0.4},
    },
    [4] = {
        [1] = {x=origin.x,y=origin.y+visibleSize.height*0.1,width=visibleSize.width,height=visibleSize.height*0.2},
        [2] = {x=origin.x,y=origin.y+visibleSize.height*0.3,width=visibleSize.width,height=visibleSize.height*0.2},
        [3] = {x=origin.x,y=origin.y+visibleSize.height*0.5,width=visibleSize.width,height=visibleSize.height*0.2},
        [4] = {x=origin.x,y=origin.y+visibleSize.height*0.7,width=visibleSize.width,height=visibleSize.height*0.3},
    },
    [5] = {
        [1] = {x=origin.x,y=origin.y+visibleSize.height*0.1,width=visibleSize.width,height=visibleSize.height*0.16},
        [2] = {x=origin.x,y=origin.y+visibleSize.height*0.26,width=visibleSize.width,height=visibleSize.height*0.16},
        [3] = {x=origin.x,y=origin.y+visibleSize.height*0.42,width=visibleSize.width,height=visibleSize.height*0.16},
        [4] = {x=origin.x,y=origin.y+visibleSize.height*0.58,width=visibleSize.width,height=visibleSize.height*0.16},
        [5] = {x=origin.x,y=origin.y+visibleSize.height*0.74,width=visibleSize.width,height=visibleSize.height*0.26},
    },
}

function GameScene.newScene(_heroIdx,_gameLevel)
    gameLevel = _gameLevel
    heroIdx = _heroIdx

    local schedulerId = 0
    blockSpeed = 2

    local scene = cc.Scene:create()
    local layer  = cc.Layer:create()
    scene:addChild(layer)

    for _,rect in ipairs(gameLayerRects[gameLevel]) do
        local game = createLayerGame(rect,heroIdx)
        layer:addChild(game,6)
        game:setPosition(rect.x,rect.y)
    end

    background = cc.LayerColor:create(cc.c4b(255, 255, 255, 255), visibleSize.width,visibleSize.height)
    layer:addChild(background, 0)
    background:setPosition(cc.p(origin.x,origin.y))

    -- time
    local timeLabel = util.createLabel("000.000''",38)
    timeLabel:setColor(cc.c3b(0,0,0))
    local tSize = timeLabel:getContentSize()
    layer:addChild(timeLabel, 7)
    timeLabel:setPosition(origin.x+visibleSize.width-tSize.width/2,origin.y+visibleSize.height-tSize.height/2)
    local timeTickStart = millisecondNow()
    local function timetick()
        nowScore = millisecondNow()-timeTickStart
        local str = util.scoreToStr(nowScore)
        timeLabel:setString(str)
        local ts = nowScore/10000
        if blockSpeed<ts then
            blockSpeed = ts
        end
        if blockSpeed>10 then
            blockSpeed = 10
        end
    end
    schedulerId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(timetick, 0, false)
    table.insert(schedulerIds,schedulerId)

    local function onNodeEvent(event)
        if "exit" == event then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerId)
        end
    end
    layer:registerScriptHandler(onNodeEvent)

    return scene
end

return GameScene

