local GRMissionStarRewardCtr = class("GRMissionStarRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local GRMissionStarRewardLayer = class("GRMissionStarRewardLayer", require("src.comp.EventLayerAdaptiveWidth"))

function GRMissionStarRewardLayer:onCreate()
	self:addBlackBackground()
	self.vec_data = {}

	self.scroll_view:setItemType(1)
	self.scroll_view:setItemSize(cc.size(560, 160))
	self:addEvent(EVENT.GOD_RELIC.STAR_REWARD, handler(self, self.updateLayer))
end

function GRMissionStarRewardLayer:updateLayer()
	self.scroll_view.createItemFunction = function(data, scale)
		local cell = require("src.layer.godrelic.GRMissionStarRewardCell"):createWithCCBIFile("ccbi/GRMissionStarRewardCell.ccbi")
		cell:reset(data)
		return cell
	end
	self.scroll_view:reloadData(self.vec_data)
end

-----------------------------------------------------------------------------
function GRMissionStarRewardCtr:onCreate()
	self:setCCBIPath("ccbi/GRMissionStarRewardLayer.ccbi")
	self:setIsSingle(false)
end

function GRMissionStarRewardCtr:getLayerClass()
	return GRMissionStarRewardLayer
end

function GRMissionStarRewardCtr:getGRMissionStarRewardLayer()
	return self.layer
end

function GRMissionStarRewardCtr:openWindow(vec_data)
	if self:isOpened() then
		return
	end
	
	self:loadLayer()
	self:open()
	self:initData(vec_data)
end

function GRMissionStarRewardCtr:initData(vec_data)
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self.layer.vec_data = vec_data
	self.layer:updateLayer()
end


return GRMissionStarRewardCtr
