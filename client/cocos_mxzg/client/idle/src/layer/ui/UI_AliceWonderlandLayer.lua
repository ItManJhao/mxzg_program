local AliceWonderlandLayer = class("AliceWonderlandLayer", require("src.comp.CCCLayerBase")) 

function AliceWonderlandLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(640, 1280)
	self:setAnchorPoint(cc.p(0, 0))
	self:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(self)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	self.lyt = lyt
	local spr_bg_1 = cc.Sprite:create()
	spr_bg_1:setPosition(0, 0)
	spr_bg_1:setContentSize(640, 1280)
	spr_bg_1:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(4, spr_bg_1, nil, "ccbi-res/alice-bg-1.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_bg_1)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_bg_1.lyt = lyt
	self:addChild(spr_bg_1)
	self.spr_bg_1 = spr_bg_1

	local spr_bg_2 = cc.Sprite:create()
	spr_bg_2:setPosition(0, -48)
	spr_bg_2:setContentSize(640, 1106)
	spr_bg_2:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(4, spr_bg_2, nil, "ccbi-res/alice-bg-2.png")
	self:addChild(spr_bg_2)
	self.spr_bg_2 = spr_bg_2

	local city_node_5 = cc.Node:create()
	city_node_5:setPosition(640, 1096)
	city_node_5:setContentSize(0, 0)
	spr_bg_2:addChild(city_node_5)
	self.city_node_5 = city_node_5

	local map_shadow_5 = cc.Sprite:create()
	map_shadow_5:setPosition(0, 0)
	map_shadow_5:setContentSize(481, 339)
	map_shadow_5:setAnchorPoint(cc.p(1, 1))
	map_shadow_5:setVisible(false)
	self:addLoadRes(2, map_shadow_5, "ccbi-res/alice-2.plist", "ccbi-res/alice-2.pvr.ccz", "alice/city-shadow-1.png")
	city_node_5:addChild(map_shadow_5)
	self.map_shadow_5 = map_shadow_5

	local UIMenu = cpp.UIMenu:create()
	UIMenu:setPosition(-188, -192)
	UIMenu:setContentSize(0, 0)
	UIMenu:setAnchorPoint(cc.p(0.5, 0.5))
	UIMenu:setIgnoreAnchorPointForPosition(false)
	city_node_5:addChild(UIMenu)

	local btn_city_5 = cpp.UIMenuItemTab:create("", nil, "--", 1, 1)
	btn_city_5:setPosition(0, 0)
	btn_city_5:setContentSize(256, 247)
	btn_city_5:setTag(5)
	btn_city_5:registerScriptTapHandler(handler(self, self.onCity))
	btn_city_5:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_city_5:setLabelOffset(cc.p(0, -2))
	local l = btn_city_5:getLabel()
	if l then
		local t = l:getTTFConfig()
		t.fontSize = 44
		l:setTTFConfig(t)
	end
	self:addLoadRes(3, btn_city_5, "ccbi-res/alice-2.plist", "ccbi-res/alice-2.pvr.ccz", {spr1="alice/city-5.png"})
	UIMenu:addChild(btn_city_5)
	self.btn_city_5 = btn_city_5

	local city_name_bg_5 = cc.Sprite:create()
	city_name_bg_5:setPosition(-275, -120)
	city_name_bg_5:setContentSize(163, 50)
	self:addLoadRes(2, city_name_bg_5, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/city-name-bg.png")
	city_node_5:addChild(city_name_bg_5)
	self.city_name_bg_5 = city_name_bg_5

	local lbl_city_name_5 = cc.Label:createWithTTF(ex.Tools:getLang(580020),FONT_DEFAULT_NAME_BOLD, 24)
	lbl_city_name_5:setPosition(81.5, 25)
	lbl_city_name_5:setContentSize(72, 30.24)
	lbl_city_name_5:setTextColor(cc.c3b(253, 224, 177))
	lbl_city_name_5:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_city_name_5:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	city_name_bg_5:addChild(lbl_city_name_5)
	self.lbl_city_name_5 = lbl_city_name_5

	local effect_node_5_1 = cc.Node:create()
	effect_node_5_1:setPosition(-240, -260)
	effect_node_5_1:setContentSize(0, 0)
	city_node_5:addChild(effect_node_5_1)
	self.effect_node_5_1 = effect_node_5_1

	local effect_node_5_2 = cc.Node:create()
	effect_node_5_2:setPosition(-140, -280)
	effect_node_5_2:setContentSize(0, 0)
	city_node_5:addChild(effect_node_5_2)
	self.effect_node_5_2 = effect_node_5_2

	local effect_node_5_3 = cc.Node:create()
	effect_node_5_3:setPosition(-180, -190)
	effect_node_5_3:setContentSize(0, 0)
	city_node_5:addChild(effect_node_5_3)
	self.effect_node_5_3 = effect_node_5_3

	local effect_node_5_4 = cc.Node:create()
	effect_node_5_4:setPosition(-165, -230)
	effect_node_5_4:setContentSize(0, 0)
	city_node_5:addChild(effect_node_5_4)
	self.effect_node_5_4 = effect_node_5_4

	local pass_node_5 = cc.Node:create()
	pass_node_5:setPosition(-200, -200)
	pass_node_5:setContentSize(0, 0)
	pass_node_5:setVisible(false)
	city_node_5:addChild(pass_node_5)
	self.pass_node_5 = pass_node_5

	local pass_bg_5 = cc.Scale9Sprite:create()
	pass_bg_5:setPosition(0, 0)
	pass_bg_5:setContentSize(262, 36)
	self:addLoadRes(1, pass_bg_5, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", {frame = "alice/lbl-tips-bg.png", capInsets = cc.rect(0,0,0,0)})
	pass_node_5:addChild(pass_bg_5)
	self.pass_bg_5 = pass_bg_5

	local pass_line_left_5 = cc.Sprite:create()
	pass_line_left_5:setPosition(91, 18)
	pass_line_left_5:setContentSize(119, 18)
	pass_line_left_5:setAnchorPoint(cc.p(1, 0.5))
	self:addLoadRes(2, pass_line_left_5, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/spr-line3.png")
	pass_bg_5:addChild(pass_line_left_5)
	self.pass_line_left_5 = pass_line_left_5

	local lbl_pass_5 = cc.Label:createWithTTF(ex.Tools:getLang(580022),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_pass_5:setPosition(131, 18)
	lbl_pass_5:setContentSize(68, 29.72)
	lbl_pass_5:setTextColor(cc.c3b(255, 255, 255))
	lbl_pass_5:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_pass_5:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_pass_5:enableOutline(cc.c4b(231,157,29,255), 1)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_pass_5)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	lbl_pass_5.lyt = lyt
	pass_bg_5:addChild(lbl_pass_5)
	self.lbl_pass_5 = lbl_pass_5

	local pass_line_right_5 = cc.Scale9Sprite:create()
	pass_line_right_5:setPosition(172, 18)
	pass_line_right_5:setContentSize(118, 18)
	pass_line_right_5:setScale(-1, 1)
	pass_line_right_5:setAnchorPoint(cc.p(1, 0.5))
	self:addLoadRes(1, pass_line_right_5, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "other/spr-line3.png", capInsets = cc.rect(60,0,25,0)})
	pass_bg_5:addChild(pass_line_right_5)
	self.pass_line_right_5 = pass_line_right_5

	local city_node_1 = cc.Node:create()
	city_node_1:setPosition(0, 978)
	city_node_1:setContentSize(0, 0)
	spr_bg_2:addChild(city_node_1)
	self.city_node_1 = city_node_1

	local map_shadow_1 = cc.Sprite:create()
	map_shadow_1:setPosition(0, 0)
	map_shadow_1:setContentSize(269, 326)
	map_shadow_1:setAnchorPoint(cc.p(0, 1))
	map_shadow_1:setVisible(false)
	self:addLoadRes(2, map_shadow_1, "ccbi-res/alice-2.plist", "ccbi-res/alice-2.pvr.ccz", "alice/city-shadow-2.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(map_shadow_1)
	lyt:setLeftMargin(0)
	lyt:setHorizontalEdge(1)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	map_shadow_1.lyt = lyt
	city_node_1:addChild(map_shadow_1)
	self.map_shadow_1 = map_shadow_1

	local UIMenu = cpp.UIMenu:create()
	UIMenu:setPosition(85, -175)
	UIMenu:setContentSize(0, 0)
	UIMenu:setAnchorPoint(cc.p(0.5, 0.5))
	UIMenu:setIgnoreAnchorPointForPosition(false)
	city_node_1:addChild(UIMenu)

	local btn_city_1 = cpp.UIMenuItemTab:create("", nil, "--", 1, 1)
	btn_city_1:setPosition(0, 0)
	btn_city_1:setContentSize(256, 246)
	btn_city_1:setTag(1)
	btn_city_1:registerScriptTapHandler(handler(self, self.onCity))
	btn_city_1:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_city_1:setLabelOffset(cc.p(0, -2))
	local l = btn_city_1:getLabel()
	if l then
		local t = l:getTTFConfig()
		t.fontSize = 44
		l:setTTFConfig(t)
	end
	self:addLoadRes(3, btn_city_1, "ccbi-res/alice-2.plist", "ccbi-res/alice-2.pvr.ccz", {spr1="alice/city-1.png"})
	UIMenu:addChild(btn_city_1)
	self.btn_city_1 = btn_city_1

	local city_name_bg_1 = cc.Sprite:create()
	city_name_bg_1:setPosition(135, -80)
	city_name_bg_1:setContentSize(163, 50)
	self:addLoadRes(2, city_name_bg_1, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/city-name-bg.png")
	city_node_1:addChild(city_name_bg_1)
	self.city_name_bg_1 = city_name_bg_1

	local lbl_city_name_1 = cc.Label:createWithTTF(ex.Tools:getLang(580019),FONT_DEFAULT_NAME_BOLD, 24)
	lbl_city_name_1:setPosition(81.5, 25)
	lbl_city_name_1:setContentSize(72, 30.24)
	lbl_city_name_1:setTextColor(cc.c3b(253, 224, 177))
	lbl_city_name_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_city_name_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	city_name_bg_1:addChild(lbl_city_name_1)
	self.lbl_city_name_1 = lbl_city_name_1

	local effect_node_1_1 = cc.Node:create()
	effect_node_1_1:setPosition(35, -250)
	effect_node_1_1:setContentSize(0, 0)
	city_node_1:addChild(effect_node_1_1)
	self.effect_node_1_1 = effect_node_1_1

	local effect_node_1_2 = cc.Node:create()
	effect_node_1_2:setPosition(140, -265)
	effect_node_1_2:setContentSize(0, 0)
	city_node_1:addChild(effect_node_1_2)
	self.effect_node_1_2 = effect_node_1_2

	local effect_node_1_3 = cc.Node:create()
	effect_node_1_3:setPosition(100, -180)
	effect_node_1_3:setContentSize(0, 0)
	city_node_1:addChild(effect_node_1_3)
	self.effect_node_1_3 = effect_node_1_3

	local effect_node_1_4 = cc.Node:create()
	effect_node_1_4:setPosition(115, -215)
	effect_node_1_4:setContentSize(0, 0)
	city_node_1:addChild(effect_node_1_4)
	self.effect_node_1_4 = effect_node_1_4

	local pass_node_1 = cc.Node:create()
	pass_node_1:setPosition(99.3, -180.94)
	pass_node_1:setContentSize(0, 0)
	pass_node_1:setVisible(false)
	city_node_1:addChild(pass_node_1)
	self.pass_node_1 = pass_node_1

	local pass_bg_1 = cc.Scale9Sprite:create()
	pass_bg_1:setPosition(0, 0)
	pass_bg_1:setContentSize(262, 36)
	self:addLoadRes(1, pass_bg_1, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", {frame = "alice/lbl-tips-bg.png", capInsets = cc.rect(0,0,0,0)})
	pass_node_1:addChild(pass_bg_1)
	self.pass_bg_1 = pass_bg_1

	local pass_line_left_1 = cc.Sprite:create()
	pass_line_left_1:setPosition(91, 18)
	pass_line_left_1:setContentSize(119, 18)
	pass_line_left_1:setAnchorPoint(cc.p(1, 0.5))
	self:addLoadRes(2, pass_line_left_1, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/spr-line3.png")
	pass_bg_1:addChild(pass_line_left_1)
	self.pass_line_left_1 = pass_line_left_1

	local pass_line_right_1 = cc.Scale9Sprite:create()
	pass_line_right_1:setPosition(172, 18)
	pass_line_right_1:setContentSize(118, 18)
	pass_line_right_1:setScale(-1, 1)
	pass_line_right_1:setAnchorPoint(cc.p(1, 0.5))
	self:addLoadRes(1, pass_line_right_1, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "other/spr-line3.png", capInsets = cc.rect(60,0,25,0)})
	pass_bg_1:addChild(pass_line_right_1)
	self.pass_line_right_1 = pass_line_right_1

	local lbl_pass_1 = cc.Label:createWithTTF(ex.Tools:getLang(580022),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_pass_1:setPosition(131, 18)
	lbl_pass_1:setContentSize(68, 29.72)
	lbl_pass_1:setTextColor(cc.c3b(255, 255, 255))
	lbl_pass_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_pass_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_pass_1:enableOutline(cc.c4b(231,157,29,255), 1)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_pass_1)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setPositionPercentYEnabled(true)
	lyt:setPositionPercentY(0.5)
	self:addLyt(lyt)
	lbl_pass_1.lyt = lyt
	pass_bg_1:addChild(lbl_pass_1)
	self.lbl_pass_1 = lbl_pass_1

	local city_node_4 = cc.Node:create()
	city_node_4:setPosition(640, 744)
	city_node_4:setContentSize(0, 0)
	spr_bg_2:addChild(city_node_4)
	self.city_node_4 = city_node_4

	local map_shadow_4 = cc.Sprite:create()
	map_shadow_4:setPosition(0, 0)
	map_shadow_4:setContentSize(405, 254)
	map_shadow_4:setAnchorPoint(cc.p(1, 1))
	map_shadow_4:setVisible(false)
	self:addLoadRes(2, map_shadow_4, "ccbi-res/alice-2.plist", "ccbi-res/alice-2.pvr.ccz", "alice/city-shadow-5.png")
	city_node_4:addChild(map_shadow_4)
	self.map_shadow_4 = map_shadow_4

	local UIMenu = cpp.UIMenu:create()
	UIMenu:setPosition(-118.76, -86.79)
	UIMenu:setContentSize(0, 0)
	UIMenu:setAnchorPoint(cc.p(0.5, 0.5))
	UIMenu:setIgnoreAnchorPointForPosition(false)
	city_node_4:addChild(UIMenu)

	local btn_city_4 = cpp.UIMenuItemTab:create("", nil, "--", 1, 1)
	btn_city_4:setPosition(0, 0)
	btn_city_4:setContentSize(256, 244)
	btn_city_4:setTag(4)
	btn_city_4:registerScriptTapHandler(handler(self, self.onCity))
	btn_city_4:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_city_4:setLabelOffset(cc.p(0, -2))
	local l = btn_city_4:getLabel()
	if l then
		local t = l:getTTFConfig()
		t.fontSize = 44
		l:setTTFConfig(t)
	end
	self:addLoadRes(3, btn_city_4, "ccbi-res/alice-2.plist", "ccbi-res/alice-2.pvr.ccz", {spr1="alice/city-4.png"})
	UIMenu:addChild(btn_city_4)
	self.btn_city_4 = btn_city_4

	local city_name_bg_4 = cc.Sprite:create()
	city_name_bg_4:setPosition(-195, -15)
	city_name_bg_4:setContentSize(163, 50)
	self:addLoadRes(2, city_name_bg_4, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/city-name-bg.png")
	city_node_4:addChild(city_name_bg_4)
	self.city_name_bg_4 = city_name_bg_4

	local lbl_city_name_4 = cc.Label:createWithTTF(ex.Tools:getLang(580021),FONT_DEFAULT_NAME_BOLD, 24)
	lbl_city_name_4:setPosition(81.5, 25)
	lbl_city_name_4:setContentSize(72, 30.24)
	lbl_city_name_4:setTextColor(cc.c3b(253, 224, 177))
	lbl_city_name_4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_city_name_4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	city_name_bg_4:addChild(lbl_city_name_4)
	self.lbl_city_name_4 = lbl_city_name_4

	local effect_node_4_1 = cc.Node:create()
	effect_node_4_1:setPosition(-170, -160)
	effect_node_4_1:setContentSize(0, 0)
	city_node_4:addChild(effect_node_4_1)
	self.effect_node_4_1 = effect_node_4_1

	local effect_node_4_2 = cc.Node:create()
	effect_node_4_2:setPosition(-65, -175)
	effect_node_4_2:setContentSize(0, 0)
	city_node_4:addChild(effect_node_4_2)
	self.effect_node_4_2 = effect_node_4_2

	local effect_node_4_3 = cc.Node:create()
	effect_node_4_3:setPosition(-110, -85)
	effect_node_4_3:setContentSize(0, 0)
	city_node_4:addChild(effect_node_4_3)
	self.effect_node_4_3 = effect_node_4_3

	local effect_node_4_4 = cc.Node:create()
	effect_node_4_4:setPosition(-90, -125)
	effect_node_4_4:setContentSize(0, 0)
	city_node_4:addChild(effect_node_4_4)
	self.effect_node_4_4 = effect_node_4_4

	local pass_node_4 = cc.Node:create()
	pass_node_4:setPosition(-125.21, -88.88)
	pass_node_4:setContentSize(0, 0)
	pass_node_4:setVisible(false)
	city_node_4:addChild(pass_node_4)
	self.pass_node_4 = pass_node_4

	local pass_bg_4 = cc.Scale9Sprite:create()
	pass_bg_4:setPosition(0, 0)
	pass_bg_4:setContentSize(262, 36)
	self:addLoadRes(1, pass_bg_4, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", {frame = "alice/lbl-tips-bg.png", capInsets = cc.rect(0,0,0,0)})
	pass_node_4:addChild(pass_bg_4)
	self.pass_bg_4 = pass_bg_4

	local pass_line_left_4 = cc.Sprite:create()
	pass_line_left_4:setPosition(91, 18)
	pass_line_left_4:setContentSize(119, 18)
	pass_line_left_4:setAnchorPoint(cc.p(1, 0.5))
	self:addLoadRes(2, pass_line_left_4, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/spr-line3.png")
	pass_bg_4:addChild(pass_line_left_4)
	self.pass_line_left_4 = pass_line_left_4

	local pass_line_right_4 = cc.Scale9Sprite:create()
	pass_line_right_4:setPosition(171, 18)
	pass_line_right_4:setContentSize(118, 18)
	pass_line_right_4:setScale(-1, 1)
	pass_line_right_4:setAnchorPoint(cc.p(1, 0.5))
	self:addLoadRes(1, pass_line_right_4, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "other/spr-line3.png", capInsets = cc.rect(60,0,25,0)})
	pass_bg_4:addChild(pass_line_right_4)
	self.pass_line_right_4 = pass_line_right_4

	local lbl_pass_4 = cc.Label:createWithTTF(ex.Tools:getLang(580022),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_pass_4:setPosition(131, 18)
	lbl_pass_4:setContentSize(68, 29.72)
	lbl_pass_4:setTextColor(cc.c3b(255, 255, 255))
	lbl_pass_4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_pass_4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_pass_4:enableOutline(cc.c4b(231,157,29,255), 1)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_pass_4)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setPositionPercentYEnabled(true)
	lyt:setPositionPercentY(0.5)
	self:addLyt(lyt)
	lbl_pass_4.lyt = lyt
	pass_bg_4:addChild(lbl_pass_4)
	self.lbl_pass_4 = lbl_pass_4

	local city_node_2 = cc.Node:create()
	city_node_2:setPosition(0, 667)
	city_node_2:setContentSize(0, 0)
	spr_bg_2:addChild(city_node_2)
	self.city_node_2 = city_node_2

	local map_shadow_2 = cc.Sprite:create()
	map_shadow_2:setPosition(0, 0)
	map_shadow_2:setContentSize(382, 294)
	map_shadow_2:setAnchorPoint(cc.p(0, 1))
	map_shadow_2:setVisible(false)
	self:addLoadRes(2, map_shadow_2, "ccbi-res/alice-2.plist", "ccbi-res/alice-2.pvr.ccz", "alice/city-shadow-4.png")
	city_node_2:addChild(map_shadow_2)
	self.map_shadow_2 = map_shadow_2

	local UIMenu = cpp.UIMenu:create()
	UIMenu:setPosition(85, -125)
	UIMenu:setContentSize(0, 0)
	UIMenu:setAnchorPoint(cc.p(0.5, 0.5))
	UIMenu:setIgnoreAnchorPointForPosition(false)
	city_node_2:addChild(UIMenu)

	local btn_city_2 = cpp.UIMenuItemTab:create("", nil, "--", 1, 1)
	btn_city_2:setPosition(0, 0)
	btn_city_2:setContentSize(256, 249)
	btn_city_2:setTag(2)
	btn_city_2:registerScriptTapHandler(handler(self, self.onCity))
	btn_city_2:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_city_2:setLabelOffset(cc.p(0, -2))
	local l = btn_city_2:getLabel()
	if l then
		local t = l:getTTFConfig()
		t.fontSize = 44
		l:setTTFConfig(t)
	end
	self:addLoadRes(3, btn_city_2, "ccbi-res/alice-2.plist", "ccbi-res/alice-2.pvr.ccz", {spr1="alice/city-2.png"})
	UIMenu:addChild(btn_city_2)
	self.btn_city_2 = btn_city_2

	local city_name_bg_2 = cc.Sprite:create()
	city_name_bg_2:setPosition(145, -45)
	city_name_bg_2:setContentSize(163, 50)
	self:addLoadRes(2, city_name_bg_2, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/city-name-bg.png")
	city_node_2:addChild(city_name_bg_2)
	self.city_name_bg_2 = city_name_bg_2

	local lbl_city_name_2 = cc.Label:createWithTTF(ex.Tools:getLang(580017),FONT_DEFAULT_NAME_BOLD, 24)
	lbl_city_name_2:setPosition(81.5, 25)
	lbl_city_name_2:setContentSize(72, 30.24)
	lbl_city_name_2:setTextColor(cc.c3b(253, 224, 177))
	lbl_city_name_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_city_name_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	city_name_bg_2:addChild(lbl_city_name_2)
	self.lbl_city_name_2 = lbl_city_name_2

	local effect_node_2_1 = cc.Node:create()
	effect_node_2_1:setPosition(40, -190)
	effect_node_2_1:setContentSize(0, 0)
	city_node_2:addChild(effect_node_2_1)
	self.effect_node_2_1 = effect_node_2_1

	local effect_node_2_2 = cc.Node:create()
	effect_node_2_2:setPosition(140, -215)
	effect_node_2_2:setContentSize(0, 0)
	city_node_2:addChild(effect_node_2_2)
	self.effect_node_2_2 = effect_node_2_2

	local effect_node_2_3 = cc.Node:create()
	effect_node_2_3:setPosition(105, -125)
	effect_node_2_3:setContentSize(0, 0)
	city_node_2:addChild(effect_node_2_3)
	self.effect_node_2_3 = effect_node_2_3

	local effect_node_2_4 = cc.Node:create()
	effect_node_2_4:setPosition(115, -165)
	effect_node_2_4:setContentSize(0, 0)
	city_node_2:addChild(effect_node_2_4)
	self.effect_node_2_4 = effect_node_2_4

	local pass_node_2 = cc.Node:create()
	pass_node_2:setPosition(69.87, -140.08)
	pass_node_2:setContentSize(0, 0)
	pass_node_2:setVisible(false)
	city_node_2:addChild(pass_node_2)
	self.pass_node_2 = pass_node_2

	local pass_bg_2 = cc.Scale9Sprite:create()
	pass_bg_2:setPosition(0, 0)
	pass_bg_2:setContentSize(262, 36)
	self:addLoadRes(1, pass_bg_2, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", {frame = "alice/lbl-tips-bg.png", capInsets = cc.rect(0,0,0,0)})
	pass_node_2:addChild(pass_bg_2)
	self.pass_bg_2 = pass_bg_2

	local pass_line_left_2 = cc.Sprite:create()
	pass_line_left_2:setPosition(91, 18)
	pass_line_left_2:setContentSize(119, 18)
	pass_line_left_2:setAnchorPoint(cc.p(1, 0.5))
	self:addLoadRes(2, pass_line_left_2, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/spr-line3.png")
	pass_bg_2:addChild(pass_line_left_2)
	self.pass_line_left_2 = pass_line_left_2

	local pass_line_right_2 = cc.Scale9Sprite:create()
	pass_line_right_2:setPosition(171, 18)
	pass_line_right_2:setContentSize(118, 18)
	pass_line_right_2:setScale(-1, 1)
	pass_line_right_2:setAnchorPoint(cc.p(1, 0.5))
	self:addLoadRes(1, pass_line_right_2, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "other/spr-line3.png", capInsets = cc.rect(60,0,25,0)})
	pass_bg_2:addChild(pass_line_right_2)
	self.pass_line_right_2 = pass_line_right_2

	local lbl_pass_2 = cc.Label:createWithTTF(ex.Tools:getLang(580022),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_pass_2:setPosition(131, 18)
	lbl_pass_2:setContentSize(68, 29.72)
	lbl_pass_2:setTextColor(cc.c3b(255, 255, 255))
	lbl_pass_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_pass_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_pass_2:enableOutline(cc.c4b(231,157,29,255), 1)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_pass_2)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setPositionPercentYEnabled(true)
	lyt:setPositionPercentY(0.5)
	self:addLyt(lyt)
	lbl_pass_2.lyt = lyt
	pass_bg_2:addChild(lbl_pass_2)
	self.lbl_pass_2 = lbl_pass_2

	local city_node_3 = cc.Node:create()
	city_node_3:setPosition(640, 563)
	city_node_3:setContentSize(0, 0)
	spr_bg_2:addChild(city_node_3)
	self.city_node_3 = city_node_3

	local map_shadow_3 = cc.Sprite:create()
	map_shadow_3:setPosition(0, 0)
	map_shadow_3:setContentSize(411, 303)
	map_shadow_3:setAnchorPoint(cc.p(1, 1))
	map_shadow_3:setVisible(false)
	self:addLoadRes(2, map_shadow_3, "ccbi-res/alice-2.plist", "ccbi-res/alice-2.pvr.ccz", "alice/city-shadow-3.png")
	city_node_3:addChild(map_shadow_3)
	self.map_shadow_3 = map_shadow_3

	local UIMenu = cpp.UIMenu:create()
	UIMenu:setPosition(-170, -119)
	UIMenu:setContentSize(0, 0)
	UIMenu:setAnchorPoint(cc.p(0.5, 0.5))
	UIMenu:setIgnoreAnchorPointForPosition(false)
	city_node_3:addChild(UIMenu)

	local btn_city_3 = cpp.UIMenuItemTab:create("", nil, "--", 1, 1)
	btn_city_3:setPosition(0, 0)
	btn_city_3:setContentSize(256, 246)
	btn_city_3:setTag(3)
	btn_city_3:registerScriptTapHandler(handler(self, self.onCity))
	btn_city_3:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_city_3:setLabelOffset(cc.p(0, -2))
	local l = btn_city_3:getLabel()
	if l then
		local t = l:getTTFConfig()
		t.fontSize = 44
		l:setTTFConfig(t)
	end
	self:addLoadRes(3, btn_city_3, "ccbi-res/alice-2.plist", "ccbi-res/alice-2.pvr.ccz", {spr1="alice/city-3.png"})
	UIMenu:addChild(btn_city_3)
	self.btn_city_3 = btn_city_3

	local city_name_bg_3 = cc.Sprite:create()
	city_name_bg_3:setPosition(-135, -35)
	city_name_bg_3:setContentSize(163, 50)
	self:addLoadRes(2, city_name_bg_3, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/city-name-bg.png")
	city_node_3:addChild(city_name_bg_3)
	self.city_name_bg_3 = city_name_bg_3

	local lbl_city_name_3 = cc.Label:createWithTTF(ex.Tools:getLang(580018),FONT_DEFAULT_NAME_BOLD, 24)
	lbl_city_name_3:setPosition(81.5, 25)
	lbl_city_name_3:setContentSize(72, 30.24)
	lbl_city_name_3:setTextColor(cc.c3b(253, 224, 177))
	lbl_city_name_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_city_name_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	city_name_bg_3:addChild(lbl_city_name_3)
	self.lbl_city_name_3 = lbl_city_name_3

	local effect_node_3_1 = cc.Node:create()
	effect_node_3_1:setPosition(-220, -185)
	effect_node_3_1:setContentSize(0, 0)
	city_node_3:addChild(effect_node_3_1)
	self.effect_node_3_1 = effect_node_3_1

	local effect_node_3_2 = cc.Node:create()
	effect_node_3_2:setPosition(-120, -205)
	effect_node_3_2:setContentSize(0, 0)
	city_node_3:addChild(effect_node_3_2)
	self.effect_node_3_2 = effect_node_3_2

	local effect_node_3_3 = cc.Node:create()
	effect_node_3_3:setPosition(-150, -120)
	effect_node_3_3:setContentSize(0, 0)
	city_node_3:addChild(effect_node_3_3)
	self.effect_node_3_3 = effect_node_3_3

	local effect_node_3_4 = cc.Node:create()
	effect_node_3_4:setPosition(-145, -160)
	effect_node_3_4:setContentSize(0, 0)
	city_node_3:addChild(effect_node_3_4)
	self.effect_node_3_4 = effect_node_3_4

	local pass_node_3 = cc.Node:create()
	pass_node_3:setPosition(-172.58, -131.34)
	pass_node_3:setContentSize(0, 0)
	pass_node_3:setVisible(false)
	city_node_3:addChild(pass_node_3)
	self.pass_node_3 = pass_node_3

	local pass_bg_3 = cc.Scale9Sprite:create()
	pass_bg_3:setPosition(0, 0)
	pass_bg_3:setContentSize(262, 36)
	self:addLoadRes(1, pass_bg_3, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", {frame = "alice/lbl-tips-bg.png", capInsets = cc.rect(0,0,0,0)})
	pass_node_3:addChild(pass_bg_3)
	self.pass_bg_3 = pass_bg_3

	local pass_line_left_3 = cc.Sprite:create()
	pass_line_left_3:setPosition(91, 18)
	pass_line_left_3:setContentSize(119, 18)
	pass_line_left_3:setAnchorPoint(cc.p(1, 0.5))
	self:addLoadRes(2, pass_line_left_3, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/spr-line3.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(pass_line_left_3)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	pass_line_left_3.lyt = lyt
	pass_bg_3:addChild(pass_line_left_3)
	self.pass_line_left_3 = pass_line_left_3

	local pass_line_right_3 = cc.Scale9Sprite:create()
	pass_line_right_3:setPosition(171, 18)
	pass_line_right_3:setContentSize(118, 18)
	pass_line_right_3:setScale(-1, 1)
	pass_line_right_3:setAnchorPoint(cc.p(1, 0.5))
	self:addLoadRes(1, pass_line_right_3, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "other/spr-line3.png", capInsets = cc.rect(60,0,25,0)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(pass_line_right_3)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	pass_line_right_3.lyt = lyt
	pass_bg_3:addChild(pass_line_right_3)
	self.pass_line_right_3 = pass_line_right_3

	local lbl_pass_3 = cc.Label:createWithTTF(ex.Tools:getLang(580022),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_pass_3:setPosition(131, 18)
	lbl_pass_3:setContentSize(68, 29.72)
	lbl_pass_3:setTextColor(cc.c3b(255, 255, 255))
	lbl_pass_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_pass_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_pass_3:enableOutline(cc.c4b(231,157,29,255), 1)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_pass_3)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setPositionPercentYEnabled(true)
	lyt:setPositionPercentY(0.5)
	self:addLyt(lyt)
	lbl_pass_3.lyt = lyt
	pass_bg_3:addChild(lbl_pass_3)
	self.lbl_pass_3 = lbl_pass_3

	local spr_bg_3 = cc.Sprite:create()
	spr_bg_3:setPosition(0, 0)
	spr_bg_3:setContentSize(640, 331)
	spr_bg_3:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(4, spr_bg_3, nil, "ccbi-res/alice-bg-3.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_bg_3)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	self:addLyt(lyt)
	spr_bg_3.lyt = lyt
	self:addChild(spr_bg_3)
	self.spr_bg_3 = spr_bg_3

	local node_top = cc.Node:create()
	node_top:setPosition(320, 1110)
	node_top:setContentSize(640, 0)
	node_top:setAnchorPoint(cc.p(0.5, 0.5))
	node_top:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_top)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(170)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_top.lyt = lyt
	self:addChild(node_top)
	self.node_top = node_top

	local spr_little_bg = cc.Sprite:create()
	spr_little_bg:setPosition(320, 3)
	spr_little_bg:setContentSize(330, 87)
	self:addLoadRes(2, spr_little_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-little-bg.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_little_bg)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(-46.5)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	spr_little_bg.lyt = lyt
	node_top:addChild(spr_little_bg)
	self.spr_little_bg = spr_little_bg

	local star_num = cc.Label:createWithTTF("爱丽丝仙境.13星",FONT_DEFAULT_NAME_BOLD, 26)
	star_num:setPosition(165, 43.5)
	star_num:setContentSize(197.07, 36.76)
	star_num:setTextColor(cc.c3b(255, 255, 255))
	star_num:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	star_num:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	star_num:enableOutline(cc.c4b(40,55,81,255), 2)
	spr_little_bg:addChild(star_num)
	self.star_num = star_num

	local arrow_menu = cpp.UIMenu:create()
	arrow_menu:setPosition(320, 0)
	arrow_menu:setContentSize(0, 0)
	arrow_menu:setAnchorPoint(cc.p(0.5, 0.5))
	arrow_menu:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(arrow_menu)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	arrow_menu.lyt = lyt
	node_top:addChild(arrow_menu)
	self.arrow_menu = arrow_menu

	local btn_right = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_right:setPosition(185, 0)
	btn_right:setContentSize(23, 34)
	btn_right:registerScriptTapHandler(handler(self, self.onRight))
	self:addLoadRes(3, btn_right, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", {spr1="alice/btn-left-right.png"})
	arrow_menu:addChild(btn_right)
	self.btn_right = btn_right

	local btn_left = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_left:setPosition(-185, 0)
	btn_left:setContentSize(23, 34)
	btn_left:setRotation(-180)
	btn_left:registerScriptTapHandler(handler(self, self.onLeft))
	self:addLoadRes(3, btn_left, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", {spr1="alice/btn-left-right.png"})
	arrow_menu:addChild(btn_left)
	self.btn_left = btn_left

	local lbl_tips_2 = cc.Label:createWithTTF(ex.Tools:getLang(580010),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_tips_2:setPosition(320, -60)
	lbl_tips_2:setContentSize(284, 29.2)
	lbl_tips_2:setTextColor(cc.c3b(234, 205, 149))
	lbl_tips_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_tips_2:enableOutline(cc.c4b(0,0,0,0), 2)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_tips_2)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	lbl_tips_2.lyt = lyt
	node_top:addChild(lbl_tips_2)
	self.lbl_tips_2 = lbl_tips_2

	local menu_right_top = cpp.UIMenu:create()
	menu_right_top:setPosition(540, 685)
	menu_right_top:setContentSize(100, 100)
	menu_right_top:setAnchorPoint(cc.p(0, 0))
	menu_right_top:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu_right_top)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(495)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	menu_right_top.lyt = lyt
	self:addChild(menu_right_top)
	self.menu_right_top = menu_right_top

	local btn_rank = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_rank:setPosition(40, 210)
	btn_rank:setContentSize(60, 60)
	btn_rank:registerScriptTapHandler(handler(self, self.onRank))
	btn_rank:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_rank:setLabelOffset(cc.p(0, -30))
	btn_rank:setLabelSize(40)
	btn_rank:setLabelOutLine(cc.c4b(0,75,129,255), 4)
	btn_rank:setLabelText(ex.Tools:getLang(580013))
	self:addLoadRes(3, btn_rank, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-new-rank-2.png"})
	menu_right_top:addChild(btn_rank)
	self.btn_rank = btn_rank

	local btn_reward = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_reward:setPosition(40, 290)
	btn_reward:setContentSize(60, 60)
	btn_reward:registerScriptTapHandler(handler(self, self.onReward))
	btn_reward:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_reward:setLabelOffset(cc.p(0, -30))
	btn_reward:setLabelSize(40)
	btn_reward:setLabelOutLine(cc.c4b(0,75,129,255), 4)
	btn_reward:setLabelText(ex.Tools:getLang(5313))
	self:addLoadRes(3, btn_reward, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-new-reward.png"})
	menu_right_top:addChild(btn_reward)
	self.btn_reward = btn_reward

	local btn_shop = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_shop:setPosition(40, 370)
	btn_shop:setContentSize(60, 60)
	btn_shop:registerScriptTapHandler(handler(self, self.onShop))
	btn_shop:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_shop:setLabelOffset(cc.p(0, -30))
	btn_shop:setLabelSize(40)
	btn_shop:setLabelOutLine(cc.c4b(0,75,129,255), 4)
	btn_shop:setLabelText(ex.Tools:getLang(580015))
	self:addLoadRes(3, btn_shop, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-new-shop.png"})
	menu_right_top:addChild(btn_shop)
	self.btn_shop = btn_shop

	local btn_info = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_info:setPosition(40, 440)
	btn_info:setContentSize(60, 61)
	btn_info:registerScriptTapHandler(handler(self, self.onInfo))
	self:addLoadRes(3, btn_info, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-info-2.png"})
	menu_right_top:addChild(btn_info)
	self.btn_info = btn_info

	local node_left_reward = cc.Node:create()
	node_left_reward:setPosition(0, 1030)
	node_left_reward:setContentSize(243, 148)
	node_left_reward:setAnchorPoint(cc.p(0, 1))
	node_left_reward:setIgnoreAnchorPointForPosition(false)
	node_left_reward:setVisible(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_left_reward)
	lyt:setLeftMargin(0)
	lyt:setHorizontalEdge(1)
	lyt:setTopMargin(250)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_left_reward.lyt = lyt
	self:addChild(node_left_reward)
	self.node_left_reward = node_left_reward

	local spr_bg_rank = cc.Scale9Sprite:create()
	spr_bg_rank:setPosition(0, 148)
	spr_bg_rank:setContentSize(243, 148)
	spr_bg_rank:setAnchorPoint(cc.p(0, 1))
	self:addLoadRes(1, spr_bg_rank, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", {frame = "alice/tips-ctr-bg.png", capInsets = cc.rect(0,0,0,0)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_bg_rank)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_bg_rank.lyt = lyt
	node_left_reward:addChild(spr_bg_rank)
	self.spr_bg_rank = spr_bg_rank

	local node_my_rank_cell = cc.Node:create()
	node_my_rank_cell:setPosition(121.5, 118)
	node_my_rank_cell:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_my_rank_cell)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(30)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_my_rank_cell.lyt = lyt
	node_left_reward:addChild(node_my_rank_cell)
	self.node_my_rank_cell = node_my_rank_cell

	local lbl_is_pass = cc.Label:createWithTTF(ex.Tools:getLang(580011),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_is_pass:setPosition(0, 0)
	lbl_is_pass:setContentSize(104, 29.2)
	lbl_is_pass:setTextColor(cc.c3b(255, 238, 178))
	lbl_is_pass:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_is_pass:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_is_pass:enableOutline(cc.c4b(81,60,65,255), 2)
	node_my_rank_cell:addChild(lbl_is_pass)
	self.lbl_is_pass = lbl_is_pass

	local lbl_consume_round = cc.Label:createWithTTF(ex.Tools:getLang(580012),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_consume_round:setPosition(121.5, 78)
	lbl_consume_round:setContentSize(160, 25.2)
	lbl_consume_round:setTextColor(cc.c3b(225, 210, 177))
	lbl_consume_round:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_consume_round:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_consume_round)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	lbl_consume_round.lyt = lyt
	node_left_reward:addChild(lbl_consume_round)
	self.lbl_consume_round = lbl_consume_round

	local reward_scroll_view = require("src.comp.UIScrollViewItem"):createWithSize(cc.size(0, 0))
	reward_scroll_view:setPosition(121.5, 38)
	reward_scroll_view:setContentSize(195, 60)
	reward_scroll_view:setAnchorPoint(cc.p(0.5, 0.5))
	reward_scroll_view:setIgnoreAnchorPointForPosition(false)
	reward_scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
	reward_scroll_view:setItemSize(cc.size(60, 60))
	local lyt = ccui.LayoutComponent:bindLayoutComponent(reward_scroll_view)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(8)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	reward_scroll_view.lyt = lyt
	node_left_reward:addChild(reward_scroll_view)
	self.reward_scroll_view = reward_scroll_view

	local node_left_rank = cc.Node:create()
	node_left_rank:setPosition(0, 1030)
	node_left_rank:setContentSize(243, 148)
	node_left_rank:setAnchorPoint(cc.p(0, 1))
	node_left_rank:setIgnoreAnchorPointForPosition(false)
	node_left_rank:setVisible(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_left_rank)
	lyt:setLeftMargin(0)
	lyt:setHorizontalEdge(1)
	lyt:setTopMargin(250)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_left_rank.lyt = lyt
	self:addChild(node_left_rank)
	self.node_left_rank = node_left_rank

	local spr_bg_rank = cc.Scale9Sprite:create()
	spr_bg_rank:setPosition(0, 148)
	spr_bg_rank:setContentSize(243, 148)
	spr_bg_rank:setAnchorPoint(cc.p(0, 1))
	self:addLoadRes(1, spr_bg_rank, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", {frame = "alice/tips-ctr-bg.png", capInsets = cc.rect(0,0,0,0)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_bg_rank)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_bg_rank.lyt = lyt
	node_left_rank:addChild(spr_bg_rank)
	self.spr_bg_rank = spr_bg_rank

	local node_my_rank_cell = cc.Node:create()
	node_my_rank_cell:setPosition(0, 118)
	node_my_rank_cell:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_my_rank_cell)
	lyt:setLeftMargin(0)
	lyt:setHorizontalEdge(1)
	lyt:setTopMargin(30)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_my_rank_cell.lyt = lyt
	node_left_rank:addChild(node_my_rank_cell)
	self.node_my_rank_cell = node_my_rank_cell

	local lbl_my_rank = cc.Label:createWithTTF(ex.Tools:getLang(57508),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_my_rank:setPosition(44.11, 0)
	lbl_my_rank:setContentSize(104, 29.2)
	lbl_my_rank:setAnchorPoint(cc.p(0, 0.5))
	lbl_my_rank:setTextColor(cc.c3b(255, 238, 178))
	lbl_my_rank:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_my_rank:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_my_rank:enableOutline(cc.c4b(81,60,65,255), 2)
	node_my_rank_cell:addChild(lbl_my_rank)
	self.lbl_my_rank = lbl_my_rank

	local lbl_rank_num = cc.Label:createWithTTF(ex.Tools:getLang(57508),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_rank_num:setPosition(135, 0)
	lbl_rank_num:setContentSize(64, 29.2)
	lbl_rank_num:setAnchorPoint(cc.p(0, 0.5))
	lbl_rank_num:setTextColor(cc.c3b(255, 238, 178))
	lbl_rank_num:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_rank_num:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_rank_num:enableOutline(cc.c4b(81,60,65,255), 2)
	node_my_rank_cell:addChild(lbl_rank_num)
	self.lbl_rank_num = lbl_rank_num

	local node_consume_round_cell = cc.Node:create()
	node_consume_round_cell:setPosition(0, 78)
	node_consume_round_cell:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_consume_round_cell)
	lyt:setLeftMargin(0)
	lyt:setHorizontalEdge(1)
	lyt:setTopMargin(70)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_consume_round_cell.lyt = lyt
	node_left_rank:addChild(node_consume_round_cell)
	self.node_consume_round_cell = node_consume_round_cell

	local lbl_consume_round = cc.Label:createWithTTF(ex.Tools:getLang(580033),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_consume_round:setPosition(20, 0)
	lbl_consume_round:setContentSize(160, 25.2)
	lbl_consume_round:setAnchorPoint(cc.p(0, 0.5))
	lbl_consume_round:setTextColor(cc.c3b(225, 210, 177))
	lbl_consume_round:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_consume_round:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_consume_round_cell:addChild(lbl_consume_round)
	self.lbl_consume_round = lbl_consume_round

	local lbl_consume_round_num = cc.Label:createWithTTF("99999",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_consume_round_num:setPosition(180, 0)
	lbl_consume_round_num:setContentSize(57.03, 25.2)
	lbl_consume_round_num:setAnchorPoint(cc.p(0, 0.5))
	lbl_consume_round_num:setTextColor(cc.c3b(225, 210, 177))
	lbl_consume_round_num:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_consume_round_num:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_consume_round_cell:addChild(lbl_consume_round_num)
	self.lbl_consume_round_num = lbl_consume_round_num

	local node_hero_die_cell = cc.Node:create()
	node_hero_die_cell:setPosition(0, 38)
	node_hero_die_cell:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_hero_die_cell)
	lyt:setLeftMargin(0)
	lyt:setHorizontalEdge(1)
	lyt:setTopMargin(110)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_hero_die_cell.lyt = lyt
	node_left_rank:addChild(node_hero_die_cell)
	self.node_hero_die_cell = node_hero_die_cell

	local lbl_hero_die = cc.Label:createWithTTF(ex.Tools:getLang(580034),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_hero_die:setPosition(20, 0)
	lbl_hero_die:setContentSize(160, 25.2)
	lbl_hero_die:setAnchorPoint(cc.p(0, 0.5))
	lbl_hero_die:setTextColor(cc.c3b(225, 210, 177))
	lbl_hero_die:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_hero_die:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_hero_die_cell:addChild(lbl_hero_die)
	self.lbl_hero_die = lbl_hero_die

	local lbl_hero_die_num = cc.Label:createWithTTF("99999",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_hero_die_num:setPosition(180, 0)
	lbl_hero_die_num:setContentSize(57.03, 25.2)
	lbl_hero_die_num:setAnchorPoint(cc.p(0, 0.5))
	lbl_hero_die_num:setTextColor(cc.c3b(225, 210, 177))
	lbl_hero_die_num:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_hero_die_num:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_hero_die_cell:addChild(lbl_hero_die_num)
	self.lbl_hero_die_num = lbl_hero_die_num

	local node_bottom = cc.Node:create()
	node_bottom:setPosition(320, 300)
	node_bottom:setContentSize(640, 0)
	node_bottom:setAnchorPoint(cc.p(0.5, 0.5))
	node_bottom:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_bottom)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setBottomMargin(300)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_bottom.lyt = lyt
	self:addChild(node_bottom)
	self.node_bottom = node_bottom

	local lbl_tips_bg_2 = cc.Scale9Sprite:create()
	lbl_tips_bg_2:setPosition(320, -35)
	lbl_tips_bg_2:setContentSize(406, 36)
	self:addLoadRes(1, lbl_tips_bg_2, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", {frame = "alice/lbl-tips-bg.png", capInsets = cc.rect(0,0,0,0)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_tips_bg_2)
	lyt:setLeftMargin(117)
	lyt:setRightMargin(117)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setBottomMargin(-53)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	lbl_tips_bg_2.lyt = lyt
	node_bottom:addChild(lbl_tips_bg_2)
	self.lbl_tips_bg_2 = lbl_tips_bg_2

	local lbl_tips_2 = cc.Label:createWithTTF(ex.Tools:getLang(580016),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_tips_2:setPosition(203, 18)
	lbl_tips_2:setContentSize(282, 27.2)
	lbl_tips_2:setTextColor(cc.c3b(241, 188, 62))
	lbl_tips_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_tips_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_tips_2:enableOutline(cc.c4b(0,0,0,0), 1)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_tips_2)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setPositionPercentYEnabled(true)
	lyt:setPositionPercentY(0.5)
	self:addLyt(lyt)
	lbl_tips_2.lyt = lyt
	lbl_tips_bg_2:addChild(lbl_tips_2)
	self.lbl_tips_2 = lbl_tips_2

	local menu_bottom = cpp.UIMenu:create()
	menu_bottom:setPosition(320, -100)
	menu_bottom:setContentSize(640, 0)
	menu_bottom:setAnchorPoint(cc.p(0.5, 0.5))
	menu_bottom:setIgnoreAnchorPointForPosition(false)
	menu_bottom:setAnchorPoint(cc.p(0.5, 0.5))
	menu_bottom:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu_bottom)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setBottomMargin(-100)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	menu_bottom.lyt = lyt
	node_bottom:addChild(menu_bottom)
	self.menu_bottom = menu_bottom

	local btn_back = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_back:setPosition(80, -60)
	btn_back:setContentSize(119, 55)
	btn_back:registerScriptTapHandler(handler(self, self.onBack))
	self:addLoadRes(3, btn_back, "ccbi-res/common-ui.plist", "ccbi-res/common-ui.pvr.ccz", {spr1="button/btn-back-1.png"})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(btn_back)
	lyt:setLeftMargin(20.5)
	lyt:setHorizontalEdge(1)
	lyt:setTopMargin(32.5)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	btn_back.lyt = lyt
	menu_bottom:addChild(btn_back)
	self.btn_back = btn_back

	local btn_reset = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_reset:setPosition(110, 0)
	btn_reset:setContentSize(197, 60)
	btn_reset:setScale(0.9, 0.9)
	btn_reset:registerScriptTapHandler(handler(self, self.onReset))
	btn_reset:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_reset:setLabelOffset(cc.p(0, 0))
	btn_reset:setLabelSize(48)
	btn_reset:setLabelOutLine(cc.c4b(26,86,171,255), 4)
	btn_reset:setLabelText(ex.Tools:getLang(580023))
	self:addLoadRes(3, btn_reset, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-blue-7.png"})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(btn_reset)
	lyt:setLeftMargin(21.35)
	lyt:setHorizontalEdge(1)
	lyt:setTopMargin(-27)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	btn_reset.lyt = lyt
	menu_bottom:addChild(btn_reset)
	self.btn_reset = btn_reset

	local btn_start_battle = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_start_battle:setPosition(320, 0)
	btn_start_battle:setContentSize(197, 60)
	btn_start_battle:setScale(0.9, 0.9)
	btn_start_battle:registerScriptTapHandler(handler(self, self.onChallenge))
	btn_start_battle:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_start_battle:setLabelOffset(cc.p(0, 0))
	btn_start_battle:setLabelSize(48)
	btn_start_battle:setLabelOutLine(cc.c4b(89,27,215,255), 4)
	btn_start_battle:setLabelText(ex.Tools:getLang(580024))
	self:addLoadRes(3, btn_start_battle, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-buy-5.png"})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(btn_start_battle)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	btn_start_battle.lyt = lyt
	menu_bottom:addChild(btn_start_battle)
	self.btn_start_battle = btn_start_battle

	local btn_system_assis = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_system_assis:setPosition(530, 0)
	btn_system_assis:setContentSize(197, 60)
	btn_system_assis:setScale(0.9, 0.9)
	btn_system_assis:registerScriptTapHandler(handler(self, self.onAssist))
	btn_system_assis:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_system_assis:setLabelOffset(cc.p(0, 0))
	btn_system_assis:setLabelSize(48)
	btn_system_assis:setLabelOutLine(cc.c4b(26,86,171,255), 4)
	btn_system_assis:setLabelText(ex.Tools:getLang(580025))
	self:addLoadRes(3, btn_system_assis, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-blue-7.png"})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(btn_system_assis)
	lyt:setRightMargin(21.35)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(-27)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	btn_system_assis.lyt = lyt
	menu_bottom:addChild(btn_system_assis)
	self.btn_system_assis = btn_system_assis

	 self:startLoadRes()
end
return AliceWonderlandLayer