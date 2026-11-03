local FloatingIslandsRewardCtr = class("FloatingIslandsRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local FloatingIslandsRewardLayer = class("FloatingIslandsRewardLayer", require("src.comp.EventLayerAdaptiveWidth"))
local FloatingIslandsRewardCell = class("FloatingIslandsRewardCell", require("src.comp.LuaLayerBase"))
local UIMenuItenBackpack = require("src.comp.menu.UIMenuItemBackpack")

function FloatingIslandsRewardCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.lbl_my_rank:setVisible(false)
	self.lbl_my_rank_tip:setVisible(false)

	self.scroll_view:setItemSize(cc.size(90, 80))
	self.scroll_view:setSwallowsTouches(false)
end

function FloatingIslandsRewardCell:initData(data)
	if data == nil then
		self.spr_rank:setVisible(false)
		self.lbl_rank:setVisible(false)
		self.lbl_my_rank_tip:setVisible(false)
		return
	end

	local config = data
	local str_rank = tostring(config.rank_up)
	if config.rank_down ~= config.rank_up then
		str_rank = tostring(config.rank_up) ..  (config.rank_down > 10000 and ex.Tools:getLang(75414) or ("-" .. tostring(config.rank_down))) 
	end

	self.spr_rank:setVisible(false)
	self.lbl_rank:setVisible(true)
	if config.rank_up > 0 and config.rank_up < 4 then 
		self.spr_rank:setVisible(true)
		self.lbl_rank:setVisible(false)
		-- self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png",config.rank_up))
		ex.Tools:setSpriteFrame(self.spr_rank, string.format("rank/spr-paihang-%s.png",config.rank_up))
	end

	self.lbl_rank:setString(str_rank)

	self.scroll_view.createItemFunction = function(data, scale)
		local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
		item:setScale(0.75)
		item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
		return item
	end
	self.scroll_view:reloadData(config.reward)

	-- for i,v in ipairs(config.reward) do
	-- 	local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
	-- 	item:registerScriptTapHandler(handler(self, self.onTouchItemInfo))
	-- 	item:setPosition(450 - 90 * (i - 1), 50)
	-- 	item:setScale(0.75)
	-- 	self.menu:addChild(item)
	-- end
end

function FloatingIslandsRewardCell:onTouchItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function FloatingIslandsRewardCell:setMyRank(rank)
	self.spr_rank:setVisible(false)
	self.lbl_rank:setVisible(false)

	self.lbl_my_rank:setVisible(true)
	self.lbl_my_rank_tip:setVisible(true)

	self.lbl_my_rank:setString(ex.Tools:getLang(47055)..rank)
end

function FloatingIslandsRewardLayer:onCreate()
	self:addBlackBackground()

	self.cell_self = FloatingIslandsRewardCell:createWithCCBIFile("ccbi/FloatingIslandsRewardCell.ccbi")
	self.cell_self:setPosition(self:getContentSize().width / 2 - self.cell_self:getContentSize().width / 2,
		self.spr_my_bg:getPositionY() + 7.5)
	self:addChild(self.cell_self)

	-- self:reorderChild(self.spr_ribbon, 50)

	self.table_view = cc.TableView:create(cc.size(self.spr_rank_bg:getContentSize().width - 10, self.spr_rank_bg:getContentSize().height - 60))
	self.table_view:setAnchorPoint(cc.p(0,0))
    self.table_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.table_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	self.table_view:setBounceable(false)
    self.table_view:setDelegate()
    self.table_view:setDataSource()

    self:addChild(self.table_view)
    self.table_view:setPosition(cc.p(self.spr_rank_bg:getPositionX() + 5, self.spr_rank_bg:getPositionY() + 5))

    local reward_ctr = FloatingIslandsRewardCtr:instance()
	self.table_view:registerScriptHandler(handler(reward_ctr, reward_ctr.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL) --滚动时的回掉函数
    self.table_view:registerScriptHandler(handler(reward_ctr, reward_ctr.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX) --列表项的尺寸
    self.table_view:registerScriptHandler(handler(reward_ctr, reward_ctr.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX) --创建列表项
    self.table_view:registerScriptHandler(handler(reward_ctr, reward_ctr.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW) --列表项的数量
	self.table_view:registerScriptHandler(handler(reward_ctr, reward_ctr.tableCellTouched), cc.TABLECELL_TOUCHED) --列表项被点击
end

-----------------------------------------------------------------------------

function FloatingIslandsRewardCtr:onCreate()
	self:setCCBIPath("ccbi/FloatingIslandsRewardLayer.ccbi")
	self:setIsSingle(false)
end

function FloatingIslandsRewardCtr:getLayerClass()
	return FloatingIslandsRewardLayer
end

function FloatingIslandsRewardCtr:getFloatingIslandsRewardLayer()
	return self.layer
end

function FloatingIslandsRewardCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData()
end

function FloatingIslandsRewardCtr:initData()
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self:updateLayer()
end

function FloatingIslandsRewardCtr:updateLayer()
	if not self:getLayer() then
		return
	end

	self:updateTableView()
end

function FloatingIslandsRewardCtr:updateTableView()
	self.layer.list_count = table.nums(cfg.floatingislandsrankreward.floatingislandsrankreward)

	local cell_data = {}
	cell_data = {}
	cell_data["cell_class"] = FloatingIslandsRewardCell
	cell_data["file"] = "ccbi/FloatingIslandsRewardCell.ccbi"
	cell_data["data"] = cfg.floatingislandsrankreward.floatingislandsrankreward
	self.layer.cell_data = cell_data
	self.layer.table_view:reloadData()

	local rank = ex.Player.rank_data.rank_floating_islands_self.rank
	if rank == nil then
		-- return
		rank = 0
	end

	local data = nil
    for i,v in ipairs(cfg.floatingislandsrankreward.floatingislandsrankreward) do
        if v.rank_up <= rank and rank <= v.rank_down then 
            data = v 
        end 
	end
	
	self.layer.cell_self:initData(data)
	if data ~= nil then
		self.layer.cell_self:setMyRank(rank)
	else
		self.layer.cell_self.lbl_rank:setVisible(true)
	end
	self.layer.cell_self.lbl_rank:setString(rank <= 0 and ex.Tools:getLang(47749) or rank)
end

function FloatingIslandsRewardCtr:scrollViewDidScroll(view)

end

function FloatingIslandsRewardCtr:cellSizeForTable(view, idx)
	return 480, 105
end

function FloatingIslandsRewardCtr:numberOfCellsInTableView(view)
    return self.layer.list_count
end

function FloatingIslandsRewardCtr:tableCellAtIndex(view, idx)
	local cell = cc.TableViewCell:create()
	local layer = self.layer
	local cell_layer = layer.cell_data["cell_class"]:createWithCCBIFile(layer.cell_data["file"])
	if cell_layer then
		cell_layer:initData(layer.cell_data["data"][idx + 1])
		cell_layer:setPosition(view:getViewSize().width * 0.5 - cell_layer:getContentSize().width * 0.5, 0)
		if cell_layer.menu then
			cell_layer.menu:setIsTouchInsideNode(view)
		end
		cell:addChild(cell_layer)
	end
	return cell
end

function FloatingIslandsRewardCtr:tableCellTouched(view, cell)

end

return FloatingIslandsRewardCtr
