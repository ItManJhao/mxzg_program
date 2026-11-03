local HeroHexagramSkillCell = class("HeroHexagramSkillCell", require("src.comp.CCCLayerBase")) 

function HeroHexagramSkillCell:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(540, 100)
	self:setAnchorPoint(cc.p(0, 0))
	self:setIgnoreAnchorPointForPosition(false)
	local s = cc.Scale9Sprite:create()
	s:setPosition(0, 0)
	s:setContentSize(540, 100)
	s:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, s, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", {frame = "hero-hexagram/spr-cell-bg.png", capInsets = cc.rect(45,61,94,21)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(s)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	s.lyt = lyt
	self:addChild(s)
	self.s = s

	local lbl_skill_name = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_skill_name:setPosition(20, 80)
	lbl_skill_name:setContentSize(15.32, 27.2)
	lbl_skill_name:setAnchorPoint(cc.p(0, 0.5))
	lbl_skill_name:setTextColor(cc.c3b(253, 252, 224))
	lbl_skill_name:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_skill_name:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_skill_name:enableOutline(cc.c4b(68,32,11,255), 1)
	self:addChild(lbl_skill_name)
	self.lbl_skill_name = lbl_skill_name

	local lbl_tip = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_tip:setPosition(502.3, 80)
	lbl_tip:setContentSize(13.32, 25.2)
	lbl_tip:setAnchorPoint(cc.p(1, 0.5))
	lbl_tip:setTextColor(cc.c3b(255, 255, 255))
	lbl_tip:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_tip:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_tip)
	self.lbl_tip = lbl_tip

	local spr_skill_icon = cc.Sprite:create()
	spr_skill_icon:setPosition(50, 32)
	spr_skill_icon:setContentSize(62, 62)
	spr_skill_icon:setScale(0.7, 0.7)
	self:addLoadRes(2, spr_skill_icon, "ccbi-res/skill-icon.plist", "ccbi-res/skill-icon.pvr.ccz", "skill-icon/101050153.png")
	self:addChild(spr_skill_icon)
	self.spr_skill_icon = spr_skill_icon

	local lbl_skill = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 16)
	lbl_skill:setPosition(90, 53)
	lbl_skill:setContentSize(440, 20.16)
	lbl_skill:setAnchorPoint(cc.p(0, 1))
	lbl_skill:setTextColor(cc.c3b(153, 121, 105))
	lbl_skill:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_skill:setDimensions(440, 0)
	self:addChild(lbl_skill)
	self.lbl_skill = lbl_skill

	 self:startLoadRes()
end
return HeroHexagramSkillCell