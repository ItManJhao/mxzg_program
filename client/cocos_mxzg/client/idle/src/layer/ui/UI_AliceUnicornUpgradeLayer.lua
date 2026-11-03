local AliceUnicornUpgradeLayer = class("AliceUnicornUpgradeLayer", require("src.comp.CCCLayerBase")) 

function AliceUnicornUpgradeLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(640, 400)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
	local spr_bg = cc.Sprite:create()
	spr_bg:setPosition(320, 200)
	spr_bg:setContentSize(640, 400)
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

	local spr_wing = cc.Sprite:create()
	spr_wing:setPosition(320, 360)
	spr_wing:setContentSize(360, 200)
	spr_wing:setScale(1.16, 1)
	self:addLoadRes(2, spr_wing, "ccbi-res/battle-end-1.plist", "ccbi-res/battle-end-1.pvr.ccz", "battle-end/spr-wing-1.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_wing)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(-60)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	spr_wing.lyt = lyt
	self:addChild(spr_wing)
	self.spr_wing = spr_wing

	local spr_result = cc.Sprite:create()
	spr_result:setPosition(320, 351)
	spr_result:setContentSize(294, 118)
	spr_result:setScale(1.16, 1)
	self:addLoadRes(2, spr_result, "ccbi-res/battle-end-lang.plist", "ccbi-res/battle-end-lang.pvr.ccz", "battle-end-lang/lbl-result-7.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_result)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(-10)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	spr_result.lyt = lyt
	self:addChild(spr_result)
	self.spr_result = spr_result

	local node_unicorn = cc.Node:create()
	node_unicorn:setPosition(320, 230)
	node_unicorn:setContentSize(100, 100)
	node_unicorn:setAnchorPoint(cc.p(0.5, 0.5))
	node_unicorn:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_unicorn)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(180)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_unicorn.lyt = lyt
	self:addChild(node_unicorn)
	self.node_unicorn = node_unicorn

	local spr_unicorn = cc.Sprite:create()
	spr_unicorn:setPosition(50, 50)
	spr_unicorn:setContentSize(100, 100)
	node_unicorn:addChild(spr_unicorn)
	self.spr_unicorn = spr_unicorn

	local spr_unicorn_frame = cc.Sprite:create()
	spr_unicorn_frame:setPosition(50, 50)
	spr_unicorn_frame:setContentSize(100, 100)
	self:addLoadRes(2, spr_unicorn_frame, "ccbi-res/backpack-4.plist", "ccbi-res/backpack-4.pvr.ccz", "backpack/spr-frame.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_unicorn_frame)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_unicorn_frame.lyt = lyt
	node_unicorn:addChild(spr_unicorn_frame)
	self.spr_unicorn_frame = spr_unicorn_frame

	local lbl_unicorn_info = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_unicorn_info:setPosition(50, -20)
	lbl_unicorn_info:setContentSize(92, 31.72)
	lbl_unicorn_info:setTextColor(cc.c3b(248, 149, 33))
	lbl_unicorn_info:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_unicorn_info:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_unicorn_info:enableOutline(cc.c4b(34,23,20,255), 2)
	node_unicorn:addChild(lbl_unicorn_info)
	self.lbl_unicorn_info = lbl_unicorn_info

	local node_elem = cc.Node:create()
	node_elem:setPosition(320, 80)
	node_elem:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_elem)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(80)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_elem.lyt = lyt
	self:addChild(node_elem)
	self.node_elem = node_elem

	local spr_result = cc.Sprite:create()
	spr_result:setPosition(0, 0)
	spr_result:setContentSize(510, 72)
	spr_result:setScale(1.16, 1)
	self:addLoadRes(2, spr_result, "ccbi-res/battle-end-1.plist", "ccbi-res/battle-end-1.pvr.ccz", "battle-end/spr-title.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_result)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(-36)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	spr_result.lyt = lyt
	node_elem:addChild(spr_result)
	self.spr_result = spr_result

	local lbl_elem_title = cc.Label:createWithTTF(ex.Tools:getLang(580525),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_elem_title:setPosition(-10, 0)
	lbl_elem_title:setContentSize(132, 27.72)
	lbl_elem_title:setAnchorPoint(cc.p(1, 0.5))
	lbl_elem_title:setTextColor(cc.c3b(255, 230, 132))
	lbl_elem_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_elem_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_elem:addChild(lbl_elem_title)
	self.lbl_elem_title = lbl_elem_title

	local node_attr = cc.Node:create()
	node_attr:setPosition(120, 0)
	node_attr:setContentSize(190, 40)
	node_attr:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr:setIgnoreAnchorPointForPosition(false)
	node_elem:addChild(node_attr)
	self.node_attr = node_attr

	local spr_attr_bg = cc.Sprite:create()
	spr_attr_bg:setPosition(95, 20)
	spr_attr_bg:setContentSize(190, 40)
	self:addLoadRes(2, spr_attr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "win-bg/cell-bg-2.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_attr_bg)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_attr_bg.lyt = lyt
	node_attr:addChild(spr_attr_bg)
	self.spr_attr_bg = spr_attr_bg

	local spr_attr = cc.Sprite:create()
	spr_attr:setPosition(10, 20)
	spr_attr:setContentSize(66, 66)
	spr_attr:setScale(0.4, 0.4)
	spr_attr:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-100.png")
	node_attr:addChild(spr_attr)
	self.spr_attr = spr_attr

	local lbl_attr = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr:setPosition(45, 18)
	lbl_attr:setContentSize(84, 29.2)
	lbl_attr:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr:setTextColor(cc.c3b(253, 254, 192))
	lbl_attr:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr:addChild(lbl_attr)
	self.lbl_attr = lbl_attr

	local lbl_attr_extra = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra:setPosition(145, 18)
	lbl_attr_extra:setContentSize(84, 29.2)
	lbl_attr_extra:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra:setTextColor(cc.c3b(239, 209, 131))
	lbl_attr_extra:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_extra:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr:addChild(lbl_attr_extra)
	self.lbl_attr_extra = lbl_attr_extra

	 self:startLoadRes()
end
return AliceUnicornUpgradeLayer