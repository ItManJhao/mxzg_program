--[[
* @Description: 异界冒险-探索页面
* @Author: 熊梦
* @Date: 2020-08-3 16:00:00
* ]]
local ExoticAdventureSearchCtr = class("ExoticAdventureSearchCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ExoticAdventureSearchLayer = class("ExoticAdventureSearchLayer", require("src.comp.EventLayerAdaptiveWidthFull"))

function ExoticAdventureSearchLayer:onCreate()
	self:setAutoClose(false)
	self:addBlackBackground()
	self:inidate()
end

function ExoticAdventureSearchLayer:inidate()
    self.spr_effect_znz = sp.SkeletonAnimation:create("spine/znz.json", "spine/znz.atlas", 1)
    self.spr_effect_znz:setAnimation(0, "stand", true);
	self.spr_effect_znz:setPosition(0,100)
    self.node_bg:addChild(self.spr_effect_znz,3)
end

-----------------------------------------------------------------------------
function ExoticAdventureSearchCtr:onCreate()
	self:setCCBIPath("ccbi/ExoticAdventureSearchLayer.ccbi")
	self:setIsSingle(false)
end

function ExoticAdventureSearchCtr:getLayerClass()
	return ExoticAdventureSearchLayer
end

function ExoticAdventureSearchCtr:getAchievementLayer()
	return self.layer
end

function ExoticAdventureSearchCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
end

function ExoticAdventureSearchCtr:initData()

end

return ExoticAdventureSearchCtr
