local PubTaskLayer = class("PubTaskLayer", require("src.comp.EventLayer"))
local PubTaskCell = class("PubTaskCell", require("src.comp.EventLayer"))

local LOCK_TYPE = {
    LOCK = 1,
    UNLOCK = 0
}

local TaskState = {}
TaskState.Null = 0
TaskState.Doing = 1
TaskState.Start = 2
TaskState.Finish = 3

-- local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

local ExTimer = require("src.ex.ExTimer")

local cfg_buyTime = ex.BuyTimeTable:getConfig(1)
local cfg_buyTime_second = tonumber(cfg_buyTime.second)
local cfg_buyTime_gem = tonumber(cfg_buyTime.gem)


function PubTaskCell:onCreate()
    --ex.log("PubTaskCell:onCreate")
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.timer = ExTimer:new():bind(self)

    -- 派遣
    local btn_size = self.btn_done:getContentSize()
    btn_size.width = btn_size.width / 2
    btn_size.height = btn_size.height / 2

    local lbl_btn_txt = cc.Label:createWithTTF(ex.Tools:getLang(2201), FONT_DEFAULT_NAME_BOLD, 40)
    :setTextColor(FONT_BLACK)
    :setScale(0.5)
    :setPosition(btn_size.width, btn_size.height)
    self.btn_done:addChild(lbl_btn_txt)
    

    btn_size = self.btn_fast_gain:getContentSize()
    btn_size.width = btn_size.width / 2
    btn_size.height = btn_size.height / 2

    -- 快速完成
    self.btn_fast_gain:setEnableAction(false)

    local lbl_btn_txt = cc.Label:createWithTTF(ex.Tools:getLang(2202), FONT_DEFAULT_NAME_BOLD, 40)
    :enableOutline(FONT_BROWN, 2)
    :setScale(0.5)
    :setPosition(btn_size.width, btn_size.height)
    self.btn_fast_gain:addChild(lbl_btn_txt)

    local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", ItemType.IT_GEM))
    spr_icon:setScale(0.25)
    spr_icon:setPosition(btn_size.width - 40, 0 - 0.5 * spr_icon:getContentSize().height * spr_icon:getScaleY())
    self.btn_fast_gain:addChild(spr_icon)

    -- 快速完成钻石数
    self.lbl_fast = cc.Label:createWithTTF("0", FONT_DEFAULT_NAME_BOLD, 40)
    -- :setTextColor(FONT_BROWN)
    :setTextColor(cc.WHITE)
    :setScale(0.5)
    :setPosition(btn_size.width + 5, spr_icon:getPositionY())
    self.btn_fast_gain:addChild(self.lbl_fast)

    -- 领取
    lbl_btn_txt = cc.Label:createWithTTF(ex.Tools:getLang(2214), FONT_DEFAULT_NAME_BOLD, 36)
    :enableOutline(FONT_BROWN, 2)
    :setScale(0.5)
    :setPosition(btn_size.width, btn_size.height)
    self.btn_gain:addChild(lbl_btn_txt)

    self.btn_unlock:registerScriptTapHandler(handler(self, self.onUnLock))
    self.btn_lock:registerScriptTapHandler(handler(self, self.onLock))
    self:addEvent(EVENT.PUB_TASK_EVENT.LOCK_STATUS_UPDATE,handler(self,self.onLockStatus))
end

function PubTaskCell:onLockStatus(event,task_id)
    if task_id ~= self.task_id then return end

    local task_data = ex.Player.pub_task:getTask(task_id)
    if not task_data then return end 
    local is_lock = task_data.task_lock == LOCK_TYPE.LOCK

    self:refreshLockStatus(is_lock)
end

