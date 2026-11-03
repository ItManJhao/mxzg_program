local PROMLuckFishRewardPoolLayer = class("PROMLuckFishRewardPoolLayer", require("src.comp.EventLayerAdaptiveWidthFull"))
local PROMLuckFishRewardPoolCtr = class("PROMLuckFishRewardPoolCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBag")

function PROMLuckFishRewardPoolLayer:onCreate()
	self:addBlackBackground()
	self:createItem()
end

function PROMLuckFishRewardPoolLayer:createItem( )
	local item_cfg = ex.Player.promotion_data.luck_fish_data:getCfg()
	self.menu_reward:removeAllChildren()
	for i,v in ipairs(item_cfg) do
		local x,y = self["node_" .. i]:getPosition()
		local item_data = v.reward[1]
		local item = UIMenuItemBackpack:createWithData(item_data.item_type,item_data.item_num)
		self.menu_reward:addChild(item)
		item:setPosition(x,y)
		item:registerScriptTapHandler(handler(self,self.onClickInfo))
	end
end

function PROMLuckFishRewardPoolLayer:onClickInfo(tag,pSender)
	ex.Tools:showItemInfo(tag,pSender)
end

----------------------------------------------------------

function PROMLuckFishRewardPoolCtr:onCreate()
	self:setCCBIPath("ccbi/PROMLuckFishRewardPoolLayer.ccbi")
	
	self:setIsSingle(false)
end

function PROMLuckFishRewardPoolCtr:getLayerClass()
	return PROMLuckFishRewardPoolLayer
end

function PROMLuckFishRewardPoolCtr:getLayer()
	return self.layer
end

function PROMLuckFishRewardPoolCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(data)
end

function PROMLuckFishRewardPoolCtr:initData(data)
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end


return PROMLuckFishRewardPoolCtr
