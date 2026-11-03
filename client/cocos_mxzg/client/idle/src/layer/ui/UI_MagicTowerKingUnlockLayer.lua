local MagicTowerKingUnlockLayer = class("MagicTowerKingUnlockLayer", require("src.comp.CCCLayerBase")) 

function MagicTowerKingUnlockLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(620, 1060)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
	self:setCascadeOpacityEnabled(true)
	self:setOpacity(0)
	self:runEnterAnim()
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(620, 1060)
	spr_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/win-bg-11.png", capInsets = cc.rect(58,64,56,71)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_bg)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_bg.lyt = lyt
	self:addChild(spr_bg)
	self.spr_bg = spr_bg

	local spr_content_bg = cc.Scale9Sprite:create()
	spr_content_bg:setPosition(310, 175)
	spr_content_bg:setContentSize(560, 765)
	spr_content_bg:setAnchorPoint(cc.p(0.5, 0))
	self:addLoadRes(1, spr_content_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-7.png", capInsets = cc.rect(15,14,16,14)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_content_bg)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(120)
	lyt:setBottomMargin(175)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_content_bg.lyt = lyt
	self:addChild(spr_content_bg)
	self.spr_content_bg = spr_content_bg

	local spr_banner = cc.Sprite:create()
	spr_banner:setPosition(310, 733)
	spr_banner:setContentSize(552, 202)
	spr_banner:setAnchorPoint(cc.p(0.5, 0))
	self:addLoadRes(2, spr_banner, "ccbi-res/magic-tower.plist", "ccbi-res/magic-tower.pvr.ccz", "magic-tower/banner-buy-king.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_banner)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(125)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	spr_banner.lyt = lyt
	self:addChild(spr_banner)
	self.spr_banner = spr_banner

	local node_title = cc.Node:create()
	node_title:setCascadeOpacityEnabled(true)
	node_title:setPosition(310, 1060)
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
	spr_title_bg:setContentSize(184, 67)
	spr_title_bg:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(1, spr_title_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/title-bar-3.png", capInsets = cc.rect(0,0,0,0)})
	node_title:addChild(spr_title_bg)
	self.spr_title_bg = spr_title_bg

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(57524),FONT_DEFAULT_NAME_BOLD, 56)
	lbl_title:setPosition(0, -40)
	lbl_title:setContentSize(211.81, 74.56)
	lbl_title:setScale(0.5, 0.5)
	lbl_title:setTextColor(cc.c3b(255, 227, 183))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title:enableOutline(cc.c4b(87,56,29,255), 2)
	node_title:addChild(lbl_title)
	self.lbl_title = lbl_title

	local menu = cpp.UIMenu:create()
	menu:setCascadeOpacityEnabled(true)
	menu:setPosition(0, 0)
	menu:setContentSize(620, 1060)
	menu:setAnchorPoint(cc.p(0, 0))
	menu:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	menu.lyt = lyt
	self:addChild(menu)
	self.menu = menu

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(542.5, 1060)
	btn_close:setContentSize(55, 58)
	btn_close:setAnchorPoint(cc.p(0.5, 1))
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-1.png", spr2="button/btn-close-1.png"})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(btn_close)
	lyt:setRightMargin(50)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	btn_close.lyt = lyt
	menu:addChild(btn_close)
	self.btn_close = btn_close

	local node_reward_1 = cc.Node:create()
	node_reward_1:setCascadeOpacityEnabled(true)
	node_reward_1:setPosition(310, 420)
	node_reward_1:setContentSize(560, 300)
	node_reward_1:setAnchorPoint(cc.p(0.5, 0))
	node_reward_1:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_reward_1)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(420)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_reward_1.lyt = lyt
	self:addChild(node_reward_1)
	self.node_reward_1 = node_reward_1

	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(280, 0)
	spr_bg:setContentSize(550, 250)
	spr_bg:setAnchorPoint(cc.p(0.5, 0))
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/cell-bg-12.png", capInsets = cc.rect(16,17,12,16)})
	node_reward_1:addChild(spr_bg)
	self.spr_bg = spr_bg

	local spr_parttern_1 = cc.Sprite:create()
	spr_parttern_1:setPosition(160, 270)
	spr_parttern_1:setContentSize(174, 9)
	spr_parttern_1:setScale(-1, 1)
	spr_parttern_1:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(2, spr_parttern_1, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/spr-line1.png")
	node_reward_1:addChild(spr_parttern_1)
	self.spr_parttern_1 = spr_parttern_1

	local spr_parttern_2 = cc.Sprite:create()
	spr_parttern_2:setPosition(400, 270)
	spr_parttern_2:setContentSize(174, 9)
	spr_parttern_2:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(2, spr_parttern_2, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/spr-line1.png")
	node_reward_1:addChild(spr_parttern_2)
	self.spr_parttern_2 = spr_parttern_2

	local lbl_reward_title_1 = cc.Label:createWithTTF(ex.Tools:getLang(57527),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_reward_title_1:setPosition(280, 270)
	lbl_reward_title_1:setContentSize(224, 29.2)
	lbl_reward_title_1:setTextColor(cc.c3b(241, 211, 139))
	lbl_reward_title_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_reward_title_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_reward_title_1:enableOutline(cc.c4b(87,56,29,255), 2)
	node_reward_1:addChild(lbl_reward_title_1)
	self.lbl_reward_title_1 = lbl_reward_title_1

	local lbl_tip_1 = cc.Label:createWithTTF(ex.Tools:getLang(57540),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_tip_1:setPosition(280, 80)
	lbl_tip_1:setContentSize(220, 25.2)
	lbl_tip_1:setTextColor(cc.c3b(122, 71, 45))
	lbl_tip_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_tip_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_reward_1:addChild(lbl_tip_1)
	self.lbl_tip_1 = lbl_tip_1

	local lbl_tip_2 = cc.Label:createWithTTF(ex.Tools:getLang(57541),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_tip_2:setPosition(280, 50)
	lbl_tip_2:setContentSize(220, 25.2)
	lbl_tip_2:setTextColor(cc.c3b(122, 71, 45))
	lbl_tip_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_tip_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_reward_1:addChild(lbl_tip_2)
	self.lbl_tip_2 = lbl_tip_2

	local menu_reward_1 = cpp.UIMenu:create()
	menu_reward_1:setPosition(280, 170)
	menu_reward_1:setContentSize(560, 120)
	menu_reward_1:setScale(0.75, 0.75)
	menu_reward_1:setAnchorPoint(cc.p(0.5, 0))
	menu_reward_1:setIgnoreAnchorPointForPosition(false)
	menu_reward_1:setAnchorPoint(cc.p(0.5, 0))
	menu_reward_1:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 10, false)
	ly.node = menu_reward_1
	menu_reward_1.layoutex = ly
	self:addLyt(ly)
	node_reward_1:addChild(menu_reward_1)
	self.menu_reward_1 = menu_reward_1

	local node_reward_2 = cc.Node:create()
	node_reward_2:setCascadeOpacityEnabled(true)
	node_reward_2:setPosition(310, 200)
	node_reward_2:setContentSize(560, 180)
	node_reward_2:setAnchorPoint(cc.p(0.5, 0))
	node_reward_2:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_reward_2)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(200)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_reward_2.lyt = lyt
	self:addChild(node_reward_2)
	self.node_reward_2 = node_reward_2

	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(280, 0)
	spr_bg:setContentSize(550, 140)
	spr_bg:setAnchorPoint(cc.p(0.5, 0))
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/cell-bg-12.png", capInsets = cc.rect(16,17,12,16)})
	node_reward_2:addChild(spr_bg)
	self.spr_bg = spr_bg

	local spr_parttern_1 = cc.Sprite:create()
	spr_parttern_1:setPosition(160, 160)
	spr_parttern_1:setContentSize(174, 9)
	spr_parttern_1:setScale(-1, 1)
	spr_parttern_1:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(2, spr_parttern_1, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/spr-line1.png")
	node_reward_2:addChild(spr_parttern_1)
	self.spr_parttern_1 = spr_parttern_1

	local spr_parttern_2 = cc.Sprite:create()
	spr_parttern_2:setPosition(400, 160)
	spr_parttern_2:setContentSize(174, 9)
	spr_parttern_2:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(2, spr_parttern_2, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/spr-line1.png")
	node_reward_2:addChild(spr_parttern_2)
	self.spr_parttern_2 = spr_parttern_2

	local lbl_reward_title_2 = cc.Label:createWithTTF(ex.Tools:getLang(57528),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_reward_title_2:setPosition(280, 160)
	lbl_reward_title_2:setContentSize(124, 29.2)
	lbl_reward_title_2:setTextColor(cc.c3b(241, 211, 139))
	lbl_reward_title_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_reward_title_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_reward_title_2:enableOutline(cc.c4b(87,56,29,255), 2)
	node_reward_2:addChild(lbl_reward_title_2)
	self.lbl_reward_title_2 = lbl_reward_title_2

	local menu_reward_2 = cpp.UIMenu:create()
	menu_reward_2:setPosition(280, 70)
	menu_reward_2:setContentSize(560, 120)
	menu_reward_2:setScale(0.75, 0.75)
	menu_reward_2:setAnchorPoint(cc.p(0.5, 0))
	menu_reward_2:setIgnoreAnchorPointForPosition(false)
	menu_reward_2:setAnchorPoint(cc.p(0.5, 0))
	menu_reward_2:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 10, false)
	ly.node = menu_reward_2
	menu_reward_2.layoutex = ly
	self:addLyt(ly)
	node_reward_2:addChild(menu_reward_2)
	self.menu_reward_2 = menu_reward_2

	local menu = cpp.UIMenu:create()
	menu:setCascadeOpacityEnabled(true)
	menu:setPosition(310, 0)
	menu:setContentSize(0, 0)
	menu:setAnchorPoint(cc.p(0.5, 0.5))
	menu:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	menu.lyt = lyt
	self:addChild(menu)
	self.menu = menu

	local btn_buy = cpp.UIMenuItemLabel:create("", nil, "--", nil)
	btn_buy:setPosition(0, 120)
	btn_buy:setContentSize(197, 60)
	btn_buy:registerScriptTapHandler(handler(self, self.onBuy))
	btn_buy:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_buy:setLabelOffset(cc.p(0, -2))
	btn_buy:setLabelSize(44)
	btn_buy:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	self:addLoadRes(3, btn_buy, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-buy-6.png"})
	menu:addChild(btn_buy)
	self.btn_buy = btn_buy

	 self:startLoadRes()
end
return MagicTowerKingUnlockLayer