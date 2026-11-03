local CrusadeGroupHeroSelectCtr = class("CrusadeGroupHeroSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CrusadeGroupHeroSelectLayer = class("CrusadeGroupHeroSelectLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
local CrusadeGroupHeroItem = require("src.layer.crusadegroup.CrusadeGroupHeroItem")
local CrusadeGroupEnergy = class("CrusadeGroupEnergy", require("src.comp.EventLayer"))
local UIMenu = require("src.comp.menu.UIMenu")

local default_formation_id = 1

CrusadeGroupHeroSelectLayer.lineup_data = {}
CrusadeGroupHeroSelectLayer.vec_heros = {}
CrusadeGroupHeroSelectLayer.vec_heros_origin = {}
CrusadeGroupHeroSelectLayer.vec_selected = {}
CrusadeGroupHeroSelectLayer.callback = nil
CrusadeGroupHeroSelectLayer.layer_elem_type = 0

function CrusadeGroupHeroSelectLayer:onCreate()
    self:addBlackBackground()

    self.btn_confirm:setName("btn_confirm")
    self.btn_matrix:setLabelOffset(cc.p(0, -35))

    local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    item_size = cc.size(item_size.width + 30, item_size.height + 10)

    self.item_size = item_size
    self.scroll_view_backpack:setItemType(1)
    self.scroll_view_backpack:setItemSize(cc.size(120, 158))
    self.scroll_view_backpack:setItemOffset(cc.p(0, 5))
    self.scroll_view_backpack:setCreateNum(4)
    self.scroll_view_backpack:setName("hero_select_view")
    self.scroll_view_backpack:setResetOffset(true)

    self.btn_contract:setEnableAction(false)

    self.btn_fetter:setEnableAction(false)

    self.btn_dragon_skill:setEnableAction(false)

    self:addEvent(EVENT.HERO_EVENT.CHANGE_HERO_POSITION, handler(self, self.changeHeroPosition))
    self:addEvent(EVENT.HERO_SELECT_EVENT.FIGHT, handler(self, self.updateFight))

    ex.Tools:addRedPoint(self.onFetter, ex.Player.fetter_data:checkFetterContractInfo(), cc.p(0.38, 0.75))
end

function CrusadeGroupHeroSelectLayer:refreshFetterRed()
    ex.Tools:addRedPoint(self.onFetter, ex.Player.fetter_data:checkFetterContractInfo(), cc.p(0.38, 0.75))
end

function CrusadeGroupHeroSelectLayer:changeHeroPosition(event, data)
    local hero_select_ctr = CrusadeGroupHeroSelectCtr:instance()
    hero_select_ctr:onBackpackIcon(data)
end

function CrusadeGroupHeroSelectLayer:updateFight(event, fighting)
    self.lbl_battle_count:setString(string.format("%d", fighting))
    CrusadeGroupHeroSelectCtr:instance().fighting = fighting
end

function CrusadeGroupHeroSelectLayer:sortHeroData(data)
    local hero_list = data

    local function sor(a, b)
        local battle_a = ex.Player.hero_data.promote:heroIsBattle(a.hero.hero_id) and 1 or 0
        local battle_b = ex.Player.hero_data.promote:heroIsBattle(b.hero.hero_id) and 1 or 0

        if battle_a ~= battle_b then
            return battle_a > battle_b
        end

        if a.hero.star ~= b.hero.star then
            return a.hero.star > b.hero.star
        end
        if a.hero.level ~= b.hero.level then
            return a.hero.level > b.hero.level
        end
        return a.hero.hero_type > b.hero.hero_type
    end

    table.sort(hero_list, sor)
    return hero_list
end

-----------------------------------------------------------------------------
function CrusadeGroupHeroSelectCtr:onCreate()
    self:setCCBIPath("ccbi/CrusadeGroupHeroSelectLayer.ccbi")
    self:setIsSingle(false)
    self.fighting = 0
end

function CrusadeGroupHeroSelectCtr:getLayerClass()
    return CrusadeGroupHeroSelectLayer
end

function CrusadeGroupHeroSelectCtr:getCrusadeGroupHeroSelectLayer()
    return self.layer
end

-- 根据战斗类型来选择阵型
-- TODO   最后一个参数为好友助战
function CrusadeGroupHeroSelectCtr:openWindow(str_title, battle_type, callback, select_elem, dead_hero_list, cost_energy)
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/crusade-group.plist")
    
    self:loadLayer()
    self:open()
    self:initData(str_title, battle_type, callback, select_elem, dead_hero_list, cost_energy)
end

function CrusadeGroupHeroSelectCtr:initData(str_title, battle_type, callback, select_elem, dead_hero_list, cost_energy)
    self.dead_hero_list = dead_hero_list
    self.cost_energy = cost_energy
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
    self.layer.btn_halo:registerScriptTapHandler(handler(self, self.onHalo))
    self.layer.btn_fetter:registerScriptTapHandler(handler(self, self.onSelectFetter))
    self.layer.btn_contract:registerScriptTapHandler(handler(self, self.onFetterLineup))
    self.layer.btn_dragon_skill:registerScriptTapHandler(handler(self, self.onDragonSkill))
    self.layer.btn_matrix:registerScriptTapHandler(handler(self, self.onMatrix))

    self.layer.btn_elem0:registerScriptTapHandler(handler(self, self.onElem))
    self.layer.btn_elem1:registerScriptTapHandler(handler(self, self.onElem))
    self.layer.btn_elem2:registerScriptTapHandler(handler(self, self.onElem))
    self.layer.btn_elem3:registerScriptTapHandler(handler(self, self.onElem))
    self.layer.btn_elem4:registerScriptTapHandler(handler(self, self.onElem))
    self.layer.btn_elem5:registerScriptTapHandler(handler(self, self.onElem))

    self.layer:addEvent(EVENT.HERO_SELECT_EVENT.DRAGON_SKILL, handler(self, self.updateDragonSkill))
    self.layer:addEvent(EVENT.CRUSADE_GROUP.UPDATE_SET_OFF, handler(self, self.handleRefreshHero))

    self.layer.menu_assist:setLocalZOrder(1000)
    self.layer.btn_assist_tip:setContentSize(self.layer.spr_lock_9:getContentSize())
    self.layer.btn_assist_tip:setVisible(not ex.Player.lineup_data.assistance_unlock)
    self.layer.btn_assist_tip:registerScriptTapHandler(handler(self, self.onHeroAssistTip))
    self.layer.btn_assist_info:registerScriptTapHandler(handler(self, self.onHeroAssistInfo))

    self.layer._pressBtnId = 0
    self.layer.callback = callback
    self.layer.lbl_title:setString(str_title)
    self.layer.lbl_battle_count:setString(string.format("%s", self.fighting))
    self.layer.lbl_title:setString(str_title)

    local str_content = string.format(ex.Tools:getLang(77634), cost_energy)
    self.layer.btn_confirm:setLabelText(str_content)
    ex.Tools:addImgToUIMenuItemLabel(self.layer.btn_confirm, nil, "crusade-group/spr-energy.png", 0.8)
    self.layer.spr_select:setPosition(self.layer.btn_elem0:getPosition())

    self.layer.lineup_type = battle_type

    local battle_config = cfg.battletype.battletype[self.layer.lineup_type]
    if battle_config then
        local lineup_data = ex.Player.lineup_data:getLineup(battle_config.save_line_up_type)

        -- 默认的阵容也是空的
        if lineup_data == nil or table.nums(lineup_data) <= 0 then
            lineup_data = {}
            lineup_data.type = battle_type
            lineup_data.time = 0
            lineup_data.goddess_type = 0
            lineup_data.formation_id = default_formation_id
            lineup_data.hero_list = {{hero_id = 0, hp = 1, position = 1},
                                     {hero_id = 0, hp = 1, position = 2},
                                     {hero_id = 0, hp = 1, position = 3},
                                     {hero_id = 0, hp = 1, position = 4},
                                     {hero_id = 0, hp = 1, position = 5},
                                     {hero_id = 0, hp = 1, position = 6},
                                     {hero_id = 0, hp = 1, position = 7},
                                     {hero_id = 0, hp = 1, position = 8},
                                     {hero_id = 0, hp = 1, position = 9}}
        end

        self.layer.lineup_data = clone(lineup_data)

        -- 篩選掉不合條件的英雄
        local vec_heros = ctr.crusade_group:getBattleHeroList(self.dead_hero_list, self.cost_energy)
        for _,hero_data in ipairs(self.layer.lineup_data.hero_list) do
            if hero_data.hero_id > 0 then
                local tmp_hero_data = TableEx.findValueFunction(vec_heros, function(value)
                    return value.hero.hero_id == hero_data.hero_id
                end)

                if tmp_hero_data == nil or tmp_hero_data.is_death or tmp_hero_data.physical_strength < cost_energy then
                    hero_data.hero_id = 0
                end
            end
        end
    end

    self.select_elem = select_elem
    if select_elem then
        for i = 0, 5 do
            local btn_elem = self.layer["btn_elem" .. i]
            if btn_elem then
                if i == select_elem then
                    self.layer.layer_elem_type = btn_elem:getTag()
                    self.layer.spr_select:setPosition(btn_elem:getPosition())
                else
                    btn_elem:setEnabled(false)
                    ex.Tools:setGray(btn_elem:getNormalImage())
                end
            end
        end
    end

    self:refreshHero()
end

function CrusadeGroupHeroSelectCtr:refreshHero()
    if not ctr.crusade_group:requestRefreshHero() then
        self.is_refresh = true
    end

    self:updateAll()
end

function CrusadeGroupHeroSelectCtr:onHeroAssistTip(tag, pSender)
    if not ex.Player.lineup_data.assistance_unlock then
        ex.MessageView:add(ex.Tools:getLang(77202))
    end
end

function CrusadeGroupHeroSelectCtr:onHeroAssistInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42102), ex.Tools:getLang(42103))
end

