local MysteryBoxCtr = class("MysteryBoxCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local MysteryBoxLayer = class("MysteryBoxLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

local CommonUIHelper = require("src.layer.promotion.CommonUIHelper")

local MysteryBoxCell = class("MysteryBoxCell", require("src.comp.LuaLayerBase"))
function MysteryBoxCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

	self.lbl_title = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(38)
	:setScale(0.5)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#613c19")
	:setAnchorTextShadow(false)
	:setAnchorPoint(ex.a.center)
    :setPosition(91, 205)
    :setLocalZOrder(10)
	self:addChild(self.lbl_title)
end

function MysteryBoxCell:initData(data)
    self.data = data
	self.btn_go.data = data
	self.btn_reward.data = data

    self.lbl_title:setXmlTextLua(ex.Tools:taskString(self.data.config.lang, self.data.config.mission.target, self.data.config.mission.condition, self.data.config.mission.subCondition))
    self.num_lab:setString("("..self.data.data.progress.."/"..self.data.config.mission.target..")")

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

function MysteryBoxCell:setIsTouchInsideNode(scroll_view)
	if scroll_view == nil then
		return
	end

	self.menu:setIsTouchInsideNode(scroll_view)
end

-----------------------------------------------------------------------------
function MysteryBoxLayer:onCreate()
    self:setAutoClose(true)
    self:addBlackBackground()

    self.scroll_view:setItemSize(cc.size(190, 235))
    self.scroll_view:setItemType(1)

	self.lbl_time = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(32)
	:setScale(0.5)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#ffffff")
	:setAnchorTextShadow(false)
	:setAnchorPoint(ex.a.right_center)
    :setPosition(550, 155)
    :setLocalZOrder(10)
    self.node_level:addChild(self.lbl_time)
    
	self.progress = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("mystery-box/spr-progress.png"))
    self.progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.progress:setMidpoint(cc.p(0, 0.5))
	self.progress:setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
	self.progress:setLocalZOrder(10)
    self.progress:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2)
    self.spr_progress_bg:addChild(self.progress)
    
	local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_promotion_6")
	spr_effect:setPosition(self.btn_level_reward:getContentSize().width / 2, self.btn_level_reward:getContentSize().height / 2)
	self.btn_level_reward:addChild(spr_effect, 10)
	
	self:addTimer("mystery_box_timer", 1000, handler(self, self.updateCDTime), true)
end

function MysteryBoxLayer:updateCDTime()
	if self.data == nil or ex.Game:getServerTime() < self.data.start_time then 
		self.lbl_time:setXmlTextLua(ex.Tools:getLang(41052))
		return 
	end 

	local remain_time = self.data.end_time - ex.Game:getServerTime()
	if remain_time < 0 then 
        self.lbl_time:setXmlTextLua(ex.Tools:getLang(41053));
        
		NetManager:sendMessage(ProtocolID.GReqMysteryBoxInfo)

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
function MysteryBoxCtr:onCreate()
	self:setCCBIPath("ccbi/MysteryBoxLayer.ccbi")
	self:setIsSingle(false)
end

function MysteryBoxCtr:getLayerClass()
	return MysteryBoxLayer
end

function MysteryBoxCtr:openWindow()
	if self:isOpened() then
		return
    end
    
	self:loadLayer()
	self:open()
	self:initData()
end

function MysteryBoxCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_level_reward:registerScriptTapHandler(handler(self, self.onClick))
    self.layer.btn_more:registerScriptTapHandler(handler(self, self.onClick))
    self.layer.btn_reward:registerScriptTapHandler(handler(self, self.onClick))
	
	self.layer:addEvent(EVENT.MAIN_CITY_PROMOTION.MYSTERY_BOX, handler(self, self.onEvent))

    self.id_for_server = 30
    
    self:updateLayer()
    self.layer:updateCDTime()
end

