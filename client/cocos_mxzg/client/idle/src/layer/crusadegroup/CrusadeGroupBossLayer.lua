--[[
    讨伐团Boss信息界面
    在讨伐团地图界面调用
]]

local CrusadeGroupBossLayer = class("CrusadeGroupBossLayer", require("src.comp.EventLayerAdaptiveWidthFull"))

local CrusadeGroupBossCell = class("CrusadeGroupBossCell", require("src.comp.LuaLayerBase"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
local UIMenuItemSkill = require("src.comp.menu.UIMenuItemSkill")

-----------------------------------------------------------------------------
function CrusadeGroupBossCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function CrusadeGroupBossCell:setTableView(table_view)
    self.menu_hero:setIsTouchInsideNode(table_view)
    self.menu_hero:setSwallowsTouches(false)

    self.menu:setIsTouchInsideNode(table_view)
    self.menu:setSwallowsTouches(false)
end

function CrusadeGroupBossCell:initData(data, can_attack)
    self.lbl_attack:setString(data.fighting)

    self.menu_hero:removeAllChildren()
    
    local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    item_size = cc.size(item_size.width + 10, item_size.height + 10)
    local item_scale = 0.5
    local has_alive = false
    for i,v in ipairs(data.hero) do
        local item = UIMenuItemHero:createWithData(v.hero_id, v.hero_type, nil, v.level, v.star)
        item:setScale(item_scale)
        -- item:registerScriptTapHandler(handler(self, self.onSelectIcon))
        item:setPosition((i - 0.5) * (item_size.width * item_scale), 10)
        self.menu_hero:add(item)

        if v.hp <= 0 then
            item:setGray(false)
        else
            has_alive = true
        end

        -- 添加血量顯示
        local progress_bg = cc.Sprite:createWithSpriteFrameName("crusade-group/progress-bg-hp-1.png")
        progress_bg:setPosition(item:getContentSize().width / 2, -20)
        item:addChild(progress_bg, 10)

        local progress_hp = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("crusade-group/progress-hp-1.png"))
        :setType(cc.PROGRESS_TIMER_TYPE_BAR)
        :setMidpoint(cc.p(0, 0.5))
        :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
        progress_hp:setPosition(progress_bg:getPosition())
        item:addChild(progress_hp, 20)

        progress_hp:setPercentage(v.hp * 100 / v.max_hp)

        -- local lbl_hp = cc.Label:createWithTTF(v.hp.."/"..v.max_hp, FONT_DEFAULT_NAME_BOLD, 24)
        -- lbl_hp:setScale(0.5)
        -- lbl_hp:setPosition(progress_bg:getPosition())
        -- item:addChild(lbl_hp, 30)
    end

    self.btn_attack:setVisible(can_attack and has_alive)
end


-----------------------------------------------------------------------------
function CrusadeGroupBossLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(true)

    self.can_attack = false

    local notch_height = require("src.model.Game"):instance():getNotchHeight()
    self.node_btn_back:setPositionY(ex.p.height - notch_height - 120)

    self.scroll_view:setItemSize(cc.size(540, 115))
    self.scroll_view:setItemType(1)

    self.spr_bg:setScaleX(self:getContentSize().width / self.spr_bg:getContentSize().width)
    self.spr_bg:setScaleY(self:getContentSize().height / self.spr_bg:getContentSize().height)

    -- 小怪數量提示
    self.lbl_revive_tip = require("src.comp.RichTextEx"):create()
	:setFontSize(40)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FFDFB2")
    :setScale(0.5)
    :setAnchorPoint(0.5, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(0, 60)
    self.node_monster_info:addChild(self.lbl_revive_tip, 10001)

    self.progress_hp = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("crusade-group/progress-hp-3.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.progress_hp:setPosition(0, 0)
    self.node_progress:addChild(self.progress_hp, 20)

    self.progress_icon:setLocalZOrder(30)
    self.lbl_boss_hp:setLocalZOrder(40)

    self:initDone()
    self:updateLayer()
end

function CrusadeGroupBossLayer:initDone()
    self:addEvent(EVENT.CRUSADE_GROUP.UPDATE_TOWN_BATTLE_INFO, handler(self, self.receiveEvent))
end

function CrusadeGroupBossLayer:setCanAttack(can_attack)
    self.can_attack = can_attack

    self:updateLayer()
end

function CrusadeGroupBossLayer:setTileId(tile_id)
    local req = CrusadeGroup_pb.GReqViewTerritory()
    req.territory_id = tile_id
    NetManager:sendMessage(ProtocolID.GReqViewTerritory, req)
end

function CrusadeGroupBossLayer:getSkillBystage()
	local t = {}
	t[1] = 0
	for i,v in ipairs(cfg.heroupgrade.grade) do
		local pre = cfg.heroupgrade.grade[i-1]
		for j=1,4 do
			if v["skill"..j] ~= pre["skill"..j] then 
				table.insert(t,i)
			end
		end
	end
	return t
end

function CrusadeGroupBossLayer:updateLayer()
    if self.town_data == nil then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/crusade-group.plist")
    sfc:addSpriteFrames("ccbi-res/hero-info.plist")
    sfc:addSpriteFrames("ccbi-res/skill-icon.plist")

    if self.spine_boss ~= nil then
        self.spine_boss:removeFromParent()
        self.spine_boss = nil
    end
    if self.item_boss ~= nil then
        self.item_boss:removeFromParent()
        self.item_boss = nil
    end

    -- 設置boss信息
    local boss_data = nil
    for i,v in ipairs(self.town_data.formation) do
        if v.boss then
            boss_data = v
            break
        end
    end

    self.btn_attack:setVisible(self.can_attack)

    self.lbl_boss_dead:setVisible(boss_data == nil or boss_data.hero[1].hp <= 0)

    if boss_data ~= nil then  
        if boss_data.hero[1].hp > 0 then
            local skin = ex.Tools:getHeroSkinByStar(boss_data.hero[1].hero_type, boss_data.hero[1].star)
            self.spine_boss = require("src.person.Hero"):create("1", "1", boss_data.hero[1].hero_type, boss_data.hero[1].level, boss_data.hero[1].star, skin)
            self.spine_boss:setShadowVisible(false)
            self.spine_boss:setScale(1 * 1.42)
            self.spine_boss:setPosition(0, 80)
            self.spine_boss:registerScriptTapHandler(handler(self, self.onTouchHero))
            -- self.menu:addChild(self.hero, -1)
            self.menu_spine:addChild(self.spine_boss)

            self.spr_stone:setVisible(false)
            if cfg.herotype.star[boss_data.hero[1].hero_type].kind == 2 then
                self.spine_boss:setScale(self.spine_boss:getScale() * 2)
            else
                self.spine_boss:setScale(1 * 1.42)
            end
        else
            self.spine_boss = sp.SkeletonAnimation:create("spine/crusade_boss_die.json","spine/crusade_boss_die.atlas", 1)
            self.spine_boss:setAnimation(0, "die", true)
            self.spine_boss:setPosition(20, 50)
            self.node_boss:addChild(self.spine_boss, 0, 10)

            self.spr_stone:setVisible(true)
        end
    
        self.item_boss = UIMenuItemHero:createWithData(boss_data.hero[1].hero_id, boss_data.hero[1].hero_type, nil, boss_data.hero[1].level, boss_data.hero[1].star)
        self.item_boss:setScale(0.6)
        -- item:registerScriptTapHandler(handler(self, self.onSelectIcon))
        self.item_boss:setPosition(0, -10)
        self.menu_boss:add(self.item_boss)

        self.item_boss:setGray(boss_data.hero[1].hp > 0)
        self.btn_attack:setVisible(self.can_attack and boss_data.hero[1].hp > 0)

        self.btn_attack.data = boss_data
        self.progress_hp:setPercentage(boss_data.hero[1].hp * 100 / boss_data.hero[1].max_hp)
        self.lbl_boss_name:setString(ex.Tools:getLang(boss_data.hero[1].hero_type))
        self.lbl_fighting:setString(boss_data.fighting)
        ex.Tools:setLimitWidth(self.lbl_fighting, 100)
        self.lbl_boss_hp:setString(boss_data.hero[1].hp)

        -- 設置boss的技能顯示
        self.menu_boss_skill:removeAllChildren()
        local icon_width = 75
        local vec_skill = ex.Player.hero_data:getHeroSkillList(boss_data.hero[1].hero_type)
        local skill_num = table.nums(vec_skill)
        local max_skill_num = 4
        local skill_stage = self:getSkillBystage()
        self.menu_boss_skill:setLocalZOrder(10)
        self.menu_boss_skill:removeAllChildren()
        for i=1,4 do
            if i <= skill_num then  
                local skill_level, is_evolve_skill, skill_id = ex.Player.hero_data:getHeroSkillLevel(6, boss_data.hero[1].star, i, boss_data.hero[1].hero_type, nil)
                local btn_skill = UIMenuItemSkill:createWithIcon(skill_id, skill_level, is_evolve_skill, handler(self, self.onSkillInfo))
                btn_skill:setScale(0.7)
                btn_skill:setPosition(icon_width * 0.7 * (i - 0.5), 0)
                btn_skill:createRich(skill_stage[i])
                btn_skill.lbl_name:setColor(cc.c3b(122,71,45))
                -- btn_skill.lbl_name:enableOutline(ex.c3b.BLACK, -1)
                -- btn_skill.lbl_name:setPositionY(-22)
                btn_skill.lbl_name:setVisible(false)
                self.menu_boss_skill:addChild(btn_skill)
                self["btn_skill"..i] = btn_skill
    
                btn_skill.skill_index = i
                btn_skill.hero_type = boss_data.hero[1].hero_type
            end 
        end
    end

    -- 刷新小怪列表
    self:updateTableView()
end

function CrusadeGroupBossLayer:onSkillInfo(tag, pSender)
	local skill_level_next_need_star = ex.Player.hero_data:getHeroSkillLevelNeedStar(pSender.skill_level + 1, pSender.skill_index, pSender.hero_type)
    require("src.layer.HeroSkillInfoCtr"):instance():openWindow(pSender.skill_type, pSender.skill_level, skill_level_next_need_star)
end

function CrusadeGroupBossLayer:receiveEvent(event, data)
    self.town_data = data
    
    local fight_type = cfg.crusadegrouptilelevel.getFightType(self.town_data.territory_id)
    
    if self.town_data.occupied and fight_type ~= 3 then
        ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_MAP_CUR_PAGE)
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CRUSADE_GROUP_LAYER)
        return
    end

    self:updateLayer()
end

function CrusadeGroupBossLayer:updateTableView()
    local list = {}
    local has_boss = false
    local monster_num = 0
    if self.town_data ~= nil and self.town_data.formation ~= nil then
        for _,team_data in ipairs(self.town_data.formation) do
            if not team_data.boss then
                table.insert(list, team_data)

                for _,v in ipairs(team_data.hero) do
                    if v.hp > 0 then
                        monster_num = monster_num + 1
                        break
                    end
                end
            else
                for _,v in ipairs(team_data.hero) do
                    if v.hp > 0 then
                        has_boss = true
                        break
                    end
                end
            end
        end
    end

    if has_boss then
        self.node_revive_time:setVisible(false)
    else
        self.node_revive_time:setVisible(true)
        self.lbl_revive_tip:setXmlTextLua(string.format(ex.Tools:getLang(77738), ex.StringUtil.convertToTimeFormat(self.town_data.refresh_countdown - ex.Game:getServerTime(), 4)))
        self.lbl_revive_tip:formatText()
    end

    self.lbl_monster_num_1:setString("x"..(has_boss and 1 or 0))
    self.lbl_monster_num_2:setString("x"..monster_num)

    self.scroll_view:getContainer():removeAllChildren()
    self.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = CrusadeGroupBossCell:createWithCCBIFile("ccbi/CrusadeGroupBossCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data, self.can_attack)
        cell:setTableView(self.scroll_view)

        if self.can_attack then
            cell.btn_attack:registerScriptTapHandler(handler(self, self.onAttack))
            cell.btn_attack.data = data
        end
    
        return cell
    end

    self.scroll_view:reloadData(list)
end

function CrusadeGroupBossLayer:onTouchHero()
	self.spine_boss:attack()
end

-- 返回
function CrusadeGroupBossLayer:onBack(tag, pSender)
    ex.MainSceneCtr:backLastLayer()
end

-- 信息
function CrusadeGroupBossLayer:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42106), ex.Tools:getLang(42107))
end