function CrusadeGroupHeroSelectCtr:updateAll()
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/hero-info.plist")
    sfc:addSpriteFrames("ccbi-res/hero-select.plist")

    -- 筛选英雄
    local battle_config = cfg.battletype.battletype[self.layer.lineup_type]
    if battle_config == nil then
        print("battle_config is nil")
    end

    -- 拿界面缓存的数据.界面打开时已经缓存服务器的布阵数据
    local lineup_data = self.layer.lineup_data
    local vec_heros = ctr.crusade_group:getBattleHeroList(self.dead_hero_list, self.cost_energy)
    for _,hero_data in ipairs(lineup_data.hero_list) do
        if hero_data.hero_id > 0 then
            local tmp_hero_data = TableEx.findValueFunction(vec_heros, function(value)
                return value.hero.hero_id == hero_data.hero_id
            end)

            if tmp_hero_data == nil or tmp_hero_data.is_death or tmp_hero_data.physical_strength < self.cost_energy then
                hero_data.hero_id = 0
            end
        end
    end

    self._selectedFormationId = lineup_data.formation_id

    -- 做一次数据验证调整
    if self._selectedFormationId == nil or self._selectedFormationId <= 0 then
        self._selectedFormationId = default_formation_id
    end

    for _, v in pairs(cfg.battlematrixaddition.battlematrixaddition) do
        if v.type == self._selectedFormationId and v.is_open <= 0 then
            if lineup_data.hero_list[v.position] ~= nil and lineup_data.hero_list[v.position].hero_id > 0 then
                lineup_data.hero_list[v.position].hero_id = 0
            end
        end
    end

    local vec_heros = ctr.crusade_group:getBattleHeroList(self.dead_hero_list, self.cost_energy)
    vec_heros = clone(vec_heros)

    local layer = self.layer
    layer.vec_heros = vec_heros
    layer.select_fetter = lineup_data.goddess_type or 0

    layer.scroll_view_backpack:setItemSize(cc.size(120, 158))

    NetManager:sendMessage(ProtocolID.GReqQueryFormation)

    self:updateScrollViewSelected()
    self:updateScrollViewBackpack()
    self:updateLayer()
