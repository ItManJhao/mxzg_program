local UICheckBox = class("UICheckBox", function()
											return cc.Layer:create()
										end)

local ResList = {
	[1] = {
		btn_down = "button/btn-down.png",
		btn_up = "button/btn-up.png",
		btn_long_bg = "win-bg/block-bg-checkbox-1.png",
		btn_long_bg_rect = cc.rect(10, 10, 1, 1),
		pop_bg = "win-bg/block-bg-checkbox-2.png",
		pop_bg_rect = cc.rect(5, 5, 1, 1),
		text_color = cc.c3b(253, 224, 177),
		pos_text_color = "#FDE0B1",
		text_size = 32,
		pop_text_size = 32,
	},
	[2] = {
		btn_down = "button/btn-down.png",
		btn_up = "button/btn-up.png",
		btn_long_bg = "setting/spr-block-2.png",
		btn_long_bg_rect = cc.rect(10, 10, 10, 10),
		pop_bg = "win-bg/block-bg-29.png",
		pop_bg_rect = cc.rect(12, 12, 12, 12),
		text_color = cc.c3b(122, 71, 45),
		pos_text_color = "#7A472D",
		text_size = 40,
		pop_text_size = 40,
	},
}

function UICheckBox:ctor()
	self:setIgnoreAnchorPointForPosition(false)
	self:setAnchorPoint(0.5, 0.5)

	self.res_list = {}
	self.content_size = cc.size(50, 50)
	self.selected_item_index = 1
	self.vec_check_item = {}
	self.is_show_menu_panel = false
	self.item_offset_y = 5
end

--[[控件创建函数，@param
	size: checkbox大小，不能为nil
	callback: 选中回调
	vec_check_item: 下拉框选项, 可以为富文本
	style_type：上面ResList定义的样式
]]
function UICheckBox:createWithContentSize(size, callback, vec_check_item, default_idx, style_type)
	if size == nil then
		return
	end

	if vec_check_item == nil then
		vec_check_item = {}
	end

	local pRef = self:create()
	pRef:initDone(size, callback, vec_check_item, default_idx, style_type)

	return pRef
end

-- 初始化控件
function UICheckBox:initDone(size, callback, vec_check_item, default_idx, style_type)
	self.content_size = size
	self.vec_check_item = vec_check_item and {}
	self.selected_item_index = default_idx and 1
	self.res_list = ResList[style_type or 1]
	
	self:updateBoxSelectedItem()
	self:setMenuItemCallback(callback)
end

-- 设置控件选中按钮
function UICheckBox:updateBoxSelectedItem()
	self:setContentSize(self.content_size)

	if self.menu_selected == nil then
		self.menu_selected = cpp.UIMenu:create()
		:setPosition(cc.p(0, 0))
		self:addChild(self.menu_selected, 10)
	end

	if self.check_item == nil then
		self.check_item = cpp.UIMenuItemImage:create()
		self.check_item:setEnableAction(false)
		self.check_item:setContentSize(self.content_size)
		self.check_item:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self.menu_selected:addChild(self.check_item, 10)

		self.check_item:registerScriptTapHandler(handler(self, self.onSelectedItem))
	end

	if self.check_item.spr_arrow == nil then
		self.check_item.spr_arrow = cc.Sprite:createWithSpriteFrameName(self.res_list.btn_down)
		:setAnchorPoint(cc.p(1, 0.5))
		:setPosition(self.content_size.width, self.content_size.height / 2)
		self.check_item:addChild(self.check_item.spr_arrow, 100)
	end

	if self.check_item.lbl_selected == nil then
		self.check_item.lbl_selected = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, self.res_list.text_size)
		:setColor(self.res_list.text_color)
		:setAnchorPoint(0, 0.5)
		:setScale(0.5)
		:setPosition(10, self.check_item:getContentSize().height / 2)
		self.check_item:addChild(self.check_item.lbl_selected, 10)
	end

	if self.vec_check_item ~= nil and table.nums(self.vec_check_item) > 0 then
		if self.selected_item_index > table.nums(self.vec_check_item) then
			self.selected_item_index = table.nums(self.vec_check_item)
		end

		self.check_item.lbl_selected:setString(self.vec_check_item[self.selected_item_index].name)
	end

	if self.check_item.spr_bg == nil then
		local bg = ccui.Scale9Sprite:createWithSpriteFrameName(self.res_list.btn_long_bg)
		:setCapInsets(self.res_list.btn_long_bg_rect)
		:setIgnoreAnchorPointForPosition(true)
		bg:setPosition(0, 0)
		bg:setContentSize(self.content_size)
		self.check_item:addChild(bg, 5)

		self.check_item.spr_bg = bg
	else
		self.check_item.spr_bg:setContentSize(self.content_size)
	end
end

-- 设置点击显示下拉菜单回调
function UICheckBox:setSelectedCallback(callback)
	self.selected_callback = callback
end

-- 设置菜单项回调
function UICheckBox:setMenuItemCallback(callback)
	self.menu_item_callback = callback
end

