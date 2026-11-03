local ChampionTop3Ctr = class("ChampionTop3Ctr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ChampionTop3Layer = class("ChampionTop3Layer", require("src.comp.EventLayerAdaptiveWidthFull"))

function ChampionTop3Layer:onCreate()
	self:addBlackBackground()
	
	-- local bet_ctr = ChampionTop3Ctr:instance()
    -- self.btn_close:registerScriptTapHandler(handler(bet_ctr, bet_ctr.closeWindow))
end

function ChampionTop3Layer:closeWindow()
    ChampionTop3Ctr:instance():closeWindow()
end

function ChampionTop3Layer:onExit()

end

-----------------------------------------------------------------------------
function ChampionTop3Ctr:onCreate()
	self:setCCBIPath("ccbi/ChampionTop3Layer.ccbi")
	self:setIsSingle(false)
end

function ChampionTop3Ctr:getLayerClass()
	return ChampionTop3Layer
end


function ChampionTop3Ctr:openWindow(ranks, time)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(ranks, time)
end

function ChampionTop3Ctr:initData(ranks, time)

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

return ChampionTop3Ctr