end

function CrusadeGroupHeroSelectCtr:updateScrollViewSelected()
    if not self:getLayer() then
        return
    end
    local layer = self.layer

    if layer.menu_selected ~= nil then
        layer.menu_selected:removeFromParent()
        layer.menu_selected = nil
    end

    layer.menu_selected = UIMenu:create()
    layer.menu_selected:setPosition(cc.p(0, 0))
    layer.menu_selected:setSwallowsTouches(false)
    layer.menu_selected:setName("menu_selected")
    layer.node_pannel_2:addChild(layer.menu_selected)

    -- 启用menu的touch事件，并设置exchange回调
    layer.menu_selected:enableExchange(true)
    layer.menu_selected:setExchangeCallback(handler(self, self.exchangeCallback))

    local item_count = #layer.lineup_data.hero_list

    local index = 1
    local config_matrix = cfg.battlematrixaddition.battlematrixaddition
    for i, v in ipairs(layer.lineup_data.hero_list) do
        if index > LineupIdxMax then
            break
        end

        if index ~= LineupIdxAssist or ex.Player.lineup_data.assistance_unlock then
            local hero_data = v.hero_id > 0 and ctr.crusade_group.data:getSetOffHero(v.hero_id) or nil
            hero_data = hero_data ~= nil and hero_data.hero
            local item = nil
            if hero_data then
                item = UIMenuItemHero:createWithData()
                item:reset(hero_data)
                if hero_data.fashion_id ~= 0 and hero_data.fashion_id ~= nil then -- 有皮肤
                    item:setFashionShowForce(hero_data.fashion_id)
                end
            else
                layer.lineup_data.hero_list[i].hero_id = NULL_ID
                item = UIMenuItemHero:createWithData()
                item:setHeroId(NULL_ID)
                item:removeIcon()
                item:removeElem()
                item:removeLevel()
                item:removeStar()
                item:resetBg(true)
            end

            item:setScale(0.7)
            item:setEnableAction(false)
            item:setTag(index)
            local icon = layer["node_icon_" .. index]
            item:setPosition(icon:getPosition()):registerScriptTapHandler(handler(self, self.onSelectIcon))
            layer.menu_selected:add(item)

            for _, v2 in pairs(config_matrix) do
                if v2.type == self._selectedFormationId and v2.position == index then
                    item:setVisible(v2.is_open == 1)
                    if v2.is_open == 0 then
                        v = 0
                    end
                    break
                end
            end
        end
        index = index + 1
    end
