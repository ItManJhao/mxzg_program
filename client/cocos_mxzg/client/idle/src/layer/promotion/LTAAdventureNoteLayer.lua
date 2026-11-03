local LTAAdventureNoteLayer = class("LTAAdventureNoteLayer", require("src.comp.EventLayer"))
local LTAAdventureNoteCell = class("LTAAdventureNoteCell", require("src.comp.LuaLayerBase"))
local CommonUIHelper = require("src.layer.promotion.CommonUIHelper")

function LTAAdventureNoteCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.data = {}

	self.title = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(46)
	:setScale(0.5)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#613c19")
	:setAnchorTextShadow(false)
	:setAnchorPoint(ex.a.left_center)
    :setPosition(cc.p(15, 125))
    :setLocalZOrder(10)
    self:addChild(self.title)
    
	self.btn_do:registerScriptTapHandler(handler(self, self.onBtnClick))
end

function LTAAdventureNoteCell:initDone(data)
	self.data = data

	self.num_lab:setString("("..self.data.data.progress.."/"..self.data.config.mission.target..")")

	self.title:setXmlTextLua(ex.Tools:taskString(self.data.config.lang, self.data.config.mission.target, self.data.config.mission.condition, self.data.config.mission.subCondition))

	self.lbl_reward_1:setString(ex.StringUtil.getScientificNumber(self.data.config.exp))

	self.btn_do:setVisible(not self.data.data.is_got)
	self.spr_got:setVisible(self.data.data.is_got)
	ex.Tools:addRedPoint(self.btn_do, false)
	if not self.data.data.is_got then
		if self.data.config.jump_info.event_type == 1 and self.data.data.progress < self.data.config.mission.target then
			self.btn_do:setLabelText(ex.Tools:getLang(2702))
		else
			self.btn_do:setLabelText(ex.Tools:getLang(2214))
		end

		if self.data.data.progress >= self.data.config.mission.target then
			ex.Tools:addRedPoint(self.btn_do, true)
		end
	end
end

function LTAAdventureNoteCell:setIsTouchInsideNode(scroll_view)
	if scroll_view == nil then
		return
	end

	self.menu:setIsTouchInsideNode(scroll_view)
end

function LTAAdventureNoteCell:onBtnClick(tag, pSender)
	if self.data.data.progress < self.data.config.mission.target then
		if self.data.config.jump_info.event_type == 1 then
			CommonUIHelper:onEventDispatcher(self.data.config.jump_info.event_type, self.data.config.jump_info.event_arg)
		else
			ex.MessageView:add(ex.Tools:getLang(self.data.config.jump_info.no_jump_hint))
		end
	else
		local req_get = Task4_pb.GReqAdventureNoteGet()
		req_get.idx = self.data.config.idx
		NetManager:sendMessage(ProtocolID.GReqAdventureNoteGet, req_get)
	end
end


-----------------------------------------------------------------------
function LTAAdventureNoteLayer:onCreateDone()
	self.super.onCreate(self)
	self:setName("LTAAdventureNoteLayer")

	self:setAutoClose(false)
	self:setSwallowTouches(false)
	
	self.id_for_server = 29
	self.promotion_idx = 421
	self.table_view_h_mergin = 8
	self.timer_name = "pro_adv_note_timer"
	
	-- 准备数据
	self.data = {}
	self.ext_info = {}
	self:refreshData()
	self.data_table = {}
	self:refreshTabelData()

	self.lv_item_temp = {}
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
	local banner_height = self.layer_promotion:getTopY() - banner_size.height * self.global_scale
	self.banner:setPosition(cc.p(0, banner_height))

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
	
	-- 创建tableview
	self.table_view = cpp.UITableViewEx:create(cc.size(640 - self.table_view_h_mergin * 2, (banner_height - 2 - self.layer_promotion:getBottomY()) / self.global_scale))
	self.table_view:setAnchorPoint(cc.p(0,0))
	self.table_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self.table_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	self.table_view:setBounceable(false)
	self.table_view:setDelegate()
	self.table_view:setDataSource()
	self.table_view:setScale(self.global_scale)
	self.table_view:setPosition(cc.p(self.table_view_h_mergin, self.layer_promotion:getBottomY()))
	self:addChild(self.table_view)
	
	-- self.table_view:registerScriptHandler(handler(self, self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL) --滚动时的回掉函数
	self.table_view:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX) --列表项的尺寸
	self.table_view:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX) --创建列表项
	self.table_view:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW) --列表项的数量
	-- self.table_view:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED) --列表项被点击

	local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_promotion_5")
	spr_effect:setPosition(self.btn_level_reward:getContentSize().width / 2, self.btn_level_reward:getContentSize().height / 2)
	self.btn_level_reward:addChild(spr_effect, 10)
	
	self:addEvent(EVENT.MAIN_CITY_PROMOTION.ADVENTURE_NOTE, handler(self, self.onEvent))

	self:addTimer(self.timer_name, 1000, handler(self, self.updateCDTime), true)

	self.table_view:reloadData()

	self:refreshBanner()

    self:updateCDTime()
end

function LTAAdventureNoteLayer:updateCDTime()
    local remain_time = self.data.end_time - ex.Game:getServerTime()

	if ex.Game:getServerTime()  <  self.data.start_time then 
		self.lbl_time:setXmlTextLua(ex.Tools:getLang(41052));
		return 
	end 

	if remain_time < 0 then 
        self.lbl_time:setXmlTextLua(ex.Tools:getLang(41053));
        
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

