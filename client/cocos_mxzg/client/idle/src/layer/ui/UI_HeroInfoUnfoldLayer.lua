local HeroInfoUnfoldLayer = class("HeroInfoUnfoldLayer", require("src.comp.CCCLayerBase")) 

function HeroInfoUnfoldLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(186, 350)
	self:setAnchorPoint(cc.p(0, -0.01))
	self:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.VERTICAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.TTOB, 0, 0, 0, true)
	ly.node = self
	self.layoutex = ly
	self:addLyt(ly)
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 350)
	spr_bg:setContentSize(186, 350)
	spr_bg:setAnchorPoint(cc.p(0, 1))
	self:addLoadRes(1, spr_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", {frame = "hero-info-2/bg-tck.png", capInsets = cc.rect(13,15,15,14)})
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.VERTICAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.BTOT, 10, 10, 28, true)
	ly.node = spr_bg
	spr_bg.layoutex = ly
	self:addLyt(ly)
	self:addChild(spr_bg)
	self.spr_bg = spr_bg

	local menu = cpp.UIMenu:create()
	menu:setPosition(10, 10)
	menu:setContentSize(166, 330)
	menu:setAnchorPoint(cc.p(0, 0))
	menu:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setType(UILayout.Type.GRID)
	ly:setResizeMode(UILayout.ResizeMode.CONTAINER)
	ly:setAffectedByScale(true)
	ly:setVerticalDirection(UILayout.Direction.BTOT)
	ly:setHorizontalDirection(UILayout.Direction.LTOR)
	ly:setPaddingLeft(15)
	ly:setPaddingRight(15)
	ly:setPaddingTop(15)
	ly:setPaddingBottom(15)
	ly:setSpaceX(28)
	ly:setSpaceY(28)
	ly.node = menu
	menu.layoutex = ly
	self:addLyt(ly)
	spr_bg:addChild(menu)
	self.menu = menu

	local btn_soul = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_soul:setPosition(42, 42)
	btn_soul:setContentSize(54, 54)
	btn_soul:registerScriptTapHandler(handler(self, self.onSoul))
	self:addLoadRes(3, btn_soul, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", {spr1="hero-info-2/btn-fuhun.png"})
	menu:addChild(btn_soul)
	self.btn_soul = btn_soul

	local label_6 = cc.Label:createWithTTF(ex.Tools:getLang(6408),FONT_DEFAULT_NAME_BOLD, 22)
	label_6:setPosition(27, 6.79)
	label_6:setContentSize(46, 29.72)
	label_6:setLocalZOrder(2)
	label_6:setTextColor(cc.c3b(255, 255, 255))
	label_6:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	label_6:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	label_6:enableOutline(cc.c4b(74,41,33,255), 1)
	btn_soul:addChild(label_6)
	self.label_6 = label_6

	local btn_skin = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_skin:setPosition(124, 42)
	btn_skin:setContentSize(54, 54)
	btn_skin:registerScriptTapHandler(handler(self, self.onSkin))
	self:addLoadRes(3, btn_skin, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", {spr1="hero-info-2/btn-pifu.png"})
	menu:addChild(btn_skin)
	self.btn_skin = btn_skin

	local label_7 = cc.Label:createWithTTF(ex.Tools:getLang(5507),FONT_DEFAULT_NAME_BOLD, 22)
	label_7:setPosition(27, 6.79)
	label_7:setContentSize(46, 29.72)
	label_7:setLocalZOrder(1)
	label_7:setTextColor(cc.c3b(255, 255, 255))
	label_7:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	label_7:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	label_7:enableOutline(cc.c4b(74,41,33,255), 1)
	btn_skin:addChild(label_7)
	self.label_7 = label_7

	local btn_pet = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_pet:setPosition(42, 124)
	btn_pet:setContentSize(54, 54)
	btn_pet:registerScriptTapHandler(handler(self, self.onPet))
	self:addLoadRes(3, btn_pet, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", {spr1="hero-info-2/btn-chongwu-none.png"})
	menu:addChild(btn_pet)
	self.btn_pet = btn_pet

	local spr_pet_icon = cc.Sprite:create()
	spr_pet_icon:setPosition(27, 27)
	spr_pet_icon:setContentSize(102, 102)
	spr_pet_icon:setScale(0.5, 0.5)
	spr_pet_icon:setLocalZOrder(1)
	self:addLoadRes(2, spr_pet_icon, "ccbi-res/backpack-5.plist", "ccbi-res/backpack-5.pvr.ccz", "backpack/1100101.png")
	btn_pet:addChild(spr_pet_icon)
	self.spr_pet_icon = spr_pet_icon

	local label_4 = cc.Label:createWithTTF(ex.Tools:getLang(4811),FONT_DEFAULT_NAME_BOLD, 22)
	label_4:setPosition(27, 6.79)
	label_4:setContentSize(46, 29.72)
	label_4:setLocalZOrder(2)
	label_4:setTextColor(cc.c3b(255, 255, 255))
	label_4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	label_4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	label_4:enableOutline(cc.c4b(74,41,33,255), 1)
	btn_pet:addChild(label_4)
	self.label_4 = label_4

	local btn_totem = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_totem:setPosition(124, 124)
	btn_totem:setContentSize(54, 54)
	btn_totem:registerScriptTapHandler(handler(self, self.onTotem))
	self:addLoadRes(3, btn_totem, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", {spr1="hero-info-2/btn-tuteng-none.png"})
	menu:addChild(btn_totem)
	self.btn_totem = btn_totem

	local spr_totem_rare = cc.Sprite:create()
	spr_totem_rare:setPosition(27, 27)
	spr_totem_rare:setContentSize(104, 104)
	spr_totem_rare:setScale(0.5, 0.5)
	spr_totem_rare:setLocalZOrder(1)
	self:addLoadRes(2, spr_totem_rare, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/rare-2.png")
	btn_totem:addChild(spr_totem_rare)
	self.spr_totem_rare = spr_totem_rare

	local spr_totem_icon = cc.Sprite:create()
	spr_totem_icon:setPosition(27, 27)
	spr_totem_icon:setContentSize(88, 88)
	spr_totem_icon:setScale(0.5, 0.5)
	spr_totem_icon:setLocalZOrder(2)
	self:addLoadRes(2, spr_totem_icon, "ccbi-res/backpack-5.plist", "ccbi-res/backpack-5.pvr.ccz", "backpack/930001.png")
	btn_totem:addChild(spr_totem_icon)
	self.spr_totem_icon = spr_totem_icon

	local label_5 = cc.Label:createWithTTF(ex.Tools:getLang(76801),FONT_DEFAULT_NAME_BOLD, 22)
	label_5:setPosition(27, 6.79)
	label_5:setContentSize(46, 29.72)
	label_5:setLocalZOrder(3)
	label_5:setTextColor(cc.c3b(255, 255, 255))
	label_5:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	label_5:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	label_5:enableOutline(cc.c4b(74,41,33,255), 1)
	btn_totem:addChild(label_5)
	self.label_5 = label_5

	local btn_hexagram = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_hexagram:setPosition(42, 206)
	btn_hexagram:setContentSize(54, 54)
	btn_hexagram:registerScriptTapHandler(handler(self, self.onHexagram))
	self:addLoadRes(3, btn_hexagram, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", {spr1="hero-info-2/btn-lmx.png"})
	menu:addChild(btn_hexagram)
	self.btn_hexagram = btn_hexagram

	local label_2 = cc.Label:createWithTTF(ex.Tools:getLang(57000),FONT_DEFAULT_NAME_BOLD, 22)
	label_2:setPosition(27, 6.79)
	label_2:setContentSize(68, 29.72)
	label_2:setLocalZOrder(3)
	label_2:setTextColor(cc.c3b(255, 255, 255))
	label_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	label_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	label_2:enableOutline(cc.c4b(74,41,33,255), 1)
	btn_hexagram:addChild(label_2)
	self.label_2 = label_2

	local btn_magic_wand = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_magic_wand:setPosition(124, 206)
	btn_magic_wand:setContentSize(54, 54)
	btn_magic_wand:registerScriptTapHandler(handler(self, self.onMagicWand))
	self:addLoadRes(3, btn_magic_wand, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", {spr1="hero-info-2/btn-mz.png"})
	menu:addChild(btn_magic_wand)
	self.btn_magic_wand = btn_magic_wand

	local spr_magic_wand_rare = cc.Sprite:create()
	spr_magic_wand_rare:setPosition(27, 27)
	spr_magic_wand_rare:setContentSize(104, 104)
	spr_magic_wand_rare:setScale(0.5, 0.5)
	spr_magic_wand_rare:setLocalZOrder(1)
	self:addLoadRes(2, spr_magic_wand_rare, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/rare-2.png")
	btn_magic_wand:addChild(spr_magic_wand_rare)
	self.spr_magic_wand_rare = spr_magic_wand_rare

	local spr_magic_wand_icon = cc.Sprite:create()
	spr_magic_wand_icon:setPosition(27, 27)
	spr_magic_wand_icon:setContentSize(94, 88)
	spr_magic_wand_icon:setScale(0.5, 0.5)
	spr_magic_wand_icon:setLocalZOrder(2)
	self:addLoadRes(2, spr_magic_wand_icon, "ccbi-res/backpack-5.plist", "ccbi-res/backpack-5.pvr.ccz", "backpack/909101.png")
	btn_magic_wand:addChild(spr_magic_wand_icon)
	self.spr_magic_wand_icon = spr_magic_wand_icon

	local label_3 = cc.Label:createWithTTF(ex.Tools:getLang(57100),FONT_DEFAULT_NAME_BOLD, 22)
	label_3:setPosition(27, 6.79)
	label_3:setContentSize(46, 29.72)
	label_3:setLocalZOrder(3)
	label_3:setTextColor(cc.c3b(255, 255, 255))
	label_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	label_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	label_3:enableOutline(cc.c4b(74,41,33,255), 1)
	btn_magic_wand:addChild(label_3)
	self.label_3 = label_3

	local lbl_magic_wand_level = cc.Label:createWithTTF("",FONT_DEFAULT_NAME_BOLD, 15)
	lbl_magic_wand_level:setPosition(49.77, 41.36)
	lbl_magic_wand_level:setContentSize(2, 20.9)
	lbl_magic_wand_level:setAnchorPoint(cc.p(1, 0.5))
	lbl_magic_wand_level:setLocalZOrder(3)
	lbl_magic_wand_level:setTextColor(cc.c3b(255, 255, 255))
	lbl_magic_wand_level:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_magic_wand_level:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_magic_wand_level:enableOutline(cc.c4b(0,0,0,255), 1)
	btn_magic_wand:addChild(lbl_magic_wand_level)
	self.lbl_magic_wand_level = lbl_magic_wand_level

	local btn_reset = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_reset:setPosition(42, 288)
	btn_reset:setContentSize(54, 54)
	btn_reset:registerScriptTapHandler(handler(self, self.onResetLife))
	self:addLoadRes(3, btn_reset, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", {spr1="hero-info-2/btn_reset.png"})
	menu:addChild(btn_reset)
	self.btn_reset = btn_reset

	local label_1 = cc.Label:createWithTTF(ex.Tools:getLang(47511),FONT_DEFAULT_NAME_BOLD, 22)
	label_1:setPosition(27, 6.79)
	label_1:setContentSize(46, 29.72)
	label_1:setLocalZOrder(2)
	label_1:setTextColor(cc.c3b(255, 255, 255))
	label_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	label_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	label_1:enableOutline(cc.c4b(74,41,33,255), 1)
	btn_reset:addChild(label_1)
	self.label_1 = label_1

	 self:startLoadRes()
end
return HeroInfoUnfoldLayer