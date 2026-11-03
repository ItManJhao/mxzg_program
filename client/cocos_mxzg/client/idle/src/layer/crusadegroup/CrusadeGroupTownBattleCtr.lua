--[[
    讨伐团城镇战斗界面
    在讨伐团场景调用
]]
local CrusadeGroupTownBattleCtr = class("CrusadeGroupTownBattleCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CrusadeGroupTownBattleLayer = class("CrusadeGroupTownBattleLayer", require("src.comp.EventLayerAdaptiveWidth"))
local ExTimer = require("src.ex.ExTimer")
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

-----------------------------------------------------------------------------
function CrusadeGroupTownBattleLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    -- 恢復提示
    self.lbl_recover_tip = require("src.comp.RichTextEx"):create()
	:setFontSize(40)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FFFFFF")
    :setScale(0.5)
    :setAnchorPoint(0.5, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(0, 0)
    self.node_recover_tip:addChild(self.lbl_recover_tip, 10001)
    self.protectTime:setString("")
end

function CrusadeGroupTownBattleLayer:setRecoverTip(time)
    if time <= 0 then
        self.node_recover_tip:setVisible(false)
    else
        self.node_recover_tip:setVisible(true)
        self.lbl_recover_tip:setXmlTextLua(string.format(ex.Tools:getLang(77430), ex.StringUtil.convertToTimeFormat(time - ex.Game:getServerTime(), 4)))
        self.lbl_recover_tip:formatText()
    end
end

-- 设置地块基础信息
function CrusadeGroupTownBattleLayer:setBlockInfo(config_build)
    if config_build == nil then
        return
    end

    ex.Tools:setSpriteFrame(self.spr_banner, config_build.building_banner)
    self.lbl_title:setString(ex.Tools:getLang(config_build.name))
    self.lbl_speed:setString(string.format(ex.Tools:getLang(77714), config_build.cream_output * 10))
    
    local rare_color = {{outline = cc.c4b(16,62,10,255), color = cc.c3b(151,221,124)},
                        {outline = cc.c3b(10,50,62,255), color = cc.c3b(124,204,221)},
                        {outline = cc.c3b(79,22,120,255), color = cc.c3b(211,124,221)},
                        {outline = cc.c3b(120,56,22,255), color = cc.c3b(233,200,68)},
                        {outline = cc.c3b(93,16,16,255), color = cc.c3b(239,110,110)},}
    self.lbl_rare:setString(string.format(ex.Tools:getLang(77761), ex.Tools:getLang(config_build.shenbing_des)))
    self.lbl_rare:setTextColor(rare_color[config_build.shenbing_rank].color)
    self.lbl_rare:enableOutline(rare_color[config_build.shenbing_rank].outline, 4)
end

function CrusadeGroupTownBattleLayer:setMarkon(is_show, element, star, markon)
    self.node_markon:setVisible(is_show)
    if is_show then
        ex.Tools:setSpriteFrame(self.spr_elem, "hero-icon/elem-"..element..".png")
        self.lbl_des_3:setString(string.format(ex.Tools:getLang(77742), ex.Tools:getLang(2115 + element), star, markon))
    end
end

-- 设置英雄列表tab
function CrusadeGroupTownBattleLayer:setHeroListTab(cur_num, total_num, handler)
    self.menu_tab:removeAllChildren()

    if cur_num <= 0 or total_num <= 0 then
        return
    end

    -- 创建tab按钮
    for i=1,total_num do
        local item = cpp.UIMenuItemTab:create("button/btn-tab-23.png", "button/btn-tab-24.png", "", 1, 1)
        item:registerScriptTapHandler(handler)
        item:setAnchorPoint(ex.a.bottom_center)
        item:setPosition((i - 0.5) * 120, 0)
        self.menu_tab:addChild(item)
        item:setLabelText(string.format(ex.Tools:getLang(77744), i))
        item:setLabelColor(FONT_BROWN)
        item:setLabelOffset(cc.p(0, -2))

        item:setTag(i)

        item:setChecked(i == cur_num)
    end
end

-- 设置英雄列表
function CrusadeGroupTownBattleLayer:setHeroList(hero_info, hard)
    self.menu_hero_list:removeAllChildren()

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/crusade-group.plist")

    if hero_info == nil then
        self.lbl_battle_count:setString(0)
        return
    end

    self.lbl_battle_count:setString(hero_info.fighting)

    local vec_color = {cc.c3b(151,221,124), cc.c3b(233,200,68), cc.c3b(239,110,110)}
    local vec_outline = {cc.c3b(16,62,10), cc.c3b(120,56,22), cc.c3b(93,16,16)}
    if hard == 2 then
        self.lbl_hard:setString(ex.Tools:getLang(77716))
        self.lbl_hard:setColor(vec_color[2])
        self.lbl_hard:enableOutline(vec_outline[2], 4)
    elseif hard < 2 then
        self.lbl_hard:setString(ex.Tools:getLang(77715))
        self.lbl_hard:setColor(vec_color[1])
        self.lbl_hard:enableOutline(vec_outline[1], 4)
    else
        self.lbl_hard:setString(ex.Tools:getLang(77717))
        self.lbl_hard:setColor(vec_color[3])
        self.lbl_hard:enableOutline(vec_outline[3], 4)
    end

    -- 创建英雄按钮
    if hero_info.hero ~= nil and #hero_info.hero > 0 then
        local hero_num = #hero_info.hero
        local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
        item_size = cc.size(item_size.width + 15, item_size.height + 12)
        local item_scale = 0.75
        for i,v in ipairs(hero_info.hero) do
            local item = UIMenuItemHero:createWithData(v.hero_id, v.hero_type, nil, v.level, v.star)
            item:setScale(item_scale)
            -- item:registerScriptTapHandler(handler(self, self.onSelectIcon))
            item:setPosition((i - 0.5 - hero_num / 2) * (item_size.width * item_scale), 0)
            self.menu_hero_list:add(item)

            if v.hp <= 0 then
                item:setGray(false)
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
    end
end

-----------------------------------------------------------------------------
function CrusadeGroupTownBattleCtr:onCreate()
    self:setCCBIPath("ccbi/CrusadeGroupTownBattleLayer.ccbi")
    self:setIsSingle(false)
end

function CrusadeGroupTownBattleCtr:getLayerClass()
    return CrusadeGroupTownBattleLayer
end

function CrusadeGroupTownBattleCtr:openWindow(town_id, area_level, building_level, is_attack)
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/crusade-group.plist")

    self.town_id = town_id
    self.area_level = area_level
    self.building_level = building_level
    self.town_data = {formation = {}}
    self.guard_time = 0
    self.timer = nil

    self:loadLayer()
    self:open()
    self:initData(is_attack)
end

function CrusadeGroupTownBattleCtr:initData(is_attack)
    self.layer:addEvent(EVENT.CRUSADE_GROUP.UPDATE_TOWN_BATTLE_INFO, handler(self, self.receiveEvent))

    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_battle:registerScriptTapHandler(handler(self, self.onBattle))

    local config_build = cfg.crusadegroupbuild.getConfig(self.town_id)

    self.layer:setBlockInfo(config_build)
    self.layer:setHeroListTab(0, 0)

    self.layer.btn_battle:setVisible(is_attack == true)
    self.layer.lbl_hard:setVisible(is_attack == true)

    self.select_idx = 1
    self.cur_round = 1

    self:updateLayer()

    -- 请求城镇信息
    local req = CrusadeGroup_pb.GReqViewTerritory()
    req.territory_id = self.town_id
    NetManager:sendMessage(ProtocolID.GReqViewTerritory, req)
end

function CrusadeGroupTownBattleCtr:updateLayer()
    self.layer:setHeroList(self.town_data.formation[self.select_idx], self.town_data.evaluation)
end


function CrusadeGroupTownBattleCtr:closeWindow(  )
    if self.timer then
        self.guard_time = 0
        self.timer:stop()
        self.timer = nil
    end
    self:close()
end

function CrusadeGroupTownBattleCtr:changTimer()
    local nowTime = ex.Game:getServerTime()
    if (ex.Player.nick == self.town_data.challenger_name) then
        self.layer.protectTime:setString(string.format(ex.Tools:getLang(77961), ex.StringUtil.convertToTimeFormat(self.guard_time - nowTime)))
    else
        self.layer.protectTime:setString(self.town_data.challenger_name .. "  ".. string.format(ex.Tools:getLang(77961), ex.StringUtil.convertToTimeFormat(self.guard_time - nowTime)))
    end
	if self.guard_time <= nowTime then 
        self.timer:stop()
        self.timer = nil
        self.layer.protectTime:setString(" ")
        self.guard_time = 0
	end
end

function CrusadeGroupTownBattleCtr:receiveEvent(event, data)
    if self.layer == nil then
        return
    end

    self.town_data = data

    if self.town_data.territory_id ~= self.town_id then
        return
    end

    self.guard_time = self.town_data.guard_time
    local nowTime = ex.Game:getServerTime()
    if (self.guard_time > nowTime) then
        if not self.timer then
            self.timer = ExTimer:new():bind(self.layer):run(handler(self, self.changTimer), 1.0)
            self:changTimer()
        end
    else
        if self.timer then
            self.timer:stop()
            self.timer = nil
        end
    end
    
    if self.town_data.occupied then
        ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_MAP_CUR_PAGE)

        self:closeWindow()

        return
    end

    self.cur_round = 1
    for i,hero_info in ipairs(data.formation) do
        local is_check = false
        for _,hero_data in ipairs(hero_info.hero) do
            if hero_data.hp > 0 then
                self.cur_round = i
                is_check = true
                break
            end
        end
        if is_check then
            break
        end
    end
    self.select_idx = self.cur_round
    
    local config_build = cfg.crusadegroupbuild.getConfig(self.town_id) or {}
    
    self.layer:setRecoverTip(self.town_data.refresh_countdown or 0)
    self.layer:setHeroListTab(self.select_idx, #self.town_data.formation, handler(self, self.onTab))
    self.layer:setMarkon(config_build.defend_is > 0, 
                         self.town_data.element, 
                         config_build.defend_star, 
                         tonumber(ex.Tools:getSysCfg("production_increase_ratio")) * 100 - 100)

    self:updateLayer()
end

function CrusadeGroupTownBattleCtr:onTab(tag, pSender)
    if self.select_idx == tag then
        return
    end

    self.select_idx = tag

    self:updateLayer()
end

-- 战斗
function CrusadeGroupTownBattleCtr:onBattle(tag, pSender)
    if #self.town_data.formation <= 0 then
        return
    end

    local nowTime = ex.Game:getServerTime()
    if self.town_data.guard_time > nowTime then 
        if ex.Player.nick ~= self.town_data.challenger_name then
            ex.MessageView:add(ex.Tools:getLang(77962))
            return
        end
    end

    local config = cfg.crusadegroupbuild.getConfig(self.town_id) or {}
    require("src.layer.crusadegroup.CrusadeGroupHeroSelectCtr"):instance():openWindow(ex.Tools:getLang(47546),
                                                                                        config.battletype, 
                                                                                        handler(self, self.onBattleDone), 
                                                                                        nil, 
                                                                                        self.town_data.dead_hero_id,
                                                                                        config.cost_energy or 0)
end

function CrusadeGroupTownBattleCtr:onBattleDone()
    -- 请求战斗
    local req = CrusadeGroup_pb.GReqStartFighting()
    req.territory_id = self.town_id
    req.formation_id = self.town_data.formation[self.cur_round].formation_id
    NetManager:sendMessage(ProtocolID.GReqStartFighting, req)

    -- 关闭界面
    self:closeWindow()
end

return CrusadeGroupTownBattleCtr