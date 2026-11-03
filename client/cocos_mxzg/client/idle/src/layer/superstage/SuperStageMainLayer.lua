local SuperStageMainLayer = class("SuperStageMainLayer", require("src.comp.EventLayerAdaptiveWidthFull"))

local SuperStageMainRegularLayer = require("src.layer.superstage.SuperStageMainRegularLayer")
local SuperStageMainLadderLayer = require("src.layer.superstage.SuperStageMainLadderLayer")
local SuperStageMainTopLayer = require("src.layer.superstage.SuperStageMainTopLayer")

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function SuperStageMainLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(true)

    local notch_height = require("src.model.Game"):instance():getNotchHeight()
    self.node_btn_back:setPositionY(ex.p.height - notch_height - 120)

    self.btn_tab_1:setLabelText(ex.Tools:getLang(74944))
    self.btn_tab_2:setLabelText(ex.Tools:getLang(74945))

    self:initDone()
    self:updateLayer()
end

function SuperStageMainLayer:initDone()
    self:addEvent(EVENT.VIDEO_STUDIO_EVENT.VIDEO_PLAY_BACK_REQ, handler(self,self.onBattleReq))
    self:addEvent(EVENT.SUPER_STAGE.PLAY_REPORT, handler(self,self.onPlayReport))
    self:addEvent(EVENT.SUPER_STAGE.PLAY_REPORT_LADDER, handler(self,self.onBattleLadder))
    
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHZC_KFSK_CFDWS_CGS, self.btn_tab_1)
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHZC_KFSK_CFDWS_DFS, self.btn_tab_2)

    self.cur_match_type = 1
    self.btn_tab_1:setChecked(true)
end

function SuperStageMainLayer:onTab(tag, pSender)
    if tag == self.cur_match_type then
        return
    end
    
    self.cur_match_type = tag

    self:updateLayer()
end

function SuperStageMainLayer:updateLayer()
    self.btn_tab_1:setChecked(self.cur_match_type == 1)
    self.btn_tab_2:setChecked(self.cur_match_type == 2)

    self.btn_tab_1:setLabelColor(self.cur_match_type == 1 and cc.c3b(255,255,255) or cc.c3b(211,225,238))
    self.btn_tab_2:setLabelColor(self.cur_match_type == 2 and cc.c3b(255,255,255) or cc.c3b(211,225,238))

    if self.layer_regular ~= nil then
        self.layer_regular:removeFromParent()
        self.layer_regular = nil
    end
    if self.layer_ladder ~= nil then
        self.layer_ladder:removeFromParent()
        self.layer_ladder = nil
    end
    if self.layer_top ~= nil then
        self.layer_top:removeFromParent()
        self.layer_top = nil
    end

    if self.cur_match_type == 1 then
        self.layer_regular = SuperStageMainRegularLayer:createWithCCBIFile("ccbi/SuperStageMainRegularLayer.ccbi")
        self:addChild(self.layer_regular, -1)
    else
        if ex.Player.super_stage_data.pinnacle_stage ~= 6 then
            self.layer_ladder = SuperStageMainLadderLayer:createWithCCBIFile("ccbi/SuperStageMainLadderLayer.ccbi")
            self:addChild(self.layer_ladder, -1)
        else
            self.layer_top = SuperStageMainTopLayer:createWithCCBIFile("ccbi/SuperStageMainTopLayer.ccbi")
            self:addChild(self.layer_top, -1)
        end
    end
end

-- 播放個人挑戰戰報
function SuperStageMainLayer:onBattleReq(event, data)
	local req_battle = Battle_pb.GReqBattleReport()
    req_battle.battle_id = data.battle_id
    req_battle.type = data.type
	NetManager:sendMessage(ProtocolID.GReqBattleReport, req_battle)

    local battle_layer = self:addBattleLayer(BattleType.SUPER_STAGE,
                                            MainSceneType.MAINCITY_SUPER_STAGE_MAIN,
                                            "",
                                            data.type,
                                            function()
                                                return true, false
                                            end)
	battle_layer:showCloseBtn(true)
	battle_layer:showSpeedBtn(true,false)
    battle_layer:setScale(1.0 / self:getScaleX())
    battle_layer:setPosition(self:getContentSize().width * 0.5 - ex.p.width  * 0.5,
                             self:getContentSize().height * 0.5  - ex.p.height * 0.5)
                             
    require("src.layer.superstage.SuperStageHistoryCtr"):instance():closeWindow()
    require("src.layer.superstage.SuperStageHistoryVideoCtr"):instance():closeWindow()
end

-- 播放戰報
function SuperStageMainLayer:onPlayReport(event, data)
    local battle_layer = self:addBattleLayer(BattleType.SUPER_STAGE,
                                            MainSceneType.MAINCITY_SUPER_STAGE_MAIN,
                                            "",
                                            nil,
                                            function()
                                                return true, false
                                            end)
	battle_layer:showCloseBtn(true)
	battle_layer:showSpeedBtn(true,false)
    battle_layer:setScale(1.0 / self:getScaleX())
    battle_layer:setPosition(self:getContentSize().width * 0.5 - ex.p.width  * 0.5,
                             self:getContentSize().height * 0.5  - ex.p.height * 0.5)
                             
    battle_layer:battleStart(nil, data.report, data)
end

function SuperStageMainLayer:onBattleLadder(event, data)
    local battle_layer = self:addBattleLayer(BattleType.SUPER_STAGE_TOP,
                                            MainSceneType.MAINCITY_SUPER_STAGE_MAIN,
                                            "", 
                                            EVENT.LADDER_EVENT.BATTLE_REPORT,
                                            function(layer, data, vec_reward, ext)
                                                ex.Tools:autoPlaySceneMusic(0.1)

                                                require("src.layer.superstage.SuperStageTopBattleEndCtr"):instance():openWindow(ext)
                                                return true, false
                                            end)
    battle_layer:setScale(1.0 / self:getParent():getScale())
    battle_layer:setPosition(self:getContentSize().width * 0.5 / battle_layer:getScale()  - ex.p.width * 0.5,
                                self:getContentSize().height * 0.5 / battle_layer:getScale() - ex.p.height * 0.5)
                             
    battle_layer:battleStart(nil, data.report, data.reward, data)
end

-- 返回
function SuperStageMainLayer:onBack(tag, pSender)
    ex.MainSceneCtr:backLastLayer()
end

function SuperStageMainLayer:onExit()

end

return SuperStageMainLayer
