local RCGPrivilegeGiftCell = class("RCGPrivilegeGiftCell", require("src.comp.EventLayer"))

function RCGPrivilegeGiftCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	self:setAnchorPoint(0, 0)
	self.menu:setSwallowsTouches(false)
	self.buy_btn:setLabelText("  ")
	self.buy_btn:setLabelSize(54)
	-- self.buy_btn:setLabelColor(FONT_BROWN)
	self.buy_btn:getLabel():setTextColor(cc.c3b(117, 60, 29))
	self.buy_btn:setScale(1.1)

    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_promotion_2")
    spr_effect:setPosition(self.gift_img:getPosition())
	self:addChild(spr_effect, 0, 10)
	
	self.gift_desc = cpp.RichTextEx:createWithXMLLua("")
	self.gift_desc:setFontSize(18)
	self.gift_desc:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.gift_desc:setFontColor("#FFFFFF")
	self.gift_desc:setContentSize(cc.size(320, 100))
	self.gift_desc:setScale(1)
	-- :setAnchorTextShadow(true)
	self.gift_desc:ignoreContentAdaptWithSize(false)
	self.gift_desc:setWrapMode(1)
	self.gift_desc:setAnchorPoint(ex.a.left_top)
	self.gift_desc:setAnchorTextOutline(true,cc.c3b(162,96,19))
	-- self.gift_desc:setXmlTextLua(str)
	self.gift_desc:setPosition(160, 142)
    self:addChild(self.gift_desc)
end

return RCGPrivilegeGiftCell