function PubTaskCell:initDone(task_id, task_type, scroll_view)
    self.task_id = task_id
    self.task_type = task_type

    local config = cfg.tavern.pubTask[task_type]
    if config == nil then
        self:setCurrentShow(TaskState.Null)
        return
    end

    self.need_time = config.time
    self.used_time = 0
    self.cur_gem = 0

    -- 任务名称
    self.lbl_name:setString(ex.Tools:getLang(PUN_TASK_NAME_BEGIN + task_type))

    -- 任务星级
    self.task_star = config.star
   
    -- self.spr_star_bg:setSpriteFrame(string.format("main-task/type-%d.png", self.task_star))
    ex.Tools:setSpriteFrame(self.spr_star_bg, string.format("main-task/type-%d.png", self.task_star))

    local bgWidth = self.spr_star_bg:getContentSize().width - 40
    local starSize = cc.Sprite:createWithSpriteFrameName("main-task/star.png"):getContentSize()

    local diff = bgWidth / self.task_star
    diff = math.min(diff, starSize.width)

    local start = cc.p(self.spr_star_bg:getPositionX(), self.spr_star_bg:getPositionY() + 2)
    start.x = start.x - diff * self.task_star / 2 + 10

    for i=1,self.task_star do
        local spr_star = cc.Sprite:createWithSpriteFrameName("main-task/star.png")
        :setPosition(start.x + (i - 1) * diff, start.y)
        self:addChild(spr_star)
    end
    
    -- 任务奖励
    local awardList = cfg.tavern.pubTask[task_type].item
    if table.nums(awardList) == 0 then
       return
    end

    local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    self:addChild(menu)

    local item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()

    -- 计算奖励开始位置
    start = cc.p(self.spr_star_bg:getPositionX(), self.spr_star_bg:getPositionY())
    start.x = start.x - 0
    start.y = start.y - 65

    local index = 0
    for k,v in pairs(awardList) do
        -- local item = UIItemBackpack:createWithData(v.item_type, v.item_num)
        local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        item:setPosition(start.x + index * item_size.width, start.y)
        :setScale(0.8)
        :registerScriptTapHandler(handler(self, self.onShowInfo))
        menu:add(item)

        index = index + 1
    end

    self:setCurrentType()

    local task_data = ex.Player.pub_task:getTask(task_id)
    if not task_data then return end 
    local is_lock = task_data.task_lock == LOCK_TYPE.LOCK
    
    self:refreshLockStatus(is_lock)
end

function PubTaskCell:refreshLockStatus(lock)
    self.btn_lock:setVisible(not lock)
    self.btn_unlock:setVisible(lock)
    self.shadow:setVisible(lock)
end

function PubTaskCell:setCurrentType()
    local task = ex.Player.pub_task:getTask(self.task_id)
    if task == nil then
        self:setCurrentShow(TaskState.Null)
        return
    end

    -- 2已完成 1可以接取 0正在进行

    if task.used_time == 0 then
        self:setCurrentShow(TaskState.Start)
        self:setTimeString(self.need_time)
    else
        local used_time = task.used_time - ex.Game:getServerTime()
        if used_time <= 0 then
            self:setCurrentShow(TaskState.Finish)
        else
            self:setCurrentShow(TaskState.Doing)

            self.used_time = used_time
            self.timer:run(handler(self, self.updateUsedTime), 1.0)
            self:updateUsedTime()
        end
    end
end

function PubTaskCell:setCurrentShow(state)
    self.task_state = state

    self.btn_done:setVisible(state == TaskState.Start)
    self.btn_fast_gain:setVisible(state == TaskState.Doing)
    self.btn_gain:setVisible(state == TaskState.Finish)

    self.lbl_time:setVisible(state ~= TaskState.Finish)
    self.spr_clock:setVisible(state ~= TaskState.Finish)
end

function PubTaskCell:updateUsedTime()
    self.used_time = self.used_time - 1

    if self.used_time <=0 then
        self.used_time = 0
        self.timer:stop()
        --self:stopTimer()
        self:setCurrentShow(TaskState.Finish)
        return
    end

    self:setTimeString(self.used_time)
end

function PubTaskCell:setTimeString(cur_time)
    self.lbl_time:setString(string.format("%d:%02d:%02d", 
        math.floor(cur_time / 3600),
        math.floor(cur_time / 60 % 60),
        math.floor(cur_time % 60)))

    if cur_time < cfg_buyTime_second then
        self.cur_gem = 0
    else
        self.cur_gem = math.floor(self.used_time / cfg_buyTime_second) * cfg_buyTime_gem
    end

    self.lbl_fast:setString(tostring(self.cur_gem))
