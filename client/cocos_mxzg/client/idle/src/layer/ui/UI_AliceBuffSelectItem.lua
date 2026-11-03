local AliceBuffSelectItem = class("AliceBuffSelectItem", require("src.comp.CCCLayerBase")) 

function AliceBuffSelectItem:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(66, 66)
	self:setAnchorPoint(cc.p(0, 0))
	self:setIgnoreAnchorPointForPosition(false)
	local spr_icon = cc.Sprite:create()
	spr_icon:setPosition(33, 33)
	spr_icon:setContentSize(66, 66)
	self:addLoadRes(2, spr_icon, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-100.png")
	self:addChild(spr_icon)
	self.spr_icon = spr_icon

	local spr_selected = cc.Sprite:create()
	spr_selected:setPosition(33, 33)
	spr_selected:setContentSize(78, 78)
	spr_selected:setVisible(false)
	self:addLoadRes(2, spr_selected, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-buff-select.png")
	self:addChild(spr_selected)
	self.spr_selected = spr_selected

	local spr_point_bg = cc.Sprite:create()
	spr_point_bg:setPosition(53, 13)
	spr_point_bg:setContentSize(26, 26)
	self:addLoadRes(2, spr_point_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-circle.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_point_bg)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(2)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	spr_point_bg.lyt = lyt
	self:addChild(spr_point_bg)
	self.spr_point_bg = spr_point_bg

	local lbl_point = cc.Label:createWithTTF("18",FONT_DEFAULT_NAME_BOLD, 16)
	lbl_point:setPosition(13, 12)
	lbl_point:setContentSize(18.25, 20.16)
	lbl_point:setTextColor(cc.c3b(255, 255, 255))
	lbl_point:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_point:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_point_bg:addChild(lbl_point)
	self.lbl_point = lbl_point

	 self:startLoadRes()
end
return AliceBuffSelectItem