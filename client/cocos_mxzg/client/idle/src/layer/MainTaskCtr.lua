local MainTaskLayer = class("MainTaskLayer", require("src.comp.EventLayerAdaptiveWidth"))
local MainTaskCtr = class("MainTaskCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local PubMainTaskCell = class("PubMainTaskCell", require("src.comp.EventLayer"))

local ExTimer = require("src.ex.ExTimer")
local LOCK_TYPE = {
    LOCK = 1,
    UNLOCK = 0
}

local cfg_buyTime = ex.BuyTimeTable:getConfig(1)
local cfg_buyTime_second = tonumber(cfg_buyTime.second)
local cfg_buyTime_gem = tonumber(cfg_buyTime.gem)

local TaskState = {}
TaskState.Null = 0
TaskState.Doing = 1
TaskState.Start = 2
TaskState.Finish = 3
-----------------------------------------------------------------------------
function PubMainTaskCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.timer = ExTimer:new():bind(self)

    -- -- jieshou 
    -- self.btn_get
    -- -- yong huwenben 
    -- self.btn_jiasu
    -- self.btn_end

    local posBar = cc.p(0, 0)
	-- posBar.x = self.time_muns:getPositionX() - self.time_muns:getContentSize().width * 0.5 + 2
	-- posBar.y = self.time_muns:getPositionY() + 1
    posBar.x = self.spr_slider_bg:getContentSize().width * 0.5 - 1
    posBar.y = self.spr_slider_bg:getContentSize().height * 0.5 

    -- self.progressEndTimer = require("src.comp.UIScale9SpriteEx"):create("main-task/spr-xjdt1.png", cc.rect(0, 0, 0, 0))
	-- self.progressEndTimer:setAnchorPoint(cc.p(0, 0.5))
	-- self.progressEndTimer:setContentSize(cc.size(self.spr_slider_bg:getContentSize().width-4, self.spr_slider_bg:getContentSize().height-2))
	-- self.progressEndTimer:setPosition(posBar)
    
    self.progressEndTimer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("main-task/spr-xjdt1.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setPosition(posBar)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_slider_bg:addChild(self.progressEndTimer)

    local btn_size = self.btn_get:getContentSize()
    btn_size.width = btn_size.width / 2
    btn_size.height = btn_size.height / 2

    local lbl_btn_txt1 = cc.Label:createWithTTF(ex.Tools:getLang(2201), FONT_DEFAULT_NAME_BOLD, 44)
    :setTextColor(FONT_WHITLE)
    :setScale(0.5)
    :enableOutline(FONT_BTN_OUTLINE_GREEN, 2)
    :setPosition(btn_size.width, btn_size.height)
    self.btn_get:addChild(lbl_btn_txt1)

    local lbl_btn_txt2 = cc.Label:createWithTTF(ex.Tools:getLang(2214), FONT_DEFAULT_NAME_BOLD, 44)
    :setTextColor(FONT_WHITLE)
    :setScale(0.5)
    :enableOutline(FONT_BTN_OUTLINE_ZI, 2)
    :setPosition(btn_size.width, btn_size.height)
    self.btn_end:addChild(lbl_btn_txt2)

    self.btn_get:registerScriptTapHandler(handler(self, self.onDoneTask))

    self.btn_jiasu:registerScriptTapHandler(handler(self, self.onGainTask))

    self.btn_end:registerScriptTapHandler(handler(self, self.onGainTask))

end 


function PubMainTaskCell:onGainTask(tag, pSender)

    if self.cur_gem > 0 then
        if ex.Player.gem < self.cur_gem then
            ex.MessageView:add(ex.Tools:getLang(1109)) -- 钻石不足
            return
        end

        -- 快速完成任务将花费%d钻石
        local content = string.format(ex.Tools:getLang(41256), self.cur_gem)
        ex.ConfirmCtr:openWindow(ex.Tools:getLang(47497), content, function()

            self:taskAward(self.task_id)
            return
        end)
    else
        -- self.btn_gain:setEnabled(false)
        self:taskAward(self.task_id)
    end
end



function PubMainTaskCell:taskAward(task_id)

    -- 发送领取奖励协议
    local req_task_award = PubTask_pb.GReqPubTaskAward()
    req_task_award.task_id = task_id
    NetManager:sendMessage(ProtocolID.GReqPubTaskAward, req_task_award)
end


function PubMainTaskCell:onDoneTask(tag, pSender)
    if self.need_points > ex.Player.pub_task.adventure_count then
        --print(ex.Tools:getLang(47313))
        --ex.MessageView:add(ex.Tools:getLang(2206))
        ex.MessageView:add(ex.Tools:getLang(41255))
        
        return
    end

    require("src.layer.PubTaskChooseHeroCtr"):instance():openWindow(self.task_id, self.task_type)
end


-- 刷新任务

function PubMainTaskCell:initDone(task_id, task_type, scroll_view)
    self.task_id = task_id
    self.task_type = task_type

    local config = cfg.tavern.pubTask[task_type]
    if config == nil then
        elf:setCurrentShow(TaskState.Null)
        return
    end

    self.need_time = config.time
    self.used_time = 0
    self.cur_gem = 0

    --  getTavernWeeklyListTime()
    --  cfg.system["tavern_promotion_discount"]

    self.need_points = config.need_points[1].item_num 
    if ex.Player.promotion_data:getTavernWeeklyListTime() == true  then
        self.need_points = self.need_points *  cfg.system["tavern_promotion_discount"] * 0.0001
    end 

    self.need_points_type = config.need_points[1].item_type 
    -- 任务名称
    self.lbl_name:setString(ex.Tools:getLang(PUN_TASK_NAME_BEGIN + task_type))

    -- 任务星级
    self.task_star = config.star
   
    -- self.spr_star_bg:setSpriteFrame(string.format("main-task-lang/spr-star%d.png", self.task_star))
    ex.Tools:setSpriteFrame(self.spr_star_bg, string.format("main-task-lang/spr-star%d.png", self.task_star))
    
    -- 任务奖励
    local awardList = cfg.tavern.pubTask[task_type].item
    if table.nums(awardList) == 0 then
       return
    end

    self.menu:setIsTouchInsideNode(scroll_view)
    self.menu:setSwallowsTouches(false)

    local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    self:addChild(menu)

    local item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()

    -- 计算奖励开始位置
    local start = cc.p(self.lbl_name:getPositionX(), self.lbl_name:getPositionY())
    start.x = start.x - 0
    start.y = start.y - 75

    local index = 0
    for k,v in pairs(awardList) do
        local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        item:setPosition(start.x + index * item_size.width, start.y)
        :setScale(0.8)
        :registerScriptTapHandler(handler(self, self.onShowInfo))
        menu:add(item)

        index = index + 1
    end

    self:setCurrentType()

end

function PubMainTaskCell:setCurrentType()
    local task = ex.Player.pub_task:getTask(self.task_id)
    if task == nil then
        self:setCurrentShow(TaskState.Null)
        return
    end
    -- 2已完成 1可以接取 0正在进行
    if task.used_time == 0 then
        self:setCurrentShow(TaskState.Start)
        self:setTimePro()
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

function PubMainTaskCell:setTimePro()
    
    self.lbl_time:setString(string.format("%d:%02d:%02d", 
        math.floor(self.used_time / 3600),
        math.floor(self.used_time / 60 % 60),
        math.floor(self.used_time % 60)))
    
    if     self.used_time < 1 then
        self.lbl_time:setString(ex.Tools:getLang(47607))
    end 

        if  self.lbl_need_refresh then 

            if self.used_time < cfg.system["tavern_quicken_time"] then
                self.cur_gem = 0
            else
                --self.cur_gem = math.floor(self.used_time / cfg_buyTime_second) * cfg_buyTime_gem
                self.cur_gem = math.min( math.floor(self.used_time / cfg.system["tavern_quicken_time"]) * cfg.system["tavern_quicken_cost"] , cfg.system["tavern_quicken_cost_max"] ) 
            
            end
    
            local str = string.format( ex.Tools:getLang(47471),  ItemType.IT_GEM, self.cur_gem) 

            self.lbl_need_refresh:setXmlTextLua(str)
        end 


    self.progressEndTimer:setPercentage( (self.need_time - self.used_time) / self.need_time * 100)
end

function PubMainTaskCell:updateUsedTime()
    self.used_time = self.used_time - 1

    if self.used_time <=0 then
        self.used_time = 0
        self.timer:stop()
        --self:stopTimer()
        self:setCurrentShow(TaskState.Finish)
        return
    end

    self:setTimePro()
end

function PubMainTaskCell:setCurrentShow(state)
    self.task_state = state

    self.btn_get:setVisible(state == TaskState.Start)
    self.btn_jiasu:setVisible(state == TaskState.Doing)
    self.btn_end:setVisible(state == TaskState.Finish)
    
    if state == TaskState.Start then 

        self.time_node:setVisible(false)
        -- 创建一个富文本
        if not self.lbl_btn_refresh then 
            self.lbl_btn_refresh = require("src.comp.RichTextEx"):create()
            :setFontSize(20)
            :setFontFace(FONT_DEFAULT_NAME_BOLD)
            :setAnchorTextShadow(true)
            :setWrapMode(1)

            self:addChild(self.lbl_btn_refresh)
            self.lbl_btn_refresh:setPosition(self.spr_slider_bg:getPositionX() ,self.spr_slider_bg:getPositionY())

        end 

        --local str = string.format( ex.Tools:getLang(47089), self.need_points) 
        local str = ""
        if self.need_points <= ex.Player.pub_task.adventure_count then 
            str = string.format( ex.Tools:getLang(47513),  self.need_points_type, self.need_points) 
        else 
            str = string.format( ex.Tools:getLang(47498),  self.need_points_type, self.need_points) 
        end 
        
        --local str = string.format( "<outline color='#895D2F' size='1'><font color='#7A472D'>%s</font></outline>", 111111111 ) 
        self.lbl_btn_refresh:setXmlTextLua(str)

    elseif state == TaskState.Doing then 
        self.time_node:setVisible(true)
        self:setTimePro()

        if self.lbl_btn_refresh then 
            
            self.lbl_btn_refresh:setXmlTextLua("")
            self.lbl_btn_refresh:setVisible(false)
        end 


        if not self.lbl_need_refresh then 
            self.lbl_need_refresh = require("src.comp.RichTextEx"):create()
            :setFontSize(20)
            :setFontFace(FONT_DEFAULT_NAME_BOLD)
            :setAnchorTextShadow(true)
            :setWrapMode(1)

            self:addChild(self.lbl_need_refresh)
            self.lbl_need_refresh:setPosition(self.btn_jiasu:getPositionX() ,self.btn_jiasu:getPositionY())

        end 


    elseif state == TaskState.Finish then 
        self.time_node:setVisible(true)
        self:setTimePro()

        if self.lbl_need_refresh then 
            self.lbl_need_refresh:setXmlTextLua("")
        end 

    end 


end

function PubMainTaskCell:onExit()
    self.timer:stop()
end

function PubMainTaskCell:onShowInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


function PubMainTaskCell:refreshTaskList()
    self:setCurrentType()
end

-----------------------------------------------------------------------------
function MainTaskLayer:onCreate()

    self:setAutoClose(true)
    self:setSwallowTouches(false)
    self:addBlackBackground()


    local spine_girl = sp.SkeletonAnimation:create("spine/act.json", "spine/act.atlas", 1)
    spine_girl:setAnimation(0, "act", true)
    spine_girl:setScale(0.75)
    spine_girl:setPosition(0,-120)
    self.show_model:addChild(spine_girl, -1)

	local posBar = cc.p(0, 0)
	-- posBar.x = self.time_muns:getPositionX() - self.time_muns:getContentSize().width * 0.5 + 2
	-- posBar.y = self.time_muns:getPositionY() + 1
    posBar.y = self.time_muns:getContentSize().height * 0.5

    self.progressTimer = require("src.comp.UIScale9SpriteEx"):create("main-task/spr-xjdt1.png", cc.rect(16, 16, 16, 16))
	self.progressTimer:setAnchorPoint(cc.p(0, 0.5))
	self.progressTimer:setContentSize(cc.size(self.time_muns:getContentSize().width-4, self.time_muns:getContentSize().height-2))
	self.progressTimer:setPosition(posBar)
	
    self.time_muns:addChild(self.progressTimer)

    
    local btn_size = self.btn_fast_gain:getContentSize()
    btn_size.width = btn_size.width / 2
    btn_size.height = btn_size.height / 2
    local lbl_btn_txt1 = cc.Label:createWithTTF(ex.Tools:getLang(47179), FONT_DEFAULT_NAME_BOLD, 44)
    :setTextColor(FONT_WHITLE)
    :setScale(0.5)
    :enableOutline(FONT_BTN_OUTLINE_GREEN, 2)
    :setPosition(btn_size.width, btn_size.height)
    self.btn_fast_gain:addChild(lbl_btn_txt1)


    local viewSize = cc.size(self.spr_list_bg:getContentSize().width, self.spr_list_bg:getContentSize().height - 20 )

    self.scroll_view = cc.ScrollView:create(viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(self.spr_list_bg:getPositionX() + 2, self.spr_list_bg:getPositionY() + 10)
    self.node_view:addChild(self.scroll_view)


    self.item_nums = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 40)
    :setTextColor(FONT_WHITLE)
    :setScale(0.5)
    :enableOutline(FONT_BLACK_TEXT, 2)
    :setPosition(self.time_muns:getPositionX(), self.time_muns:getPositionY())
    self:addChild(self.item_nums)


    self.btn_text_refresh = require("src.comp.RichTextEx"):create()
    :setFontSize(20)
    :setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setAnchorTextShadow(true)
    :setWrapMode(1)

    self.btn_enter:addChild(self.btn_text_refresh)
    self.btn_text_refresh:setPosition(self.btn_enter:getContentSize().width * 0.5 ,self.btn_enter:getContentSize().height * 0.5)

    
    self.btn_enter:registerScriptTapHandler(handler(self, self.onRefreshByGem))

    self.btn_fast_gain:registerScriptTapHandler(handler(self, self.onFastGain))

    ex.EffectCtr:playNormalEff(21, self.btn_power:getContentSize().width / 2, self.btn_power:getContentSize().height * 0.65, nil, self.btn_power, 0)
    self:initSwallowLayer()

    self:updateProgress( )
    self:showTaskList()
    self:refreshItemNum()
    self:refreshBtnStatus()
end 


function MainTaskLayer:onFastGain(tag, pSender)


    if ex.Player.pub_task:checkRedDot() then 

        NetManager:sendMessage(ProtocolID.GReqOneKeyGetReward)
    else 
        ex.MessageView:add(ex.Tools:getLang(41257))

    end 


end 



function MainTaskLayer:updateProgress( )

    -- wo de fangqian guanka 
    local  chapter_data = cfg.chapterreward.chapterreward[ex.Player.chapter_data.chapter_id]
    if not chapter_data then 
        return end 
    --tavern_point_max
    self.progressTimer:setPercentage(ex.Player.pub_task.adventure_count / chapter_data.tavern_point_max * 100)
    self.item_nums:setString(ex.Player.pub_task.adventure_count .. "/".. chapter_data.tavern_point_max)    

end


function MainTaskLayer:startTask(task_id)

    self:touchSwallowTouches(false)

    for _,v in pairs(self.cellList) do
        if v.task_id == task_id then
            v:setCurrentType()
            return
        end
    end
end

function MainTaskLayer:addTaskCell(task_id, task_type)
    local cell = PubMainTaskCell:createWithCCBIFile("ccbi/MainTaskCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
    cell:setAnchorPoint(ex.a.center)
	
    cell:initDone(task_id, task_type, self.scroll_view)
    -- cell.btn_done:registerScriptTapHandler(handler(self, self.onDoneTask))
    -- cell.btn_fast_gain:registerScriptTapHandler(handler(self, self.onGainTask))
    -- cell.btn_gain:registerScriptTapHandler(handler(self, self.onGainTask))

	return cell
end

function MainTaskLayer:refreshItemNum( )

    -- 900202
     self.lbl_select_num:setString(ex.Player:getItemNum(cfg.system["tavern_refresh_item"][1].item_type))
     self:refreshBtnStatus( )
     self:updateProgress()
 end
 

function MainTaskLayer:onRefreshByGem(tag, pSender)
    -- if ex.Player.pub_task.can_do_num <= 0 then
    --     -- 当前没有任务可以刷新
    --     ex.MessageView:add(ex.Tools:getLang(41038))
    --     return
    -- end

    local function confirmRefresh()
        self:refreshTask(1)
    end

    if ex.Player.pub_task.free_refresh > 0 then 


    elseif ex.Player:getItemNum(cfg.system["tavern_refresh_item"][1].item_type) > 0 and ex.Player:getItemNum(cfg.system["tavern_refresh_item"][1].item_type) >= cfg.system["tavern_refresh_item"][1].item_num then 

        -- cfg.system["tavern_refresh_item"][1].item_type, cfg.system["tavern_refresh_item"][1].item_num

    else 

        if ex.Player.gem < cfg.system["tavern_refresh_gem"] then
            ex.MessageView:add(ex.Tools:getLang(1109)) -- 钻石不足
            return
        end

        -- local content = string.format(ex.Tools:getLang(2207), cfg.system["tavern_refresh_gem"])
        -- ex.ConfirmCtr:openWindow(ex.Tools:getLang(47497), content, function()

        --     self:refreshTask(1)
        --     return
        -- end)

        -- return 

    end 

    if ex.Player.pub_task:hasHighStarTask() then
        ex.ConfirmCtr:openWindow("", ex.Tools:getLang(41017), confirmRefresh)
    else
        confirmRefresh()
    end

end


function MainTaskLayer:refreshBtnStatus( )
    local str = ""
    if ex.Player.pub_task.free_refresh > 0 then 
        
        str = string.format(ex.Tools:getLang(47644)   )

    elseif ex.Player:getItemNum(cfg.system["tavern_refresh_item"][1].item_type) > 0 then 
		str = string.format(ex.Tools:getLang(47005),cfg.system["tavern_refresh_item"][1].item_type, cfg.system["tavern_refresh_item"][1].item_num)
    else 
        str = string.format( ex.Tools:getLang(47005),  ItemType.IT_GEM, cfg.system["tavern_refresh_gem"]) 
    end 
    self.btn_text_refresh:setXmlTextLua(str)
end


function MainTaskLayer:refreshTask(index)
    -- self:touchSwallowTouches(true)
    
    NetManager:sendMessage(ProtocolID.GReqPubTaskRefresh)

end


function MainTaskLayer:refreshTaskList( )
    
    for i,v in ipairs(self.cellList) do
        v:refreshTaskList()
    end

end

function MainTaskLayer:showTaskList( )
    
    -- anniu fuwenben fuwenben 
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
    local item_size = PubMainTaskCell:createWithCCBIFile("ccbi/MainTaskCell.ccbi"):getContentSize()
    item_size.height = item_size.height + 5

    -- 调整ScrollView
    --self:adjustScrollView()
    local cont_height = item_size.height * table.nums(self.cellList)
    cont_height = math.max(cont_height , viewSize.height)

    self.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))


    -- 按排好的顺序显示
    local start = cc.p(viewSize.width * 0.5 - 2, cont_height - item_size.height * 0.5)

    for i,v in ipairs(self.cellList) do
        v:setPosition(start.x, start.y - (i - 1) * item_size.height)
    end

    --self:setTaskCount()

    -- 更新列表后可以Touch
    self:touchSwallowTouches(false)


    -- liebiao 



end




--触摸吞噬
function MainTaskLayer:initSwallowLayer()
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


function MainTaskLayer:touchSwallowTouches(is_lock)
    self.touch_layer:setSwallowsTouches(is_lock)
end

function MainTaskLayer:onShowMsg(tag, pSender)
    -- 显示一个小窗口
    require("src.layer.MainTaskPowerCtr"):instance():openWindow()
end

function MainTaskLayer:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42016), ex.Tools:getLang(42017))
end


