local LuaBattleLayer = class("LuaBattleLayer", function()
                                return cpp.LuaBattleLayer:create() 
                            end)
                        
function LuaBattleLayer:onLayerEvent()
    self:registerScriptHandler(handler(self, self.eventHandler))
end

function LuaBattleLayer:eventHandler(eventType)
    if eventType == "enter" then
        self:onEventLayerEnter()
    elseif eventType == "exit" then
        self:onEventLayerExit()
    end
end

function LuaBattleLayer:ctor()
	self:registerLoadScriptHandler(handler(self, self.onBattleEvent))
    local sfc = cc.SpriteFrameCache:getInstance() 
    sfc:addSpriteFrames("ccbi-res/skill-icon.plist")
    sfc:addSpriteFrames("ccbi-res/battle-scene.plist")

    self:onLayerEvent()

    self.total_round = 15

    local win_size = cc.Director:getInstance():getWinSize()
    local top_height = win_size.height - (122 + 40) - 22;

	self:setLuaMode(true)
	self.node_scene = cc.Node:create()
    self:addChild(self.node_scene)

    self.node_hero = cc.Node:create()
    self.node_scene:addChild(self.node_hero, 1)

    self.node_bg = cc.Node:create()
    self.node_scene:addChild(self.node_bg)

    self.skill_system = cpp.SkillSystem:new()
    self.skill_system:retain()

   	self:setNodeSceneLua(self.node_scene)
    self:setNodeHeroLua(self.node_hero)
   	self:setNodeBgLua(self.node_bg)
	self:setSkillSystemLua(self.skill_system)
    self:setActionTimeLua(0.5)

    self.listener = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
    self.listener:setSwallowTouches(true)
    self.listener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN )
    self.listener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED )
    self.listener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED )
    local event_dispatcher = self:getEventDispatcher() 
    event_dispatcher:addEventListenerWithSceneGraphPriority(self.listener, self)
    
    self.lbl_round_text = cc.Label:createWithTTF(ex.Tools:getLang(47301), FONT_DEFAULT_NAME_BOLD, 50)
    self.lbl_round_text:setScale(0.5)
    self.lbl_round_text:setPosition(win_size.width * 0.5, top_height)
    self.lbl_round_text:enableOutline(FONT_BLACK_C4B, 3)
    self:addChild(self.lbl_round_text)

    self.lbl_round = cc.Label:createWithTTF("0", FONT_DEFAULT_NAME_BOLD, 50)
    self.lbl_round:setScale(0.5)
    self.lbl_round:setPosition(win_size.width * 0.5, self.lbl_round_text:getPositionY() - 30)
    self.lbl_round:enableOutline(FONT_BLACK_C4B, 3)
    self:addChild(self.lbl_round)
    

    self:initMenuScene()
    self:initSpeedBtn()
    self:initSkipBtn()

	self:enter()
    if self.onCreate then
        self:onCreate()
    end
end

function LuaBattleLayer:onEventLayerEnter()
    self.node_hero:setContentSize(self:getMapSizeLua())
    self.node_hero:setPosition(self:getMapPosLua())
    if self.onEnter then
        self:onEnter()
   end
end

function LuaBattleLayer:onEventLayerExit()
    if self.scheduler_wait_reward ~= nil then 
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler_wait_reward)
        self.scheduler_wait_reward = nil
    end

    if self.onExit then
         self:onExit()
    end
end


function LuaBattleLayer:initMenuScene()
    -- 添加场景menu
    self.menu_scene = cpp.UIMenu:create()
    self.menu_scene:setPosition(0, 0)
    self:addChild(self.menu_scene)
end

function LuaBattleLayer:initSpeedBtn(x, y, scale)

    if self.btn_speed then
        return
    end

    local win_size = cc.Director:getInstance():getWinSize()
    
    x = x or win_size.width - 80
    -- y = y or win_size.height * 0.275
    y = y or ex.MainSceneCtr:getBottomHeight() + 220
    scale = scale or 1

    self.speed = cc.UserDefault:getInstance():getIntegerForKey(string.format("%s-battle_speed", ex.Player.role_id), 0)
    -- self:setTimeScaleLua(self.speed + 1)
    self.speed_level = 3

    -- 双倍速度按钮
    -- self.btn_speed = cpp.UIMenuItemImage:createWithSpriteFrameName(nil, nil, nil)
    -- self.btn_speed:setContentSize(150, 70)
    -- self.btn_speed:setPosition(x, y)
    -- self.btn_speed:setScale(scale)
    -- self.btn_speed:registerScriptTapHandler(handler(self, self.onChangeSpeed))
    -- self.menu_scene:addChild(self.btn_speed)


    -- local spr_bg = cc.Sprite:createWithSpriteFrameName("battle-scene/spr-bg-1.png")
    -- spr_bg:setPosition(95, 35);
    -- self.btn_speed:addChild(spr_bg)

    -- local spr_speed = cc.Sprite:createWithSpriteFrameName("battle-scene/btn-speed-1.png")
    -- spr_speed:setPosition(37, 35);
    -- self.btn_speed:addChild(spr_speed)

    -- self.lbl_speed = cc.Label:createWithTTF(string.format("x%d", self.speed + 1), FONT_DEFAULT_NAME_BOLD, 45)
    -- self.lbl_speed:setAnchorPoint(0, 0.5)
    -- self.lbl_speed:setPosition(76, 35)
    -- self.lbl_speed:enableOutline(FONT_RED, 1)
    -- self.btn_speed:addChild(self.lbl_speed)

    self.btn_speed = cpp.UIMenuItemImage:createWithSpriteFrameName("battle-scene/btn-speed-1.png", nil, nil)
    -- self.btn_speed:setContentSize(150, 70)
    self.btn_speed:setPosition(x, y)
    self.btn_speed:setScale(scale)
    self.btn_speed:registerScriptTapHandler(handler(self, self.onChangeSpeed))
    self.menu_scene:addChild(self.btn_speed)
    self.callback_speed = handler(self, self.changeSpeedCallback)
    self:updateBattleSpeed()
