local DungeonHeroAttackCtr = class("DungeonHeroAttackCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local DungeonHeroAttackLayer = class("DungeonHeroAttackLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenu = require("src.comp.menu.UIMenu")
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

DungeonHeroAttackLayer.vec_heros = {}
DungeonHeroAttackLayer.vec_selected = {}
DungeonHeroAttackLayer.callback = nil
DungeonHeroAttackLayer.layer_elem_type = 0

function DungeonHeroAttackLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    self:addBlackBackground()
    self.btn_confirm:setLabelText(ex.Tools:getLang(47150))
    self.btn_confirm:setLabelSize(50)
    self.btn_confirm:setLabelScale(0.5)
end

-----------------------------------------------------------------------------
function DungeonHeroAttackCtr:onCreate()
	self:setCCBIPath("ccbi/DungeonHeroAttackLayer.ccbi")
	self:setIsSingle(false)
end

function DungeonHeroAttackCtr:getLayerClass()
	return DungeonHeroAttackLayer
end

function DungeonHeroAttackCtr:getDungeonHeroAttackLayer()
	return self.layer
end

function DungeonHeroAttackCtr:openWindow(monster_level)
	if self:isOpened() then
		return
	end
	
	self:loadLayer()
	self:open()
	self:initData(monster_level)
end

function DungeonHeroAttackCtr:initData(monster_level)
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
    self.layer.btn_speed_check:registerScriptTapHandler(handler(self, self.onSpeedCheck))
    
    self.monster_level = monster_level
    self.selected_index = ex.Player.dungeon_data.battle_attack_cur_select_index
    if self.selected_index > 0 then
        for i, v in ipairs(ex.Player.dungeon_data.lineup_hero_list) do
            if i == self.selected_index then
                if tonumber(v.hero_rate) <= 0 then
                    self.selected_index = -1
                end
                break
            end
        end
    end
    if self.selected_index <= 0 then
        for i, v in ipairs(ex.Player.dungeon_data.lineup_hero_list) do
            if tonumber(v.hero_rate) > 0 then
                self.selected_index = i
                break
            end
        end
    end
    
	self:updateScrollViewSelected()
	self:updateLayer()
end

function DungeonHeroAttackCtr:updateScrollViewSelected()
	if not self:getLayer() then
		return
	end
	local layer = self.layer

    layer.scroll_view_selected:getContainer():removeAllChildren()
    layer.scroll_view_selected:setBounceable(false)

	layer.menu_selected = UIMenu:create();
    layer.menu_selected:setPosition(cc.p(0, 0));
    layer.menu_selected:setSwallowsTouches(false);
    layer.menu_selected:setIsTouchInsideNode(layer.scroll_view_selected);
    layer.menu_selected:setName("menu_selected")
    layer.scroll_view_selected:getContainer():addChild(layer.menu_selected);

	local item_count = 6
    local item_scale = 0.75

	local view_size = layer.scroll_view_selected:getViewSize()
	local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    item_size = cc.size(item_size.width + 15, item_size.height + 12)

    for i=1,6 do
        local hero_data = ex.Player.dungeon_data:getTeamHeroHpDataByIndex(i)

        local item = nil
        if hero_data ~= nil then
            item = UIMenuItemHero:createWithData(hero_data.hero_id, hero_data.hero_type, hero_data.elem, hero_data.level, hero_data.star)
            item.index = i

            if i == self.selected_index then
                item:setSelected(true)
            end

            if tonumber(hero_data.hero_rate) <= 0 then
                item:setEnabled(false)

                local spr_die = cc.Sprite:createWithSpriteFrameName("other/lbl-dead.png")
                spr_die:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
                spr_die:setLocalZOrder(100)
                item:addChild(spr_die)
                if item.spr_hero_icon then
                    item.spr_hero_icon:setColor(FONT_GRAY)
                end
            end

            -- 显示血量进度条
            item.spr_progress_bg = cc.Sprite:createWithSpriteFrameName("dungeon/progress-hp-bg.png")
            item.spr_progress_bg:setPosition(item:getContentSize().width / 2, -20)
            item:addChild(item.spr_progress_bg)

            item.progress = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("dungeon/progress-hp.png"))
            :setType(cc.PROGRESS_TIMER_TYPE_BAR)
            :setMidpoint(cc.p(0, 0.5))
            :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
            :setPosition(item.spr_progress_bg:getPosition())
            item:addChild(item.progress)

            item.progress:setPercentage(hero_data.hero_rate / 100)
        else
            item = UIMenuItemHero:createWithData()
            item:setHeroId(NULL_ID)
            item:removeIcon()
            item:removeElem()
            item:removeLevel()
            item:removeStar()
            item.index = i
        end

        item:setScale(item_scale)
        item:setPosition((i - 0.5) * (item_size.width * item_scale), view_size.height / 2)
        :registerScriptTapHandler(handler(self, self.onSelectIcon))
        layer.menu_selected:add(item)
    end

    layer.scroll_view_selected:setContentSize(view_size)
