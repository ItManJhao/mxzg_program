local LTAMysteryBoxLayer = class("LTAMysteryBoxLayer", require("src.comp.EventLayer"))
local LTAMysteryBoxCell = class("LTAMysteryBoxCell", require("src.comp.LuaLayerBase"))

local CommonUIHelper = require("src.layer.promotion.CommonUIHelper")

function LTAMysteryBoxCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.data = {}

	local title_1 = cpp.RichTextEx:createWithXMLLua("")
	title_1:setFontSize(38)
	title_1:setScale(0.5)
	title_1:setFontFace(FONT_DEFAULT_NAME_BOLD)
	title_1:setFontColor("#613c19")
	title_1:setAnchorTextShadow(false)
	title_1:setAnchorPoint(ex.a.center)
    title_1:setPosition(ex.Tools:getAbsolutePosition(cc.p(-99, -206), CommonUIDefine.UIDefine.ComponentOriginType.RIGHT_TOP, self.node_1))
    title_1:setLocalZOrder(10)
	self.node_1:addChild(title_1)

	local title_2 = cpp.RichTextEx:createWithXMLLua("")
	title_2:setFontSize(38)
	title_2:setScale(0.5)
	title_2:setFontFace(FONT_DEFAULT_NAME_BOLD)
	title_2:setFontColor("#613c19")
	title_2:setAnchorTextShadow(false)
	title_2:setAnchorPoint(ex.a.center)
    title_2:setPosition(ex.Tools:getAbsolutePosition(cc.p(-99, -206), CommonUIDefine.UIDefine.ComponentOriginType.RIGHT_TOP, self.node_2))
    title_2:setLocalZOrder(10)
	self.node_2:addChild(title_2)

	local title_3 = cpp.RichTextEx:createWithXMLLua("")
	title_3:setFontSize(38)
	title_3:setScale(0.5)
	title_3:setFontFace(FONT_DEFAULT_NAME_BOLD)
	title_3:setFontColor("#613c19")
	title_3:setAnchorTextShadow(false)
	title_3:setAnchorPoint(ex.a.center)
    title_3:setPosition(ex.Tools:getAbsolutePosition(cc.p(-99, -206), CommonUIDefine.UIDefine.ComponentOriginType.RIGHT_TOP, self.node_3))
    title_3:setLocalZOrder(10)
	self.node_3:addChild(title_3)
	
	self.node_ref = {}
	table.insert(self.node_ref, {
		node = self.node_1,
		lbl_reward = self.lbl_reward_1,
		title = title_1,
		menu = self.menu_1,
		btn_do = self.btn_do_1,
		spr_got = self.spr_got_1,
		num_lab = self.num_lab_1
	})
	table.insert(self.node_ref, {
		node = self.node_2,
		lbl_reward = self.lbl_reward_2,
		title = title_2,
		menu = self.menu_2,
		btn_do = self.btn_do_2,
		spr_got = self.spr_got_2,
		num_lab = self.num_lab_2
	})
	table.insert(self.node_ref, {
		node = self.node_3,
		lbl_reward = self.lbl_reward_3,
		title = title_3,
		menu = self.menu_3,
		btn_do = self.btn_do_3,
		spr_got = self.spr_got_3,
		num_lab = self.num_lab_3
	})

	self.node_ref[1].btn_do:setTag(1)
	self.node_ref[2].btn_do:setTag(2)
	self.node_ref[3].btn_do:setTag(3)
    self.node_ref[1].btn_do:registerScriptTapHandler(handler(self, self.onBtnClick))
    self.node_ref[2].btn_do:registerScriptTapHandler(handler(self, self.onBtnClick))
    self.node_ref[3].btn_do:registerScriptTapHandler(handler(self, self.onBtnClick))
end