end

function LuaBattleLayer:removeSpeedBtn()
    if self.btn_speed then
        self.btn_speed:removeFromParent()
        self.btn_speed = nil
    end
end

function LuaBattleLayer:initSkipBtn()
    local win_size = cc.Director:getInstance():getWinSize()
    -- 跳过战斗
    self.btn_skip = cpp.UIMenuItemImage:createWithSpriteFrameName("battle-scene/btn-speed-11.png", nil, nil)
    -- self.btn_skip:setContentSize(150, 70)
    self.btn_skip:setPosition(self.btn_speed:getPositionX(), self.btn_speed:getPositionY() - 110)
    self.btn_skip:registerScriptTapHandler(handler(self, self.onSkipBattle))
    self.menu_scene:addChild(self.btn_skip)

    -- local spr_bg = cc.Sprite:createWithSpriteFrameName("battle-scene/spr-bg-1.png")
    -- spr_bg:setPosition(95, 35);
    -- self.btn_skip:addChild(spr_bg)

    -- local spr_speed = cc.Sprite:createWithSpriteFrameName("battle-scene/btn-speed-11.png")
    -- -- spr_speed:setPosition(37, 35);
    -- spr_speed:setPosition(0, 0);
    -- self.btn_skip:addChild(spr_speed)

    -- self.lbl_skip = cc.Label:createWithTTF(ex.Tools:getLang(47647), FONT_DEFAULT_NAME_BOLD, 30)
    -- self.lbl_skip:setAnchorPoint(0, 0.5)
    -- self.lbl_skip:setPosition(76, 35)
    -- self.lbl_skip:enableOutline(FONT_RED, 1)
    -- self.btn_skip:addChild(self.lbl_skip)

    self.callback_skip = handler(self, self.skipBattleCallback)
end

function LuaBattleLayer:isInVisible(node)
    if not node then
        return true
    end

    local visible = node:isVisible()
    if not visible then
        return false
    end

    local parent = node:getParent()
    if parent and (not parent:isVisible())  then
        return false
    end

    return self:isInVisible(parent)
end

function LuaBattleLayer:onTouchBegan(touch, event)
    return self:isInVisible(self)
end

function LuaBattleLayer:onTouchMoved(touch, event)

end

function LuaBattleLayer:onTouchEnded(touch, event)

end

function LuaBattleLayer:onBattleEvent(event, params1, params2, params3, params4)
	if self[event] then
		return self[event](self, params1, params2, params3, params4)
	end
end


function LuaBattleLayer:getHeroPositionLua(team, index)
	-- 左右
    local bg_size = self:getMapSizeLua();
    
    --    bg_size.width = MIN(Director::getInstance()->getWinSize().width, bg_size.width);
    bg_size.height = bg_size.height * 0.7;
    
    local coe_x = team == 1 and -1 or 1;
    -- 列间隔
    local index_x = index < 2 and 0 or bg_size.width * 0.2;
    
    -- 第一列距离地图中间的长度
    local offset_x = bg_size.width * 0.15;
    local x = bg_size.width * 0.5 + offset_x * coe_x + index_x * coe_x;
    
    local num_y = index < 2 and 2 or 4;
    local index_y = index < 2 and index or index - 2;
    
    -- 英雄上下距离..总占据距离
    local offset_y = index < 2 and bg_size.height * 0.4 or bg_size.height * 0.8
    local y = bg_size.height * 0.5 - offset_y * 0.5 + (index_y + 0.5) * (offset_y / num_y);
    
    local pos = {
        x = x,
        y = y
    }
    -- pos.x = x + self:getMapPosLua().x
    -- pos.y = y + self:getMapPosLua().y
    return json.encode(pos)
end

