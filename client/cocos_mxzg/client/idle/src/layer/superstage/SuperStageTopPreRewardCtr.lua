local SuperStageTopPreRewardCtr = class("SuperStageTopPreRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SuperStageTopPreRewardLayer = class("SuperStageTopPreRewardLayer", require("src.comp.EventLayer"))

-----------------------------------------------------------------------------
function SuperStageTopPreRewardLayer:onCreate()
	self:addBlackBackground()
	
    local win_size = cc.Director:getInstance():getWinSize()
	local width = Maths.min(self:getContentSize().width, win_size.width)
	self:setScale(width / self:getContentSize().width)
end

function SuperStageTopPreRewardLayer:onExit()
	if self.callback_exit then
		self.callback_exit()
	end
end

-----------------------------------------------------------------------------
function SuperStageTopPreRewardCtr:onCreate()
	self:setCCBIPath("ccbi/SuperStageTopPreRewardLayer.ccbi")
	self:setIsSingle(false)
end

function SuperStageTopPreRewardCtr:getLayerClass()
	return SuperStageTopPreRewardLayer
end


function SuperStageTopPreRewardCtr:openWindow(rank, battle_num, win_num, nick, callback_exit)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(rank, battle_num, win_num, nick, callback_exit)
end

function SuperStageTopPreRewardCtr:initData(rank, battle_num, win_num, nick, callback_exit)
	self.layer.callback_exit = callback_exit
	
	self.layer.lbl_rank:setString(rank)
	self.layer.lbl_count:setString(battle_num)
	self.layer.lbl_win_count:setString(win_num)
	self.layer.lbl_name:setString(nick)

	local width = self.layer.lbl_text1:getContentSize().width + self.layer.lbl_name:getContentSize().width
	self.layer.lbl_text1:setPositionX(self.layer:getContentSize().width * 0.5 - width * 0.5)
	self.layer.lbl_name:setPositionX(self.layer.lbl_text1:getPositionX() + self.layer.lbl_text1:getContentSize().width)
end

return SuperStageTopPreRewardCtr