function LTAMysteryBoxCell:initDone(data)
	self.data = data

	for i=1,3 do
		if self.data[i] ~= nil then
			self.node_ref[i].node:setVisible(true)

			self.node_ref[i].title:setXmlTextLua(ex.Tools:taskString(self.data[i].config.lang, self.data[i].config.mission.target, self.data[i].config.mission.condition, self.data[i].config.mission.subCondition))
			self.node_ref[i].num_lab:setString("("..self.data[i].data.progress.."/"..self.data[i].config.mission.target..")")

			self.node_ref[i].lbl_reward:setString(ex.StringUtil.getScientificNumber(self.data[i].config.exp))
		
			self.node_ref[i].btn_do:setVisible(not self.data[i].data.is_got)
			self.node_ref[i].spr_got:setVisible(self.data[i].data.is_got)
			ex.Tools:addRedPoint(self.node_ref[i].btn_do, false)
			if not self.data[i].data.is_got then
				if self.data[i].config.jump_info.event_type == 1 and self.data[i].data.progress < self.data[i].config.mission.target then
					self.node_ref[i].btn_do:setLabelText(ex.Tools:getLang(2702))
				else
					self.node_ref[i].btn_do:setLabelText(ex.Tools:getLang(2214))
				end

				if self.data[i].data.progress >= self.data[i].config.mission.target then
					ex.Tools:addRedPoint(self.node_ref[i].btn_do, true)
				end
			end
		else
			self.node_ref[i].node:setVisible(false)
		end
	end
end

function LTAMysteryBoxCell:setIsTouchInsideNode(scroll_view)
	if scroll_view == nil then
		return
	end

	self.node_ref[1].menu:setIsTouchInsideNode(scroll_view)
	self.node_ref[2].menu:setIsTouchInsideNode(scroll_view)
	self.node_ref[3].menu:setIsTouchInsideNode(scroll_view)
end

function LTAMysteryBoxCell:onBtnClick(tag, pSender)
	if self.data[tag].data.progress < self.data[tag].config.mission.target then
		if self.data[tag].config.jump_info.event_type == 1 then
			CommonUIHelper:onEventDispatcher(self.data[tag].config.jump_info.event_type, self.data[tag].config.jump_info.event_arg)
		else
			ex.MessageView:add(ex.Tools:getLang(self.data[tag].config.jump_info.no_jump_hint))
		end
	else
		local req_get = Task4_pb.GReqMysteryBoxGet()
		req_get.idx = self.data[tag].config.idx
		NetManager:sendMessage(ProtocolID.GReqMysteryBoxGet, req_get)
	end
end


