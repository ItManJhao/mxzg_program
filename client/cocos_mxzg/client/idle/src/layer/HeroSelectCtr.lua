local HeroSelectCtr = class("HeroSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroSelectLayer = class("HeroSelectLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
local UIMenu = require("src.comp.menu.UIMenu")


local default_formation_id = 1

HeroSelectLayer.vec_lineup_data = {}
HeroSelectLayer.vec_heros = {}
HeroSelectLayer.vec_heros_origin = {}
HeroSelectLayer.vec_selected = {}
HeroSelectLayer.callback = nil
HeroSelectLayer.layer_elem_type = 0

-- 默认选择第一页
HeroSelectLayer.select_type = 1

function HeroSelectLayer:onCreate()
    self:addBlackBackground()

    self.btn_confirm:setName("btn_confirm")
    self.btn_matrix:setLabelOffset(cc.p(0, -35))
    
    local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    item_size = cc.size(item_size.width + 30, item_size.height + 10)

    self.item_size = item_size
    self.scroll_view_backpack:setItemSize(cc.size(item_size.width, item_size.height))
    self.scroll_view_backpack:setItemOffset(cc.p(0, 5))
    self.scroll_view_backpack:setCreateNum(4)
    self.scroll_view_backpack:setName("hero_select_view")
    self.scroll_view_backpack:setResetOffset(true)
    
    self.scroll_view_team_title:setItemSize(cc.size(150, 45))
    self.scroll_view_team_title:setCreateNum(30)
    self.scroll_view_team_title:setName("scroll_view_team_title")
    self.scroll_view_team_title:setResetOffset(true)

    self:reorderChild(self.node_change_road, 10000)
    self.node_change_road:setVisible(false)
    self.btn_change_road:setVisible(false)
    self.lbl_change_road_tip_2:setPositionX(self:getContentSize().width / 2)
    self.lbl_change_road_tip_2:setString(ex.Tools:getLang(70118))
    self.lbl_change_road_tip_2:setVisible(false)
    self.lbl_change_road_tip:setVisible(false)

    self.btn_contract:setEnableAction(false)

    self.btn_fetter:setEnableAction(false)
    
    self.btn_dragon_skill:setEnableAction(false)

    self:addEvent(EVENT.HERO_EVENT.CHANGE_HERO_POSITION, handler(self,self.changeHeroPosition))
    self:addEvent(EVENT.HERO_SELECT_EVENT.FIGHT, handler(self,self.updateFight))

    ex.Tools:addRedPoint(self.onFetter, ex.Player.fetter_data:checkFetterContractInfo(), cc.p(0.38, 0.75))
end

function HeroSelectLayer:refreshFetterRed()
    ex.Tools:addRedPoint(self.onFetter,ex.Player.fetter_data:checkFetterContractInfo() , cc.p(0.38, 0.75))
end 

function HeroSelectLayer:changeHeroPosition(event,data)
    local hero_select_ctr = HeroSelectCtr:instance()
    hero_select_ctr:onBackpackIcon(data)
end 

function HeroSelectLayer:updateFight(event, fighting)
    self.lbl_battle_count:setString(string.format("%d", fighting))
    HeroSelectCtr:instance().fighting = fighting
end

function HeroSelectLayer:sortHeroData(data)
    local hero_list = data

    local function sor(a,b)
        local battle_a = ex.Player.hero_data.promote:heroIsBattle(a.hero_id) and 1 or 0
        local battle_b = ex.Player.hero_data.promote:heroIsBattle(b.hero_id) and 1 or 0

        if self.friends_hero_data and  a.hero_id == self.friends_hero_data.hero_id then 
            battle_a = 2
        end
        
        if self.friends_hero_data and  b.hero_id == self.friends_hero_data.hero_id then 
            battle_b = 2
        end 

        if battle_a ~= battle_b then  return battle_a > battle_b  end

        if a.star ~= b.star then return a.star > b.star end
        if a.level ~= b.level then return a.level > b.level end
        return a.hero_type > b.hero_type
    end
    table.sort(hero_list,sor)
    return hero_list
end

-----------------------------------------------------------------------------
function HeroSelectCtr:onCreate()
	self:setCCBIPath("ccbi/HeroSelectLayer.ccbi")
    self:setIsSingle(false)
    self.fighting = 0
end

function HeroSelectCtr:getLayerClass()
	return HeroSelectLayer
end

function HeroSelectCtr:getHeroSelectLayer()
	return self.layer
end

-- 根据战斗类型来选择阵型
-- TODO   最后一个参数为好友助战
function HeroSelectCtr:openWindow(str_title, str_content, battle_type, callback, vec_hp, friends_hero_list, can_save_callback, select_type, select_elem)
	if self:isOpened() then
		return
	end
	
	self:loadLayer()
	self:open()
	self:initData(str_title, str_content, battle_type, callback, vec_hp,  friends_hero_list, can_save_callback, select_type, select_elem)
end

function HeroSelectCtr:initData(str_title, str_content, battle_type, callback, vec_hp, friends_hero_list, can_save_callback, select_type, select_elem)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
	self.layer.btn_halo:registerScriptTapHandler(handler(self, self.onHalo))
    self.layer.btn_fetter:registerScriptTapHandler(handler(self, self.onSelectFetter))
    self.layer.btn_contract:registerScriptTapHandler(handler(self, self.onFetterLineup))
    self.layer.btn_dragon_skill:registerScriptTapHandler(handler(self, self.onDragonSkill))
    self.layer.btn_matrix:registerScriptTapHandler(handler(self, self.onMatrix))
    self.layer.btn_switch:registerScriptTapHandler(handler(self, self.onSwitch))
    
	self.layer.btn_elem0:registerScriptTapHandler(handler(self, self.onElem))
	self.layer.btn_elem1:registerScriptTapHandler(handler(self, self.onElem))
	self.layer.btn_elem2:registerScriptTapHandler(handler(self, self.onElem))
	self.layer.btn_elem3:registerScriptTapHandler(handler(self, self.onElem))
	self.layer.btn_elem4:registerScriptTapHandler(handler(self, self.onElem))
    self.layer.btn_elem5:registerScriptTapHandler(handler(self, self.onElem))

    self.layer:addEvent(EVENT.HERO_SELECT_EVENT.DRAGON_SKILL, handler(self, self.updateDragonSkill))

    self.layer.menu_assist:setLocalZOrder(1000)
    self.layer.btn_assist_tip:setContentSize(self.layer.spr_lock_9:getContentSize())
    self.layer.btn_assist_tip:setVisible(not ex.Player.lineup_data.assistance_unlock)
    self.layer.btn_assist_tip:registerScriptTapHandler(handler(self, self.onHeroAssistTip))
    self.layer.btn_assist_info:registerScriptTapHandler(handler(self, self.onHeroAssistInfo))

    self.layer._pressBtnId = 0
    self.layer.callback = callback
    self.layer.vec_hp = vec_hp    
    self.layer.friends_hero_list = friends_hero_list
    self.layer.can_save_callback = can_save_callback
    self.layer.lbl_title:setString(str_title)
    self.layer.btn_confirm:setLabelText(str_content)

    self.layer.lbl_battle_count:setString(string.format("%s", self.fighting))
	self.layer.lbl_title:setString(str_title)
	self.layer.btn_confirm:setLabelText(str_content)
    self.layer.spr_select:setPosition(self.layer.btn_elem0:getPosition())

    if type(battle_type) == "number" then
        self.layer.vec_lineup_type = {battle_type}
    else
        self.layer.vec_lineup_type = battle_type
    end

    local addLineupType = function(container, battle_config)
        if battle_config then
            local lineup_data = ex.Player.lineup_data:getLineup(battle_config.save_line_up_type)
            
            -- 拿默认的阵容
            -- add 熊梦
            -- 异界冒险武器系统动力系统、不拿主线阵容 
            if lineup_data == nil and battle_config.save_line_up_type ~= LineupType.EXOTIC_ADVENTURE_ARMS and battle_config.save_line_up_type ~= LineupType.EXOTIC_ADVENTURE_POWER then
                lineup_data = ex.Player.lineup_data:getLineup(battle_config.default_line_up_type)
            end

            -- 默认的阵容也是空的
            if lineup_data == nil then
                local data = {}
                data.type = battle_type
                data.time = 0
                data.goddess_type = 0
                data.formation_id = default_formation_id

                data.list_count = 8
                data.hero_list = {}
                for i=1, LineupIdxMax do
                    local hero_data = {}
                    hero_data.hero_id = NULL_ID
                    hero_data.hp = 0
                    hero_data.position = i
                    table.insert(data.hero_list, hero_data)
                end

                lineup_data = data
            end

            if lineup_data then
                -- self.layer.vec_lineup_data[battle_config.save_line_up_type] = clone(lineup_data)
                container[battle_config.save_line_up_type] = clone(lineup_data)
            end
        end
    end


    for k,v in pairs(self.layer.vec_lineup_type) do
        local battle_config = cfg.battletype.battletype[v]
        addLineupType(self.layer.vec_lineup_data, battle_config)
        if battle_config and battle_config.filter_list ~= "" then
            for i,vf in ipairs(battle_config.filter_list) do
                addLineupType(self.layer.vec_lineup_data, cfg.battletype.battletype[vf])
            end
        end
    end

    if select_type then
        local type = TableEx.findValueFunction(self.layer.vec_lineup_type, function(value)
            return value == select_type
        end)
        if type == nil then
            print("select_type not found", select_type)
            battle_type = self.layer.vec_lineup_type[1]
        else
            battle_type = type
        end
    else
        battle_type = self.layer.vec_lineup_type[1]
    end
    self.layer.battle_type = battle_type

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

    self:updateScrollViewTeamTitle()
    self:updateAll()
end

function HeroSelectCtr:onHeroAssistTip(tag, pSender)
    if not ex.Player.lineup_data.assistance_unlock then
        ex.MessageView:add(ex.Tools:getLang(77202))
    end
end

function HeroSelectCtr:onHeroAssistInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42102), ex.Tools:getLang(42103))
end