-- 展示或者隐藏下拉菜单
function UICheckBox:showCheckMenu(visible)
	self.is_show_menu_panel = visible


	if visible then
		if self.check_item ~= nil and self.check_item.spr_arrow ~= nil then
			ex.Tools:setSpriteFrame(self.check_item.spr_arrow, self.res_list.btn_up)
			-- self.check_item.spr_arrow:setSpriteFrame(self.res_list.btn_up)
		end

		-- 计算panel大小
		local item_size = self:getContentSize()
		local item_num = math.max(1, table.nums(self.vec_check_item))
		local item_height = math.min(item_num, 5) * item_size.height

		-- 创建panel
		if self.check_panel == nil then
			self.check_panel = cc.Layer:create()
			self:addChild(self.check_panel, 20)
		else
			self.check_panel:setVisible(true)
		end

		-- 创建panel背景
		if self.check_panel.spr_bg == nil then
			local bg = ccui.Scale9Sprite:createWithSpriteFrameName(self.res_list.pop_bg)
			:setCapInsets(self.res_list.pop_bg_rect)
			:setIgnoreAnchorPointForPosition(false)
			:setAnchorPoint(0, 1)
			bg:setPosition(0, 0)
			bg:setContentSize(cc.size(item_size.width, item_height + 10))
			self.check_panel:addChild(bg, 5)
	
			self.check_panel.spr_bg = bg
		end
		-- 创建panel菜单滑动屏
		if self.check_panel.scroll_view == nil then
			local scroll_view = require("src.comp.UIScrollViewBackpack"):createWithSize(cc.size(item_size.width, item_height))
			scroll_view:setIgnoreAnchorPointForPosition(false)
			scroll_view:setAnchorPoint(0, 1)
			scroll_view:setPosition(5, -5)
			scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
			scroll_view:setItemSize(cc.size(item_size.width - 10, item_size.height + 10))
			scroll_view:setItemOffset(cc.p(0, 5))
			scroll_view:setAutoFull(true)
			self.check_panel:addChild(scroll_view, 10)
		
			self.check_panel.scroll_view = scroll_view
		end
		-- 创建panel菜单menu
		if self.check_panel.menu == nil then
			local menu = cpp.UIMenu:create()
			:setIsTouchInsideNode(self.check_panel.scroll_view)
			:setSwallowsTouches(false)
			:setPosition(cc.p(0, 0))
			self.check_panel.scroll_view:addChild(menu)

			self.check_panel.menu = menu
		end

		self.check_panel.menu:removeAllChildren()

		-- 创建panel菜单项
		local tmp_item_size = nil
		local item_num = table.nums(self.vec_check_item)
		for i=1,item_num do
			local check_data = self.vec_check_item[item_num - i + 1]

			local item = cpp.UIMenuItemImage:create()
			item:setEnableAction(false)
			item:setAnchorPoint(0, 0)
			self.check_panel.menu:addChild(item, 10)

			item.sort = item_num - i + 1
			item.index = check_data.index
			item.name = check_data.name

			-- 创建Label对象，并初始化
			local scale_label = 0.5
			local lbl_content = require("src.comp.RichTextEx"):create()
			:setFontSize(self.res_list.pop_text_size)
			:setFontFace(FONT_DEFAULT_NAME_BOLD)
			:setFontColor(self.res_list.pos_text_color)
			:setScale(scale_label)
			:setAnchorPoint(0, 0.5)
			:setPosition(0, item:getContentSize().height / 2)
			:setAnchorTextShadow(true)
			-- :ignoreContentAdaptWithSize(false)
			:setWrapMode(1)
			item:addChild(lbl_content, 10001)

			lbl_content:setXmlTextLua(check_data.name)
			lbl_content:formatText()
	
			item:registerScriptTapHandler(handler(self, self.onMenuItem))

			if tmp_item_size == nil then
				tmp_item_size = cc.size(item_size.width, lbl_content:getContentSize().height + 5)
			end
			
			item:setContentSize(tmp_item_size)
			item:setPosition(5, (lbl_content:getContentSize().height + self.item_offset_y) * (i - 1))
			lbl_content:setPositionY(item:getContentSize().height / 2)
		end

		self.check_panel.scroll_view:setContentSize(cc.size(tmp_item_size.width, tmp_item_size.height * table.nums(self.vec_check_item)))
		self.check_panel.scroll_view:setContentOffset(cc.p(0, -self.check_panel.scroll_view:getContentSize().height + self.check_panel.scroll_view:getViewSize().height))
	else
		if self.check_item ~= nil and self.check_item.spr_arrow ~= nil then
			ex.Tools:setSpriteFrame(self.check_item.spr_arrow, self.res_list.btn_down)
			-- self.check_item.spr_arrow:setSpriteFrame(self.res_list.btn_down)
		end

		if self.check_panel ~= nil then
			self.check_panel:removeFromParent()
			self.check_panel = nil
			-- self.check_panel:setVisible(false)
		end
	end
end

-- 点击选中项回调
function UICheckBox:onSelectedItem(tag, pSender)
	if self.is_show_menu_panel then
		self:showCheckMenu(false)
	else
		self:showCheckMenu(true)
	end

	if self.selected_callback ~= nil then
		self.selected_callback(self.is_show_menu_panel)
	end
end

-- 点击选中下拉菜单项
function UICheckBox:onMenuItem(tag, pSender)
	self:showCheckMenu(false)

	if pSender.index == nil or pSender.index <= 0 then
		return
	end

	self.selected_item_index = pSender.sort
	self.check_item.lbl_selected:setString(self.vec_check_item[self.selected_item_index].name)

	if self.menu_item_callback ~= nil then
		self.menu_item_callback(pSender.index, pSender.name)
	end
end

-- 设置panel内容
function UICheckBox:setCheckItemList(vec_check_item, default_idx)
	self.vec_check_item = vec_check_item or {}
	self.selected_item_index = default_idx or 1

	if self.selected_item_index > table.nums(self.vec_check_item) then
		self.selected_item_index = table.nums(self.vec_check_item)
	end
	if self.check_item.lbl_selected ~= nil then
		self.check_item.lbl_selected:setString(self.vec_check_item[self.selected_item_index].name)
	end

	-- 刷新显示
	if self.is_show_menu_panel then
		self:showCheckMenu(true)
	end
end

return UICheckBox
