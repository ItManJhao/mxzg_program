local RCGLimitCell = class("RCGLimitCell", require("src.comp.EventLayer"))

function RCGLimitCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	self.menu:setSwallowsTouches(false)
	self.btn_buy:setLabelSize(45)
	self.btn_buy:setLabelColor(FONT_BLACK)

	self:setIgnoreAnchorPointForPosition(false)
	self:setAnchorPoint(0.5, 0.5)
	self.scroll_view:setItemSize(cc.size(90, 100))
	self.scroll_view:setSwallowsTouches(false)


	self.lbl_content = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FFFFFF")
	:setPosition(cc.p(self.spr_text_bg:getPositionX() + 10, self.spr_text_bg:getPositionY()))
	:setAnchorPoint(cc.p(0, 0.5))
	self:addChild(self.lbl_content)
end

function RCGLimitCell:reset(data, scroll_view, index)
	self.data = data

	-- 调用次数不多。所以写在这里
	local cell_format = {
		[1] = {outline = cc.c3b(15, 101, 57), btn_outline = cc.c3b(162, 96, 19), btn_img = "button/btn-orange-big-1.png", btn_scale=1},
		[2] = {outline = cc.c3b(105, 30, 181), btn_outline = cc.c3b(162, 96, 19), btn_img = "button/btn-orange-big-1.png", btn_scale=1},
		[3] = {outline = cc.c3b(181, 64, 9), btn_outline = cc.c3b(162, 96, 19), btn_img = "button/btn-orange-big-1.png", btn_scale=1},
		[4] = {outline = cc.c3b(132, 16, 16), btn_outline = cc.c3b(98, 27, 215), btn_img = "button/btn-orange-4.png", btn_scale=0.83},
	}

	local sfc = cc.SpriteFrameCache:getInstance()
	local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

	-- self.menu:setIsTouchInsideNode(self.scroll_view)
    self.btn_buy:registerScriptTapHandler(handler(self, self.onBuy))
	self.btn_buy:setScale(1.2)
	self.lbl_desc:setString(ex.Tools:getLang(self.data.item_language))
	self.lbl_desc:enableOutline(cell_format[index].outline, 2)
	-- self.lbl_content:setXmlTextLua(ex.Tools:getLang(self.data.tag_language))
	-- local string.format(ex.Tools:getLang(47229))
	-- local str = string.format("<outline color='#A26013'size='2'> 立赠<font color='#FF2A00'><outline color='#A26013'size='0'> 1360</outline></font><img src='backpack/900002.png' width='30' height='30' />和价值<font color='#FF2A00'><outline color='#A26013'size='0'> 4096</outline></font><img src='backpack/900002.png' width='30' height='30' />豪礼</outline>")
	-- string.format(ex.Tools:getLang(47104))
	self.lbl_content:setXmlTextLua(ex.Tools:getLang(self.data.tag_language))

	local lbl_buy = self.btn_buy:getLabel()
	lbl_buy:setColor(cc.c3b(255,255,255))
	lbl_buy:enableOutline(cell_format[index].btn_outline, 4)
	self.btn_buy:setNormalImage(cc.Sprite:createWithSpriteFrameName(cell_format[index].btn_img))
	self.btn_buy:setScale(cell_format[index].btn_scale)
	lbl_buy:setPosition(self.btn_buy:getContentSize().width * 0.5, self.btn_buy:getContentSize().height * 0.5)
	lbl_buy:setScale(0.5 / cell_format[index].btn_scale)

    self.lbl_count:setString(string.format(ex.Tools:getLang(47238), self.data.limit_times))
	local icon = tonumber(self.data.icon) or 1
	ex.Tools:setSpriteFrame(self.spr_ribbon, string.format("promotion/spr-ribbon-%d.png", icon))
	if icon > 3 then icon = 3 end 
	ex.Tools:setSpriteFrame(self.spr_gift, string.format("promotion/spr-gift-%d.png", icon))
	self.spr_gift:setScale(self.spr_gift:getScale() * 1 / cell_format[index].btn_scale)
	self.spr_gift:setVisible(index > 3)

	self.scroll_view.createItemFunction = function(data)
		local item = UIMenuItemBackpack:createWithData(data.item_type, data.item_num)
		item:setScale(0.75)
		item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
		if data.item_type == ItemType.IT_GEM then
			item:setDoubleIcon(true, 3)
		end
		return item
	end
	self.scroll_view:reloadData(self.data.goods)

    local is_buy = ex.Player.promotion_data:getDayLimitStatus(self.data.idx)
    if is_buy == true then
        -- cell.btn_buy:setLabelText(ex.Tools:getLang(47217))
        self.btn_buy:setLabelText(string.format(ex.Tools:getLang(47404), (self.data.rmb / 100)))
    else
        self.btn_buy:setLabelText(ex.Tools:getLang(47327))
        self.btn_buy:setEnabled(false)
    end
end

return RCGLimitCell