function HeroSelectCtr:updateAll()

    local sfc = cc.SpriteFrameCache:getInstance() 
    sfc:addSpriteFrames("ccbi-res/hero-info.plist")
    sfc:addSpriteFrames("ccbi-res/hero-select.plist")



    local battle_type = self.layer.battle_type
    print("HeroSelectCtr.battle_type", battle_type)

    -- 筛选英雄
    local battle_config = cfg.battletype.battletype[battle_type]
    self._saveLineUpType = battle_config.save_line_up_type
    if battle_config == nil then
        print("battle_config is nil")
    end
    
    -- 拿界面缓存的数据.界面打开时已经缓存服务器的布阵数据
    local lineup_data = self.layer.vec_lineup_data[battle_config.save_line_up_type]

    -- self.layer.vec_lineup_data[battle_config.save_line_up_type] = lineup_data

    self._selectedFormationId = lineup_data.formation_id

    -- 做一次数据验证调整
    if self._selectedFormationId == nil or self._selectedFormationId <= 0 then self._selectedFormationId = default_formation_id end

    for _,v in pairs(cfg.battlematrixaddition.battlematrixaddition) do
        if v.type == self._selectedFormationId and v.is_open <= 0 then
            if lineup_data.hero_list[v.position] ~= nil and lineup_data.hero_list[v.position].hero_id > 0 then 
                lineup_data.hero_list[v.position].hero_id = 0
            end
        end
    end

    local vec_filter_list = {}

    if battle_config.filter_list ~= "" then
        for k,v in pairs(battle_config.filter_list) do
            local tmp_battle_config = cfg.battletype.battletype[v]
            local tmp_lineup_data = self.layer.vec_lineup_data[tmp_battle_config.save_line_up_type]
            if tmp_lineup_data then
                for kh,vh in pairs(tmp_lineup_data.hero_list) do
                    table.insert(vec_filter_list, vh)
                end
            end
        end
    end
    
    local vec_heros = {}
    for k,v in pairs(ex.Player.hero_data.hero_list) do
        local is_filter = TableEx.findValueFunction(vec_filter_list, function(value)
            return value.hero_id == v.hero_id
        end)

        if is_filter == nil then
            table.insert(vec_heros, v)
        end
    end

    -- 删除血量为0的英雄
    if self.layer.vec_hp ~= nil then
        for i,v in ipairs(lineup_data.hero_list) do
            local hp_data = TableEx.findValueFunction(self.layer.vec_hp, function(value)
                return value.hero_id == v.hero_id
            end)

            if hp_data and hp_data.hp <= 0 then
                lineup_data.hero_list[i].hero_id = NULL_ID
            end
        end
    end


    if self.layer.friends_hero_list ~= nil and #self.layer.friends_hero_list > 0 then
        for i,v in ipairs(self.layer.friends_hero_list) do
            if v ~= nil and v.hero_id ~= 0 then 
                table.insert(vec_heros, v)
            end 
        end
    end
    
    -- 删除不符合等级需求的英雄
    local level_config = cfg.battleformation.battleformation[battle_config.line_up_type]
    if level_config.hero_need_level > 1 then
        local vec_hero = {}

        for k,v in pairs(vec_heros) do
            local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(v.hero_id)
            local level = is_cube_hero and v.tweak_cube_lv or v.level 
	    	if level >= level_config.hero_need_level then 
               table.insert(vec_hero, v)
	    	end
        end
        vec_heros = vec_hero
    end

    vec_heros = clone(vec_heros)

    local layer = self.layer
    layer.battle_type = battle_type
	layer.lineup_data = lineup_data
	layer.vec_heros = vec_heros
    layer.select_fetter = lineup_data.goddess_type or 0

    if battle_type == BattleType.TRIAL then
        layer.scroll_view_backpack:setItemSize(cc.size(layer.item_size.width, layer.item_size.height + 13))
    else
        layer.scroll_view_backpack:setItemSize(layer.item_size)
    end

    layer.lbl_tip:setVisible(false)
    if level_config.hero_need_level > 1 then
        layer.lbl_tip:setVisible(true)
        layer.lbl_tip:setString(string.format(ex.Tools:getLang(52315), level_config.hero_need_level))
    end

    NetManager:sendMessage(ProtocolID.GReqQueryFormation)

	self:updateScrollViewSelected()
    self:updateScrollViewBackpack()
    self:updateLayer()
