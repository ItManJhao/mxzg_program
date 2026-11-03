local DungeonLayer = class("DungeonLayer", require("src.comp.EventLayer"))
local UIMenu = require("src.comp.menu.UIMenu")
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

--------------------------------------------
function DungeonLayer:getAsynImage()
    local vec_image = {

    }
    return vec_image
end


function DungeonLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
	self:setExitCallback(handler(self,self.onExitCB))

    self:setContentSize(cc.size(ex.p.width, ex.p.height))

    self:registerEvent()

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/dungeon.plist")
    sfc:addSpriteFrames("ccbi-res/dungeon-grid.plist")
    sfc:addSpriteFrames("ccbi-res/lang-1.plist")

    local notch_height = require("src.model.Game"):instance():getNotchHeight()

    self.btn_back:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60,
                              self:getContentSize().height / 2 + ex.p.height / 2 / self:getScaleY() - 100 / self:getScaleY() - 42 - notch_height)

    local item_size = cc.size(64, 64)
    self.bottom_height = 440

    -- 显示网格砖块,并保存网格层区域大小
    self:updateGrid()

    local spr_map_bg = cc.Sprite:createWithSpriteFrameName("dungeon-grid/spr-map-bg.png")
    spr_map_bg:setLocalZOrder(20)
    spr_map_bg:setScale(self.layer_grid:getScale())
    spr_map_bg:setPosition(ex.p.cx, self.bottom_height + self.layer_grid_size.height / 2 - 20)
    self:addChild(spr_map_bg)

	-- 设置左右上下遮罩位置,及网格底图大小
    self.spr_bg_top:setLocalZOrder(30)
    self.spr_bg_top:setPosition(ex.p.cx, self.bottom_height + self.layer_grid_size.height - 40)
    self.spr_bg_top:setScale(ex.p.width / self.spr_bg_top:getContentSize().width)

    self.spr_bg_bottom:setLocalZOrder(40)
    local scale_x = ex.p.width / self.spr_bg_bottom:getContentSize().width
    local scale_y = (self.bottom_height - 20) / self.spr_bg_bottom:getContentSize().height
    self.spr_bg_bottom:setScale((scale_x) > scale_y and scale_x or scale_y)
    self.spr_bg_bottom:setPosition(ex.p.cx, self.bottom_height + 20 * self.spr_bg_bottom:getScale())

    -- self.spr_bg = cc.Sprite:create("ccbi-res/map-bg-dungeon-1.jpg")
    -- self.spr_bg:setLocalZOrder(0)
    -- self.spr_bg:setPosition(ex.p.cx, ex.p.cy - 20)
    -- self:addChild(self.spr_bg)

    -- local scale_x = ex.p.width / self.spr_bg:getContentSize().width
    -- local scale_y = ex.p.height / self.spr_bg:getContentSize().height
    -- self.spr_bg:setScale(scale_x > scale_y and scale_x or scale_y)

    self.spr_bg:setContentSize(ex.p)
    self.spr_bg:setPosition(ex.p.cx, ex.p.cy)

    -- 设置界面按钮位置
    self.menu:setLocalZOrder(100)
    self.btn_info:setPosition(50, ex.p.height - 20 - 120 - notch_height)
    self.btn_rank:setPosition(130, ex.p.height - 20 - 120- notch_height)

    self.spr_title_bg:setLocalZOrder(50)
    self.spr_title_bg:setPosition(ex.p.cx, ex.p.height - 20 - 120 - notch_height)
    self.lbl_title:setLocalZOrder(60)
    self.lbl_title:setPosition(ex.p.cx, ex.p.height - 20 - 120 - notch_height)

    -- self.btn_back:setPosition(80, self.bottom_height - 310)
    self.btn_buff_list:setPosition(ex.p.width - 80, self.bottom_height - 300)
    self.btn_buff_list:setEnableAction(false)
    self.btn_buff_list:setLabelText(ex.Tools:getLang(47202))
    self.btn_buff_list:setLabelSize(36)
    self.btn_buff_list:setLabelColor(FONT_LIGHT_YELLOW)
    self.btn_buff_list:setLabelOffset(cc.p(0, -0.5))

    -- 刷新道具显示
    self:updateProps()

    -- 如果英雄队列为空，则显示英雄组队界面
    if ex.Player.dungeon_data.lineup_hero_list == nil or #ex.Player.dungeon_data.lineup_hero_list <= 0 then
        require("src.layer.DungeonHeroSelectCtr"):instance():openWindow()
    end

    self.spr_hero_list_bg:setLocalZOrder(150)
    self.spr_hero_list_bg:setContentSize(cc.size(ex.p.width, 180))
    self.spr_hero_list_bg:setPosition(ex.p.width / 2, self.bottom_height - 200)
    self.layer_hero_list:setLocalZOrder(200)
    self.layer_hero_list:setContentSize(cc.size(self.spr_hero_list_bg:getContentSize().width - 60, self.layer_hero_list:getContentSize().height))
    self.layer_hero_list:setPosition(self.spr_hero_list_bg:getPosition())

    self:updateHeroList()

    -- 添加时间倒计时定时器
    self.lbl_left_time:setLocalZOrder(150)
    self.lbl_left_time:enableOutline(FONT_BROWN_C4B, 1)
    self.lbl_left_time:setPosition(ex.p.cx, self.btn_buff_list:getPositionY() - 10)
    self:addTimer()

    self.lbl_left_time_bg:setLocalZOrder(149)
    self.lbl_left_time_bg:setPosition(self.lbl_left_time:getPosition())

    -- 刷新地牢排行榜数据
    ex.Player.rank_data:onRefreshDungeon()
