local ChampionLayer = class("ChampionLayer", require("src.comp.EventLayer"))

local ChampionTimeTitle = {
    {text=ex.Tools:getLang(47547),time_key= "battle_next_time"},
    {text=ex.Tools:getLang(47241),time_key= "battle_next_time"},
    {text=ex.Tools:getLang(47731),time_key= "battle_next_time"},
    {text=ex.Tools:getLang(47521),time_key= "battle_next_time"},
}

function ChampionLayer:onExit()

end

function ChampionLayer:onCreate()
    -- 缓存冠军赛界面
    self.stage = ex.Player.champion_data.battle_stage

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
    table.insert(vec_title, ex.Tools:getLang(47290))
    table.insert(vec_title, ex.Tools:getLang(47431))

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

    self:addEvent(EVENT.CHAMPION_EVENT.UPDATE_MAIN, handler(self, self.updateLayer))
    self:addEvent(EVENT.CHAMPION_EVENT.BATTLE_REPORT, handler(self, self.createBattleReport))
    self:addEvent(EVENT.CHAMPION_EVENT.START_BIU, handler(self, self.startBiu))
    self:addEvent(EVENT.CHAMPION_EVENT.CLEAN_BIU, handler(self, self.cleanBiu))
    self:addEvent(EVENT.CHAMPION_EVENT.ADD_BIU, handler(self, self.addBiu))
    self:addEvent(EVENT.CHAMPION_EVENT.SUB_REFRESH, handler(self, self.subRefresh))
    self:addEvent(EVENT.CHAMPION_EVENT.STAGE_BECHANGE, handler(self, self.stageBechange))
    self:addEvent(EVENT.CHAMPION_EVENT.UPDATE_KNOCKOUT, handler(self, self.updateKnockout))

    NetManager:sendMessage(ProtocolID.GReqScanChampion)
    NetManager:sendMessage(ProtocolID.GReqScanChampionKnockout)
    NetManager:sendMessage(ProtocolID.GReqChampionBiuList)

    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)

    if device.platform == "mac" or is_game_controller == true then

        local menu = cpp.UIMenu:create()
        menu:setPosition(self.node_top:getContentSize().width * 0.5, 0)
        self.node_top:addChild(menu)

        local btn_GM = cpp.UIMenuItemLabel:create("button/btn-small-1.png", nil, ex.Tools:getLang(47035), nil)
        btn_GM:setPosition(0, 90)
        btn_GM:registerScriptTapHandler(function()
            local req_command = Role_pb.GReqGMCommandNew()
            req_command.command = "CHAMPION_NEXT_STAGE"
            NetManager:sendMessage(ProtocolID.GReqGMCommandNew, req_command)

            NetManager:sendMessage(ProtocolID.GReqScanChampion)
            NetManager:sendMessage(ProtocolID.GReqScanChampionKnockout)
            NetManager:sendMessage(ProtocolID.GReqGuessChampionBattle)
            NetManager:sendMessage(ProtocolID.GReqMyChampionBattle)
        end)
        menu:addChild(btn_GM)
    end

end

function ChampionLayer:updateTimer()
    local champion_title = ChampionTimeTitle[ex.Player.champion_data.battle_stage + 1]

    local is_visible = false
    -- if ex.Player.champion_data.period == ChampionType.IDLE then
    -- elseif ex.Player.champion_data.period == ChampionType.TRIALS then
    --     is_visible = true
    -- elseif ex.Player.champion_data.period == ChampionType.KNOCKOUT then
    --     is_visible = ex.Player.champion_data.battle_round ~= 1
    -- end

    local time = 0
    local battle_status = ex.Player.champion_data:getBattleStatus()
    -- if self.selected_type == 1 and
    --    ex.Player.champion_data.my_champion.period ~= nil and
    --    (ex.Player.champion_data.my_champion.period ~= ex.Player.champion_data.period or 
    --     ex.Player.champion_data.my_champion.battle_round ~= ex.Player.champion_data.battle_round)
    -- then
    --     is_visible = false
    -- else
    if battle_status == ChampionType.NOT_START then
        is_visible = true
        time = ex.Player.champion_data.battle_start_time
    elseif battle_status == ChampionType.END then
        is_visible = false
        time = ex.Player.champion_data[champion_title.time_key]
    else
        is_visible = ((ex.Player.champion_data.period == 2 and ex.Player.champion_data.battle_round == 1) or ex.Player.champion_data.period == 0) and false or true
        time = ex.Player.champion_data[champion_title.time_key]
    end
    self.lbl_battle_time:setVisible(is_visible and self.selected_type ~= 4)

    time = time - ex.Game:getServerTime()
    self.lbl_battle_time:setString(champion_title.text .. ex.StringUtil.convertToTimeFormat(math.max(0, time)))
    if time <= 0 and self.cur_layer then
        -- ex.Tools:try(function()
        --     self.cur_layer:refresh()
        -- end)
        -- NetManager:sendMessage(ProtocolID.GReqScanChampion)
        -- NetManager:sendMessage(ProtocolID.GReqScanChampionKnockout)
        -- NetManager:sendMessage(ProtocolID.GReqGuessChampionBattle)
        -- NetManager:sendMessage(ProtocolID.GReqMyChampionBattle)
    end
