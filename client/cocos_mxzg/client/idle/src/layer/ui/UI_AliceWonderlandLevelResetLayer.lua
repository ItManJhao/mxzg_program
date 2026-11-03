local AliceWonderlandLevelResetLayer = class("AliceWonderlandLevelResetLayer", require("src.comp.CCCLayerBase")) 

function AliceWonderlandLevelResetLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(598, 381)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(598, 381)
	spr_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/win-bg-24.png", capInsets = cc.rect(25,30,25,29)})
	self:addChild(spr_bg)
	self.spr_bg = spr_bg

	local node_title = cc.Node:create()
	node_title:setPosition(299, 381)
	node_title:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_title)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_title.lyt = lyt
	self:addChild(node_title)
	self.node_title = node_title

	local spr_title_bg = cc.Scale9Sprite:create()
	spr_title_bg:setPosition(0, 0)
	spr_title_bg:setContentSize(223, 70)
	spr_title_bg:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(1, spr_title_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/title-bar-4.png", capInsets = cc.rect(0,0,0,0)})
	node_title:addChild(spr_title_bg)
	self.spr_title_bg = spr_title_bg

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(70355),FONT_DEFAULT_NAME_BOLD, 56)
	lbl_title:setPosition(0, -50)
	lbl_title:setContentSize(116, 74.56)
	lbl_title:setScale(0.5, 0.5)
	lbl_title:setTextColor(cc.c3b(255, 227, 183))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title:enableOutline(cc.c4b(87,56,29,255), 2)
	node_title:addChild(lbl_title)
	self.lbl_title = lbl_title

	local lbl_tips = cc.Label:createWithTTF(ex.Tools:getLang(580030),FONT_DEFAULT_NAME_BOLD, 24)
	lbl_tips:setPosition(299, 190.5)
	lbl_tips:setContentSize(28.69, 30.24)
	lbl_tips:setTextColor(cc.c3b(122, 71, 45))
	lbl_tips:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_tips:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_tips)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(175.38)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	lbl_tips.lyt = lyt
	self:addChild(lbl_tips)
	self.lbl_tips = lbl_tips

	local CCMenu = cpp.UIMenu:create()
	CCMenu:setPosition(0, 0)
	CCMenu:setContentSize(0, 0)
	self:addChild(CCMenu)

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(545, 375)
	btn_close:setContentSize(55, 58)
	btn_close:setAnchorPoint(cc.p(0.5, 1))
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-1.png", spr2="button/btn-close-1.png"})
	CCMenu:addChild(btn_close)
	self.btn_close = btn_close

	local btn_reset = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_reset:setPosition(400, 50)
	btn_reset:setContentSize(136, 58)
	btn_reset:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_reset:setLabelOffset(cc.p(0, 0))
	btn_reset:setLabelSize(44)
	btn_reset:setLabelOutLine(cc.c4b(0,0,0,255), 2)
	btn_reset:setLabelText(ex.Tools:getLang(74224))
	self:addLoadRes(3, btn_reset, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-orange-big-1.png", spr3="button/btn-orange-big-2.png"})
	CCMenu:addChild(btn_reset)
	self.btn_reset = btn_reset

	local btn_cancel = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_cancel:setPosition(200, 50)
	btn_cancel:setContentSize(136, 58)
	btn_cancel:registerScriptTapHandler(handler(self, self.onClose))
	btn_cancel:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_cancel:setLabelOffset(cc.p(0, 0))
	btn_cancel:setLabelSize(44)
	btn_cancel:setLabelOutLine(cc.c4b(0,0,0,255), 2)
	btn_cancel:setLabelText(ex.Tools:getLang(5662))
	self:addLoadRes(3, btn_cancel, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-green-big-1.png"})
	CCMenu:addChild(btn_cancel)
	self.btn_cancel = btn_cancel

	 self:startLoadRes()
end
return AliceWonderlandLevelResetLayer