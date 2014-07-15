local RankScene = {}

local visibleSize = cc.Director:getInstance():getVisibleSize()
local origin = cc.Director:getInstance():getVisibleOrigin()

local function scrollViewDidScroll(view)
    print("scrollViewDidScroll")
end

local function scrollViewDidZoom(view)
    print("scrollViewDidZoom")
end

local function tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end

local function cellSizeForTable(table,idx) 
    return 20,20
end

local TAG_LABEL_RANK = 0x101
local TAG_LABEL_NAME = 0x102
local TAG_LABEL_SCORE = 0x103
local TAG_LABEL_LEVEL = 0x104
local function tableCellAtIndex(table, idx)
    local rank = idx+1
    local rankStr = string.format("%d",rank)
    local nameStr = "hanxi"
    local scoreStr = "110"
    local labelRank = nil
    local labelName = nil
    local labelScore = nil
    local cell = table:dequeueCell()
    if nil == cell then
        cell = cc.TableViewCell:new()
        --local sprite = cc.Sprite:create("logo.png")
        --sprite:setAnchorPoint(cc.p(0,0))
        --sprite:setPosition(cc.p(0, 0))
        --cell:addChild(sprite)

        labelRank = util.createLabel(rankStr,15)
        labelRank:setPosition(cc.p(visibleSize.width*0.2,0))
        labelRank:setAnchorPoint(cc.p(0,0))
        labelRank:setTag(TAG_LABEL_RANK)
        labelRank:setColor(cc.c3b(0,0,0))
        cell:addChild(labelRank)

        labelName = util.createLabel(nameStr,15)
        labelName:setPosition(cc.p(visibleSize.width*0.35,0))
        labelName:setAnchorPoint(cc.p(0,0))
        labelName:setTag(TAG_LABEL_NAME)
        labelName:setColor(cc.c3b(0,0,0))
        cell:addChild(labelName)

        labelScore = util.createLabel(scoreStr,15)
        labelScore:setPosition(cc.p(visibleSize.width*0.7,0))
        labelScore:setAnchorPoint(cc.p(0,0))
        labelScore:setTag(TAG_LABEL_SCORE)
        labelScore:setColor(cc.c3b(0,0,0))
        cell:addChild(labelScore)
    else
        labelRank = cell:getChildByTag(TAG_LABEL_RANK)
        if nil ~= labelRank then
            labelRank:setString(rankStr)
        end
        labelName = cell:getChildByTag(TAG_LABEL_NAME)
        if nil ~= labelName then
            labelName:setString(nameStr)
        end
        labelScore = cell:getChildByTag(TAG_LABEL_SCORE)
        if nil ~= labelScore then
            labelScore:setString(scoreStr)
        end
    end

    return cell
end

local function numberOfCellsInTableView(table)
   return 25
end


function RankScene.newScene()
    local scene  = cc.Scene:create()
    local layer  = cc.Layer:create()
    layer:setPosition(origin.x,origin.y)

    -- Title
    local titleLabel = util.createLabel(STR_RANK,30)
    titleLabel:setPosition(cc.p(visibleSize.width/2, visibleSize.height*0.85))
    titleLabel:setColor(cc.c3b(0,0,0))
    layer:addChild(titleLabel, 5)

    labelRank = util.createLabel(STR_RANK_T1,20)
    labelRank:setPosition(cc.p(visibleSize.width*0.2,visibleSize.height*0.7))
    labelRank:setAnchorPoint(cc.p(0,0))
    labelRank:setTag(TAG_LABEL_RANK)
    labelRank:setColor(cc.c3b(0,0,0))
    layer:addChild(labelRank,5)

    labelName = util.createLabel(STR_RANK_T2,20)
    labelName:setPosition(cc.p(visibleSize.width*0.35,visibleSize.height*0.7))
    labelName:setAnchorPoint(cc.p(0,0))
    labelName:setTag(TAG_LABEL_NAME)
    labelName:setColor(cc.c3b(0,0,0))
    layer:addChild(labelName,5)

    labelScore = util.createLabel(STR_RANK_T3,20)
    labelScore:setPosition(cc.p(visibleSize.width*0.7,visibleSize.height*0.7))
    labelScore:setAnchorPoint(cc.p(0,0))
    labelScore:setTag(TAG_LABEL_SCORE)
    labelScore:setColor(cc.c3b(0,0,0))
    layer:addChild(labelScore,5)

    local tableView = cc.TableView:create(cc.size(visibleSize.width, visibleSize.height*0.55))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setPosition(cc.p(0, visibleSize.height*0.15))
    tableView:setDelegate()
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    layer:addChild(tableView,5)
    tableView:registerScriptHandler(scrollViewDidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
    tableView:registerScriptHandler(scrollViewDidZoom,cc.SCROLLVIEW_SCRIPT_ZOOM)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:reloadData()

    local menus = STR_MENUS
    local function menuCallback(pSender)
        local gameLevel = pSender:getTag()
        print("gameLevel",gameLevel)
        for i=1,#menus do
            local node = layer:getChildByTag(i)
            if i==gameLevel then
                node:setEnabled(false)
            else
                node:setEnabled(true)
                node:getTitleLabel():setColor(cc.c3b(255,255,0))
            end
        end
    end
    local h = visibleSize.height/(#menus+4)
    for i=1,#menus do
        local y = h*(#menus-i+2)
        local button = util.creatButtun(menus[i],20)
        button:setAnchorPoint(cc.p(0, 0.5))
        button:setTag(i)
        button:setPosition(cc.p(0,y))
        button:registerControlEventHandler(menuCallback,cc.CONTROL_EVENTTYPE_TOUCH_DOWN )
        layer:addChild(button,6)
    end
    menuCallback(layer:getChildByTag(1))

    local labelMy = util.createLabel("我：",20)
    labelMy:setPosition(cc.p(visibleSize.width*0.1,visibleSize.height*0.1))
    labelMy:setColor(cc.c3b(255,0,0))
    layer:addChild(labelMy, 5)
    local labelMyRank = util.createLabel("30",15)
    labelMyRank:setPosition(cc.p(visibleSize.width*0.25,visibleSize.height*0.1))
    labelMyRank:setColor(cc.c3b(255,0,0))
    layer:addChild(labelMyRank, 5)
    local labelMyName = util.createLabel("涵曦",15)
    labelMyName:setPosition(cc.p(visibleSize.width*0.4,visibleSize.height*0.1))
    labelMyName:setColor(cc.c3b(255,0,0))
    layer:addChild(labelMyName, 5)
    local labelMyScore = util.createLabel("2333",15)
    labelMyScore:setPosition(cc.p(visibleSize.width*0.75,visibleSize.height*0.1))
    labelMyScore:setColor(cc.c3b(255,0,0))
    layer:addChild(labelMyScore, 5)
    
    local background = cc.LayerColor:create(cc.c4b(255, 255, 255, 255), visibleSize.width,visibleSize.height)
    layer:addChild(background, 0)

    scene:addChild(layer)
    return scene
end

return RankScene

