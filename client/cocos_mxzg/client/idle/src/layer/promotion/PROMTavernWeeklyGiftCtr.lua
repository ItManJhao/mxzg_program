local PROMTavernWeeklyGiftCtr = class("PROMTavernWeeklyGiftCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local PROMTavernWeeklyRankGiftLayer = class("PROMTavernWeeklyRankGiftLayer", require("src.comp.EventLayer"))

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
    

	local str_rank = tostring(config.rank_up)
    if config.rank_up > 4 then 
        str_rank = (config.rank_low ).."-"..config.rank_up
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

	for i,v in ipairs(config.reward) do
		local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
		item:setPosition(430 - 80 * (i - 1), 50)
		item:setScale(0.75)
		self.menu:addChild(item)
	end

end

------------------------------------------------



function PROMTavernWeeklyRankGiftLayer:onCreate()
	self:addBlackBackground()

end


function  PROMTavernWeeklyRankGiftLayer:sor( data )
    if #data < 1 then return {} end
 
    local function sort_table (a,b)  
        return a.rank_low < b.rank_low
    end 
    table.sort( data, sort_table )
    return data
 end


function PROMTavernWeeklyRankGiftLayer:initDone()

	-- 处理数据
    self.layer.cell_self = RewardCell:createWithCCBIFile("ccbi/PROMRewardCell.ccbi")
    self.layer.cell_self:setPosition(10, 5)
    self.layer.cell_self:setAnchorPoint(0, 0)
    self.layer.spr_rank_bg_self:addChild(self.layer.cell_self)

    self.deal_data = {}
    -- 重新整理数据
    local ori_data = {}

    local remRank = 0

    local now_data = ex.Player.promotion_data:getPromotionTavernWeeklyDatas()
    for k,v in pairs(cfg.promotiontavernweeklyrank.promotiontavernweeklyrank) do
        if now_data.turns == v.turns then 
            local nowData = {}
            nowData.rank_low = v.rank_low
            nowData.reward = v.reward
            nowData.rank_up = v.rank_up
            table.insert( ori_data, nowData )
        end 
    end

    local sort_data = self:sor(ori_data)
    local lase_rank = 0

    local myRankIndex = 0
    for k,v in pairs(sort_data) do
        local nowData = {}
        nowData.rank_low = v.rank_low
        nowData.reward = v.reward
        nowData.rank_up = v.rank_up

        if nowData.rank_low <= ex.Player.rank_data.rank_pub_task_self.rank and ex.Player.rank_data.rank_pub_task_self.rank <= v.rank_up then 
            myRankIndex = k
        end 

        table.insert( self.deal_data, nowData )
    end

    local config = self.deal_data[myRankIndex]
	if not config then
		self.layer.cell_self:initData(config)
	else 
		self.layer.cell_self:initData(config)
	end

    
	self:updateScroll()
end



function PROMTavernWeeklyRankGiftLayer:updateScroll( )

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




function PROMTavernWeeklyRankGiftLayer:scrollViewDidScroll(view)
end

function PROMTavernWeeklyRankGiftLayer:cellSizeForTable(view, idx)
    return 480, 110
end

function PROMTavernWeeklyRankGiftLayer:numberOfCellsInTableView(view)
	return #self.deal_data
	
end

function PROMTavernWeeklyRankGiftLayer:tableCellAtIndex(view, idx)
    -- 标记层数
    local cell = cc.TableViewCell:create()
    cell:setLocalZOrder(-idx)


	-- 创建ccbi cell
    local cell_rank = RewardCell:createWithCCBIFile("ccbi/PROMRewardCell.ccbi")

	if cell_rank then
		cell_rank:initData(self.deal_data[idx + 1])
		cell_rank:setPosition(0, 0)
		cell_rank:setAnchorPoint(0, 0)
		cell:addChild(cell_rank)

	end
	return cell
end






function PROMTavernWeeklyRankGiftLayer:onShowInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


------------------------------------------------

function PROMTavernWeeklyGiftCtr:onCreate()
	self:setCCBIPath("ccbi/PROMAdventureRankGiftLayer.ccbi")
	self:setIsSingle(false)
end

function PROMTavernWeeklyGiftCtr:getLayerClass()
	return PROMTavernWeeklyRankGiftLayer
end

function PROMTavernWeeklyGiftCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer:initDone()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

end

return PROMTavernWeeklyGiftCtr
