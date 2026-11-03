--[[
* @Description: 异界冒险-货仓-箱子预览界面
* @Author: 熊梦
* @Date: 2020-07-30 20:00:00
* ]]
local ExoticAdventureBackpackInfoCtr = class("ExoticAdventureBackpackInfoCtr",require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ExoticAdventureBackpackInfoLayer = class("ExoticAdventureBackpackInfoLayer",require("src.comp.EventLayerAdaptiveWidth"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
local UIItemHeroPiece = require("src.comp.menu.UIMenuItemHeroPiece")

function ExoticAdventureBackpackInfoLayer:onCreate()
    self:addBlackBackground()
end

function ExoticAdventureBackpackInfoLayer:inidata(item_type,reward)
	self.reward = reward[1]
	local item = ex.Tools:createBackpackItem(self.reward.item_type, self.reward.item_num)
	item:setScale(0.9)
	item:registerScriptTapHandler(handler(self, self.onShowInfo))
	self.menu:addChild(item)
end

function ExoticAdventureBackpackInfoLayer:onShowInfo(tag, pSender)
	ex.Tools:onClickItemInfo(self.reward.item_type,self.reward.item_num)
end

-----------------------------------------------------------------------------
function ExoticAdventureBackpackInfoCtr:onCreate()
	self:setCCBIPath("ccbi/ExoticAdventureBackpackInfoLayer.ccbi")
	self:setIsSingle(false)
end

function ExoticAdventureBackpackInfoCtr:getLayerClass()
	return ExoticAdventureBackpackInfoLayer
end

function ExoticAdventureBackpackInfoCtr:getAchievementLayer()
	return self.layer
end

function ExoticAdventureBackpackInfoCtr:openWindow(item_type,reward)
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
	self.layer:inidata(item_type,reward)
end

function ExoticAdventureBackpackInfoCtr:initData()

end

return ExoticAdventureBackpackInfoCtr
