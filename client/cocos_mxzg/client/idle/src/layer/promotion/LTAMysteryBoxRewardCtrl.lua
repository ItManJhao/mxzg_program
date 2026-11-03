local LTAMysteryBoxRewardCtrl = class("LTAMysteryBoxRewardCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local LTAMysteryBoxRewardLayer = class("LTAMysteryBoxRewardLayer", require("src.comp.EventLayerAdaptiveWidth"))
local LTAMysteryBoxRewardCell = class("LTAMysteryBoxRewardCell", require("src.comp.LuaLayerBase"))

local MysteryBoxRewardContentType = {
	MBOX_EXP = 1,	-- 魔盒经验奖励
	RECHARGE = 2,	-- 充值奖励
}

function LTAMysteryBoxRewardCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.content_type = MysteryBoxRewardContentType.RECHARGE
	self.data = {}

	self.item_temp = {}

	self.title = cpp.RichTextEx:createWithXMLLua("")
	self.title:setFontSize(46)
	self.title:setScale(0.5)
	self.title:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.title:setFontColor("#613c19")
	self.title:setAnchorTextShadow(false)
	self.title:setAnchorPoint(ex.a.left_center)
    self.title:setPosition(cc.p(15, 125))
    self.title:setLocalZOrder(10)
    self:addChild(self.title)
    
	self.btn_do:registerScriptTapHandler(handler(self, self.onBtnClick))
end

function LTAMysteryBoxRewardCell:initDone(content_type, data)
	self.content_type = content_type
	self.data = data

	if self.content_type == MysteryBoxRewardContentType.MBOX_EXP then
		self.title:setXmlTextLua(string.format(ex.Tools:getLang(52608), tostring(data.value)))
	else
		self.title:setXmlTextLua(string.format(ex.Tools:getLang(52611), tostring(data.value / 100)))
	end

	self.btn_do:setVisible(not self.data.is_got)
	self.spr_got:setVisible(self.data.is_got)
	ex.Tools:addRedPoint(self.btn_do, self.data.can_get)
	if not self.data.is_got then
		self.btn_do:setLabelText(ex.Tools:getLang(2214))
	end

	for i,v in ipairs(self.item_temp) do
		v:removeFromParent(true)
	end
	self.item_temp = {}

	local begin = 24
    local margin = 5
    local posY = 58
    local scale = 0.75
    for i,v in ipairs(self.data.reward) do
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

function LTAMysteryBoxRewardCell:onBtnClick(tag, pSender)
	if not self.data.can_get then
		if self.content_type == MysteryBoxRewardContentType.MBOX_EXP then
			ex.MessageView:add(ex.Tools:getLang(52609))
		else
			ex.MessageView:add(ex.Tools:getLang(52612))
		end
	else
		if self.content_type == MysteryBoxRewardContentType.MBOX_EXP then
			local req_get = Task4_pb.GReqMysteryBoxExpGet()
			req_get.idx = self.data.idx
			NetManager:sendMessage(ProtocolID.GReqMysteryBoxExpGet, req_get)
		else
			local req_get = Task4_pb.GReqMysteryBoxRechargeGet()
			req_get.idx = self.data.idx
			NetManager:sendMessage(ProtocolID.GReqMysteryBoxRechargeGet, req_get)
		end
	end
end

function LTAMysteryBoxRewardCell:onClick(tag, pSender)
    if pSender.item_type ~= nil then
		ex.Tools:onClickItemInfo(pSender.item_type)
	else
		print("LTAMysteryBoxRewardCell:onClick no handle!")
	end
end

--------------------------------------------

function LTAMysteryBoxRewardLayer:onCreate()
    self:addBlackBackground()

	self.content_type = MysteryBoxRewardContentType.RECHARGE
	self.data_table = {}

    local content_size = self:getContentSize()
    self:setPosition(cc.p(ex.p.cx - content_size.width / 2, ex.p.cy - content_size.height / 2))

	-- 创建tableview
	self.table_view = cpp.UITableViewEx:create(self.table_view_layer:getContentSize())
	self.table_view:setAnchorPoint(cc.p(0,0))
	self.table_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self.table_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	self.table_view:setBounceable(false)
	self.table_view:setDelegate()
	self.table_view:setDataSource()
	self.table_view:setPosition(ex.p.zero)
	self.table_view_layer:addChild(self.table_view)

	self.table_view:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX) --列表项的尺寸
	self.table_view:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX) --创建列表项
	self.table_view:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW) --列表项的数量
end

function LTAMysteryBoxRewardLayer:refreshView(content_type, data_table)
	self.content_type = content_type
	self.data_table = data_table

	if self.content_type == MysteryBoxRewardContentType.MBOX_EXP then
		self.title:setString(ex.Tools:getLang(52607))
	else
		self.title:setString(ex.Tools:getLang(52610))
	end

    self.table_view:reloadData()
end

function LTAMysteryBoxRewardLayer:cellSizeForTable(view, idx)
	return 620, 150 + 4
end

