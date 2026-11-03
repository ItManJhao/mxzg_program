local SuperStageTopLayer = class("SuperStageTopLayer", require("src.comp.EventLayer"))

local TopTimeTitle = {
    {text=ex.Tools:getLang(47547),time_key= "battle_next_time"},
    {text=ex.Tools:getLang(47241),time_key= "battle_next_time"},
    {text=ex.Tools:getLang(47731),time_key= "battle_next_time"},
    {text=ex.Tools:getLang(47521),time_key= "battle_next_time"},
}

function SuperStageTopLayer:onExit()

end

-- 层切入时会被调用
function SuperStageTopLayer:changeLayerIn()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, true)
end

function SuperStageTopLayer:changeLayerOutEnd()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, false)
end

function SuperStageTopLayer:onCreate()
    -- 缓存冠军赛界面
    self.stage = ex.Player.super_stage_data.battle_stage
    
    self.node_top:setPositionY(self.node_top:getPositionY() - require("src.model.Game"):instance():getNotchHeight())

    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    self.spr_bg:setScaleY(ex.p.height / self.spr_bg:getContentSize().height)

    self.layer_biu = require("src.comp.BiuLayer"):create()
    self.layer_biu:setPositionY(ex.p.height * 0.45)
    self.layer_biu:setContentSize(cc.size(ex.p.width, ex.p.height * 0.25))
    self:addChild(self.layer_biu, 99999)

    local vec_title = {}
    table.insert(vec_title, ex.Tools:getLang(47691))
    table.insert(vec_title, ex.Tools:getLang(47608))
    table.insert(vec_title, ex.Tools:getLang(76025))
    table.insert(vec_title, ex.Tools:getLang(47381))

    for i=1,4 do
        local btn_tab = self["btn_tab"..i]
        if btn_tab then
            btn_tab:setLabelText(" ")
            btn_tab:setLabelSize(44)
            btn_tab:setContentSize(cc.size(130, 50))
            local lbl = btn_tab:getLabel()
            lbl:setPosition(btn_tab:getContentSize().width * 0.5, btn_tab:getContentSize().height * 0.5)
            lbl:setString(vec_title[i])
            lbl:enableOutline(cc.c3b(0, 70, 114), 4)
        end
    end

    self.node_top:setLocalZOrder(1)

    self:updateTitle()
    -- self:updateWorship()
    self:updateLayerType()
    self:updateLayer()
    self:stageBechange()

    self:addEvent(EVENT.SUPER_STAGE.UPDATE_MAIN, handler(self, self.updateLayer))
    self:addEvent(EVENT.SUPER_STAGE.BATTLE_REPORT, handler(self, self.createBattleReport))
    self:addEvent(EVENT.SUPER_STAGE.START_BIU, handler(self, self.startBiu))
    self:addEvent(EVENT.SUPER_STAGE.CLEAN_BIU, handler(self, self.cleanBiu))
    self:addEvent(EVENT.SUPER_STAGE.ADD_BIU, handler(self, self.addBiu))
    self:addEvent(EVENT.SUPER_STAGE.SUB_REFRESH, handler(self, self.subRefresh))
    self:addEvent(EVENT.SUPER_STAGE.STAGE_BECHANGE, handler(self, self.stageBechange))
    self:addEvent(EVENT.SUPER_STAGE.UPDATE_KNOCKOUT, handler(self, self.updateKnockout))

    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHZC_KFSK_CFDWS_DFS_DZ, self.btn_rank)

    NetManager:sendMessage(ProtocolID.GReqScanPinnacle)
    NetManager:sendMessage(ProtocolID.GReqScanPinnacleKnockout)
    NetManager:sendMessage(ProtocolID.GReqPinnacleBiuList)

    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)

    if device.platform == "mac" or is_game_controller == true then
        local menu = cpp.UIMenu:create()
        menu:setPosition(self.node_top:getContentSize().width * 0.5, 0)
        self.node_top:addChild(menu)

        local btn_GM = cpp.UIMenuItemLabel:create("button/btn-small-1.png", nil, ex.Tools:getLang(47035), nil)
        btn_GM:setPosition(0, 90)
        btn_GM:registerScriptTapHandler(function()
            local req_command = Role_pb.GReqGMCommandNew()
            req_command.command = "PINNACLE_NEXT_STAGE"
            NetManager:sendMessage(ProtocolID.GReqGMCommandNew, req_command)

            NetManager:sendMessage(ProtocolID.GReqScanPinnacle)
            NetManager:sendMessage(ProtocolID.GReqScanPinnacleKnockout)
            NetManager:sendMessage(ProtocolID.GReqGuessPinnacleBattle)
            NetManager:sendMessage(ProtocolID.GReqMyPinnacleBattle)
        end)
        menu:addChild(btn_GM)
    end
