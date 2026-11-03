local SuperStageAccountCtr = class("SuperStageAccountCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SuperStageAccountLayer = class("SuperStageAccountLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

-----------------------------------------------------------------------------
function SuperStageAccountLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    self.btn_tab_1:setChecked(true)

    self.btn_tab_1:setLabelText(ex.Tools:getLang(74832))
    self.btn_tab_2:setLabelText(ex.Tools:getLang(74833))

    self.btn_tab_1:setLabelOffset(cc.p(0, -3))
    self.btn_tab_2:setLabelOffset(cc.p(0, -3))

    -- 设置左右切换按钮的灰色状态
    local spr_left = cc.Sprite:createWithSpriteFrameName("super-stage/btn-left.png")
    ex.Tools:setGrayAuto(spr_left, true)
    self.btn_left:setDisabledImage(spr_left)
    local spr_right = cc.Sprite:createWithSpriteFrameName("super-stage/btn-right.png")
    ex.Tools:setGrayAuto(spr_right, true)
    self.btn_right:setDisabledImage(spr_right)
end

-----------------------------------------------------------------------------
function SuperStageAccountCtr:onCreate()
    self:setCCBIPath("ccbi/SuperStageAccountLayer.ccbi")
    self:setIsSingle(false)
end

function SuperStageAccountCtr:getLayerClass()
    return SuperStageAccountLayer
end

function SuperStageAccountCtr:openWindow(role_id, server_id)
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData(role_id, server_id)
end

function SuperStageAccountCtr:initData(role_id, server_id)
    self.role_id = role_id
    self.server_id = server_id
    self.max_season_id = 1

    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer.btn_tab_1:registerScriptTapHandler(handler(self, self.onTab))
    self.layer.btn_tab_2:registerScriptTapHandler(handler(self, self.onTab))

    self.layer.btn_share:registerScriptTapHandler(handler(self, self.onShare))

    self.layer.btn_left:registerScriptTapHandler(handler(self, self.onSeasonLeft))
    self.layer.btn_right:registerScriptTapHandler(handler(self, self.onSeasonRight))

    self.layer:addEvent(EVENT.SUPER_STAGE.SEASON_LOG, handler(self, self.receiveEvent))

    -- 如果是自己，則顯示分享按鈕
    self.layer.btn_share:setVisible(ex.Player.role_id == role_id)

    self:onTab(1)
end

function SuperStageAccountCtr:onTab(tag, pSender)
    if pSender ~= nil and self.layer_type == tag then
        return
    end

    self.layer_type = tag

    if self.layer_type == 1 then
        self.select_season_id = -1
    else
        self.select_season_id = self.max_season_id
    end
    
    local req = StageMatchRim_pb.GReqDetailSeason()
    req.season_id = self.select_season_id
    req.rid = self.role_id
    req.server_id = self.server_id
    NetManager:sendMessage(ProtocolID.GReqDetailSeason, req)

    self:updateLayer()
end

function SuperStageAccountCtr:onSeasonLeft(tag, pSender)
    if self.select_season_id <= 2 then
        self.select_season_id = 1
    else
        self.select_season_id = self.select_season_id - 1
    end
    
    local req = StageMatchRim_pb.GReqDetailSeason()
    req.season_id = self.select_season_id
    req.rid = self.role_id
    req.server_id = self.server_id
    NetManager:sendMessage(ProtocolID.GReqDetailSeason, req)

    self:updateLayer()
end

function SuperStageAccountCtr:onSeasonRight(tag, pSender)
    if self.select_season_id >= self.max_season_id - 1 then
        self.select_season_id = self.max_season_id
    else
        self.select_season_id = self.select_season_id + 1
    end

    local req = StageMatchRim_pb.GReqDetailSeason()
    req.season_id = self.select_season_id
    req.rid = self.role_id
    req.server_id = self.server_id
    NetManager:sendMessage(ProtocolID.GReqDetailSeason, req)

    self:updateLayer()
end

function SuperStageAccountCtr:updateLayer()
    -- 设置按钮显示与可点击状态
    self.layer.btn_tab_1:setChecked(self.layer_type == 1)
    self.layer.btn_tab_2:setChecked(self.layer_type ~= 1)

    if self.layer_type == 1 then
        self.layer.btn_left:setVisible(false)
        self.layer.btn_right:setVisible(false)
    else
        self.layer.btn_left:setVisible(true)
        self.layer.btn_right:setVisible(true)

        self.layer.btn_left:setEnabled(self.select_season_id > 1)
        self.layer.btn_right:setEnabled(self.select_season_id < self.max_season_id)
    end

    -- 刷新数据显示
    local has_data = self.data ~= nil and self.data.season_id == self.select_season_id

    if self.select_season_id == -1 then
        self.layer.lbl_stage:setString(ex.Tools:getLang(74832))
    else
        self.layer.lbl_stage:setString(string.format(ex.Tools:getLang(74834), self.select_season_id))
    end
    
    -- 段位
    local str_default = ex.Tools:getLang(74845)
    local config_rank_cur = cfg.superstage.superstage[has_data and self.data.curr_stage_id or 1]
    self.layer.lbl_cur_rank:setString(has_data and ex.Tools:getLang(config_rank_cur.name_lang) or str_default)
    local config_rank_max = cfg.superstage.superstage[has_data and self.data.history_stage_id or 1]
    self.layer.lbl_top_rank:setString(has_data and (config_rank_max and ex.Tools:getLang(config_rank_max.name_lang) or str_default) or str_default)

    -- 分数
    self.layer.lbl_cur_score:setString(has_data and self.data.curr_score or 0)
    self.layer.lbl_top_score:setString(has_data and self.data.history_score or 0)

    -- 胜场
    self.layer.lbl_win_num:setString(has_data and self.data.normal_win_count or 0)
    self.layer.lbl_win_rate:setString((has_data and self.data.normal_win_rate or 0).."%")

    -- 伤害
    self.layer.lbl_top_damage:setString(has_data and self.data.history_max_dmg or 0)

    -- 连胜场数
    self.layer.lbl_top_win_num:setString(has_data and self.data.history_winning_streak or 0)

    -- mvp英雄
    if has_data and self.data.mvp_hero.hero_type > 0 then
        self.layer.node_mvp_hero:setVisible(true)
        self.layer.lbl_hero_name:setVisible(true)
        self.layer.lbl_mvp_hero_tip:setVisible(false)

        self.layer.node_mvp_hero:removeAllChildren()
        local item_hero = require("src.comp.menu.UIMenuItemHero"):createWithData("1", self.data.mvp_hero.hero_type, nil, self.data.mvp_hero.level, self.data.mvp_hero.star)
        self.layer.node_mvp_hero:addChild(item_hero)

        self.layer.lbl_hero_name:setString(ex.Tools:getLang(self.data.mvp_hero.hero_type))
    else
        self.layer.node_mvp_hero:setVisible(false)
        self.layer.lbl_hero_name:setVisible(false)
        self.layer.lbl_mvp_hero_tip:setVisible(true)
    end

    -- 最强对手
    if has_data and self.data.strongest_opponent.rid > 0 then
        self.layer.node_player_info:setVisible(true)
        self.layer.lbl_strongest_player_tip:setVisible(false)

        ex.Tools:setSpriteFrame(self.layer.spr_photo, "head-icon/"..self.data.strongest_opponent.head_id..".png")
        ex.Tools:setSpriteFrame(self.layer.spr_border, ex.Tools:getBorderIconByIdx(self.data.strongest_opponent.border_id))
        self.layer.lbl_player_name:setString(ex.StringUtil.getServerName(self.data.strongest_opponent.server)..self.data.strongest_opponent.name)
        self.layer.lbl_level:setString(self.data.strongest_opponent.level or 1)
        self.layer.lbl_player_attack:setString(self.data.strongest_opponent.fighting)
    else
        self.layer.node_player_info:setVisible(false)
        self.layer.lbl_strongest_player_tip:setVisible(true)
    end
end

function SuperStageAccountCtr:receiveEvent(event, data, max_season_id)
    if data == nil then
        return
    end

    self.max_season_id = max_season_id

    if data.season_id ~= self.select_season_id then
        return
    end

    self.data = data

    self:updateLayer()
end

-- 分享
function SuperStageAccountCtr:onShare(tag, pSender)
    local pos = {}
	local x,y = pSender:getPosition()

	pos.x = x + pSender:getContentSize().width / 2
	pos.y = y + pSender:getContentSize().height / 2 + 48

	local ctr = require("src.layer.heroinfo.HeroShareMenuCtr"):instance()--:openWindow(pos)
	local callback = handler(self,self.onShareMenuClick)
	ctr:openWindow(callback)
	ctr.layer:setLocalZOrder(1000001)

	local pos_x = pos.x - ctr.layer:getContentSize().width
    local pos_y = pos.y + ctr.layer:getContentSize().height
	ctr.layer:setPosition(pos_x,pos_y)
end

function SuperStageAccountCtr:onShareMenuClick(tag, pSender)
    local req = StageMatchRim_pb.GReqDetailSeasonShare()
    req.chat_type = tag
    NetManager:sendMessage(ProtocolID.GReqDetailSeasonShare, req)
    
    require("src.layer.heroinfo.HeroShareMenuCtr"):instance():closeWindow()
    
    ex.MessageView:add(ex.Tools:getLang(74938))
end

return SuperStageAccountCtr
