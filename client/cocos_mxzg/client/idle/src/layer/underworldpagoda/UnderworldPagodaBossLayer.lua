local UnderworldPagodaBossLayer = class("UnderworldPagodaBossLayer", require("src.comp.EventLayer"))

local HadesType = {
    hades_type_1 = 1,   --赫卡忒地狱
    hades_type_2 = 2    --撒旦魔域
}

local HadesDegree = {
    simple = 1,         --简单
    difficulty = 2      --困难
}

function UnderworldPagodaBossLayer:onCreate()
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/underworld-pagoda-lang.plist")
    sfc:addSpriteFrames("ccbi-res/underworld-pagoda.plist")
    

    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    self.spr_dizuo:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)

    self.boss_type = 0                                                                  -- boss 类型
    self.skin = nil
    self.hades_degree = HadesDegree.simple                                              -- 難度
    self.floor = 1                                                                      -- 层数
    self.floor_idx = 1                                                                  -- 层数的唯一标签 idx
    self.hadestype = HadesType.hades_type_1                                             -- 地狱类型
    self.hedesinfo = ex.Player.underworld_pagoda_data["hadesInfo_type_"..self.hadestype]-- 当前地狱的数据
    self.max_tab = {}                                                                   -- 关卡数量
  
    self.btn_simple:setChecked(true)

    self.node_boss_name:setPositionY(self.node_boss_name:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.node_rank:setPosition(ex.p.width,self.node_rank:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.node_level:setPosition(0,self.node_boss_name:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    
    self.node_bottom:setScale(math.min(ex.s.global_scale))
    self.spr_bottom_bg:setContentSize(cc.size(ex.p.width, self.spr_bottom_bg:getContentSize().height * self.node_bottom:getScale()))

    -- 技能
    self.scroll_view_skill:setItemSize(cc.size(90, 90))
    self.scroll_view_skill:setAlignmentCenter(true)

    -- 关卡
    self.scroll_view_tab:setName("scroll_view_tab")
    -- self.scroll_view_tab:setResetOffset(true)
    self.scroll_view_tab:setItemSize(cc.size(85, 75))
    self.scroll_view_tab:setAlignmentCenter(true)
    self.scroll_view_tab:setBounceable(true)

    -- 首通奖励
    self.scroll_view_reward:setName("scroll_view_reward")
    -- self.scroll_view_reward:setResetOffset(true)
    self.scroll_view_reward:setItemSize(cc.size(120, 140))
    self.scroll_view_reward:setAlignmentCenter(true)
    self.scroll_view_reward:setBounceable(true)

    self:addEvent(EVENT.UNDERWORLDPAGODA.UPDATE_RANKLIST, handler(self, self.updateRank))
    self:addEvent(EVENT.UNDERWORLDPAGODA.UPDATE_LAYER, handler(self, self.updateLayer))
    self:addEvent(EVENT.UNDERWORLDPAGODA.BATTLE_BOSS_BATTLE, handler(self, self.startBattle))
    self:addEvent(EVENT.UNDERWORLDPAGODA.UPDATE_BOSS, handler(self, self.updateBoss))
end

function UnderworldPagodaBossLayer:logicOperation()
    if #self.max_tab ~= 2 then
        self.max_tab = {}
        local type_1_conut = 0
        local type_2_conut = 0
        for i,v in ipairs(cfg.hadesfloor.hadesfloor) do
            if v.type == self.hadestype then 
                if v.difficulty_lv == HadesDegree.simple then
                    type_1_conut = type_1_conut + 1
                else
                    type_2_conut = type_2_conut + 1
                end
            end
        end
        table.insert( self.max_tab, type_1_conut )  -- 简单的关卡数量
        table.insert( self.max_tab, type_2_conut )  -- 困难的关卡数量
    end 
    for i,v in ipairs(cfg.hadesfloor.hadesfloor) do
        if v.type == self.hadestype and v.difficulty_lv == self.hades_degree then
            if self.hades_degree == HadesDegree.simple then
                if self.hedesinfo.pass_floor >= self.max_tab[HadesDegree.simple] then
                    if v.show_floor == self.max_tab[HadesDegree.simple] then
                        self.floor_idx = v.idx
                        self.floor = v.show_floor
                        break
                    end
                else
                    if v.show_floor == self.hedesinfo.pass_floor + 1 then
                        self.floor_idx = v.idx
                        self.floor = v.show_floor
                        break
                    end
                end
            else
                local floor = self.hedesinfo.pass_floor - self.max_tab[HadesDegree.simple] + 1 <= 0 and 1 or self.hedesinfo.pass_floor - self.max_tab[HadesDegree.simple] + 1
                if floor >= self.max_tab[HadesDegree.difficulty] then
                    if v.show_floor == self.max_tab[HadesDegree.difficulty] then
                        self.floor_idx = v.idx
                        self.floor = v.show_floor
                        break
                    end
                elseif v.show_floor == floor then
                    self.floor_idx = v.idx
                    self.floor = v.show_floor
                    break
                end
            end
        end
    end
end

function UnderworldPagodaBossLayer:setHadesType( type )
    self.hadestype = type --地狱类型
    self.hedesinfo = ex.Player.underworld_pagoda_data["hadesInfo_type_"..self.hadestype]
    local reddot_type_1 = {
		--  主场景  导航-主城  跨服时空  冥域魔都  赫卡忒地狱  简单
		RedDotType.ZCJ_DHZC_KFSK_MYMD_HKTDY_JD,
		--  主场景  导航-主城  跨服时空  冥域魔都  赫卡忒地狱  困难
		RedDotType.ZCJ_DHZC_KFSK_MYMD_HKTDY_KN,
	}
	local reddot_type_2 = {
		--  主场景  导航-主城  跨服时空  冥域魔都  撒旦魔域  简单
		RedDotType.ZCJ_DHZC_KFSK_MYMD_SDMY_JD,
		--  主场景  导航-主城  跨服时空  冥域魔都  撒旦魔域  困难
		RedDotType.ZCJ_DHZC_KFSK_MYMD_SDMY_KN,
	}
	local reddot_type = {
		reddot_type_1,
		reddot_type_2
	}
    self:addRedDotNode(reddot_type[self.hadestype][HadesDegree.simple], self.btn_simple)
    self:addRedDotNode(reddot_type[self.hadestype][HadesDegree.difficulty], self.btn_difficult)
    self:logicOperation()
    self:updateLayer()
    self:updateBoss()
    self:updateRank()
end

function UnderworldPagodaBossLayer:updateBoss()
    local boss_type_temp = cfg.hadesmonster.getConfig(self.floor_idx,"hero_type")
    if self.boss_type == boss_type_temp then -- boss相同的话 就不重新加载形象
        return
    end

    self.boss_type = boss_type_temp
    self.node_boss:removeAllChildren()

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/hero-info.plist")
    sfc:addSpriteFrames("ccbi-res/skill-icon.plist")

    -- 创建 boss 骨骼
    self.sp_hero = require("src.person.Hero"):create("1", "1", self.boss_type, 250, 13, self.skin)
	self.sp_hero:setShadowVisible(false)
    self.sp_hero:setScale(1.5 * 1.42)
    self.sp_hero:setPosition(0, -10)
    self.node_boss:addChild(self.sp_hero)

    -- 创建技能
	local vec_skill = ex.Player.hero_data:getHeroSkillList(self.boss_type)
    self.scroll_view_skill.createItemFunction = function(data, scale)
        local sfc = cc.SpriteFrameCache:getInstance()
        sfc:addSpriteFrames("ccbi-res/hero-info.plist")
        sfc:addSpriteFrames("ccbi-res/skill-icon.plist")
        local item = require("src.comp.menu.UIMenuItemSkill"):createWithIcon(data, 1, true, handler(self, self.onSkillInfo))
        item:resetLblName()
        return item
    end
    self.scroll_view_skill:reloadData(vec_skill)

end

function UnderworldPagodaBossLayer:updateLayer()
    self.hedesinfo = ex.Player.underworld_pagoda_data["hadesInfo_type_"..self.hadestype]
    if self.hadestype == HadesType.hades_type_1 then
        self.lbl_boss_name:setString(ex.Tools:getLang(6252))
        local texture = cc.Director:getInstance():getTextureCache():addImage(string.format( "ccbi-res/underworld-pagoda-simple-%d.jpg",self.hades_degree))
        if texture then
            self.spr_bg:setTexture(texture)
        end
    else    
        local texture = cc.Director:getInstance():getTextureCache():addImage(string.format( "ccbi-res/underworld-pagoda-difficulty-%d.jpg",self.hades_degree))
        if texture then
            self.spr_bg:setTexture(texture)
        end
        self.lbl_boss_name:setString(ex.Tools:getLang(6253))
    end

    self:creatorTab()
    self:updataReward()
    self:updataItemCount()
    self:checkReddot()
end

-- 更新挑战和扫荡需要的道具数量
function UnderworldPagodaBossLayer:updataItemCount()
    -- 挑战按钮
    if self.hades_degree == HadesDegree.simple then
        if self.floor == self.hedesinfo.pass_floor + 1 then
            ex.Tools:setAllGrayAuto(self.btn_battle:getNormalImage(), false)
            self.btn_battle:setEnabled(true)
        else
            ex.Tools:setAllGrayAuto(self.btn_battle:getNormalImage(), true)
            self.btn_battle:setEnabled(false)
        end
    else
        if self.floor == self.hedesinfo.pass_floor - self.max_tab[HadesDegree.simple] + 1 then
            ex.Tools:setAllGrayAuto(self.btn_battle:getNormalImage(), false)
            self.btn_battle:setEnabled(true)
        else
            ex.Tools:setAllGrayAuto(self.btn_battle:getNormalImage(), true)
            self.btn_battle:setEnabled(false)
        end
    end

    self.node_battle_litem:removeAllChildren()
    self.node_fast_battle_litem:removeAllChildren()
    local battle_item = cfg.hadesfloor.getConfig(self.floor_idx,"cost")
    local sacle = 0.3
    local pos_y = -2
    if #battle_item ~= 0 then
        local spr_battle_item = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png",battle_item[1].item_type))
        spr_battle_item:setName("spr_battle_item")
        spr_battle_item:setScale(sacle)
        self.node_battle_litem:addChild(spr_battle_item)
    
        local lbl_battle_item = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 40)
                            :setScale(0.5,0.5)
                            :setAnchorPoint(0,0.5)
                            :setString(string.format(":%d/%d",ex.Player:getItemNum(battle_item[1].item_type),battle_item[1].item_num))
                            :setColor(cc.c4b(173,134,136,255))
                            :setPosition(spr_battle_item:getContentSize().width / 2 * sacle,pos_y)
        self.node_battle_litem:addChild(lbl_battle_item)
    end

    local fast_battle_num = self.hedesinfo.sweep_count + 1
    if self.hedesinfo.sweep_count >= #cfg.hadesbuycount.hadesbuycount then
        local lbl_fast_battle_item = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 40)
                            :setScale(0.5,0.5)
                            :setAnchorPoint(0.5,0.5)
                            :setColor(cc.c4b(173,134,136,255))
        self.node_fast_battle_litem:addChild(lbl_fast_battle_item)
        lbl_fast_battle_item:setString(ex.Tools:getLang(30306))
        lbl_fast_battle_item:setPosition(16,pos_y)
        return
    end
    local fast_battle_cost = cfg.hadesbuycount.getConfig(fast_battle_num)
    if fast_battle_cost ~= "erreo" then
        local pos_item = #fast_battle_cost == 2 and 50 or 90
        for i,v in ipairs(fast_battle_cost) do
            local spr_fast_battle_item = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png",v.item_type))
                                :setName("spr_fast_battle_item")
                                :setScale(sacle)
                                :setPositionX((i - 1) * 85 - pos_item)
            self.node_fast_battle_litem:addChild(spr_fast_battle_item)

            local lbl_fast_battle_item = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 40)
                            :setScale(0.5,0.5)
                            :setAnchorPoint(0,0.5)
                            :setColor(cc.c4b(173,134,136,255))
                            :setPositionX((i - 1) * 85 - pos_item + spr_fast_battle_item:getContentSize().width / 2 * sacle)
                            :setString(string.format(":%d/%d",ex.Player:getItemNum(v.item_type),v.item_num))
            if v.item_type == 900002 then
                lbl_fast_battle_item:setString(string.format(":%d",v.item_num))
            end
            self.node_fast_battle_litem:addChild(lbl_fast_battle_item)
        end
    end