end

function HeroSelectCtr:updateScrollViewTeamTitle()

    self.layer.scroll_view_team_title.createItemFunction = function(data, scale)
        local config = cfg.battletype.battletype[data]
        local btn_title = cpp.UIMenuItemTab:create("button/btn-tab-3.png", "button/btn-tab-4.png", config and ex.Tools:getLang(config.title_lang) or  " ", 1, 1)
        btn_title.data = data
        btn_title:setLabelOffset(cc.p(0, -2))
        btn_title:setLabelScale(0.55, 0.55)
        btn_title:setLabelColor(cc.c3b(122,71,45))
        btn_title:registerScriptTapHandler(handler(HeroSelectCtr:instance(), HeroSelectCtr:instance().onTabTitle))

        if self.layer.battle_type == data then
            btn_title:setChecked(true)
        end

        return btn_title
    end
    self.layer.scroll_view_team_title:reloadData(self.layer.vec_lineup_type)
end

function HeroSelectCtr:updateScrollViewSelected()
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
    for i,v in ipairs(layer.lineup_data.hero_list) do
        if index > LineupIdxMax then
            break
        end

        if index ~= LineupIdxAssist or ex.Player.lineup_data.assistance_unlock then
            local hero_data = ex.Player.hero_data:getHeroDataById(v.hero_id)
            local item = nil
            if hero_data then
                item = UIMenuItemHero:createWithData()
                item:reset(hero_data)
                if hero_data.fashion_id ~= 0 and hero_data.fashion_id ~= nil then   -- 有皮肤
                    item:setFashionShowForce(hero_data.fashion_id)
                end
            else
                local is_have = false
                if layer.friends_hero_list ~= nil and #layer.friends_hero_list > 0 then 
                    for i2,v2 in ipairs(layer.friends_hero_list) do
                        if v.hero_id == v2.hero_id then
                            item = UIMenuItemHero:createWithData()
                            item:reset(v2)
                            if v2.fashion_id ~= 0 and v2.fashion_id ~= nil then   -- 有皮肤
                                item:setFashionShowForce(v2.fashion_id)
                            end
                            is_have = true
                            break
                        end
                    end
                end
                if is_have == false then
                    layer.lineup_data.hero_list[i].hero_id = NULL_ID
                    item = UIMenuItemHero:createWithData()
                    item:setHeroId(NULL_ID)
                    item:removeIcon()
                    item:removeElem()
                    item:removeLevel()
                    item:removeStar()
                    item:resetBg(true)
                end
            end

            item:setScale(0.7)
            item:setEnableAction(false)
            item:setTag(index)
            local icon = layer["node_icon_"..index]
            item:setPosition(icon:getPosition())
            :registerScriptTapHandler(handler(self, self.onSelectIcon))
            layer.menu_selected:add(item)

            for _,v2 in pairs(config_matrix) do
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