end

function PubTaskCell:onLock(tag,pSender)
    print(self.__cname,tag)
    local req = PubTask_pb.GReqLockUpPubTask()
    req.task_id = self.task_id
    req.task_lock = LOCK_TYPE.LOCK
	
	NetManager:sendMessage(ProtocolID.GReqLockUpPubTask,req)
end

function PubTaskCell:onUnLock(tag,pSender)
    print(self.__cname,tag)
    local callback = function()
        local req = PubTask_pb.GReqLockUpPubTask()
        req.task_id = self.task_id
        req.task_lock = LOCK_TYPE.UNLOCK
        NetManager:sendMessage(ProtocolID.GReqLockUpPubTask,req)
    end
    local title, content = ex.Tools:getLang(2218) , ex.Tools:getLang(2219)
    ex.ConfirmCtr:openWindow(title, content, callback)
end

-- function PubTaskCell:stopTimer()
--     self.timer:stop()
-- end

function PubTaskCell:onExit()
    self.timer:stop()
end

function PubTaskCell:onShowInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end



-----------------------------------------------------------------------------
function PubTaskLayer:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/map-bg-pub-1.jpg", remove_type=1},
    }
    return vec_image
end

function PubTaskLayer:onCreate()
	--ex.log("PubTaskLayer:onCreate")
	self:setAutoClose(false)

    local last_content_size = self:getContentSize()
    local cur_content_size = cc.size(ex.p.width - 20, ex.p.height - 200)
    local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

    self:setContentSize(cur_content_size)
    self:setPosition(ex.p.width / 2 - self:getContentSize().width / 2, ex.p.height / 2 - self:getContentSize().height / 2 + 50)

    -- self.spr_bg:setContentSize(self.spr_bg:getContentSize().width + offset.x, self.spr_bg:getContentSize().height + offset.y)
    -- self.btn_back:setPosition(self.btn_back:getPositionX() + offset.x / 2, self.btn_back:getPositionY() + offset.y)

    local notch_height = require("src.model.Game"):instance():getNotchHeight()

    self.btn_back:setPosition(self:getContentSize().width * self:getScaleY() / 2 + ex.p.width / 2 - 80,
                              self:getContentSize().height * self:getScaleY() / 2 + ex.p.height / 2 - 142 - notch_height)

    self.spr_title_bg:setPosition(self.spr_title_bg:getPositionX() + offset.x / 2, self.spr_title_bg:getPositionY() + offset.y - notch_height)
    -- self.spr_pattern:setPosition(self.spr_pattern:getPositionX() + offset.x / 2, self.spr_pattern:getPositionY() + offset.y)
    self.lbl_title:setPosition(self.lbl_title:getPositionX() + offset.x / 2, self.lbl_title:getPositionY() + offset.y - notch_height)
    self.btn_info:setPosition(self.btn_info:getPositionX() + offset.x / 2, self.btn_info:getPositionY() + offset.y - notch_height * 0.5)

    self.lbl_task:setPosition(self.lbl_task:getPositionX() + offset.x / 2, self.lbl_task:getPositionY() + offset.y - notch_height)
    self.lbl_time:setPosition(self.lbl_time:getPositionX() + offset.x / 2, self.lbl_time:getPositionY() + offset.y - notch_height)

    self.btn_refresh_gem:setPosition(self.btn_refresh_gem:getPositionX() + offset.x / 2, self.btn_refresh_gem:getPositionY())
    self.btn_refresh_t1:setPosition(self.btn_refresh_t1:getPositionX() + offset.x / 2, self.btn_refresh_t1:getPositionY())
    self.btn_refresh_t2:setPosition(self.btn_refresh_t2:getPositionX() + offset.x / 2, self.btn_refresh_t2:getPositionY())


    self.spr_bg:setPosition(self.spr_bg:getPositionX() + offset.x / 2, self.spr_bg:getPositionY())
    self.spr_bg:setContentSize(self.spr_bg:getContentSize().width, self.spr_bg:getContentSize().height + offset.y - notch_height)

    self.show_log:setPosition(self.spr_bg:getPositionX() + 30 + self.spr_bg:getContentSize().width * 0.5 + offset.x / 2 , self.spr_bg:getContentSize().height + 220 - notch_height* 0.1 )
    self.btn_power:setPosition(self.spr_bg:getPositionX() - self.btn_power:getContentSize().width * 0.5 + self.spr_bg:getContentSize().width * 0.5 + offset.x / 2, self.spr_bg:getContentSize().height + 150 - notch_height * 0.1)
    ex.EffectCtr:playNormalEff(21, self.btn_power:getContentSize().width / 2, self.btn_power:getContentSize().height * 0.65, nil, self.btn_power, 0)

    local spr_bg = cc.Sprite:create("ccbi-res/map-bg-pub-1.jpg")
    spr_bg:setScale(ex.p.width / spr_bg:getContentSize().width, ex.p.height / spr_bg:getContentSize().height)
    spr_bg:setPosition(ex.p.center().x - self:getPositionX(), ex.p.center().y - self:getPositionY())
    self:addChild(spr_bg, -1)

    local spine_girl = sp.SkeletonAnimation:create("spine/act.json", "spine/act.atlas", 1)
    spine_girl:setAnimation(0, "act", true)
    spine_girl:setScale(0.75)
    spine_girl:setPosition(150, self.spr_bg:getContentSize().height - 70 - notch_height* 0.3)
    self.spr_bg:addChild(spine_girl, -1)

    -- local spr_bg = cc.Sprite:create("ccbi-res/map-bg-main-scene.jpg")
    -- spr_bg:setScale(ex.p.width / spr_bg:getContentSize().width, ex.p.height / spr_bg:getContentSize().height)
    -- spr_bg:setPosition(ex.p.center(-self:getPositionX(), -self:getPositionY()))
    -- spr_bg:setCascadeOpacityEnabled(true)
    -- spr_bg:setLocalZOrder(-100)
    -- self:addChild(spr_bg)

	self.btn_refresh_gem:getParent():setLocalZOrder(1)

	self.btn_refresh_gem:registerScriptTapHandler(handler(self, self.onRefreshByGem))
    self.btn_refresh_t1:registerScriptTapHandler(handler(self, self.onRefreshByTicket1))
    self.btn_refresh_t2:registerScriptTapHandler(handler(self, self.onRefreshByTicket2))

    local viewSize = cc.size(self.spr_bg:getContentSize().width, self.spr_bg:getContentSize().height - 90)
    viewSize.height = viewSize.height - 43

    self.scroll_view = cc.ScrollView:create(viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(self:getContentSize().width / 2 - viewSize.width / 2, self.spr_bg:getPositionY() + 40)
    self:addChild(self.scroll_view)

    self:initSwallowLayer()

    self:initDone()

    -- self:addEvent(EVENT.PUB_TASK_EVENT.UPDATE, handler(self, self.updateScrollView))
    self:addEvent(EVENT.PUB_TASK_EVENT.LOCK_STATUS_UPDATE,handler(self,self.updateRefreshGemBtn))
end

--触摸吞噬
function PubTaskLayer:initSwallowLayer()
    self.touch_layer = cc.Layer:create()
    self.touch_layer:setTouchEnabled(true)
    self.touch_layer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.touch_layer:registerScriptTouchHandler(function(event)
        if event == "began" then
            return true
        end
    end)
    self:addChild(self.touch_layer, 100)
end

function PubTaskLayer:touchSwallowTouches(is_lock)
    self.touch_layer:setSwallowsTouches(is_lock)
end

function PubTaskLayer:initDone()
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/hero-info.plist")
    sfc:addSpriteFrames("ccbi-res/hero-info-lang.plist")

    -- 任务重置时间
    self.reset_time = GetSystemResetTime()

    self.timer = ExTimer:new():bind(self)
    self.timer:run(handler(self, self.setTaskResetTime), 1.0)
    self:setTaskResetTime()

    -- 钻石刷新的钻石数量
    self.refreshGem = ex.Tools:getSysCfg("tavern_refresh_gem")

    local btn_size = self.btn_refresh_gem:getContentSize()
    btn_size.width = btn_size.width / 2
    btn_size.height = btn_size.height / 2

    local txt_color = FONT_BROWN

    -- 钻石刷新按钮
    local lbl_refresh = cc.Label:createWithTTF(ex.Tools:getLang(2203), FONT_DEFAULT_NAME_BOLD, 24)
    :setTextColor(txt_color)
    :setPosition(btn_size.width, btn_size.height + 13)
    self.btn_refresh_gem:addChild(lbl_refresh)

    local lbl_value = cc.Label:createWithTTF(tostring(self.refreshGem), FONT_DEFAULT_NAME_BOLD, 40) -- 20
    :setTextColor(txt_color)
    :setScale(0.5)
    :setPosition(btn_size.width + 4, btn_size.height - 14)
    self.btn_refresh_gem:addChild(lbl_value)
    self.btn_refresh_gem.lbl_num = lbl_value

    local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", ItemType.IT_GEM))
    :setScale(0.25)
    :setPosition(btn_size.width - 30, btn_size.height - 14)
    self.btn_refresh_gem:addChild(spr_icon)

    -- 普通卷轴按钮
    spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", ItemType.IT_PUB_TICKET_SMALL))
    :setScale(0.45)
    :setPosition(btn_size.width * 0.55, btn_size.height)
    self.btn_refresh_t1:addChild(spr_icon)

    self:setBtnItemNum(self.btn_refresh_t1, ex.Player:getItemNum(ItemType.IT_PUB_TICKET_SMALL))

    -- 高级卷轴按钮
    spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", ItemType.IT_PUB_TICKET_HIGH))
    :setScale(0.45)
    :setPosition(btn_size.width * 0.55, btn_size.height)
    self.btn_refresh_t2:addChild(spr_icon)

    self:setBtnItemNum(self.btn_refresh_t2, ex.Player:getItemNum(ItemType.IT_PUB_TICKET_HIGH))

    self:updateScrollView()
    self:updateRefreshGemBtn()

    NetManager:sendMessage(ProtocolID.GReqPubTaskList)
    
end

function PubTaskLayer:onExit()
    -- 停止重置时间计时器
    self.timer:stop()
end

function PubTaskLayer:getRefreshGemNum()
    local task_num_undo = 0
    for i,v in ipairs(ex.Player.pub_task.taskList) do
        if v.used_time <= 0 and v.task_lock == 0 then
            task_num_undo = task_num_undo + 1
        end
    end

    return task_num_undo * self.refreshGem
end

function PubTaskLayer:updateRefreshGemBtn()
    self.btn_refresh_gem.lbl_num:setString(tostring(self:getRefreshGemNum()))
end

function PubTaskLayer:setTaskResetTime()
    self.reset_time = self.reset_time - 1
    if self.reset_time <= 0 then
        self.reset_time = self.reset_time + 86400

        -- self:touchSwallowTouches(true)

        -- 发送酒馆任务协议
        NetManager:sendMessage(ProtocolID.GReqPubTaskList)
    end
    -- 将重置于%d:%02d:%02d
    self.lbl_time:setString(string.format(ex.Tools:getLang(2204), 
        math.floor(self.reset_time / 3600),
        math.floor(self.reset_time / 60 % 60),
        math.floor(self.reset_time % 60)))
end

function PubTaskLayer:setTaskCount()
    self.lbl_task:setString(ex.Tools:getLang(2205)..string.format("%d/%d",
        ex.Player.pub_task.can_do_num,
        ex.Player.pub_task.task_count))
end

function PubTaskLayer:setBtnItemNum(btn, num)
    local btn_size = btn:getContentSize()

    local lbl_num = btn:getChildByTag(10)
    if lbl_num then
        lbl_num:removeFromParent()
        lbl_num = nil
    end

    lbl_num = cc.Label:createWithTTF(string.format("%d/1", num), FONT_DEFAULT_NAME_BOLD, 40) -- 20
    :setAnchorPoint(ex.a.right_center)
    :setTextColor(FONT_BROWN)
    :setScale(0.5)
    :setPosition(btn_size.width * 0.78, btn_size.height * 0.5)
    btn:addChild(lbl_num, 10, 10)
end

function PubTaskLayer:addTaskCell(task_id, task_type)
    local cell = PubTaskCell:createWithCCBIFile("ccbi/MainTaskCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
    cell:setAnchorPoint(ex.a.center)
	
    cell:initDone(task_id, task_type, self.scroll_view)

    cell.btn_done:registerScriptTapHandler(handler(self, self.onDoneTask))
    cell.btn_fast_gain:registerScriptTapHandler(handler(self, self.onGainTask))
    cell.btn_gain:registerScriptTapHandler(handler(self, self.onGainTask))

	return cell
end

-- function PubTaskLayer:updateTableView()
--     --print("PubTaskLayer:updateTableView")
--     if self.table_view ~= nil then
--         self.table_view:removeFromParent()
--         self.table_view = nil
--     end

--     self.table_view = cpp.UITableViewEx:create(self.spr_bg:getContentSize())
--     self.table_view:setPosition(40, 40)
--     self.table_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
--     self.table_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
--     self.table_view:setBounceable(false)
--     self.table_view:setDelegate()
--     self.table_view:setDataSource()
--     self.table_view:setMoveSpeed(0.7)
--     self:addChild(self.table_view)

--     self.table_view:registerScriptHandler(handler(self, self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL) --滚动时的回掉函数
--     self.table_view:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX) --列表项的尺寸
--     self.table_view:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX) --创建列表项
--     self.table_view:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW) --列表项的数量
--     -- self.table_view:registerScriptHandler( handler(self, self.tableCellWillRecycle),cc.TABLECELL_WILL_RECYCLE);            --列表项将被回收
--     self.table_view:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED) --列表项被点击
--     -- self.table_view:registerScriptHandler( handler(self, self.tableCellHighLight),cc.TABLECELL_HIGH_LIGHT);                --列表项高亮显示
--     -- self.table_view:registerScriptHandler( handler(self, self.tableCellUnhighLight),cc.TABLECELL_UNHIGH_LIGHT);            --列表项取消高亮

