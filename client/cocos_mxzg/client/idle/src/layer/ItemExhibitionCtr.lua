
--[[
    func: 获得奖励通用框
    author:熊梦
    time:2020-09-27 11:25:46
    版权所有:广州暗耀晶石网络信息科技有限公司
]]


local ItemExhibitionCtr = class("ItemExhibitionCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local ItemExhibitionLayer = class("ItemExhibitionLayer", require("src.comp.LuaLayerBase"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function ItemExhibitionLayer:onCreate()
	self:setAutoClose(true)

	self:addBlackBackground()
end

function ItemExhibitionLayer:creatRewardItem(reward)
	self.node_item:removeAllChildren()

	local margin = 10
	for i,v in ipairs(reward) do
		local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
		item:registerScriptTapHandler(handler(self, self.onItemInfo))
		-- local item = UIItemBackpack:createWithData(v.item_type,v.item_num)
		self.menu:addChild(item)
		local size = item:getContentSize()
		local beginX = (#reward * size.width + (#reward - 1) * margin) / 2
		local posX = -beginX + ((size.width + margin) * (i - 1) ) + size.width / 2
		item:setAnchorPoint(0.5,0.5)
		item:setPosition(posX,0)
	end
end

function ItemExhibitionLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function ItemExhibitionCtr:onCreate()
	self:setCCBIPath("ccbi/ItemExhibitionLayer.ccbi")
	self:setIsSingle(false)
end


function ItemExhibitionCtr:getLayerClass()
	return ItemExhibitionLayer
end

function ItemExhibitionCtr:openWindow(reward , callback)
	if self:isOpened() then
		return
	end

	self.callback = callback or nil
	self:loadLayer()
	self:open()
	self:updateLayer(reward, callback)

end


function ItemExhibitionCtr:updateLayer(reward, callback)
	self.callback = callback
	local layer = self.layer
	layer.reward = reward
	self.callback = callback
	layer.btn_close:registerScriptTapHandler(handler(self,self.closeWindow))
	layer.btn_enter:registerScriptTapHandler(handler(self,self.onClickEnter))
	layer:creatRewardItem(reward)

end

function ItemExhibitionCtr:onClickEnter(tag , pSender)
	if self.callback and self.can then 
		self.callback(pSender)
	end
	self:closeWindow(nil ,self.layer)
end

return ItemExhibitionCtr