end

function SuperStageTopLayer:updateTimer()
    local top_title = TopTimeTitle[ex.Player.super_stage_data.battle_stage + 1]

    local time = ex.Player.super_stage_data[top_title.time_key]
    self.lbl_battle_time:setVisible(self.selected_type ~= 4)

    time = time - ex.Game:getServerTime()
    self.lbl_battle_time:setString(top_title.text .. ex.StringUtil.convertToTimeFormat(math.max(0, time)))
end

function SuperStageTopLayer:stageBechange()
    self.is_run_ani = false
    self.stage = ex.Player.super_stage_data.battle_stage
end

function SuperStageTopLayer:updateKnockout()
    self.is_run_ani = false
    local old_stage = self.stage
    self.stage = ex.Player.super_stage_data.battle_stage

    if self.stage == 3 and old_stage ~= self.stage and old_stage ~= 0 then
        self.is_run_ani = true
    end
end


function SuperStageTopLayer:updateTitle()
    if self.selected_type == nil then
        self.selected_type = 1
    end
    
    for i=1,4 do
        local btn_tab = self["btn_tab"..i]
        if btn_tab then
            local lbl = btn_tab:getLabel()
            if self.selected_type == i then
                lbl:setTextColor(cc.c4b(255, 255, 255, 255))
                local pos = cc.p(btn_tab:getParent():getPositionX() + btn_tab:getPositionX(), btn_tab:getParent():getPositionY() + btn_tab:getPositionY())
                self.spr_select:setPosition(pos)
            else
                lbl:setTextColor(cc.c4b(200, 235, 255, 255))
            end
        end
    end
end

function SuperStageTopLayer:updateLayer()
    self.lbl_battle_round:setString(ex.Player.super_stage_data:getTopTitle(ex.Player.super_stage_data.battle_round))
    
    local is_biu_visible = cc.UserDefault:getInstance():getIntegerForKey("super_stage_biu_visible", 1)
    self.btn_biu_visible:setChecked(is_biu_visible == 1)
    self.layer_biu:setVisible(is_biu_visible == 1)

    -- 更新副标题
    self:updateTimer()
end

function SuperStageTopLayer:updateLayerType()
    if self.selected_type == nil then
        return
    end

    if self.cur_layer ~= nil then
        self.cur_layer:removeFromParent()
        self.cur_layer = nil
    end

    self.spr_round_bg:setVisible(self.selected_type ~= 4)
    self.lbl_battle_round:setVisible(self.selected_type ~= 4)
    self.lbl_battle_time:setVisible(self.selected_type ~= 4 and ex.Player.super_stage_data.battle_round ~= 1)
    self.btn_edit_biu:setVisible(self.selected_type ~= 4)
    self.btn_biu_visible:setVisible(self.selected_type ~= 4)
    self.btn_reward:setVisible(self.selected_type ~= 4)
    self.btn_history:setVisible(self.selected_type ~= 4)

    local layer = nil
    if self.selected_type == 1 then
        layer = require("src.layer.superstage.SuperStageTopMyLayer"):create()
        self:addChild(layer)
    elseif self.selected_type == 2 then
        layer = require("src.layer.superstage.SuperStageTopGuessLayer"):createWithCCBIFile("ccbi/SuperStageTopGuessLayer.ccbi")
        self:addChild(layer)
    elseif self.selected_type == 3 then
        layer = require("src.layer.superstage.SuperStageTop32Layer"):createWithCCBIFile("ccbi/SuperStageTop32Layer.ccbi")
        layer:resetY(self.node_top:getPositionY() - 140)
        self:addChild(layer)
    elseif self.selected_type == 4 then
        layer = require("src.layer.superstage.SuperStageTop2Layer"):createWithCCBIFile("ccbi/SuperStageTop2Layer.ccbi")
        layer:resetY(self.node_top:getPositionY() - 30)
        self:addChild(layer)
    end
    
    self.cur_layer = layer
    
    self:subRefresh()
    self:updateLayer()
end

