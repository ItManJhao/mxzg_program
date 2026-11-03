local MagicTowerLayer = class("MagicTowerLayer", require("src.layer.ui.UI_MagicTowerLayer"))
local MagicTowerCell = class("MagicTowerCell", require("src.layer.ui.UI_MagicTowerCell"))

MagicTowerLayer.ctr = ctr.magic_tower

function MagicTowerCell:onCreate()
    self.super.onCreate(self)
	self:setName("MagicTowerCell")

    self:setAnchorPoint(cc.p(0.5, 0.5))
    self:setIgnoreAnchorPointForPosition(false)

    self.menu_challenger:setSwallowsTouches(false)
    self.menu_stage:setSwallowsTouches(false)
end

function MagicTowerCell:resetData(data)
    self:setVisible(table.nums(data) > 0)

    if table.nums(data) <= 0 then
        return
    end

    if data.level <= 0 then
        self.node_stage_info:setSpriteFrame("magic-tower/spr-stage-bg-1.png")
        self.lbl_stage_name:setVisible(false)
        self.spr_star_bg_1:setVisible(false)
        self.spr_star_bg_2:setVisible(false)
        self.spr_star_bg_3:setVisible(false)
        self.node_flag:setVisible(false)
        return
    elseif data.is_max then
        self.node_stage_info:setSpriteFrame("magic-tower/spr-stage-bg-3.png")
        self.lbl_stage_name:setVisible(false)
        self.spr_star_bg_1:setVisible(false)
        self.spr_star_bg_2:setVisible(false)
        self.spr_star_bg_3:setVisible(false)
        self.node_flag:setVisible(false)
        return
    end

    self.data = data

    self.node_flag:setVisible(data.level % 5 == 0 and data.challenger_data ~= nil)
    self.lbl_stage_name:setString(string.format(ex.Tools:getLang(57500), data.level))

    local star_num = data.stage_data == nil and 0 or table.nums(data.stage_data.complete_id)
    self.spr_star_1:setVisible(star_num >= 1)
    self.spr_star_2:setVisible(star_num >= 2)
    self.spr_star_3:setVisible(star_num >= 3)

    if data.challenger_data ~= nil then
        self.lbl_name:setString(ex.StringUtil.getServerName(data.challenger_data.server_id)..data.challenger_data.name)
        ex.Tools:setSpriteFrame(self.spr_border, ex.Tools:getBorderIconByIdx(data.challenger_data.broad_id or 0))
        ex.Tools:setSpriteFrame(self.spr_photo, string.format("head-icon/%d.png", data.challenger_data.head_id))
    end

    if data.is_show_sword then
        -- 添加刀剑特效
        local spine_sword = sp.SkeletonAnimation:create("spine/battle-sword.json","spine/battle-sword.atlas", 1)
        spine_sword:setAnimation(0, "stand", true);
        spine_sword:setPosition(self.node_stage_info:getPositionX(), self:getContentSize().height * 0.5 - 50)
        spine_sword:setScale(0.5)
        spine_sword:setName("tower_cur_cell")
        self:addChild(spine_sword, 10)
    end

	self:resetLyt()
end

function MagicTowerCell:onStage()
    if self.data ~= nil and self.data.callback ~= nil then
        self.data.callback(self.data.level)
    end
end

function MagicTowerCell:onPhoto()
    if self.data ~= nil and self.data.challenger_data ~= nil then
        ex.Tools:showPlayerInfo(self.data.challenger_data.rid, self.data.challenger_data.player_server_id)
    end
end

function MagicTowerCell:onChallenger()
    if self.data.callback_challenger ~= nil then
        self.data.callback_challenger(self.data.level)
    end
end

-----------------------------------------------------------------------------
function MagicTowerLayer:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/magic-tower.pvr.ccz", plist_name = "ccbi-res/magic-tower.plist", remove_type=2},
        {image_name = "ccbi-res/magic-tower-lang.pvr.ccz", plist_name = "ccbi-res/magic-tower-lang.plist", remove_type=2},
    }
    return vec_image
end

