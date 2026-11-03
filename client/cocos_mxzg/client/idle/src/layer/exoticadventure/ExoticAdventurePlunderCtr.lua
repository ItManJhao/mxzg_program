--[[
* @Description: 异界冒险-其他舰队事件-选择舰队页面
* @Author: 熊梦
* @Date: 2020-08-5 14:00:00
* ]]
local ExoticAdventurePlunderCtr = class("ExoticAdventurePlunderCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ExoticAdventurePlunderLayer = class("ExoticAdventurePlunderLayer", require("src.comp.EventLayerAdaptiveWidthFull"))

function ExoticAdventurePlunderLayer:onCreate()
	self:addBlackBackground()
	self:registerBtnEvent()
	self:inidata()
end

function ExoticAdventurePlunderLayer:inidata()
	self.battle_type = BattleType.EXOTIC_ADVENTURE_POWER
	self:onChoice(1)
end

function ExoticAdventurePlunderLayer:updataEnemyInfo( )
	self.lbl_server:setString("[s"..ex.Player.exotic_adventure_data.service_id.."]")
	self.lbl_name:setString(ex.Player.exotic_adventure_data.enemy_nick)
end

-- 关闭按钮
function ExoticAdventurePlunderLayer:registerBtnEvent( )
	local ctr = ExoticAdventurePlunderCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))

	self:addEvent(EVENT.EXOTICADVENTURE.ENEMY_INFO,handler(self,self.updataEnemyInfo))
	self:addEvent(EVENT.EXOTICADVENTURE.EVENT_THREE,handler(self,self.closewindow))
end

function ExoticAdventurePlunderLayer:onChoice(tag,pSender)
	if tag == 1 then
		self.battle_type = BattleType.EXOTIC_ADVENTURE_POWER    	-- 异界冒险动力系统
		self.btn_power:setEnabled(false)
		self.btn_arms:setEnabled(true)
	elseif tag == 2 then
		self.battle_type =BattleType.EXOTIC_ADVENTURE_ARMS    		-- 异界冒险武器系统
		self.btn_power:setEnabled(true)
		self.btn_arms:setEnabled(false)
	end
end

function ExoticAdventurePlunderLayer:closewindow()
	local ctr = ExoticAdventurePlunderCtr:instance()
	ctr:closeWindow()
end

-- 放弃事件
function ExoticAdventurePlunderLayer:onOut(tag,pSender)
	local req = SpaceTimeAdventure_pb.GReqQuitEvent()
	NetManager:sendMessage(ProtocolID.GReqQuitEvent, req)
end

function ExoticAdventurePlunderLayer:onSure(tag,pSender)
	local req = SpaceTimeAdventure_pb.GReqExecuteEvent()
	req.event_type = ex.Player.exotic_adventure_data.event_type
	req.battle_type = self.battle_type
	NetManager:sendMessage(ProtocolID.GReqExecuteEvent, req)
	self:closewindow()
end

function ExoticAdventurePlunderLayer:onRanks(tag,pSender)
	-- local hero_layer = require("src.layer.HeroSelectCtr"):instance()
	-- hero_layer:openWindow(ex.Tools:getLang(47524),
    --                     ex.Tools:getLang(47064),
    --                     {BattleType.EXOTIC_ADVENTURE_ARMS, BattleType.EXOTIC_ADVENTURE_POWER},
	-- 					handler(self, self.onPreFight))
	require("src.layer.exoticadventure.ExoticAdventureTeamCtr"):instance():openWindow()
end

function ExoticAdventurePlunderLayer:onPreFight()


end

-----------------------------------------------------------------------------
function ExoticAdventurePlunderCtr:onCreate()
	self:setCCBIPath("ccbi/ExoticAdventurePlunderLayer.ccbi")
	self:setIsSingle(false)
end

function ExoticAdventurePlunderCtr:getLayerClass()
	return ExoticAdventurePlunderLayer
end

function ExoticAdventurePlunderCtr:getAchievementLayer()
	return self.layer
end

function ExoticAdventurePlunderCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
end

function ExoticAdventurePlunderCtr:initData()

end

return ExoticAdventurePlunderCtr
