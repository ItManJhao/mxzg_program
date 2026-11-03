--  

local PROMSpeedFightCtr = class("PROMSpeedFightCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local PROMSpeedFightRankLayer = class("PROMSpeedFightRankLayer", require("src.comp.EventLayer"))

local RankCell = class("RankCell", require("src.comp.LuaLayerBase"))
function RankCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end


function RankCell:initData(data )
    self.spr_photo:setSpriteFrame(string.format("head-icon/%d.png", data.head_id))
    self.spr_frame:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.border_id))
    self.lbl_name:setString(data.name)    
    self.lbl_lv:setString(string.format(ex.Tools:getLang(19), data.level))

    self.lbl_num:setString(string.format("%d", data.count))

    if data.rank <= 0 then
        self.spr_rank:setVisible(false)
        self.lbl_rank:setVisible(true)
        self.lbl_rank:setString(ex.Tools:getLang(52012))
        return 
    end

    if data ~= nil and self.spr_rank ~= nil then
        self.spr_rank:setVisible(false)
        self.lbl_rank:setVisible(true)
        self.lbl_rank:enableShadow(FONT_BLACK_C4B, cc.size(1, -1))
        if data.rank > 0 and data.rank < 4 then 
            self.spr_rank:setVisible(true)
            self.lbl_rank:setVisible(false)
            -- self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png", data.rank))
            ex.Tools:setSpriteFrame(self.spr_rank, string.format("rank/spr-paihang-%s.png", data.rank))
        end
        self.lbl_rank:setString(string.format("%d", data.rank))
    end

end


------------------------------------------------

function PROMSpeedFightRankLayer:onCreate()
	self:addBlackBackground()

    self.layer:setScale(ex.p.width / 640)
end

function PROMSpeedFightRankLayer:initDone()

    self.layer.cell_self = RankCell:createWithCCBIFile("ccbi/RankTopThreeCell.ccbi")
    local bg_size = self.layer.spr_rank_bg_self:getContentSize()
    self.layer.cell_self:setPosition((bg_size.width - self.layer.cell_self:getContentSize().width) / 2, (bg_size.height - self.layer.cell_self:getContentSize().height) / 2)
    self.layer.spr_rank_bg_self:addChild(self.layer.cell_self)

    local ttf_config = self.layer.cell_self.lbl_rank:getTTFConfig()
    ttf_config.fontSize = 36
    self.layer.cell_self.lbl_rank:setTTFConfig(ttf_config)
    

	local data = {}
    data.head_id = ex.Player.head_id;
    data.border_id = ex.Player.border_id;
    data.name = ex.Player.nick
    data.level = ex.Player.level
	data.rank = ex.Player.promotion_data.speed_fight_data.myRank
	data.count = ex.Player.promotion_data.speed_fight_data.nvalue
	self.layer.cell_self:initData(data)

    local list = ex.Player.promotion_data.speed_fight_data.listRank
    for i=1,3 do
        local data = list[i]
        if data ~= nil then
            self.layer["node_"..i]:setVisible(true)
            self.layer["spr_head_"..i]:setSpriteFrame(string.format("head-icon/%d.png", data.head_id))
            self.layer["spr_top_bg_"..i]:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.border_id))
            self.layer["lbl_name_"..i]:setString(data.name)
        else
            self.layer["node_"..i]:setVisible(false)
        end
    end

	self:updateScroll( )
end


function PROMSpeedFightRankLayer:updateScroll( )
	if self.layer.table_view ~= nil then
        self.layer.table_view:removeFromParent()
        self.layer.table_view = nil
	end
	

	self.layer.table_view = cpp.UITableViewEx:create(cc.size(self.layer.spr_rank_bg:getContentSize().width - 14, self.layer.spr_rank_bg:getContentSize().height - 66))
    self.layer.table_view:setPosition(self.layer.spr_rank_bg:getPositionX() + 8, self.layer.spr_rank_bg:getPositionY() + 5)
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





function PROMSpeedFightRankLayer:scrollViewDidScroll(view)
end

function PROMSpeedFightRankLayer:cellSizeForTable(view, idx)
    return 554, 110 + 4
end

function PROMSpeedFightRankLayer:numberOfCellsInTableView(view)
	return #ex.Player.promotion_data.speed_fight_data.listRank
end

function PROMSpeedFightRankLayer:tableCellAtIndex(view, idx)
    -- 标记层数
    local cell = cc.TableViewCell:create()
    cell:setLocalZOrder(-idx)


	-- 创建ccbi cell
    local cell_rank = RankCell:createWithCCBIFile("ccbi/RankTopThreeCell.ccbi")
	if cell_rank then
		cell_rank:initData(ex.Player.promotion_data.speed_fight_data.listRank[idx + 1])
		cell_rank:setPosition(0, 0)
		cell_rank:setAnchorPoint(0, 0)
		cell:addChild(cell_rank)

	end
	return cell
end





function PROMSpeedFightRankLayer:onShowInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

------------------------------------------------


function PROMSpeedFightCtr:onCreate()
	self:setCCBIPath("ccbi/PROMAdventureRankLayer.ccbi")
	self:setIsSingle(false)
end

function PROMSpeedFightCtr:getLayerClass()
	return PROMSpeedFightRankLayer
end

function PROMSpeedFightCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer:initDone()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

end

return PROMSpeedFightCtr