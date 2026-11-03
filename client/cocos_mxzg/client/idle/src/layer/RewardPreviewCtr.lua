local RewardPreviewCtr = class("RewardPreviewCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local RewardPreviewLayer = class("RewardPreviewLayer", require("src.comp.LuaLayerBase"))

function RewardPreviewLayer:onCreate()
	self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0, 1)

	self.scroll_view:setItemSize(cc.size(90, 90))
end

-----------------------------------------------------------------------------
function RewardPreviewCtr:onCreate()
	self:setCCBIPath("ccbi/RewardPreviewLayer.ccbi")
	self:setIsSingle(false)
end

function RewardPreviewCtr:getLayerClass()
	return RewardPreviewLayer
end

function RewardPreviewCtr:getRewardPreviewLayer()
	return self.layer
end

function RewardPreviewCtr:openWindow(pos, vec_reward)
	if self:isOpened() then
		return
	end
	
	self:loadLayer()
	self:open()
	self:initData(pos, vec_reward)
end

function RewardPreviewCtr:initData(pos, vec_reward)
	vec_reward = vec_reward or {}
	self.layer:setPosition(pos)

	-- 适配宽度
	local width = math.min(self.layer.scroll_view.item_size.width * 3.5, table.nums(vec_reward) * self.layer.scroll_view.item_size.width)
	self.layer.scroll_view:setViewSize(cc.size(width, self.layer.scroll_view:getViewSize().height))
	self.layer.scroll_view.createItemFunction = function(data, scale)
		local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
		item:setScale(0.8)
		item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
		return item
	end
	self.layer.scroll_view:reloadData(vec_reward)
	self.layer.spr_bg:setContentSize(cc.size(width + 12, self.layer.spr_bg:getContentSize().height))
end


return RewardPreviewCtr
