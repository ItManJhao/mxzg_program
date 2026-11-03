local HeroListDragonRoomCell = class("HeroListDragonRoomCell", require("src.comp.CCCLayerBase")) 

function HeroListDragonRoomCell:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(150, 224)
	local spr_bg = cc.Sprite:create()
	spr_bg:setPosition(75, 112)
	spr_bg:setContentSize(150, 224)
	self:addLoadRes(2, spr_bg, "ccbi-res/dragon.plist", "ccbi-res/dragon.pvr.ccz", "dragon/spr-dragon-room-bg.png")
	self:addChild(spr_bg)
	self.spr_bg = spr_bg

	local spr_name1 = cc.Sprite:create()
	spr_name1:setPosition(75, 237.99)
	spr_name1:setContentSize(49, 26)
	spr_name1:setVisible(false)
	self:addLoadRes(2, spr_name1, "ccbi-res/dragon-lang.plist", "ccbi-res/dragon-lang.pvr.ccz", "dragon-lang/lbl-room-type-1-1.png")
	self:addChild(spr_name1)
	self.spr_name1 = spr_name1

	local spr_name2 = cc.Sprite:create()
	spr_name2:setPosition(75, 237.99)
	spr_name2:setContentSize(48, 26)
	spr_name2:setVisible(false)
	self:addLoadRes(2, spr_name2, "ccbi-res/dragon-lang.plist", "ccbi-res/dragon-lang.pvr.ccz", "dragon-lang/lbl-room-type-2-1.png")
	self:addChild(spr_name2)
	self.spr_name2 = spr_name2

	local spr_lock = cc.Sprite:create()
	spr_lock:setPosition(75, 112)
	spr_lock:setContentSize(52, 65)
	spr_lock:setVisible(false)
	self:addLoadRes(2, spr_lock, "ccbi-res/dragon.plist", "ccbi-res/dragon.pvr.ccz", "dragon/spr-lock.png")
	self:addChild(spr_lock)
	self.spr_lock = spr_lock

	local spr_add = cc.Sprite:create()
	spr_add:setPosition(75, 112)
	spr_add:setContentSize(50, 52)
	spr_add:setVisible(false)
	self:addLoadRes(2, spr_add, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/spr-add-1.png")
	self:addChild(spr_add)
	self.spr_add = spr_add

	 self:startLoadRes()
end
return HeroListDragonRoomCell