function MainTaskLayer:onExit()
    -- add 熊梦 调用活动中心里面的咖啡时刻刷新界面
    ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS)

    if self.audio_effect_id ~= nil then
        ex.AudioManager:stopEffect(self.audio_effect_id)
    end
    self.audio_effect_id = nil
end

-----------------------------------------------------------------------------
function MainTaskCtr:onCreate()
	self:setCCBIPath("ccbi/MainTaskLayer.ccbi")
    self:setIsSingle(false)

    self.audio_effect_index = -1
end

function MainTaskCtr:getLayerClass()
	return MainTaskLayer
end

function MainTaskCtr:refreshItemNum()
    if self.layer == nil then
        return
    end
    
    self.layer:refreshItemNum()
end 


function MainTaskCtr:startTask(id)
    if self.layer == nil then
        return
    end

    self.layer:startTask(id)
end 

function MainTaskCtr:showTaskList()
    if self.layer == nil then
        return
    end
    
    self.layer:showTaskList()
end 

function MainTaskCtr:refreshTaskList()
    if self.layer == nil then
        return
    end
    
    self.layer:refreshTaskList()
end 

function MainTaskCtr:openWindow(data)
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/hero-info.plist")
    sfc:addSpriteFrames("ccbi-res/hero-info-lang.plist")
    sfc:addSpriteFrames("ccbi-res/main-task.plist")
    sfc:addSpriteFrames("ccbi-res/main-task-lang.plist")

	self:loadLayer()
	self:open()
	self:initData(data)
end

function MainTaskCtr:initData(data)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    -- 以后封装成一个模块
    local config = TableEx.findValueFunction(cfg.mainscenepage.mainscenepage, function(config)
        return MainSceneType[config.layer_type] == MainSceneType.MAINCITY_PUB_TASK
    end)

    if config and config.audio_effect ~= "" then
        local effect_index = ex.Tools:randTableIndex(config.audio_effect, self.audio_effect_index)
        if effect_index ~= nil then
            self.audio_effect_index = effect_index
            self.layer.audio_effect_id = ex.AudioManager:playEffect(config.audio_effect[effect_index])
        end
    end
end


return MainTaskCtr