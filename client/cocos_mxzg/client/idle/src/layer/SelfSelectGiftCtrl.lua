--[[
    func: 自选礼包选择界面
    author:徐东浩
    time:2019-11-13 14:59:17
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local SelfSelectGiftCtrl = class("SelfSelectGiftCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SelfSelectGiftLayer = class("SelfSelectGiftLayer", require("src.comp.EventLayerAdaptiveWidth"))
local SelfSelectGiftCell = class("SelfSelectGiftCell", require("src.comp.LuaLayerBase"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function SelfSelectGiftCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.data = nil
	self.callback = nil
	self.item = nil

	self.btn_slt:registerScriptTapHandler(handler(self, self.onSelect))
end

function SelfSelectGiftCell:initDone(data, callback, is_select)
	local is_new = self.data ~= data

	self.data = data
	self.callback = callback

	if is_new then
		if self.item ~= nil then
			self.item:removeFromParent()
		end
		self.item = nil

		local prop_type = ex.Player.backpack_data:getPropType(self.data.reward[1].item_type)
		if prop_type == ItemData.IT_HERO or prop_type == ItemData.IT_HERO_MATERIAL then
			local item_type = self.data.reward[1].item_type
			local hero_type = prop_type == ItemData.IT_HERO and item_type or cfg.item.item[item_type].use_value
			local hero_info = cfg.herotype.star[hero_type]
			local hero_star = prop_type == ItemData.IT_HERO and hero_info.star or cfg.item.item[item_type].star
			if hero_info ~= nil then
				self.item = UIMenuItemHero:createWithData(nil , hero_info.type, hero_info.elem, self.data.reward[1].item_num, hero_star, nil)
				-- self.item:initSelectItem(hero_info)
				self.item:setScale(1)
				self.menu:addChild(self.item)
				self.item.data = data
				self.item:setPosition(100, 64)
				self.item:registerScriptTapHandler(handler(self, self.onClick))
				
				self.item:setRedPoint(false)
				if hero_info.type == 0 then self.item:setAllIcon() end
			end
		else
			self.item = ex.Tools:createBackpackItem(self.data.reward[1].item_type, self.data.reward[1].item_num)
			self.item:setPosition(100, 64)
			self.item:setScale(1)
			self.item:registerScriptTapHandler(handler(self, self.onClick))
			self.item:setLocalZOrder(10)
			self.menu:addChild(self.item)
		end
			
		local item_config = cfg.item.item[tonumber(self.data.reward[1].item_type)] or "-"
		self.name:setString(ex.Tools:getLang(item_config.name).."*"..tostring(self.data.reward[1].item_num))
		ex.Tools:setLimitWidth(self.name, self:getContentSize().width/2.2)
	end

	self.btn_slt:setChecked(is_select)
end

function SelfSelectGiftCell:onSelect(tag, pSender)
	if self.callback ~= nil then
		self.callback(self.data.idx)
	end
end

function SelfSelectGiftCell:onClick(tag, pSender)
    if pSender.item_type ~= nil then
		ex.Tools:onClickItemInfo(pSender.item_type)
	else
		print("SelfSelectGiftCell:onClick no handle!")
	end
end

-----------------------------------------------------------------------------
function SelfSelectGiftLayer:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	
	self:addBlackBackground()
	
	self.select_idx = 0
	self.config_table = {}

	self.btn_do:setLabelText(ex.Tools:getLang(2401))

	-- 创建tableview
	local bg_size = self.table_view_bg:getPreferredSize()
	self.table_view = cpp.UITableViewEx:create(cc.size(bg_size.width - 14, bg_size.height - 14))
	self.table_view:setAnchorPoint(cc.p(0,0))
	self.table_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self.table_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	self.table_view:setBounceable(false)
	self.table_view:setDelegate()
	self.table_view:setDataSource()
	self.table_view:setPosition(cc.p(7, 7))
	self.table_view_bg:addChild(self.table_view)

	self.table_view:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX) --列表项的尺寸
	self.table_view:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX) --创建列表项
	self.table_view:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW) --列表项的数量
end

function SelfSelectGiftLayer:init(config_table)
	self.config_table = config_table

	self.table_view:reloadData()
end

function SelfSelectGiftLayer:cellSizeForTable(view, idx)
	return 546, 128 + 4
end

function SelfSelectGiftLayer:tableCellAtIndex(view, idx)
	local cell = view:dequeueCell()
	local task_cell = nil
	if cell == nil then
        cell = cc.TableViewCell:create()
    else
        cell:removeAllChildren()
	end
	
	task_cell = SelfSelectGiftCell:createWithCCBIFile("ccbi/SelfSelectGiftCell.ccbi")
	task_cell:setAnchorPoint(0, 0)
	task_cell:setPosition(0, 4)
	task_cell:setName("task_cell")
	cell:addChild(task_cell)

    cell:setLocalZOrder(idx * 10)
    
    local data = self.config_table[idx + 1]
    task_cell:initDone(data, handler(self, self.onSelectHandler), self.select_idx == data.idx)

    return cell
end

function SelfSelectGiftLayer:numberOfCellsInTableView(view)
	return #self.config_table
end

function SelfSelectGiftLayer:onSelectHandler(idx)
	if idx == self.select_idx then
		self.select_idx = 0
	else
		self.select_idx = idx
	end

	local offset_x, offset_y = self.table_view:getContentOffset()
	self.table_view:reloadData()
	self.table_view:setContentOffset(cc.p(offset_x, offset_y))
end

-----------------------------------------------------------------------------
function SelfSelectGiftCtrl:onCreate()
	self:setCCBIPath("ccbi/SelfSelectGiftLayer.ccbi")
    self:setIsSingle(false)
end

function SelfSelectGiftCtrl:getLayerClass()
	return SelfSelectGiftLayer
end

function SelfSelectGiftCtrl:openWindow(prop_type)
	if self:isOpened() then
		return
    end

    self.item_type = prop_type

	self:loadLayer()
	self:open()
	self:initDone()
end

function SelfSelectGiftCtrl:initDone()
	local config = cfg.item.item[self.item_type]

	if not config then
		return
    end
    
	local config_table = {}
	for k,v in pairs(cfg.selfselectgift.selfselectgift) do
		if config.use_value == v.type then
			table.insert(config_table, v)
		end
	end

	table.sort(config_table, function(a, b)
		return a.idx < b.idx
	end)

	self.layer:init(config_table)

	self.layer.btn_do:registerScriptTapHandler(handler(self, self.onConfirm))
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end

function SelfSelectGiftCtrl:onConfirm(tag,pSender)
	if self.item_type == 0 or self.layer.select_idx == 0 then
		ex.MessageView:add(ex.Tools:getLang(41158))
		return
	end

	local config = nil
	for k,v in pairs(cfg.selfselectgift.selfselectgift) do
		if v.idx == self.layer.select_idx then
			config = v
		end
	end
	if config == nil then
		return
	end

	local req = BackPack_pb.GReqSelfSelectGift()
	req.idx = self.layer.select_idx
	req.item_id = self.item_type
	req.item_type = config.reward[1].item_type
	NetManager:sendMessage(ProtocolID.GReqSelfSelectGift, req)

	self:closeWindow()
end

return SelfSelectGiftCtrl