end

function UnderworldPagodaBossLayer:updataReward()
    self.scroll_view_reward:setLoaded(false)
    
    local data_reward = {}
    for i,v in ipairs(cfg.hadesfloor.getConfig(self.floor_idx,"pass_reward")) do
        table.insert(data_reward,v)
    end

    self.scroll_view_reward.createItemFunction = function(data, scale)
        local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
		item:setScale(scale)
        item:registerScriptTapHandler(handler(self, self.onShowInfo))
        return item
    end

    self.scroll_view_reward:reloadData(data_reward)

end

function UnderworldPagodaBossLayer:creatorTab()
    local btn_tab = {}
    for i,v in ipairs(cfg.hadesfloor.hadesfloor) do
        if v.type == self.hadestype and v.difficulty_lv == self.hades_degree then
            table.insert(btn_tab,v)
        end
    end
    self.scroll_view_tab.createItemFunction = function(data, scale)

        local tab = cpp.UIMenuItemTab:create("underworld-pagoda/btn-underworld-pagod-xuanzebg.png", "underworld-pagoda/btn-underworld-pagod-xuanzebg-2.png", "", 1, 1)
        tab:setTag(data.idx)
        tab:setAnchorPoint(ex.a.center)
        tab:setLabelText(" ")
        tab:registerScriptTapHandler(handler(self, self.onTabChange))

        local lbl = tab:getLabel()
        lbl:enableOutline(cc.c4b(45,74,169,255), 3)
        lbl:setString(string.format( ex.Tools:getLang(75620),data.show_floor))
        
        local ttf_config = lbl:getTTFConfig()
        ttf_config.fontSize = 34
        lbl:setTTFConfig(ttf_config)

        tab.floor = data.show_floor
        tab.idx = data.idx
        -- 已经通关的 显示通关标签
        local show_icon = false
        if self.hades_degree == HadesDegree.simple then
            if data.show_floor <= self.hedesinfo.pass_floor then
                show_icon = true
            end
            if data.show_floor == self.floor then
                tab:setChecked(true)
            end
        else
            if data.show_floor <= self.hedesinfo.pass_floor - self.max_tab[HadesDegree.simple] then
                show_icon = true
            end
            
            if data.show_floor == self.floor then
                tab:setChecked(true)
            end
        end

        if show_icon then
            local sfc = cc.SpriteFrameCache:getInstance()
            sfc:addSpriteFrames("ccbi-res/underworld-pagoda-lang.plist")
            local file = "underworld-pagoda-lang/spr-underworld-pagoda-jibai.png"
            local spr_icon = cc.Sprite:createWithSpriteFrameName(file)
            spr_icon:setAnchorPoint(ex.a.center)
            spr_icon:setPosition(tab:getContentSize().width/2,tab:getContentSize().height/2)
            tab:addChild(spr_icon,10)
        end

        -- 检测道具是否足够可以挑战
        local battle_visible = false
        local battle_item = cfg.hadesfloor.getConfig(self.floor_idx,"cost")
        if ex.Player:getItemNum(battle_item[1].item_type) >= battle_item[1].item_num then
            local pass_floor = self.hedesinfo.pass_floor >= self.max_tab[HadesDegree.simple] and self.hedesinfo.pass_floor - self.max_tab[HadesDegree.simple] or self.hedesinfo.pass_floor
            local degree = HadesDegree.simple
            if self.hedesinfo.pass_floor >= self.max_tab[HadesDegree.simple] then
                degree = HadesDegree.difficulty
            end
            if data.show_floor == pass_floor + 1 and degree == self.hades_degree then
                battle_visible = true
            end
        end
        ex.Tools:addRedPoint(tab, battle_visible, cc.p(0.85, 0.75))
        return tab
    end
    self.scroll_view_tab:reloadData(btn_tab)

    if self.floor == 3 then
        self.scroll_view_tab:setContentOffset(cc.p(0,-150))
    elseif self.floor == 4 then
        self.scroll_view_tab:setContentOffset(cc.p(0,-80))
    elseif self.floor == 5 or self.floor == 6 then
        self.scroll_view_tab:setContentOffset(cc.p(0,0))
    end
