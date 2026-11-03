local MagicTowerBattleEndLayer = class("MagicTowerBattleEndLayer", require("src.comp.CCCLayerBase")) 

function MagicTowerBattleEndLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(620, 480)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
	self:setCascadeOpacityEnabled(true)
	self:setOpacity(0)
	self:runEnterAnim()
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(620, 480)
	spr_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(4, spr_bg, nil, "ccbi-res/map-bg-result-1.png")
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

	local node_title_win = cc.Node:create()
	node_title_win:setCascadeOpacityEnabled(true)
	node_title_win:setPosition(310, 480)
	node_title_win:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_title_win)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_title_win.lyt = lyt
	self:addChild(node_title_win)
	self.node_title_win = node_title_win

	local spr_title_bg = cc.Sprite:create()
	spr_title_bg:setPosition(-10, 0)
	spr_title_bg:setContentSize(546, 193)
	self:addLoadRes(2, spr_title_bg, "ccbi-res/battle-end-1.plist", "ccbi-res/battle-end-1.pvr.ccz", "battle-end/spr-wing-5.png")
	node_title_win:addChild(spr_title_bg)
	self.spr_title_bg = spr_title_bg

	local spr_title = cc.Sprite:create()
	spr_title:setPosition(0, -10)
	spr_title:setContentSize(262, 98)
	self:addLoadRes(2, spr_title, "ccbi-res/battle-end-lang.plist", "ccbi-res/battle-end-lang.pvr.ccz", "battle-end-lang/lbl-result-6.png")
	node_title_win:addChild(spr_title)
	self.spr_title = spr_title

	local node_title_lose = cc.Node:create()
	node_title_lose:setCascadeOpacityEnabled(true)
	node_title_lose:setPosition(310, 480)
	node_title_lose:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_title_lose)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_title_lose.lyt = lyt
	self:addChild(node_title_lose)
	self.node_title_lose = node_title_lose

	local spr_title_bg = cc.Sprite:create()
	spr_title_bg:setPosition(-10, 0)
	spr_title_bg:setContentSize(546, 193)
	self:addLoadRes(2, spr_title_bg, "ccbi-res/battle-end-1.plist", "ccbi-res/battle-end-1.pvr.ccz", "battle-end/spr-wing-4.png")
	node_title_lose:addChild(spr_title_bg)
	self.spr_title_bg = spr_title_bg

	local spr_title = cc.Sprite:create()
	spr_title:setPosition(0, -10)
	spr_title:setContentSize(262, 98)
	self:addLoadRes(2, spr_title, "ccbi-res/battle-end-lang.plist", "ccbi-res/battle-end-lang.pvr.ccz", "battle-end-lang/lbl-result-5.png")
	node_title_lose:addChild(spr_title)
	self.spr_title = spr_title

	local menu = cpp.UIMenu:create()
	menu:setCascadeOpacityEnabled(true)
	menu:setPosition(570, 480)
	menu:setContentSize(0, 0)
	menu:setSwallowsTouches(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu)
	lyt:setRightMargin(50)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	menu.lyt = lyt
	self:addChild(menu)
	self.menu = menu

	local btn_report = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_report:setPosition(0, -80)
	btn_report:setContentSize(66, 74)
	btn_report:registerScriptTapHandler(handler(self, self.onReport))
	btn_report:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_report:setLabelOffset(cc.p(0, -2))
	btn_report:setLabelSize(44)
	btn_report:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	self:addLoadRes(3, btn_report, "ccbi-res/common-ui.plist", "ccbi-res/common-ui.pvr.ccz", {spr1="button/btn-battle-detail.png"})
	menu:addChild(btn_report)
	self.btn_report = btn_report

	local node_win = cc.Node:create()
	node_win:setCascadeOpacityEnabled(true)
	node_win:setPosition(310, 160)
	node_win:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_win)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setPositionPercentYEnabled(true)
	lyt:setPositionPercentY(0.5)
	self:addLyt(lyt)
	node_win.lyt = lyt
	self:addChild(node_win)
	self.node_win = node_win

	local spr_win_icon = cc.Sprite:create()
	spr_win_icon:setPosition(-20, 0)
	spr_win_icon:setContentSize(382, 259)
	spr_win_icon:setAnchorPoint(cc.p(0.5, 0))
	self:addLoadRes(2, spr_win_icon, "ccbi-res/magic-tower.plist", "ccbi-res/magic-tower.pvr.ccz", "magic-tower/spr-battle-end-win.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_win_icon)
	self:addLyt(lyt)
	spr_win_icon.lyt = lyt
	node_win:addChild(spr_win_icon)
	self.spr_win_icon = spr_win_icon

	local node_title_win = cc.Node:create()
	node_title_win:setPosition(0, 0)
	node_title_win:setContentSize(0, 0)
	node_win:addChild(node_title_win)
	self.node_title_win = node_title_win

	local spr_photo = cc.Sprite:create()
	spr_photo:setPosition(0, 90)
	spr_photo:setContentSize(91, 91)
	spr_photo:setScale(0.6, 0.6)
	self:addLoadRes(2, spr_photo, "ccbi-res/head-icon-1.plist", "ccbi-res/head-icon-1.pvr.ccz", "head-icon/0.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_photo)
	self:addLyt(lyt)
	spr_photo.lyt = lyt
	node_win:addChild(spr_photo)
	self.spr_photo = spr_photo

	local spr_border = cc.Sprite:create()
	spr_border:setPosition(0, 90)
	spr_border:setContentSize(138, 138)
	spr_border:setScale(0.75, 0.75)
	self:addLoadRes(2, spr_border, "ccbi-res/backpack-4.plist", "ccbi-res/backpack-4.pvr.ccz", "backpack/1005017.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_border)
	self:addLyt(lyt)
	spr_border.lyt = lyt
	node_win:addChild(spr_border)
	self.spr_border = spr_border

	local lbl_name = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_name:setPosition(0, 40)
	lbl_name:setContentSize(30.3, 31.72)
	lbl_name:setTextColor(cc.c3b(255, 255, 255))
	lbl_name:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_name:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_name:enableOutline(cc.c4b(26,20,39,255), 2)
	node_win:addChild(lbl_name)
	self.lbl_name = lbl_name

	local spr_star_1 = cc.Sprite:create()
	spr_star_1:setPosition(-30, 12)
	spr_star_1:setContentSize(38, 38)
	spr_star_1:setScale(0.6, 0.6)
	self:addLoadRes(2, spr_star_1, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/star-0.png")
	node_win:addChild(spr_star_1)
	self.spr_star_1 = spr_star_1

	local spr_star_2 = cc.Sprite:create()
	spr_star_2:setPosition(0, 12)
	spr_star_2:setContentSize(38, 38)
	spr_star_2:setScale(0.6, 0.6)
	self:addLoadRes(2, spr_star_2, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/star-0.png")
	node_win:addChild(spr_star_2)
	self.spr_star_2 = spr_star_2

	local spr_star_3 = cc.Sprite:create()
	spr_star_3:setPosition(30, 12)
	spr_star_3:setContentSize(38, 38)
	spr_star_3:setScale(0.6, 0.6)
	self:addLoadRes(2, spr_star_3, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/star-0.png")
	node_win:addChild(spr_star_3)
	self.spr_star_3 = spr_star_3

	local spr_tip_bg = cc.Sprite:create()
	spr_tip_bg:setPosition(0, -80)
	spr_tip_bg:setContentSize(79, 50)
	spr_tip_bg:setScale(6, 1)
	self:addLoadRes(2, spr_tip_bg, "ccbi-res/magic-tower.plist", "ccbi-res/magic-tower.pvr.ccz", "magic-tower/spr-tip-bg.png")
	node_win:addChild(spr_tip_bg)
	self.spr_tip_bg = spr_tip_bg

	local lbl_tip = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_tip:setPosition(0, -80)
	lbl_tip:setContentSize(30.3, 31.72)
	lbl_tip:setTextColor(cc.c3b(255, 255, 255))
	lbl_tip:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_tip:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_tip:enableOutline(cc.c4b(26,20,39,255), 2)
	node_win:addChild(lbl_tip)
	self.lbl_tip = lbl_tip

	local node_lose = cc.Node:create()
	node_lose:setPosition(310, 190)
	node_lose:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_lose)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setPositionPercentYEnabled(true)
	lyt:setPositionPercentY(0.5)
	self:addLyt(lyt)
	node_lose.lyt = lyt
	self:addChild(node_lose)
	self.node_lose = node_lose

	 self:startLoadRes()
end
return MagicTowerBattleEndLayer