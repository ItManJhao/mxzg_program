local MagicTowerRewardCell = class("MagicTowerRewardCell", require("src.comp.CCCLayerBase")) 

function MagicTowerRewardCell:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(550, 155)
	self:setAnchorPoint(cc.p(0, 0))
	self:setIgnoreAnchorPointForPosition(false)
	local spr_cell_bg = cc.Scale9Sprite:create()
	spr_cell_bg:setPosition(275, 77.5)
	spr_cell_bg:setContentSize(550, 155)
	self:addLoadRes(1, spr_cell_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/cell-bg-14.png", capInsets = cc.rect(38,60,38,46)})
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

	local lbl_title = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 24)
	lbl_title:setPosition(40, 130)
	lbl_title:setContentSize(28.69, 30.24)
	lbl_title:setAnchorPoint(cc.p(0, 0.5))
	lbl_title:setTextColor(cc.c3b(122, 71, 45))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_title)
	self.lbl_title = lbl_title

	local spr_progress_bg = cc.Sprite:create()
	spr_progress_bg:setPosition(475, 85)
	spr_progress_bg:setContentSize(126, 20)
	spr_progress_bg:setScale(0.75, 0.75)
	self:addLoadRes(2, spr_progress_bg, "ccbi-res/achievement.plist", "ccbi-res/achievement.pvr.ccz", "achievement/item-progress-bg.png")
	self:addChild(spr_progress_bg)
	self.spr_progress_bg = spr_progress_bg

	local lbl_progress = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_progress:setPosition(475, 85)
	lbl_progress:setContentSize(25.91, 27.2)
	lbl_progress:setTextColor(cc.c3b(255, 255, 255))
	lbl_progress:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_progress:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_progress:enableOutline(cc.c4b(0,0,0,255), 1)
	self:addChild(lbl_progress)
	self.lbl_progress = lbl_progress

	local menu_item = require('src.comp.menu.UIMenuEx'):create()
	menu_item:setPosition(40, 55)
	menu_item:setContentSize(360, 80)
	menu_item:setScale(0.75, 0.75)
	menu_item:setAnchorPoint(cc.p(0, 0))
	menu_item:setSwallowsTouches(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 10, false)
	ly.node = menu_item
	menu_item.layoutex = ly
	self:addLyt(ly)
	self:addChild(menu_item)
	self.menu_item = menu_item

	local menu = require('src.comp.menu.UIMenuEx'):create()
	menu:setPosition(0, 0)
	menu:setContentSize(0, 0)
	menu:setAnchorPoint(cc.p(0.5, 0.5))
	menu:setIgnoreAnchorPointForPosition(false)
	menu:setSwallowsTouches(false)
	self:addChild(menu)
	self.menu = menu

	local btn_confirm = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_confirm:setPosition(475, 45)
	btn_confirm:setContentSize(102, 44)
	btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
	btn_confirm:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_confirm:setLabelOffset(cc.p(0, -2))
	btn_confirm:setLabelSize(44)
	btn_confirm:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	btn_confirm:setLabelText(ex.Tools:getLang(5675))
	self:addLoadRes(3, btn_confirm, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-orange-1.png"})
	menu:addChild(btn_confirm)
	self.btn_confirm = btn_confirm

	local btn_go = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_go:setPosition(475, 45)
	btn_go:setContentSize(102, 44)
	btn_go:registerScriptTapHandler(handler(self, self.onGo))
	btn_go:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_go:setLabelOffset(cc.p(0, -2))
	btn_go:setLabelSize(44)
	btn_go:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	btn_go:setLabelText(ex.Tools:getLang(57525))
	self:addLoadRes(3, btn_go, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-green-1.png"})
	menu:addChild(btn_go)
	self.btn_go = btn_go

	local spr_complete = cc.Sprite:create()
	spr_complete:setPosition(475, 45)
	spr_complete:setContentSize(50, 40)
	spr_complete:setScale(0.75, 0.75)
	self:addLoadRes(2, spr_complete, "ccbi-res/magic-tower.plist", "ccbi-res/magic-tower.pvr.ccz", "magic-tower/spr-check.png")
	self:addChild(spr_complete)
	self.spr_complete = spr_complete

	local spr_unlock = cc.Sprite:create()
	spr_unlock:setPosition(475, 45)
	spr_unlock:setContentSize(120, 46)
	self:addLoadRes(2, spr_unlock, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/spr-unlock-bg.png")
	self:addChild(spr_unlock)
	self.spr_unlock = spr_unlock

	local lbl_unlock = cc.Label:createWithTTF(ex.Tools:getLang(57523),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_unlock:setPosition(60, 23)
	lbl_unlock:setContentSize(28.3, 29.72)
	lbl_unlock:setTextColor(cc.c3b(255, 0, 0))
	lbl_unlock:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_unlock:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_unlock:enableOutline(cc.c4b(0,0,0,255), 1)
	spr_unlock:addChild(lbl_unlock)
	self.lbl_unlock = lbl_unlock

	 self:startLoadRes()
end
return MagicTowerRewardCell