end

function UnderworldPagodaBossLayer:updateRank()
    -- message PSHadesRankData {
    --     optional int64 player_id = 1; //玩家ID
    --     optional string name = 2; //玩家名字
    --     optional int32 level = 3; //玩家等级
    --     optional int32 head_id = 4; //玩家头像
    --     optional int32 border_id = 5; //头像框id
    --     optional int32 server_id = 6; //大区（服务器区号）.
    --     optional int32 rank = 7; //玩家排名
    --     optional int32 floor = 8; //当前通关层数1-12
    -- }
    for i=1,3 do
        self["spr_rank_difficult_"..i]:setVisible(false)
        local rank_data = ex.Player.underworld_pagoda_data["hadesInfo_rank_list_"..self.hadestype].ranks[i] 
        self["lbl_rank_damage_"..i]:setVisible(rank_data ~= nil)
        if rank_data == nil then
            self["lbl_rank_name_"..i]:setString(ex.Tools:getLang(54202))
        else
            self["lbl_rank_name_"..i]:setString(rank_data.name)
            local str_floor = ""
            if rank_data.floor <= self.max_tab[HadesDegree.simple] then
                str_floor = string.format(ex.Tools:getLang(6201),rank_data.floor)
            else
                str_floor = string.format(ex.Tools:getLang(6201),rank_data.floor-self.max_tab[HadesDegree.simple])
                self["spr_rank_difficult_"..i]:setVisible(true)
            end
            self["lbl_rank_damage_"..i]:setString(str_floor)
        end
    end