function MysteryBoxCtr:updateLayer()
    if self.layer == nil then
        return
    end
    
    self.layer.data = ex.Player.promotion_data:getCommonActivityDataForID(self.id_for_server)
    local ext_info = ex.Player.promotion_data:getCommonActivityExtInfoTable(self.id_for_server)
    local table_data = self:generateData(self.layer.data, ext_info.curr_day)

    self.layer.scroll_view:getContainer():removeAllChildren()
    self.layer.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = MysteryBoxCell:createWithCCBIFile("ccbi/MysteryBoxCell.ccbi")
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

function MysteryBoxCtr:generateData(data, day)
	local getData = function(idx)
		for i,v in ipairs(data.list) do
			if v.idx == idx then
				return v
			end
		end
		return {idx = idx, progress = 0, is_got = false, ext_info = ""}	-- 没有数据就返回默认的。
	end

	local result = {}
	for i,v in ipairs(cfg.promotionmysterybox.promotionmysterybox) do
		if v.turns == data.turns and v.day == day then
			local d = getData(v.idx)

			table.insert(result, {data = d,config = v})
		end
	end

	return result
end

-- 刷新显示等级节点
function MysteryBoxCtr:refreshLevelStatus(exp)
	local can_get, level, config = ex.Player.promotion_data:getConfigExpLevelForMysteryBox(exp)
	
	ex.Tools:addRedPoint(self.layer.btn_level_reward, can_get, cc.p(0.9, 0.9))

    -- 进度条显示
    local total_value = config ~= nil and config.exp_need or 1
	local percent = math.min(exp / total_value, 1) * 100
    self.layer.progress:setPercentage(percent)
    self.layer.lbl_progress:setString(exp.."/"..total_value)
end

-- 刷新显示累充节点
function MysteryBoxCtr:refreshRechargeStatus()
    local can_get, is_got, config = ex.Player.promotion_data:getConfigRechargeForMysteryBox()
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

function MysteryBoxCtr:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-- 点击cell的领取奖励
function MysteryBoxCtr:onReward(tag, pSender)
	local req_get = Task4_pb.GReqMysteryBoxGet()
	req_get.idx = pSender.data.config.idx
	NetManager:sendMessage(ProtocolID.GReqMysteryBoxGet, req_get)
end

-- 点击cell的前往
function MysteryBoxCtr:onGo(tag, pSender)
	if pSender.data.config.jump_info.event_type == 1 then
        CommonUIHelper:onEventDispatcher(pSender.data.config.jump_info.event_type, pSender.data.config.jump_info.event_arg)
        
        self:closeWindow()
	else
		ex.MessageView:add(ex.Tools:getLang(pSender.data.config.jump_info.no_jump_hint))
	end
end

function MysteryBoxCtr:onClick(tag, pSender)
    if pSender == self.layer.btn_reward then
        local _, is_got, config = ex.Player.promotion_data:getConfigRechargeForMysteryBox()
        local ext_info = ex.Player.promotion_data:getCommonActivityExtInfoTable(self.id_for_server)
        if not is_got and config ~= nil and ext_info.total_recharge >= config.recharge_need then
            local req_get = Task4_pb.GReqMysteryBoxRechargeGet()
            req_get.idx = config.idx
            NetManager:sendMessage(ProtocolID.GReqMysteryBoxRechargeGet, req_get)
        else
            ex.MessageView:add(ex.Tools:getLang(52612))
        end
    elseif pSender == self.layer.btn_level_reward then
		-- 打开窗口
		require("src.layer.promotion.LTAMysteryBoxRewardCtrl"):instance():openLevelWindow()
    elseif pSender == self.layer.btn_more then
		-- 打开窗口
		require("src.layer.promotion.LTAMysteryBoxRewardCtrl"):instance():openRechargeWindow()
    else
        if pSender.item_type ~= nil then
            ex.Tools:onClickItemInfo(pSender.item_type)
        else
            print("LTAMysteryBoxLayer:onClick no handle!")
        end
    end
end

function MysteryBoxCtr:onEvent(event, ui_event)
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

return MysteryBoxCtr