end

function DungeonLayer:onExitCB()
    
end

-- 层切入时会被调用
function DungeonLayer:changeLayerIn()
    NetManager:sendMessage(ProtocolID.GReqDungeonKillRewardList)
    NetManager:sendMessage(ProtocolID.GReqDungeonShopList)
end

function DungeonLayer:registerEvent()
   self:addEvent(EVENT.DUNGEON_EVENT.GRID_INFO, handler(self, self.updateGrid))
   self:addEvent(EVENT.DUNGEON_EVENT.GRID_EVENT, handler(self, self.updateEvent))
   self:addEvent(EVENT.DUNGEON_EVENT.PROPS_INFO, handler(self, self.updateProps))
   self:addEvent(EVENT.DUNGEON_EVENT.HERO_INFO, handler(self, self.updateHeroList))
   self:addEvent(EVENT.DUNGEON_EVENT.ON_BATTLE, handler(self, self.onBattle))
   self:addEvent(EVENT.DUNGEON_EVENT.BATTLE_END, handler(self, self.onBattleEnd))
   self:addEvent(EVENT.DUNGEON_EVENT.TAKE_KILL_REWARD, handler(self, self.updateKillRewardEffect))
   self:addEvent(EVENT.DUNGEON_EVENT.USE_POTION_SUCCEED, handler(self, self.onUsePotionSucceed))
end

-- 添加时间倒计时定时器
function DungeonLayer:addTimer()
	local scheduler = cc.Director:getInstance():getScheduler()
    self.schedulerID = scheduler:scheduleScriptFunc(handler(self, self.handleSchedule),1,false)
    self:handleSchedule()
end

function DungeonLayer:handleSchedule()
    local time = ex.Player.dungeon_data.end_time - ex.Game:getServerTime()
    self.lbl_left_time:setString(ex.Tools:getLang(47401)..ex.StringUtil.convertToTimeFormat(time))
    if time <= 0 then 
        self:removeTimer()
    end
end

function DungeonLayer:removeTimer()
	if self.schedulerID ~= nil then 
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
		self.schedulerID = nil
	end
end

function DungeonLayer:onExitCB()
	self:removeTimer()
end

function DungeonLayer:onRank(tag , pSender)
    require("src.layer.RankTopThreeCtr"):instance():openWindow(11)
end

function DungeonLayer:onInfo(tag , pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42030), ex.Tools:getLang(42031))
end

function DungeonLayer:onBack(tag , pSender)
    -- ex.MainSceneCtr:instance():changeLayer(MainSceneType.MAINCITY_LAYER)
    cfg.funcopen["main_ancient"].open()
end

-----------------------------------------------------------------------------
-- 刷新网格显示
function DungeonLayer:updateGrid()
    local item_size = cc.size(64, 64)
    local item_col = 5
    local item_row = 5

    self:onNextStageDone()

    self.lbl_title:setString(string.format(ex.Tools:getLang(47395), ex.Player.dungeon_data.cur_stage))

    local layer_cur_size = cc.size(item_size.width * item_col, item_size.height * item_row)
    if self.layer_grid == nil then
        self.layer_grid = cc.Layer:create()
        self.layer_grid:setLocalZOrder(35)
        self:addChild(self.layer_grid)

        local scale = ex.p.width / layer_cur_size.width
        if ex.p.width > 640 then
            scale = scale * 640 / ex.p.width
        end
        self.layer_grid_size = cc.size(layer_cur_size.width * scale, layer_cur_size.height * scale)

        local pos_y = self.bottom_height-- - self.layer_grid_size.height / 2

        self.layer_grid:setAnchorPoint(0, 0)
        self.layer_grid:setContentSize(layer_cur_size)
        self.layer_grid:setScale(scale)
        self.layer_grid:setPosition(0, pos_y - 20)
    end

    local menu = self.layer_grid:getChildByName("menu_grid")
    if menu == nil then
        menu = cpp.UIMenu:create()
        menu:setName("menu_grid")
        :setSwallowsTouches(false)
        :setPosition(cc.p((ex.p.width - self.layer_grid_size.width) / 4, 0))
        self.layer_grid:addChild(menu, 100)
    end

    local effect_idx = 0
    local grid_type_rand_1 = ex.Player.dungeon_data.cur_grid_type
    for i,v in ipairs(ex.Player.dungeon_data.grid_list) do
        local item = menu:getChildByTag(v.grid_y * 1000 + v.grid_x)

        if v.is_open <= 0 then
            if item == nil then
                local str_item = string.format("dungeon-grid/%d-%02d.png", grid_type_rand_1, v.grid_rand_type)
                item = cpp.UIMenuItemImage:createWithSpriteFrameName(str_item, str_item, str_item)
                item:setEnableAction(false)
                item:registerScriptTapHandler(handler(self, self.onSelectGrid))
                item:setTag(v.grid_y * 1000 + v.grid_x)
                item:setScale(64 / 78)
                item.pos_x = v.grid_x
                item.pos_y = v.grid_y
                item:setLocalZOrder(v.grid_y * 1000 + v.grid_x)
                -- item:setPosition((j - 0.5) * item_size.width, (i - 0.5) * item_size.height)
                item:setPosition((v.grid_x - 0.5) * item_size.width, (v.grid_y - 0.5) * item_size.height)
                menu:addChild(item)
            end
        else    -- 如果已经打开，但是还有瓦片的，播放特效
            if item ~= nil and item.removing == nil then
                item:setEnabled(false)

                local item_size = item:getContentSize()
                local inner_center_point = cc.p(item_size.width * item:getScale() / 2, item_size.height * item:getScale() / 2)
                local world_space_point = item:convertToWorldSpace(inner_center_point)
                local pos = self:convertToNodeSpace(world_space_point)

                local spr_effect = cc.Sprite:create()
                self:addChild(spr_effect, 1000)
                spr_effect:setPosition(pos)
                spr_effect:setScale(2.0)
                spr_effect:setVisible(false)

                local func = function()
                    spr_effect:setVisible(true)
                    item:removeFromParent()
                    ex.AudioManager:playEffect("music/shelter-stone.mp3")
                end
                spr_effect:runAction(cc.Sequence:create(cc.DelayTime:create(effect_idx * 0.15), 
                                                        cc.CallFunc:create(func), 
                                                        ex.EffectFactory:createEffectByName("eff_dungeon_stone_boomb"), 
                                                        cc.RemoveSelf:create(), 
                                                        nil))

                effect_idx = effect_idx + 1
                item.removing = true
            end
        end
    end

    self:updateEvent()