function LuaBattleLayer:battleEndLua()
    -- if self.scheduler_wait_reward == nil then
    --     local scheduler = cc.Director:getInstance():getScheduler()
    --     self.scheduler_wait_reward = scheduler:scheduleScriptFunc(handler(self, self.battleEndLua), 5, false)   
    -- end
    print("LuaBattleLayer:battleEndLua", self:isWin(1))

    if self.is_callback_end then
        return
    end
    self.is_callback_end = true

	if self.callback_end then
        self:stopUpdate()

        -- 跳过战斗时。不延时删除界面
        if self.is_skip == true then
            self.callback_end(self:isWin(1), self)
        else

            local is_win = self:isWin(1)
            print("LuaBattleLayer:battleEndLua", is_win)
            -- 延时删除界面
            local self_p = self
            local delay_end = function()
                self_p.callback_end(self_p:isWin(1), self_p)
            end

            local delay = cc.DelayTime:create(1.5)
            local sequence = cc.Sequence:create(delay, cc.CallFunc:create(delay_end))
            self:runAction(sequence)
        end
	else
		self:remove()
	end
end

function LuaBattleLayer:setBattleEndCallback(callback)
	self.callback_end = callback
end


function LuaBattleLayer:remove()
	-- self.skill_system:release()
    self:stopUpdate()

    self:setVisible(false)
    local delay = cc.DelayTime:create(0.1)
    local sequence = cc.Sequence:create(delay, cc.RemoveSelf:create())
	self:runAction(sequence);
end


function LuaBattleLayer:setBattleBg(file)
    if self.node_bg then
        self.node_bg:removeFromParent()
        self.node_bg = nil
    end

    local win_size = cc.Director:getInstance():getWinSize()
    
    local spr_bg = cc.Sprite:create(file)
    if not spr_bg then
        spr_bg = cc.Sprite:createWithSpriteFrameName(file)
    end

    if not spr_bg then
        print("file not found", file)
        spr_bg = cc.Sprite:create()
    end
    
    spr_bg:setScale((win_size.width + 10) / spr_bg:getContentSize().width, win_size.height / spr_bg:getContentSize().height)
    spr_bg:setPosition(win_size.width * 0.5, win_size.height * 0.5)
    -- self:addChild(spr_bg, -1)

    self.node_bg = cc.Node:create()
    self.node_bg:setPosition(0, 0)
    self:addChild(self.node_bg, -1)
    self.node_bg:addChild(spr_bg)
    
    self:setNodeBgLua(self.node_bg)
    -- self:addChild(cc.LayerColor:create(FONT_BLACK_C4B, win_size.width, win_size.height), -1)
end

function LuaBattleLayer:getAllHeroHp()
    local vec_hero = {}
    
    local vec_team1 = self:getBattleRoleListByTeam(1)
    local vec_team2 = self:getBattleRoleListByTeam(2)
    vec_team1 = json.decode(vec_team1)
    vec_team2 = json.decode(vec_team2)

    local vec_team = TableEx.mergeTables(vec_team1, vec_team2)
    for k,v in pairs(vec_team) do
        local battle_role = self:getBattleRole(v)
        if battle_role then
            local heros = battle_role:getBattleHeroList()
            heros = json.decode(heros)

            if heros then
                 for j,v1 in pairs(heros) do
                    local hero = self:getBattleHeroByHeroID(v1)
                    if hero then
                        local data = {}
                        data.hero_id = tonumber(v1)
                        data.hp = hero:getHp()
                        data.hp_max = hero:getHpMaxBase()
                        table.insert(vec_hero, data)
                    end
                end
            end
        end
    end

    return vec_hero
end

function LuaBattleLayer:getHeroHpByTeam(team)
    local vec_hero = {}
    
    local vec_team1 = self:getBattleRoleListByTeam(team)
    local vec_team = json.decode(vec_team1)
    for k,v in pairs(vec_team) do
        local battle_role = self:getBattleRole(v)
        if battle_role then
            local heros = battle_role:getBattleHeroList()
            heros = json.decode(heros)

            if heros then
                 for j,v1 in pairs(heros) do
                    local hero = self:getBattleHeroByHeroID(v1)
                    if hero then
                        local data = {}
                        data.hero_id = v1
                        data.hp = hero:getHp()
                        data.hp_max = hero:getHpMax()
                        table.insert(vec_hero, data)
                    end
                end
            end
        end
    end

    return vec_hero
end

function LuaBattleLayer:heroActionEndLua()

    local total_round = self:getTotalRound() + 1
    self.lbl_round:setString(string.format("%d", total_round))

    if self.updateRound then
        self:updateRound()
    end

    if total_round >= self.total_round then
        -- battleEnd 函数有问题。。在当前函数调不到C++中的battleEnd，其他所有函数都能调用。但是在其他地方能调用。原因未知
        -- self:battleEnd()
        self:roundBattleEnd()
    end
end

function LuaBattleLayer:heroDeathLua(hero_id)

end

function LuaBattleLayer:showBattleStartAmin()
    local win_size = cc.Director:getInstance():getWinSize()
    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_battle_start")
    spr_effect:setPosition(win_size.width * 0.5, win_size.height * 0.6)
    spr_effect:setScale(1)
    self:addChild(spr_effect, 0, 10)
