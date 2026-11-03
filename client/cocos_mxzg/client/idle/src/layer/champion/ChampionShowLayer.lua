local ChampionShowLayer = class("ChampionShowLayer", require("src.comp.EventLayer"))

function ChampionShowLayer:onExit()

end

function ChampionShowLayer:onCreate()
    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    self.spr_bg:setScaleY(ex.p.height / self.spr_bg:getContentSize().height)


    self.node_top1:setPositionY(self.node_top1:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.node_top2:setPositionY(self.node_top2:getPositionY() - require("src.model.Game"):instance():getNotchHeight())

    self:updateWorship()
    self:updateLayer()


    self:addEvent(EVENT.CHAMPION_EVENT.UPDATE_SHOW_LAYER, handler(self, self.updateLayer))
    self:addEvent(EVENT.CHAMPION_EVENT.UPDATE_LIKE, handler(self, self.updateLike))

    NetManager:sendMessage(ProtocolID.GReqScanChampion)

    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)

    ex.EffectCtr:playNormalEff(25, self.btn_pvp:getContentSize().width / 2, self.btn_pvp:getContentSize().height * 0.83, nil, self.btn_pvp, 0)
end

function ChampionShowLayer:updateWorship()

end

function ChampionShowLayer:updateTimer()
    -- 更新赛季倒计时
    local is_in_season = ex.Player.champion_data:isInSeason()
    if  is_in_season then
        local now_time = ex.Game:getServerTime()
        local season_time2 = string.format(ex.Tools:getLang(47391), ex.StringUtil.convertToHowLongHour(math.max(0, ex.Player.champion_data.end_time - now_time)))
        self.lbl_season_time2:setString(season_time2)
        self.lbl_season_time2:setPositionX(self.lbl_season_time1:getPositionX() + self.lbl_season_time1:getContentSize().width + 2)
    else
        self.lbl_season_time2:setString("")
    end
end

function ChampionShowLayer:updateLayer()

    local getRankText = function(rank)
        if rank <= 0 then
            return ex.Tools:getLang(47749)
        end
        return tostring(rank)
    end

    local battle_status = ex.Player.champion_data:getBattleStatus()
    if battle_status == ChampionType.NOT_START then
        self.lbl_season_status:setString(ex.Tools:getLang(47415))
    elseif battle_status == ChampionType.END then
        self.lbl_season_status:setString(ex.Tools:getLang(47727))
    else
        self.lbl_season_status:setString(ex.Tools:getLang(70703 + ex.Player.champion_data.period))
    end


    self.lbl_my_rank:setString(getRankText(ex.Player.champion_data.rank))
    self.lbl_my_rank_max:setString(getRankText(ex.Player.champion_data.rank_max))

    local season_time1 = os.date("%m.%d", ex.Player.champion_data.start_time) .. "-" .. os.date("%m.%d", ex.Player.champion_data.end_time)
    self.lbl_season_time1:setString(season_time1)

    self.lbl_worship_count:setString(ex.Player.champion_data.worship_count)
    self:updateTimer()

    -- 虚位以待
    for i=1,3 do
        local player_data = TableEx.findValueFunction(ex.Player.champion_data.vec_rank, function(value)
            return value.rank == i
        end)

        self["btn_like"..i].data = player_data
        self["node_hero"..i]:removeAllChildren()
        self["btn_like"..i]:setVisible(player_data ~= nil)
        self["lbl_like"..i]:setVisible(player_data ~= nil)

        if player_data then
            local hero = require("src.person.Hero"):create("1", "1", 1, 1, ex.Tools:getHeroSkinByImageId(player_data.image_id)) 
            hero:setScale(i == 1 and 1.2 * 1.42 or 1 * 1.42)
            self["node_hero"..i]:addChild(hero)

            self["lbl_name"..i]:setString(player_data.name)
            self["lbl_like"..i]:setString(player_data.like)
        else
            self["lbl_name"..i]:setString(ex.Tools:getLang(47593))
            -- TEST展示自己的形象
            -- local hero_type = 10505014
            -- local hero_star = 12
            -- local skin = ex.Tools:getHeroSkinByStar(hero_type, hero_star)
            -- local hero = require("src.person.Hero"):create("12323", "123213", hero_type, 1, hero_star, skin)
            -- hero:setScale(i == 1 and 1.2 or 1)
            -- self["node_hero"..i]:addChild(hero)
        end
    end
    self:updateLike()
end

function ChampionShowLayer:updateLike()
    for i=1,3 do
        local player_data = TableEx.findValueFunction(ex.Player.champion_data.vec_rank, function(value)
            return value.rank == i
        end)

        self["lbl_like"..i]:setVisible(player_data ~= nil)

        if player_data then
            self["lbl_like"..i]:setString(player_data.like)

            local is_like = ex.Player.champion_data:isLike(player_data.rid)
            ex.Tools:setGrayAuto(self["btn_like"..i]:getNormalImage(), is_like)
            self["btn_like"..i]:setEnabled(is_like == false)
        end
    end

end

function ChampionShowLayer:onChampion()
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CHAMPIONSHIP)
end

function ChampionShowLayer:onInfo()
    require("src.layer.InfoCtr"):instance():openWindow(ex.Tools:getLang(42048), ex.Tools:getLang(42049))
end


function ChampionShowLayer:onLineup()
    if ex.Player.champion_data.my_champion.period == ChampionType.IDLE or ex.Player.champion_data.my_champion.stage == 1 then
        require("src.layer.HeroSelectCtr"):instance():openWindow(ex.Tools:getLang(47632),
                                                                 ex.Tools:getLang(47589),
                                                                 BattleType.CHAMPIONSHIP,
                                                                 function(  )
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
-- LineupType.CHAMPIONSHIP

function ChampionShowLayer:onImageSetting()
    require("src.layer.SettingChooseCtr"):instance():openWindow(3)
end

function ChampionShowLayer:onLike(tag, pSender)
    if pSender.data == nil then
        return
    end

    if ex.Player.champion_data:isLike(pSender.data.rid) then
        return
    end

    if ex.Player.champion_data:isLimitLike() then
        -- ex.MessageView:add(string.format(ex.Tools:getLang(47504), ex.Tools:getSysCfg("champion_max_like")))
        ex.MessageView:add(ex.Tools:getLang(70768))
        return
    end

    local req_like = Champion_pb.GReqChampionLike()
    req_like.rid = pSender.data.rid
    NetManager:sendMessage(ProtocolID.GReqChampionLike, req_like)
end

function ChampionShowLayer:onPvp()
    ex.JumpManager:jumpByAtom("main_pvp")
end

function ChampionShowLayer:onBack()
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
end

function ChampionShowLayer:onRank()
	local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CHAMPIONSHIP)
	if layer then
		layer.selected_type = 4
		layer:updateLayerType()
		layer:updateTitle()
	end
end



return ChampionShowLayer