end

function DungeonHeroAttackCtr:updateLayer()
	if not self:getLayer() then
		return
	end

    -- 计算战斗力
    local combat_effectiveness = 0;
    local hero_hp_data_selected = nil
    local hero_data = nil
    for i,v in ipairs(ex.Player.dungeon_data.lineup_hero_list) do
        if v.index == self.selected_index then
            hero_hp_data_selected = v
            hero_data = ex.Player.dungeon_data:getTeamHeroInfoDataById(v.hero_id)
            break
        end
    end
    
    local tmp_hero_data = ex.Player.dungeon_data:getTeamHeroHpDataByIndex(self.selected_index)
    if tmp_hero_data ~= nil then
        combat_effectiveness = tmp_hero_data.hero_bat
    end


    self.layer.lbl_battle_count:setString(string.format("%d", combat_effectiveness))

    local is_dungeon_battle_pass = cc.UserDefault:getInstance():getIntegerForKey("is_dungeon_battle_pass"..ex.Player.role_id, 0)
    self.layer.btn_speed_check:setChecked(is_dungeon_battle_pass == 1)

    if hero_hp_data_selected == nil then
        if self.layer.item_hero_selected ~= nil then
            self.layer.item_hero_selected:setVisible(false)
        end
        if self.layer.spr_hero_progress_bg ~= nil then
            self.layer.spr_hero_progress_bg:setVisible(false)
        end
        if self.layer.progress_hero ~= nil then
            self.layer.progress_hero:setVisible(false)
        end
    else
        if self.layer.item_hero_selected ~= nil then
            self.layer.item_hero_selected:removeFromParent()
            self.layer.item_hero_selected = nil
        end
        
        if self.layer.item_hero_selected == nil then
            local fashion_id = ex.Player.hero_data.fashion:getWearByID(hero_data.hero_id) or 0
            if fashion_id == 0 then
                local skin = ex.Tools:getHeroSkinByStar(hero_data.hero_type, hero_data.star, hero_data.evolve)
                self.layer.item_hero_selected = require("src.person.Hero"):create("1", "1", hero_data.hero_type, hero_data.level, hero_data.star, skin)
            else
                self.layer.item_hero_selected = require("src.person.Hero"):create("1", "1", 1, 1, 1, fashion_id)
            end
            self.layer.item_hero_selected:setScale(1.42)
            self.layer.item_hero_selected:setPosition(self.layer.spr_vs:getPositionX() - 150, self.layer.spr_vs:getPositionY())
            self.layer:addChild(self.layer.item_hero_selected)
        end

            -- 显示血量进度条
        if self.layer.spr_hero_progress_bg == nil then
            self.layer.spr_hero_progress_bg = cc.Sprite:createWithSpriteFrameName("dungeon/progress-hp-bg.png")
            self.layer.spr_hero_progress_bg:setPosition(self.layer.item_hero_selected:getPositionX(), 
                                                        self.layer.spr_vs:getPositionY() - 100)
            self.layer:addChild(self.layer.spr_hero_progress_bg)

            self.layer.progress_hero = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("dungeon/progress-hp.png"))
            :setType(cc.PROGRESS_TIMER_TYPE_BAR)
            :setMidpoint(cc.p(0, 0.5))
            :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
            :setPosition(self.layer.spr_hero_progress_bg:getPosition())
            self.layer:addChild(self.layer.progress_hero)
        end

        self.layer.progress_hero:setPercentage(hero_hp_data_selected.hero_rate / 100)
    end

    local config = ex.Player.dungeon_data:getMonsterByStageAndLevel(ex.Player.dungeon_data.cur_stage, self.monster_level)
    if self.layer.item_monster_selected == nil and config ~= nil then

        local skin = ex.Tools:getHeroSkinByStar(config.hero_type, config.hero_star)
        self.layer.item_monster_selected = require("src.person.Hero"):create("12323", "123213", config.hero_type, config.hero_level, config.hero_star, skin)
        self.layer.item_monster_selected:setScale(1.42)
        self.layer.item_monster_selected:setPosition(self.layer.spr_vs:getPositionX() + 150, self.layer.spr_vs:getPositionY())
        self.layer:addChild(self.layer.item_monster_selected)

        -- 显示血量进度条
        self.layer.spr_monster_progress_bg = cc.Sprite:createWithSpriteFrameName("dungeon/progress-hp-bg.png")
        self.layer.spr_monster_progress_bg:setPosition(self.layer.item_monster_selected:getPositionX(), 
                                                       self.layer.spr_vs:getPositionY() - 100)
        self.layer:addChild(self.layer.spr_monster_progress_bg)

        self.layer.progress_monster = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("dungeon/progress-hp.png"))
        :setType(cc.PROGRESS_TIMER_TYPE_BAR)
        :setMidpoint(cc.p(0, 0.5))
        :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
        :setPosition(self.layer.spr_monster_progress_bg:getPosition())
        self.layer:addChild(self.layer.progress_monster)
        
        local monster_rate = ex.Player.dungeon_data:getMonsterCurHp(self.monster_level)
        self.layer.progress_monster:setPercentage(monster_rate / 100)
    end