function HeroSelectCtr:updateScrollViewBackpack()
    if not self:getLayer() then
        return
    end
    local layer = self.layer

    local vec_hero = {}
    for k,v in pairs(layer.vec_heros) do
        if layer.layer_elem_type == 0 then
            table.insert(vec_hero, v)
        elseif v.elem == layer.layer_elem_type then
            table.insert(vec_hero, v)
        end
    end

    local is_show_hp = layer.vec_hp ~= nil and true or false

    vec_hero = self.layer:sortHeroData(vec_hero)
    layer.scroll_view_backpack.createItemFunction = function(hero_data, scale)
        
        local item = UIMenuItemHero:createWithData()
        item:reset(hero_data)
        if hero_data.fashion_id ~= 0 and hero_data.fashion_id ~= nil then   -- 有皮肤
            item:setFashionShowForce(hero_data.fashion_id)
        end

        item:registerScriptTapHandler(handler(self, self.onBackpackIcon))
        item:setScale(1)

        
        if TableEx.findValueFunction(layer.lineup_data.hero_list, function(value)
            return value.hero_id == hero_data.hero_id
        end) then
            item:setSelected(true)
        end

        if layer.friends_hero_list ~= nil and #layer.friends_hero_list > 0 then 
            for i,v in ipairs(layer.friends_hero_list) do
                if hero_data.hero_id == v.hero_id then
                    item:setFriendHeroStatus()
                    break
                end
            end
        end 

        if is_show_hp then
            local hp_data = TableEx.findValueFunction(layer.vec_hp, function(v)
                return v.hero_id == hero_data.hero_id
            end)

            local now_hp = hp_data and hp_data.hp or hero_data:getHp()
            item:setDeath(hp_data ~= nil and hp_data.hp <= 0)
            item:setCompleted(now_hp, hero_data:getHp(), false)
        end

        return item
    end

    layer.scroll_view_backpack:reloadData(vec_hero)

    layer.scroll_view_backpack.menu:setLuaModel(true)
    layer.scroll_view_backpack.menu:enableLongPress(true)
    layer.scroll_view_backpack.menu:setLongPressCallback(handler(self, self.longTouch))
end

function HeroSelectCtr:onTabTitle(tag, pSender)
    self.layer.battle_type = pSender.data
    self:updateAll()
end

function HeroSelectCtr:updateTitleSelect(is_focus)
    local index = TableEx.isInTable(self.layer.vec_lineup_type, self.layer.battle_type)
    if index and index >= 0 and is_focus then
        self.layer.scroll_view_team_title:setFocus(index)
    end

    local children = self.layer.scroll_view_team_title.menu:getChildren()
	for i,v in ipairs(children) do
        local node = v
        
        if node.data then
            node:setChecked(node.data == self.layer.battle_type)
		end
    end
end

-- 设置好友支援英雄可选择的数量上限
function HeroSelectCtr:setFriendHeroMax(num_max)
    self.friend_hero_can_select_num = num_max
end

-- 显示公会战选路相关
-- @param default_road: 默认选中路线
function HeroSelectCtr:showRoadSelect(default_road)
    self.layer.btn_change_road:setVisible(true)

    if default_road == nil then
        self.select_road = 1
    else
        self.select_road = default_road
    end

    self.layer.lbl_tip:setVisible(false)

    self.layer.btn_change_road:setLabelText(ex.Tools:getLang(70113))
    self.layer.btn_change_road:setVisible(true)
    self.layer.lbl_change_road_tip:setString(string.format(ex.Tools:getLang(70112), ex.Tools:getLang(70113 + self.select_road)))
    self.layer.lbl_change_road_tip:setVisible(true)
    self.layer.lbl_change_road_tip_2:setVisible(true)

    -- self.layer.btn_confirm:setPosition(self.layer:getContentSize().width - 170, self.layer.btn_change_road:getPositionY())
    self.layer.btn_confirm:setScale(self.layer.btn_change_road:getScale())

    self.layer.btn_change_road:registerScriptTapHandler(handler(self, self.onChangeRoad))
    self.layer.btn_road_1:registerScriptTapHandler(handler(self, self.onRoadSelect))
    self.layer.btn_road_2:registerScriptTapHandler(handler(self, self.onRoadSelect))