function CrusadeGroupBossLayer:onReport(tag, pSender)
    if self.town_data == nil or self.town_data.territory_id == nil then
        return
    end
    require("src.layer.crusadegroup.CrusadeGroupBattleLogCtr"):instance():openWindow(self.town_data.territory_id)
end

-- 攻击
function CrusadeGroupBossLayer:onAttack(tag, pSender)
    if pSender.data == nil or pSender.data.formation_id == nil then
        return
    end

    -- 如果其他小怪未死亡，則不許攻擊boss
    local boss_data = nil
    for i,v in ipairs(self.town_data.formation) do
        if v.boss then
            boss_data = v
            break
        end
    end
    if boss_data ~= nil and boss_data.formation_id == pSender.data.formation_id then
        for i,v in ipairs(self.town_data.formation) do
            if not v.boss and v.hero[1].hp > 0 then
                ex.MessageView:add(ex.Tools:getLang(77747))
                return
            end
        end
    end

    self.selected_formation_id = pSender.data.formation_id
    local config = cfg.crusadegroupbuild.getConfig(self.town_data.territory_id) or {}
    require("src.layer.crusadegroup.CrusadeGroupHeroSelectCtr"):instance():openWindow(ex.Tools:getLang(47546),
                                                                                        config.battletype, 
                                                                                        handler(self, self.onBattleDone), 
                                                                                        nil, 
                                                                                        self.town_data.dead_hero_id,
                                                                                        config.cost_energy or 0)
end

function CrusadeGroupBossLayer:onBattleDone()
    if self.town_data == nil then
        return
    end

    -- 请求战斗
    local req = CrusadeGroup_pb.GReqStartFighting()
    req.territory_id = self.town_data.territory_id
    req.formation_id = self.selected_formation_id
    NetManager:sendMessage(ProtocolID.GReqStartFighting, req)
end

function CrusadeGroupBossLayer:onExit()

end

return CrusadeGroupBossLayer
