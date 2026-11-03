local AliceUnicornElemInfoLayer = class("AliceUnicornElemInfoLayer", require("src.comp.CCCLayerBase")) 

function AliceUnicornElemInfoLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(360, 380)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(360, 380)
	spr_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/win-bg-3.png", capInsets = cc.rect(17,16,18,18)})
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

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(580525),FONT_DEFAULT_NAME_BOLD, 44)
	lbl_title:setPosition(180, 340)
	lbl_title:setContentSize(264, 55.44)
	lbl_title:setScale(0.5, 0.5)
	lbl_title:setTextColor(cc.c3b(249, 243, 224))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_title)
	self.lbl_title = lbl_title

	local spr_line = cc.Sprite:create()
	spr_line:setPosition(180, 310)
	spr_line:setContentSize(282, 5)
	spr_line:setScale(1.16, 1)
	self:addLoadRes(2, spr_line, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-line-2.png")
	self:addChild(spr_line)
	self.spr_line = spr_line

	local node_elem = cc.Node:create()
	node_elem:setPosition(180, 155)
	node_elem:setContentSize(320, 290)
	node_elem:setAnchorPoint(cc.p(0.5, 0.5))
	node_elem:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_elem)
	lyt:setLeftMargin(20)
	lyt:setRightMargin(20)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(80)
	lyt:setBottomMargin(10)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	node_elem.lyt = lyt
	self:addChild(node_elem)
	self.node_elem = node_elem

	 self:startLoadRes()
end
return AliceUnicornElemInfoLayer