end

function DungeonHeroAttackCtr:onSelectIcon(tag, pSender)
    if pSender:getHeroId() == NULL_ID then
        return
    end

    local hero_hp_data = ex.Player.dungeon_data:getTeamHeroHpDataByIndex(pSender.index)
    if tonumber(hero_hp_data.hero_rate) <= 0 then
        return
    end

    -- 将之前的选中项取消选中
    local last_hero_hp_data = ex.Player.dungeon_data:getTeamHeroHpDataByIndex(self.selected_index)
    if last_hero_hp_data ~= nil then
        local item_selected = self.layer.menu_selected:getItemByHeroId(last_hero_hp_data.hero_id)
        if item_selected ~= nil then
            item_selected:setSelected(false)
        end
    end

    -- 选中新选中项
    local item = self.layer.menu_selected:getItemByHeroId(pSender:getHeroId())
    if item then
        item:setSelected(true)
    end

    self.selected_index = item.index

    self:updateLayer()
end

-- 是否跳过战斗
function DungeonHeroAttackCtr:onSpeedCheck(tag, pSender)
    self.is_dungeon_battle_pass = not self.is_battle_pass
    local is_dungeon_battle_pass = cc.UserDefault:getInstance():getIntegerForKey("is_dungeon_battle_pass"..ex.Player.role_id, 0)
    if is_dungeon_battle_pass == 1 then
        is_dungeon_battle_pass = 0
    else
        is_dungeon_battle_pass = 1
    end
    cc.UserDefault:getInstance():setIntegerForKey("is_dungeon_battle_pass"..ex.Player.role_id, is_dungeon_battle_pass)

    self.layer.btn_speed_check:setChecked(is_dungeon_battle_pass == 1)
end

-- 进入战斗
function DungeonHeroAttackCtr:onConfirm(tag, pSender)
    if self.selected_index <= 0 then
        ex.MessageView:add(ex.Tools:getLang(41207))
        return
    end

    ex.EventManager:fire(EVENT.DUNGEON_EVENT.ON_BATTLE, self.monster_level, self.selected_index)

    ex.Player.dungeon_data.battle_attack_cur_select_index = self.selected_index
    
    self:closeWindow(tag, pSender)
end

return DungeonHeroAttackCtr
