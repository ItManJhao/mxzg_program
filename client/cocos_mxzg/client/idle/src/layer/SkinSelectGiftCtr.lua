--[[
    func: 自选皮肤 通用界面
    author:熊梦
    time:2020-09-27 17:17:17
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local SkinSelectGiftCtr = class("SkinSelectGiftCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SkinSelectGiftLayer = class("SkinSelectGiftLayer", require("src.comp.EventLayerAdaptiveWidth"))
local SelfSelectGiftCell = class("SelfSelectGiftCell", require("src.comp.LuaLayerBase"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function SelfSelectGiftCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.data = nil
	self.callback = nil
	self.item = nil

	self.btn_slt:registerScriptTapHandler(handler(self, self.onSelect))
	self.btn_slt:setPositionX(self.btn_slt:getPositionX()+40)
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
		self.item = ex.Tools:createBackpackItem(self.data.item_type, self.data.item_num)
		self.item:setPosition(100, 64)
		self.item:setScale(1)
		self.item:registerScriptTapHandler(handler(self, self.onClick))
		self.item:setLocalZOrder(10)
		self.menu:addChild(self.item)
			
		local item_config = cfg.item.item[tonumber(self.data.item_type)] or "-"
		self.name:setString(ex.Tools:getLang(item_config.name).."*"..tostring(self.data.item_num))
		ex.Tools:setLimitWidth(self.name, self:getContentSize().width/2.2)
	end

	if self.data.is_owned then
		local file = "prom-zhongqiu-2/spr-skin-jiaobiao.png"
		local sprite = cc.Sprite:createWithSpriteFrameName(file)
		sprite:setPosition(120,100)
		self:addChild(sprite)

		local label = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 28)
		:setScale(0.5)
		:setAnchorPoint(cc.p(0.5,0.5))
		:setPosition(30,18)
		:enableOutline(cc.c4b(119,63,26,255), 2)
		:setString(ex.Tools:getLang(91539))
		:setTextColor(cc.c3b(253,243,220))
		sprite:addChild(label)

		self.btn_slt:setVisible(false)
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
function SkinSelectGiftLayer:onCreate()
	-- self:setAutoClose(false)
	-- self:setSwallowTouches(false)
	
	self:addBlackBackground()

	local sfc = cc.SpriteFrameCache:getInstance() 
	sfc:addSpriteFrames("ccbi-res/prom-zhongqiu-2.plist")
	
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

function SkinSelectGiftLayer:init(config_table)
	self.config_table = config_table

	self.table_view:reloadData()
end

function SkinSelectGiftLayer:cellSizeForTable(view, idx)
	return 546, 128 + 4
end

function SkinSelectGiftLayer:tableCellAtIndex(view, idx)
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

function SkinSelectGiftLayer:numberOfCellsInTableView(view)
	return #self.config_table
end

function SkinSelectGiftLayer:onSelectHandler(idx)
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
function SkinSelectGiftCtr:onCreate()
	self:setCCBIPath("ccbi/SkinSelectGiftLayer.ccbi")
    self:setIsSingle(false)
end

function SkinSelectGiftCtr:getLayerClass()
	return SkinSelectGiftLayer
end

function SkinSelectGiftCtr:openWindow(reward,skin_list)
	-- reward ： 奖励的皮肤列表
	-- 	idx  皮肤唯一标识
	--	is_owned  是否已经拥有皮肤
	--  item_type 皮肤道具id
	-- item_num 皮肤数量
	if self:isOpened() then
		return
    end

    self.reward = reward

	self:loadLayer()
	self:open()
	self:initDone()
end

function SkinSelectGiftCtr:initDone()

	local config_table = self.reward

	table.sort(config_table, function(a, b)
		return a.idx < b.idx
	end)

	self.layer:init(config_table)

	self.layer.btn_do:registerScriptTapHandler(handler(self, self.onConfirm))
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end

function SkinSelectGiftCtr:onConfirm(tag,pSender)

	if self.layer.select_idx ~= 0 then
		local req = Promotion076_pb.GReqMidFashionExchangeFashion()
		req.idx = self.layer.select_idx
		NetManager:sendMessage(ProtocolID.GReqMidFashionExchangeFashion, req)
	end
	
	self:closeWindow()
end

return SkinSelectGiftCtr
