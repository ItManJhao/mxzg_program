local DreamRewardCtr = class("DreamRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local DreamRewardLayer = class("DreamRewardLayer", require("src.comp.EventLayerAdaptiveWidth"))



------------------------------------------------

function DreamRewardLayer:onCreate()
	self:addBlackBackground()

end

function DreamRewardLayer:initDone()

	local cell_data = {}
	-- infiniterewardshow
	-- 

	for k,v in pairs(cfg.infiniterewardshow.infiniterewardshow) do
		
		if v.idx ~= 1 then 
			local data = {}
			data.award_list = v.value
			data.idx = v.idx
			
			table.insert( cell_data, data )
		end 

	end


	if not self.reward_list then 
		local win_size = cc.size(self.spr_scroll_bg:getContentSize().width,self.spr_scroll_bg:getContentSize().height - 10)

		self.reward_list = ex.Tools:initTableView(self.spr_scroll_bg,cell_data, {require("src.layer.dream.DreamShowRewardCell"),"ccbi/DreamShowRewardCell.ccbi"} , win_size, 5,cc.p(0,5),true)
	end 	

	self:updateScroll()
end


function DreamRewardLayer:updateScroll( )

	
end




function DreamRewardLayer:onShowInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

------------------------------------------------


function DreamRewardCtr:onCreate()
	self:setCCBIPath("ccbi/DreamRewardLayer.ccbi")
	self:setIsSingle(false)
end

function DreamRewardCtr:getLayerClass()
	return DreamRewardLayer
end

function DreamRewardCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer:initDone()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

end

return DreamRewardCtr











