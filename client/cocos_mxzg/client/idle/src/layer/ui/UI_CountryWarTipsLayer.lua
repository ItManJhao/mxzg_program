local CountryWarTipsLayer = class("CountryWarTipsLayer", require("src.comp.CCCLayerBase")) 

function CountryWarTipsLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(385, 900)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
	self:setCascadeOpacityEnabled(true)
	self:setOpacity(0)
	self:runEnterAnim()
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(385, 850)
	spr_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-24.png", capInsets = cc.rect(16,16,14,15)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_bg)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(50)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_bg.lyt = lyt
	self:addChild(spr_bg)
	self.spr_bg = spr_bg

	local UIMenu = cpp.UIMenu:create()
	UIMenu:setCascadeOpacityEnabled(true)
	UIMenu:setPosition(340, 846)
	UIMenu:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(UIMenu)
	lyt:setRightMargin(45)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(4)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	UIMenu.lyt = lyt
	spr_bg:addChild(UIMenu)

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(0, 2.99)
	btn_close:setContentSize(53, 56)
	btn_close:setAnchorPoint(cc.p(0.5, 1))
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-1.png", spr2="button/btn-close-1.png"})
	UIMenu:addChild(btn_close)
	self.btn_close = btn_close

	local lbl_title = cc.Label:createWithTTF("3",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_title:setPosition(192.5, 805)
	lbl_title:setContentSize(12.55, 37.8)
	lbl_title:setTextColor(cc.c3b(255, 224, 178))
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_title)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(26.1)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	lbl_title.lyt = lyt
	spr_bg:addChild(lbl_title)
	self.lbl_title = lbl_title

	local spr_tips_bg = cc.Scale9Sprite:create()
	spr_tips_bg:setPosition(192.5, 75)
	spr_tips_bg:setContentSize(150, 29)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_tips_bg)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(60.5)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	spr_tips_bg.lyt = lyt
	spr_bg:addChild(spr_tips_bg)
	self.spr_tips_bg = spr_tips_bg

	local spr_tips = cc.Sprite:create()
	spr_tips:setPosition(2, 14.5)
	spr_tips:setContentSize(29, 29)
	self:addLoadRes(2, spr_tips, "ccbi-res/countrywar.plist", "ccbi-res/countrywar.pvr.ccz", "countrywar/spr-tips.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_tips)
	lyt:setLeftMargin(-12.5)
	lyt:setHorizontalEdge(1)
	lyt:setPositionPercentYEnabled(true)
	lyt:setPositionPercentY(0.5)
	self:addLyt(lyt)
	spr_tips.lyt = lyt
	spr_tips_bg:addChild(spr_tips)
	self.spr_tips = spr_tips

	local lbl_stage = cc.Label:createWithTTF("",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_stage:setPosition(23.97, 29)
	lbl_stage:setContentSize(11.41, 32.76)
	lbl_stage:setAnchorPoint(cc.p(0, 1))
	lbl_stage:setTextColor(cc.c3b(255, 224, 178))
	lbl_stage:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_stage:setDimensions(11.41, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_stage)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	lbl_stage.lyt = lyt
	spr_tips_bg:addChild(lbl_stage)
	self.lbl_stage = lbl_stage

	 self:startLoadRes()
end
return CountryWarTipsLayer