--     self.table_view:reloadData()
-- end

function PubTaskLayer:updateScrollView()
    self.scroll_view:getContainer():removeAllChildren()

    self.cellList = {}

    local index = 0
    for _,v in pairs(ex.Player.pub_task.taskList) do
        local task_node = self:addTaskCell(v.task_id, v.task_type)
        task_node:setName("task_cell" .. index)
        self.scroll_view:addChild(task_node)
        table.insert(self.cellList, task_node)
        index = index + 1
    end
    
    -- 排序顺序 已完成 可以接取 正在进行
    table.sort(self.cellList, function(a, b)
        if a.task_state == TaskState.Start and  b.task_state == TaskState.Start then
            if a.task_star == b.task_star then
                return a.task_type > b.task_type
            else
                return a.task_star > b.task_star -- 可以接取状态按照星级排序
            end
        else
            return a.task_state > b.task_state
        end
    end)

    local viewSize = self.scroll_view:getViewSize()
    --cc.size(480, 150)
    local item_size = PubTaskCell:createWithCCBIFile("ccbi/MainTaskCell.ccbi"):getContentSize()
    item_size.height = item_size.height + 5

    -- 调整ScrollView
    --self:adjustScrollView()
    local cont_height = item_size.height * table.nums(self.cellList)
    cont_height = math.max(cont_height , viewSize.height)

    self.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))

    -- 按排好的顺序显示
    local start = cc.p(viewSize.width * 0.5, cont_height - item_size.height * 0.5)

    for i,v in ipairs(self.cellList) do
        v:setPosition(start.x, start.y - (i - 1) * item_size.height)
    end

    self:setTaskCount()

    -- 更新列表后可以Touch
    self:touchSwallowTouches(false)
