local HeroMagicWandAttrPreviewCtr = class("HeroMagicWandAttrPreviewCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroMagicWandAttrPreviewLayer = class("HeroMagicWandAttrPreviewLayer", require("src.layer.ui.UI_HeroMagicWandAttrPreviewLayer"))
------------------------------------------------
function HeroMagicWandAttrPreviewLayer:onCreate()
	self.super.onCreate(self)
	self:setName("HeroMagicWandAttrPreviewLayer")

	-- self:setIgnoreAnchorPointForPosition(false)
end

function HeroMagicWandAttrPreviewLayer:resetData(position, item_type)
	self.item_type = item_type
	-- self.position_fix = position
	self:updateLayer()
end

function HeroMagicWandAttrPreviewLayer:updateLayer()
	local r_list = ex.Player.hero_data.magic_wand:getAttrRange(self.item_type)
	local attr_num = table.nums(r_list)
	for i=1, 2 do
		self["lbl_attr"..i]:setVisible(i <= attr_num)
		if i <= attr_num then
			local str1 = ex.Tools:getAttrTextOnly(r_list[i].attr)
			local str2 = ex.Tools:getAttrValue(r_list[i].attr, r_list[i].min)
			local str3 = ex.Tools:getAttrValue(r_list[i].attr, r_list[i].max)
			self["lbl_attr"..i]:setString(string.format("%s: %s - %s", str1, str2, str3))
		end
	end

	self:resetLyt()
	
	self:setPositionCenter()

	self:addBlackBackground()
	-- self:setPosition(math.max(0,
	-- 						  self.position_fix.x - self:getContentSize().width),
	-- 				self.position_fix.y - self:getContentSize().height)

end

-----------------------------------------------
function HeroMagicWandAttrPreviewCtr:loadLayer()
	local tmp_layer = HeroMagicWandAttrPreviewLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function HeroMagicWandAttrPreviewCtr:onCreate()
	self:setIsSingle(false)
end

function HeroMagicWandAttrPreviewCtr:openWindow(position, item_type)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer:resetData(position, item_type)
end

return HeroMagicWandAttrPreviewCtr

