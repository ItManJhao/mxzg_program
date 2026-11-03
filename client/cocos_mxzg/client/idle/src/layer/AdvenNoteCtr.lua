local AdvenNoteCtr = class("AdvenNoteCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local AdvenNoteLayer = class("AdvenNoteLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

local CommonUIHelper = require("src.layer.promotion.CommonUIHelper")

local AdvenNoteCell = class("AdvenNoteCell", require("src.comp.LuaLayerBase"))
function AdvenNoteCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

	self.lbl_title = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(46)
	:setScale(0.5)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#613c19")
	:setAnchorTextShadow(false)
	:setAnchorPoint(ex.a.left_center)
    :setPosition(cc.p(15, 125))
    :setLocalZOrder(10)
    self:addChild(self.lbl_title)
end

function AdvenNoteCell:initData(data)
	self.data = data
	self.btn_go.data = data
	self.btn_reward.data = data

	self.num_lab:setString("("..self.data.data.progress.."/"..self.data.config.mission.target..")")

	self.lbl_title:setXmlTextLua(ex.Tools:taskString(self.data.config.lang, self.data.config.mission.target, self.data.config.mission.condition, self.data.config.mission.subCondition))

	self.lbl_reward:setString(ex.StringUtil.getScientificNumber(self.data.config.exp))

	self.spr_got:setVisible(self.data.data.is_got)
	ex.Tools:addRedPoint(self.btn_reward, false)
	if not self.data.data.is_got then
		if self.data.config.jump_info.event_type == 1 and self.data.data.progress < self.data.config.mission.target then
			self.btn_go:setVisible(true)
			self.btn_reward:setVisible(false)
		else
			self.btn_go:setVisible(false)
			self.btn_reward:setVisible(true)
		end

		if self.data.data.progress >= self.data.config.mission.target then
			ex.Tools:addRedPoint(self.btn_reward, true)
		end
	else
		self.btn_go:setVisible(false)
		self.btn_reward:setVisible(false)
	end
end

function AdvenNoteCell:setIsTouchInsideNode(scroll_view)
	if scroll_view == nil then
		return
	end

	self.menu:setIsTouchInsideNode(scroll_view)
end

-----------------------------------------------------------------------------
function AdvenNoteLayer:onCreate()
    self:setAutoClose(true)
    self:addBlackBackground()

    self.scroll_view:setItemSize(cc.size(620, 155))
    self.scroll_view:setItemType(1)

	self.lbl_time = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(32)
	:setScale(0.5)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#ffffff")
	:setAnchorTextShadow(false)
	:setAnchorPoint(ex.a.right_center)
    :setPosition(550, 160)
    :setLocalZOrder(10)
    self.node_level:addChild(self.lbl_time)
    
	self.progress = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("adven-note/spr-progress.png"))
    self.progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.progress:setMidpoint(cc.p(0, 0.5))
	self.progress:setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
	self.progress:setLocalZOrder(10)
    self.progress:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2)
    self.spr_progress_bg:addChild(self.progress)
    
	local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_promotion_5")
	spr_effect:setPosition(self.btn_level_reward:getContentSize().width / 2, self.btn_level_reward:getContentSize().height / 2)
	self.btn_level_reward:addChild(spr_effect, 10)
	
	self:addTimer("adv_note_timer", 1000, handler(self, self.updateCDTime), true)
    self:updateCDTime()
end

function AdvenNoteLayer:updateCDTime()
	if self.data == nil or ex.Game:getServerTime() < self.data.start_time then 
		self.lbl_time:setXmlTextLua(ex.Tools:getLang(41052))
		return 
	end 

    local remain_time = self.data.end_time - ex.Game:getServerTime()
	if remain_time < 0 then 
        self.lbl_time:setXmlTextLua(ex.Tools:getLang(41053))
        
		NetManager:sendMessage(ProtocolID.GReqAdventureNoteInfo)

        self:removeTimerByName(self.timer_name)
		return
	end

    local d, h, m, s = ex.Tools:formatTime(math.max(remain_time, 0))
    if remain_time > 86400 then
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(41130), d))
    else
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(41129), h, m, s))
    end
end

-----------------------------------------------------------------------------
function AdvenNoteCtr:onCreate()
	self:setCCBIPath("ccbi/AdvenNoteLayer.ccbi")
	self:setIsSingle(false)
end

function AdvenNoteCtr:getLayerClass()
	return AdvenNoteLayer
end

