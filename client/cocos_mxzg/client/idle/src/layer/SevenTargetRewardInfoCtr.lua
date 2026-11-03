local SevenTargetRewardInfoCtr = class("SevenTargetRewardInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local SevenTargetRewardInfoLayer = class("SevenTargetRewardInfoLayer", require("src.comp.LuaLayerBase"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function SevenTargetRewardInfoLayer:onCreate()
	self:setAutoClose(true)

	self:addBlackBackground()
end

function SevenTargetRewardInfoLayer:creatRewardItem(reward)
	self.node_item:removeAllChildren()
	local menu = cpp.UIMenu:create()
	self.node_item:addChild(menu)
	menu:setPosition(0,0)

	local margin = 10
	for i,v in ipairs(reward) do
		local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
		item:registerScriptTapHandler(handler(self, self.onItemInfo))
		-- local item = UIItemBackpack:createWithData(v.item_type,v.item_num)
		menu:addChild(item)
		local size = item:getContentSize()
		local beginX = (#reward * size.width + (#reward - 1) * margin) / 2
		local posX = -beginX + ((size.width + margin) * (i - 1) ) + size.width / 2
		item:setAnchorPoint(0.5,0.5)
		item:setPosition(posX,0)
	end
end

function SevenTargetRewardInfoLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function SevenTargetRewardInfoCtr:onCreate()
	self:setCCBIPath("ccbi/SevenTargetRewardInfoLayer.ccbi")
	self:setIsSingle(false)
end


function SevenTargetRewardInfoCtr:getLayerClass()
	return SevenTargetRewardInfoLayer
end

function SevenTargetRewardInfoCtr:openWindow(data , can_get, callback)
	if self:isOpened() then
		return
	end

	self.callback = callback or nil
	self:loadLayer()
	self:open()
	self:updateLayer(data,can_get,callback)

end


function SevenTargetRewardInfoCtr:updateLayer(data,can_get, callback)
	self.callback = callback
	local layer = self.layer
	layer.data = data
	self.callback = callback
	self.can = can_get
	local str = can_get and ex.Tools:getLang(47695) or ex.Tools:getLang(47589)
	layer.btn_enter:setLabelText(str)
	layer.btn_close:registerScriptTapHandler(handler(self,self.closeWindow))
	layer.btn_close:setTag(data.idx)
	layer.btn_enter:registerScriptTapHandler(handler(self,self.onClickEnter))
	layer.btn_enter:setTag(data.idx)
	layer:creatRewardItem(data.reward)

end

function SevenTargetRewardInfoCtr:onClickEnter(tag , pSender)
	if self.callback and self.can then 
		self.callback(self.layer.data.idx , pSender)
	end
	self:closeWindow(nil ,self.layer)
end

return SevenTargetRewardInfoCtr
