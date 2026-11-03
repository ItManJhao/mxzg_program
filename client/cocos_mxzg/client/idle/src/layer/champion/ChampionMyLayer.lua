local ChampionMyLayer = class("ChampionMyLayer", require("src.comp.EventLayer"))

function ChampionMyLayer:onCreate()
    -- self:updateLayerType()
    self:addEvent(EVENT.CHAMPION_EVENT.UPDATE_MY_CHAMPION, handler(self, self.updateLayerType))


    local menu = cpp.UIMenu:create()
    menu:setPosition(cc.p(0, 0))
    self:addChild(menu)

    self.btn_lineup = cpp.UIMenuItemLabel:create("button/btn-buy-5.png",
                                                 "button/btn-buy-5.png",
                                                 ex.Tools:getLang(47288),
                                                 nil)
    -- self.btn_lineup:setLabelColor(cc.c3b(255, 255, 255))
    -- self.btn_lineup:setLabelShadow(cc.c4b(177, 84, 0, 255), cc.size(0, -1), 10)
    self.btn_lineup:setLabelOutLine(cc.c4b(70, 6, 255, 255))
    self.btn_lineup:setLabelSize(48)
    self.btn_lineup:setPosition(ex.p.width * 0.5, ex.p.height * 0.124)
    self.btn_lineup:registerScriptTapHandler(handler(self, self.onLineup))
    menu:addChild(self.btn_lineup)
    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
end

function ChampionMyLayer:refresh()
    NetManager:sendMessage(ProtocolID.GReqMyChampionBattle)
end

function ChampionMyLayer:updateLayerType()

    if self.layer_idle then
        self.layer_idle:removeFromParent()
        self.layer_idle = nil
    end

    if self.layer_info then
        self.layer_info:removeFromParent()
        self.layer_info = nil
    end

    -- 冠军赛未开始
    if ex.Player.champion_data.my_champion.period == ChampionType.IDLE or (ex.Player.champion_data.my_champion.bid ~= nil and ex.Player.champion_data.my_champion.bid == 0) then
        self.layer_idle = require("src.layer.champion.ChampionMyCompeteLayer"):createWithCCBIFile("ccbi/ChampionMyCompeteLayer.ccbi")
        self:addChild(self.layer_idle)
    else
        self.layer_info = require("src.layer.champion.ChampionBattleInfoCell"):createWithCCBIFile("ccbi/ChampionBattleInfoCell.ccbi")
        self.layer_info:setScale(ex.s.global_scale)
        self.layer_info:setIgnoreAnchorPointForPosition(false)
        self.layer_info:setAnchorPoint(ex.a.center)
        self.layer_info:setPosition(ex.p.width * 0.5, ex.p.height * 0.45)
        self:addChild(self.layer_info)
    end

    self:updateLayer()
end

function ChampionMyLayer:updateTimer()
    if self.layer_idle then

        if ex.Player.champion_data.my_champion.period == ChampionType.IDLE then
            local time = ex.Player.champion_data.battle_start_time - ex.Game:getServerTime()
            self.layer_idle.lbl_start_time:setString(ex.StringUtil.convertToTimeFormat(math.max(0, time), 5))
            self.layer_idle.lbl_time_tip:setString(ex.Tools:getLang(47701))
            self.layer_idle.lbl_title:setString(ex.Tools:getLang(47077))
            self.layer_idle.lbl_content:setXmlTextLua(ex.Tools:getLang(70719))
        else
            local time = ex.Player.champion_data.end_time - ex.Game:getServerTime()
            self.layer_idle.lbl_start_time:setString(ex.StringUtil.convertToTimeFormat(math.max(0, time), 5))
            self.layer_idle.lbl_time_tip:setString(ex.Tools:getLang(47353))
            self.layer_idle.lbl_title:setString(ex.Tools:getLang(70773))
            self.layer_idle.lbl_content:setXmlTextLua(ex.Tools:getLang(70774))
        end
    end
end

function ChampionMyLayer:updateLayer()
    if self.layer_idle then

    elseif self.layer_info then

        self.layer_info.bid = ex.Player.champion_data.my_champion.bid or 0
        self.layer_info:setVisible(ex.Player.champion_data.my_champion.period ~= ChampionType.IDLE)
        self.layer_info.btn_report:setVisible(ex.Player.champion_data.my_champion.stage == 3 or ex.Player.champion_data.my_champion.stage == 0)
        local parent = self:getParent()
        local is_anim = false
        local which_win = ex.Player.champion_data.my_champion.stage ~= 3 and ex.Player.champion_data.my_champion.which_win or 0
        if parent then
            local old_battle = ex.Player.champion_data.my_old_battle_id
            is_anim = parent.is_run_ani and ex.Player.champion_data.my_champion.battle_id ~= old_battle
            if ex.Player.champion_data.my_champion.stage == 3  then
                ex.Player.champion_data.my_old_battle_id = ex.Player.champion_data.my_champion.battle_id
            end
            -- local is_anim = parent and parent.my_stage ~= 3 and ex.Player.champion_data.battle_stage == 3
            self.layer_info:reset({which_win = which_win, players={ex.Player.champion_data.my_champion.attacker, ex.Player.champion_data.my_champion.defender}}, is_anim)
            -- parent.my_stage = ex.Player.champion_data.battle_stage
            parent:stageBechange()
        else
            self.layer_info:reset({which_win = which_win, players={ex.Player.champion_data.my_champion.attacker, ex.Player.champion_data.my_champion.defender}}, is_anim)
        end
    end

    self:updateTimer()
end

function ChampionMyLayer:reset(type, data)

end

function ChampionMyLayer:onLineup()
    if ex.Player.champion_data.my_champion.period == ChampionType.IDLE or ex.Player.champion_data.my_champion.stage == 1 then
        require("src.layer.HeroSelectCtr"):instance():openWindow(ex.Tools:getLang(47632),
                                                                 ex.Tools:getLang(47589),
                                                                 BattleType.CHAMPIONSHIP,
                                                                 function()
                                                                    NetManager:sendMessage(ProtocolID.GReqChampionSaveFormation)
                                                                 end,
                                                                 nil,
                                                                 nil,
                                                                function()
                                                                    local can_save = ex.Player.champion_data.my_champion.period == ChampionType.IDLE or ex.Player.champion_data.my_champion.stage == 1
                                                                    if can_save ~= true then
                                                                        ex.MessageView:add(ex.Tools:getLang(70770))
                                                                    else
                                                                        ex.MessageView:add(ex.Tools:getLang(70772))
                                                                    end
                                                                    return can_save
                                                                end)
    else
        ex.MessageView:add(ex.Tools:getLang(70770))
    end
end


return ChampionMyLayer