end

-----------------------------------------------------------------------------
-- 刷新事件显示
function DungeonLayer:updateEvent()

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/lang-1.plist")

    local item_size = cc.size(64, 64)
    local item_col = 5
    local item_row = 5

    local menu_event = self.layer_grid:getChildByName("menu_event")
    if menu_event == nil then
        menu_event = cpp.UIMenu:create()
        menu_event:setName("menu_event")
        :setSwallowsTouches(false)
        :setPosition(cc.p((ex.p.width - self.layer_grid_size.width) / 4, 0))
        self.layer_grid:addChild(menu_event, 80)
    end

    local menu_monster = self.layer_grid:getChildByName("menu_monster")
    if menu_monster == nil then
        menu_monster = cpp.UIMenu:create()
        menu_monster:setName("menu_monster")
        :setSwallowsTouches(false)
        :setPosition(cc.p((ex.p.width - self.layer_grid_size.width) / 4, 0))
        self.layer_grid:addChild(menu_monster, 120)
    end

    for i,v in ipairs(ex.Player.dungeon_data.grid_list) do
        local item = menu_event:getChildByTag(v.grid_y * 1000 + v.grid_x)
        if item == nil then
            item = menu_monster:getChildByTag(v.grid_y * 1000 + v.grid_x)
        end
        -- 中心点另有处理
        if v.is_open > 0 and v.grid_event_type ~= 0 and (v.grid_x ~= 3 or v.grid_y ~= 3) then
            if item == nil then
                local is_need_act = false
                if v.grid_event_type < 0 then
                    local str_item = string.format("dungeon/monster-frame-%d.png", tonumber(v.grid_event_num))
                    is_need_act = true

                    item = cpp.UIMenuItemImage:createWithSpriteFrameName(str_item, str_item, str_item)

                    -- 添加怪物头像显示
                    local config = ex.Player.dungeon_data:getMonsterByStageAndLevel(ex.Player.dungeon_data.cur_stage, tonumber(v.grid_event_num))
                    if config ~= nil then
                        local icon = ex.Tools:getHeroIconByStar(config.hero_type , config.hero_star) + 10000000
                        local spr_hero_icon = cc.Sprite:createWithSpriteFrameName("hero-icon/"..icon..".png")
                        spr_hero_icon:setScale((item:getContentSize().width - 45) / spr_hero_icon:getContentSize().width)
                        spr_hero_icon:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
                        spr_hero_icon:setLocalZOrder(-1)
                        item:addChild(spr_hero_icon)
                    else 
                        print("config is null: ", tonumber(v.grid_event_num))
                    end
                else
                    local str_item = string.format("dungeon/event-%d.png", v.grid_event_type)

                    item = cpp.UIMenuItemImage:createWithSpriteFrameName(str_item, str_item, str_item)

                    -- if v.grid_event_type == 104 or v.grid_event_type == 106 or v.grid_event_type == 107 or v.grid_event_type == 109 then
                    --     is_need_act = true
                    -- end
                end

                item:setEnableAction(false)
                item:registerScriptTapHandler(handler(self, self.onSelectGridEvent))
                item:setScale(item_size.width / item:getContentSize().width)
                item:setTag(v.grid_y * 1000 + v.grid_x)
                item.pos_x = v.grid_x
                item.pos_y = v.grid_y
                item.pos = cc.p((v.grid_x - 0.5) * item_size.width, (v.grid_y - 0.5) * item_size.height)
                item:setLocalZOrder(v.grid_y * 1000 + v.grid_x)
                item:setPosition(item.pos)

                if v.grid_event_type < 0 then
                    menu_monster:addChild(item)
                else
                    menu_event:addChild(item)
                end

                -- 部分事件添加上下漂浮动作
                if is_need_act == true then
                    local move_time = 0.65-- + math.random(1, 10) / 100
                    local act_seq = cc.Sequence:create(cc.MoveTo:create(move_time, cc.p(item.pos.x, item.pos.y + 10)), cc.MoveTo:create(move_time, item.pos), nil)
                    item:runAction(cc.RepeatForever:create(act_seq))
                end

                -- 添加宝箱特效
                if v.grid_event_type == DUNGEON_EVENT_TYPE.KEY_BOX or v.grid_event_type == DUNGEON_EVENT_TYPE.KEY then
                    local item_size = item:getContentSize()
                    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_dungeon_event_static_"..v.grid_event_type)
                    spr_effect:setPosition(cc.p(item_size.width / 2, item_size.height / 2))
                    item:addChild(spr_effect)
                end
            end
        else
            if item ~= nil and (v.grid_x ~= 3 or v.grid_y ~= 3) then
                -- print("remove event: ("..v.grid_x..", "..v.grid_y..")")
                item:removeFromParent()
                item = nil
            end
        end
    end

    -- 对中心点进行处理
    for i,v in ipairs(ex.Player.dungeon_data.grid_list) do
        if v.grid_x == 3 and v.grid_y == 3 then 
            local item = menu_monster:getChildByTag(v.grid_y * 1000 + v.grid_x)
            local monster_status = ex.Player.dungeon_data:getMonsterStatus(5)
            if item == nil or item.monster_status ~= monster_status then
                -- 添加下一层按钮
                local str_item = "lang-1/spr-next-stage.png"
                if item == nil then
                    item = cpp.UIMenuItemImage:createWithSpriteFrameName(str_item, str_item, str_item)
                    item.monster_status = monster_status
                    item:setEnableAction(false)
                    item:registerScriptTapHandler(handler(self, self.onSelectGridEvent))
                    item:setScale(item_size.width / item:getContentSize().width)
                    item:setTag(v.grid_y * 1000 + v.grid_x)
                    item.pos_x = v.grid_x
                    item.pos_y = v.grid_y
                    item.pos = cc.p((v.grid_x - 0.5) * item_size.width, (v.grid_y - 0.5) * item_size.height)
                    item:setLocalZOrder(v.grid_y * 1000 + v.grid_x)
                    item:setPosition((v.grid_x - 0.5) * item_size.width, (v.grid_y - 0.5) * item_size.height)
                    menu_monster:addChild(item)
                end

                item.monster_status = monster_status
                item:stopAllActions()
                item:removeChildByTag(800)
                item:removeChildByTag(900)

                if monster_status == -1 then
                    -- 添加下一层按钮
                    str_item = "lang-1/spr-next-stage.png"
                    item:setEnabled(true)
                    
                    -- 添加按钮特效
                    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_dungeon_next_stage")
                    spr_effect:setTag(800)
                    item:addChild(spr_effect, 10)
                    local item_size = item:getContentSize()
                    spr_effect:setPosition(cc.p(item_size.width / 2, item_size.height / 2))
                elseif monster_status == 1 then
                    -- 添加怪物石雕按钮，无法点击
                    str_item = "dungeon/spr-carve.png"
                    item:setEnabled(false)
                else
                    -- 怪物状态
                    str_item = string.format("dungeon/monster-frame-%d.png", tonumber(v.grid_event_num))
                    item:setEnabled(true)
                    -- 添加怪物头像显示
                    local config = ex.Player.dungeon_data:getMonsterByStageAndLevel(ex.Player.dungeon_data.cur_stage, tonumber(v.grid_event_num))
                    if config ~= nil then
                        local icon = ex.Tools:getHeroIconByStar(config.hero_type , config.hero_star) + 10000000
                        local spr_hero_icon = cc.Sprite:createWithSpriteFrameName("hero-icon/"..icon..".png")
                        spr_hero_icon:setTag(900)
                        spr_hero_icon:setScale((item:getContentSize().width - 45) / spr_hero_icon:getContentSize().width)
                        spr_hero_icon:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
                        spr_hero_icon:setLocalZOrder(-1)
                        item:addChild(spr_hero_icon)
                    else 
                        print("config is null: ", tonumber(v.grid_event_num))
                    end

                    -- 部分事件添加上下漂浮动作
                    local move_time = 0.65-- + math.random(1, 10) / 100
                    local act_seq = cc.Sequence:create(cc.MoveTo:create(move_time, cc.p(item.pos.x, item.pos.y + 10)), cc.MoveTo:create(move_time, item.pos), nil)
                    item:runAction(cc.RepeatForever:create(act_seq))
                end
                item:setNormalImage(cc.Sprite:createWithSpriteFrameName(str_item))
                item:setSelectedImage(cc.Sprite:createWithSpriteFrameName(str_item))
                item:setDisabledImage(cc.Sprite:createWithSpriteFrameName(str_item))
            end
            break
        end
    end
