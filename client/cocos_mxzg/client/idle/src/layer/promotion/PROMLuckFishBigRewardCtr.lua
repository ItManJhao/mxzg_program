local PROMLuckFishBigRewardLayer = class("PROMLuckFishBigRewardLayer", require("src.comp.EventLayerAdaptiveWidthFull"))
local PROMLuckFishBigRewardCtr = class("PROMLuckFishBigRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBag")

function PROMLuckFishBigRewardLayer:onCreate()
	self:addBlackBackground()
	self:createItem()
end

function PROMLuckFishBigRewardLayer:createItem( )

    self.menu_reward:removeAllChildren()

    local item_data = cfg.promotionweekendkoi.promotionweekendkoi[1]
	for i,v in ipairs(item_data.koi_reward) do
		local item = UIMenuItemBackpack:createWithData(v.item_type,v.item_num)
		self.menu_reward:addChild(item)
        item:registerScriptTapHandler(handler(self,self.onClickInfo))
        local str = ex.Tools:getLang(cfg.item.item[v.item_type].name) .. "X" .. v.item_num
        self.lbl_name:setString(str)
	end
end

function PROMLuckFishBigRewardLayer:onClickInfo(tag,pSender)
	ex.Tools:showItemInfo(tag,pSender)
end

----------------------------------------------------------

function PROMLuckFishBigRewardCtr:onCreate()
	self:setCCBIPath("ccbi/PROMLuckFishBigRewardLayer.ccbi")
	
	self:setIsSingle(false)
end

function PROMLuckFishBigRewardCtr:getLayerClass()
	return PROMLuckFishBigRewardLayer
end

function PROMLuckFishBigRewardCtr:getLayer()
	return self.layer
end

function PROMLuckFishBigRewardCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(data)
end

function PROMLuckFishBigRewardCtr:initData(data)
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end


return PROMLuckFishBigRewardCtr
