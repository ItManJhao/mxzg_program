local LadderRewardCtr = class("LadderRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local LadderRewardLayer = class("LadderRewardLayer", require("src.comp.EventLayerAdaptiveWidth"))
local LadderRewardCell = class("LadderRewardCell", require("src.comp.LuaLayerBase"))
local UIMenuItenBackpack = require("src.comp.menu.UIMenuItemBackpack")

function LadderRewardCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.lbl_my_rank:setVisible(false)
	self.lbl_my_rank_tip:setVisible(false)
end

function LadderRewardCell:initData(data)
	if data == nil then
		self.spr_rank:setVisible(false)
		self.lbl_rank:setVisible(false)
		self.lbl_my_rank_tip:setVisible(false)
		return
	end

	local config = data
	local str_rank = tostring(config.rank_up)
	if config.rank_low ~= config.rank_up then
		str_rank = tostring(config.rank_low) .. "-" .. tostring(config.rank_up)
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

	for i,v in ipairs(config.rank_reward) do
		local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
		item:registerScriptTapHandler(handler(self, self.onTouchItemInfo))
		item:setPosition(450 - 90 * (i - 1), 50)
		item:setScale(0.75)
		self.menu:addChild(item)
	end
end

function LadderRewardCell:onTouchItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function LadderRewardCell:setMyRank(rank)
	self.spr_rank:setVisible(false)
	self.lbl_rank:setVisible(false)

	self.lbl_my_rank:setVisible(true)
	self.lbl_my_rank_tip:setVisible(true)

	self.lbl_my_rank:setString(ex.Tools:getLang(47055)..rank)
end

function LadderRewardLayer:onCreate()
	self:addBlackBackground()

	-- local last_content_size = self:getContentSize()
	-- local cur_content_size = cc.size(ex.p.width - 20, last_content_size.height)
	-- local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

	-- self:setContentSize(cur_content_size)
	-- self:setPosition(ex.p.width / 2 - self:getContentSize().width / 2, ex.p.height / 2 - self:getContentSize().height / 2 + 20)

	-- self.spr_bg:setContentSize(cc.size(cur_content_size.width + 20, cur_content_size.height + 20))
	-- self.btn_close:setPosition(cur_content_size.width - 40, cur_content_size.height - 25)

	-- self.lbl_title_bg:setPosition(self.lbl_title_bg:getPositionX() + offset.x / 2, self.lbl_title_bg:getPositionY() + offset.y)
	-- self.lbl_title:setPosition(self.lbl_title:getPositionX() + offset.x / 2, self.lbl_title:getPositionY() + offset.y)

	-- self.spr_ribbon:setPosition(self.spr_ribbon:getPositionX() + offset.x / 2, self.spr_ribbon:getPositionY())
	-- self.spr_my_bg:setPosition(self.spr_my_bg:getPositionX() + offset.x / 2, self.spr_my_bg:getPositionY())
	-- self.spr_rank_bg:setPosition(self.spr_rank_bg:getPositionX() + offset.x / 2, self.spr_rank_bg:getPositionY())

	self.cell_self = LadderRewardCell:createWithCCBIFile("ccbi/LadderRewardCell.ccbi")
	self.cell_self:setPosition(self:getContentSize().width / 2 - self.cell_self:getContentSize().width / 2,
		90 - self.cell_self:getContentSize().height / 2)
	self:addChild(self.cell_self)

	self:reorderChild(self.spr_ribbon, 50)

	self.table_view = cc.TableView:create(cc.size(self.spr_rank_bg:getContentSize().width - 10, self.spr_rank_bg:getContentSize().height - 10))
	self.table_view:setAnchorPoint(cc.p(0,0))
    self.table_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.table_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	self.table_view:setBounceable(false)
    self.table_view:setDelegate()
    self.table_view:setDataSource()

    self:addChild(self.table_view)
    self.table_view:setPosition(cc.p(self.spr_rank_bg:getPositionX() + 5, self.spr_rank_bg:getPositionY() + 5))

    local reward_ctr = LadderRewardCtr:instance()
	self.table_view:registerScriptHandler(handler(reward_ctr, reward_ctr.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL) --滚动时的回掉函数
    self.table_view:registerScriptHandler(handler(reward_ctr, reward_ctr.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX) --列表项的尺寸
    self.table_view:registerScriptHandler(handler(reward_ctr, reward_ctr.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX) --创建列表项
    self.table_view:registerScriptHandler(handler(reward_ctr, reward_ctr.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW) --列表项的数量
	self.table_view:registerScriptHandler(handler(reward_ctr, reward_ctr.tableCellTouched), cc.TABLECELL_TOUCHED) --列表项被点击
end

-----------------------------------------------------------------------------

function LadderRewardCtr:onCreate()
	self:setCCBIPath("ccbi/LadderRewardLayer.ccbi")
	self:setIsSingle(false)
end

function LadderRewardCtr:getLayerClass()
	return LadderRewardLayer
end

function LadderRewardCtr:getLadderRewardLayer()
	return self.layer
end

function LadderRewardCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData()
end

function LadderRewardCtr:initData()
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self:updateLayer()
end

function LadderRewardCtr:updateLayer()
	if not self:getLayer() then
		return
	end

	self:updateTableView()
end

function LadderRewardCtr:updateTableView()
	self.layer.list_count = table.nums(cfg.serverladderrankreward.reward)

	local cell_data = {}
	cell_data = {}
	cell_data["cell_class"] = LadderRewardCell
	cell_data["file"] = "ccbi/PvpRewardCell.ccbi"
	cell_data["data"] = cfg.serverladderrankreward.reward
	self.layer.cell_data = cell_data
	self.layer.table_view:reloadData()

	local rank = ex.Player.rank_data.rank_ladder_self.rank
	if rank == nil then
		return
	end

	local data = ex.Player.league_data:getRankRewardConfigByRank(rank)
	self.layer.cell_self:initData(data)
	if data ~= nil then
		self.layer.cell_self:setMyRank(rank)
	else
		self.layer.cell_self.lbl_rank:setVisible(true)
	end
	self.layer.cell_self.lbl_rank:setString(rank <= 0 and ex.Tools:getLang(47749) or rank)
end

function LadderRewardCtr:scrollViewDidScroll(view)

end

function LadderRewardCtr:cellSizeForTable(view, idx)
	return 480, 105
end

function LadderRewardCtr:numberOfCellsInTableView(view)
    return self.layer.list_count
end

function LadderRewardCtr:tableCellAtIndex(view, idx)
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

function LadderRewardCtr:tableCellTouched(view, cell)

end

return LadderRewardCtr