function LTAAdventureNoteLayer:updateProgress(value, total_value)
	total_value = total_value == 0 and 1 or total_value
	local percent = math.min(value / total_value, 1) * 100
    self.progress_timer:setPercentage(percent)
end

function LTAAdventureNoteLayer:refreshExpStatus()
    if self.ext_info == nil or self.ext_info.exp == nil then
        return
	end
	-- local sfc = cc.SpriteFrameCache:getInstance()
	-- sfc:addSpriteFrames("ccbi-res/promotion.plist")

	local can_get, level, config = ex.Player.promotion_data:getConfigExpLevelForAdvNote(self.ext_info.exp)
	
	ex.Tools:addRedPoint(self.btn_level_reward, can_get)

	self.spr_level:setString(tostring(level or 0))
	-- self.spr_level:setString(0)
    -- ex.Tools:setSpriteFrame(self.spr_level, string.format("promotion/spr-number-%d.png", level or 0))
    
    self:updateProgress(self.ext_info.exp, config ~= nil and config.exp_need or 0)
    
    self.lbl_progress:setString(tostring(self.ext_info.exp).."/"..tostring(config ~= nil and config.exp_need or 0))
    
	for i,v in ipairs(self.lv_item_temp) do
		v:removeFromParent()
	end
	self.lv_item_temp = {}

	local scale = 0.6
	if config ~= nil then
		for i,v in ipairs(config.reward) do
			local node_name = "node_next_reward_"..i

			local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
			item:setPosition(self[node_name]:getPosition())
			item:setScale(scale)
			item:registerScriptTapHandler(handler(self, self.onClick))
			item:setLocalZOrder(i * 10)
			self.menu:addChild(item)
			table.insert(self.lv_item_temp, item)
		end
	end
end

function LTAAdventureNoteLayer:refreshRechargeStatus()
    local can_get, is_got, config = ex.Player.promotion_data:getConfigRechargeForAdvNote()
	
    self.title:setString(string.format(ex.Tools:getLang(52503), config ~= nil and (config.recharge_need / 100) or 0))
    self.num_lab:setString("("..(self.ext_info.total_recharge / 100).."/"..(config ~= nil and (config.recharge_need / 100) or 0)..")")

	ex.Tools:addRedPoint(self.btn_do, can_get)
    if not is_got then
        self.btn_do:setLabelText(ex.Tools:getLang(2214))
    end
    self.btn_do:setVisible(not is_got)
	self.spr_got:setVisible(is_got)
	
	for i,v in ipairs(self.item_temp) do
		v:removeFromParent()
	end
	self.item_temp = {}

    local begin = 24
    local margin = 5
    local posY = 58
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

function LTAAdventureNoteLayer:refreshBanner()
    self:refreshExpStatus()
    
    self:refreshRechargeStatus()
end

function LTAAdventureNoteLayer:onClick(tag, pSender)
    if pSender == self.btn_do then
        local _, is_got, config = ex.Player.promotion_data:getConfigRechargeForAdvNote()
        if not is_got and config ~= nil and self.ext_info.total_recharge >= config.recharge_need then
            local req_get = Task4_pb.GReqAdventureNoteRechargeGet()
            req_get.idx = config.idx
            NetManager:sendMessage(ProtocolID.GReqAdventureNoteRechargeGet, req_get)
        else
			ex.MessageView:add(ex.Tools:getLang(52512))
        end
    elseif pSender == self.btn_level_reward then
		-- 打开窗口
		require("src.layer.promotion.LTAAdvNoteRewardCtrl"):instance():openLevelWindow()
    elseif pSender == self.btn_more then
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

function LTAAdventureNoteLayer:refreshData()
	self.data = ex.Player.promotion_data:getCommonActivityDataForID(self.id_for_server)

	self.ext_info = ex.Player.promotion_data:getCommonActivityExtInfoTable(self.id_for_server)
end

function LTAAdventureNoteLayer:refreshTabelData()
	self.data_table = self:generateData(self.data.turns, self.ext_info.curr_day)
end

function LTAAdventureNoteLayer:generateData(turns, day)
	local getData = function(idx)
		for i,v in ipairs(self.data.list) do
			if v.idx == idx then
				return v
			end
		end
		return {idx = idx, progress = 0, is_got = false, ext_info = ""}	-- 没有数据就返回默认的。
	end

	local result = {}
	for i,v in ipairs(cfg.promotionadventurenotes.promotionadventurenotes) do
		if v.turns == turns and v.day == day then
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

function LTAAdventureNoteLayer:cellSizeForTable(view, idx)
	return 620, 150 + 4
end

function LTAAdventureNoteLayer:tableCellAtIndex(view, idx)
	local cell = view:dequeueCell()
	local task_cell = nil
	if cell == nil then
        cell = cc.TableViewCell:create()
    else
        cell:removeAllChildren()
	end
	
	task_cell = LTAAdventureNoteCell:createWithCCBIFile("ccbi/LTAAdventureNoteCell.ccbi")
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

function LTAAdventureNoteLayer:numberOfCellsInTableView(view)
	return #self.data_table
end

function LTAAdventureNoteLayer:onEvent(event, ui_event)
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


return LTAAdventureNoteLayer