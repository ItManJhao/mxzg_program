local AliceBuffSelectCell = class("AliceBuffSelectCell", require("src.comp.CCCLayerBase")) 

function AliceBuffSelectCell:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(510, 280)
	self:setAnchorPoint(cc.p(0, 0))
	self:setIgnoreAnchorPointForPosition(false)
	local spr_cell_bg = cc.Scale9Sprite:create()
	spr_cell_bg:setPosition(255, 140)
	spr_cell_bg:setContentSize(510, 280)
	self:addLoadRes(1, spr_cell_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", {frame = "alice/block-2.png", capInsets = cc.rect(0,0,0,0)})
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

	local spr_title_bg = cc.Sprite:create()
	spr_title_bg:setPosition(255, 264)
	spr_title_bg:setContentSize(510, 32)
	self:addLoadRes(2, spr_title_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/block-1.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_title_bg)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	spr_title_bg.lyt = lyt
	self:addChild(spr_title_bg)
	self.spr_title_bg = spr_title_bg

	local lbl_title = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_title:setPosition(250, 264)
	lbl_title:setContentSize(26.3, 27.72)
	lbl_title:setTextColor(cc.c3b(230, 199, 152))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_title)
	self.lbl_title = lbl_title

	local menu_item = require('src.comp.menu.UIMenuEx'):create()
	menu_item:setPosition(255, 125)
	menu_item:setContentSize(500, 240)
	menu_item:setAnchorPoint(cc.p(0.5, 0.5))
	menu_item:setIgnoreAnchorPointForPosition(false)
	menu_item:setSwallowsTouches(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setType(UILayout.Type.GRID)
	ly:setResizeMode(UILayout.ResizeMode.CONTAINER)
	ly:setAffectedByScale(false)
	ly:setVerticalDirection(UILayout.Direction.TTOB)
	ly:setHorizontalDirection(UILayout.Direction.LTOR)
	ly:setPaddingLeft(20)
	ly:setPaddingRight(0)
	ly:setPaddingTop(20)
	ly:setPaddingBottom(0)
	ly:setSpaceX(12)
	ly:setSpaceY(10)
	ly.node = menu_item
	menu_item.layoutex = ly
	self:addLyt(ly)
	self:addChild(menu_item)
	self.menu_item = menu_item

	 self:startLoadRes()
end
return AliceBuffSelectCell