end

-----------------------------------------------------------------------------
-- 刷新道具显示
function DungeonLayer:updateProps()
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/lang-1.plist")
    -- lang-1

    if self.layer_props == nil then
        self.layer_props = cc.Layer:create()
        self.layer_props:setLocalZOrder(200)
        self:addChild(self.layer_props)

        self.layer_props:setAnchorPoint(0, 0)
        self.layer_props:setContentSize(cc.size(ex.p.width, 100))
        self.layer_props:setPosition(0, self.bottom_height - 110)
    end
    self.layer_props:removeAllChildren()

    local menu = cpp.UIMenu:create()
    menu:setName("menu")
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    self.layer_props:addChild(menu, 80)

    local index = 1
    local btn_num_total = 6
    local str_item = {}
    table.insert(str_item, "dungeon/btn-kill-reward.png")
    table.insert(str_item, "dungeon/btn-potion-hp.png")
    table.insert(str_item, "dungeon/btn-potion-diffusion.png")
    table.insert(str_item, "dungeon/btn-shop-add.png")
    table.insert(str_item, "dungeon/btn-shop.png")
    table.insert(str_item, "dungeon/btn-ether.png")

    local str_item_name = {}
    table.insert(str_item_name, ex.Tools:getLang(47062))
    table.insert(str_item_name, ex.Tools:getLang(cfg.item.item[901602].name))
    table.insert(str_item_name, ex.Tools:getLang(cfg.item.item[901603].name))
    table.insert(str_item_name, ex.Tools:getLang(cfg.item.item[901604].name))
    table.insert(str_item_name, ex.Tools:getLang(47458))
    table.insert(str_item_name, ex.Tools:getLang(47619))

    local reddot_type = {}
    table.insert(reddot_type, RedDotType.ZCJ_DHZC_YGZC_YSBHS_JSJS)
    --  self:addRedDotNode(RedDotType.ZCJ_DHGH_KJ_YX, self.btn_profession_5)

    for i,v in ipairs(str_item) do
        local index = i
        local item = cpp.UIMenuItemImage:createWithSpriteFrameName(str_item[i], str_item[i], str_item[i])
        item:registerScriptTapHandler(handler(self, self.onUseProps))
        item:setTag(index)
        item:setPosition(self.layer_props:getContentSize().width / btn_num_total * (index - 0.5), self.layer_props:getContentSize().height / 2)
        menu:addChild(item)

        if reddot_type[i] ~= nil then
            self:addRedDotNode(reddot_type[i], item)
        end

        local item_bg = cc.Sprite:createWithSpriteFrameName("dungeon/btn-bg.png")
        item_bg:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
        item_bg:setLocalZOrder(-1)
        item:addChild(item_bg)

        local item_num_bg = cc.Sprite:createWithSpriteFrameName("dungeon/spr-btn-bg-1.png")
        item_num_bg:setPosition(item:getContentSize().width / 2, 20)
        item_num_bg:setLocalZOrder(10)
        item:addChild(item_num_bg)

        item.lbl_name = cc.Label:createWithTTF(str_item_name[i], FONT_DEFAULT_NAME_BOLD, 36)
        item.lbl_name:setScale(0.5)
        item.lbl_name:setColor(FONT_LIGHT_YELLOW)
        item.lbl_name:setPosition(item_num_bg:getPosition())
        item.lbl_name:setLocalZOrder(20)
        item:addChild(item.lbl_name)

        if index > 1 and index < 5 then
            item.lbl_num = cc.Label:createWithTTF("0", FONT_DEFAULT_NAME_BOLD, 36)
            item.lbl_num:setColor(FONT_LIGHT_YELLOW)
            item.lbl_num:setScale(0.5)
            item.lbl_num:setAnchorPoint(1, 0.5)
            item.lbl_num:setPosition(item:getContentSize().width - 20, 40)
            item.lbl_num:setLocalZOrder(30)
            item:addChild(item.lbl_num)

            local props_num = ex.Player.dungeon_data:getPropsNum(901600 + index)
            item.lbl_num:setString(string.format("%d", props_num))
        elseif index == 6 then
            -- 添加暂不开放图标显示
            local spr_unopen = cc.Sprite:createWithSpriteFrameName("lang-1/lbl-unopen.png")
            spr_unopen:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
            spr_unopen:setLocalZOrder(40)
            item:addChild(spr_unopen)
        elseif index == 1 then
            self:updateKillRewardEffect()
        end
    end
