local ProphetTreeRewardPreviewCtr = class("ProphetTreeRewardPreviewCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ProphetTreeRewardPreviewLayer = class("ProphetTreeRewardPreviewLayer", require("src.comp.EventLayer"))

function ProphetTreeRewardPreviewLayer:onCreate()
	self:setAutoClose(true)
	self:addBlackBackground()
end

function ProphetTreeRewardPreviewLayer:onClose(tag,pSender)
    ProphetTreeRewardPreviewCtr:instance():closeWindow()
end

function ProphetTreeRewardPreviewLayer:refresh(data)
	local content_list = {}
	-- 添加所有子节点
	for i,v in ipairs(data) do
		if i > 1 then
			table.insert(content_list, self:addLine())
		end

		table.insert(content_list, self:addRateDesc(v.star, v.description_lang))
		table.insert(content_list, self:addItems(v.item_show))
	end

	-- 计算高度
	local temp_height = 0
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

function ProphetTreeRewardPreviewLayer:addRateDesc(star, lang_id)
	local node_box = cc.Node:create()
	node_box:setAnchorPoint(ex.a.top_center)
	node_box:setContentSize(self.scroll_view:getViewSize().width, 46)

	ex.Tools:createRichText(node_box, ex.Tools:getLang(lang_id), 22, false, cc.tex2F(50, 50), 
		CommonUIDefine.UIDefine.ComponentOriginType.RATIO, "#FFE1B2", 1, ex.a.center)

	return {height = 46, node = node_box}
end

function ProphetTreeRewardPreviewLayer:addItems(item_list)
	local count_row = math.ceil(#item_list / 4)
	local margin_x, margin_y, margin_top, margin_bottom = 25, 15, 10, 10

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

function ProphetTreeRewardPreviewLayer:addLine()
	local node_box = cc.Node:create()
	node_box:setAnchorPoint(ex.a.top_center)
	node_box:setContentSize(self.scroll_view:getViewSize().width, 46)

	local line = cc.Sprite:createWithSpriteFrameName("other/spr-line.png")
	line:setScaleX(480 / line:getContentSize().width)
	line:setAnchorPoint(ex.a.center)
	line:setPosition(ex.Tools:getAbsolutePosition(cc.p(50, 50), CommonUIDefine.UIDefine.ComponentOriginType.RATIO, node_box))
	node_box:addChild(line)

	return {height = 46, node = node_box}
end

function ProphetTreeRewardPreviewLayer:onItem(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function ProphetTreeRewardPreviewCtr:onCreate()
	self:setCCBIPath("ccbi/ProphetTreeRewardPreviewLayer.ccbi")
	self:setIsSingle(false)

	self.data = {}
end

function ProphetTreeRewardPreviewCtr:getLayerClass()
	return ProphetTreeRewardPreviewLayer
end

function ProphetTreeRewardPreviewCtr:getProphetTreeRewardPreviewLayer()
	return self.layer
end

function ProphetTreeRewardPreviewCtr:openWindow(prophet_type)
	if self:isOpened() then
		self:addReward(vec_reward)
		return
	end

	self.data = cfg.prophecyshow.getConfigListByProphecyType(prophet_type)

	self:loadLayer()
	self:open()
	self:refreshView()
end

function ProphetTreeRewardPreviewCtr:refreshView()
    self.layer:refresh(self.data)
end

return ProphetTreeRewardPreviewCtr