function LTAMysteryBoxRewardLayer:tableCellAtIndex(view, idx)
	local cell = view:dequeueCell()
	local task_cell = nil
	if cell == nil then
        cell = cc.TableViewCell:create()
    else
        cell:removeAllChildren()
	end
	
	task_cell = LTAMysteryBoxRewardCell:createWithCCBIFile("ccbi/LTAMysteryBoxRewardCell.ccbi")
	task_cell:setAnchorPoint(0, 0)
	task_cell:setPosition(0, 4)
	task_cell:setName("task_cell")
	cell:addChild(task_cell)

    cell:setLocalZOrder(idx * 10)
    
    local data = self.data_table[idx + 1]
    task_cell:initDone(self.content_type, data)

    return cell
end

function LTAMysteryBoxRewardLayer:numberOfCellsInTableView(view)
	return #self.data_table
end

-----------------------------------------------------------------------------
function LTAMysteryBoxRewardCtrl:onCreate()
	self:setCCBIPath("ccbi/LTAMysteryBoxRewardLayer.ccbi")
    self:setIsSingle(false)
	
	self.id_for_server = 30

	self.content_type = MysteryBoxRewardContentType.RECHARGE
    self.data = {}
    self.ext_info = {}
    self.data_table = {}
end

function LTAMysteryBoxRewardCtrl:getLayerClass()
	return LTAMysteryBoxRewardLayer
end

function LTAMysteryBoxRewardCtrl:getLTAMysteryBoxRewardLayer()
	return self.layer
end

function LTAMysteryBoxRewardCtrl:openLevelWindow()
	if self:isOpened() then
		return
	end
	
	self.content_type = MysteryBoxRewardContentType.MBOX_EXP

	self:_openWindow()
end

function LTAMysteryBoxRewardCtrl:openRechargeWindow()
	if self:isOpened() then
		return
	end
	
	self.content_type = MysteryBoxRewardContentType.RECHARGE

	self:_openWindow()
end

function LTAMysteryBoxRewardCtrl:_openWindow()
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/promotion.plist")
	
    self:loadLayer()
    self:open()
    
	self:initData()
	
	self:updateView()

	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self.event_data = ex.EventManager:add(EVENT.MAIN_CITY_PROMOTION.MYSTERY_BOX, handler(self, self.onEvent))
end

function LTAMysteryBoxRewardCtrl:closeWindow()
	if self.event_data ~= nil then
		ex.EventManager:remove(self.event_data)
	end

	self:close()
end

function LTAMysteryBoxRewardCtrl:initData()
	self.data = {}
    self.ext_info = {}
	self.data_table = {}
	
    self.data = ex.Player.promotion_data:getCommonActivityDataForID(self.id_for_server)

    self.ext_info = ex.Player.promotion_data:getCommonActivityExtInfoTable(self.id_for_server)
	
	if self.content_type == MysteryBoxRewardContentType.MBOX_EXP then
		local isGot = function(idx)
			for i,v in ipairs(self.ext_info.lv_rewards) do
				if v == idx then  
					return true 
				end
			end
			return false
		end

		for i,v in ipairs(cfg.promotionmysteryboxlevelreward.promotionmysteryboxlevelreward) do
			if v.turns == self.data.turns then
				local isgot = isGot(v.level)
				local canget = not isgot and self.ext_info.exp >= v.exp_need
				table.insert(self.data_table, {is_got = isgot, can_get = canget, idx = v.level, value = v.exp_need, reward = v.reward})
			end
		end
	else
		local isGot = function(idx)
			for i,v in ipairs(self.ext_info.idx_recharge_reward) do
				if v == idx then  
					return true 
				end
			end
			return false
		end

		for i,v in ipairs(cfg.promotionmysteryboxrechargereward.promotionmysteryboxrechargereward) do
			if v.turns == self.data.turns then
				local isgot = isGot(v.idx)
				local canget = not isgot and self.ext_info.total_recharge >= v.recharge_need
				table.insert(self.data_table, {is_got = isgot, can_get = canget, idx = v.idx, value = v.recharge_need, reward = v.reward})
			end
		end
	end

	table.sort(self.data_table, function(a, b)
		if a.is_got or b.is_got then      -- 有已领取的
			if a.is_got == b.is_got then return a.idx < b.idx end     -- 都领了排idx
			if a.is_got then return false end                              -- a领了，a在后
			return true                                                         -- 否则就是b领了，b在后
		else                            -- 都没有领取的
			if a.can_get or b.can_get then  -- 有可以领的
				if a.can_get == b.can_get then return a.idx < b.idx end -- 都可领排idx
				if a.can_get then return true end                       -- a可领，a在前
				return false                                            -- b可领，b在前
			else
				return a.idx < b.idx        -- 没有可领的排idx
			end
		end
	end)
end

function LTAMysteryBoxRewardCtrl:updateView()
    self.layer:refreshView(self.content_type, self.data_table)
end

function LTAMysteryBoxRewardCtrl:onEvent(event, ui_event)
	self:initData()
	
	self:updateView()
end

return LTAMysteryBoxRewardCtrl
