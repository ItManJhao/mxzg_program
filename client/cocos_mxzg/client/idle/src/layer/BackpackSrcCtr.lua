local BackpackSrcCtr = class("BackpackSrcCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local BackpackSrcLayer = class("BackpackSrcLayer", require("src.comp.LuaLayerBase"))

local BackpackSrcCell = class("BackpackSrcCell", require("src.comp.LuaLayerBase"))
function BackpackSrcCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.menu:setSwallowsTouches(false)
end

function BackpackSrcCell:initData(data)
    self.spr_suggest:setVisible(data.is_suggest > 0)
    self.lbl_title:setString(ex.Tools:getLang(data.title_lang))
    self.lbl_content:setString(ex.Tools:getLang(data.description_lang))
end

function BackpackSrcLayer:onCreate()
	print("BackpackSrcLayer:onCreate")

	self:setAutoClose(true)
	self:setSwallowTouches(true)
	
	self:addBlackBackground()

	self.lbl_desc = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(44)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setFontColor("#551E14")
	:setScale(0.5)
	:setAnchorTextShadow(true)
	:setAnchorPoint(cc.p(0, 1))
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	:setContentSize(720, 0)
	:setPosition(0, 0)
	self.scroll_view_content:addChild(self.lbl_desc)
end

function BackpackSrcLayer:setItemContent(str_content)
	self.lbl_desc:setXmlTextLua(str_content)
	self.lbl_desc:formatText()

	local height = self.lbl_desc:getContentSize().height * self.lbl_desc:getScaleY()

	if height > self.scroll_view_content:getViewSize().height then
		self.lbl_desc:setPositionY(height)
	
		self.scroll_view_content:setContentSize(cc.size(self.scroll_view_content:getViewSize().width, height))
		self.scroll_view_content:setContentOffset(cc.p(0, -height + self.scroll_view_content:getViewSize().height))
	else
		self.lbl_desc:setPositionY(self.scroll_view_content:getViewSize().height)
	
		self.scroll_view_content:setContentSize(self.scroll_view_content:getViewSize())
		self.scroll_view_content:setContentOffset(cc.p(0, 0))
	end
end

-----------------------------------------------------------------------------
function BackpackSrcCtr:onCreate()
	self:setCCBIPath("ccbi/BackpackSrcLayer.ccbi")
	self:setIsSingle(false)
end


function BackpackSrcCtr:getLayerClass()
	return BackpackSrcLayer
end

--[[
	is_show_use
	点击自己背包，奖励窗口才会显示使用按钮
]]

function BackpackSrcCtr:openWindow(prop_type, jump_callback)
	if self:isOpened() then
		return
	end

	self.jump_callback = jump_callback or nil
	self:loadLayer()
	self:open()
	self:initDone(prop_type)

end

function BackpackSrcCtr:initDone(prop_type)
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self.item_type = prop_type

	local config = cfg.item.item[self.item_type]

	if not config then
		return
	end 
	
	self.is_piece = ex.Player.backpack_data:isPiece(self.item_type)

	self.layer.lbl_prop_name:setString(ex.Tools:getLang(config.name))

	local item_num = ex.StringUtil.getScientificNumber(ex.Player:getItemNum(self.item_type))
	self.layer.lbl_prop_num:setString(ex.Tools:getLang(47531)..item_num)

	self.layer:setItemContent(ex.Tools:getLang(config.content))

	local item = self.is_piece and require("src.comp.menu.UIMenuItemHeroPiece") or require("src.comp.menu.UIMenuItemBackpack")
	local node = item:createWithData(prop_type)
	:setPosition(self.layer.spr_icon:getPositionX(), self.layer.spr_icon:getPositionY())
	if not self.is_piece then 
		if node.lbl_num then 
			node.lbl_num:setVisible(false) 
		end
	end
	self.layer:addChild(node)

	ex.Tools:setSpriteFrame(self.layer.spr_icon, config.icon .. ".png")

	self:updateTableView()
end

function BackpackSrcCtr:updateTableView()
	-- 获取来源列表
	local item_config = cfg.item.item[self.item_type]
	local source_list = {}
	if item_config ~= nil and item_config.source ~= "" then
		source_list = clone(item_config.source)
	end

	for i,v in ipairs(source_list) do
		local source_config = cfg.itemsource.itemsource[v.source]
		v.title_lang = source_config.title_lang
		v.description_lang = source_config.description_lang
		v.jump_info = source_config.jump_info
	end

    -- 初始化tableview
    self.layer.scroll_view:setItemSize(cc.size(self.layer.scroll_view:getViewSize().width, 125))
    self.layer.scroll_view:setItemType(1)
	self.layer.scroll_view.createItemFunction = function(data, scale)

        -- 创建ccbi cell
        local cell = BackpackSrcCell:createWithCCBIFile("ccbi/BackpackSrcCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data)
    
        cell.menu:setIsTouchInsideNode(self.layer.scroll_view)

        cell.btn_go.jump_info = data.jump_info
		cell.btn_go:registerScriptTapHandler(handler(self, self.onItemSrc))
		
        return cell
    end
    
    self.layer.scroll_view:reloadData(source_list)
end

function BackpackSrcCtr:onItemSrc(tag, pSender)
	local jump_info = pSender.jump_info
	if not jump_info then
		return
	end

	if ex.JumpManager:isCanJumpByAtom(jump_info.event_arg) then
		-- self:closeOtherWindow()
		require("src.comp.LuaNodeCtr"):closeOtherWindow()
	else
		return
	end

	if ex.JumpManager:jumpByAtom(jump_info.event_arg) then
		self:closeWindow(0, nil)
	else
		return
	end

	if self.jump_callback then
		self.jump_callback(jump_info.event_arg)
	end
end

return BackpackSrcCtr