-----------------------------------------------------------------------
function LTAMysteryBoxLayer:onCreateDone()
	self.super.onCreate(self)
	self:setName("LTAMysteryBoxLayer")

	self:setAutoClose(false)
	self:setSwallowTouches(false)
	
	self.id_for_server = 30
	self.promotion_idx = 422
	self.timer_name = "pro_mystery_box_timer"
	
	-- 准备数据
	self.data = {}
	self.ext_info = {}
	self:refreshData()
	self.data_table = {}
	self:refreshTabelData()

	self.item_temp = {}

	-- 设置banner
	self.global_scale = ex.p.width / 640

	self.lbl_time = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(36)
	:setScale(0.5)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#ffffff")
	:setAnchorTextShadow(false)
	:setAnchorPoint(ex.a.right_center)
    :setPosition(ex.Tools:getAbsolutePosition(cc.p(5, 0), CommonUIDefine.UIDefine.ComponentOriginType.RIGHT_TOP, self.time_node))
    :setLocalZOrder(10)
	self.time_node:addChild(self.lbl_time)
	self.time_node:setScale(self.global_scale)

	self.banner:setScale(self.global_scale)
	
	local banner_size = self.banner:getContentSize()
	local positionY = self.layer_promotion:getBottomY() + 40
	self.banner:setPosition(cc.p(0, positionY))
	positionY = positionY + self.banner:getContentSize().height * self.global_scale

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/promotion.plist")
	sfc:addSpriteFrames("ccbi-res/promotion-effect.plist")

	self.progress_timer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("promotion/spr-progress-fg1.png"))
    self.progress_timer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.progress_timer:setMidpoint(cc.p(0, 0.5))
	self.progress_timer:setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
	self.progress_timer:setLocalZOrder(10)
    self.progress_timer:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2 )
    self.spr_progress_bg:addChild(self.progress_timer)
    
    self.btn_level_reward:registerScriptTapHandler(handler(self, self.onClick))
    self.btn_more:registerScriptTapHandler(handler(self, self.onClick))
    self.btn_do:registerScriptTapHandler(handler(self, self.onClick))
	
	self.spr_altar:setPosition(0, self.layer_promotion:getTopY() - 12)
	self.spr_altar:setPreferredSize(cc.size(ex.p.width, self.spr_altar:getPreferredSize().height))

	self.table_view_bg:setPosition(4, positionY + 4)
	self.table_view_bg:setPreferredSize(cc.size(ex.p.width - 4 * 2, self.layer_promotion:getTopY() - positionY - 4 - 16))

	-- 创建tableview
	local table_view_bg_size = self.table_view_bg:getContentSize()
	local view_size = cc.size((table_view_bg_size.width - 4 * 2) / self.global_scale, (table_view_bg_size.height - 4 * 2) / self.global_scale)
	
	self.table_view = cpp.UITableViewEx:create(view_size)
	self.table_view:setAnchorPoint(cc.p(0,0))
	self.table_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self.table_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	self.table_view:setBounceable(false)
	self.table_view:setDelegate()
	self.table_view:setDataSource()
	self.table_view:setScale(self.global_scale)
	self.table_view:setPosition(cc.p(4, 4))
	self.table_view_bg:addChild(self.table_view)
	
	-- self.table_view:registerScriptHandler(handler(self, self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL) --滚动时的回掉函数
	self.table_view:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX) --列表项的尺寸
	self.table_view:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX) --创建列表项
	self.table_view:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW) --列表项的数量
	-- self.table_view:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED) --列表项被点击

	local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_promotion_6")
	spr_effect:setPosition(self.btn_level_reward:getContentSize().width / 2, self.btn_level_reward:getContentSize().height / 2)
	self.btn_level_reward:addChild(spr_effect, 10)
	
	self:addEvent(EVENT.MAIN_CITY_PROMOTION.MYSTERY_BOX, handler(self, self.onEvent))

	self:addTimer(self.timer_name, 1000, handler(self, self.updateCDTime), true)

	self.table_view:reloadData()

	self:refreshBanner()

    self:updateCDTime()
end

function LTAMysteryBoxLayer:updateCDTime()
    local remain_time = self.data.end_time - ex.Game:getServerTime()

	if ex.Game:getServerTime()  <  self.data.start_time then 
		self.lbl_time:setXmlTextLua(ex.Tools:getLang(41052));
		return 
	end 

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

function LTAMysteryBoxLayer:updateProgress(value, total_value)
	total_value = total_value == 0 and 1 or total_value
	local percent = math.min(value / total_value, 1) * 100
    self.progress_timer:setPercentage(percent)
end

function LTAMysteryBoxLayer:refreshExpStatus()
    if self.ext_info == nil or self.ext_info.exp == nil then
        return
    end
    
	local can_get, level, config = ex.Player.promotion_data:getConfigExpLevelForMysteryBox(self.ext_info.exp)
	
	ex.Tools:addRedPoint(self.btn_level_reward, can_get)

    self:updateProgress(self.ext_info.exp, config ~= nil and config.exp_need or 0)
    
    self.lbl_progress:setString(tostring(self.ext_info.exp).."/"..tostring(config ~= nil and config.exp_need or 0))
end

function LTAMysteryBoxLayer:refreshRechargeStatus()
    local can_get, is_got, config = ex.Player.promotion_data:getConfigRechargeForMysteryBox()
	
    self.title:setString(string.format(ex.Tools:getLang(52503), config ~= nil and (config.recharge_need / 100) or 0))
    self.num_lab:setString("("..(self.ext_info.total_recharge / 100).."/"..(config ~= nil and (config.recharge_need / 100) or 0)..")")

	ex.Tools:addRedPoint(self.btn_do, can_get)
    if not is_got then
        self.btn_do:setLabelText(ex.Tools:getLang(2214))
    end
    self.btn_do:setVisible(not is_got)
	self.spr_got:setVisible(is_got)
	
	for i,v in ipairs(self.item_temp) do
		v:removeFromParent(true)
	end
	self.item_temp = {}

    local begin = 24
    local margin = 5
    local posY = 256
	local scale = 0.75
	if config ~= nil then
		for i,v in ipairs(config.reward) do
			local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
			local posX = (begin + item:getContentSize().width * scale / 2) + (i - 1) * ((item:getContentSize().width * scale) + margin)
			item:setPosition(posX, posY)
			item:setScale(scale)
			item:registerScriptTapHandler(handler(self, self.onClick))
			item:setLocalZOrder(i * 10)
			self.menu:addChild(item)
			table.insert(self.item_temp, item)
		end
	end