function MagicTowerLayer:onCreate()
    self.super.onCreate(self)
	self:setName("MagicTowerLayer")

    self:setAutoClose(false)
    self:setSwallowTouches(false)

    local win_size = cc.Director:getInstance():getWinSize()

    self.spr_bg = cc.Sprite:create("ccbi-res/map-bg-magic-tower.jpg")
    local scale_x = win_size.width / self.spr_bg:getContentSize().width
    local scale_y = win_size.height / self.spr_bg:getContentSize().height
    self.spr_bg:setScale(scale_x > scale_y and scale_x or scale_y)
    self.spr_bg:setPosition(cc.p(win_size.width * 0.5, win_size.height * 0.5))
    self:addChild(self.spr_bg, -2)

    self.menu_right_top:setPositionY(self.menu_right_top:getPositionY() - require("src.model.Game"):instance():getNotchHeight())

    self.lbl_rank_self:setPositionX(self.lbl_rank_self_title:getPositionX() + self.lbl_rank_self_title:getContentSize().width + 10)

    self:addEvent(EVENT.MAGIC_TOWER_EVENT.UPDATE, handler(self, self.updateLayer))
    self:addEvent(EVENT.MAGIC_TOWER_EVENT.STAGE_GOTO, handler(self, self.stageGoto))
    self:addEvent(EVENT.MAGIC_TOWER_EVENT.RANK, handler(self, self.updateRank))
    self:addEvent(EVENT.MAGIC_TOWER_EVENT.CHALLENGE_TIMES, handler(self, self.updateBuyTimes))

    self:addRedDotNode(RedDotType.ZCJ_DHZC_HJZT_HMT_ZMZL, self.btn_road)
end

function MagicTowerLayer:onEnterFinish()
    ex.Player.rank_data:onRefresh(18)
end

function MagicTowerLayer:allResLoadDone()
    self.cell_size = cc.Sprite:createWithSpriteFrameName("magic-tower/spr-stage-bg-2.png"):getContentSize()

    self:updateLayer()
end


function MagicTowerLayer:getLayerOffset()
    return cc.p(0, -require("src.model.Game"):instance():getNotchHeight())
end

function MagicTowerLayer:updateRank()
    for i=1,3 do
        local rank_data = ex.Player.rank_data.rank_magic_tower_list[i]
        local name = rank_data and rank_data.name or ex.Tools:getLang(47593)
        local stage = rank_data and string.format(ex.Tools:getLang(6201), rank_data.pass_level) or ""
        self["lbl_rank_name_"..i]:setString(name)
        self["lbl_rank_stage_"..i]:setString(stage)
    end

    self.lbl_rank_self:setString((ex.Player.rank_data.rank_magic_tower_self.rank == nil or ex.Player.rank_data.rank_magic_tower_self.rank <= 0) and ex.Tools:getLang(47749) or ex.Player.rank_data.rank_magic_tower_self.rank)
end

function MagicTowerLayer:updateBuyTimes()
    local max_free_times = ex.Tools:getSysCfg("magic_tower_daily_free_times") 
    self.lbl_challenge_times:setString(string.format("%d/%d", ex.Player.magic_tower_data.can_challenge_times, max_free_times))
    self.lbl_buy_times:setString(string.format("%d", table.nums(cfg.magictowerdailybuy.magictowerdailybuy) - ex.Player.magic_tower_data.buy_times))
end

function MagicTowerLayer:stageGoto(event, stage)
    local tower_max = table.nums(cfg.magictower.magictower)

    -- 当前位置居中显示
    local y = (stage + 0.5) * self.cell_size.height
    y = y - self.scroll_view:getSize().height * 0.5
    y = math.max(y, 0)
    local percentage = 100 - y / tower_max / self.cell_size.height * 100.0

    -- 设置位置
    self.scroll_view:scrollToPercentVertical(percentage, 0, false)
end

function MagicTowerLayer:updateLayer()
    local now_stage = ex.Player.magic_tower_data:getNowStage()

    self:updateRank()
    self:updateBuyTimes()

    self.scroll_view.createItemFunction = function(data, scale)
		local item = MagicTowerCell:create()
		item:resetData(data)
		return item
	end

    local stage_data_list = {}
    table.insert(stage_data_list, {})
    table.insert(stage_data_list, {level = 999, is_max = true})
    local tower_max = table.nums(cfg.magictower.magictower)
    for i=1,tower_max do
        local config_data = clone(cfg.magictower.magictower[tower_max - i + 1])
        config_data.stage_max = tower_max
        config_data.challenger_data = nil
        config_data.is_show_sword = (config_data.level == now_stage + 1)
        config_data.is_max = false
        config_data.callback_challenger = handler(self, self.onChallengeArena)
        config_data.stage_data = ex.Player.magic_tower_data:getStageData(config_data.level)
        config_data.callback = handler(self, self.onStageCellTouched)

        for _,challenger_data in ipairs(ex.Player.magic_tower_data.challenger_list) do
            if challenger_data.level == config_data.level then
                config_data.challenger_data = challenger_data
                break
            end
        end

        table.insert(stage_data_list, config_data)
    end
    table.insert(stage_data_list, {level = 0})
    self.scroll_view:reloadData(stage_data_list)

    -- 当前位置居中显示
    self:stageGoto("", now_stage + 1)