end

function LuaBattleLayer:battleStartAuto()
    self:battleStart()
    
    -- 判断模式
    local is_run_action = self.skill_system:isRunAction()
    if is_run_action then
        self:startUpdate()
    else
        self:skipBattle()
    end
    --self:startUpdate()
end

-- 跳过战斗过程。直接获得战斗结果
function LuaBattleLayer:skipBattle()

    self.is_skip = true
    if self:isBattleEnd() then
        return
    end
    -- print("skipBattle")
    self:stopUpdate()

    local is_visible = self:isVisible()

    self:setVisible(false)
    while true do
        self:updateBattleLua(0.017)
        if self:isBattleEnd() then
            break
        end
    end

    if self:getBattleStatuTypeLua() ~= BattleStatuType.BST_END then
        self:battleEnd()
    end
    
    self:setVisible(is_visible)
end

function LuaBattleLayer:delayBattleStart(delay_time, is_skip, is_show_start_amin)
    -- self:battleStartLua()
    is_show_start_amin = is_show_start_amin == nil and true or is_show_start_amin
    
    if is_skip then
        self.is_skip = true
        self:setVisible(false)
        self:stopActionByTag(1000)
        self:setRunAction(false)
        self:battleStart()
        self:skipBattle()
    else
        self:stopActionByTag(1000)

        if is_show_start_amin then
            self:showBattleStartAmin()
        end
        
        local act_start = cc.Sequence:create(cc.DelayTime:create(delay_time), cc.CallFunc:create(handler(self, self.battleStartAuto)))
        act_start:setTag(1000)
        self:runAction(act_start)
    end
end

function LuaBattleLayer:onChangeSpeed(tag, pSender)
    local speed = ((self.speed + 1) % 3)
    if self.callback_speed(speed) then
        self.speed = speed
        self:updateBattleSpeed()
        cc.UserDefault:getInstance():setIntegerForKey(string.format("%s-battle_speed", ex.Player.role_id), self.speed)
    end
end

function LuaBattleLayer:updateBattleSpeed()
    self:setTimeScaleLua((self.speed * 0.3) + 1.3)
    ex.Tools:setSpriteFrame(self.btn_speed:getNormalImage(), string.format("battle-scene/btn-speed-%d.png", self.speed + 1))
    -- self.lbl_speed:setString(string.format("x%d", self.speed + 1))
end

function LuaBattleLayer:onSkipBattle(tag, pSender)
    if self.callback_skip() then
        self:setRunAction(false)
        self:skipBattle()
    end
end

function LuaBattleLayer:setChangeSpeedCallback(callback)
    self.callback_speed = callback
end

function LuaBattleLayer:setSkipBattleCallback(callback)
    self.callback_skip = callback
end

function LuaBattleLayer:changeSpeedCallback(speed)
    speed = speed + 1
    -- print("speed", speed)
    if speed <= 1 then
        return true
    end

    local key = "battle_speed_" .. speed .. "x"
    local config_vip = ex.Player.fetter_data:getSpeedConfig(key)
     if config_vip ~= nil then
        if config_vip.vip_level > ex.Player.fetter_data.vip.vip_level then
            ex.MessageView:add(string.format(ex.Tools:getLang(47518), config_vip.vip_level))
        else
            return true
        end
    end

    return false
end

function LuaBattleLayer:skipBattleCallback()
    -- local config_vip = ex.Player.shop_data:getVipStatus("battle_skip", 0)
    -- if ex.Player.vip_level >= config_vip.vip_level then
    --     return true
    -- end

    local need_level = ex.Tools:getSysCfg("battle_skip_level")
    if  ex.Player.level >= need_level then
        return true
    end
    ex.MessageView:add(string.format(ex.Tools:getLang(41037), config_vip.vip_level, need_level))
    return false
end

function LuaBattleLayer:addSkillRes(skill_type)
    local sfc = cc.SpriteFrameCache:getInstance()
    local config = cfg.heroskill.heroskill[skill_type]
    if config and config.file ~= "" then
        for k,v in pairs(config.file) do

            local file_plist = "skill/" .. v .. ".plist"

            -- createLuaAnimateWithDuration
            -- sfc:addSpriteFrames(file_plist)

            local action = cpp.ActionFactory:createLuaAnimate(file_plist,
                                                              "skill-" .. v .. "/%d.png", 0.06);

            cpp.Game:preloadEffect("music/skill-" .. v .. ".mp3")
        end
    end
end



