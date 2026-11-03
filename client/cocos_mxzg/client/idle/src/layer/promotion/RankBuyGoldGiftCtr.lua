
local RankBuyGoldGiftCtr = class("RankBuyGoldGiftCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local RankBuyGoldGiftLayer = class("RankBuyGoldGiftLayer", require("src.comp.EventLayer"))

local RewardCell = class("RewardCell", require("src.comp.LuaLayerBase"))
function RewardCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function RewardCell:initData(config)
	if not config then 
		self.spr_rank:setVisible(false)
		self.lbl_rank:setVisible(true)
		self.lbl_rank:setString(ex.Tools:getLang(47749))
		return 
	end 
	local str_rank = tostring(config.idx)
	if config.rank_low == config.rank_up then 
		str_rank = tostring(config.rank_low)
	else 
		str_rank = tostring(config.rank_low .."-"..config.rank_up)
	end 


	self.spr_rank:setVisible(false)
	self.lbl_rank:setVisible(true)
	if config.rank_low > 0 and config.rank_low < 4 then 
		self.spr_rank:setVisible(true)
		self.lbl_rank:setVisible(false)
		-- self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png",config.rank_low))
		ex.Tools:setSpriteFrame(self.spr_rank, string.format("rank/spr-paihang-%s.png",config.rank_low))
	end

	self.lbl_rank:setString(str_rank)

	for i,v in ipairs(config.reward) do
		local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
		item:setPosition(430 - 80 * (i - 1), 50)
		item:setScale(0.75)
		self.menu:addChild(item)
	end

end

------------------------------------------------



function RankBuyGoldGiftLayer:onCreate()
	self:addBlackBackground()

end

function RankBuyGoldGiftLayer:initDone()

	-- 处理数据
	-- 
    self.layer.cell_self = RewardCell:createWithCCBIFile("ccbi/PROMRewardCell.ccbi")
    self.layer.cell_self:setPosition(10, 5)
    self.layer.cell_self:setAnchorPoint(0, 0)
    self.layer.spr_rank_bg_self:addChild(self.layer.cell_self)

	local now_data = ex.Player.promotion_data:getPromotionBuyGoldDatas()
	self.show_list = {}
	--处理数据表
	for k,v in pairs(cfg.promotionbuygoldrank.promotionbuygoldrank) do
		if now_data.turns == v.turns then 
			table.insert( self.show_list, v )
		end 
	end
	
	local sort = function ( a,b )
		return a.rank_low < b.rank_low
	end
	table.sort( self.show_list, sort )
    local myRankIndex = 0
    for k,v in pairs(self.show_list) do
        local nowData = {}
        nowData.rank_low = v.rank_low
        nowData.reward = v.reward
        nowData.rank_up = v.rank_up

        if nowData.rank_low <= ex.Player.rank_data.rank_buy_gold_self.rank and ex.Player.rank_data.rank_buy_gold_self.rank <= v.rank_up then 
            myRankIndex = k
        end 
        --table.insert( self.deal_data, nowData )
    end

	local config = self.show_list[myRankIndex]
	if not config then
		self.layer.cell_self:initData(config)
	else 
		self.layer.cell_self:initData(config)
	end
	
	self:updateScroll()
end

function RankBuyGoldGiftLayer:updateScroll( )

	if self.layer.table_view ~= nil then
        self.layer.table_view:removeFromParent()
        self.layer.table_view = nil
	end
	


	self.layer.table_view = cpp.UITableViewEx:create(cc.size(self.layer.spr_rank_bg:getContentSize().width - 10, self.layer.spr_rank_bg:getContentSize().height - 55))
    self.layer.table_view:setPosition(self.layer.spr_rank_bg:getPositionX() + 10, self.layer.spr_rank_bg:getPositionY() + 5)
    self.layer.table_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.layer.table_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.layer.table_view:setBounceable(false)
    self.layer.table_view:setDelegate()
    self.layer.table_view:setDataSource()
    self.layer.table_view:setMoveSpeed(0.7)
    self.layer:addChild(self.layer.table_view, 10)

    self.layer.table_view:registerScriptHandler(handler(self, self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL) --滚动时的回掉函数
    self.layer.table_view:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX) --列表项的尺寸
    self.layer.table_view:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX) --创建列表项
    self.layer.table_view:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW) --列表项的数量
    -- self.layer.table_view:registerScriptHandler(handler(self, self.tableCellWillRecycle),cc.TABLECELL_WILL_RECYCLE);            --列表项将被回收
    -- self.layer.table_view:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED) --列表项被点击
    -- self.layer.table_view:registerScriptHandler(handler(self, self.tableCellHighLight),cc.TABLECELL_HIGH_LIGHT);                --列表项高亮显示
    -- self.layer.table_view:registerScriptHandler(handler(self, self.tableCellUnhighLight),cc.TABLECELL_UNHIGH_LIGHT);            --列表项取消高亮

	self.layer.table_view:reloadData()
	
end




function RankBuyGoldGiftLayer:scrollViewDidScroll(view)
end

function RankBuyGoldGiftLayer:cellSizeForTable(view, idx)
    return 480, 110
end

function RankBuyGoldGiftLayer:numberOfCellsInTableView(view)
	return #self.show_list
	
end

function RankBuyGoldGiftLayer:tableCellAtIndex(view, idx)
    -- 标记层数
    local cell = cc.TableViewCell:create()
    cell:setLocalZOrder(-idx)


	-- 创建ccbi cell
    local cell_rank = RewardCell:createWithCCBIFile("ccbi/PROMRewardCell.ccbi")

	if cell_rank then
		cell_rank:initData(self.show_list[idx + 1])
		cell_rank:setPosition(0, 0)
		cell_rank:setAnchorPoint(0, 0)
		cell:addChild(cell_rank)

	end
	return cell
end






function RankBuyGoldGiftLayer:onShowInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


------------------------------------------------

function RankBuyGoldGiftCtr:onCreate()
	self:setCCBIPath("ccbi/RankBuyGoldGiftLayer.ccbi")
	self:setIsSingle(false)
end

function RankBuyGoldGiftCtr:getLayerClass()
	return RankBuyGoldGiftLayer
end

function RankBuyGoldGiftCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initDone()
end

function RankBuyGoldGiftCtr:initDone()
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	
	self.layer:initDone()
end

return RankBuyGoldGiftCtr