end

function MagicTowerLayer:onStageCellTouched(stage)
    require("src.layer.magictower.MagicTowerPreviewCtr"):instance():openWindow(stage, handler(self, self.createBattleShow))
end

function MagicTowerLayer:onChallengeArena(stage)
    local challenger_data = ex.Player.magic_tower_data:getChallengerData(stage)
    if challenger_data == nil then
        return
    end

    if challenger_data.rid == ex.Player.role_id then
        ex.MessageView:add(ex.Tools:getLang(57538))
        return
    end

    local stage_data = ex.Player.magic_tower_data:getStageData(stage)
    if stage_data == nil or
        stage_data.complete_id == nil or 
        table.nums(stage_data.complete_id) < 3 then

        ex.MessageView:add(ex.Tools:getLang(57539))
        return
    end

    local req_battle = MagicTower_pb.GReqMagicTowerChallengeArena()
    req_battle.idx = stage
    NetManager:sendMessage(ProtocolID.GReqMagicTowerChallengeArena, req_battle)
end

function MagicTowerLayer:createBattleShow(stage, vec_battle, fetter_type)
    -- 判断体力值
    if ex.Player.magic_tower_data.can_challenge_times <= 0 then
        ex.MessageView:add(ex.Tools:getLang(47527))
        return
    end

    local req_battle = MagicTower_pb.GReqMagicTowerChallenge()
    req_battle.idx = stage
    NetManager:sendMessage(ProtocolID.GReqMagicTowerChallenge, req_battle)
end

function MagicTowerLayer:createBattleLogShow(server_id, battle_id)
    -- 判断体力值
    if ex.Player.magic_tower_data.can_challenge_times <= 0 then
        ex.MessageView:add(ex.Tools:getLang(47527))
        return
    end

    local req_battle = MagicTower_pb.GReqMagicTowerQuery()
    req_battle.server_id = server_id
    req_battle.battle_id = battle_id
    NetManager:sendMessage(ProtocolID.GReqMagicTowerQuery, req_battle)
end

function MagicTowerLayer:onBattleEnd(event, is_win)
    self:updateLayer()

    ex.Tools:autoPlaySceneMusic()
end

function MagicTowerLayer:onBuyTimes(tag, pSender)
    local config = cfg.magictowerdailybuy.magictowerdailybuy[ex.Player.magic_tower_data.buy_times + 1]
    if config == nil then
        ex.MessageView:add(ex.Tools:getLang(47386))
        return
    end

    ex.ConfirmCtr:openWindow(ex.Tools:getLang(41301), string.format(ex.Tools:getLang(54509), config.need[1].item_type, config.need[1].item_num), function()
        NetManager:sendMessage(ProtocolID.GReqMagicTowerBuyCount)
    end)
end

function MagicTowerLayer:onBack(tag, pSender)
    if not ex.MainSceneCtr:backLastLayer() then
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
    end
end

function MagicTowerLayer:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(57501), ex.Tools:getLang(57502))
end

function MagicTowerLayer:onRank(tag, pSender)
    ex.Player.rank_data:onRefresh(18)
    require("src.layer.RankTopThreeCtr"):instance():openWindow(18)
end

function MagicTowerLayer:onShop(tag, pSender)
    require("src.layer.magictower.MagicTowerShopCtr"):instance():openWindow()
end

function MagicTowerLayer:onRoad(tag, pSender)
    require("src.layer.magictower.MagicTowerRewardCtr"):instance():openWindow()
end

function MagicTowerLayer:onStarSelect(tag, pSender)
    require("src.layer.magictower.MagicTowerStarSelectCtr"):instance():openWindow()
end

return MagicTowerLayer