end

-----------------------------------------------------------------------------
-- 刷新英雄列表显示
function DungeonLayer:updateHeroList()
    self.layer_hero_list:removeAllChildren()

    if ex.Player.dungeon_data.lineup_hero_list == nil or #ex.Player.dungeon_data.lineup_hero_list <= 0 then
        self.btn_back:setVisible(false)
    else
        self.btn_back:setVisible(true)
    end

    local menu = cpp.UIMenu:create()
    menu:setName("menu")
    :setSwallowsTouches(false)
    :setPosition(self.layer_hero_list:getContentSize().width / 2, self.layer_hero_list:getContentSize().height / 2)
    self.layer_hero_list:addChild(menu)

    local num = 6
    local index = 1
    for i=1,6 do
        local hero_data = nil
        local hero_data = ex.Player.dungeon_data:getTeamHeroHpDataByIndex(i)
        local item = nil
        if hero_data == nil then
            item = UIMenuItemHero:createWithData()
            item:setHeroId(NULL_ID)
            item:removeIcon()
            item:removeElem()
            item:removeLevel()
            item:removeStar()
        else
            item = UIMenuItemHero:createWithData(hero_data.hero_id, hero_data.hero_type, hero_data.elem, hero_data.level, hero_data.star)
            -- item:registerScriptTapHandler(handler(self, self.onSelectHero))

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
            item.spr_progress_bg:setPosition(item:getContentSize().width / 2, -15)
            item:addChild(item.spr_progress_bg)

            item.progress = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("dungeon/progress-hp.png"))
            :setType(cc.PROGRESS_TIMER_TYPE_BAR)
            :setMidpoint(cc.p(0, 0.5))
            :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
            :setPosition(item.spr_progress_bg:getPosition())
            item:addChild(item.progress)

            item.progress:setPercentage(hero_data.hero_rate / 100)
        end
        item:setTag(i)
        item:setPosition(115 * (index - num / 2 - 0.5), 15)
        menu:addChild(item)

        index = index + 1
    end

    local scale_x = (ex.p.width - 60) / self.layer_hero_list:getContentSize().width
    if scale_x >= 1 and 115 * num > self.layer_hero_list:getContentSize().width then
        scale_x = self.layer_hero_list:getContentSize().width / (115 * num)
    end
    self.layer_hero_list:setScale(scale_x > 1 and 1 or scale_x)
