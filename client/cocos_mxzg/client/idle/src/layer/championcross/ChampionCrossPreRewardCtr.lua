local ChampionPreRewardCtr = class("ChampionCrossPreRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ChampionPreRewardLayer = class("ChampionCrossPreRewardLayer", require("src.comp.EventLayer"))
function ChampionPreRewardLayer:onCreate()
	self:addBlackBackground()
	
    local win_size = cc.Director:getInstance():getWinSize()
	local width = Maths.min(self:getContentSize().width, win_size.width)
	self:setScale(width / self:getContentSize().width)
	
end

function ChampionPreRewardLayer:updateLayer()
	self.lbl_rank:setString(ex.Player.championcross_data.my_result.rank)
	self.lbl_count:setString(ex.Player.championcross_data.my_result.battle_num)
	self.lbl_win_count:setString(ex.Player.championcross_data.my_result.win_num)
	self.lbl_name:setString(ex.Player.nick)

	local width = self.lbl_text1:getContentSize().width + self.lbl_name:getContentSize().width
	self.lbl_text1:setPositionX(self:getContentSize().width * 0.5 - width * 0.5)
	self.lbl_name:setPositionX(self.lbl_text1:getPositionX() + self.lbl_text1:getContentSize().width)
end

function ChampionPreRewardLayer:closeWindow()
    ChampionPreRewardCtr:instance():closeWindow()
end

function ChampionPreRewardLayer:onExit()
    if ex.Player.championcross_data.show_round ~= 0 then
        NetManager:sendMessage(ProtocolID.GReqChampionCrossShowTop)
    end
end

-----------------------------------------------------------------------------
function ChampionPreRewardCtr:onCreate()
	self:setCCBIPath("ccbi/ChampionCrossPreRewardLayer.ccbi")
	self:setIsSingle(false)
end

function ChampionPreRewardCtr:getLayerClass()
	return ChampionPreRewardLayer
end


function ChampionPreRewardCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData()
end

function ChampionPreRewardCtr:initData()
	self.layer:updateLayer()
end

return ChampionPreRewardCtr