end

-- function PubTaskLayer:adjustScrollView()
--     self.cont_height = self.item_size.height * table.nums(self.cellList)
--     self.cont_height = math.max(self.cont_height , self.viewSize.height)

--     self.scroll_view:setContentSize(cc.size(self.viewSize.width, self.cont_height))
--     self.scroll_view:setContentOffset(cc.p(0, self.viewSize.height - self.cont_height))
-- end

function PubTaskLayer:startTask(task_id)
    -- ex.log(">>startTask:")
    -- ex.log("task_id: "..task_id)

    self:touchSwallowTouches(false)

    self:setTaskCount()

    for _,v in pairs(self.cellList) do
        if v.task_id == task_id then
            v:setCurrentType()
            return
        end
    end
end

-- function PubTaskLayer:removeTaskByGain(task_id)
--     --self:touchSwallowTouches(false)

--     self:setTaskCount()

--     for i,v in ipairs(self.cellList) do
--         if v.task_id == task_id then
--             local posY = v:getPositionY()
--             --v:stopTimer()
--             v:removeFromParent()
--             table.remove(self.cellList, i)
--             self:moveTaskUp(posY)
--             return
--         end
--     end
-- end

-- function PubTaskLayer:moveTaskUp(posY)
--     for _,v in pairs(self.cellList) do
--         if v:getPositionY() < posY then
--             v:runAction(cc.MoveBy:create(0.2, cc.p(0, self.item_size.height)))
--         end
--     end

