

local BattleReportCtr = class("BattleReportCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local BattleReportLayer = class("BattleReportLayer", require("src.comp.EventLayer"))

function BattleReportLayer:onCreate()
    self.battle_type = BattleType.PVP_DEFENSE
end

function BattleReportLayer:addBattle(type)
    if self.battle_layer ~= nil then
        self.battle_layer:removeFromParent()
        self.battle_layer = nil
    end

    local battle_layer = self:addBattleLayer(self.battle_type,
                                             MainSceneType.MAINCITY_LAYER,
                                             "",
                                             type,
                                             function()
                                                return true, false
                                             end)
    battle_layer:showCloseBtn(true)
    battle_layer:showSpeedBtn(true,false)
    battle_layer:setPosition(self:getContentSize().width * 0.5  / battle_layer:getScale() - ex.p.width  * 0.5,
    self:getContentSize().height * 0.5 / battle_layer:getScale() - ex.p.height * 0.5)

    battle_layer:setExitCallback(function()
        self:remove()
    end)
end

function BattleReportLayer:remove()
    -- 延迟一帧删除自己
    self:runAction(cc.CallFunc:create(function( )
        BattleReportCtr:instance():closeWindow()
    end))
end

-----------------------------------------------------------------------------
function BattleReportCtr:onCreate()
	self:setCCBIPath("ccbi/BattleReportLayer.ccbi")
	self:setIsSingle(false)
end

function BattleReportCtr:getLayerClass()
	return BattleReportLayer
end

function BattleReportCtr:getBattleReportLayer()
	return self.layer
end

function BattleReportCtr:openWindow(battle_id, type, battle_type)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(battle_id, type, battle_type)
end

function BattleReportCtr:initData(battle_id, type, battle_type)
    local req_battle = Battle_pb.GReqBattleReport()
    req_battle.battle_id = battle_id
    req_battle.type = type
    NetManager:sendMessage(ProtocolID.GReqBattleReport, req_battle)

    self.layer.battle_type = battle_type or self.layer.battle_type
    self.layer:addBattle(type)
end

return BattleReportCtr
