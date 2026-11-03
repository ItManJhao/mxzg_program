local AliceBattleLogTeamCell = class("AliceBattleLogTeamCell", require("src.comp.CCCLayerBase")) 

function AliceBattleLogTeamCell:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(510, 120)
	self:setAnchorPoint(cc.p(0, 0))
	self:setIgnoreAnchorPointForPosition(false)
	local spr_cell_bg = cc.Scale9Sprite:create()
	spr_cell_bg:setPosition(255, 60)
	spr_cell_bg:setContentSize(510, 120)
	self:addLoadRes(1, spr_cell_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", {frame = "alice/block-2.png", capInsets = cc.rect(0,0,0,0)})
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

	local spr_title_bg = cc.Sprite:create()
	spr_title_bg:setPosition(258, 104)
	spr_title_bg:setContentSize(504, 32)
	self:addLoadRes(2, spr_title_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/block-1.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_title_bg)
	lyt:setLeftMargin(6)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	spr_title_bg.lyt = lyt
	self:addChild(spr_title_bg)
	self.spr_title_bg = spr_title_bg

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(580076),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_title:setPosition(255, 104)
	lbl_title:setContentSize(26.3, 27.72)
	lbl_title:setTextColor(cc.c3b(230, 199, 152))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_title)
	self.lbl_title = lbl_title

	local menu_item = require('src.comp.menu.UIMenuEx'):create()
	menu_item:setPosition(10, 40)
	menu_item:setContentSize(720, 80)
	menu_item:setScale(0.7, 0.7)
	menu_item:setAnchorPoint(cc.p(0, 0))
	menu_item:setSwallowsTouches(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 10, false)
	ly.node = menu_item
	menu_item.layoutex = ly
	self:addLyt(ly)
	self:addChild(menu_item)
	self.menu_item = menu_item

	 self:startLoadRes()
end
return AliceBattleLogTeamCell