--     local moveTimer = ExTimer:new():bind(self)
--     moveTimer:runOnce(function()
--         self:adjustScrollView()

--         self:touchSwallowTouches(false)

--         local starty = self.cont_height - self.item_size.height * 0.5
--         local index = 0 
--         for _,v in pairs(self.cellList) do
--              v:setPositionY(starty - index * self.item_size.height)

--              index = index + 1
--         end
--     end, 0.2)
-- end

function PubTaskLayer:addTaskByTicket(task_id)
    local new_task = ex.Player.pub_task:getTask(task_id)
    if new_task == nil then
        return
    end

    self:setTaskCount()

    local viewSize = self.scroll_view:getViewSize()
    --cc.size(480, 150)
    local item_size = PubTaskCell:createWithCCBIFile("ccbi/MainTaskCell.ccbi"):getContentSize()
    item_size.height = item_size.height + 5

    -- 新增高级任务
    local cont_height = item_size.height * table.nums(self.cellList)
    local task_node = self:addTaskCell(new_task.task_id, new_task.task_type)
    task_node:setPosition(viewSize.width/2, cont_height + item_size.height * 0.5)
    self.scroll_view:addChild(task_node)
    table.insert(self.cellList, task_node)

    -- task_node:runAction(cc.EaseBackOut:create(cc.MoveBy:create(0.18, cc.p(viewSize.width, 0))))

    -- local callback = function()
        cont_height = cont_height + item_size.height
        cont_height = math.max(cont_height , viewSize.height)

        self.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
        self.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))

    --     self:touchSwallowTouches(false)
    -- end

    -- self.scroll_view:getContainer():runAction(cc.Sequence:create(cc.MoveBy:create(0.2, cc.p(0, -item_size.height)),
    --     cc.CallFunc:create(callback)))