function AdvenNoteCtr:openWindow()
	if self:isOpened() then
		return
    end
    
	self:loadLayer()
	self:open()
	self:initData()
end

function AdvenNoteCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_level_reward:registerScriptTapHandler(handler(self, self.onClick))
    self.layer.btn_more:registerScriptTapHandler(handler(self, self.onClick))
    self.layer.btn_reward:registerScriptTapHandler(handler(self, self.onClick))
	
	self.layer:addEvent(EVENT.MAIN_CITY_PROMOTION.ADVENTURE_NOTE, handler(self, self.onEvent))

    self.id_for_server = 29
    
    self:updateLayer()
    self.layer:updateCDTime()
end

function AdvenNoteCtr:updateLayer()
    if self.layer == nil then
        return
    end
    
    self.layer.data = ex.Player.promotion_data:getCommonActivityDataForID(self.id_for_server)
    local ext_info = ex.Player.promotion_data:getCommonActivityExtInfoTable(self.id_for_server)
    local table_data = self:generateData(self.layer.data, ext_info.curr_day)

    self.layer.scroll_view:getContainer():removeAllChildren()
    self.layer.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = AdvenNoteCell:createWithCCBIFile("ccbi/AdvenNoteCell.ccbi")
        cell:setIsTouchInsideNode(self.layer.scroll_view)
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)

        cell:initData(data)
    
        cell.btn_reward:registerScriptTapHandler(handler(self, self.onReward))
        cell.btn_go:registerScriptTapHandler(handler(self, self.onGo))
    
        return cell
    end

    self.layer.scroll_view:reloadData(table_data)

    -- 刷新显示等级节点
    self:refreshLevelStatus(ext_info.exp)
    -- 刷新显示累充节点
    self:refreshRechargeStatus()
end

function AdvenNoteCtr:generateData(data, day)
	local getData = function(idx)
		for i,v in ipairs(data.list) do
			if v.idx == idx then
				return v
			end
		end
		return {idx = idx, progress = 0, is_got = false, ext_info = ""}	-- 没有数据就返回默认的。
	end

	local result = {}
	for i,v in ipairs(cfg.promotionadventurenotes.promotionadventurenotes) do
		if v.turns == data.turns and v.day == day then
			local d = getData(v.idx)
			table.insert(result, {data = d,config = v})
		end
	end

	table.sort(result, function(a, b)
		local a_is_got = a.data ~= nil and a.data.is_got or false
		local b_is_got = b.data ~= nil and b.data.is_got or false

		if a_is_got or b_is_got then      -- 有已领取的
			if a_is_got == b_is_got then return a.config.idx < b.config.idx end     -- 都领了排idx
			if a_is_got then return false end                              -- a领了，a在后
			return true                                                         -- 否则就是b领了，b在后
		else                            -- 都没有领取的
			local a_total_progress = a.config.target_num or (a.config.mission ~= nil and a.config.mission.target) or 1
			local b_total_progress = b.config.target_num or (b.config.mission ~= nil and b.config.mission.target) or 1
			local a_can_get = a.data.progress >= a_total_progress
			local b_can_get = b.data.progress >= b_total_progress

			if a_can_get or b_can_get then  -- 有可以领的
				if a_can_get == b_can_get then return a.config.idx < b.config.idx end -- 都可领排idx
				if a_can_get then return true end                       -- a可领，a在前
				return false                                            -- b可领，b在前
			else
				return a.config.idx < b.config.idx        -- 没有可领的排idx
			end
		end
	end)

	return result
end

-- 刷新显示等级节点
function AdvenNoteCtr:refreshLevelStatus(exp)
	local can_get, level, config = ex.Player.promotion_data:getConfigExpLevelForAdvNote(exp)
	
	ex.Tools:addRedPoint(self.layer.btn_level_reward, can_get, cc.p(0.9, 0.9))

    -- 等级显示
    self.layer.spr_level:setString(tostring(level or 0))
    
    -- 进度条显示
    local total_value = config ~= nil and config.exp_need or 1
	local percent = math.min(exp / total_value, 1) * 100
    self.layer.progress:setPercentage(percent)
    self.layer.lbl_progress:setString(exp.."/"..total_value)
    
    -- 显示下一等级奖励
    self.layer.menu_reward_next:removeAllChildren()
	local scale = 0.6
	if config ~= nil then
		for i,v in ipairs(config.reward) do
			local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
			item:setPosition((i - 0.5) * (item:getContentSize().width * scale + 5), 0)
			item:setScale(scale)
			item:registerScriptTapHandler(handler(self, self.onItemInfo))
			item:setLocalZOrder(i * 10)
			self.layer.menu_reward_next:addChild(item)
		end
	end
