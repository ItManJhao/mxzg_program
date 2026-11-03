local TrialInfoCtr = class("TrialInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local TrialInfoLayer = class("TrialInfoLayer", require("src.comp.LuaLayerBase"))
-- local TrialBattleLayer = class("TrialBattleLayer", require("src.comp.LuaBattleLayer"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")


function TrialInfoLayer:onCreate()
	print("TrialInfoLayer:onCreate")
	-- self.btn_start:registerScriptTapHandler(handler(self, self.onStartFight))
    -- self:createEmenyHero()
    self:addBlackBackground()

    self:reorderChild(self.menu_hero, 100)
end

function TrialInfoLayer:updateLblTitle(mission_id)
    self.lbl_title:setString(string.format( ex.Tools:getLang(72045), mission_id))
end

function TrialInfoLayer:showBtnString(tag)
    local mission_id = ex.Player.trial_data:getMissionId()
    local battle_data = ex.Player.trial_data:getBattleData(mission_id)

    local str = (mission_id == tag and (battle_data ~= nil and battle_data.status == TRIAL_BOX.CAN_GET)) and ex.Tools:getLang(47064) or ex.Tools:getLang(47589)
	local btn_size = self.btn_start:getContentSize()
	local lbl_btn_txt = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 26)
	:enableOutline(FONT_DARK_BLUE, 2)
	:setPosition(btn_size.width/2, btn_size.height/2 + 3)
	self.btn_start:addChild(lbl_btn_txt)
end

function TrialInfoLayer:updateMatrix(matrix_type)
    local item_list = {}
    local config_addition = cfg.battlematrixaddition.battlematrixaddition
    for i,v in ipairs(config_addition) do
        if v.type == matrix_type then
            table.insert(item_list, v)
        end
    end

    -- 显示锁状态及属性加成
    for i,v in ipairs(item_list) do
        if self["spr_lock_"..v.position] ~= nil then
            self["spr_lock_"..v.position]:setVisible(v.is_open <= 0)
        end
    end
end

function TrialInfoLayer:createEmenyHero(data, matrix_type)
    self:updateMatrix(matrix_type)
    -- if not data then return end
    self.menu_hero:removeAllChildren()

    local item_list = {}
    local config_addition = cfg.battlematrixaddition.battlematrixaddition
    for i,v in ipairs(config_addition) do
        if v.type == matrix_type then
            table.insert(item_list, v)
        end
    end

    local scale = 0.8
    for i=1, LineupNum do
        local hero_data = TableEx.findValueFunction(data, function(value)
            return value.pos == i
        end)

        local is_unlock = true
        for _,v in ipairs(item_list) do
            if v.position == i then
                is_unlock = v.is_open > 0
            end
        end

        if is_unlock then
            local level = hero_data and (hero_data.hero_level or hero_data.level) or 0
            local star = hero_data and (hero_data.hero_star or hero_data.star) or 0
            local hero_type = hero_data and (hero_data.hero_type or hero_data.type) or 0
            local elem = hero_data and hero_data.elem or 0
            local item = UIMenuItemHero:createWithData(0, 0, 0, 0)
            item:setPosition(self["node_icon_" .. i]:getPosition())
            -- :registerScriptTapHandler(handler(self, self.onClickTaskHero))
            self.menu_hero:addChild(item)
            -- item:setEnabled(false)

            local tmp_data = {}
            tmp_data.level = level
            tmp_data.star = star
            tmp_data.hero_type = hero_type
            tmp_data.elem = elem
            item:reset(tmp_data)
            item:resetBg(nil, nil)
            item:setScale(scale)

            if hero_data then
                item:setCompleted(hero_data.hp, hero_data.max_hp, false)
            end
        end
    end
end

function TrialInfoLayer:createReward(data)
    self.menu_reward:removeAllChildren()

	if not data then return end
    local margin = 10
	local max_width = self.spr_bg:getContentSize().width
    local item_size = UIMenuItemHero:createWithData(0, 0, 0, 0)
    item_size = item_size:getContentSize()
    local length = #data.reward
    local reward_data = data.reward

    local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
    local scale = 0.8
    for i=1,length do
    	local item = UIMenuItemBackpack:createWithData(reward_data[i].item_type, reward_data[i].item_num)
        item:setPosition((item_size.width + margin) * (i - 0.5 - length / 2), 0)
        item:registerScriptTapHandler(handler(self, self.onClickItem))
        item:setScale(scale)
        self.menu_reward:add(item)
    end
end

function TrialInfoLayer:upIcon(data)
    local sfc = cc.SpriteFrameCache:getInstance()
    local frame = sfc:getSpriteFrame(string.format("head-icon/%d.png", data.def_head_id));
    if frame == nil then
        frame = sfc:getSpriteFrame("head-icon/0.png");
    end

    self.spr_photo:setSpriteFrame(frame)

    local border = sfc:getSpriteFrame(ex.Tools:getBorderIconByIdx(data.def_border_id))
    self.spr_frame:setSpriteFrame(border)

    self.lbl_level:setString(data.def_level)
    self.lbl_name:setString(data.def_nick)
    self.lbl_bat:setString(data.def_fighting)
end

function TrialInfoLayer:onClickItem(tag , pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function TrialInfoCtr:onCreate()
	self:setCCBIPath("ccbi/TrialInfoLayer.ccbi")
	self:setIsSingle(false)
end

function TrialInfoCtr:getLayerClass()
	return TrialInfoLayer
end

function TrialInfoCtr:openWindow(emeny_data,tag,callback)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(emeny_data,tag,callback)
end

function TrialInfoCtr:initData(emeny_data,tag,callback)
	-- dump(emeny_data)
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	-- self.layer.btn_start:registerScriptTapHandler(handler(self, self.onStartFight))
	self.layer.btn_start:registerScriptTapHandler(handler(self, self.onBattle))
	self.layer.tag = tag
	self.layer.emeny_data = emeny_data.hero_data
	self.layer.callback = callback
    self.layer:showBtnString(tag)
	self.layer:createEmenyHero(self.layer.emeny_data, emeny_data.def_formation_id)
    local reward_data = {}
    local show_mission_id = 1
    for i,v in ipairs(cfg.adventurereward.reward) do
        if v.mission == tag and v.level == ex.Player.trial_data.hard_lv then
            reward_data = v
            show_mission_id = v.show_mission
            break
        end
    end
    self.layer:createReward(reward_data)
    self.layer:upIcon(emeny_data)
    self.layer:updateLblTitle(show_mission_id)
end

function TrialInfoCtr:onBattle(tag, pSender)

	local mission_id = self.layer.emeny_data[1].mission_id
    local cur_mission = ex.Player.trial_data:getMissionId()
    local battle_data = ex.Player.trial_data:getBattleData(cur_mission)

	print(self.__cname, mission_id, cur_mission)

    -- local cur_pos = ex.Player.trial_data:getCurPos()
    -- local pos_data = ex.Player.trial_data:getPosData(self.layer.tag)
    -- dump(pos_data)
    -- print("cur_pos", cur_pos)
    -- dump(pos_data, "pos_data")
    if self.layer.tag == cur_mission and (battle_data == nil or battle_data.status == TRIAL_BOX.CAN_GET) then 
    -- if mission_id == mission_cur then
        local vec_friend_hero = {}
        for i,v in ipairs(ex.Player.trial_data.select_friend_hero) do
            table.insert(vec_friend_hero, v.hero_data)
        end
        
	    require('src.layer.HeroSelectCtr'):instance():openWindow(ex.Tools:getLang(47524),
	                                                             ex.Tools:getLang(47064),
	                                                             BattleType.TRIAL,
                                                                 handler(self, self.onBattleDone),
                                                                 ex.Player.trial_data.vec_hp_left,
                                                                 vec_friend_hero)
        require('src.layer.HeroSelectCtr'):instance():setFriendHeroMax(1)
	else
		self:closeWindow(0, nil)
	end
end

function TrialInfoCtr:onBattleDone(vec_hero, fetter_type)
    local layer = self.layer
    if layer.is_battle then
        self:closeWindow(0, nil)
        return
    end

    layer.is_battle = true

    if layer.callback then
        layer.callback(vec_hero, fetter_type)
    end
    self:closeWindow(0, nil)

    --local layer = self.layer
    --cur_layer:createBattle(layer.stage, vec_hero)
end


return TrialInfoCtr