end


function PubTaskLayer:onDoneTask(tag, pSender)
    if ex.Player.pub_task.can_do_num <= 0 then
        --print(ex.Tools:getLang(47313))
        ex.MessageView:add(ex.Tools:getLang(2206))
        return
    end

    local cell = pSender:getParent():getParent()
    if cell == nil then
        return
    end

    require("src.layer.PubTaskChooseHeroCtr"):instance():openWindow(cell.task_id, cell.task_type)
end

function PubTaskLayer:onGainTask(tag, pSender)
    local cell = pSender:getParent():getParent()
    if cell == nil then
        return
    end

    if cell.cur_gem > 0 then
        if ex.Player.gem < cell.cur_gem then
            ex.MessageView:add(ex.Tools:getLang(1109)) -- 钻石不足
            return
        end

        -- 快速完成任务将花费%d钻石
        local content = string.format(ex.Tools:getLang(2207), cell.cur_gem)
        ex.ConfirmCtr:openWindow(ex.Tools:getLang(47497), content, function()
            for _,v in pairs(self.cellList) do
                if v.task_id == cell.task_id then
                    v.btn_fast_gain:setEnabled(false)
                    self:taskAward(v.task_id)
                    return
                end
            end
        end)
    else
        cell.btn_gain:setEnabled(false)
        self:taskAward(cell.task_id)
    end