function SuperStageTopLayer:subRefresh()
    if self.cur_layer then
        self.cur_layer:refresh()
    end
end


function SuperStageTopLayer:onChangeLayer(tag)
    if self.selected_type == tag then
        return
    end
    self.selected_type = tag
    self:updateTitle()
    self:updateLayerType()
    self:updateTimer()
end

-- 排行
function SuperStageTopLayer:onRank(tag, pSender)
    require("src.layer.superstage.SuperStageTopRankCtr"):instance():openWindow()
end

function SuperStageTopLayer:onEditBiu()
    local res_need = ex.Tools:getSysCfg("topmatch_barrage_cost")[1]
    require("src.layer.BiuEditCtr"):instance():openWindow(res_need, function(text)
                                                            local now_time = ex.Game:getServerTime()
                                                            if ex.Player.super_stage_data.biu_cd - now_time > -1 then
                                                                -- ex.MessageView:add(string.format(ex.Tools:getLang(47076), math.max(ex.Player.super_stage_data.biu_cd - now_time + 1, 0)))
                                                                ex.MessageView:add(ex.Tools:getLang(34109))
                                                                return false
                                                            end
                                                            
                                                            local req_biu = Pinnacle_pb.GReqPinnacleBiubiu()
                                                            req_biu.content = text
                                                            NetManager:sendMessage(ProtocolID.GReqPinnacleBiubiu, req_biu)

                                                            return true
                                                          end)
end

function SuperStageTopLayer:createBattleReport(evt, report)

    if self.battle_layer then
        self.battle_layer:removeFromParent()
        self.battle_layer = nil
    end
    
    local battle_layer = self:addBattleLayer(BattleType.SUPER_STAGE_TOP,
                                             MainSceneType.MAINCITY_SUPER_STAGE_TOP,
                                             "",
                                             "",
                                             function(layer, data, vec_reward, ext)
                                                -- ex.Tools:autoPlaySceneMusic()
                                                return true, false
                                             end)
    battle_layer:battleStart(nil, report)
    battle_layer:showCloseBtn(true)

    ex.Tools:autoPlaySceneMusic()
end


function SuperStageTopLayer:startBiu(evt)
    self.layer_biu:setBiuText(ex.Player.super_stage_data.vec_biu)
    self.layer_biu:startBiu()
end

function SuperStageTopLayer:addBiu(evt, data)
    self.layer_biu:addBiuText(data)
end

function SuperStageTopLayer:cleanBiu()
    self.layer_biu:clearBiu()
end

function SuperStageTopLayer:onBiuVisible()
    local is_visible = cc.UserDefault:getInstance():getIntegerForKey("super_stage_biu_visible", 1)
    is_visible = is_visible == 0 and 1 or 0
    cc.UserDefault:getInstance():setIntegerForKey("super_stage_biu_visible", is_visible)
    self.layer_biu:setVisible(is_visible == 1)
end


function SuperStageTopLayer:onBack()
	ex.JumpManager:jumpByAtom("main_super_stage")
end

function SuperStageTopLayer:onInfo()
    require("src.layer.InfoCtr"):instance():openWindow(ex.Tools:getLang(42100), ex.Tools:getLang(42101))
end

function SuperStageTopLayer:onHistory()
    require("src.layer.superstage.SuperStageTop2HistoryCtr"):instance():openWindow({title=ex.Tools:getLang(47651),
                                                                        class=require("src.layer.superstage.SuperStageTop2HistoryCell"),
                                                                        file="ccbi/SuperStageTop2HistoryCell.ccbi",
                                                                        data_func=function()
                                                                            return ex.Player.super_stage_data.my_champion_battle
                                                                        end,
                                                                        event = EVENT.SUPER_STAGE.UPDATE_MY_CHAMPION_BATTLE})
    NetManager:sendMessage(ProtocolID.GReqScanMyPinnacleBattle)
end

function SuperStageTopLayer:onReward()
    require("src.layer.rank.RankSingleCtr"):instance():openWindow({title=ex.Tools:getLang(47370),
                                                                  class=require("src.layer.superstage.SuperStageTopRewardCell"),
                                                                  file="ccbi/DreamRewardCell.ccbi",
                                                                  data_func=function()
                                                                        return cfg.topmatchsecondreward.topmatchsecondreward
                                                                   end,
                                                                   "",
                                                                   tip=ex.Tools:getLang(70771)})
end

return SuperStageTopLayer