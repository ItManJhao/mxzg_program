--[[
* @Description: 端午节活动界面二：龙舟翻牌游戏 中大奖界面
* @Author: 熊梦
* @Date: 2020-06-19 21:45:00
* ]]
local PROMDragonBoatRewardCtr = class("PROMDragonBoatRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMDragonBoatRewardLayer = class("PROMDragonBoatRewardLayer", require("src.comp.EventLayerAdaptiveWidthFull"))

-----------------------------------------------------------------------
function PROMDragonBoatRewardLayer:onCreate()
	self:addBlackBackground()
	self:registerBtnEvent()
	self:setLocalZOrder(1)

	local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_reward")
    spr_effect:setPosition(self.spr_title:getPositionX(), self.spr_title:getPositionY()-15)
	self:addChild(spr_effect, 20, 100)
	
end

function PROMDragonBoatRewardLayer:setItem(item_type, item_num)
	local item = ex.Tools:createBackpackItem(item_type, item_num)
	item:setScale(0.9)
	item:registerScriptTapHandler(handler(self, self.onItemInfo))
	self.menu:addChild(item)
end

-- 关闭按钮
function PROMDragonBoatRewardLayer:registerBtnEvent( )
	local boatreward_ctr = PROMDragonBoatRewardCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(boatreward_ctr, boatreward_ctr.closeWindow))
end

function PROMDragonBoatRewardLayer:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type, nil, nil, 2)
end

-----------------------------------------------------------------------
function PROMDragonBoatRewardCtr:onCreate()
	self:setCCBIPath("ccbi/PROMDragonBoatRewardCell.ccbi")
	self:setIsSingle(false)
end

function PROMDragonBoatRewardCtr:getLayerClass()
	return PROMDragonBoatRewardLayer
end

function PROMDragonBoatRewardCtr:getDiscussLayer()
	return self.layer
end

function PROMDragonBoatRewardCtr:openWindow(item_type,item_num)
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
	self.layer:setItem(item_type,item_num)
end

return PROMDragonBoatRewardCtr
