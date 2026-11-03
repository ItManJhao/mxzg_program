local MagicTowerStarSelectCell = class("MagicTowerStarSelectCell", require("src.comp.CCCLayerBase")) 

function MagicTowerStarSelectCell:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(213, 60)
	self:setAnchorPoint(cc.p(0, 0))
	self:setIgnoreAnchorPointForPosition(false)
	local spr_cell_bg = cc.Scale9Sprite:create()
	spr_cell_bg:setPosition(106.5, 30)
	spr_cell_bg:setContentSize(213, 60)
	self:addLoadRes(1, spr_cell_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "button/btn-rect-5.png", capInsets = cc.rect(0,0,0,0)})
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

	local lbl_name = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_name:setPosition(106.5, 30)
	lbl_name:setContentSize(25.91, 27.2)
	lbl_name:setTextColor(cc.c3b(255, 255, 255))
	lbl_name:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_name:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_name:enableOutline(cc.c4b(0,0,0,255), 1)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_name)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setPositionPercentYEnabled(true)
	lyt:setPositionPercentY(0.5)
	self:addLyt(lyt)
	lbl_name.lyt = lyt
	self:addChild(lbl_name)
	self.lbl_name = lbl_name

	 self:startLoadRes()
end
return MagicTowerStarSelectCell