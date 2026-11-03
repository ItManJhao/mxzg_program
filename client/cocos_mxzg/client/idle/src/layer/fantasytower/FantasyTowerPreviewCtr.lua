local FantasyTowerPreviewCtr = class('FantasyTowerPreviewCtr', require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local FantasyTowerPreviewLayer = class('FantasyTowerPreviewLayer', require("src.comp.EventLayerAdaptiveWidth"))

function FantasyTowerPreviewLayer:onCreate()
    self:addBlackBackground()
    -- self.scroll_view_emeny:setBounceable(false)
    self.scroll_view_reward:setBounceable(false)
    
    self.btn_confirm:setLabelText(ex.Tools:getLang(5566))
    self.btn_confirm:setName("tower_battle")
    self.btn_confirm:setLabelSize(50)
    self.btn_confirm:setLabelScale(0.5)
    -- self.btn_confirm:setLabelOutLine(FONT_BROWN_C4B, 2)

    self.btn_sweep:setLabelText(ex.Tools:getLang(47413))
    self.btn_sweep:setLabelSize(50)
    self.btn_sweep:setLabelScale(0.5)
    -- self.btn_sweep:setLabelOutLine(FONT_DARK_BLUE_C4B, 2)

    self:reorderChild(self.spr_title_bg, 100)
    self:reorderChild(self.lbl_satge, 101)

    self.lbl_desc = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#784100")
	:setAnchorTextShadow(true)
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	:setContentSize(cc.size(540, 60))
	:setPosition(cc.p(41, 500))
	:setAnchorPoint(cc.p(0, 1))
    self:addChild(self.lbl_desc)
    
    self:addEvent(EVENT.TOWER_EVENT.TOWER_LOG, handler(self, self.updateReport))
end

function FantasyTowerPreviewLayer:updateReport()
    local data = ex.Player.tower_data.log
    if data == nil then
        return
    end

    -- 不是当前层数的数据
    if self.stage ~= data.stage then
        return
    end

    self.lbl_name_quick:setString(data.fastest.role_name ~= "" and data.fastest.role_name or ex.Tools:getLang(47593))
    self.lbl_name_low:setString(data.fastest.role_name ~= "" and data.lowest.role_name or ex.Tools:getLang(47593))
end


function FantasyTowerPreviewLayer:onReport()
    require("src.layer.fantasytower.FantasyTowerLogCtr"):instance():openWindow()
end

-----------------------------------------------------------------------------
function FantasyTowerPreviewCtr:onCreate()
    self:setCCBIPath('ccbi/FantasyTowerPreviewLayer.ccbi')
    self:setIsSingle(false)
end

function FantasyTowerPreviewCtr:getLayerClass()
    return FantasyTowerPreviewLayer
end

function FantasyTowerPreviewCtr:getFantasyTowerPreviewLayer()
    return self.layer
end

function FantasyTowerPreviewCtr:openWindow(stage, callback)
    if self:isOpened() then
        return
    end
    
    self:loadLayer()
    self:open()
    self:initData(stage, callback)
end

function FantasyTowerPreviewCtr:initData(stage, callback)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    
	self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onBattle))
    self.layer.btn_sweep:registerScriptTapHandler(handler(self, self.onSweep))
    
    local layer = self.layer
    layer.stage = stage
    layer.callback = callback

    local now_stage = ex.Player.tower_data:getNowStage()

    layer.lbl_satge:setString(string.format(ex.Tools:getLang(47016), stage))

    local vec_monster = ex.Player.tower_data:getMonsterList(stage)

    if stage == now_stage then
        -- layer.lbl_reward_tip:setString(ex.Tools:getLang(47088))
        layer.lbl_battle_tip:setVisible(true)
        layer.btn_sweep:setVisible(false)
        layer.btn_confirm:setVisible(true)
        layer.lbl_sweep_times:setVisible(false)
        layer.btn_confirm:setPositionX(layer:getContentSize().width / 2)
    else
        -- layer.lbl_reward_tip:setString(ex.Tools:getLang(47203))
        layer.lbl_battle_tip:setVisible(false)
        layer.btn_sweep:setVisible(true)
        layer.btn_confirm:setVisible(false)
        layer.lbl_sweep_times:setVisible(true)
        layer.btn_sweep:setPositionX(layer:getContentSize().width / 2)

        self:updateSweepStatue()
    end

    local UIMenu = require('src.comp.menu.UIMenu')

    -- 显示怪物
    local margin = 0 -- 边距
    local item_size = cc.size(170, 100)
    local num = #vec_monster

    if layer.spine_hero ~= nil then
        layer.spine_hero:removeFromParent()
        layer.spine_hero = nil
    end

    if num > 1 then
        local data = vec_monster[1]
        local skin = ex.Tools:getHeroSkinByStar(data.hero_type, data.hero_star)
        layer.spine_hero = require("src.person.Hero"):create("1", "1", data.hero_type, 1, data.hero_star,skin)
        layer.spine_hero:setScale(1.3 * 1.42)
        layer.spine_hero:setPosition(layer:getContentSize().width / 2, 650)
        layer.spine_hero:registerScriptTapHandler(handler(self, self.onTouchHero))
        layer:addChild(layer.spine_hero)
    end

    -- 计算战斗力
    local config = cfg.towerreward.towerreward[stage]
    local battle = config.battle_advice
    -- for i = 1, num do
    --     local data = vec_monster[i]
    --     local stage = ex.Player.hero_data:getHeroStageByLevel(data.hero_level)
    --     battle =
    --         battle + ex.Player.hero_data:getHeroAttribute(data.hero_type, stage, data.hero_star, data.hero_level).bat
    -- end
    layer.lbl_battle:setString(string.format('%d', battle))
    layer.lbl_desc:setXmlTextLua(ex.Tools:getLang(config.mission_tip))

    -- 显示奖励
    local menu_reward = UIMenu:create()
    menu_reward:setSwallowsTouches(false)
    menu_reward:setPosition(cc.p(0, 0))
    menu_reward:setIsTouchInsideNode(layer.scroll_view_reward)
    layer.scroll_view_reward:getContainer():addChild(menu_reward)

    local vec_reward

    if stage == now_stage then
        vec_reward = ex.Player.tower_data:getRewardList(stage)
    else
        vec_reward = ex.Player.tower_data:getSweepRewardList(stage)
    end
    num = #vec_reward
    local view_size = layer.scroll_view_reward:getViewSize()
    local cont_width = item_size.width * num + margin * 2
    cont_width = math.max(cont_width, view_size.width)

    -- dump(vec_reward)

    layer.scroll_view_reward:setContentSize(cc.size(cont_width, view_size.height))
    layer.scroll_view_reward:setContentOffset(cc.p(0, 0))
    local UIMenuItemBackpack = require('src.comp.menu.UIMenuItemBackpack')

    local begin_x = cont_width * 0.5 - (num - 1) * item_size.width * 0.5
    for i = 1, num do
        local data = vec_reward[i]
        local item_backpack = UIMenuItemBackpack:createWithData(data.item_type, data.item_num)
        item_backpack:setPosition(begin_x + item_size.width * (i - 1) + margin, layer.scroll_view_reward:getViewSize().height * 0.5)
        item_backpack:registerScriptTapHandler(handler(self, self.onItemInfo))
        item_backpack:setScale(0.93)
        menu_reward:addChild(item_backpack)
    end

    local req_log = Tower_pb.GReqTowerLog()
    req_log.stage = stage
    NetManager:sendMessage(ProtocolID.GReqTowerLog, req_log)