end

-----------------------------------------------------------------------------
-- 选中网格快，翻开出现事件
function DungeonLayer:onSelectGrid(tag, pSender)
    -- print("onSelectGrid, ", pSender.pos_x, pSender.pos_y)

    if ex.Player.dungeon_data.lineup_hero_list == nil or #ex.Player.dungeon_data.lineup_hero_list <= 0 then
        return
    end

    local vec_grid_pos = {}
    local grid_pos_data = {}
    grid_pos_data.grid_x = pSender.pos_x
    grid_pos_data.grid_y = pSender.pos_y
    table.insert(vec_grid_pos, grid_pos_data)
    local flag = ex.Player.dungeon_data:gridLight(vec_grid_pos)
    if flag == false then
        return
    end

    -- 去除网格块
    pSender:removeFromParent()
    pSender = nil

    self:updateEvent()
end

function DungeonLayer:onLightGridAround(grid_x, grid_y)
    if grid_x == nil or grid_y == nil then
        return
    end
    
    for i, v in ipairs(ex.Player.dungeon_data.grid_list) do
        if grid_x == v.grid_x and grid_y == v.grid_y then
            v.grid_event_type = 0
            break
        end
    end

    local vec_grid_pos = {}
    for i = grid_x - 1, grid_x + 1 do
        for j = grid_y - 1, grid_y + 1 do
            local grid_pos_data = {}
            grid_pos_data.grid_x = i
            grid_pos_data.grid_y = j
            table.insert(vec_grid_pos, grid_pos_data)
        end
    end
    
    local flag = ex.Player.dungeon_data:gridLight(vec_grid_pos)

    if flag == false then
        return
    end

    self:updateGrid()
    self:updateEvent()
end

-- 点击事件，响应对应事件响应
function DungeonLayer:onSelectGridEvent(tag, pSender)
    -- print("----------onSelectGridEvent, ", pSender.pos_x, pSender.pos_y)

    if ex.Player.dungeon_data.lineup_hero_list == nil or #ex.Player.dungeon_data.lineup_hero_list <= 0 then
        return
    end

    -- 如果所有英雄都死亡了，则弹出提示
    local is_have_hero_alive = false
    for i, v in ipairs(ex.Player.dungeon_data.lineup_hero_list) do
        if tonumber(v.hero_rate) > 0 then
            is_have_hero_alive = true
            break
        end
    end

    for i,v in ipairs(ex.Player.dungeon_data.grid_list) do
        if v.grid_x == pSender.pos_x and v.grid_y == pSender.pos_y and v.is_open > 0 then
            -- 如果所有英雄都死亡了，则弹出提示
            if not is_have_hero_alive and v.grid_event_type == -1 then
                ex.MessageView:add(ex.Tools:getLang(41207))
                return
            end
        
            -- print("onSelectGridEvent, ", v.grid_event_type)
            if v.grid_event_type > 100 and v.grid_event_type < 110 and v.grid_event_type ~= DUNGEON_EVENT_TYPE.KEY_BOX then
                ex.AudioManager:playEffect("music/shelter"..v.grid_event_type..".mp3")
            end
            if v.grid_event_type == -1 then
                require("src.layer.DungeonHeroAttackCtr"):instance():openWindow(tonumber(v.grid_event_num))
            elseif v.grid_event_type == DUNGEON_EVENT_TYPE.SHOP then
                local vec_shop_item = {}
                for i,v2 in pairs(ex.Player.dungeon_data.shop_list) do
                    if v2.shop_id == v.grid_event_num then
                        table.insert(vec_shop_item, v2)
                    end
                end
                -- dump(vec_shop_item, "vec_shop_item")
                require("src.layer.DungeonShopCtr"):instance():openWindow(vec_shop_item)
            elseif v.grid_event_type == DUNGEON_EVENT_TYPE.KEY_BOX then
                require("src.layer.DungeonBoxUseCtr"):instance():openWindow(v.grid_x, v.grid_y, tonumber(v.grid_event_num))
            else
                if v.grid_x == 3 and v.grid_y == 3 then 
                    -- print("check next stage")
                    local monster_status = ex.Player.dungeon_data:getMonsterStatus(5)
                    if monster_status == -1 then
                        local max_stage = 0
                        for k,v in pairs(cfg.shelterlevel.shelterlevel) do
                            if v.shelter_stage > max_stage then
                                max_stage = v.shelter_stage
                            end
                        end
                        if ex.Player.dungeon_data.cur_stage >= max_stage then
                            ex.MessageView:add(ex.Tools:getLang(41335))
                            return
                        end
                        ex.ConfirmCtr:openWindow(ex.Tools:getLang(47611), ex.Tools:getLang(47696), handler(self, self.onNextStageConfirm))
                    end
                else 
                    local type, flag = ex.Player.dungeon_data:clickEvent(pSender.pos_x, pSender.pos_y)

                    if type == DUNGEON_EVENT_TYPE.BUFF or 
                        type == DUNGEON_EVENT_TYPE.GOLD or 
                        type == DUNGEON_EVENT_TYPE.STONE or
                        type == DUNGEON_EVENT_TYPE.FREE_BOX_1 or 
                        type == DUNGEON_EVENT_TYPE.FREE_BOX_2 or 
                        type == DUNGEON_EVENT_TYPE.FREE_BOX_3 or 
                        type == DUNGEON_EVENT_TYPE.FREE_BOX_4 or 
                        type == DUNGEON_EVENT_TYPE.FREE_BOX_5 or 
                        type == DUNGEON_EVENT_TYPE.FREE_BOX_6 or 
                        type == DUNGEON_EVENT_TYPE.KEY or 
                        type == DUNGEON_EVENT_TYPE.POTION_1 or 
                        type == DUNGEON_EVENT_TYPE.POTION_2 or
                        type == DUNGEON_EVENT_TYPE.SHOP_ADD then
                        
                        local item_size = pSender:getContentSize()
                        local inner_center_point = cc.p(item_size.width / 2, item_size.height / 2)
                        local world_space_point = pSender:convertToWorldSpace(inner_center_point)
                        local pos = self:convertToNodeSpace(world_space_point)
                        
                        local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_dungeon_event_"..type)
                        self:addChild(spr_effect, 1000)
                        spr_effect:setPosition(pos)
                        spr_effect:setScale(2.0)
                    end
                    
                    if flag == true then
                        self:updateEvent()
                        self:updateProps()
                    end
                end
            end

            break
        end
    end
    
