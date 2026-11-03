local MenuItemDragonSkill = class("MenuItemDragonSkill", function ()
	return cpp.UIMenuItemLabel:create("", "", "", nil)
end, require("src.comp.CCCBaseClass")) 

function MenuItemDragonSkill:ctor()
	require("src.comp.CCCBaseClass").ctor(self)
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(50, 50)
	self:setContentSize(100, 100)
	self:setLabelText(ex.Tools:getLang(1240))
	self:setLabelColor(cc.c3b(255, 225, 178))
	self:setLabelSize(48)
	self:addLoadRes(3, self, "ccbi-res/skill-icon.plist", "ccbi-res/skill-icon.pvr.ccz", {spr1="skill-icon/spr-skill-bg-2.png"})
	local spr_icon = cc.Sprite:create()
	spr_icon:setPosition(50, 50)
	spr_icon:setContentSize(62, 62)
	spr_icon:setScale(1.3, 1.3)
	spr_icon:setLocalZOrder(1)
	self:addLoadRes(2, spr_icon, "ccbi-res/skill-icon.plist", "ccbi-res/skill-icon.pvr.ccz", "skill-icon/1001015.png")
	self:addChild(spr_icon)
	self.spr_icon = spr_icon

	local spr_frame = cc.Sprite:create()
	spr_frame:setPosition(50, 50)
	spr_frame:setContentSize(84, 84)
	spr_frame:setLocalZOrder(1)
	self:addLoadRes(2, spr_frame, "ccbi-res/skill-icon.plist", "ccbi-res/skill-icon.pvr.ccz", "skill-icon/spr-skill-frame-1.png")
	self:addChild(spr_frame)
	self.spr_frame = spr_frame

	local spr_level_bg = cc.Sprite:create()
	spr_level_bg:setPosition(19.36, 80.44)
	spr_level_bg:setContentSize(30, 30)
	spr_level_bg:setLocalZOrder(1)
	self:addLoadRes(2, spr_level_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "win-bg/block-bg-29.png")
	self:addChild(spr_level_bg)
	self.spr_level_bg = spr_level_bg

	local lbl_level = cc.Label:createWithTTF("-",FONT_DEFAULT_NAME_BOLD, 40)
	lbl_level:setPosition(19.36, 80.44)
	lbl_level:setContentSize(13.32, 50.4)
	lbl_level:setScale(0.5, 0.5)
	lbl_level:setLocalZOrder(1)
	lbl_level:setTextColor(cc.c3b(122, 71, 45))
	lbl_level:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_level:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_level)
	self.lbl_level = lbl_level

	local spr_lock = cc.Sprite:create()
	spr_lock:setPosition(50, 50)
	spr_lock:setContentSize(52, 65)
	spr_lock:setLocalZOrder(1)
	self:addLoadRes(2, spr_lock, "ccbi-res/dragon.plist", "ccbi-res/dragon.pvr.ccz", "dragon/spr-lock.png")
	self:addChild(spr_lock)
	self.spr_lock = spr_lock

	 self:startLoadRes()
end
return MenuItemDragonSkill