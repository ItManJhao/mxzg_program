local HeroHexagramResetCtr = class("HeroHexagramResetCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local HeroHexagramResetLayer = class("HeroHexagramResetLayer", require("src.layer.ui.UI_HeroHexagramResetLayer"))
------------------------------------------------
function HeroHexagramResetLayer:onCreate()
	self.super.onCreate(self)
	self:setName("HeroHexagramResetLayer")

	self:addBlackBackground()
	self.lbl_content:setDimensions(540, 0)
	self.lbl_content:setAlignment(cc.TEXT_ALIGNMENT_LEFT)
end

-----------------------------------------------
function HeroHexagramResetCtr:loadLayer()
    local tmp_layer = HeroHexagramResetLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function HeroHexagramResetCtr:onCreate()
	self:setIsSingle(false)
end

function HeroHexagramResetCtr:openWindow(hero_id, hexagram_type)
	if self:isOpened() then
		return
	end

	self.hero_id = hero_id
	self.hexagram_type = hexagram_type

	self:loadLayer()
	self:open()
    self:initData()
end

function HeroHexagramResetCtr:initData()
	self.layer.btn_reset:registerScriptTapHandler(handler(self, self.onReset))

	self:updateLayer();
end

function HeroHexagramResetCtr:updateLayer()
	local hexagram_data = ex.Player.hero_data.hexagram:getHexagramData(self.hero_id, self.hexagram_type) or {hero_id = self.hero_id, type = self.hexagram_type, level = 0}
	local config = ex.Player.hero_data.hexagram:getHexagramConfig(self.hexagram_type, hexagram_data.level)

	self.layer.scroll_view.createItemFunction = function(data, scale)
        local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        return item
    end
    self.layer.scroll_view:reloadData(config.give_back)
end

function HeroHexagramResetCtr:onReset()
	if ex.Player.hero_data.hexagram:reset(self.hero_id, self.hexagram_type) then
		self:closeWindow()
	end
end

return HeroHexagramResetCtr