end

-- 刷新显示圣龙技能
function HeroSelectCtr:updateDragonSkill()
    local is_visible = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_dragon")
    if is_visible == false then
        self.layer.node_dragon_skill:setVisible(false)
        return
    end
    self.layer.node_dragon_skill:setVisible(true)

    for i=1,4 do
        local spr_skill = self.layer["spr_dragon_skill_"..i]
        local hallows_data = nil
        for _,v in pairs(ex.Player.dragon_data.vec_hallows) do
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
            -- spr_skill:setSpriteFrame("skill-icon/"..config_relic.skill..".png")
            ex.Tools:setSpriteFrame(spr_skill, "skill-icon/"..config_relic.skill..".png")
        end
    end
end

-- 打开或隐藏选中路线节点
function HeroSelectCtr:onChangeRoad(tag, pSender)
    local is_visible = self.layer.node_change_road:isVisible()

    if is_visible == false then
        self.layer.node_change_road:setPosition(self.layer.btn_change_road:getPosition())
        self.layer.node_change_road:setVisible(true)

        if self.select_road == 1 then
            self.layer.btn_road_1:setLabelText(ex.Tools:getLang(70113 + 2))
            self.layer.btn_road_1:setTag(2)
        else
            self.layer.btn_road_1:setLabelText(ex.Tools:getLang(70113 + 1))
            self.layer.btn_road_1:setTag(1)
        end
        if self.select_road == 3 then
            self.layer.btn_road_2:setLabelText(ex.Tools:getLang(70113 + 2))
            self.layer.btn_road_2:setTag(2)
        else
            self.layer.btn_road_2:setLabelText(ex.Tools:getLang(70113 + 3))
            self.layer.btn_road_2:setTag(3)
        end
    else
        self.layer.node_change_road:setVisible(false)
    end
end

-- 选中对应路线
function HeroSelectCtr:onRoadSelect(tag, pSender)
    self.select_road = tag


    ex.MessageView:add(string.format(ex.Tools:getLang(47623), ex.Tools:getLang(70118 + self.select_road)))

    self.layer.node_change_road:setVisible(false)
    self.layer.lbl_change_road_tip:setString(string.format(ex.Tools:getLang(47648), ex.Tools:getLang(70118 + self.select_road)))
end

function HeroSelectCtr:updateScrollViewBackpack()
    if not self:getLayer() then
        return
    end
    local layer = self.layer    

    local vec_hero = {}
    for k,v in pairs(layer.vec_heros) do
        if layer.layer_elem_type == 0 then
            table.insert(vec_hero, v)
        elseif v.elem == layer.layer_elem_type then
            table.insert(vec_hero, v)
        end
    end

    local is_show_hp = layer.vec_hp ~= nil and true or false

    vec_hero = self.layer:sortHeroData(vec_hero)
    layer.scroll_view_backpack.createItemFunction = function(hero_data, scale)        
        local item = UIMenuItemHero:createWithData()
        item:reset(hero_data)
        if hero_data.fashion_id ~= 0 and hero_data.fashion_id ~= nil then   -- 有皮肤
            item:setFashionShowForce(hero_data.fashion_id)
        end

        item:registerScriptTapHandler(handler(self, self.onBackpackIcon))
        item:setScale(1)

        if TableEx.findValueFunction(layer.lineup_data.hero_list, function(value)
            return hero_data.hero_id == value.hero_id
        end) then
            item:setSelected(true)
        end

        if layer.friends_hero_list ~= nil and #layer.friends_hero_list > 0 then 
            for i,v in ipairs(layer.friends_hero_list) do
                if hero_data.hero_id == v.hero_id then
                    item:setFriendHeroStatus()
                    break
                end
            end
        end 

        if is_show_hp then
            local hp_data = TableEx.findValueFunction(layer.vec_hp, function(v)
                return v.hero_id == hero_data.hero_id
            end)
            -- hero_data:updateAbility()

            local now_hp = hp_data and hp_data.hp or hero_data:getHp()
            item:setDeath(hp_data ~= nil and hp_data.hp <= 0)
            item:setCompleted(now_hp, hero_data:getHp(), false)
        end

        return item
    end

    layer.scroll_view_backpack:reloadData(vec_hero)

    layer.scroll_view_backpack.menu:setLuaModel(true)
    layer.scroll_view_backpack.menu:enableLongPress(true)
    layer.scroll_view_backpack.menu:setLongPressCallback(handler(self, self.longTouch))
    -- menu, pSender
end

function HeroSelectCtr:longTouch(tag, pSender)

    if pSender.friend_type and pSender.friend_type >= 1 then
        return
    end

    require("src.layer.heroinfo.HeroShareInfoCtr"):instance():openWindowById(pSender.hero_id)
end
 
function HeroSelectCtr:exchangeCallback(item_touch, item_exchange)
    if not item_exchange:isEnabled() or not item_exchange:isVisible() then
        local icon = self.layer["node_icon_"..item_touch:getTag()]
        item_touch:setPosition(icon:getPosition())
        return
    end

    local exchange_tag = item_exchange:getTag()
    local touch_tag = item_touch:getTag()

  local config ={}
    for i,v in ipairs(cfg.battlematrixaddition.battlematrixaddition) do
        if v.type == self._selectedFormationId then
            table.insert(config,v)
        end
    end
    
    for i,v in ipairs(config) do
        if v.position == exchange_tag or v.position == touch_tag then
            if v.is_open == 0 then
                local icon = self.layer["node_icon_"..item_touch:getTag()]
                item_touch:setPosition(icon:getPosition())
                return
            end
        end
    end


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