end

function ChampionLayer:stageBechange()
    self.is_run_ani = false
    self.period = ex.Player.champion_data.period
    self.stage = ex.Player.champion_data.battle_stage
end

function ChampionLayer:updateKnockout()
    self.is_run_ani = false
    local old_stage = self.stage
    self.period = ex.Player.champion_data.period
    self.stage = ex.Player.champion_data.battle_stage

    if self.stage == 3 and old_stage ~= self.stage and old_stage ~= 0 then
        self.is_run_ani = true
    end
end


function ChampionLayer:updateTitle()
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

function ChampionLayer:updateLayer()

    -- if self.selected_type == 1 and
    --    ex.Player.champion_data.my_champion.period ~= nil and
    --    (ex.Player.champion_data.my_champion.period ~= ex.Player.champion_data.period or 
    --     ex.Player.champion_data.my_champion.battle_round ~= ex.Player.champion_data.battle_round)
    -- then
    --     -- 止步多少强
    --     local title = ex.Player.champion_data:getChampionTitle(ex.Player.champion_data.my_champion.period, ex.Player.champion_data.my_champion.battle_round)
    --     self.lbl_battle_round:setString(ex.Tools:getLang(47325) .. title)
    --     self.lbl_battle_time:setString("")
    -- else
        local champion_status = ex.Player.champion_data:getBattleStatus()
        if champion_status == ChampionType.NOT_START then
            self.lbl_battle_round:setString(ex.Tools:getLang(47121))
        elseif champion_status == ChampionType.END then
            self.lbl_battle_round:setString(ex.Tools:getLang(47418))
        else
            self.lbl_battle_round:setString(ex.Player.champion_data:getChampionTitle(ex.Player.champion_data.period, ex.Player.champion_data.battle_round))
        end
        print("ex.Player.champion_data.battle_round", ex.Player.champion_data.battle_round)
        local is_biu_visible = cc.UserDefault:getInstance():getIntegerForKey("champion_biu_visible", 1)
        self.btn_biu_visible:setChecked(is_biu_visible == 1)
        self.layer_biu:setVisible(is_biu_visible == 1)

        -- 更新副标题
        self:updateTimer()
    -- end
end

function ChampionLayer:updateLayerType()
    if self.selected_type == nil then
        return
    end

    if self.cur_layer ~= nil then
        self.cur_layer:removeFromParent()
        self.cur_layer = nil
    end

    self.spr_round_bg:setVisible(self.selected_type ~= 4)
    self.lbl_battle_round:setVisible(self.selected_type ~= 4)
    self.lbl_battle_time:setVisible(ex.Player.champion_data.period ~= ChampionType.IDLE and self.selected_type ~= 4 and ex.Player.champion_data.battle_round ~= 1)
    self.btn_edit_biu:setVisible(self.selected_type ~= 4)
    self.btn_biu_visible:setVisible(self.selected_type ~= 4)
    self.btn_reward:setVisible(self.selected_type ~= 4)
    self.btn_history:setVisible(self.selected_type ~= 4)

    local layer = nil
    if self.selected_type == 1 then
        layer = require("src.layer.champion.ChampionMyLayer"):create()
        self:addChild(layer)
    elseif self.selected_type == 2 then
        layer = require("src.layer.champion.ChampionGuessLayer"):createWithCCBIFile("ccbi/ChampionGuessLayer.ccbi")
        self:addChild(layer)
    elseif self.selected_type == 3 then
        layer = require("src.layer.champion.ChampionTop32Layer"):createWithCCBIFile("ccbi/ChampionTop32Layer.ccbi")
        layer:resetY(self.node_top:getPositionY() - 140)
        self:addChild(layer)
    elseif self.selected_type == 4 then
        layer = require("src.layer.champion.ChampionRankLayer"):createWithCCBIFile("ccbi/ChampionRankLayer.ccbi")
        layer:resetY(self.node_top:getPositionY() - 30)
        self:addChild(layer)
    end
    
    self.cur_layer = layer
    
    self:subRefresh()
    self:updateLayer()