end

function LTAMysteryBoxLayer:refreshBanner()
    self:refreshExpStatus()
    
    self:refreshRechargeStatus()
end

function LTAMysteryBoxLayer:onClick(tag, pSender)
    if pSender == self.btn_do then
        local _, is_got, config = ex.Player.promotion_data:getConfigRechargeForMysteryBox()
        if not is_got and config ~= nil and self.ext_info.total_recharge >= config.recharge_need then
            local req_get = Task4_pb.GReqMysteryBoxRechargeGet()
            req_get.idx = config.idx
            NetManager:sendMessage(ProtocolID.GReqMysteryBoxRechargeGet, req_get)
        else
            ex.MessageView:add(ex.Tools:getLang(52612))
        end
    elseif pSender == self.btn_level_reward then
		-- 打开窗口
		require("src.layer.promotion.LTAMysteryBoxRewardCtrl"):instance():openLevelWindow()
    elseif pSender == self.btn_more then
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

function LTAMysteryBoxLayer:refreshData()
	self.data = ex.Player.promotion_data:getCommonActivityDataForID(self.id_for_server)

	self.ext_info = ex.Player.promotion_data:getCommonActivityExtInfoTable(self.id_for_server)
end

function LTAMysteryBoxLayer:refreshTabelData()
	self.data_table = self:generateData(self.data.turns, self.ext_info.curr_day)
end

function LTAMysteryBoxLayer:generateData(turns, day)
	local getData = function(idx)
		for i,v in ipairs(self.data.list) do
			if v.idx == idx then
				return v
			end
		end
		return {idx = idx, progress = 0, is_got = false, ext_info = ""}	-- 没有数据就返回默认的。
	end

	local result = {}
	for i,v in ipairs(cfg.promotionmysterybox.promotionmysterybox) do
		if v.turns == turns and v.day == day then
			local d = getData(v.idx)
			local tab = result[#result]
			if tab == nil or #tab >= 3 then
				tab = {}
				table.insert(result, tab)
			end

			table.insert(tab, {data = d,config = v})
		end
	end

	return result
end

function LTAMysteryBoxLayer:cellSizeForTable(view, idx)
	return 620, 230 + 4
end

function LTAMysteryBoxLayer:tableCellAtIndex(view, idx)
	local cell = view:dequeueCell()
    local task_cell = nil
    if cell == nil then
        cell = cc.TableViewCell:create()
    else
        cell:removeAllChildren()
	end
	   
	task_cell = LTAMysteryBoxCell:createWithCCBIFile("ccbi/LTAMysteryBoxCell.ccbi")
	task_cell:setAnchorPoint(0, 0)
	task_cell:setPosition(0, 4)
	task_cell:setName("task_cell")
	task_cell:setIsTouchInsideNode(view)
	cell:addChild(task_cell)

    cell:setLocalZOrder(idx * 10)
    
    local data = self.data_table[idx + 1]
    task_cell:initDone(data)

    return cell
end

function LTAMysteryBoxLayer:numberOfCellsInTableView(view)
	return #self.data_table
end

function LTAMysteryBoxLayer:onEvent(event, ui_event)
	self:refreshData()

	if ui_event == EVENT.UI.REFRESH_ALL then
		self:refreshTabelData()

		self:refreshBanner()

		if self.table_view ~= nil then
			self.table_view:reloadData()
		end
	elseif ui_event == EVENT.UI.REFRESH_RECHARGE or ui_event == EVENT.UI.REFRESH_BANNER then
		self:refreshBanner()
	end
end


return LTAMysteryBoxLayer