function LuaBattleLayer:getHaloList()
    local vec_halo_data = {}

    -- 双方阵营
    local vec_team1 = self:getBattleRoleListByTeam(1)
    local vec_team2 = self:getBattleRoleListByTeam(2)
    vec_team1 = json.decode(vec_team1)
    vec_team2 = json.decode(vec_team2)
    local vec_team = TableEx.mergeTables(vec_team1, vec_team2)
    for k,v in pairs(vec_team) do
        -- 遍历对战双方
        local battle_role = self:getBattleRole(v)
        local team = self:getTeamByRoleID(v)
        if battle_role then

            -- 遍历英雄
            local heros = battle_role:getBattleHeroList()
            heros = json.decode(heros)
            heros = heros or {}

            -- 元素类型列表
            local vec_type = {}
            for j,v1 in pairs(heros) do
                local battle_hero = self:getBattleHeroByHeroID(v1)
                if battle_hero then
                    table.insert(vec_type, battle_hero:getType())
                end
            end

            -- 光环类型列表
            local vec_idx = ex.Player.battle_data:getBattleHaloIdx(vec_type)

            local length = table.nums(vec_idx)

            -- 光环图标
            local icon
            if length > 0 then 
                local k,v = next(vec_idx)
                icon = cfg.battlehalo.battlehalo[v].icon
            else
                icon = 10000
            end

            -- 光环所有数据
            local data = {}
            data.vec_type = vec_type
            data.vec_idx = vec_idx
            data.icon = icon

            table.insert(vec_halo_data, data)
        end
    end

    return vec_halo_data
end

function LuaBattleLayer:addHaloBtn(y)

    if not self.menu_scene then
        self:initMenuScene()
    end

    y = y or ex.MainSceneCtr:getMenuScaleHeight() + 40

    -- 添加光环显示
    local button_size = 80
    local offset_width = ex.p.width - button_size * 2

    local vec_halo_data = self:getHaloList()

    -- dump(vec_halo_data, "vec_halo_data")

    for i,v in ipairs(vec_halo_data) do
        local file = string.format("hero-icon/elem-%d.png", v.icon)
        local btn_halo = cpp.UIMenuItemImage:createWithSpriteFrameName(file, nil, nil)
        btn_halo.data = clone(v.vec_type) 
        btn_halo:setPosition(cc.p(offset_width * (i - 1) + button_size, y))
        btn_halo:registerScriptTapHandler(handler(self, self.onHalo))
        self["btn_halo"..i] = btn_halo
        self.menu_scene:addChild(btn_halo)
    end
end

function LuaBattleLayer:removeHaloBtn()
    for i=1,2 do
        if self["btn_halo"..i] then
            self["btn_halo"..i]:removeFromParent()
            self["btn_halo"..i] = nil
        end
    end
end