end

function UnderworldPagodaBossLayer:onUpdateInterface(tag, pSender)
    self.hades_degree = tag
    self:logicOperation()
    self:updateLayer()
    self:updateBoss()
    self:updateRank()
end

function UnderworldPagodaBossLayer:onTabChange(tag, pSender)
    if tag == self.floor_idx then return end
  
    self.floor = pSender.floor      -- 层数
    self.floor_idx = pSender.idx    -- 层数的唯一标签 idx
    -- print("层数的唯一标签 idx",pSender.idx)
    self:updateBoss()
    self:updataReward()
    self:updataItemCount()
    self:checkReddot()
end

function UnderworldPagodaBossLayer:onSkillInfo(tag, pSender)
    require("src.layer.HeroSkillInfoCtr"):instance():openWindow(pSender.skill_type, pSender.skill_level, nil)
end

function UnderworldPagodaBossLayer:onBack()
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_UNDERWORLD_PAGODA)
end

function UnderworldPagodaBossLayer:startBattle(event,report, pass_reward, data_info)
    self.hedesinfo = ex.Player.underworld_pagoda_data["hadesInfo_type_"..self.hadestype]
    ex.Player.underworld_pagoda_data:gReqHadesRankList(self.hadestype)
    self.battle_layer = self:addBattleLayer(BattleType.UNDERWORLD_PAGODA_BOSS,
                                            MainSceneType.MAINCITY_UNDERWORLD_PAGODA_BOSS,
                                            "",
                                            nil,
                                            function(layer, data, vec_reward, ext)
                                                require("src.layer.underworldpagoda.UnderworldPagodaBattleEndCtr"):instance():openWindow(data.isWin,vec_reward,ext)
                                                return true, false
                                            end)                                               

    self.battle_layer:battleStart(nil, report,pass_reward,report.log)  
    local isWin = report.win_id == ex.Player.role_id
    if isWin then
        self:logicOperation()
    end