end

-- 确认进入下一层
function DungeonLayer:onNextStageConfirm(tag, pSender)
    local max_stage = 0
    for k,v in pairs(cfg.shelterlevel.shelterlevel) do
        if v.shelter_stage > max_stage then
            max_stage = v.shelter_stage
        end
    end
    if ex.Player.dungeon_data.cur_stage >= max_stage then
        ex.MessageView:add(ex.Tools:getLang(41335))
        return
    end
    
    self.spr_bg_next_stage = cc.Sprite:createWithSpriteFrameName("dungeon/spr-bg-next-stage.png")
    self.spr_bg_next_stage:setAnchorPoint(cc.p(0.5, 0.5))
    self.spr_bg_next_stage:setScaleX(ex.p.width / self.spr_bg_next_stage:getContentSize().width)
    self.spr_bg_next_stage:setScaleY(ex.p.height / self.spr_bg_next_stage:getContentSize().height)
    self.spr_bg_next_stage:setPosition(ex.p.cx, ex.p.height * 1.5)
    self:addChild(self.spr_bg_next_stage, 9999)

    local action = cc.MoveTo:create(0.3, cc.p(ex.p.cx, ex.p.cy))
    action:setTag(1000)
    self.spr_bg_next_stage:runAction(action)

	NetManager:sendMessage(ProtocolID.GReqDungeonNextStage)
end

-- 响应进入下一层
function DungeonLayer:onNextStageDone()
    if self.spr_bg_next_stage == nil then
        return
    end

    -- local action = self.spr_bg_next_stage:getActionByTag(1000)
    -- local duration = 0.3
    -- if action ~= nil then
    --     self.spr_bg_next_stage:stopAllActions()

    --     duration = (self.spr_bg_next_stage:getPositionY() + ex.p.height * 0.5) / ex.p.height * 0.3
    -- end

    -- local action = cc.Sequence:create(cc.MoveTo:create(duration, cc.p(ex.p.cx, -ex.p.height * 0.5)), cc.RemoveSelf:create(), nil)
    local action = cc.Sequence:create(cc.FadeOut:create(0.3), cc.RemoveSelf:create(), nil)
    self.spr_bg_next_stage:runAction(action)

    self.spr_bg_next_stage = nil
end

-- 领取击杀奖励
function DungeonLayer:onKillReward(tag, pSender)
    if ex.Player.dungeon_data.lineup_hero_list == nil or #ex.Player.dungeon_data.lineup_hero_list <= 0 then
        return
    end

    -- 显示击杀奖励列表界面
    require("src.layer.DungeonKillRewardCtr"):instance():openWindow()
end

-- 使用道具
function DungeonLayer:onUseProps(tag, pSender)
    if ex.Player.dungeon_data.lineup_hero_list == nil or #ex.Player.dungeon_data.lineup_hero_list <= 0 then
        return
    end

    local props_type = 0
    if tag == 1 then
        self:onKillReward(tag, pSender)
        return
    elseif tag == 2 then
        props_type = 901602
    elseif tag == 3 then
        props_type = 901603
    elseif tag == 4 then
        props_type = 901604
    elseif tag == 5 then
        self:onShop(tag, pSender)
        return
    elseif tag == 6 then
        self:onEther(tag, pSender)
        return
    else 
        return
    end

    if props_type == 901602 or props_type == 901603 then
        -- 打开药水使用界面
        require("src.layer.DungeonPotionUseCtr"):instance():openWindow(props_type)
    elseif props_type == 901604 then
        -- 召唤商店
        local flag = ex.Player.dungeon_data:useProps(props_type)
        if flag == false then
            return
        end

        -- 刷新显示
        self:updateProps()
    end
end

-- 使用药剂成功
function DungeonLayer:onUsePotionSucceed(event, props_type, target_id)
    print("DungeonLayer:onUsePotionSucceed")
    if props_type == 901603 then
        -- 使用驱散药剂后，boss四周网格也爆裂
        for i,v in ipairs(ex.Player.dungeon_data.grid_list) do
            if v.grid_event_type < 0 and tonumber(v.grid_event_num) == tonumber(target_id) then
                v.grid_event_type = 0
                v.grid_event_num = 0
                self:onLightGridAround(v.grid_x, v.grid_y)
                break
            end
        end
    end
end

-- 打开商店界面
function DungeonLayer:onShop(tag, pSender)
    if ex.Player.dungeon_data.lineup_hero_list == nil or #ex.Player.dungeon_data.lineup_hero_list <= 0 then
        return
    end

    require("src.layer.DungeonShopListCtr"):instance():openWindow()
    -- ex.MainSceneCtr:instance():changeLayer(MainSceneType.MAINCITY_DUNGEON_SHOP)
