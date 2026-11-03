local PROMChristmasHappyPreviewCtr = class("PROMChristmasHappyPreviewCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMChristmasHappyPreviewLayer = class("PROMChristmasHappyPreviewLayer", require("src.comp.EventLayer"))

function PROMChristmasHappyPreviewLayer:onCreate()
	self:setAutoClose(true)
	self:addBlackBackground()
end

function PROMChristmasHappyPreviewLayer:onClose(tag,pSender)
    PROMChristmasHappyPreviewCtr:instance():closeWindow()
end

function PROMChristmasHappyPreviewLayer:refresh(data,max_weight)
	ex.Tools:setLimitWidth(self.lbl_title, 120)
	local content_list = {}
	-- 添加所有子节点
	local item_data = {}
	for i,v in ipairs(data) do
		local table_data = {}
		table_data.item_type = v.cost[1].item_type
		table_data.item_num =  v.cost[1].item_num
		table_data.weight = v.weight
		table.insert( item_data, table_data)
	end
	
	table.insert(content_list, self:addItems(item_data,max_weight))

	-- 计算高度
	local temp_height = 20
	for i=1, #content_list do
		temp_height = temp_height + content_list[i].height
	end
	self.scroll_view:setContentSize(cc.size(self.scroll_view:getViewSize().width, temp_height))
	self.scroll_view:setContentOffset(self.scroll_view:minContainerOffset())

	-- 子节点布局
	for i=1, #content_list do
		content_list[i].node:setPosition(self.scroll_view:getViewSize().width / 2, temp_height)
		self.scroll_view:addChild(content_list[i].node)

		temp_height = temp_height - content_list[i].height
	end
end


function PROMChristmasHappyPreviewLayer:addItems(item_list,max_weight)
	local count_row = math.ceil(#item_list / 4)
	local margin_x, margin_y, margin_top, margin_bottom = 25, 25, 10, 10

	local node_box = cc.Node:create()
	node_box:setAnchorPoint(ex.a.top_center)

	local menu = cpp.UIMenu:create()
	menu:setIsTouchInsideNode(self.scroll_view)
    menu:setSwallowsTouches(false)
	node_box:addChild(menu);
	
	local node_width = self.scroll_view:getViewSize().width
	local item_scale = 0.9
	local start_pos_x = 0
	local item_size = cc.size(0, 0)
	for i,v in ipairs(item_list) do
		local row, col = math.ceil(i / 4), 1 + ((i - 1) % 4)
		local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
		item:setScale(item_scale)
		item_size = item:getContentSize()
		item_size = cc.size(item_size.width * item_scale, item_size.height * item_scale)
		menu:addChild(item)
		item:registerScriptTapHandler(handler(self, self.onItem))
		
		local lbl = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 40)
		:setColor(cc.c3b(255,255,178))
		:setAnchorPoint(0.5, 0.5)
		:setScale(0.5)
		:setPosition(item:getPositionX()+60, item:getPositionY()-15)
		item:addChild(lbl)
		local weight  = string.format( "%.2f",(v.weight/max_weight)*100) 
		lbl:setString(weight.."%")

		start_pos_x = (node_width - 4 * item_size.width - 3 * margin_x) / 2
		item:setPosition(start_pos_x + (col - 0.5) * item_size.width + (col - 1) * margin_x, 0 - margin_top - ((row - 0.5) * item_size.height + (row - 1) * margin_y))
	end
	
	local node_size = cc.size(node_width, margin_top + margin_bottom + count_row * item_size.height + (count_row - 1) * margin_y)
	node_box:setContentSize(node_size)

	menu:setPosition(cc.p(0, node_size.height));

	return {height = node_size.height, node = node_box}
end

function PROMChristmasHappyPreviewLayer:onItem(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function PROMChristmasHappyPreviewCtr:onCreate()
	self:setCCBIPath("ccbi/PROMChristmasHappyPreviewLayer.ccbi")
	self:setIsSingle(false)

	self.data = {}
end

function PROMChristmasHappyPreviewCtr:getLayerClass()
	return PROMChristmasHappyPreviewLayer
end

function PROMChristmasHappyPreviewCtr:getProphetTreeRewardPreviewLayer()
	return self.layer
end

function PROMChristmasHappyPreviewCtr:openWindow(table_data,max_weight)
	if self:isOpened() then
		self:addReward(vec_reward)
		return
	end

	self.data = table_data
	self.max_weight = max_weight
	self:loadLayer()
	self:open()
	self:refreshView()
end

function PROMChristmasHappyPreviewCtr:refreshView()
    self.layer:refresh(self.data,self.max_weight)
end

return PROMChristmasHappyPreviewCtr