end

function FantasyTowerPreviewCtr:updateSweepStatue()
    if self.layer == nil then
        return
    end

    local now_stage = ex.Player.tower_data:getNowStage()

    if self.layer.stage == now_stage then
        return
    end

    local max_times = table.nums(cfg.towersweep.towersweep)
    self.layer.lbl_sweep_times:setString(string.format(ex.Tools:getLang(47085), max_times - ex.Player.tower_data.sweep_times, max_times))

    local config = cfg.towersweep.towersweep[ex.Player.tower_data.sweep_times + 1]
    -- local config = cfg.towersweep.towersweep[ex.Player.tower_data.sweep_times]
    if config == nil then
        self.layer.btn_sweep:setLabelText(ex.Tools:getLang(47413))
        self.layer.btn_sweep:removeChildByTag(200)
    else
        local gem_need = config.cost_gem
        if gem_need > 0 then
            self.layer.btn_sweep:setLabelText(string.format(ex.Tools:getLang(47712), gem_need))

            if self.layer.btn_sweep:getChildByTag(200) == nil then
                local spr_gem = cc.Sprite:createWithSpriteFrameName("backpack/900002.png")
                spr_gem:setScale(0.3)
                spr_gem:setTag(200)
                spr_gem:setPosition(45, self.layer.btn_sweep:getContentSize().height / 2)
                self.layer.btn_sweep:addChild(spr_gem)
            end
        else
            self.layer.btn_sweep:setLabelText(ex.Tools:getLang(47413))
            self.layer.btn_sweep:removeChildByTag(200)
        end
    end
end

function FantasyTowerPreviewCtr:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function FantasyTowerPreviewCtr:onTouchHero()
    if layer.spine_hero ~= nil then
        layer.spine_hero:attack()
    end
end

function FantasyTowerPreviewCtr:onBattle(tag, pSender)
    require('src.layer.HeroSelectCtr'):instance():openWindow(
        ex.Tools:getLang(47524),
        ex.Tools:getLang(47064),
        BattleType.TOWER,
        handler(self, self.onBattleDone)
    )
end

function FantasyTowerPreviewCtr:onSweep(tag, pSender)
    -- 判断次数
    local max_times = table.nums(cfg.towersweep.towersweep)
    if max_times <= ex.Player.tower_data.sweep_times then
        ex.MessageView:add(ex.Tools:getLang(47762))
        return
    end

    -- 发送扫荡请求
    -- local req_sweep = ProtocolRequest.ReqTowerSweep
    -- cpp.NetManager:instance():sendLuaData(req_sweep)
    
    NetManager:sendMessage(ProtocolID.GReqTowerSweep)
end

function FantasyTowerPreviewCtr:onBattleDone(vec_hero, fetter_type)
    local layer = self.layer
    if layer.is_battle then
        self:closeWindow(0, nil)
        return
    end

    layer.is_battle = true

    if layer.callback then
        layer.callback(layer.stage, vec_hero, fetter_type)
    end
    
    self:closeWindow(0, nil)
end

return FantasyTowerPreviewCtr
