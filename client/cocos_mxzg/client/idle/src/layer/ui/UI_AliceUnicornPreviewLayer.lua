local AliceUnicornPreviewLayer = class("AliceUnicornPreviewLayer", require("src.comp.CCCLayerBase")) 

function AliceUnicornPreviewLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(480, 720)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(480, 720)
	spr_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/win-bg-12.png", capInsets = cc.rect(14,15,14,12)})
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

	local node_info = cc.Node:create()
	node_info:setPosition(240, 750)
	node_info:setContentSize(0, 0)
	node_info:setScale(0.8, 0.8)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_info)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(-30)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_info.lyt = lyt
	self:addChild(node_info)
	self.node_info = node_info

	local spr_unicorn_type = cc.Sprite:create()
	spr_unicorn_type:setPosition(0, -300)
	spr_unicorn_type:setContentSize(543, 479)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_unicorn_type)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(60.5)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	spr_unicorn_type.lyt = lyt
	node_info:addChild(spr_unicorn_type)
	self.spr_unicorn_type = spr_unicorn_type

	local lbl_info_tip = cc.Label:createWithTTF(ex.Tools:getLang(580514),FONT_DEFAULT_NAME_BOLD, 18)
	lbl_info_tip:setPosition(0, -510)
	lbl_info_tip:setContentSize(25.52, 44.68)
	lbl_info_tip:setTextColor(cc.c3b(253, 252, 224))
	lbl_info_tip:enableOutline(cc.c4b(87,56,29,255), 2)
	node_info:addChild(lbl_info_tip)
	self.lbl_info_tip = lbl_info_tip

	local node_name = cc.Node:create()
	node_name:setPosition(0, -75)
	node_name:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_name)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(75)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_name.lyt = lyt
	node_info:addChild(node_name)
	self.node_name = node_name

	local spr_name_bg = cc.Scale9Sprite:create()
	spr_name_bg:setPosition(0, 0)
	spr_name_bg:setContentSize(262, 70)
	spr_name_bg:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(1, spr_name_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-23.png", capInsets = cc.rect(0,0,0,0)})
	node_name:addChild(spr_name_bg)
	self.spr_name_bg = spr_name_bg

	local lbl_name = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_name:setPosition(0, -20)
	lbl_name:setContentSize(84, 29.2)
	lbl_name:setTextColor(cc.c3b(253, 252, 224))
	lbl_name:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_name:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_name:enableOutline(cc.c4b(87,56,29,255), 2)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_name)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	lbl_name.lyt = lyt
	node_name:addChild(lbl_name)
	self.lbl_name = lbl_name

	local lbl_grade = cc.Label:createWithTTF("零阶+2",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_grade:setPosition(0, -50)
	lbl_grade:setContentSize(67.36, 29.2)
	lbl_grade:setTextColor(cc.c3b(253, 252, 224))
	lbl_grade:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_grade:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_grade:enableOutline(cc.c4b(87,56,29,255), 2)
	node_name:addChild(lbl_grade)
	self.lbl_grade = lbl_grade

	local node_equip = cc.Node:create()
	node_equip:setPosition(0, 0)
	node_equip:setContentSize(0, 0)
	node_info:addChild(node_equip)
	self.node_equip = node_equip

	local node_equip_1 = cc.Node:create()
	node_equip_1:setPosition(-200, -380)
	node_equip_1:setContentSize(0, 0)
	node_equip:addChild(node_equip_1)
	self.node_equip_1 = node_equip_1

	local spr_equip_bg = cc.Sprite:create()
	spr_equip_bg:setPosition(0, 0)
	spr_equip_bg:setContentSize(124, 127)
	self:addLoadRes(2, spr_equip_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-equip-bg.png")
	node_equip_1:addChild(spr_equip_bg)
	self.spr_equip_bg = spr_equip_bg

	local spr_equip_1 = cc.Sprite:create()
	spr_equip_1:setPosition(0, 0)
	spr_equip_1:setContentSize(98, 92)
	self:addLoadRes(2, spr_equip_1, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-equip-1.png")
	node_equip_1:addChild(spr_equip_1)
	self.spr_equip_1 = spr_equip_1

	local lbl_equip_strenthen_1 = cc.Label:createWithTTF("+0",FONT_DEFAULT_NAME_BOLD, 24)
	lbl_equip_strenthen_1:setPosition(5, -30)
	lbl_equip_strenthen_1:setContentSize(32.03, 34.24)
	lbl_equip_strenthen_1:setAnchorPoint(cc.p(0, 0.5))
	lbl_equip_strenthen_1:setTextColor(cc.c3b(249, 243, 224))
	lbl_equip_strenthen_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_equip_strenthen_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_equip_strenthen_1:enableOutline(cc.c4b(68,32,11,255), 2)
	node_equip_1:addChild(lbl_equip_strenthen_1)
	self.lbl_equip_strenthen_1 = lbl_equip_strenthen_1

	local node_equip_2 = cc.Node:create()
	node_equip_2:setPosition(-70, -430)
	node_equip_2:setContentSize(0, 0)
	node_equip:addChild(node_equip_2)
	self.node_equip_2 = node_equip_2

	local spr_equip_bg = cc.Sprite:create()
	spr_equip_bg:setPosition(0, 0)
	spr_equip_bg:setContentSize(124, 127)
	self:addLoadRes(2, spr_equip_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-equip-bg.png")
	node_equip_2:addChild(spr_equip_bg)
	self.spr_equip_bg = spr_equip_bg

	local spr_equip_2 = cc.Sprite:create()
	spr_equip_2:setPosition(0, 0)
	spr_equip_2:setContentSize(100, 100)
	self:addLoadRes(2, spr_equip_2, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-equip-2.png")
	node_equip_2:addChild(spr_equip_2)
	self.spr_equip_2 = spr_equip_2

	local lbl_equip_strenthen_2 = cc.Label:createWithTTF("+0",FONT_DEFAULT_NAME_BOLD, 24)
	lbl_equip_strenthen_2:setPosition(5, -30)
	lbl_equip_strenthen_2:setContentSize(32.03, 34.24)
	lbl_equip_strenthen_2:setAnchorPoint(cc.p(0, 0.5))
	lbl_equip_strenthen_2:setTextColor(cc.c3b(249, 243, 224))
	lbl_equip_strenthen_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_equip_strenthen_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_equip_strenthen_2:enableOutline(cc.c4b(68,32,11,255), 2)
	node_equip_2:addChild(lbl_equip_strenthen_2)
	self.lbl_equip_strenthen_2 = lbl_equip_strenthen_2

	local node_equip_3 = cc.Node:create()
	node_equip_3:setPosition(70, -430)
	node_equip_3:setContentSize(0, 0)
	node_equip:addChild(node_equip_3)
	self.node_equip_3 = node_equip_3

	local spr_equip_bg = cc.Sprite:create()
	spr_equip_bg:setPosition(0, 0)
	spr_equip_bg:setContentSize(124, 127)
	self:addLoadRes(2, spr_equip_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-equip-bg.png")
	node_equip_3:addChild(spr_equip_bg)
	self.spr_equip_bg = spr_equip_bg

	local spr_equip_3 = cc.Sprite:create()
	spr_equip_3:setPosition(0, 0)
	spr_equip_3:setContentSize(100, 94)
	self:addLoadRes(2, spr_equip_3, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-equip-3.png")
	node_equip_3:addChild(spr_equip_3)
	self.spr_equip_3 = spr_equip_3

	local lbl_equip_strenthen_3 = cc.Label:createWithTTF("+0",FONT_DEFAULT_NAME_BOLD, 24)
	lbl_equip_strenthen_3:setPosition(5, -30)
	lbl_equip_strenthen_3:setContentSize(32.03, 34.24)
	lbl_equip_strenthen_3:setAnchorPoint(cc.p(0, 0.5))
	lbl_equip_strenthen_3:setTextColor(cc.c3b(249, 243, 224))
	lbl_equip_strenthen_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_equip_strenthen_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_equip_strenthen_3:enableOutline(cc.c4b(68,32,11,255), 2)
	node_equip_3:addChild(lbl_equip_strenthen_3)
	self.lbl_equip_strenthen_3 = lbl_equip_strenthen_3

	local node_equip_4 = cc.Node:create()
	node_equip_4:setPosition(200, -380)
	node_equip_4:setContentSize(0, 0)
	node_equip:addChild(node_equip_4)
	self.node_equip_4 = node_equip_4

	local spr_equip_bg = cc.Sprite:create()
	spr_equip_bg:setPosition(0, 0)
	spr_equip_bg:setContentSize(124, 127)
	self:addLoadRes(2, spr_equip_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-equip-bg.png")
	node_equip_4:addChild(spr_equip_bg)
	self.spr_equip_bg = spr_equip_bg

	local spr_equip_4 = cc.Sprite:create()
	spr_equip_4:setPosition(0, 0)
	spr_equip_4:setContentSize(81, 100)
	self:addLoadRes(2, spr_equip_4, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-equip-4.png")
	node_equip_4:addChild(spr_equip_4)
	self.spr_equip_4 = spr_equip_4

	local lbl_equip_strenthen_4 = cc.Label:createWithTTF("+0",FONT_DEFAULT_NAME_BOLD, 24)
	lbl_equip_strenthen_4:setPosition(5, -30)
	lbl_equip_strenthen_4:setContentSize(32.03, 34.24)
	lbl_equip_strenthen_4:setAnchorPoint(cc.p(0, 0.5))
	lbl_equip_strenthen_4:setTextColor(cc.c3b(249, 243, 224))
	lbl_equip_strenthen_4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_equip_strenthen_4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_equip_strenthen_4:enableOutline(cc.c4b(68,32,11,255), 2)
	node_equip_4:addChild(lbl_equip_strenthen_4)
	self.lbl_equip_strenthen_4 = lbl_equip_strenthen_4

	local spr_equip_select = cc.Sprite:create()
	spr_equip_select:setPosition(-200, -380)
	spr_equip_select:setContentSize(142, 157)
	node_equip:addChild(spr_equip_select)
	self.spr_equip_select = spr_equip_select

	local menu = cpp.UIMenu:create()
	menu:setPosition(240, 0)
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

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(190, 720)
	btn_close:setContentSize(55, 58)
	btn_close:setScale(0.8, 0.8)
	btn_close:setAnchorPoint(cc.p(0.5, 1))
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-1.png", spr2="button/btn-close-1.png"})
	menu:addChild(btn_close)
	self.btn_close = btn_close

	local node_elem = cc.Node:create()
	node_elem:setPosition(240, 310)
	node_elem:setContentSize(0, 0)
	node_elem:setScale(0.8, 0.8)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_elem)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	node_elem.lyt = lyt
	self:addChild(node_elem)
	self.node_elem = node_elem

	local spr_cell_bg = cc.Sprite:create()
	spr_cell_bg:setPosition(0, -78)
	spr_cell_bg:setContentSize(543, 156)
	self:addLoadRes(2, spr_cell_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-cell-bg-1.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_cell_bg)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	spr_cell_bg.lyt = lyt
	node_elem:addChild(spr_cell_bg)
	self.spr_cell_bg = spr_cell_bg

	local lbl_title_1 = cc.Label:createWithTTF(ex.Tools:getLang(580515),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_title_1:setPosition(-210, -22)
	lbl_title_1:setContentSize(92, 31.72)
	lbl_title_1:setTextColor(cc.c3b(253, 252, 224))
	lbl_title_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title_1:enableOutline(cc.c4b(68,32,11,255), 2)
	node_elem:addChild(lbl_title_1)
	self.lbl_title_1 = lbl_title_1

	local node_attr_base_1 = cc.Node:create()
	node_attr_base_1:setPosition(-251.76, -78.13)
	node_attr_base_1:setContentSize(0, 0)
	node_elem:addChild(node_attr_base_1)
	self.node_attr_base_1 = node_attr_base_1

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(20, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_base_1:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_base_1 = cc.Sprite:create()
	spr_attr_base_1:setPosition(0, 0)
	spr_attr_base_1:setContentSize(66, 66)
	spr_attr_base_1:setScale(0.75, 0.75)
	spr_attr_base_1:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_base_1, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-100.png")
	node_attr_base_1:addChild(spr_attr_base_1)
	self.spr_attr_base_1 = spr_attr_base_1

	local lbl_attr_base_1 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_base_1:setPosition(60, 0)
	lbl_attr_base_1:setContentSize(84, 29.2)
	lbl_attr_base_1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_base_1:setTextColor(cc.c3b(253, 252, 224))
	lbl_attr_base_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_base_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_base_1:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_base_1:addChild(lbl_attr_base_1)
	self.lbl_attr_base_1 = lbl_attr_base_1

	local lbl_attr_base_extra_1 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_base_extra_1:setPosition(60, 0)
	lbl_attr_base_extra_1:setContentSize(80, 25.2)
	lbl_attr_base_extra_1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_base_extra_1:setVisible(false)
	lbl_attr_base_extra_1:setTextColor(cc.c3b(255, 226, 124))
	lbl_attr_base_extra_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_base_extra_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_base_extra_1:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_base_1:addChild(lbl_attr_base_extra_1)
	self.lbl_attr_base_extra_1 = lbl_attr_base_extra_1

	local node_attr_base_2 = cc.Node:create()
	node_attr_base_2:setPosition(20, -78.13)
	node_attr_base_2:setContentSize(0, 0)
	node_elem:addChild(node_attr_base_2)
	self.node_attr_base_2 = node_attr_base_2

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(20, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_base_2:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_base_2 = cc.Sprite:create()
	spr_attr_base_2:setPosition(0, 0)
	spr_attr_base_2:setContentSize(66, 66)
	spr_attr_base_2:setScale(0.75, 0.75)
	spr_attr_base_2:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_base_2, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-100.png")
	node_attr_base_2:addChild(spr_attr_base_2)
	self.spr_attr_base_2 = spr_attr_base_2

	local lbl_attr_base_2 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_base_2:setPosition(60, 0)
	lbl_attr_base_2:setContentSize(84, 29.2)
	lbl_attr_base_2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_base_2:setTextColor(cc.c3b(253, 252, 224))
	lbl_attr_base_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_base_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_base_2:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_base_2:addChild(lbl_attr_base_2)
	self.lbl_attr_base_2 = lbl_attr_base_2

	local lbl_attr_base_extra_2 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_base_extra_2:setPosition(60, 0)
	lbl_attr_base_extra_2:setContentSize(80, 25.2)
	lbl_attr_base_extra_2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_base_extra_2:setVisible(false)
	lbl_attr_base_extra_2:setTextColor(cc.c3b(255, 226, 124))
	lbl_attr_base_extra_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_base_extra_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_base_extra_2:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_base_2:addChild(lbl_attr_base_extra_2)
	self.lbl_attr_base_extra_2 = lbl_attr_base_extra_2

	local node_attr_base_3 = cc.Node:create()
	node_attr_base_3:setPosition(-251.76, -128.13)
	node_attr_base_3:setContentSize(0, 0)
	node_elem:addChild(node_attr_base_3)
	self.node_attr_base_3 = node_attr_base_3

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(20, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_base_3:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_base_3 = cc.Sprite:create()
	spr_attr_base_3:setPosition(0, 0)
	spr_attr_base_3:setContentSize(66, 66)
	spr_attr_base_3:setScale(0.75, 0.75)
	spr_attr_base_3:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_base_3, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-100.png")
	node_attr_base_3:addChild(spr_attr_base_3)
	self.spr_attr_base_3 = spr_attr_base_3

	local lbl_attr_base_3 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_base_3:setPosition(60, 0)
	lbl_attr_base_3:setContentSize(84, 29.2)
	lbl_attr_base_3:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_base_3:setTextColor(cc.c3b(253, 252, 224))
	lbl_attr_base_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_base_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_base_3:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_base_3:addChild(lbl_attr_base_3)
	self.lbl_attr_base_3 = lbl_attr_base_3

	local lbl_attr_base_extra_3 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_base_extra_3:setPosition(60, 0)
	lbl_attr_base_extra_3:setContentSize(80, 25.2)
	lbl_attr_base_extra_3:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_base_extra_3:setVisible(false)
	lbl_attr_base_extra_3:setTextColor(cc.c3b(255, 226, 124))
	lbl_attr_base_extra_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_base_extra_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_base_extra_3:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_base_3:addChild(lbl_attr_base_extra_3)
	self.lbl_attr_base_extra_3 = lbl_attr_base_extra_3

	local node_attr_base_4 = cc.Node:create()
	node_attr_base_4:setPosition(20, -128.13)
	node_attr_base_4:setContentSize(0, 0)
	node_elem:addChild(node_attr_base_4)
	self.node_attr_base_4 = node_attr_base_4

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(20, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_base_4:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_base_4 = cc.Sprite:create()
	spr_attr_base_4:setPosition(0, 0)
	spr_attr_base_4:setContentSize(66, 66)
	spr_attr_base_4:setScale(0.75, 0.75)
	spr_attr_base_4:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_base_4, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-100.png")
	node_attr_base_4:addChild(spr_attr_base_4)
	self.spr_attr_base_4 = spr_attr_base_4

	local lbl_attr_base_4 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_base_4:setPosition(60, 0)
	lbl_attr_base_4:setContentSize(84, 29.2)
	lbl_attr_base_4:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_base_4:setTextColor(cc.c3b(253, 252, 224))
	lbl_attr_base_4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_base_4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_base_4:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_base_4:addChild(lbl_attr_base_4)
	self.lbl_attr_base_4 = lbl_attr_base_4

	local lbl_attr_base_extra_4 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_base_extra_4:setPosition(60, 0)
	lbl_attr_base_extra_4:setContentSize(80, 25.2)
	lbl_attr_base_extra_4:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_base_extra_4:setVisible(false)
	lbl_attr_base_extra_4:setTextColor(cc.c3b(255, 226, 124))
	lbl_attr_base_extra_4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_base_extra_4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_base_extra_4:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_base_4:addChild(lbl_attr_base_extra_4)
	self.lbl_attr_base_extra_4 = lbl_attr_base_extra_4

	local node_elem = cc.Node:create()
	node_elem:setPosition(240, 180)
	node_elem:setContentSize(0, 0)
	node_elem:setScale(0.8, 0.8)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_elem)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	node_elem.lyt = lyt
	self:addChild(node_elem)
	self.node_elem = node_elem

	local spr_cell_bg = cc.Sprite:create()
	spr_cell_bg:setPosition(0, -101)
	spr_cell_bg:setContentSize(543, 202)
	self:addLoadRes(2, spr_cell_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-cell-bg-2.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_cell_bg)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	spr_cell_bg.lyt = lyt
	node_elem:addChild(spr_cell_bg)
	self.spr_cell_bg = spr_cell_bg

	local lbl_title_2 = cc.Label:createWithTTF(ex.Tools:getLang(580516),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_title_2:setPosition(-210, -22)
	lbl_title_2:setContentSize(92, 31.72)
	lbl_title_2:setTextColor(cc.c3b(253, 252, 224))
	lbl_title_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title_2:enableOutline(cc.c4b(68,32,11,255), 2)
	node_elem:addChild(lbl_title_2)
	self.lbl_title_2 = lbl_title_2

	local node_attr_1 = cc.Node:create()
	node_attr_1:setPosition(-251.76, -72.85)
	node_attr_1:setContentSize(0, 0)
	node_elem:addChild(node_attr_1)
	self.node_attr_1 = node_attr_1

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(20, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_1:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_1 = cc.Sprite:create()
	spr_attr_1:setPosition(0, 0)
	spr_attr_1:setContentSize(66, 66)
	spr_attr_1:setScale(0.75, 0.75)
	spr_attr_1:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_1, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-lock.png")
	node_attr_1:addChild(spr_attr_1)
	self.spr_attr_1 = spr_attr_1

	local lbl_attr_1 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_1:setPosition(60, 0)
	lbl_attr_1:setContentSize(84, 29.2)
	lbl_attr_1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_1:setTextColor(cc.c3b(253, 252, 224))
	lbl_attr_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_1:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_1:addChild(lbl_attr_1)
	self.lbl_attr_1 = lbl_attr_1

	local lbl_attr_extra_1 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra_1:setPosition(60, 0)
	lbl_attr_extra_1:setContentSize(80, 25.2)
	lbl_attr_extra_1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra_1:setVisible(false)
	lbl_attr_extra_1:setTextColor(cc.c3b(255, 226, 124))
	lbl_attr_extra_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_extra_1:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_1:addChild(lbl_attr_extra_1)
	self.lbl_attr_extra_1 = lbl_attr_extra_1

	local node_attr_2 = cc.Node:create()
	node_attr_2:setPosition(20, -72.85)
	node_attr_2:setContentSize(0, 0)
	node_elem:addChild(node_attr_2)
	self.node_attr_2 = node_attr_2

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(20, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_2:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_2 = cc.Sprite:create()
	spr_attr_2:setPosition(0, 0)
	spr_attr_2:setContentSize(66, 66)
	spr_attr_2:setScale(0.75, 0.75)
	spr_attr_2:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_2, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-lock.png")
	node_attr_2:addChild(spr_attr_2)
	self.spr_attr_2 = spr_attr_2

	local lbl_attr_2 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_2:setPosition(60, 0)
	lbl_attr_2:setContentSize(84, 29.2)
	lbl_attr_2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_2:setTextColor(cc.c3b(253, 252, 224))
	lbl_attr_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_2:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_2:addChild(lbl_attr_2)
	self.lbl_attr_2 = lbl_attr_2

	local lbl_attr_extra_2 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra_2:setPosition(60, 0)
	lbl_attr_extra_2:setContentSize(80, 25.2)
	lbl_attr_extra_2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra_2:setVisible(false)
	lbl_attr_extra_2:setTextColor(cc.c3b(255, 226, 124))
	lbl_attr_extra_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_extra_2:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_2:addChild(lbl_attr_extra_2)
	self.lbl_attr_extra_2 = lbl_attr_extra_2

	local node_attr_3 = cc.Node:create()
	node_attr_3:setPosition(-251.76, -122.85)
	node_attr_3:setContentSize(0, 0)
	node_elem:addChild(node_attr_3)
	self.node_attr_3 = node_attr_3

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(20, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_3:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_3 = cc.Sprite:create()
	spr_attr_3:setPosition(0, 0)
	spr_attr_3:setContentSize(66, 66)
	spr_attr_3:setScale(0.75, 0.75)
	spr_attr_3:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_3, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-lock.png")
	node_attr_3:addChild(spr_attr_3)
	self.spr_attr_3 = spr_attr_3

	local lbl_attr_3 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_3:setPosition(60, 0)
	lbl_attr_3:setContentSize(84, 29.2)
	lbl_attr_3:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_3:setTextColor(cc.c3b(253, 252, 224))
	lbl_attr_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_3:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_3:addChild(lbl_attr_3)
	self.lbl_attr_3 = lbl_attr_3

	local lbl_attr_extra_3 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra_3:setPosition(60, 0)
	lbl_attr_extra_3:setContentSize(80, 25.2)
	lbl_attr_extra_3:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra_3:setVisible(false)
	lbl_attr_extra_3:setTextColor(cc.c3b(255, 226, 124))
	lbl_attr_extra_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_extra_3:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_3:addChild(lbl_attr_extra_3)
	self.lbl_attr_extra_3 = lbl_attr_extra_3

	local node_attr_4 = cc.Node:create()
	node_attr_4:setPosition(20, -122.85)
	node_attr_4:setContentSize(0, 0)
	node_elem:addChild(node_attr_4)
	self.node_attr_4 = node_attr_4

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(20, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_4:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_4 = cc.Sprite:create()
	spr_attr_4:setPosition(0, 0)
	spr_attr_4:setContentSize(66, 66)
	spr_attr_4:setScale(0.75, 0.75)
	spr_attr_4:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_4, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-lock.png")
	node_attr_4:addChild(spr_attr_4)
	self.spr_attr_4 = spr_attr_4

	local lbl_attr_4 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_4:setPosition(60, 0)
	lbl_attr_4:setContentSize(84, 29.2)
	lbl_attr_4:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_4:setTextColor(cc.c3b(253, 252, 224))
	lbl_attr_4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_4:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_4:addChild(lbl_attr_4)
	self.lbl_attr_4 = lbl_attr_4

	local lbl_attr_extra_4 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra_4:setPosition(60, 0)
	lbl_attr_extra_4:setContentSize(80, 25.2)
	lbl_attr_extra_4:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra_4:setVisible(false)
	lbl_attr_extra_4:setTextColor(cc.c3b(255, 226, 124))
	lbl_attr_extra_4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra_4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_extra_4:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_4:addChild(lbl_attr_extra_4)
	self.lbl_attr_extra_4 = lbl_attr_extra_4

	local node_attr_5 = cc.Node:create()
	node_attr_5:setPosition(-251.81, -177.35)
	node_attr_5:setContentSize(0, 0)
	node_elem:addChild(node_attr_5)
	self.node_attr_5 = node_attr_5

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(20, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_5:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_5 = cc.Sprite:create()
	spr_attr_5:setPosition(0, 0)
	spr_attr_5:setContentSize(66, 66)
	spr_attr_5:setScale(0.75, 0.75)
	spr_attr_5:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_5, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-lock.png")
	node_attr_5:addChild(spr_attr_5)
	self.spr_attr_5 = spr_attr_5

	local lbl_attr_5 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_5:setPosition(60, 0)
	lbl_attr_5:setContentSize(84, 29.2)
	lbl_attr_5:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_5:setTextColor(cc.c3b(253, 252, 224))
	lbl_attr_5:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_5:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_5:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_5:addChild(lbl_attr_5)
	self.lbl_attr_5 = lbl_attr_5

	local lbl_attr_extra_5 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra_5:setPosition(60, 0)
	lbl_attr_extra_5:setContentSize(80, 25.2)
	lbl_attr_extra_5:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra_5:setVisible(false)
	lbl_attr_extra_5:setTextColor(cc.c3b(255, 226, 124))
	lbl_attr_extra_5:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra_5:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_extra_5:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_5:addChild(lbl_attr_extra_5)
	self.lbl_attr_extra_5 = lbl_attr_extra_5

	local menu = cpp.UIMenu:create()
	menu:setPosition(0, 0)
	menu:setContentSize(0, 0)
	menu:setAnchorPoint(cc.p(0.5, 0.5))
	menu:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	menu.lyt = lyt
	node_elem:addChild(menu)
	self.menu = menu

	local btn_elem_info = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_elem_info:setPosition(210, -22)
	btn_elem_info:setContentSize(96, 38)
	btn_elem_info:setScale(0.95, 0.95)
	btn_elem_info:registerScriptTapHandler(handler(self, self.onElemInfo))
	btn_elem_info:getLabel():setTextColor(cc.c4b(255, 227, 183, 255))
	btn_elem_info:setLabelOffset(cc.p(0, -2))
	btn_elem_info:setLabelSize(40)
	btn_elem_info:setLabelOutLine(cc.c4b(87,56,29,255), 4)
	btn_elem_info:setLabelText(ex.Tools:getLang(57160))
	self:addLoadRes(3, btn_elem_info, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", {spr1="hero-hexagram/spr-red-bg.png"})
	menu:addChild(btn_elem_info)
	self.btn_elem_info = btn_elem_info

	 self:startLoadRes()
end
return AliceUnicornPreviewLayer