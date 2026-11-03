local PROMChristmasGiftBoxRewardInfoCtr = class("PROMChristmasGiftBoxRewardInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local PROMChristmasGiftBoxRewardInfoLayer = class("PROMChristmasGiftBoxRewardInfoLayer", require("src.comp.LuaLayerBase"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function PROMChristmasGiftBoxRewardInfoLayer:onCreate()
	self:setAutoClose(true)

	self.scroll_view:setItemSize(cc.size(120, 120))
    self.scroll_view:setItemType(1)
    self.scroll_view:setAlignmentCenter(true)
	ex.Tools:setLimitWidth(self.lbl_title, 120)

	self:addBlackBackground()
end

function PROMChristmasGiftBoxRewardInfoLayer:creatRewardItem(reward)
	self.scroll_view.createItemFunction = function(data, scale)
        local menu = cpp.UIMenu:create()
        local item = UIItemBackpack:createWithData(data.item_type,data.item_num)
        item:registerScriptTapHandler(handler(self,self.onItemInfo))
        menu:addChild(item)
        return menu
	end
	self.scroll_view:reloadData(reward)
	
end

function PROMChristmasGiftBoxRewardInfoLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function PROMChristmasGiftBoxRewardInfoCtr:onCreate()
	self:setCCBIPath("ccbi/PROMChristmasGiftBoxRewardInfoLayer.ccbi")
	self:setIsSingle(false)
end


function PROMChristmasGiftBoxRewardInfoCtr:getLayerClass()
	return PROMChristmasGiftBoxRewardInfoLayer
end

function PROMChristmasGiftBoxRewardInfoCtr:openWindow(data , can_get, callback)
	if self:isOpened() then
		return
	end

	self.callback = callback or nil
	self:loadLayer()
	self:open()
	self:updateLayer(data,can_get,callback)

end


function PROMChristmasGiftBoxRewardInfoCtr:updateLayer(data,can_get, callback)
	self.callback = callback
	local layer = self.layer
	layer.data = data
	self.callback = callback
	self.can = can_get
	local str = can_get and ex.Tools:getLang(47695) or ex.Tools:getLang(47589)
	layer.btn_enter:setLabelText(str)
	layer.btn_enter:registerScriptTapHandler(handler(self,self.onClickEnter))
	layer:creatRewardItem(data)

end

function PROMChristmasGiftBoxRewardInfoCtr:onClickEnter(tag , pSender)
	if self.callback and self.can then 
		self.callback(self.layer.data.idx , pSender)
	end
	self:closeWindow(nil ,self.layer)
end

return PROMChristmasGiftBoxRewardInfoCtr