end

-- 打开以太时空界面
function DungeonLayer:onEther(tag, pSender)
    if ex.Player.dungeon_data.lineup_hero_list == nil or #ex.Player.dungeon_data.lineup_hero_list <= 0 then
        return
    end

    ex.MessageView:add(ex.Tools:getLang(47726))
    return
end

-- 打开buff列表界面
function DungeonLayer:onBuffList(tag, pSender)
    if ex.Player.dungeon_data.lineup_hero_list == nil or #ex.Player.dungeon_data.lineup_hero_list <= 0 then
        return
    end

    require("src.layer.DungeonBuffListCtr"):instance():openWindow()
end

-- 选中英雄
function DungeonLayer:onSelectHero(tag, pSender)
    -- if ex.Player.dungeon_data.lineup_hero_list == nil or #ex.Player.dungeon_data.lineup_hero_list <= 0 then
    --     return
    -- end

end

-----------------------------------------------------------------------------
function DungeonLayer:updateKillRewardEffect()
    if self.layer_props == nil then
        return 
    end

    local menu = self.layer_props:getChildByName("menu")
    if menu == nil then
        return 
    end

    local item = menu:getChildByTag(1)
    if item == nil then
        return 
    end

    local effect = item:getChildByName("effect")
    -- 添加击杀祭祀激活特效
    if ex.Player.dungeon_data:IsAnyKillReward() then
        if effect ~= nil then
            effect:setVisible(true)
            return
        end

        -- 添加特效
        local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_dungeon_kill_reward")
        spr_effect:setName("effect")
        item:addChild(spr_effect, 100)
        local item_size = item:getContentSize()
        spr_effect:setPosition(cc.p(item_size.width / 2, item_size.height / 2))
    else
        if effect ~= nil then
            effect:setVisible(false)
            return
        end
    end
end

function DungeonLayer:onBattle(event, monster_level, hero_index) 
    local req_battle = Dungeon_pb.GReqDungeonBattleEnd()
    req_battle.monster_level = monster_level
    req_battle.hero_index = hero_index
    NetManager:sendMessage(ProtocolID.GReqDungeonBattleEnd, req_battle)

    -- 如果胜利，则取消对应怪物网格的事件
    for i, v in ipairs(ex.Player.dungeon_data.grid_list) do
        if v.grid_event_type < 0 and tonumber(v.grid_event_num) == monster_level then
            ex.Player.dungeon_data.cur_battle_grid_x = v.grid_x
            ex.Player.dungeon_data.cur_battle_grid_y = v.grid_y
            break
        end
    end
    ex.Player.dungeon_data.cur_battle_monster_idx = monster_level

    if cc.UserDefault:getInstance():getIntegerForKey("is_dungeon_battle_pass"..ex.Player.role_id) ~= 1 then
        local battle_layer = self:addBattleLayer(BattleType.DUNGEON,
                                                MainSceneType.MAINCITY_DUNGEON,
                                                "",
                                                EVENT.DUNGEON_EVENT.BATTLE_START, 
                                                function(layer, data)
                                                    ex.EventManager:fire(EVENT.DUNGEON_EVENT.BATTLE_END, data.isWin)
                                                    return true, false
                                                end)
    end
end

function DungeonLayer:onBattleEnd(event, is_win)
    print("ClanMissionLayer:onBattleEnd", is_win)
    ex.Tools:autoPlaySceneMusic()

    if is_win == true then
        ex.AudioManager:playEffect("music/shelter-win.mp3")
    else
        ex.AudioManager:playEffect("music/shelter-lose.mp3")
    end

    if is_win == true then
        self:onLightGridAround(ex.Player.dungeon_data.cur_battle_grid_x, ex.Player.dungeon_data.cur_battle_grid_y)
    end

    -- 显示战斗结算界面
    self:runBattleEndAction(is_win)
end

function DungeonLayer:runBattleEndAction(is_win)
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/battle-end-1.plist")
    sfc:addSpriteFrames("ccbi-res/battle-end-lang.plist")

    local result = 0
    if is_win == true then
        result = 1
    end

    local spr_result_bg = cc.Sprite:createWithSpriteFrameName("battle-end/spr-wing-"..result..".png")
    spr_result_bg.spr_result = cc.Sprite:createWithSpriteFrameName("battle-end-lang/lbl-result-"..result..".png")
    spr_result_bg.spr_result:setPosition(spr_result_bg:getContentSize().width / 2, spr_result_bg:getContentSize().height / 2)
    spr_result_bg:addChild(spr_result_bg.spr_result)
    spr_result_bg:setPosition(ex.p.cx, ex.p.height * 0.6)
    self:addChild(spr_result_bg, 10000)

    spr_result_bg:runAction(cc.Sequence:create(cc.FadeIn:create(0.3), cc.DelayTime:create(0.7), cc.FadeOut:create(0.5), cc.RemoveSelf:create(), nil))
    spr_result_bg.spr_result:runAction(cc.Sequence:create(cc.FadeIn:create(0.3), cc.DelayTime:create(0.7), cc.FadeOut:create(0.5), nil))

    if is_win == true then
        local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_battle_end")
        spr_effect:setPosition(spr_result_bg:getContentSize().width / 2, spr_result_bg:getContentSize().height / 2)
        spr_result_bg:addChild(spr_effect)
    end
end

return DungeonLayer
