--[[
    func: 中秋活动-皮肤奖励预览界面
    author:熊梦
    time:2021-02-24 13:56:46
    版权所有:广州暗耀晶石网络信息科技有限公司
]]
local PROMShangYueSkinPreviewCtr = class("PROMShangYueSkinPreviewCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMShangYueSkinPreviewLayer = class("PROMShangYueSkinPreviewLayer", require("src.comp.EventLayer"))

function PROMShangYueSkinPreviewLayer:onCreate()
	self:setAutoClose(true)
	self:addBlackBackground()
end

function PROMShangYueSkinPreviewLayer:onClose(tag,pSender)
    PROMChristmasHappyPreviewCtr:instance():closeWindow()
end

function PROMShangYueSkinPreviewLayer:refresh(data)
	ex.Tools:setLimitWidth(self.lbl_title, 120)
	local content_list = {}
	-- 添加所有子节点
	local item_data = {}
	for i,v in ipairs(data) do
		local table_data = {}
		table_data.item_type = v.item_type
		table_data.item_num =  v.item_num
		table.insert( item_data, table_data)
	end
	
	table.insert(content_list, self:addItems(item_data))

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


function PROMShangYueSkinPreviewLayer:addItems(item_list)
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

		start_pos_x = (node_width - 4 * item_size.width - 3 * margin_x) / 2
		item:setPosition(start_pos_x + (col - 0.5) * item_size.width + (col - 1) * margin_x, 0 - margin_top - ((row - 0.5) * item_size.height + (row - 1) * margin_y))
	end
	
	local node_size = cc.size(node_width, margin_top + margin_bottom + count_row * item_size.height + (count_row - 1) * margin_y)
	node_box:setContentSize(node_size)

	menu:setPosition(cc.p(0, node_size.height));

	return {height = node_size.height, node = node_box}
end

function PROMShangYueSkinPreviewLayer:onItem(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function PROMShangYueSkinPreviewCtr:onCreate()
	self:setCCBIPath("ccbi/PROMChristmasHappyPreviewLayer.ccbi")
	self:setIsSingle(false)

	self.data = {}
end

function PROMShangYueSkinPreviewCtr:getLayerClass()
	return PROMShangYueSkinPreviewLayer
end

function PROMShangYueSkinPreviewCtr:getProphetTreeRewardPreviewLayer()
	return self.layer
end

function PROMShangYueSkinPreviewCtr:openWindow(table_data)
	if self:isOpened() then
		self:addReward(vec_reward)
		return
	end

	self.data = table_data
	self:loadLayer()
	self:open()
	self:refreshView()
end

function PROMShangYueSkinPreviewCtr:refreshView()
    self.layer:refresh(self.data)
end

return PROMShangYueSkinPreviewCtr
