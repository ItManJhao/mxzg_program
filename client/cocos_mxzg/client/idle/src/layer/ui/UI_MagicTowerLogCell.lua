local MagicTowerLogCell = class("MagicTowerLogCell", require("src.comp.CCCLayerBase")) 

function MagicTowerLogCell:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(540, 120)
	self:setAnchorPoint(cc.p(0, 0))
	self:setIgnoreAnchorPointForPosition(false)
	local spr_cell_bg = cc.Scale9Sprite:create()
	spr_cell_bg:setPosition(270, 60)
	spr_cell_bg:setContentSize(540, 120)
	self:addLoadRes(1, spr_cell_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/cell-bg-1.png", capInsets = cc.rect(13,12,13,13)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_cell_bg)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_cell_bg.lyt = lyt
	self:addChild(spr_cell_bg)
	self.spr_cell_bg = spr_cell_bg

	local spr_cell_bg_self = cc.Scale9Sprite:create()
	spr_cell_bg_self:setPosition(270, 60)
	spr_cell_bg_self:setContentSize(540, 120)
	spr_cell_bg_self:setVisible(false)
	self:addLoadRes(1, spr_cell_bg_self, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-28.png", capInsets = cc.rect(20,20,20,20)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_cell_bg_self)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_cell_bg_self.lyt = lyt
	self:addChild(spr_cell_bg_self)
	self.spr_cell_bg_self = spr_cell_bg_self

	local spr_photo = cc.Sprite:create()
	spr_photo:setPosition(80, 60)
	spr_photo:setContentSize(91, 91)
	spr_photo:setScale(0.6, 0.6)
	self:addLoadRes(2, spr_photo, "ccbi-res/head-icon-1.plist", "ccbi-res/head-icon-1.pvr.ccz", "head-icon/0.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_photo)
	self:addLyt(lyt)
	spr_photo.lyt = lyt
	self:addChild(spr_photo)
	self.spr_photo = spr_photo

	local spr_border = cc.Sprite:create()
	spr_border:setPosition(80, 60)
	spr_border:setContentSize(138, 138)
	spr_border:setScale(0.75, 0.75)
	self:addLoadRes(2, spr_border, "ccbi-res/backpack-4.plist", "ccbi-res/backpack-4.pvr.ccz", "backpack/1005017.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_border)
	self:addLyt(lyt)
	spr_border.lyt = lyt
	self:addChild(spr_border)
	self.spr_border = spr_border

	local node_tip = cc.Node:create()
	node_tip:setPosition(-10, 125)
	node_tip:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_tip)
	lyt:setLeftMargin(-10)
	lyt:setHorizontalEdge(1)
	lyt:setTopMargin(-5)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_tip.lyt = lyt
	self:addChild(node_tip)
	self.node_tip = node_tip

	local spr_rare = cc.Sprite:create()
	spr_rare:setPosition(0, 0)
	spr_rare:setContentSize(111, 45)
	spr_rare:setAnchorPoint(cc.p(0, 1))
	self:addLoadRes(2, spr_rare, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/mission-rare-1.png")
	node_tip:addChild(spr_rare)
	self.spr_rare = spr_rare

	local lbl_rare_tip = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 18)
	lbl_rare_tip:setPosition(50, -20)
	lbl_rare_tip:setContentSize(23.52, 24.68)
	lbl_rare_tip:setTextColor(cc.c3b(255, 255, 255))
	lbl_rare_tip:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_rare_tip:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_rare_tip:enableOutline(cc.c4b(0,0,0,255), 1)
	node_tip:addChild(lbl_rare_tip)
	self.lbl_rare_tip = lbl_rare_tip

	local lbl_name = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 24)
	lbl_name:setPosition(135, 80)
	lbl_name:setContentSize(28.69, 30.24)
	lbl_name:setAnchorPoint(cc.p(0, 0.5))
	lbl_name:setTextColor(cc.c3b(122, 71, 45))
	lbl_name:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_name:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_name)
	self.lbl_name = lbl_name

	local lbl_content = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_content:setPosition(135, 40)
	lbl_content:setContentSize(23.91, 25.2)
	lbl_content:setAnchorPoint(cc.p(0, 0.5))
	lbl_content:setTextColor(cc.c3b(223, 96, 33))
	lbl_content:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_content:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_content)
	self.lbl_content = lbl_content

	local menu = cpp.UIMenu:create()
	menu:setPosition(0, 0)
	menu:setContentSize(0, 0)
	menu:setAnchorPoint(cc.p(0.5, 0.5))
	menu:setIgnoreAnchorPointForPosition(false)
	self:addChild(menu)
	self.menu = menu

	local btn_battle = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_battle:setPosition(480, 60)
	btn_battle:setContentSize(102, 44)
	btn_battle:registerScriptTapHandler(handler(self, self.onBattle))
	btn_battle:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_battle:setLabelOffset(cc.p(0, -2))
	btn_battle:setLabelSize(48)
	btn_battle:setLabelOutLine(cc.c4b(122,71,45,255), 4)
	btn_battle:setLabelText(ex.Tools:getLang(1445))
	self:addLoadRes(3, btn_battle, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-orange-1.png"})
	menu:addChild(btn_battle)
	self.btn_battle = btn_battle

	local btn_share = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_share:setPosition(380, 60)
	btn_share:setContentSize(80, 41)
	btn_share:registerScriptTapHandler(handler(self, self.onBattleShare))
	btn_share:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_share:setLabelOffset(cc.p(0, -2))
	btn_share:setLabelSize(44)
	btn_share:setLabelOutLine(cc.c4b(137,93,47,255), 4)
	btn_share:setLabelText(ex.Tools:getLang(2124))
	self:addLoadRes(3, btn_share, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-share.png"})
	menu:addChild(btn_share)
	self.btn_share = btn_share

	 self:startLoadRes()
end
return MagicTowerLogCell