end

function PubTaskLayer:taskAward(task_id)
    -- self:touchSwallowTouches(true)

    -- 发送领取奖励协议
    local req_task_award = PubTask_pb.GReqPubTaskAward()
    req_task_award.task_id = task_id
    NetManager:sendMessage(ProtocolID.GReqPubTaskAward, req_task_award)
end

function PubTaskLayer:refreshTask(index)
    -- self:touchSwallowTouches(true)
    
    -- 发送任务刷新协议
    -- local req_task_refresh = PubTask_pb.GReqPubTaskRefresh()
    -- req_task_refresh.index = index -- 刷新方式 1钻石 2普通券 3高级券
    -- NetManager:sendMessage(ProtocolID.GReqPubTaskRefresh, req_task_refresh)
    NetManager:sendMessage(ProtocolID.GReqPubTaskRefresh)
end

function PubTaskLayer:onRefreshByGem(tag, pSender)
    if ex.Player.pub_task.can_do_num <= 0 then
        -- 当前没有任务可以刷新
        ex.MessageView:add(ex.Tools:getLang(41038))
        return
    end

    if ex.Player.gem < self.refreshGem then
        ex.MessageView:add(ex.Tools:getLang(1109)) -- 钻石不足
        return
    end

    local function confirmRefresh()
        self:refreshTask(1)
    end

    if ex.Player.pub_task:hasHighStarTask() then
        ex.ConfirmCtr:openWindow("", ex.Tools:getLang(41017), confirmRefresh)
    else
        confirmRefresh()
    end
end

function PubTaskLayer:onRefreshByTicket1(tag, pSender)
    -- if ex.Player.pub_task.can_do_num >= cfg.vip.vip[ex.Player.vip_level].tavern then
    --     ex.MessageView:add(ex.Tools:getLang(100051)) -- 已达到最大数量
    --     return
    -- end

    local item_type = ItemType.IT_PUB_TICKET_SMALL
    local backpack_item_num = ex.Player:getItemNum(item_type)
    if backpack_item_num < 1 then
        -- ex.MessageView:add(string.format(ex.Tools:getLang(1108),
        --     ex.Tools:getLang(item_type)))
        ex.Tools:showEnoughTip(item_type)
        return
    end

    -- 扣除普通卷轴
    -- ex.Player:addItem(ItemType.IT_PUB_TICKET_SMALL, -1)

    -- self:setBtnItemNum(self.btn_refresh_t1, backpack_item_num -  1)

	self:refreshTask(2)
end

function PubTaskLayer:onRefreshByTicket2(tag, pSender)
    -- if ex.Player.pub_task.can_do_num >= cfg.vip.vip[ex.Player.vip_level].tavern then
    --     ex.MessageView:add(ex.Tools:getLang(100051)) -- 已达到最大数量
    --     return
    -- end
    
    local item_type = ItemType.IT_PUB_TICKET_HIGH
    local backpack_item_num = ex.Player:getItemNum(item_type)
    if backpack_item_num < 1 then
        -- ex.MessageView:add(string.format(ex.Tools:getLang(1108),
        --     ex.Tools:getLang(item_type)))
        ex.Tools:showEnoughTip(item_type)
        return
    end

    -- 扣除高级卷轴
    -- ex.Player:addItem(ItemType.IT_PUB_TICKET_HIGH, -1)

    -- self:setBtnItemNum(self.btn_refresh_t2, backpack_item_num -  1)

	self:refreshTask(3)
end

function PubTaskLayer:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42016), ex.Tools:getLang(42017))
end

function PubTaskLayer:onBtnBack(tag, pSender)
    --ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
    if not ex.MainSceneCtr:backLastLayer() then
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
    end
end



function PubTaskLayer:onShowMsg(tag, pSender)
    -- 显示一个小窗口
    -- require("src.layer.MainTaskPowerCtr"):instance():openWindow()
    ex.JumpManager:jumpByAtom("act_recharge")
end

return PubTaskLayer