function HeroSelectCtr:updateLayer()
	if not self:getLayer() then
		return
    end
    
	local layer = self.layer
    local battle_config = cfg.battletype.battletype[layer.battle_type]

    layer.btn_switch:setVisible(battle_config.switch ~= nil and battle_config.switch ~= "")

    local req_compute = Battle_pb.GReqPreComputeStrength()
    req_compute.type = EVENT.HERO_SELECT_EVENT.FIGHT
    req_compute.line_up_type = battle_config.line_up_type

    for i,v in ipairs(layer.lineup_data.hero_list) do
		local hero_data = ex.Player.hero_data:getHeroDataById(v.hero_id)
		if hero_data then
            table.insert(req_compute.hero_ids, hero_data.hero_id)
        else
            if layer.friends_hero_list ~= nil and #layer.friends_hero_list > 0 then 
                for i2,v2 in ipairs(layer.friends_hero_list) do
                    if v.hero_id == v2.hero_id then
                        table.insert(req_compute.hero_ids, v2.hero_id)
                        break
                    end
                end
            end 
        end
    end

    NetManager:sendMessage(ProtocolID.GReqPreComputeStrength, req_compute)

    self:updateHalo()
    self:updateFetter()
    self:updateDragonSkill()
    self:updateMatrix()
end


function HeroSelectCtr:onSelectIcon(tag, pSender)
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
    for k,v in pairs(layer.lineup_data.hero_list) do
        if v.hero_id == hero_id then
            v.hero_id = NULL_ID
        end
    end

    self:updateLayer()

    self:updateScrollViewBackpack()
end

function HeroSelectCtr:onBackpackIcon(tag, pSender)
    if pSender:isSelected() then
        for i,v in ipairs(self.layer.lineup_data.hero_list) do
            if v.hero_id == pSender:getHeroId() then
                self.layer.lineup_data.hero_list[i].hero_id = NULL_ID
                break
            end
        end

        self:updateScrollViewSelected()
        pSender:setSelected(false)
        self:updateLayer()
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    local layer = self.layer

    local hero_id = pSender:getHeroId()

    -- 检查空位是否足够
    local hero_index = nil
    for i,v in ipairs(self.layer.lineup_data.hero_list) do
        if v.hero_id <= 0 then
            local is_open = false
            for _,v2 in pairs(cfg.battlematrixaddition.battlematrixaddition) do
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

    if layer.friends_hero_list ~= nil and #layer.friends_hero_list > 0 then 
        -- 判定选中的英雄是否为好友支援英雄
        local is_friend_hero = false
        for i2,v2 in ipairs(layer.friends_hero_list) do
            if hero_id == v2.hero_id then
                is_friend_hero = true
                break
            end
        end

        if is_friend_hero then
            -- 检查好友支援英雄是否已达上限
            local friend_hero_select_num = 0
            for i,v in ipairs(layer.lineup_data.hero_list) do
                for i2,v2 in ipairs(layer.friends_hero_list) do
                    if v.hero_id == v2.hero_id then
                        friend_hero_select_num = friend_hero_select_num + 1
                        break
                    end
                end
            end 

            if self.friend_hero_can_select_num ~= nil and friend_hero_select_num ~= nil and self.friend_hero_can_select_num <= friend_hero_select_num then
                ex.MessageView:add(ex.Tools:getLang(41295))
                return
            end
        end
    end

    if not TableEx.isInTableFunction(layer.vec_heros, function(value)
        return value.hero_id == hero_id
    end) then
        return
    end

    if pSender.is_death == true then
        ex.MessageView:add(ex.Tools:getLang(32306))
        return
    end

    local menu = layer.menu_selected
    local item = menu:getChildByTag(hero_index)
    
    local hero_data = nil
    if pSender:getFriendHeroType() == 1 then
        for i,v in ipairs(layer.friends_hero_list) do
            if v.hero_id == hero_id then
                hero_data = v
                break
            end
        end
    else 
        hero_data = ex.Player.hero_data:getHeroDataById(hero_id)
    end

    if self:isRepeatHero(hero_data) then
        ex.MessageView:add(ex.Tools:getLang(41298))
        return
    end       

    layer.lineup_data.hero_list[hero_index].hero_id = hero_id
    -- 将英雄放到出战列表中
    pSender:setSelected(true)

    if item and hero_data then
        item:setHeroId(hero_id)
        item.star = hero_data.star
        item:resetBg()
        item:setIcon(hero_data.hero_type)
        item:setElem(hero_data.elem)
        item:setLevel(hero_data.level)
        item:setStar(hero_data.star)
        if hero_data.fashion_id ~= 0 and hero_data.fashion_id ~= nil then   -- 有皮肤
            item:setFashionShowForce(hero_data.fashion_id)
        end
    end

    self:updateLayer()
end



function HeroSelectCtr:isRepeatHero(hero_data)
    if not hero_data then
        return false
    end

    for k,v in pairs(self.layer.lineup_data.hero_list) do
        local tmp_hero_data = nil
        tmp_hero_data = TableEx.findValueFunction(self.layer.friends_hero_list, function(value)
            return value.hero_id == v.hero_id
        end)

        tmp_hero_data = tmp_hero_data or ex.Player.hero_data:getHeroDataById(v.hero_id)
        if tmp_hero_data and  tmp_hero_data.hero_type == hero_data.hero_type then
            return true
        end
    end
    return false
