local SuperStageTop3Ctr = class("SuperStageTop3Ctr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SuperStageTop3Layer = class("SuperStageTop3Layer", require("src.comp.EventLayerAdaptiveWidthFull"))

function SuperStageTop3Layer:onCreate()
	self:addBlackBackground()
end

function SuperStageTop3Layer:closeWindow()
    SuperStageTop3Ctr:instance():closeWindow()
end

function SuperStageTop3Layer:onExit()

end

-----------------------------------------------------------------------------
function SuperStageTop3Ctr:onCreate()
	self:setCCBIPath("ccbi/SuperStageTop3Layer.ccbi")
	self:setIsSingle(false)
end

function SuperStageTop3Ctr:getLayerClass()
	return SuperStageTop3Layer
end

function SuperStageTop3Ctr:openWindow(ranks, time)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(ranks, time)
end

function SuperStageTop3Ctr:initData(ranks, time)

	for i=1,3 do
		local data = TableEx.findValueFunction(ranks,function(value)
			return value.rank == i
		end)

		if data then
			self.layer["lbl_name"..i]:setString(data.name)
			-- self.layer["lbl_name"..i]:setString(data.rank)
			ex.Tools:setSpriteFrame(self.layer["spr_head"..i], string.format("head-icon/%d.png", data.head_id))
			ex.Tools:setSpriteFrame(self.layer["spr_frame"..i], ex.Tools:getBorderIconByIdx(data.border_id))
		end
	end
	self.layer.lbl_time:setString(ex.Tools:getLang(70778) .. os.date("%Y-%m-%d %H:%M:%S", time))
end

return SuperStageTop3Ctr
