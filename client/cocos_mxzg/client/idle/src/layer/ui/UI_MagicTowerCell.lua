local MagicTowerCell = class("MagicTowerCell", require("src.comp.CCCLayerBase")) 

function MagicTowerCell:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(430, 166)
	self:setAnchorPoint(cc.p(0, 0))
	self:setIgnoreAnchorPointForPosition(false)
	local node_flag = cc.Sprite:create()
	node_flag:setPosition(104, 50)
	node_flag:setContentSize(207, 198)
	self:addLoadRes(2, node_flag, "ccbi-res/magic-tower.plist", "ccbi-res/magic-tower.pvr.ccz", "magic-tower/spr-flag.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_flag)
	self:addLyt(lyt)
	node_flag.lyt = lyt
	self:addChild(node_flag)
	self.node_flag = node_flag

	local spr_photo = cc.Sprite:create()
	spr_photo:setPosition(87.5, 99)
	spr_photo:setContentSize(91, 91)
	spr_photo:setScale(0.6, 0.6)
	self:addLoadRes(2, spr_photo, "ccbi-res/head-icon-1.plist", "ccbi-res/head-icon-1.pvr.ccz", "head-icon/0.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_photo)
	self:addLyt(lyt)
	spr_photo.lyt = lyt
	node_flag:addChild(spr_photo)
	self.spr_photo = spr_photo

	local spr_border = cc.Sprite:create()
	spr_border:setPosition(87.5, 99)
	spr_border:setContentSize(138, 138)
	spr_border:setScale(0.75, 0.75)
	self:addLoadRes(2, spr_border, "ccbi-res/backpack-4.plist", "ccbi-res/backpack-4.pvr.ccz", "backpack/1005017.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_border)
	self:addLyt(lyt)
	spr_border.lyt = lyt
	node_flag:addChild(spr_border)
	self.spr_border = spr_border

	local lbl_name = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 16)
	lbl_name:setPosition(87.5, 59)
	lbl_name:setContentSize(23.13, 24.16)
	lbl_name:setTextColor(cc.c3b(255, 0, 0))
	lbl_name:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_name:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_name:enableOutline(cc.c4b(255,255,255,255), 2)
	node_flag:addChild(lbl_name)
	self.lbl_name = lbl_name

	local menu_challenger = cpp.UIMenu:create()
	menu_challenger:setPosition(87.5, 29)
	menu_challenger:setContentSize(0, 0)
	menu_challenger:setAnchorPoint(cc.p(0.5, 0.5))
	menu_challenger:setIgnoreAnchorPointForPosition(false)
	node_flag:addChild(menu_challenger)
	self.menu_challenger = menu_challenger

	local btn_challenge = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_challenge:setPosition(0, 0)
	btn_challenge:setContentSize(229, 65)
	btn_challenge:setScale(0.5, 0.5)
	btn_challenge:registerScriptTapHandler(handler(self, self.onChallenger))
	btn_challenge:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_challenge:setLabelOffset(cc.p(0, -2))
	btn_challenge:setLabelSize(64)
	btn_challenge:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	btn_challenge:setLabelText(ex.Tools:getLang(57514))
	self:addLoadRes(3, btn_challenge, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-super-gift-2.png"})
	menu_challenger:addChild(btn_challenge)
	self.btn_challenge = btn_challenge

	local btn_photo = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_photo:setPosition(0, 70)
	btn_photo:setContentSize(60, 60)
	btn_photo:registerScriptTapHandler(handler(self, self.onPhoto))
	menu_challenger:addChild(btn_photo)
	self.btn_photo = btn_photo

	local node_stage_info = cc.Sprite:create()
	node_stage_info:setPosition(296, 83)
	node_stage_info:setContentSize(262, 166)
	self:addLoadRes(2, node_stage_info, "ccbi-res/magic-tower.plist", "ccbi-res/magic-tower.pvr.ccz", "magic-tower/spr-stage-bg-2.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_stage_info)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_stage_info.lyt = lyt
	self:addChild(node_stage_info)
	self.node_stage_info = node_stage_info

	local menu_stage = cpp.UIMenu:create()
	menu_stage:setPosition(131, 83)
	menu_stage:setContentSize(262, 166)
	menu_stage:setAnchorPoint(cc.p(0.5, 0.5))
	menu_stage:setIgnoreAnchorPointForPosition(false)
	menu_stage:setAnchorPoint(cc.p(0.5, 0.5))
	menu_stage:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu_stage)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	menu_stage.lyt = lyt
	node_stage_info:addChild(menu_stage)
	self.menu_stage = menu_stage

	local btn_stage = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_stage:setPosition(131, 83)
	btn_stage:setContentSize(262, 166)
	btn_stage:registerScriptTapHandler(handler(self, self.onStage))
	local lyt = ccui.LayoutComponent:bindLayoutComponent(btn_stage)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	btn_stage.lyt = lyt
	menu_stage:addChild(btn_stage)
	self.btn_stage = btn_stage

	local lbl_stage_name = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_stage_name:setPosition(131, 143)
	lbl_stage_name:setContentSize(30.3, 31.72)
	lbl_stage_name:setTextColor(cc.c3b(255, 255, 255))
	lbl_stage_name:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_stage_name:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_stage_name:enableOutline(cc.c4b(120,81,68,255), 2)
	node_stage_info:addChild(lbl_stage_name)
	self.lbl_stage_name = lbl_stage_name

	local spr_star_bg_1 = cc.Sprite:create()
	spr_star_bg_1:setPosition(101, 108)
	spr_star_bg_1:setContentSize(38, 38)
	spr_star_bg_1:setScale(0.75, 0.75)
	self:addLoadRes(2, spr_star_bg_1, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/star-bg.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_star_bg_1)
	lyt:setRightMargin(146.75)
	lyt:setHorizontalEdge(2)
	self:addLyt(lyt)
	spr_star_bg_1.lyt = lyt
	node_stage_info:addChild(spr_star_bg_1)
	self.spr_star_bg_1 = spr_star_bg_1

	local spr_star_1 = cc.Sprite:create()
	spr_star_1:setPosition(101, 108)
	spr_star_1:setContentSize(38, 38)
	spr_star_1:setScale(0.75, 0.75)
	spr_star_1:setVisible(false)
	self:addLoadRes(2, spr_star_1, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/star-0.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_star_1)
	lyt:setRightMargin(146.75)
	lyt:setHorizontalEdge(2)
	self:addLyt(lyt)
	spr_star_1.lyt = lyt
	node_stage_info:addChild(spr_star_1)
	self.spr_star_1 = spr_star_1

	local spr_star_bg_2 = cc.Sprite:create()
	spr_star_bg_2:setPosition(131, 108)
	spr_star_bg_2:setContentSize(38, 38)
	spr_star_bg_2:setScale(0.75, 0.75)
	self:addLoadRes(2, spr_star_bg_2, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/star-bg.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_star_bg_2)
	lyt:setRightMargin(116.75)
	lyt:setHorizontalEdge(2)
	self:addLyt(lyt)
	spr_star_bg_2.lyt = lyt
	node_stage_info:addChild(spr_star_bg_2)
	self.spr_star_bg_2 = spr_star_bg_2

	local spr_star_2 = cc.Sprite:create()
	spr_star_2:setPosition(131, 108)
	spr_star_2:setContentSize(38, 38)
	spr_star_2:setScale(0.75, 0.75)
	spr_star_2:setVisible(false)
	self:addLoadRes(2, spr_star_2, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/star-0.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_star_2)
	lyt:setRightMargin(116.75)
	lyt:setHorizontalEdge(2)
	self:addLyt(lyt)
	spr_star_2.lyt = lyt
	node_stage_info:addChild(spr_star_2)
	self.spr_star_2 = spr_star_2

	local spr_star_bg_3 = cc.Sprite:create()
	spr_star_bg_3:setPosition(161, 108)
	spr_star_bg_3:setContentSize(38, 38)
	spr_star_bg_3:setScale(0.75, 0.75)
	self:addLoadRes(2, spr_star_bg_3, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/star-bg.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_star_bg_3)
	lyt:setRightMargin(86.75)
	lyt:setHorizontalEdge(2)
	self:addLyt(lyt)
	spr_star_bg_3.lyt = lyt
	node_stage_info:addChild(spr_star_bg_3)
	self.spr_star_bg_3 = spr_star_bg_3

	local spr_star_3 = cc.Sprite:create()
	spr_star_3:setPosition(161, 108)
	spr_star_3:setContentSize(38, 38)
	spr_star_3:setScale(0.75, 0.75)
	spr_star_3:setVisible(false)
	self:addLoadRes(2, spr_star_3, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/star-0.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_star_3)
	lyt:setRightMargin(86.75)
	lyt:setHorizontalEdge(2)
	self:addLyt(lyt)
	spr_star_3.lyt = lyt
	node_stage_info:addChild(spr_star_3)
	self.spr_star_3 = spr_star_3

	 self:startLoadRes()
end
return MagicTowerCell