local MagicTowerPreviewCtr = class('MagicTowerPreviewCtr', require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local MagicTowerPreviewLayer = class('MagicTowerPreviewLayer', require("src.layer.ui.UI_MagicTowerPreviewLayer"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function MagicTowerPreviewLayer:onCreate()
	self.super.onCreate(self)
	self:setName("MagicTowerPreviewLayer")

    self:addBlackBackground()
    
    self.lbl_attack:setPositionX(self.lbl_attack_title:getPositionX() + self.lbl_attack_title:getContentSize().width)
    self.lbl_name_1:setPositionX(self.lbl_name_title_1:getPositionX() + self.lbl_name_title_1:getContentSize().width)
    self.lbl_name_2:setPositionX(self.lbl_name_title_2:getPositionX() + self.lbl_name_title_2:getContentSize().width)

    self.stage = 1
    
    self:addEvent(EVENT.MAGIC_TOWER_EVENT.LOG, handler(self, self.updateStageInfo))
end

function MagicTowerPreviewLayer:updateLayer()
    self.stage_data = ex.Player.magic_tower_data:getStageData(self.stage) or {}
    self.stage_config = cfg.magictower.magictower[self.stage]

    self.lbl_title:setString(string.format(ex.Tools:getLang(57500), self.stage))
    self.lbl_attack:setString(self.stage_config.require_fighting)

    self:createSpine(self.stage_config.hero_type, self.stage_config.hero_star)
    self:updateStageCondition(self.stage_config.target, self.stage_data and self.stage_data.complete_id or {})
    self:updateStageReward((self.stage_data.complete_id ~= nil and table.nums(self.stage_data.complete_id) >= table.nums(self.stage_config.target)) and self.stage_config.first_reward or self.stage_config.reward)
    self:updateHandleState(self.stage, ex.Player.magic_tower_data:getNowStage(), self.stage_data.complete_id ~= nil and table.nums(self.stage_data.complete_id) >= table.nums(self.stage_config.target))
end

function MagicTowerPreviewLayer:onTouchHero()
	self.hero:attack()
end

function MagicTowerPreviewLayer:createSpine(hero_type, hero_star)
    if self.hero ~= nil then 
		return
	end
    hero_star = hero_star or 5

    local skin = ex.Tools:getHeroSkinByStar(hero_type, hero_star)
    self.hero = require("src.person.Hero"):create("1", "1", hero_type, 1, hero_star, skin)

	self.hero:setShadowVisible(false)
    self.hero:setScale(1.5)
    self.hero:setPosition(0, 0)
	self.hero:registerScriptTapHandler(handler(self, self.onTouchHero))
    -- self.menu:addChild(self.hero, -1)
    self.menu_hero:addChild(self.hero)
end

-- 更新层信息
function MagicTowerPreviewLayer:updateStageInfo()
    local log = ex.Player.magic_tower_data.stage_log

    self.lbl_name_1:setString((log ~= nil and log.fast_pass.rid > 0) and ex.StringUtil.getServerName(log.fast_pass.server_id)..log.fast_pass.name or ex.Tools:getLang(47593))
    self.lbl_name_2:setString((log ~= nil and log.min_fighting_pass.rid > 0) and ex.StringUtil.getServerName(log.min_fighting_pass.server_id)..log.min_fighting_pass.name or ex.Tools:getLang(47593))
end

-- 更新层条件
function MagicTowerPreviewLayer:updateStageCondition(vec_target, vec_complete_id)
    for i,v in ipairs(vec_target) do
        self["lbl_condition_"..i]:setString(ex.Tools:getLang(cfg.magictowertarget.magictowertarget[v].language))
        self["spr_star_"..i]:setVisible(TableEx.isInTable(vec_complete_id, v) ~= nil)
    end
end

-- 更新层奖励
function MagicTowerPreviewLayer:updateStageReward(vec_reward)
    self.menu_reward:removeAllChildren()

    for i,item_data in ipairs(vec_reward) do
        local item = UIItemBackpack:createWithData(item_data.item_type, item_data.item_num)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        self.menu_reward:addChild(item)
    end

	self:resetLyt()
end

-- 更新层挑战状态
function MagicTowerPreviewLayer:updateHandleState(cur_stage, now_stage, is_complete)
    self.btn_challenge:setVisible(cur_stage <= now_stage + 1)
    self.btn_sweep:setVisible(is_complete)

	self:resetLyt()
end

-- 战报按钮回调
function MagicTowerPreviewLayer:onLog(tag, pSender)
    local stage_log = ex.Player.magic_tower_data.stage_log
    if stage_log.fast_pass.rid <= 0 and stage_log.min_fighting_pass.rid <= 0 and stage_log.self.rid <= 0 then
        ex.MessageView:add(ex.Tools:getLang(57532))
        return
    end

    require("src.layer.magictower.MagicTowerLogCtr"):instance():openWindow(handler(self, self.onLogShow))
end

-- 挑战按钮回调
function MagicTowerPreviewLayer:onChallenge(tag, pSender)
    if self.stage > ex.Player.magic_tower_data:getNowStage() + 1 then
        return
    end

    if ex.Player.magic_tower_data.can_challenge_times <= 0 then
        ex.MessageView:add(ex.Tools:getLang(57537))
        return
    end

    require('src.layer.HeroSelectCtr'):instance():openWindow(
        ex.Tools:getLang(47524),
        ex.Tools:getLang(47064),
        BattleType.MAGIC_TOWER,
        handler(self, self.onBattleDone)
    )
end

-- 扫荡按钮回调
function MagicTowerPreviewLayer:onSweep(tag, pSender)
    if self.stage > ex.Player.magic_tower_data:getNowStage() + 1 then
        return
    end

    if self.stage_data.complete_id ~= nil and table.nums(self.stage_data.complete_id) < 3 then
        ex.MessageView:add(ex.Tools:getLang(57506))
        return
    end

    if ex.Player.magic_tower_data.can_challenge_times <= 0 then
        ex.MessageView:add(ex.Tools:getLang(57537))
        return
    end

    local req = MagicTower_pb.GReqMagicTowerSweep()
    req.idx = self.stage
    NetManager:sendMessage(ProtocolID.GReqMagicTowerSweep, req)
end

function MagicTowerPreviewLayer:onBattleDone(vec_hero, fetter_type)
    if self.is_battle then
        self:onClose()
        return
    end

    self.is_battle = true

    if self.callback then
        self.callback(self.stage, vec_hero, fetter_type)
    end
    
    self:onClose()
end

function MagicTowerPreviewLayer:onLogShow(server_id, battle_id)
    local req = MagicTower_pb.GReqMagicTowerQuery()
    req.server_id = server_id
    req.battle_id = battle_id
    NetManager:sendMessage(ProtocolID.GReqMagicTowerQuery, req)

    self:onClose()
end

-----------------------------------------------------------------------------
function MagicTowerPreviewCtr:loadLayer()
	local tmp_layer = MagicTowerPreviewLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function MagicTowerPreviewCtr:openWindow(stage, callback)
    if self:isOpened() then
        return
    end
    
    self:loadLayer()
    self:open()
    self:initData(stage, callback)
end

function MagicTowerPreviewCtr:initData(stage, callback)
    self.layer.stage = stage
    self.layer.callback = callback
    self.layer:updateLayer()

    local req = MagicTower_pb.GReqMagicTowerLevelPassDetail()
    req.level = stage
    NetManager:sendMessage(ProtocolID.GReqMagicTowerLevelPassDetail, req)
end

return MagicTowerPreviewCtr