end

-- 刷新显示累充节点
function AdvenNoteCtr:refreshRechargeStatus()
    local can_get, is_got, config = ex.Player.promotion_data:getConfigRechargeForAdvNote()
    local ext_info = ex.Player.promotion_data:getCommonActivityExtInfoTable(self.id_for_server)
    
    local str_title = string.format(ex.Tools:getLang(52503), config ~= nil and (config.recharge_need / 100) or 0)
    str_title = str_title.."("..(ext_info.total_recharge / 100).."/"..(config ~= nil and (config.recharge_need / 100) or 0)..")"
    self.layer.lbl_total_charge:setString(str_title)

	ex.Tools:addRedPoint(self.layer.btn_reward, can_get, cc.p(0.95, 0.9))
    self.layer.btn_reward:setVisible(not is_got)
	self.layer.spr_got:setVisible(is_got)
    
    -- 显示累充奖励
    self.layer.menu_reward:removeAllChildren()
	local scale = 0.75
	if config ~= nil then
		for i,v in ipairs(config.reward) do
			local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
			item:setPosition((i - 0.5) * ((item:getContentSize().width * scale) + 5), 0)
			item:setScale(scale)
			item:registerScriptTapHandler(handler(self, self.onItemInfo))
			item:setLocalZOrder(i * 10)
			self.layer.menu_reward:addChild(item)
		end
	end
end

function AdvenNoteCtr:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-- 点击cell的领取奖励
function AdvenNoteCtr:onReward(tag, pSender)
	local req_get = Task4_pb.GReqAdventureNoteGet()
	req_get.idx = pSender.data.config.idx
	NetManager:sendMessage(ProtocolID.GReqAdventureNoteGet, req_get)
end

-- 点击cell的前往
function AdvenNoteCtr:onGo(tag, pSender)
	if pSender.data.config.jump_info.event_type == 1 then
		CommonUIHelper:onEventDispatcher(pSender.data.config.jump_info.event_type, pSender.data.config.jump_info.event_arg)

        self:closeWindow()
	else
		ex.MessageView:add(ex.Tools:getLang(pSender.data.config.jump_info.no_jump_hint))
	end
end

function AdvenNoteCtr:onClick(tag, pSender)
    if pSender == self.layer.btn_reward then
        local _, is_got, config = ex.Player.promotion_data:getConfigRechargeForAdvNote()
		local ext_info = ex.Player.promotion_data:getCommonActivityExtInfoTable(self.id_for_server)
        if not is_got and config ~= nil and ext_info.total_recharge >= config.recharge_need then
            local req_get = Task4_pb.GReqAdventureNoteRechargeGet()
            req_get.idx = config.idx
            NetManager:sendMessage(ProtocolID.GReqAdventureNoteRechargeGet, req_get)
        else
			ex.MessageView:add(ex.Tools:getLang(52512))
        end
    elseif pSender == self.layer.btn_level_reward then
		-- 打开窗口
		require("src.layer.promotion.LTAAdvNoteRewardCtrl"):instance():openLevelWindow()
    elseif pSender == self.layer.btn_more then
		-- 打开窗口
		require("src.layer.promotion.LTAAdvNoteRewardCtrl"):instance():openRechargeWindow()
    else
        if pSender.item_type ~= nil then
            ex.Tools:onClickItemInfo(pSender.item_type)
        else
            print("LTAAdventureNoteLayer:onClick no handle!")
        end
    end
end

function AdvenNoteCtr:onEvent(event, ui_event)
	if ui_event == EVENT.UI.REFRESH_ALL then
        self.layer.data = ex.Player.promotion_data:getCommonActivityDataForID(self.id_for_server)
        local ext_info = ex.Player.promotion_data:getCommonActivityExtInfoTable(self.id_for_server)
        local table_data = self:generateData(self.layer.data, ext_info.curr_day)

		self:updateLayer()

		if self.layer.scroll_view ~= nil then
			self.layer.scroll_view:reloadData(table_data)
		end
	elseif ui_event == EVENT.UI.REFRESH_RECHARGE or ui_event == EVENT.UI.REFRESH_BANNER then
		self:updateLayer()
	end
end

return AdvenNoteCtr