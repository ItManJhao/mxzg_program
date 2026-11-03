local AliceChangeLineupCtr = class("AliceChangeLineupCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local AliceChangeLineupLayer = class("AliceChangeLineupLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
local UIMenu = require("src.comp.menu.UIMenu")


local default_formation_id = 1

AliceChangeLineupLayer.vec_lineup_data = {}
AliceChangeLineupLayer.vec_heros = {}
AliceChangeLineupLayer.vec_heros_origin = {}
AliceChangeLineupLayer.vec_selected = {}
AliceChangeLineupLayer.callback = nil
AliceChangeLineupLayer.layer_elem_type = 0

-- 默认选择第一页
AliceChangeLineupLayer.select_type = 1
local LINEIP_ID = {
    [1] = 39,
    [2] = 40,
    [3] = 41,
}
local LINEIP_ID_TYPE = {
    [39] = 1,
    [40] = 2,
    [41] = 3,
}
function AliceChangeLineupLayer:onCreate()
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

    self:reorderChild(self.node_change_road, 10000)
    self.node_change_road:setVisible(false)

    self.btn_contract:setEnableAction(false)

    self.btn_fetter:setEnableAction(false)
    
    self.btn_dragon_skill:setEnableAction(false)

    self:addEvent(EVENT.HERO_EVENT.CHANGE_HERO_POSITION, handler(self,self.changeHeroPosition))
    self:addEvent(EVENT.ALICE.ALICE_UPDATE_FIGHT, handler(self,self.updateFight))

    ex.Tools:addRedPoint(self.onFetter, ex.Player.fetter_data:checkFetterContractInfo(), cc.p(0.38, 0.75))
end

function AliceChangeLineupLayer:refreshFetterRed()
    ex.Tools:addRedPoint(self.onFetter,ex.Player.fetter_data:checkFetterContractInfo() , cc.p(0.38, 0.75))
end 

function AliceChangeLineupLayer:changeHeroPosition(event,data)
    local hero_select_ctr = AliceChangeLineupCtr:instance()
    hero_select_ctr:onBackpackIcon(data)
end 

function AliceChangeLineupLayer:updateFight(event,type,fighting)
    local select_team_fighting = fighting
    -- print(AliceChangeLineupCtr:instance().select_team)
    -- print(AliceChangeLineupCtr:instance().lineup_num)
    if AliceChangeLineupCtr:instance().select_team ~= 0 then
        local team = LINEIP_ID[AliceChangeLineupCtr:instance().select_team]
        if team == type then
            self.lbl_battle_count:setString(string.format("%d", fighting))
            AliceChangeLineupCtr:instance().fighting = fighting
        end
    else
        for i=1, AliceChangeLineupCtr:instance().lineup_num do
            self["lbl_fitting_bg_"..LINEIP_ID_TYPE[type]]:setString(fighting)
        end
    end
end

function AliceChangeLineupLayer:sortHeroData(data)
    local hero_list = data

    local function sor(a,b)
        local a_id = a.hero_id == 10 and 1 or 0
        local b_id = b.hero_id == 10 and 1 or 0

        local battle_a = ctr.alice.data:heroIsBattle(a.hero_id) and 1 or 0
        local battle_b = ctr.alice.data:heroIsBattle(b.hero_id) and 1 or 0
        
        if a_id ~= b_id then return a_id > b_id  end
        if battle_a ~= battle_b then  return battle_a > battle_b  end
        if a.star ~= b.star then return a.star > b.star end
        if a.level ~= b.level then return a.level > b.level end
        return a.hero_type > b.hero_type
    end
    table.sort(hero_list,sor)
    return hero_list
end

-----------------------------------------------------------------------------
function AliceChangeLineupCtr:onCreate()
	self:setCCBIPath("ccbi/AliceChangeLineupLayer.ccbi")
    self:setIsSingle(false)
    self.fighting = 0
end

function AliceChangeLineupCtr:getLayerClass()
	return AliceChangeLineupLayer
end

function AliceChangeLineupCtr:getAliceChangeLineupLayer()
	return self.layer
end

-- 根据战斗类型来选择阵型
-- TODO   最后一个参数为好友助战
function AliceChangeLineupCtr:openWindow(str_title, str_content, battle_type, callback, vec_hp, friends_hero_list, can_save_callback, select_type)
	if self:isOpened() then
		return
	end
	
	self:loadLayer()
	self:open()
	self:initData(str_title, str_content, battle_type, callback, vec_hp,  friends_hero_list, can_save_callback, select_type)
end

function AliceChangeLineupCtr:initData(str_title, str_content, battle_type, callback, vec_hp, friends_hero_list, can_save_callback, select_type)
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

    self.layer.menu_assist:setLocalZOrder(1000)
    self.layer.btn_assist_tip:setContentSize(self.layer.spr_lock_9:getContentSize())
    self.layer.btn_assist_tip:setVisible(true)
    self.layer.btn_assist_tip:registerScriptTapHandler(handler(self, self.onHeroAssistTip))
    self.layer.btn_assist_info:registerScriptTapHandler(handler(self, self.onHeroAssistInfo))
    self.layer.btn_change_team_1_2:registerScriptTapHandler(handler(self, self.onChangeTeam))
    self.layer.btn_change_team_2_3:registerScriptTapHandler(handler(self, self.onChangeTeam))

    for i=0,3 do
        self.layer["team_"..i]:setLabelText(ex.Tools:getLang(580050 + i))
        self.layer["team_"..i]:setLabelOffset(cc.p(0, -2))
        self.layer["team_"..i]:setLabelScale(0.55, 0.55)
        self.layer["team_"..i]:setLabelColor(cc.c3b(122,71,45))
        self.layer["team_"..i]:setVisible(false)
        self.layer["team_"..i]:registerScriptTapHandler(handler(self, self.onTabTitle))
    end
    self.layer.btn_change_team_2_3:setVisible(false)

    self.lineup_num = ctr.alice.data:getLineupNumByStar()
    if self.lineup_num > 2 then
        self.layer.btn_change_team_2_3:setVisible(true)
    end
    self.select_team = 1
    if self.lineup_num ~= 1 then
        self.select_team = 0
    end
    self.layer.node_pannel_2:setVisible(self.lineup_num == 1)
    self.layer.team_all_node:setVisible(self.lineup_num ~= 1)

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
    battle_type = {39,40,41}

    if type(battle_type) == "number" then
        self.layer.vec_lineup_type = {battle_type}
    else
        self.layer.vec_lineup_type = battle_type
    end

    

    local addLineupType = function(container, battle_config)
        if battle_config then
            local lineup_data = ex.Player.lineup_data:getLineup(battle_config.save_line_up_type)
            
            
            -- -- 拿默认的阵容
            -- if lineup_data == nil then
            --     lineup_data = ex.Player.lineup_data:getLineup(battle_config.default_line_up_type)
            -- end

            -- 默认的阵容也是空的
            if lineup_data == nil then
                local data = {}
                data.type = battle_type
                data.time = 0
                data.goddess_type = 0
                data.formation_id = default_formation_id

                data.list_count = 8
                data.hero_list = {}
                for i=1, LineupNum do
                    local hero_data = {}
                    hero_data.hero_id = NULL_ID
                    hero_data.hp = 0
                    hero_data.position = i
                    table.insert(data.hero_list, hero_data)
                end

                lineup_data = data
            end

            if lineup_data then
                container[battle_config.save_line_up_type] = clone(lineup_data)
            end
        end
    end


    for k,v in pairs(self.layer.vec_lineup_type) do
        local battle_config = cfg.battletype.battletype[v]
        addLineupType(self.layer.vec_lineup_data, battle_config)
    end
    for lineup_idx=1,self.lineup_num do
        -- for k,hero in pairs(self.layer.vec_lineup_data[LINEIP_ID[lineup_idx]].hero_list) do
        --     if hero.hero_id ~= 0 then 
        --         ctr.alice.data:setBattleHero(hero.hero_id,lineup_idx,self.layer.vec_lineup_data[LINEIP_ID[lineup_idx]].hero_list)
        --     end
        -- end
        ctr.alice.data:setBattleHero(lineup_idx,self.layer.vec_lineup_data[LINEIP_ID[lineup_idx]].hero_list)
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
    --检查过阵容的队伍type
    self.add_team_type = {}
    self:updateTeam()
    self:updateAll()
   
end

function AliceChangeLineupCtr:updateTeam()

    self.layer.team_all_node:setVisible(self.select_team == 0)
    self.layer.node_pannel_2:setVisible(self.select_team  ~= 0)
    self.layer.lbl_no_team_tips:setVisible(false)
    local lineup_num = ctr.alice.data:getLineupNumByStar()

    for i=0,3 do
        self.layer["team_"..i]:setChecked(i == self.select_team)
    end
    
    if lineup_num == 1 then
        self.layer.team_1:setPosition( self.layer.team_0:getPosition())
        self.layer.team_1:setVisible(true)
        self.layer.team_1:setChecked(true)
    elseif lineup_num == 2 then
        for i=0,2 do
            self.layer["team_"..i]:setVisible(true)        
        end
        self.layer.team_menu_node_3:setVisible(false)
        self.layer.lbl_no_team_tips:setVisible(true)
        self.layer.lbl_no_team_tips:setString(ex.Tools:getLang(580568))
    else
        for i=0,3 do
            self.layer["team_"..i]:setVisible(true)  
        end  
    end
    if self.select_team == 0 then
        self.layer.btn_dragon_skill:setVisible(false)
        self.layer.btn_fetter:setVisible(false)
        self.layer.lbl_adjust:setVisible(false)
    else
        self.layer.btn_dragon_skill:setVisible(true)
        self.layer.btn_fetter:setVisible(true)
        self.layer.lbl_adjust:setVisible(true)
    end
    

    self:getLineupMatrix() 
end

function AliceChangeLineupCtr:getLineupMatrix()

    local lineup_num = ctr.alice.data:getLineupNumByStar()
    if lineup_num <= 1 then
        return
    end
    local line_up_hero_data = {}
    for i=1,lineup_num do
        local num = 0
        local lineup_data = self.layer.vec_lineup_data[LINEIP_ID[i]]
        if not lineup_data then
            break
        end
        local formation_id = lineup_data.formation_id
        local formation_id_list = {}
        for _,v in pairs(cfg.battlematrixaddition.battlematrixaddition) do
            if v.type == formation_id then
                table.insert( formation_id_list, v)
                table.sort( formation_id_list, function (a,b)
                    return a.idx < b.idx
                end )
            end
        end

        for _,v in ipairs(formation_id_list) do
           if v.position ~= 9 and v.is_open > 0 then
                num = num + 1
                self.layer["hero_icon_"..i.."_"..num]:setTag(i * 10 + v.position)
           end
        end
    end
    -- print(self.layer.hero_icon_1_1:getTag(),self.layer.hero_icon_1_2:getTag(),self.layer.hero_icon_1_3:getTag(),self.layer.hero_icon_1_4:getTag(),self.layer.hero_icon_1_5:getTag(),self.layer.hero_icon_1_6:getTag())
    -- print(self.layer.hero_icon_2_1:getTag(),self.layer.hero_icon_2_2:getTag(),self.layer.hero_icon_2_3:getTag(),self.layer.hero_icon_2_4:getTag(),self.layer.hero_icon_2_5:getTag(),self.layer.hero_icon_2_6:getTag())

end

function AliceChangeLineupCtr:updateAll()

    local sfc = cc.SpriteFrameCache:getInstance() 
    sfc:addSpriteFrames("ccbi-res/hero-info.plist")
    sfc:addSpriteFrames("ccbi-res/hero-select.plist")



    local battle_type = self.layer.battle_type
    print("AliceChangeLineupCtr.battle_type", battle_type)

    -- 筛选英雄
    local battle_config = cfg.battletype.battletype[battle_type]
    self._saveLineUpType = battle_config.save_line_up_type
    if battle_config == nil then
        print("battle_config is nil")
    end
    
    -- 拿界面缓存的数据.界面打开时已经缓存服务器的布阵数据
    -- local lineup_data = {}
    for i=1, self.lineup_num do
        local lineup_data = self.layer.vec_lineup_data[LINEIP_ID[i]]
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

         --移除阵容中的助阵英雄
        for i,v in ipairs(lineup_data.hero_list) do
            if v.position == 9 then
                table.remove( lineup_data.hero_list, i )
            end
        end

    end

    local function getgrade(level)
        for i,v in pairs(cfg.heroupgrade.grade) do
            if level > v.begin_level and level <= v.level then
                return v.grade
            elseif level > 140 then
                return 6
            end
        end
    end

    local hero_list_clone = clone(ex.Player.hero_data.hero_list)
    local star = ctr.alice.data.star
    for i,hero_data in ipairs(hero_list_clone) do
        if hero_data then
            for _,herobase in pairs(cfg.herobase.herobase) do
                if hero_data.hero_type == herobase.type then
                    hero_data.hp = herobase.hp
                    hero_data.spd = herobase.spd
                    hero_data.atk = herobase.atk
                    hero_data.def = herobase.def                 
                    if hero_data.star < star then
                        hero_data.level = cfg.herostar.star[hero_data.star].level_limit 
                    else
                        hero_data.star = star                
                        hero_data.level = cfg.herostar.star[star].level_limit 
                    end
                    hero_data.stage = getgrade(hero_data.level)
                end
            end  
        end
    end

    local vec_heros = {}

    for k,v in pairs(hero_list_clone) do
         table.insert(vec_heros, v)
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


    --克隆一份英雄数据
    -- vec_heros = clone(vec_heros)
    local assist_hero = ctr.alice.data.assist_hero_data
    --是否有助战英雄，如果有把它加入到英雄列表中
    if assist_hero ~= nil and assist_hero.hero_id ~= nil then
        if assist_hero.star == ctr.alice.data.star then
            table.insert( vec_heros, ctr.alice.data.assist_hero_data )
        else
            ctr.alice.data.assist_hero_data = {}
        end
    end
    


    local layer = self.layer
    layer.battle_type = battle_type
	-- layer.lineup_data = lineup_data
	layer.vec_heros = vec_heros
    -- layer.select_fetter = lineup_data.goddess_type or 0

    layer.scroll_view_backpack:setItemSize(layer.item_size)

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

function AliceChangeLineupCtr:updateScrollViewSelected()
	if not self:getLayer() then
		return
	end
    local layer = self.layer
    if self.select_team == 0 then
        if layer.team_menu ~= nil then
            layer.team_menu:removeFromParent()
            layer.team_menu = nil
        end
        layer.team_menu = UIMenu:create()
        layer.team_menu:setPosition(cc.p(0, 0))
        layer.team_menu:setSwallowsTouches(false)
        layer.team_menu:setName("menu_selected")
        layer.team_all_node:addChild(layer.team_menu)

        layer.team_menu:enableExchange(true)
        layer.team_menu:setExchangeCallback(handler(self, self.exchangeCallback))
    else
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
    end

    local index = 1
    local config_matrix = cfg.battlematrixaddition.battlematrixaddition

    local function updateselect(tag)
        local lineup_data = self.layer.vec_lineup_data[LINEIP_ID[tag]]
        for i,v in ipairs(lineup_data.hero_list) do
            if index > 8 then
                index = 1
                break
            end
        --    print( ex.Player.lineup_data.assistance_unlock)
            if index ~= LineupIdxAssist or ex.Player.lineup_data.assistance_unlock then
                local hero_data = nil
                local star = ctr.alice.data.star
                if  v.hero_id == 10 then
                    local a = 0
                end
                if v.hero_id == 10 and ctr.alice.data.assist_hero_data.star == star then
                    hero_data = ctr.alice.data.assist_hero_data
                else
                    hero_data = clone(ex.Player.hero_data:getHeroDataById(v.hero_id))
                end
                             
                if hero_data then
                    for _,herobase in pairs(cfg.herobase.herobase) do
                        if hero_data.hero_type == herobase.type  then
                            hero_data.hp = herobase.hp
                            if hero_data.star < star then
                                hero_data.level = cfg.herostar.star[hero_data.star].level_limit 
                            else    
                                hero_data.star = star                
                                hero_data.level = cfg.herostar.star[hero_data.star].level_limit 
                            end
                        end
                    end  
                end
                
                local item = nil
                if hero_data then
                    item = UIMenuItemHero:createWithData()
                    item:reset(hero_data)
                    local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(hero_data.hero_id)
                    if is_cube_hero then
                        item:setLevel(hero_data.level,true)
                    end               
                    if hero_data.fashion_id ~= 0 and hero_data.fashion_id ~= nil then   -- 有皮肤
                        item:setFashionShowForce(hero_data.fashion_id)
                    end
                else
                        -- self.layer.vec_lineup_data[LINEIP_ID[lineup_idx]].hero_list
                        self.layer.vec_lineup_data[LINEIP_ID[tag]].hero_list[i].hero_id = NULL_ID
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
                item:setTag(index + tag * 10)
                -- print("item:getTag()", item:getTag())
                local icon = nil
                if self.select_team == 0 then
                    item:setScale(0.5)
                    local is_have = true
                        for pos=1,6 do
                            local tmp_tag = layer["hero_icon_"..tag.."_"..pos]:getTag() - tag * 10
                            if index == tmp_tag then
                                icon = layer["hero_icon_"..tag.."_"..pos]
                                is_have = false
                                break
                            end
                        end
                    
                    if is_have then
                        icon = layer.hero_icon_0
                    end
                    local offset = (layer.team_all_node:getContentSize().width - layer.team_node_1:getContentSize().width) / 2
                    item:setPosition(icon:getPositionX() + offset  , icon:getPositionY() + icon:getParent():getPositionY() + icon:getParent():getParent():getPositionY())
                    :registerScriptTapHandler(handler(self, self.onSelectIcon))
                else
                    icon = layer["node_icon_"..index]
                    item:setPosition(icon:getPosition())
                    :registerScriptTapHandler(handler(self, self.onSelectIcon))
                end
                 
                if self.select_team == 0 then
                    layer.team_menu:add(item)
                else
                    layer.menu_selected:add(item)
                end

                for _,v2 in pairs(config_matrix) do
                    if v2.type == lineup_data.formation_id and v2.position == index then
                        item:setVisible(v2.is_open == 1)
                        if v2.is_open == 0 then
                            v = 0
                        end
                        break
                    end
                end
            end
            index = index + 1
            if index > 8 then
                index = 1
                break
            end
        end
    end
    if self.select_team == 0 then
        for i=1,self.lineup_num do
            updateselect(i)
        end
    else
        updateselect(self.select_team )
    end
end

--显示可上阵的英雄
function AliceChangeLineupCtr:updateScrollViewBackpack()
    if not self:getLayer() then
        return
    end
    local layer = self.layer    

    local vec_hero = {}
    for k,v in pairs(layer.vec_heros) do
        -- if v.star <= ctr.alice.data.star then
            if layer.layer_elem_type == 0 then
                table.insert(vec_hero, v)
            elseif v.elem == layer.layer_elem_type then
                table.insert(vec_hero, v)
            end
        -- end
    end

    local is_show_hp = layer.vec_hp ~= nil and true or false

    vec_hero = self.layer:sortHeroData(vec_hero)
    layer.scroll_view_backpack.createItemFunction = function(hero_data, scale)        
        local item = UIMenuItemHero:createWithData()
        item:reset(hero_data)
        local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(hero_data.hero_id)
        if is_cube_hero then
            item:setLevel(hero_data.level,true)
        end 
        if hero_data.hero_id == 10 then
            item:setFriendHeroStatus()
        end
        if hero_data.fashion_id ~= 0 and hero_data.fashion_id ~= nil then   -- 有皮肤
            item:setFashionShowForce(hero_data.fashion_id)
        end

        item:registerScriptTapHandler(handler(self, self.onBackpackIcon))
        item:setScale(1)


        if self.select_team ~= 0 then
            local lock_list = {}
            local lineup_type_list = {1}
            if self.lineup_num == 1 then
                lineup_type_list = {1}
            elseif self.lineup_num == 2 then
                lineup_type_list = {1,2}
            else
                lineup_type_list = {1,2,3}
            end
            -- local lineup_type_list = {1,2,3}
            for i,v in ipairs(lineup_type_list) do
                if v == self.select_team then
                    table.remove( lineup_type_list, i )
                end
            end          
            for i,lineup_idx in pairs(lineup_type_list) do
                for i,v in pairs(self.layer.vec_lineup_data[LINEIP_ID[lineup_idx]].hero_list) do
                    if v ~= 0 and v.hero_id ~= 0 then
                        table.insert( lock_list, v.hero_id  )
                    end
                end
            end
 
            for k,hero_id in pairs(lock_list) do
                if hero_data.hero_id == hero_id then
                    item:setSelected(false)
                    item:setEnabled(false)
                    item:setLocked()
                end
            end

            if TableEx.findValueFunction(self.layer.vec_lineup_data[LINEIP_ID[self.select_team]].hero_list, function(value)
                return (value ~= 0 and hero_data.hero_id == value.hero_id)
            end) then
                item:setSelected(true)
            end
        else
            for lineup_idx=1,self.lineup_num do
                if TableEx.findValueFunction(self.layer.vec_lineup_data[LINEIP_ID[lineup_idx]].hero_list, function(value)
                    return (value ~= 0 and hero_data.hero_id == value.hero_id)
                end) then
                    item:setSelected(true)
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

function AliceChangeLineupCtr:updateLayer()
	if not self:getLayer() then
		return
    end
    
	local layer = self.layer

    local function reqfighting(battle_config,tag)
        local req_compute = Alice_pb.GReqAliceLineUpFighting()
        req_compute.star = ctr.alice.data.star
        req_compute.line_up_type = battle_config.line_up_type

        -- for lineup_idx=1,self.lineup_num do
            
            for i,v in ipairs(self.layer.vec_lineup_data[LINEIP_ID[tag]].hero_list) do
                local hero_data = ex.Player.hero_data:getHeroDataById(v.hero_id)
              
                if v.hero_id == 10 then
                    hero_data = ctr.alice.data.assist_hero_data
                    -- hero_data.hero_id = -1
                end
                if hero_data then
                    table.insert(req_compute.heroId, hero_data.hero_id)
                end
            end

            NetManager:sendMessage(ProtocolID.GReqAliceLineUpFighting, req_compute)
        -- end
    end
    local battle_config = nil
    if self.select_team ~= 0 then
        battle_config = cfg.battletype.battletype[LINEIP_ID[self.select_team]]
        reqfighting(battle_config,self.select_team)
    else
        for lineup_idx=1,self.lineup_num do
            battle_config = cfg.battletype.battletype[LINEIP_ID[lineup_idx]] 
            reqfighting(battle_config,lineup_idx)
        end
    end

    
    self:updateHalo()
    self:updateMatrix()
end

--刷新最终的元素类型
function AliceChangeLineupCtr:updateHalo()
    if not self:getLayer() then
        return
    end
    local layer = self.layer
    local sfc = cc.SpriteFrameCache:getInstance()

    local layer = self.layer
    -- local vec_hero = layer.lineup_data.hero_list
    
    local function setelem(tag)
        local vec_result = {}
        for i,v in ipairs(self.layer.vec_lineup_data[LINEIP_ID[tag]].hero_list) do
            if v.hero_id > 0 then
                local hero_data = ex.Player.hero_data:getHeroDataById(v.hero_id)
                if hero_data then
                    table.insert(vec_result, hero_data.hero_type)
                end
            end
            if v.hero_id == 10 then
                local hero_type = ctr.alice.data.assist_hero_data.hero_type
                table.insert(vec_result, hero_type)
            end
        end  
        local vec_idx, vec_attr, icon = ex.Player.battle_data:getBattleHalo(vec_result)
        ex.Tools:setSpriteFrame(layer["spr_elem_"..tag], string.format("hero-icon/elem-%s.png", icon)) 
        ex.Tools:setSpriteFrame(layer.btn_halo:getNormalImage(), string.format("hero-icon/elem-%s.png", icon))
    end
    if self.select_team ~= 0 then
        setelem(self.select_team)
    else
        for lineup_idx=1,self.lineup_num do  
            setelem(lineup_idx)
        end   
    end
end

--刷新阵容的类型
function AliceChangeLineupCtr:updateMatrix()
    local cur_matrix = nil
    if self.select_team ~= 0 then
        cur_matrix = self.layer.vec_lineup_data[LINEIP_ID[self.select_team]].formation_id
        self.layer.btn_matrix:setNormalImage(cc.Sprite:createWithSpriteFrameName("hero-select/spr-matrix-2-"..cur_matrix..".png"))
    else
        for lineup_idx=1,self.lineup_num do 
            local cur_matrix_type = self.layer.vec_lineup_data[LINEIP_ID[lineup_idx]].formation_id
            ex.Tools:setSpriteFrame(self.layer["spr_matrix_"..lineup_idx], string.format("hero-select/spr-matrix-2-%s.png", cur_matrix_type))
        end
    end
    
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
                self.layer["spr_lock_"..v.position]:setVisible(true)
            end

            if v.ability[1] ~= nil and v.ability[1].attr > 0 then
                self.layer["lbl_attr_add_"..v.position]:setString(ex.Tools:getLang(122000 + v.ability[1].attr).."+"..(v.ability[1].value / 100).."%")
            end
        end
    end
    self:getLineupMatrix()
end

function AliceChangeLineupCtr:onTabTitle(tag, pSender)
    if self.select_team == tag then
        return
    end
    self.select_team = tag
    if tag ~= 0 then
        self.layer.battle_type = LINEIP_ID[tag]
       
    end
    self:updateTeam()
    self:updateAll()
end

function AliceChangeLineupCtr:longTouch(tag, pSender)

    -- if pSender.friend_type and pSender.friend_type >= 1 then
    --     return
    -- end

    require("src.layer.alice.AliceAssistHeroShareInfoCtr"):instance():openWindow(pSender.data, pSender.hero_id)
end
 
function AliceChangeLineupCtr:exchangeCallback(item_touch, item_exchange)
    if not item_exchange:isEnabled() or not item_exchange:isVisible() then
        local icon = self.layer["node_icon_"..item_touch:getTag() % 10]
        item_touch:setPosition(icon:getPosition())
        return
    end

    local exchange_tag = item_exchange:getTag()
    local touch_tag = item_touch:getTag()

    local touch_team = math.floor(touch_tag / 10)
    local exchange_team = math.floor(exchange_tag / 10)

    local exchange_tag_pos = exchange_tag % 10
    local touch_tag_pos = touch_tag % 10

    if self.select_team ~= 0 then
        if touch_team ~= self.select_team or exchange_team ~= self.select_team then
            return
        end
        local config ={}
        for i,v in ipairs(cfg.battlematrixaddition.battlematrixaddition) do
            if v.type == self.layer.vec_lineup_data[LINEIP_ID[exchange_team]].formation_id then
                table.insert(config,v)
            end
        end
        
        for i,v in ipairs(config) do
            if v.position == touch_tag_pos or v.position == exchange_tag_pos then
                if v.is_open == 0 then
                    local icon = self.layer["node_icon_"..item_touch:getTag() % 10]
                    item_touch:setPosition(icon:getPosition())
                    return
                end
            end
        end
    end

    if self.select_team == 0 then    
        --验证点击英雄的数据和被替换英雄队伍数据是否有冲突
        for i,v in pairs( self.layer.vec_lineup_data[LINEIP_ID[exchange_team]].hero_list) do
            if touch_team ~= exchange_team then
                local tmp_hero_data = nil
                tmp_hero_data = ex.Player.hero_data:getHeroDataById(v.hero_id)
                if v.hero_id == 10 then
                    tmp_hero_data = ctr.alice.data.assist_hero_data
                end
                if tmp_hero_data and  tmp_hero_data.hero_type == item_touch.hero_type then
                    ex.MessageView:add(ex.Tools:getLang(41298))
                    self:updateScrollViewSelected()
                    return 
                end
            end  
        end

        --验证被替换英雄数据和主动点击的英雄队伍数据是有否冲突
        for i,v in pairs( self.layer.vec_lineup_data[LINEIP_ID[touch_team]].hero_list) do
            if touch_team ~= exchange_team then
                local tmp_hero_data = nil
                tmp_hero_data = ex.Player.hero_data:getHeroDataById(v.hero_id)
                if v.hero_id == 10 then
                    tmp_hero_data = ctr.alice.data.assist_hero_data
                end
                if tmp_hero_data and  tmp_hero_data.hero_type == item_exchange.hero_type then
                    ex.MessageView:add(ex.Tools:getLang(41298))
                    self:updateScrollViewSelected()
                    return 
                end
            end  
        end
    end
   

    -- 交换tag
    item_exchange:setTag(touch_tag)
    item_touch:setTag(exchange_tag)

    -- 交换id
    local layer = self.layer
    local data_before = self.layer.vec_lineup_data[LINEIP_ID[exchange_team]].hero_list[exchange_tag % 10]
    local data_after = self.layer.vec_lineup_data[LINEIP_ID[touch_team]].hero_list[touch_tag % 10]
    local hero_id = data_before.hero_id
    data_before.hero_id = data_after.hero_id
    data_after.hero_id = hero_id
    return true
end

function AliceChangeLineupCtr:onChangeTeam(tag, pSender)
    --获取对调队伍的数据
    local chang_team_1 =  clone(self.layer.vec_lineup_data[LINEIP_ID[tag]])
    local chang_team_2 = clone(self.layer.vec_lineup_data[LINEIP_ID[tag + 1]])

    --交换数据

    self.layer.vec_lineup_data[LINEIP_ID[tag + 1]].formation_id = chang_team_1.formation_id
    self.layer.vec_lineup_data[LINEIP_ID[tag + 1]].hero_list = chang_team_1.hero_list
    self.layer.vec_lineup_data[LINEIP_ID[tag + 1]].type = chang_team_1.type
    self.layer.vec_lineup_data[LINEIP_ID[tag + 1]].time = chang_team_1.time
    self.layer.vec_lineup_data[LINEIP_ID[tag + 1]].goddess_type = chang_team_1.goddess_type

    self.layer.vec_lineup_data[LINEIP_ID[tag]].formation_id = chang_team_2.formation_id
    self.layer.vec_lineup_data[LINEIP_ID[tag]].hero_list = chang_team_2.hero_list
    self.layer.vec_lineup_data[LINEIP_ID[tag]].type = chang_team_2.type
    self.layer.vec_lineup_data[LINEIP_ID[tag]].time = chang_team_2.time
    self.layer.vec_lineup_data[LINEIP_ID[tag]].goddess_type = chang_team_2.goddess_type
    self:updateLayer()
    self:updateScrollViewSelected()
end


function AliceChangeLineupCtr:onSelectIcon(tag, pSender)
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
    for lineup_idx=1,self.lineup_num do   
        for k,v in pairs(layer.vec_lineup_data[LINEIP_ID[lineup_idx]].hero_list) do
            if v.hero_id == hero_id then
                v.hero_id = NULL_ID
            end
        end
    end
    self:updateLayer()

    self:updateScrollViewBackpack()
end

function AliceChangeLineupCtr:onBackpackIcon(tag, pSender)
    if pSender:isSelected() then
        for lineup_idx=1,self.lineup_num do
            for i,v in ipairs(self.layer.vec_lineup_data[LINEIP_ID[lineup_idx]].hero_list) do
                if v.hero_id == pSender:getHeroId() then
                    self.layer.vec_lineup_data[LINEIP_ID[lineup_idx]].hero_list[i].hero_id = NULL_ID
                    break
                end
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

    -- -- 检查空位是否足够
    local hero_index = nil
    local hero_team = nil

    if self.select_team == 0 then
        for i=1,self.lineup_num do
            local lineup_data = self.layer.vec_lineup_data[LINEIP_ID[i]]
            -- 检查空位是否足够
            
            local is_find = false
            for idx,v in ipairs(lineup_data.hero_list) do
                if v.hero_id <= 0 then
                    local is_open = false
                    for _,v2 in pairs(cfg.battlematrixaddition.battlematrixaddition) do
                        if v2.type == lineup_data.formation_id and v2.position == idx and v2.is_open > 0 then
                            is_open = true
                            break
                        end
                    end
                    if is_open == true and (idx ~= LineupIdxAssist or ex.Player.lineup_data.assistance_unlock) then
                        hero_index = idx
                        is_find = true
                        break
                    end
                end
            end
            if is_find then
                hero_team = i
                break
            end
        end
    else
        local lineup_data = self.layer.vec_lineup_data[LINEIP_ID[self.select_team]]
            -- 检查空位是否足够
            
            local is_find = false
            for idx,v in ipairs(lineup_data.hero_list) do
                if v.hero_id <= 0 then
                    local is_open = false
                    for _,v2 in pairs(cfg.battlematrixaddition.battlematrixaddition) do
                        if v2.type == lineup_data.formation_id and v2.position == idx and v2.is_open > 0 then
                            is_open = true
                            break
                        end
                    end
                    if is_open == true and (idx ~= LineupIdxAssist or ex.Player.lineup_data.assistance_unlock) then
                        hero_index = idx
                        is_find = true
                        break
                    end
                end
            end
            if is_find then
                hero_team = self.select_team
                -- break
            end
    end

    if not hero_index then
        return
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

    local menu = nil
    local item = nil
    if self.select_team == 0 then
         menu = layer.team_menu
    else
         menu = layer.menu_selected
    end
    item = menu:getChildByTag(hero_index + hero_team * 10)

    
    
    local hero_data = nil
    local star = ctr.alice.data.star
    hero_data = clone(ex.Player.hero_data:getHeroDataById(hero_id))
    if hero_data then
        for _,herobase in pairs(cfg.herobase.herobase) do
            if hero_data.hero_type == herobase.type  then
                hero_data.hp = herobase.hp
                if hero_data.star < star then
                    hero_data.level = cfg.herostar.star[hero_data.star].level_limit 
                else    
                    hero_data.star = star                
                    hero_data.level = cfg.herostar.star[hero_data.star].level_limit 
                end
            end
        end  
    end
    if hero_id == 10 then
        hero_data = ctr.alice.data.assist_hero_data
    end

    -- if self.select_team == 0 then
    --     self.layer.vec_lineup_data[LINEIP_ID[hero_team]].hero_list
    -- end

    if self:isRepeatHero(hero_data,hero_team) then
        ex.MessageView:add(ex.Tools:getLang(41298))
        return
    end       

    self.layer.vec_lineup_data[LINEIP_ID[hero_team]].hero_list[hero_index].hero_id = hero_id

    -- layer.lineup_data.hero_list[hero_index].hero_id = hero_id
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

--判断是都否有重复英雄
function AliceChangeLineupCtr:isRepeatHero(hero_data,team)
    if not hero_data then
        return false
    end

    -- local function isrepeat(tag)
        -- for lineup_idx=1,self.lineup_num do
            for i,v in pairs( self.layer.vec_lineup_data[LINEIP_ID[team]].hero_list) do
                local tmp_hero_data = nil
                tmp_hero_data = ex.Player.hero_data:getHeroDataById(v.hero_id)
                if v.hero_id == 10 then
                    tmp_hero_data = ctr.alice.data.assist_hero_data
                end
                if tmp_hero_data and  tmp_hero_data.hero_type == hero_data.hero_type then
                    return true
                end
            end
        -- end
    -- end

    -- if self.select_team ~= 0 then
    --     return  isrepeat(self.select_team)
    -- else
    --     for lineup_idx=1,self.lineup_num do
    --         return isrepeat(lineup_idx)
    --     end
        
    -- end
   
    return false
end

--保存阵容
function AliceChangeLineupCtr:onConfirm(tag, pSender)
    local layer = self.layer
    -- self.layer.vec_lineup_data[LINEIP_ID[lineup_idx]].hero_list
    for _,v in pairs(layer.vec_lineup_type) do
        for i=1,self.lineup_num do
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
                return
            end
        end
       break
    end

    if self.select_team ~= 0 then
        local lineup_data = layer.vec_lineup_data[LINEIP_ID[self.select_team]]
        self:setLineup(LINEIP_ID[self.select_team], lineup_data.hero_list, lineup_data.goddess_type, lineup_data.formation_id)
    else
        for i=1,self.lineup_num do
            local lineup_data = layer.vec_lineup_data[LINEIP_ID[i]]
            if lineup_data then
                self:setLineup(LINEIP_ID[i], lineup_data.hero_list, lineup_data.goddess_type, lineup_data.formation_id)
            end
        end
    end
    -- for i=1,self.lineup_num do
    --     local lineup_data = layer.vec_lineup_data[LINEIP_ID[i]]
    --     if lineup_data then
    --         self:setLineup(LINEIP_ID[i], lineup_data.hero_list, lineup_data.goddess_type, lineup_data.formation_id)
    --     end
    -- end

    if layer.can_save_callback then
        if layer.can_save_callback() ~= true then
            self:closeWindow(tag, pSender)
            return
        end
    end

    

    if layer.callback then
        layer.callback(nil, nil, self.select_road)
    end
    
    self:closeWindow(tag, pSender)
end

--保存阵容以及把阵容加到缓存
function AliceChangeLineupCtr:setLineup(type, vec_hero, fetter_type, formation_id)
    --阵容加到缓存
	local data = {}
	data.type = type
	data.time = 0
	data.goddess_type = fetter_type or 0
	data.formation_id = formation_id or 0

	data.list_count = table.nums(vec_hero)
	data.hero_list = vec_hero

	ex.Player.lineup_data.vec_lineup[type] = data

	-- 发送数据
	local req = Alice_pb.GReqAliceSaveLineUp()
    req.star = ctr.alice.data.star
	req.lineData.type = data.type
	req.lineData.time = data.time
	req.lineData.goddess_type = data.goddess_type
	req.lineData.formation_id = data.formation_id
	for k,v in pairs(vec_hero) do
		local hero_data = req.lineData.hero_list:add()
        hero_data.hero_id = v.hero_id
        -- if v.hero_id == 10 then
        --     hero_data.hero_id = -1
        -- end
		hero_data.hp = v.hp
		hero_data.position = k
	end
	NetManager:sendMessage(ProtocolID.GReqAliceSaveLineUp, req)

    -- -- local vec_hero_id =ex.Player.lineup_data:getIdList(data.type,data.hero_list)
    -- for k,v in pairs(vec_hero) do
	-- 	if v.hero_id ~= 0 then 
			-- ctr.alice.data:setBattleHero(v.hero_id,LINEIP_ID_TYPE[type], vec_hero)
	-- 	end
	-- end
    ctr.alice.data:setBattleHero(LINEIP_ID_TYPE[type], vec_hero)
	
end

function AliceChangeLineupCtr:onSelectFetter()
    ex.MessageView:add(ex.Tools:getLang(580067))
end

function AliceChangeLineupCtr:onDragonSkill()
    ex.MessageView:add(ex.Tools:getLang(580067))
end


function AliceChangeLineupCtr:onMatrix()
    require("src.layer.HeroMatrixCtr"):instance():openWindow(self.layer.vec_lineup_data[LINEIP_ID[self.select_team]].formation_id, handler(self, self.onMatrixDone))
end

function AliceChangeLineupCtr:onMatrixDone(matrix_type)
    if not self.layer then
        return
    end

    local config_matrix = cfg.battlematrixaddition.battlematrixaddition
    -- 记录原始英雄无效位置
    local vec_lock_pos_last = {}
    -- for _,v in pairs(config_matrix) do
    --     if v.type == self._selectedFormationId and v.is_open == 0 then
    --         table.insert(vec_lock_pos_last, v.position)
    --     end
    -- end

    if self.select_team ~= 0 then
        for _,v in pairs(config_matrix) do
            if v.type == self.layer.vec_lineup_data[LINEIP_ID[self.select_team]].formation_id and v.is_open == 0 then
                table.insert(vec_lock_pos_last, v.position)
            end
        end
        self.layer.vec_lineup_data[LINEIP_ID[self.select_team]].formation_id = matrix_type
    end
    
    local lineup_data = self.layer.vec_lineup_data[cfg.battletype.battletype[self.layer.battle_type].save_line_up_type]
    if lineup_data then
        lineup_data.formation_id = self.layer.vec_lineup_data[LINEIP_ID[self.select_team]].formation_id
    end

    -- 记录新的英雄无效位置
    local vec_lock_pos_new = {}
    for _,v in pairs(config_matrix) do
        if self.layer.vec_lineup_data[LINEIP_ID[self.select_team]].formation_id and v.type == self.layer.vec_lineup_data[LINEIP_ID[self.select_team]].formation_id and v.is_open == 0 then
            table.insert(vec_lock_pos_new, v.position)
        end
    end

    -- 更新阵型位置
    self:updateMatrix()

    -- 修正英雄位置
    local tmp_vec_hero = {0, 0, 0, 0, 0, 0, 0, 0}
    -- for lineup_idx=1,self.lineup_num do
        for i,v in ipairs(self.layer.vec_lineup_data[LINEIP_ID[self.select_team]].hero_list) do
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
            local hero_data = self.layer.vec_lineup_data[LINEIP_ID[self.select_team]].hero_list[k]
            if hero_data then
                hero_data.hero_id = v
            end
        end
    
        self:updateScrollViewSelected()
    -- end
end



function AliceChangeLineupCtr:onHalo()
    local layer = self.layer
    -- local vec_hero = layer.lineup_data.hero_list
    local vec_result = {}
    for lineup_idx=1,self.lineup_num do
        for i,v in ipairs(self.layer.vec_lineup_data[LINEIP_ID[lineup_idx]].hero_list) do
            if v.position > 0 and v.hero_id > 0 then
                local hero_data = ex.Player.hero_data:getHeroDataById(v.hero_id)
                if hero_data then
                    table.insert(vec_result, hero_data.hero_type)
                end
            end
        end
    end
    require("src.layer.HaloCtr"):instance():openWindow(vec_result)
end

function AliceChangeLineupCtr:onElem(tag, pSender)

    local layer = self.layer
    layer.layer_elem_type = tag

    self.layer.spr_select:setPosition(pSender:getPosition())

    self.layer.scroll_view_backpack:setLoaded(false)
    self:updateScrollViewBackpack()
end

function AliceChangeLineupCtr:onHeroAssistTip(tag, pSender)
    ex.MessageView:add(ex.Tools:getLang(580067))
end

function AliceChangeLineupCtr:onHeroAssistInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42102), ex.Tools:getLang(42103))
end

function AliceChangeLineupCtr:onFetterLineup()
end


return AliceChangeLineupCtr