function LuaBattleLayer:initHeroData(data)
    local artifact_list = data.artifact_list or {}
    -- 初始化数据

    -- 方便查找神器数据
    local getArtifact = function(role_id)
        for k,v in pairs(artifact_list) do
            if v.role_id == role_id then
                return v
            end
        end
    end

    -- 数据生成
    for k1,team in ipairs(data) do

        local battle_role = self:addBattleRold(team.role_id, team.team)

        -- 获得光环属性加成
        local vec_halo = ex.Player.battle_data:getBattleHalo(team.hero_list)

        -- 获得工会属性加成
        local vec_clan_ability = data.clan_skill[team.role_id] and ex.Player.clan_data:getSkillAbilityNumByList(data.clan_skill[team.role_id]) or {}

        -- 获得神器属性加成
        local vec_artifact_attr = ex.Player.fetter_data:getHeroAbility(getArtifact(team.role_id))

        for i,v in ipairs(team.hero_list) do
            local hero_type = v.hero_type or v.type
            local hero_type_config = cfg.herotype.star[hero_type]
            if not hero_type_config then
                print("LuaBattleLayer:initHeroData hero_type", hero_type, "not found")
            end


            if hero_type_config then

                -- 属性的额外加成。值容错。使用hero_level 或 level
                local level = v.hero_level or v.level
                local star = v.hero_star or v.star
                local atk_multiple = v.atk_multiple or 100
                local hp_multiple = v.hp_multiple or 100

                atk_multiple = atk_multiple / 100
                hp_multiple = hp_multiple / 100
                
                local hero_id = v.hero_id or cpp.Game:makeLuaId()

                -- dump(v, "hero_data")

                -- 根据等级获得阶级
                local hero_stage = v.stage or ex.Player.hero_data:getHeroStageByLevel(level)
                local hero_attr = nil

                hero_attr = ex.Player.hero_data:getHeroAttribute(hero_type,
                                                                 hero_stage,
                                                                 star,
                                                                 level)

                -- 本身属性。如果传进来的有具体数值。则使用具体数值。。否则使用getHeroAttribute计算出来的数值
                local hp = v.hp or hero_attr.hp
                local atk = v.atk or hero_attr.atk
                local def = v.def or hero_attr.def
                local spd = v.spd or hero_attr.spd
                local anger = v.anger or 50
                
                -- 显示的形象
                local skin = ex.Tools:getHeroSkinByStar(hero_type, star)

                -- 普通攻击
                local attack_skill_level = 1
                local attack_skill = ex.Player.hero_data:getHeroSkill(hero_type, 2) or 0

                -- 主动技能
                local active_skill_level = ex.Player.hero_data:getHeroSkillLevel(hero_stage, star, 1, hero_type)
                local active_skill = active_skill_level > 0 and ex.Player.hero_data:getHeroSkill(hero_type, 1) or 0
                active_skill = active_skill or 0

                self:addSkillRes(attack_skill)
                self:addSkillRes(active_skill)

                local battle_hero = self:addBattleHero(battle_role:getRoleID(),
                                                       hero_id,
                                                       level,
                                                       i - 1,
                                                       hero_type,
                                                       hero_type_config.occupation,
                                                       hero_type_config.elem,
                                                       hero_type_config.elem,
                                                       hp,
                                                       hp_multiple,
                                                       0,
                                                       atk,
                                                       atk_multiple,
                                                       def,
                                                       1,
                                                       spd,
                                                       anger,
                                                       attack_skill,
                                                       attack_skill_level,
                                                       active_skill,
                                                       active_skill_level,
                                                       skin,
                                                       self:getNodeHeroLua())
                
                -- 添加被动技能
                for skill_i = 2, 4 do
                    local skill_level = ex.Player.hero_data:getHeroSkillLevel(hero_stage, star, skill_i, hero_type)
                    if skill_level > 0 then
                        local skill_type = hero_type_config["skill_" .. skill_i]
                        if skill_type and skill_type ~= 0 then
                            battle_hero:addSkill(cpp.Game:makeLuaId(), skill_type, skill_level, true)
                        end
                    end
                end

                -- 显示等级和元素
                -- local hero = battle_hero:getHero()
                -- if hero then
                -- end

                -- 阵型光环生效
                for h,hv in pairs(vec_halo) do
                    battle_hero:addAbility(h, hv)
                end

                -- 公会科技生效
                local vec_ability = vec_clan_ability[hero_type_config.occupation]
                if vec_ability then
                    for h,hv in pairs(vec_ability) do
                        battle_hero:addAbility(h, hv)
                    end
                end

                -- 队伍属性生效
                local vec_team_attr = data.vec_team_attr and data.vec_team_attr[team.team] or {}
                vec_team_attr = vec_team_attr or {}

                for h,hv in pairs(vec_team_attr) do
                    battle_hero:addAbility(h, hv)
                end

                -- 神器英雄增益
                for h,hv in pairs(vec_artifact_attr) do
                    -- print(h, hv)
                    battle_hero:addAbility(h, hv)
                end                
            end
        end
    end

    -- 神器技能
    for k,v in pairs(artifact_list) do
        local role_id = v.role_id or "0"
        local team = self:getTeamByRoleID(role_id)
        local battle_role = self:getBattleRoleByRoleID(role_id)

        local active_skill = 0
        if cfg.goddessskill.goddessskill[v.type] then
            active_skill = cfg.goddessskill.goddessskill[v.type].skill
        end

        if battle_role then
            -- 计算神器攻击力
            -- 技能等级攻击力
            local skill_atk = 1
            local config_level = ex.Player.fetter_data:getSkillLevelConfig(v.type, math.max(v.skill_level or 1, 1))
            if config_level then
                skill_atk = config_level.skill_atk
            end

            -- 精炼等级攻击力
            local config_refine = ex.Player.fetter_data:getSkillRefineConfig(v.type, v.refine_level)
            if config_refine then
                skill_atk = skill_atk + config_refine.skill_atk
            end

            local battle_hero = self:addBattleHero(battle_role:getRoleID(),
                                                   battle_role:getRoleID(),
                                                   1, --level,
                                                   10,
                                                   v.type,
                                                   0,
                                                   0,
                                                   0,
                                                   0,
                                                   0,
                                                   0,
                                                   skill_atk,
                                                   1,
                                                   0,
                                                   1,
                                                   9999,
                                                   0, -- 150, 
                                                   0,
                                                   0,
                                                   active_skill,
                                                   math.max(v.skill_level or 1, 1),
                                                   0,
                                                   nil)
            battle_hero:setArtifact(true)

            -- 神器无视防御和眩晕抵抗
            battle_hero:addAbility(AbilityType.AT_EXEMPTION_PETRIFY, 1)
            battle_hero:addAbility(AbilityType.AT_DEFENSE_IGNORE, 1)

            -- 添加UI
            self:addSkillRes(active_skill)

            -- 添加动画资源
            self:addArtifactUI(team, v.type, data.artifact_y)
            self:artifactActionEndLua(battle_role:getRoleID())
        end
    end

    -- 读取装备属性
    local HeroAbilityData = require("src.data.HeroAbilityData")
    local hero_equip_list = data.equip_list or {}
    for i,v in ipairs(hero_equip_list) do
        local battle_hero = self:getBattleHeroByHeroID(v.hero_id)
        if battle_hero then
            local vec_ability = HeroAbilityData.getEquipAbility(v.equip_list)
            for key,value in pairs(vec_ability) do
                battle_hero:addAbility(key, value)
            end
        end
    end

    -- 读取符文属性
    local runes_list = data.runes_list or {}
    for i,v in ipairs(runes_list) do
        local battle_hero = self:getBattleHeroByHeroID(v.hero_id)
        if battle_hero then
            local runes_ability = ex.Player.runes_data:getAbilityByList(v.runes_list)

            for key,value in pairs(runes_ability.vec_ability) do
                -- print("runes_list", key, value)
                battle_hero:addAbility(key, value)
            end

            -- 添加符文被动
            for k,skill_type in pairs(runes_ability.vec_skill) do
                -- print("skill_type", skill_type)
                battle_hero:addSkill(cpp.Game:makeLuaId(), skill_type, 1, true)
            end

            -- local vec_ability = HeroAbilityData.getEquipAbility(v.equip_list)
            -- for key, value in pairs(vec_ability) do
            --     battle_hero:addAbility(key, value)
            -- end
        end

    end
    
    -- [{hero_id:"1", runes_list = [{type=150020003, ability_id=101, skill1, skill2}, {type, ability_id, skill1, skill2}]}


    for i,v in ipairs(hero_equip_list) do
        local battle_hero = self:getBattleHeroByHeroID(v.hero_id)
        if battle_hero then
            local vec_ability = HeroAbilityData.getEquipAbility(v.equip_list)
            for key,value in pairs(vec_ability) do
                battle_hero:addAbility(key, value)
            end
        end
    end

    -- 被动生效
    self:effectPassive()

    -- 修改属性 修改英雄的剩余血量
    for k1,team in ipairs(data) do
        for i,v in ipairs(team.hero_list) do
            -- 判断当前英雄是否要设置到指定血量
            local hero_id = v.hero_id or nil
            local hp_left = v.hp_left or nil
            local hp_max = v.hp_max or nil

            if hero_id then
                local battle_hero = self:getBattleHeroByHeroID(hero_id)
                if battle_hero then

                    -- 更新一下血量显示
                    battle_hero:setHpMax(battle_hero:getHpMaxBase())
                    battle_hero:setHp(battle_hero:getHpMaxBase())

                    local hero = battle_hero:getHero()
                    if hero then
                        hero:setHpMax(battle_hero:getHpMaxBase())
                        hero:setHp(battle_hero:getHpMaxBase())
                    end

                    -- 血量最大值
                   if hp_max then
                        battle_hero:setHpMax(hp_max)
                        if hero then
                            hero:setHpMax(battle_hero:getHpMax())
                        end
                    end
                    
                    -- 剩余血量
                    if hp_left then
                        battle_hero:setHp(hp_left)
                        if hero then
                            hero:setHp(battle_hero:getHp())
                            -- print("hero:showHP", hero.showHP)
                            hero:showHP()
                        end
                    end


                    print("battle_hero.hp5", battle_hero:getHpMaxBase())
                end
            end
        end
    end

    if not data.halo_y or data.halo_y > -100 then
        self:addHaloBtn(data.halo_y)
    end
end

function LuaBattleLayer:getAbilityByList(vec_runes)
	local runes_ability = {}

	runes_ability.vec_skill = {}

	local vec_ability = {}

	for k,v in pairs(vec_runes) do
		local runes_cfg = cfg.runestype.runestype[v.item_type]
		repeat
			if not runes_cfg then
				break
			end

			local ability = ex.Player.backpack_data:getRunesAbilityConfig(runes_cfg.rare, v.ability_id)
			if not ability then
				break
			end

			vec_ability[ability.attr] = vec_ability[ability.attr] and (vec_ability[ability.attr] + ability.value) or ability.value

			if v.skill[1] ~= nil and v.skill[1].skill_id > 0 then
				table.insert(runes_ability.vec_skill, v.skill[1].skill_id)
			end

			if v.skill[2] ~= nil and v.skill[2].skill_id > 0 then
				table.insert(runes_ability.vec_skill, v.skill[2].skill_id)
			end
        until true
	end

	runes_ability.vec_ability = vec_ability

	return runes_ability
end

function LuaBattleLayer:addArtifactUI(team, type, y)

    y = y or ex.p.height * 0.8

    if not self.node_artifact then
        self.node_artifact = cc.Node:create()
        self:addChild(self.node_artifact)
    end

    -- 神器显示
    local artifact_size = 80
    local offset_width = ex.p.width - artifact_size * 2

    -- 骨骼动画
    local spine = sp.SkeletonAnimation:create("spine/".. type ..".json","spine/".. type ..".atlas", 1)
    spine:setAnimation(0, "stand", true);
    spine:setScale(0.4)
    spine:setPosition(offset_width * (team - 1) + artifact_size, y + 10)
    self.node_artifact:addChild(spine, 10)

    -- 进度条背景
    local prog_bg = cc.Sprite:createWithSpriteFrameName("battle-scene/prog-bg-1.png")
    -- prog_bg:setScale(top_scale)
    prog_bg:setPosition(offset_width * (team - 1) + artifact_size, y - 25)
    self.node_artifact:addChild(prog_bg, 19)

    -- 进度条
    local prog_artifact = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("battle-scene/prog-1.png"))
    prog_artifact:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    prog_artifact:setMidpoint(cc.p(0, 0.5))
    prog_artifact:setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    prog_artifact:setPosition(prog_bg:getPositionX(), prog_bg:getPositionY())
    prog_artifact:setScale(prog_bg:getScale())
    prog_artifact:setPercentage(0)
    self.node_artifact:addChild(prog_artifact, 19)
    self["prog_artifact"..team] = prog_artifact

    -- 进度条花纹
    local prog_frame = cc.Sprite:createWithSpriteFrameName("battle-scene/prog-frame-1.png")
    -- prog_bg:setScale(top_scale)
    prog_frame:setPosition(prog_bg:getPosition())
    self.node_artifact:addChild(prog_frame, 19)

    -- 添加神器进度
    local lbl_artifact_round = cc.Label:createWithTTF("0/4", FONT_DEFAULT_NAME_BOLD, 50)
    lbl_artifact_round:setScale(0.5)
    lbl_artifact_round:setPosition(prog_bg:getPosition())
    lbl_artifact_round:enableOutline(FONT_BLACK_C4B, 3)
    lbl_artifact_round:setVisible(false)
    self.node_artifact:addChild(lbl_artifact_round, 19)
    self["lbl_artifact_round"..team] = lbl_artifact_round

    -- 添加神器形象