end

function HeroSelectCtr:updateHalo()
    if not self:getLayer() then
        return
    end
    local layer = self.layer
    local sfc = cc.SpriteFrameCache:getInstance()

    local layer = self.layer
    local vec_hero = layer.lineup_data.hero_list
    local vec_result = {}
    for i,v in ipairs(vec_hero) do
        if v.hero_id > 0 then
            local hero_data = ex.Player.hero_data:getHeroDataById(v.hero_id)
            if hero_data then
                table.insert(vec_result, hero_data.hero_type)
            else
                for i2,v2 in ipairs(layer.friends_hero_list) do
                    if v.hero_id == v2.hero_id then
                        table.insert(vec_result, v2.hero_type)
                        break
                    end
                end
            end
        end
    end

    local vec_idx, vec_attr, icon = ex.Player.battle_data:getBattleHalo(vec_result)
    ex.Tools:setSpriteFrame(layer.btn_halo:getNormalImage(), string.format("hero-icon/elem-%s.png", icon))
end


function HeroSelectCtr:updateFetter()
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
function HeroSelectCtr:updateDragonSkill()
    local is_visible = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_dragon")
    if is_visible == false then
        self.layer.node_dragon_skill:setVisible(false)
        return
    end
    self.layer.node_dragon_skill:setVisible(true)

    for i=1,4 do
        local spr_skill = self.layer["spr_dragon_skill_"..i]
        local hallows_data = nil
        for _,v in pairs(ex.Player.dragon_data.vec_hallows) do
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
            -- spr_skill:setSpriteFrame("skill-icon/"..config_relic.skill..".png")
            ex.Tools:setSpriteFrame(spr_skill, "skill-icon/"..config_relic.skill..".png")
        end
    end
end

function HeroSelectCtr:updateMatrix()
    local cur_matrix = self._selectedFormationId

    self.layer.btn_matrix:setNormalImage(cc.Sprite:createWithSpriteFrameName("hero-select/spr-matrix-2-"..cur_matrix..".png"))
    local item_list = {}
    local config_addition = cfg.battlematrixaddition.battlematrixaddition
    for i,v in ipairs(config_addition) do
        if v.type == cur_matrix then
            table.insert(item_list, v)
        end
    end

    -- 显示锁状态及属性加成
    for i,v in ipairs(item_list) do
        if self.layer["spr_lock_"..v.position] ~= nil then
            self.layer["spr_lock_"..v.position]:setVisible(v.is_open <= 0)
            self.layer["lbl_attr_add_"..v.position]:setVisible(v.is_open > 0)

            if v.position == LineupIdxAssist then
                self.layer["spr_lock_"..v.position]:setVisible(not ex.Player.lineup_data.assistance_unlock)
            end

            if v.ability[1] ~= nil and v.ability[1].attr > 0 then
                self.layer["lbl_attr_add_"..v.position]:setString(ex.Tools:getLang(122000 + v.ability[1].attr).."+"..(v.ability[1].value / 100).."%")
            end
        end
    end
end

--获取出战英雄的宝石的总星数
function HeroSelectCtr:getGemMaxNum( )
    local gem_max_num = 0
    local gem_list = {}
    local gem_num_list = {}
    for _,v in pairs(self.layer.vec_lineup_type) do
        local battle_config = cfg.battletype.battletype[v]
        local lineup_data = self.layer.vec_lineup_data[battle_config.save_line_up_type]
        for i=1,#lineup_data.hero_list do
            if lineup_data.hero_list[i] ~= nil and lineup_data.hero_list[i].hero_id ~= NULL_ID then
                local gem_data = ex.Player.hero_data:getHeroJewelListForHeroid(lineup_data.hero_list[i].hero_id)
                if gem_data.jewel_list ~= nil and #gem_data.jewel_list > 0 then
                    for j,k in ipairs(gem_data.jewel_list) do
                        if k.jewel_type and k.jewel_type > 0 then
                            table.insert(gem_list, k.jewel_type) 
                        end
                    end                   
                end
            end
        end
    end
   for k,v in pairs(cfg.jeweltype.jeweltype) do
        for i,j in ipairs(gem_list) do
            if k == j then
            table.insert(gem_num_list, v.star)
            end
        end  
   end
    for i,v in ipairs(gem_num_list) do
        gem_max_num = gem_max_num + v
    end

    return gem_max_num

end