end

-- 扫荡
function UnderworldPagodaBossLayer:onFastBattle()
    if self.hedesinfo.sweep_count >= #cfg.hadesbuycount.hadesbuycount then
        ex.MessageView:add(ex.Tools:getLang(30306))
        return
    end

    if self.hedesinfo.pass_floor <= 0 then
        ex.MessageView:add(ex.Tools:getLang(5038))
        return
    end

    local fast_battle_num = self.hedesinfo.sweep_count + 1
    local fast_battle_cost = cfg.hadesbuycount.getConfig(fast_battle_num)
    if fast_battle_cost ~= "erreo" then
        if #fast_battle_cost ~= 0 then
            if ex.Player:getItemNum(fast_battle_cost[1].item_type) < fast_battle_cost[1].item_num then
                ex.MessageView:add(ex.Tools:getLang(30503))
                return
            end
        end
    end

    ex.ConfirmCtr:openWindow(ex.Tools:getLang(41301), ex.Tools:getLang(6260), function()
        ex.Player.underworld_pagoda_data:gReqHadesSweep(self.hadestype)
    end)
end

-- 挑战
function UnderworldPagodaBossLayer:onBattle()
    local battle_item = cfg.hadesfloor.getConfig(self.floor_idx,"cost")
    if battle_item ~= "" then
        if ex.Player:getItemNum(battle_item[1].item_type) < battle_item[1].item_num then
            ex.MessageView:add(ex.Tools:getLang(30503))
            return
        end
    end

    -- 进入布阵界面
    require('src.layer.HeroSelectCtr'):instance():openWindow(ex.Tools:getLang(47524),
                                                            ex.Tools:getLang(47064),
                                                            BattleType.UNDERWORLD_PAGODA_BOSS,
                                                            handler(self, self.onBattleDone))
