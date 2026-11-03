--[[
    func: 一元礼包
    time:2020-01-09 14:49:56
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local PROMThreeDayLayer = class("PROMThreeDayLayer", require("src.layer.promotion.PromotionBaseLayer"))

-----------------------------------------------------------------------
function PROMThreeDayLayer:onCreateDone()
	self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.promotion_id = 61
    self.layer_type = ex.Player.promotion_data.three_day_gift_data.day

    -- self:addTimeProgress()
    -- self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(426))

    -- local top_y = self.layer_promotion:getTopY()
    -- top_y = top_y - 126 - 10
    
    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    self.spr_bg:setPositionY(self.spr_bg:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    
    self.node_day:setPositionY(self.spr_bg:getPositionY() - 85)
    self.node_main_reward:setPositionY(self.spr_bg:getPositionY() - 321.5)
    self.node_main:setPositionY(self.spr_bg:getPositionY() - 575)
    self.node_task:setPositionY(self.spr_bg:getPositionY() - 680)

    
    -- 子任务内容
	self.lbl_sub_task = cpp.RichTextEx:createWithXMLLua("123123")
	:setFontSize(48)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#7a472d")
	:setScale(0.5)
	:setPosition(cc.p(-255.8, -30))
	:setAnchorPoint(cc.p(0, 0.5))
    self.node_task:addChild(self.lbl_sub_task)

    -- 主任务内容
    self.lbl_main_task = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(48)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FFFFFF")
	:setScale(0.5)
	:setPosition(cc.p(0, 20))
    self.node_main:addChild(self.lbl_main_task)

	self.prog_task = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("promotion/prog-vip-1.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.prog_task:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2)
    self.spr_progress_bg:addChild(self.prog_task)

    -- self.node_main:setPositionY((self.node_day:getPositionY() + self.node_task:getPositionY()) / 2 + 25 )
    self.node_task:setScale(ex.s.global_scale)
    self.node_day:setScale(ex.s.global_scale)

    self.btn_day1:setLabelText(ex.Tools:getLang(5591))
    self.btn_day2:setLabelText(ex.Tools:getLang(5023))
    self.btn_day3:setLabelText(ex.Tools:getLang(5370))

    self.scroll_view:setItemSize(cc.size(100, 100))

    self:updateView()
    self:addEvent(EVENT.MAIN_CITY_PROMOTION.THREE_DAY_GIFT_REFRESH, handler(self, self.updateView))

    NetManager:sendMessage(ProtocolID.GReqThreeDayTaskData)

    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
    -- self:updateTimer()
end

function PROMThreeDayLayer:onExit()
    self:removeTimerByName("timer")
end

function PROMThreeDayLayer:updateTimer()
	local is_open =  ex.Player.promotion_data:checkThreeDayGiftIsOpen()
    if is_open ~= true then
        if cfg.funcopen["act_limit_time_server"].isVisible() then
            cfg.funcopen["act_limit_time_server"].open()
        else
            cfg.funcopen["main_city"].open()
        end
        return
    end
end

function PROMThreeDayLayer:updateView()

    -- self.layer_type = 1 -- ex.Player.promotion_data.three_day_gift_data.day
    self.layer_type = self.layer_type or 1
    self.layer_type = cc.clampf(self.layer_type, 1, 3)

    self.btn_day1:setChecked(self.layer_type == 1)
    self.btn_day2:setChecked(self.layer_type == 2)
    self.btn_day3:setChecked(self.layer_type == 3)

    

    self:updateTask()
end

function PROMThreeDayLayer:updateTask()
    local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")

    -- 读取当前天数的数据
    local day = self.layer_type
    local server_day = ex.Player.promotion_data.three_day_gift_data.day
    local task_list = ex.Player.promotion_data.three_day_gift_data.task_list
    local turns = ex.Player.promotion_data:getPromotionTurns(self.promotion_id)
    local cur_sub_task = ex.Player.promotion_data:threeDayGetCurTask(day)

    ex.Tools:addRedPoint(self.btn_day1, server_day >= 1 and ex.Player.promotion_data:threeDayCheckRedDotByDay(1), cc.p(0.9, 0.95))
    ex.Tools:addRedPoint(self.btn_day2, server_day >= 2 and ex.Player.promotion_data:threeDayCheckRedDotByDay(2), cc.p(0.9, 0.95))
    ex.Tools:addRedPoint(self.btn_day3, server_day >= 3 and ex.Player.promotion_data:threeDayCheckRedDotByDay(3), cc.p(0.9, 0.95))

    -- 任务个数
    local task_num = 1
    -- 任务完成个数
    local finish_num = 0

    local sub_task_list = {}
    for i,v in ipairs(cfg.promotion3daytask.promotion3daytask) do
        if v.turns == turns and v.day == day then
            local data = TableEx.findValueFunction(task_list, function(value)
                return value.idx == v.idx
            end)

            local is_reward = TableEx.findValueFunction(ex.Player.promotion_data.three_day_gift_data.reward_idx, function(value)
                return v.idx == value
            end)

            if data and data.progress >= v.task.target and v.task_index <= cur_sub_task.task_index and is_reward then
                finish_num = finish_num + 1
            end

            table.insert(sub_task_list, v)
		end
    end

    task_num = table.nums(sub_task_list)

    local cur_main_reward = TableEx.findValueFunction(cfg.promotion3daytaskreward.promotion3daytaskreward, function(value)
        return value.turns == turns and value.day == day
    end)

    self.lbl_main_task:setXmlTextLua(string.format(ex.Tools:getLang(41352), task_num, finish_num, task_num))
    self.prog_task:setPercentage(finish_num / task_num * 100)
    ex.Tools:setSpriteFrame(self.spr_item_bg, string.format("three-day/spr-reward-%d.png", day))

    -- 更新主任务奖励
    local reward_status = ex.Player.promotion_data:threeDayGetUltimateRewardStatus(day)

    self.menu_main_task:removeChildByName("item_reward")
    local item_main = UIMenuItemBag:createWithData(cur_main_reward.reward[1].item_type, cur_main_reward.reward[1].item_num)
    item_main:setPosition(cc.p(0, 10))
    item_main:setName("item_reward")
    item_main:registerScriptTapHandler(handler(self, self.onMainReward))
    self.menu_main_task:addChild(item_main)
    ex.Tools:addRedPoint(item_main, reward_status == 1)
    item_main:setGet(reward_status == 2)

    local cur_sub_task_data = TableEx.findValueFunction(ex.Player.promotion_data.three_day_gift_data.task_list, function(value)
        return cur_sub_task.idx == value.idx
    end)

    self.lbl_sub_task:setXmlTextLua(string.format(ex.Tools:getLang(41353), cur_sub_task.task_index) .. ex.Tools:taskString(cur_sub_task.lang, cur_sub_task.task.target, nil))
    self.lbl_progress:setString(string.format("%d/%d", cur_sub_task_data.progress, cur_sub_task.task.target))

    -- 更新子任务奖励
    self.scroll_view.createItemFunction = function(data, scale)
        local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
        item:setScale(0.78)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        return item
    end
    self.scroll_view:reloadData(cur_sub_task.reward)


    local is_reward = TableEx.findValueFunction(ex.Player.promotion_data.three_day_gift_data.reward_idx, function(value)
        return cur_sub_task.idx == value
    end)

    -- 更新按钮状态
    local can_reward = cur_sub_task_data.progress >= cur_sub_task.task.target and is_reward == nil
    self.lbl_progress:setVisible(can_reward ~= true)

    ex.Tools:addRedPoint(self.btn_submit, false)

    -- 未到达开启天数
    if day > server_day then
        ex.Tools:setGrayAuto(self.btn_submit:getNormalImage(), true)
        ex.Tools:setGrayAuto(self.btn_submit:getSelectedImage(), true)
        self.btn_submit:setEnabled(false)
        self.btn_submit:setLabelText(ex.Tools:getLang(47681))
        self.lbl_progress:setVisible(false)
    elseif is_reward then
        ex.Tools:setGrayAuto(self.btn_submit:getNormalImage(), true)
        ex.Tools:setGrayAuto(self.btn_submit:getSelectedImage(), true)
        self.btn_submit:setEnabled(false)
        self.btn_submit:setLabelText(ex.Tools:getLang(2703))
        self.lbl_progress:setVisible(false)
    -- elseif self.layer_type ~= ex.Player.promotion_data.three_day_gift_data.day then
    elseif can_reward ~= true then
        ex.Tools:setBtnRewardStatus(self.btn_submit, can_reward and 1 or 0, ex.Tools:getLang(47695), ex.Tools:getLang(47627))
        ex.Tools:setGrayAuto(self.btn_submit:getNormalImage(), false)
        ex.Tools:setGrayAuto(self.btn_submit:getSelectedImage(), false)
        self.btn_submit:setEnabled(true)
    else
        ex.Tools:setBtnRewardStatus(self.btn_submit, can_reward and 1 or 0, ex.Tools:getLang(47695), ex.Tools:getLang(47627) )
        ex.Tools:setGrayAuto(self.btn_submit:getNormalImage(), false)
        ex.Tools:setGrayAuto(self.btn_submit:getSelectedImage(), false)
        self.btn_submit:setEnabled(true)
        ex.Tools:addRedPoint(self.btn_submit, true)
    end
end

function PROMThreeDayLayer:onSubmit(tag, pSender)
    local day = self.layer_type
    local cur_sub_task = ex.Player.promotion_data:threeDayGetCurTask(day)

    local is_reward = TableEx.findValueFunction(ex.Player.promotion_data.three_day_gift_data.reward_idx, function(value)
        return cur_sub_task.idx == value
    end)

    -- 最后一天的奖励已经领取了
    -- if is_reward or self.layer_type ~= ex.Player.promotion_data.three_day_gift_data.day then
    if is_reward  then
        return
    end

    local data = TableEx.findValueFunction(ex.Player.promotion_data.three_day_gift_data.task_list, function(value)
        return value.idx == cur_sub_task.idx
    end)

    local cur_sub_task_data = TableEx.findValueFunction(ex.Player.promotion_data.three_day_gift_data.task_list, function(value)
        return cur_sub_task.idx == value.idx
    end)

    if cur_sub_task_data.progress >= cur_sub_task.task.target then
        -- 领取奖励
        local req_reward = Promotion061_pb.GReqThreeDayTaskReward()
        req_reward.idx = cur_sub_task.idx
        NetManager:sendMessage(ProtocolID.GReqThreeDayTaskReward, req_reward)

        NetManager:sendMessage(ProtocolID.GReqThreeDayTaskData)
    else
        -- 领取
        local backToLayer =  function ( layer )
            -- require("src.layer.MainTaskCtr"):instance():openWindow()
            -- cfg.funcopen["act_limit_time_server"].open()
            local vec_idx = ex.Player.promotion_data:getPromotionByType(PromotionPageType.LIMIT_TIME_SERVER_ACTIVITY)
            local select_idx = 705
            -- for i,v in ipairs(vec_idx) do
            --     if v.idx == 705 then
            --         select_idx = i
            --         break
            --     end
            -- end
			layer:initWithTable(nil, vec_idx, select_idx)
        end
        local params = {}
        params.backToLayer = backToLayer

        ex.JumpManager:jumpByAtom(cur_sub_task.jump_info.event_arg, params)
    end
end

function PROMThreeDayLayer:onDay(tag)
    -- if ex.Player.promotion_data.three_day_gift_data.day < tag then
    --     ex.MessageView:add("未达到开放天数")
    --     self:updateView()
    --     return
    -- end

    self.layer_type = tag
    self:updateView()
end

function PROMThreeDayLayer:onMainReward(tag, pSender)
    -- 判断是否可以领取当前天数奖励
    local reward_status = ex.Player.promotion_data:threeDayGetUltimateRewardStatus(self.layer_type)
    -- 领取今天最终奖励
    if reward_status == 1 then
        local req_reward = Promotion061_pb.GReqThreeDayTaskUltimateReward()
        req_reward.day = self.layer_type
        NetManager:sendMessage(ProtocolID.GReqThreeDayTaskUltimateReward, req_reward)

        NetManager:sendMessage(ProtocolID.GReqThreeDayTaskData)
    else
        ex.Tools:showItemInfo(tag, pSender)
    end
end

return PROMThreeDayLayer