end

function LuaBattleLayer:removeArtifactUI()
    if self.node_artifact then
        self.node_artifact:removeFromParent()
        self.node_artifact = nil
    end
end


function LuaBattleLayer:artifactSkillLua(artifact_id)

    if self.is_skip == true then
        return
    end
    
    local team = self:getTeamByRoleID(artifact_id)
    local battle_hero = self:getBattleHeroByHeroID(artifact_id)
    if self["lbl_artifact_round"..team] then
        self["lbl_artifact_round"..team]:setString("0/3")
        self["prog_artifact"..team]:setPercentage(0)
    end

    self:showFetterAnim(battle_hero:getType())

    if self:isInVisible(self) then
        ex.AudioManager:playEffect("music/goddessactivate.mp3")
        ex.AudioManager:playEffect("music/fetter-".. battle_hero:getType() .. ".mp3")
    end

end

function LuaBattleLayer:artifactActionEndLua(artifact_id)
    local team = self:getTeamByRoleID(artifact_id)
    local battle_hero = self:getBattleHeroByHeroID(artifact_id)
    if self["lbl_artifact_round"..team] and battle_hero then
        self["lbl_artifact_round"..team]:setString(string.format("%d/3", battle_hero:getAnger() / 50))
        -- print("artifactActionEndLua", 100 * (battle_hero:getAnger() / 50 / 3), battle_hero:getAnger())
        self["prog_artifact"..team]:setPercentage(100 * (battle_hero:getAnger() / 50 / 3))
    end