end

-- 刷新显示圣龙技能
function CrusadeGroupHeroSelectCtr:updateDragonSkill()
    local is_visible = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_dragon")
    if is_visible == false then
        self.layer.node_dragon_skill:setVisible(false)
        return
    end
    self.layer.node_dragon_skill:setVisible(true)

    for i = 1, 4 do
        local spr_skill = self.layer["spr_dragon_skill_" .. i]
        local hallows_data = nil
        for _, v in pairs(ex.Player.dragon_data.vec_hallows) do
            if v.pos == i then
                hallows_data = v
                break
            end
        end

        if hallows_data == nil or hallows_data.item_type <= 0 then
            spr_skill:setVisible(false)
        else
            spr_skill:setVisible(true)
            local config_relic = cfg.dragonrelic.dragonrelic[hallows_data.item_type]
            spr_skill:setSpriteFrame("skill-icon/" .. config_relic.skill .. ".png")
        end
    end
end

function CrusadeGroupHeroSelectCtr:updateScrollViewBackpack()
    if not self:getLayer() then
        return
    end
    local layer = self.layer

    local vec_hero = {}
    for k, v in pairs(layer.vec_heros) do
        local config = cfg.herotype.star[v.hero.hero_type]
        if layer.layer_elem_type == 0 then
            table.insert(vec_hero, v)
        elseif config.elem == layer.layer_elem_type then
            table.insert(vec_hero, v)
        end
    end

    vec_hero = self.layer:sortHeroData(vec_hero)
    layer.scroll_view_backpack.createItemFunction = function(data, scale)
        local cell = CrusadeGroupHeroItem:createWithCCBIFile("ccbi/CrusadeGroupHeroItem.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.3)
        local energy_item = CrusadeGroupEnergy:createWithCCBIFile("ccbi/CrusadeGroupEnergy.ccbi")
        energy_item:setIgnoreAnchorPointForPosition(false)
        energy_item:setAnchorPoint(0.5, 0.5)
        energy_item:setPosition(cell:getContentSize().width / 2, - energy_item:getContentSize().height / 2 - 5)
        cell:addChild(energy_item)
        local physical_strength = data.physical_strength or 0
        energy_item.lbl_num:setString(physical_strength)
        cell:reloadData(data, CRUSADE_GROUP_HERO_ITEM_TYPE.BATTLE)
        cell.btn_item.data = data
        cell.btn_item:registerScriptTapHandler(handler(self, self.onBackpackIcon))
        cell.menu:setSwallowsTouches(false)
        cell.menu:setIsTouchInsideNode(self.scroll_view)

        if  TableEx.findValueFunction(
                layer.lineup_data.hero_list,
                function(value)
                    return data.hero.hero_id == value.hero_id
                end
            )
         then
            cell.btn_item.is_selected = true
            cell.spr_selected:setVisible(true)
        else
            cell.btn_item.is_selected = false
            cell.spr_selected:setVisible(false)
        end

        return cell
    end

    layer.scroll_view_backpack:reloadData(vec_hero)

    layer.scroll_view_backpack.menu:setLuaModel(true)
    layer.scroll_view_backpack.menu:enableLongPress(true)
    -- layer.scroll_view_backpack.menu:setLongPressCallback(handler(self, self.longTouch))
end

function CrusadeGroupHeroSelectCtr:longTouch(tag, pSender)
    require("src.layer.heroinfo.HeroShareInfoCtr"):instance():openWindowById(pSender.hero_id)
end

function CrusadeGroupHeroSelectCtr:exchangeCallback(item_touch, item_exchange)
    if not item_exchange:isEnabled() or not item_exchange:isVisible() then
        local icon = self.layer["node_icon_" .. item_touch:getTag()]
        item_touch:setPosition(icon:getPosition())
        return
    end

    local exchange_tag = item_exchange:getTag()
    local touch_tag = item_touch:getTag()

    -- 交换tag
    item_exchange:setTag(item_touch:getTag())
    item_touch:setTag(exchange_tag)

    -- 交换id
    local layer = self.layer
    local data_before = layer.lineup_data.hero_list[exchange_tag]
    local data_after = layer.lineup_data.hero_list[touch_tag]
    local hero_id = data_before.hero_id
    data_before.hero_id = data_after.hero_id
    data_after.hero_id = hero_id

    return true
end

function CrusadeGroupHeroSelectCtr:updateLayer()
    if not self:getLayer() then
        return
    end

    local layer = self.layer
    local battle_config = cfg.battletype.battletype[layer.lineup_type]

    local req_compute = Battle_pb.GReqPreComputeStrength()
    req_compute.type = EVENT.HERO_SELECT_EVENT.FIGHT
    req_compute.line_up_type = battle_config.line_up_type

    for i, v in ipairs(layer.lineup_data.hero_list) do
        local hero_data = ex.Player.hero_data:getHeroDataById(v.hero_id)
        if hero_data then
            table.insert(req_compute.hero_ids, hero_data.hero_id)
        end
    end

    NetManager:sendMessage(ProtocolID.GReqPreComputeStrength, req_compute)

    self:updateHalo()
    self:updateFetter()
    self:updateDragonSkill()
    self:updateMatrix()
end

function CrusadeGroupHeroSelectCtr:onSelectIcon(tag, pSender)
    if pSender:getHeroId() == NULL_ID then
        return
    end
    local layer = self.layer

    local hero_id = pSender:getHeroId()
    pSender:setHeroId(NULL_ID)
    pSender:removeIcon()
    pSender:removeElem()
    pSender:removeLevel()
    pSender:removeStar()
    pSender:resetBg(true)

    -- TableEx.replace(layer.vec_selected, hero_id, NULL_ID)
    -- local hero_data = TableEx.findValueFunction(layer.lineup_data.hero_list, function(value)
    --     return value.hero_id == hero_id
    -- end)
    -- hero_data.hero_id = NULL_ID
    for k, v in pairs(layer.lineup_data.hero_list) do
        if v.hero_id == hero_id then
            v.hero_id = NULL_ID
        end
    end

    self:updateLayer()

    self:updateScrollViewBackpack()
end

function CrusadeGroupHeroSelectCtr:onBackpackIcon(tag, pSender)
    if not self.is_refresh then
        ex.MessageView:add("数据刷新中，请稍等") 
        return
    end

    local data = pSender.data
    local item = pSender:getParent():getParent()
    if not item then
        return
    end

    if pSender.is_selected then
        item.spr_selected:setVisible(false)

        for i, v in ipairs(self.layer.lineup_data.hero_list) do
            if v.hero_id == data.hero.hero_id then
                self.layer.lineup_data.hero_list[i].hero_id = NULL_ID
                break
            end
        end

        self:updateScrollViewSelected()
        pSender.is_selected = false
        self:updateLayer()
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    local layer = self.layer

    local hero_id = data.hero.hero_id

    -- 检查空位是否足够
    local hero_index = nil
    for i, v in ipairs(self.layer.lineup_data.hero_list) do
        if v.hero_id <= 0 then
            local is_open = false
            for _, v2 in pairs(cfg.battlematrixaddition.battlematrixaddition) do
                if v2.type == self._selectedFormationId and v2.position == i and v2.is_open > 0 then
                    is_open = true
                    break
                end
            end
            if is_open == true and (i ~= LineupIdxAssist or ex.Player.lineup_data.assistance_unlock) then
                hero_index = i
                break
            end
        end
    end

    if not hero_index then
        return
    end

    if not TableEx.isInTableFunction(
            layer.vec_heros,
            function(value)
                return value.hero.hero_id == hero_id
            end
        )
     then
        return
    end

    if data.is_death == true then
        ex.MessageView:add(ex.Tools:getLang(32306))
        return
    end

    if not data.is_energy_enough then
        ex.MessageView:add(ex.Tools:getLang(77938))
        return
    end

    local menu = layer.menu_selected
    local hero_item = menu:getChildByTag(hero_index)

    local hero_data = hero_id > 0 and ctr.crusade_group.data:getSetOffHero(hero_id).hero or nil
    if self:isRepeatHero(hero_data) then
        ex.MessageView:add(ex.Tools:getLang(41298))
        return
    end

    layer.lineup_data.hero_list[hero_index].hero_id = hero_id
    -- 将英雄放到出战列表中
    pSender.is_selected = true
    item.spr_selected:setVisible(true)
    if hero_item and hero_data then
        hero_item:setHeroId(hero_id)
        hero_item.star = hero_data.star
        hero_item:resetBg()
        hero_item:setIcon(hero_data.hero_type)
        hero_item:setLevel(hero_data.level)
        hero_item:setStar(hero_data.star)
        if hero_data.fashion_id ~= 0 and hero_data.fashion_id ~= nil then -- 有皮肤
            hero_item:setFashionShowForce(hero_data.fashion_id)
        end
    end

    self:updateLayer()
end

function CrusadeGroupHeroSelectCtr:isRepeatHero(hero_data)
    if not hero_data then
        return false
    end

    for k, v in pairs(self.layer.lineup_data.hero_list) do
        local tmp_hero_data = ex.Player.hero_data:getHeroDataById(v.hero_id)
        if tmp_hero_data and tmp_hero_data.hero_type == hero_data.hero_type then
            return true
        end
    end
    return false
end

function CrusadeGroupHeroSelectCtr:updateHalo()
    if not self:getLayer() then
        return
    end
    local layer = self.layer
    local sfc = cc.SpriteFrameCache:getInstance()

    local layer = self.layer
    local vec_hero = layer.lineup_data.hero_list
    local vec_result = {}
    for i, v in ipairs(vec_hero) do
        if v.hero_id > 0 then
            local hero_data = ex.Player.hero_data:getHeroDataById(v.hero_id)
            if hero_data then
                table.insert(vec_result, hero_data.hero_type)
            end
        end
    end

    local vec_idx, vec_attr, icon = ex.Player.battle_data:getBattleHalo(vec_result)
    ex.Tools:setSpriteFrame(layer.btn_halo:getNormalImage(), string.format("hero-icon/elem-%s.png", icon))
end

function CrusadeGroupHeroSelectCtr:updateFetter()
    if not self:getLayer() then
        return
    end

    local fetter_type = self.layer.select_fetter or 0

    -- 显示羁绊红点
    if ex.Player.fetter_data:isUnlockOne() then
        ex.Tools:addRedPoint(self.layer.btn_fetter:getNormalImage(), fetter_type == 0, ex.r.p8)
    end

    -- 显示+号
    if fetter_type == 0 then
        ex.Tools:setSpriteFrame(self.layer.btn_fetter:getNormalImage(), "hero-info/btn-add.png")
        return
    end

    local skin = ex.Player.fetter_data:getSkin(self.layer.select_fetter or 0)
    ex.Tools:setSpriteFrame(self.layer.btn_fetter:getNormalImage(), string.format("hero-icon/%d.png", skin))
end

-- 刷新显示圣龙技能
function CrusadeGroupHeroSelectCtr:updateDragonSkill()
    local is_visible = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_dragon")
    if is_visible == false then
        self.layer.node_dragon_skill:setVisible(false)
        return
    end
    self.layer.node_dragon_skill:setVisible(true)

    for i = 1, 4 do
        local spr_skill = self.layer["spr_dragon_skill_" .. i]
        local hallows_data = nil
        for _, v in pairs(ex.Player.dragon_data.vec_hallows) do
            if v.pos == i then
                hallows_data = v
                break
            end
        end

        if hallows_data == nil or hallows_data.item_type <= 0 then
            spr_skill:setVisible(false)
        else
            spr_skill:setVisible(true)
            local config_relic = cfg.dragonrelic.dragonrelic[hallows_data.item_type]
            spr_skill:setSpriteFrame("skill-icon/" .. config_relic.skill .. ".png")
        end
    end
end

function CrusadeGroupHeroSelectCtr:updateMatrix()
    local cur_matrix = self._selectedFormationId

    self.layer.btn_matrix:setNormalImage(cc.Sprite:createWithSpriteFrameName("hero-select/spr-matrix-2-" .. cur_matrix .. ".png"))
    local item_list = {}
    local config_addition = cfg.battlematrixaddition.battlematrixaddition
    for i, v in ipairs(config_addition) do
        if v.type == cur_matrix then
            table.insert(item_list, v)
        end
    end

    -- 显示锁状态及属性加成
    for i, v in ipairs(item_list) do
        self.layer["spr_lock_" .. v.position]:setVisible(v.is_open <= 0)
        self.layer["lbl_attr_add_" .. v.position]:setVisible(v.is_open > 0)

        if v.position == LineupIdxAssist then
            self.layer["spr_lock_" .. v.position]:setVisible(not ex.Player.lineup_data.assistance_unlock)
        end

        if v.ability[1] ~= nil and v.ability[1].attr > 0 then
            self.layer["lbl_attr_add_" .. v.position]:setString(ex.Tools:getLang(122000 + v.ability[1].attr) .. "+" .. (v.ability[1].value / 100) .. "%")
        end
    end
end

function CrusadeGroupHeroSelectCtr:onConfirm(tag, pSender)
    if not self.is_refresh then
        ex.MessageView:add("数据刷新中，请稍等") 
        return
    end

    local layer = self.layer

    local lineup_data = layer.lineup_data
    local hero_num = 0
    if lineup_data.hero_list ~= nil or #lineup_data.hero_list > 0 then
        for i,v in ipairs(lineup_data.hero_list) do
            if v.hero_id > 0 then
                hero_num = hero_num + 1
            end
        end
    end
    if hero_num <= 0 then
        ex.MessageView:add(ex.Tools:getLang(32307))
        return
    end

    local battle_config = cfg.battletype.battletype[self.layer.lineup_type]
    if battle_config and lineup_data then
        ex.Player.lineup_data:setLineup(battle_config.save_line_up_type, lineup_data.hero_list, lineup_data.goddess_type, lineup_data.formation_id)
    end

    if layer.callback then
        layer.callback(nil, nil, self.select_road)
    end

    self:closeWindow(tag, pSender)
end

function CrusadeGroupHeroSelectCtr:onSelectFetter()
    require("src.layer.FettersSelectCtr"):instance():openWindow(handler(self, self.onSelectFetterDone), self.layer.select_fetter)
end

function CrusadeGroupHeroSelectCtr:onSelectFetterDone(idx)
    self.layer.select_fetter = idx
    self.layer.lineup_data.goddess_type = self.layer.select_fetter
    self:updateFetter()
end

function CrusadeGroupHeroSelectCtr:onDragonSkill()
    require("src.layer.dragon.DragonSkillCtr"):instance():openWindow()
end

function CrusadeGroupHeroSelectCtr:onMatrix()
    require("src.layer.HeroMatrixCtr"):instance():openWindow(self._selectedFormationId, handler(self, self.onMatrixDone))
end

function CrusadeGroupHeroSelectCtr:onMatrixDone(matrix_type)
    local config_matrix = cfg.battlematrixaddition.battlematrixaddition
    -- 记录原始英雄无效位置
    local vec_lock_pos_last = {}
    for _, v in pairs(config_matrix) do
        if v.type == self._selectedFormationId and v.is_open == 0 then
            table.insert(vec_lock_pos_last, v.position)
        end
    end

    self._selectedFormationId = matrix_type
    self.layer.lineup_data.formation_id = self._selectedFormationId

    -- 记录新的英雄无效位置
    local vec_lock_pos_new = {}
    for _, v in pairs(config_matrix) do
        if v.type == self._selectedFormationId and v.is_open == 0 then
            table.insert(vec_lock_pos_new, v.position)
        end
    end

    -- 更新阵型位置
    self:updateMatrix()

    -- 修正英雄位置
    local tmp_vec_hero = {0, 0, 0, 0, 0, 0, 0, 0}
    for i, v in ipairs(self.layer.lineup_data.hero_list) do
        if v.hero_id > 0 then
            local pos = i
            local num = 0
            for _, v2 in ipairs(vec_lock_pos_last) do
                if v2 <= pos then
                    num = num - 1
                end
            end
            for _, v2 in ipairs(vec_lock_pos_new) do
                if v2 <= pos + num then
                    num = num + 1

                    for _, v3 in ipairs(vec_lock_pos_new) do
                        if v3 ~= v2 and v3 <= pos + num then
                            num = num + 1
                        end
                    end
                    break
                end
            end
            pos = pos + num

            if tmp_vec_hero[pos] ~= nil then
                tmp_vec_hero[pos] = v.hero_id
            end
        end
    end

    for k, v in pairs(tmp_vec_hero) do
        local hero_data = self.layer.lineup_data.hero_list[k]
        if hero_data then
            hero_data.hero_id = v
        end
    end

    self:updateScrollViewSelected()
end

function CrusadeGroupHeroSelectCtr:onHalo()
    local layer = self.layer
    local vec_hero = layer.lineup_data.hero_list
    local vec_result = {}
    for i, v in ipairs(vec_hero) do
        if v.position > 0 and v.hero_id > 0 then
            local hero_data = ex.Player.hero_data:getHeroDataById(v.hero_id)
            if hero_data then
                table.insert(vec_result, hero_data.hero_type)
            end
        end
    end
    require("src.layer.HaloCtr"):instance():openWindow(vec_result)
end

function CrusadeGroupHeroSelectCtr:onElem(tag, pSender)
    if self.select_elem then
        -- 界面是限定元素，则不给选择
        return
    end

    local layer = self.layer
    layer.layer_elem_type = tag

    self.layer.spr_select:setPosition(pSender:getPosition())

    self.layer.scroll_view_backpack:setLoaded(false)
    self:updateScrollViewBackpack()
end

function CrusadeGroupHeroSelectCtr:onFetterLineup()
end

function CrusadeGroupHeroSelectCtr:handleRefreshHero()
    self:updateAll()
    self.is_refresh = true
end


return CrusadeGroupHeroSelectCtr
