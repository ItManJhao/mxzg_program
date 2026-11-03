--[[
    func: 天梯挑战对手界面
    author:徐东浩
    time:2020-01-04 21:14:12
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local LadderChallengeCtrl = class("LadderChallengeCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local LadderChallengeLayer = class("LadderChallengeLayer", require("src.comp.EventLayer"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function LadderChallengeLayer:onCreate()
    self:addBlackBackground()
	local height = Maths.min(self:getContentSize().height, ex.p.height);
    self:setScale(height / self:getContentSize().height);

    self.menu_hero = cpp.UIMenu:create()
    self.menu_hero:setSwallowsTouches(true)
    self.menu_hero:setPosition(cc.p(0, 0))
    self.menu_hero:setLocalZOrder(10)
    self:addChild(self.menu_hero)
end

function LadderChallengeLayer:refreshHeadInfo(role_info)
    ex.Tools:setSpriteFrame(self.spr_photo, string.format("head-icon/%d.png", role_info.head_id))
    ex.Tools:setSpriteFrame(self.spr_photo_bg, ex.Tools:getBorderIconByIdx(role_info.border_id))
    
    self.lbl_level:setString(tostring(role_info.level))
    self.lbl_name:setString(string.format("%s%s", ex.StringUtil.getServerName(role_info.server_id), tostring(role_info.nick)))
    self.lbl_rank:setString(tostring(role_info.ladder_rank))
    self.lbl_clan_name:setString(string.format(ex.Tools:getLang(47008), (role_info.clan_name == nil or string.len(role_info.clan_name) > 0) and tostring(role_info.clan_name) or ex.Tools:getLang(47258)))
end

function LadderChallengeLayer:setPassTeam(is_pass)
    self.btn_pass_team:setChecked(is_pass)
end

function LadderChallengeLayer:setPower(power)
    self.lbl_battle_count:setString(tostring(power))
end

function LadderChallengeLayer:refreshTeam(power, hero_datas, formation_id)

    

    self:setPower(power)

    if hero_datas == nil then
        return
    end

    if formation_id == nil or formation_id <= 0 then formation_id = 1 end

    self.node_hero:removeAllChildren()

    local menu = cpp.UIMenu:create()
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    :setName("menu_hero")
    self.node_hero:addChild(menu)

    local getHeroDataByPos = function(pos)
        for k,v in pairs(hero_datas) do
            if v.pos == pos then
                return v
            end 
        end
        return nil
    end

    local config_matrix = cfg.battlematrixaddition.battlematrixaddition
    for pos=1,LineupNum do
        local is_open = false
        for _,matrix in pairs(config_matrix) do
            if matrix.type == formation_id and matrix.position == pos then
                is_open = matrix.is_open == 1
                break
            end
        end

        local item = nil
        if is_open == false then
            item = cc.Sprite:createWithSpriteFrameName("hero-select/spr-lock.png")
            item:setScale(1.1)
            self.node_hero:addChild(item)
        else
            local data = getHeroDataByPos(pos)
            if data ~= nil then
                local hero_config = cfg.herotype.star[data.hero_type]
                item = UIMenuItemHero:createWithData(data.hero_id, data.hero_type, hero_config ~= nil and hero_config.elem or 0, data.level, data.star)
            else
                item = UIMenuItemHero:createWithData(0, 0, 0, 0, 0)
            end

            item:setScale(0.8)
            menu:addChild(item)
        end

        local pos_idx_x = pos > 4 and pos - 4 or pos
        local pos_idx_y = pos > 4 and 1 or 0

        item:setPosition(496 - pos_idx_x * 106, 158 - pos_idx_y * 100)
    end
end

-----------------------------------------------------------------------------
function LadderChallengeCtrl:onCreate()
    self:setCCBIPath("ccbi/LadderChallengeLayer.ccbi")
    
    self:setIsSingle(false)

    self.data = {}
    self.user_default_key = "is_pass_team_for_ladder"

    self.show_heros = {}
    self.battle_parent_layer = nil
end

function LadderChallengeCtrl:openWindow(data, battle_parent_layer)
	if self:isOpened() then
		return
    end
    
    self.data = {}
    self.data = data
    self.battle_parent_layer = battle_parent_layer
    
	self:loadLayer()
    self:open()

    ex.Player.league_data:reqLadderLineUpData(self.data.role_info.rid)
    
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/fantasy-land.plist")
    sfc:addSpriteFrames("ccbi-res/fantasy-land-lang.plist")
    sfc:addSpriteFrames("ccbi-res/hero-select.plist")

	self:init()
end

function LadderChallengeCtrl:getLayerClass()
	return LadderChallengeLayer
end

function LadderChallengeCtrl:closeWindow()
    self.data = {}
    self.show_heros = {}
    self.is_battle = false
    self.battle_parent_layer = nil

	self:close(self.layer)
end

function LadderChallengeCtrl:init()
    self.layer.btn_battle:registerScriptTapHandler(handler(self, self.onBattle))
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_pass_team:registerScriptTapHandler(handler(self, self.onPassTeam))
    self.layer:addEvent(EVENT.LADDER_EVENT.BATTLE_RESULT, handler(self, self.onBattleResult))
    
    -- dump(self.show_heros, "show_heros")
	self:updateLayer()
end

function LadderChallengeCtrl:updateLayer()
    self.layer:refreshHeadInfo(self.data.role_info)

    local is_pass = cc.UserDefault:getInstance():getBoolForKey(self.user_default_key, false)
    self.layer:setPassTeam(is_pass)
end

function LadderChallengeCtrl:onPassTeam(tag, pSender)
    cc.UserDefault:getInstance():setBoolForKey(self.user_default_key, self.layer.btn_pass_team:isChecked())
end

function LadderChallengeCtrl:onBattle()
    if self.layer.btn_pass_team:isChecked() then
        self:onPreFight()
    else
        require("src.layer.HeroSelectCtr"):instance():openWindow(ex.Tools:getLang(47524),
                                                                  ex.Tools:getLang(47064),
                                                                  BattleType.LADDER_ATTACKER,
                                                                  handler(self, self.onPreFight))
    end
end

function LadderChallengeCtrl:onPreFight()
    if self.is_battle then
        ex.MessageView:add(ex.Tools:getLang(47303))
        return
    end

    -- 发送副本战斗请求
    ex.Player.league_data:reqChallenge(self.data.role_info.rid)
end

-- 接收战斗结果事件，判断进入条件，并处理
function LadderChallengeCtrl:onBattleResult(e, data)
    if data.code ~= 0 then
        ex.MessageView:add(ex.Tools:getLang(70314))

        ex.Player.league_data:reqRefreshDefends()

        self:closeWindow()
        return
    end

    if self.is_battle then
        ex.MessageView:add(ex.Tools:getLang(47303))
        return
    end
    
    self.is_battle = true

    self.battle_parent_layer.battle_result = data

    self.battle_parent_layer:onBattle()

    self:closeWindow()

    ex.EventManager:fire(EVENT.LADDER_EVENT.BATTLE_REPORT, data.report)
end

-- 接收防守者阵容并显示
function LadderChallengeCtrl:refreshTeam(data)
    if not self:isOpened() then
		return
    end

    if data.code ~= 0 then
        ex.MessageView:add(ex.Tools:getLang(70314))

        ex.Player.league_data:reqRefreshDefends()

        self:closeWindow()
        return
    end

    self.layer:refreshTeam(data.fight, data.hero_data, data.formation_id)
end

return LadderChallengeCtrl
