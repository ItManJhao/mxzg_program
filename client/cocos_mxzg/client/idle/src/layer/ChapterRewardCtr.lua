local ChapterRewardCtr = class("ChapterRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ChapterRewardLayer = class("ChapterRewardLayer", require("src.comp.LuaLayerBase"))

function ChapterRewardLayer:onCreate()

    -- local win_size = cc.Director:getInstance():getWinSize()

    -- local scaleX = 640 / ex.p.width
    local scale = Maths.clampf(math.min(1, ex.p.width / 640), 0.5, 1)
    self:setScale(scale)

    -- local last_content_size = self:getContentSize()
    -- local cur_content_size = cc.size(ex.p.width - 20, ex.p.height - 220)
    -- local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

    -- self:setContentSize(cur_content_size)
    -- self:setPosition(ex.p.width / 2 - self:getContentSize().width / 2, ex.p.height / 2 - self:getContentSize().height / 2 + 20)

    -- self.spr_bg:setContentSize(cc.size(cur_content_size.width + 20, cur_content_size.height + 20))
    -- self.spr_bg:setPosition(-10, -10)
    -- self.btn_close:setPosition(cur_content_size.width - 40, cur_content_size.height - 25)

    -- self.spr_title_bg:setPosition(self.spr_title_bg:getPositionX() + offset.x / 2, self.spr_title_bg:getPositionY() + offset.y)
    -- self.lbl_title:setPosition(self.lbl_title:getPositionX() + offset.x / 2, self.lbl_title:getPositionY() + offset.y)

    -- self.spr_box:setPosition(30 + offset.x / 2, 60)
    -- self.spr_box:setContentSize(cc.size(self.spr_box:getContentSize().width + offset.x / 2, cur_content_size.height - 220))

    self.table_view = cc.TableView:create(cc.size(self.spr_box:getContentSize().width - 10, self.spr_box:getContentSize().height - 10))
    self.table_view:setPosition(self.spr_box:getPositionX() + 5, self.spr_box:getPositionY() + 5)
    self.table_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.table_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.table_view:setBounceable(false)
    self.table_view:setDelegate()
    self.table_view:setDataSource()
    self:addChild(self.table_view)

    self.table_view:registerScriptHandler(handler(self, self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL) --滚动时的回掉函数
    self.table_view:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX) --列表项的尺寸
    self.table_view:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX) --创建列表项
    self.table_view:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW) --列表项的数量
    self.table_view:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED) --列表项被点击

    self:addBlackBackground()

end

function ChapterRewardLayer:scrollViewDidScroll(view)
end

function ChapterRewardLayer:cellSizeForTable(view, idx)
    return self.cell_size.width, self.cell_size.height + 10
end

function ChapterRewardLayer:numberOfCellsInTableView(view)
    return self.data ~= nil and table.nums(self.data) or 0
end

function ChapterRewardLayer:tableCellAtIndex(view, idx)
    local cell = cc.TableViewCell:create()
    -- cell:setLocalZOrder(-idx)
    local cell_layer = self.cell_class:createWithCCBIFile(self.ccbi_file)
    cell_layer:setPosition(0, 0)

    if cell_layer.onInit then
    	cell_layer:onInit(self.data[idx + 1], idx)
    end

    cell:addChild(cell_layer)
    return cell
end

function ChapterRewardLayer:tableCellTouched(view, cell)
end

function ChapterRewardLayer:updateLayer()
	if not self.cell_class or not self.data then
		print("cell_class = ", self.cell_class, "data = ", self.data)
		return
	end
		
	self.ccbi_file = "ccbi/" .. self.cell_class.__cname .. ".ccbi"
	self.cell_size = self.cell_class:createWithCCBIFile(self.ccbi_file):getContentSize()
	self.table_view:reloadData()
end

-----------------------------------------------------------------------------
function ChapterRewardCtr:onCreate()
	self:setCCBIPath("ccbi/ChapterRewardLayer.ccbi")
	self:setIsSingle(false)
end

function ChapterRewardCtr:getLayerClass()
	return ChapterRewardLayer
end

function ChapterRewardCtr:getChapterRewardLayer()
	return self.layer
end

function ChapterRewardCtr:openWindow(data, cell_class)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(data, cell_class)
end

function ChapterRewardCtr:initData(data, cell_class)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    
	self.layer.data = data
	self.layer.cell_class = cell_class
	self.layer:updateLayer()
end

function ChapterRewardCtr:updateLayer()
    if not self:getLayer() then
        return
    end
    self.layer:updateLayer()
end

return ChapterRewardCtr