end

function ChampionLayer:subRefresh()
    if self.cur_layer then
        self.cur_layer:refresh()
    end
end


function ChampionLayer:onChangeLayer(tag)
    if self.selected_type == tag then
        return
    end
    self.selected_type = tag
    self:updateTitle()
    self:updateLayerType()
    self:updateTimer()
end


function ChampionLayer:onEditBiu()
    local res_need = ex.Tools:getSysCfg("champion_barrage_cost")[1]
    require("src.layer.BiuEditCtr"):instance():openWindow(res_need, function(text)
                                                            local now_time = ex.Game:getServerTime()
                                                            if ex.Player.champion_data.biu_cd - now_time > -1 then
                                                                -- ex.MessageView:add(string.format(ex.Tools:getLang(47076), math.max(ex.Player.champion_data.biu_cd - now_time + 1, 0)))
                                                                ex.MessageView:add(ex.Tools:getLang(34109))
                                                                return false
                                                            end
                                                            
                                                            local req_biu = Champion_pb.GReqChampionBiubiu()
                                                            req_biu.content = text
                                                            NetManager:sendMessage(ProtocolID.GReqChampionBiubiu, req_biu)

                                                            return true
                                                          end)
end

function ChampionLayer:createBattleReport(evt, report)

    if self.battle_layer then
        self.battle_layer:removeFromParent()
        self.battle_layer = nil
    end
    
    local battle_layer = self:addBattleLayer(BattleType.CHAMPIONSHIP,
                                             MainSceneType.MAINCITY_CHAMPIONSHIP,
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


function ChampionLayer:startBiu(evt)
    self.layer_biu:setBiuText(ex.Player.champion_data.vec_biu)
    self.layer_biu:startBiu()
end

function ChampionLayer:addBiu(evt, data)
    self.layer_biu:addBiuText(data)
end

function ChampionLayer:cleanBiu()
    self.layer_biu:clearBiu()
end

function ChampionLayer:onBiuVisible()
    local is_visible = cc.UserDefault:getInstance():getIntegerForKey("champion_biu_visible", 1)
    is_visible = is_visible == 0 and 1 or 0
    cc.UserDefault:getInstance():setIntegerForKey("champion_biu_visible", is_visible)
    self.layer_biu:setVisible(is_visible == 1)
end


function ChampionLayer:onBack()
	ex.JumpManager:jumpByAtom("main_champion_like")
end

function ChampionLayer:onHistory()
    require("src.layer.champion.ChampionListCtr"):instance():openWindow({title=ex.Tools:getLang(47651),
                                                                        class=require("src.layer.champion.ChampionMyHistoryCell"),
                                                                        file="ccbi/ChampionMyHistoryCell.ccbi",
                                                                        data_func=function()
                                                                            return ex.Player.champion_data.my_champion_battle
                                                                        end,
                                                                        event=EVENT.CHAMPION_EVENT.UPDATE_MY_CHAMPION_BATTLE})
    NetManager:sendMessage(ProtocolID.GReqScanMyChampionBattle)
end

function ChampionLayer:onShop()
	cfg.funcopen.main_shop.open(SHOP_TYPE.PVPNORMAL)
end

function ChampionLayer:onReward()
    require("src.layer.rank.RankSingleCtr"):instance():openWindow({title=ex.Tools:getLang(47370),
                                                                  class=require("src.layer.champion.ChampionRewardCell"),
                                                                  file="ccbi/DreamRewardCell.ccbi",
                                                                  data_func=function()
                                                                    local vec_reward = {}
                                                                    for i,v in ipairs(cfg.championreward.championreward) do
                                                                        if v.reward_rank_type == 0 then
                                                                            table.insert(vec_reward, v)
                                                                        end
                                                                    end
                                                                    return vec_reward
                                                                   end,
                                                                   "",
                                                                   tip=ex.Tools:getLang(70771)})
end

function ChampionLayer:onInfo()
    require("src.layer.InfoCtr"):instance():openWindow(ex.Tools:getLang(42048), ex.Tools:getLang(42049))
end


-- 层切入时会被调用
function ChampionLayer:changeLayerIn()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, true)
end

function ChampionLayer:changeLayerOutEnd()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, false)
end

return ChampionLayer