function HeroSelectCtr:onConfirm(tag, pSender)
    local layer = self.layer

    -- 时空魔塔关卡挑战 增添宝石星数限制
    if layer.vec_lineup_type[1] == 24 then
        local data = clone(ex.Player.space_time_magic_tower_data)
        local cur_mission = data.mission_id + 1 
        local ret = 0
        for k, v in ipairs(cfg.timetowermisson.timetowermisson) do
            if cur_mission == v.mission then
                ret = v.need_gem_lv
                break
            end
        end
        if self:getGemMaxNum() < ret then
            ex.MessageView:add(string.format(ex.Tools:getLang(75631),ret))
            return
        end
    end

    for _,v in pairs(layer.vec_lineup_type) do
        local battle_config = cfg.battletype.battletype[v]
        local lineup_data = layer.vec_lineup_data[battle_config.save_line_up_type]
        local is_select = nil
        for i=1,LineupNum do
            if lineup_data.hero_list[i] ~= nil and lineup_data.hero_list[i].hero_id ~= NULL_ID then
                is_select = true
            end
        end
        if is_select == nil then
            ex.MessageView:add(ex.Tools:getLang(47575))
            layer.battle_type = v
            self:updateAll()
            self:updateTitleSelect(true)
            return
        end
    end

    if layer.can_save_callback then
        if layer.can_save_callback() ~= true then
            self:closeWindow(tag, pSender)
            return
        end
    end

    for k,v in pairs(layer.vec_lineup_type) do
        local battle_config = cfg.battletype.battletype[v]
        local lineup_data = layer.vec_lineup_data[battle_config.save_line_up_type]
        if battle_config and lineup_data then
            ex.Player.lineup_data:setLineup(battle_config.save_line_up_type, lineup_data.hero_list, lineup_data.goddess_type, lineup_data.formation_id)
        end
    end

    if layer.callback then
        layer.callback(nil, nil, self.select_road)
    end
    
    self:closeWindow(tag, pSender)
end

function HeroSelectCtr:onSelectFetter()
    require("src.layer.FettersSelectCtr"):instance():openWindow(handler(self, self.onSelectFetterDone),
                                                                self.layer.select_fetter)
end

function HeroSelectCtr:onSelectFetterDone(idx)
    self.layer.select_fetter = idx
    local save_line_up_type = cfg.battletype.battletype[self.layer.battle_type].save_line_up_type
    local lineup_data = self.layer.vec_lineup_data[save_line_up_type]
    if lineup_data then
        lineup_data.goddess_type = self.layer.select_fetter
    end
    self:updateFetter()
end

function HeroSelectCtr:onDragonSkill()
    require("src.layer.dragon.DragonSkillCtr"):instance():openWindow()
end


function HeroSelectCtr:onMatrix()
    require("src.layer.HeroMatrixCtr"):instance():openWindow(self._selectedFormationId, handler(self, self.onMatrixDone))
end

function HeroSelectCtr:onMatrixDone(matrix_type)
    if not self.layer then
        return
    end

    local config_matrix = cfg.battlematrixaddition.battlematrixaddition
    -- 记录原始英雄无效位置
    local vec_lock_pos_last = {}
    for _,v in pairs(config_matrix) do
        if v.type == self._selectedFormationId and v.is_open == 0 then
            table.insert(vec_lock_pos_last, v.position)
        end
    end

    self._selectedFormationId = matrix_type
    local lineup_data = self.layer.vec_lineup_data[cfg.battletype.battletype[self.layer.battle_type].save_line_up_type]
    if lineup_data then
        lineup_data.formation_id = self._selectedFormationId
    end

    -- 记录新的英雄无效位置
    local vec_lock_pos_new = {}
    for _,v in pairs(config_matrix) do
        if v.type == self._selectedFormationId and v.is_open == 0 then
            table.insert(vec_lock_pos_new, v.position)
        end
    end

    -- 更新阵型位置
    self:updateMatrix()

    -- 修正英雄位置
    local tmp_vec_hero = {0, 0, 0, 0, 0, 0, 0, 0}
    for i,v in ipairs(self.layer.lineup_data.hero_list) do
        if v.hero_id > 0 then
            local pos = i
            local num = 0
            for _,v2 in ipairs(vec_lock_pos_last) do
                if v2 <= pos then
                    num = num - 1
                end
            end
            for _,v2 in ipairs(vec_lock_pos_new) do
                if v2 <= pos + num then
                    num = num + 1

                    for _,v3 in ipairs(vec_lock_pos_new) do
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

    for k,v in pairs(tmp_vec_hero) do
        local hero_data = self.layer.lineup_data.hero_list[k]
        if hero_data then
            hero_data.hero_id = v
        end
    end

    self:updateScrollViewSelected()
end



function HeroSelectCtr:onHalo()
    local layer = self.layer
    local vec_hero = layer.lineup_data.hero_list
    local vec_result = {}
    for i,v in ipairs(vec_hero) do
        if v.position > 0 and v.hero_id > 0 then
            local hero_data = ex.Player.hero_data:getHeroDataById(v.hero_id)
            if hero_data then
                table.insert(vec_result, hero_data.hero_type)
            else
                for i2,v2 in ipairs(layer.friends_hero_list) do
                    if v.hero_id == v2.hero_id then
                        table.insert(vec_result, v2.hero_type)
                        break
                    end
                end
            end
        end
    end
    require("src.layer.HaloCtr"):instance():openWindow(vec_result)
end

function HeroSelectCtr:onElem(tag, pSender)
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

function HeroSelectCtr:onFetterLineup()
end

function HeroSelectCtr:onSwitch()
    local battle_config = cfg.battletype.battletype[self.layer.battle_type]
    local cur_lineup_data = self.layer.vec_lineup_data[battle_config.save_line_up_type]
    local switch_lineup_data = self.layer.vec_lineup_data[battle_config.switch]
    self.layer.vec_lineup_data[battle_config.switch] = cur_lineup_data
    self.layer.vec_lineup_data[battle_config.save_line_up_type] = switch_lineup_data
    self:updateAll()
    -- if lineup_data then
    --     lineup_data.formation_id = self._selectedFormationId
    -- end
end

return HeroSelectCtr