end

-- 播放神器技能特效
function LuaBattleLayer:showFetterAnim(type)
    local layer = cc.Layer:create()

    local time_scale = 1.0 / self:getTimeScaleLua()
    local bg = cc.LayerColor:create(cc.c4b(0,0,0,0), ex.p.width, ex.p.height)
    bg:runAction(cc.FadeTo:create(0.1 * time_scale, 170))
    bg:runAction(cc.Sequence:create(cc.DelayTime:create(1.3 * time_scale), cc.FadeTo:create(0.1 * time_scale, 0)))
    layer:addChild(bg)

    local eff2 = ex.EffectCtr:playNormalEff(12, ex.p.width * 0.5, ex.p.height * 0.6, nil, layer, 10, nil, nil, nil, time_scale)
    local scale = ex.p.width / (eff2.anim:getContentSize().width + 80)
    eff2:setScale(scale)

    local spine = sp.SkeletonAnimation:create("spine/".. type ..".json","spine/".. type ..".atlas", 1)
    spine:setAnimation(0, "stand", true);
    spine:setScale(1.1)
    spine:setPosition(-200, ex.p.height * 0.55)
    spine:runAction(cc.EaseExponentialOut:create(cc.MoveTo:create(0.3 * time_scale, cc.p(ex.p.width * 0.3, ex.p.height * 0.5))))
    layer:addChild(spine, 10)

    -- eff2 = ex.EffectCtr:playNormalEff(13, ex.p.width * 0.5, ex.p.height * 0.6, nil, layer, 11, nil, nil, nil, time_scale)
    -- eff2:setScale(scale)
    -- eff2.anim:setOpacity(200)
    
    spine:runAction(cc.Sequence:create(cc.DelayTime:create(1.5 * time_scale), cc.EaseExponentialOut:create(cc.MoveTo:create(0.3 * time_scale,cc.p(-400, ex.p.height * 0.5)))))
    layer:runAction(cc.Sequence:create(cc.DelayTime:create(4 * time_scale), cc.RemoveSelf:create()))
    self:addChild(layer, 999)
end

function LuaBattleLayer:onHalo(tag, pSender)
    require("src.layer.HaloCtr"):instance():openWindow(clone(pSender.data))
end

return LuaBattleLayer