end

function UnderworldPagodaBossLayer:onBattleDone()
    ex.Player.underworld_pagoda_data:gReqHadesChallenge(self.hadestype)
end

function UnderworldPagodaBossLayer:onInfo()
    local name_lang = {
        6252,
        6253
    }
    local content_lang = {
        6257,
        6258
    }
    ex.InfoCtr:openWindow(ex.Tools:getLang(name_lang[self.hadestype]), ex.Tools:getLang(content_lang[self.hadestype]))    
end

function UnderworldPagodaBossLayer:onShowInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function UnderworldPagodaBossLayer:onRank()
    require("src.layer.underworldpagoda.UnderworldPagodaRankCtr"):instance():openWindow(self.hadestype)
end

function UnderworldPagodaBossLayer:checkReddot( )
    local reddot_degree = {
        self.btn_simple,
        self.btn_difficult
    }

 	-- 检测是否可以扫荡 （花钻石的扫荡不检测 直接return）
    local free_visible = false
    if self.hedesinfo.pass_floor >= 1 then
        for k,v in pairs(cfg.hadesbuycount.hadesbuycount) do
            if v.idx == self.hedesinfo.sweep_count+1 and #v.cost == 2 then
                local cost_num = 0
                for j,k in ipairs(v.cost) do
                    if ex.Player:getItemNum(k.item_type) >= k.item_num then
                        cost_num = cost_num + 1
                    end
                end
                free_visible = cost_num == #v.cost and true or false
                break
            end
        end
    end
    ex.Tools:addRedPoint(self.btn_fast_battle, free_visible, cc.p(0.95, 0.85))

    -- 检测道具是否足够可以挑战
    -- 如果是最高层 直接不再判断
    if self.hedesinfo.pass_floor >= self.max_tab[HadesDegree.simple] + self.max_tab[HadesDegree.difficulty] then
        ex.Tools:addRedPoint(self.btn_battle, false, cc.p(0.95, 0.85))
		return
    end
    local battle_visible = false
    local battle_item = cfg.hadesfloor.getConfig(self.floor_idx,"cost")
    local pass_floor = self.hedesinfo.pass_floor >= self.max_tab[HadesDegree.simple] and self.hedesinfo.pass_floor - self.max_tab[HadesDegree.simple] or self.hedesinfo.pass_floor
    local degree = self.hedesinfo.pass_floor >= self.max_tab[HadesDegree.simple] and HadesDegree.difficulty or HadesDegree.simple
    if ex.Player:getItemNum(battle_item[1].item_type) >= battle_item[1].item_num and
       self.floor == pass_floor + 1 and degree == self.hades_degree then
        battle_visible = true
    end
    ex.Tools:addRedPoint(self.btn_battle, battle_visible, cc.p(0.95, 0.85))
end

return UnderworldPagodaBossLayer