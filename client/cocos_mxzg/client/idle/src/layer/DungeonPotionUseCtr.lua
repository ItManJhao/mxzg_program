local DungeonPotionUseCtr = class("DungeonPotionUseCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local DungeonPotionUseLayer = class("DungeonPotionUseLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenu = require("src.comp.menu.UIMenu")
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function DungeonPotionUseLayer:onCreate()
	self:addBlackBackground()
	self.selected_index = "0"

	self.btn_confirm:setLabelText(ex.Tools:getLang(47473))
    self.btn_confirm:setLabelSize(36)
	self.btn_confirm:setLabelColor(FONT_BROWN)
    self.btn_confirm:setLabelScale(0.5)
	
	self.btn_cancel:setLabelText(ex.Tools:getLang(47703))
    self.btn_cancel:setLabelSize(36)
    self.btn_cancel:setLabelColor(FONT_BROWN)
    self.btn_cancel:setLabelScale(0.5)
end

function DungeonPotionUseLayer:showTarget(target_type)
	self.target_type = target_type
	
	if self.menu_selected == nil then
		self.menu_selected = UIMenu:create();
		self.menu_selected:setPosition(cc.p(0, 0));
		self.menu_selected:setName("menu_selected")
		self:addChild(self.menu_selected)
	end
	self.menu_selected:removeAllChildren()

	if target_type == 1 then
		-- 目标为英雄
		local item_count = table.nums(ex.Player.dungeon_data.lineup_hero_list)
		local item_size = cc.size(120, 120)
		local item_scale = 0.7
		local start_pos_x = (self:getContentSize().width - (item_size.width * item_scale + 5) * item_count) / 2

		for i,v in pairs(ex.Player.dungeon_data.lineup_hero_list) do
            local hero_data = ex.Player.dungeon_data:getTeamHeroInfoDataById(v.hero_id)
			local item = UIMenuItemHero:createWithData(hero_data.hero_id, hero_data.hero_type, hero_data.elem, hero_data.level, hero_data.star)
			item:setEnableAction(false)
			item:registerScriptTapHandler(handler(self, self.onSelectTarget))
			item.target_id = v.index
			item:setScale(item_scale)
			item:setPosition(start_pos_x + (i - 0.5) * (item_size.width * item_scale + 5), 160)
			self.menu_selected:add(item)

			-- print("self.selected_index, v:", self.selected_index, v)
			if ((self.selected_index == "0" or tonumber(self.selected_index) == tonumber(v.index))) and tonumber(v.hero_rate) > 0 then
				self.selected_index = v.index
                item:setSelected(true)
            end

            if tonumber(v.hero_rate) <= 0 then
                local spr_die = cc.Sprite:createWithSpriteFrameName("other/lbl-dead.png")
                spr_die:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
                spr_die:setLocalZOrder(100)
                item:addChild(spr_die)
                if item.spr_hero_icon then
                    item.spr_hero_icon:setColor(FONT_GRAY)
                end
				
				item:setEnabled(false)
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

            item.progress:setPercentage(v.hero_rate / 100)
		end
	else
		-- 目标为怪物
		local vec_monster_level = {}
		for k,v in pairs(ex.Player.dungeon_data.grid_list) do
			if v.is_open > 0 and v.grid_event_type < 0 then
				table.insert(vec_monster_level, tonumber(v.grid_event_num))
			end
		end

		if table.nums(vec_monster_level) > 1 then
			local tmp_vec = vec_monster_level
			vec_monster_level = {}
			for k,v in pairs(tmp_vec) do
				if v < 5 then
					table.insert(vec_monster_level, v)
				end
			end
		end

		-- dump(vec_monster_level, "vec_monster_level")
		local item_count = table.nums(vec_monster_level)
		-- local item_size = cc.size(100, 100)
		local item_size = cc.size(110, 110)
		local item_scale = 1 - 0.4 * (item_count / 5)
		local start_pos_x = (self:getContentSize().width - (item_size.width * item_scale + 5) * item_count) / 2
		-- self.menu_selected:setScale(380 / (item_count * (item_size.width + 5)))

		for i, v in ipairs(vec_monster_level) do
			local config = ex.Player.dungeon_data:getMonsterByStageAndLevel(ex.Player.dungeon_data.cur_stage, tonumber(v))
			local item = nil
            if config ~= nil then
				item = UIMenuItemHero:createWithData("1", config.hero_type, nil, config.hero_level, config.hero_star)
			else
				local str_item = string.format("dungeon/monster-frame-%d.png", v)
				item = cpp.UIMenuItemImage:createWithSpriteFrameName(str_item, str_item, str_item)
			end
            item:setEnableAction(false)
			item:registerScriptTapHandler(handler(self, self.onSelectTarget))
            item.target_id = tostring(v)
			item:setScale(item_scale)
			item:setPosition(start_pos_x + (i - 0.5) * (item_size.width * item_scale + 5), 160)
			self.menu_selected:add(item)

			if self.selected_index == "0" or tonumber(self.selected_index) == tostring(v) then
				self.selected_index = tostring(v)
				item:setSelected(true)
			end
		end
	end
end

function DungeonPotionUseLayer:onSelectTarget(tag, pSender)
	-- print("DungeonPotionUseLayer:onSelectTarget", pSender.target_id)
	self.selected_index = pSender.target_id

	-- 刷新选中项显示
	local vec_child = self.menu_selected:getChildren()
	if self.target_type == 1 then
		for i, v in ipairs(vec_child) do
			if v:isEnabled() == true then
				v:setSelected(v.target_id == self.selected_index)
			end
		end
	else
		for i, v in ipairs(vec_child) do
			v:setSelected(tonumber(v.target_id) == tonumber(self.selected_index))
		end
	end
end

-----------------------------------------------------------------------------
function DungeonPotionUseCtr:onCreate()
	self:setCCBIPath("ccbi/DungeonPotionUseLayer.ccbi")
	self:setIsSingle(false)
end

function DungeonPotionUseCtr:getLayerClass()
	return DungeonPotionUseLayer
end

function DungeonPotionUseCtr:getDungeonPotionUseLayer()
	return self.layer
end

function DungeonPotionUseCtr:openWindow(props_type)
	if self:isOpened() then
		return
	end

	self.props_type = props_type
	self.props_num = ex.Player.dungeon_data:getPropsNum(self.props_type)

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/dungeon.plist")

	self:loadLayer()
	self:open()
	self:initData()
end

function DungeonPotionUseCtr:initData()
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
	self.layer.btn_cancel:registerScriptTapHandler(handler(self, self.onCancel))
	
	self:updateLayer()
end

function DungeonPotionUseCtr:updateLayer()
	if not self:getLayer() then
		return
	end

	self.layer.spr_potion:setSpriteFrame("backpack/"..self.props_type..".png")
	self.layer.lbl_name:setString(ex.Tools:getLang(cfg.item.item[self.props_type].name))
	self.layer.lbl_intro:setString(ex.Tools:getLang(self.props_type - 100000))
	if self.props_type == 901602 then
		self.layer:showTarget(1)
	elseif self.props_type == 901603 then
		self.layer:showTarget(2)
	end
end

function DungeonPotionUseCtr:onCancel()
	self:closeWindow(0, nil)
end

function DungeonPotionUseCtr:onConfirm(tag, pSender)
	-- print("DungeonPotionUseCtr:onConfirm", self.props_type, self.layer.selected_index)
	local props_num = ex.Player.dungeon_data:getPropsNum(self.props_type)
	if props_num <= 0 then
		ex.MessageView:add(ex.Tools:getLang(47143))
		return
	end

	if tonumber(self.layer.selected_index) == 0 then
		ex.MessageView:add(ex.Tools:getLang(47680))
		return
	end

	-- 如果是弥散药剂，则在其他怪物未死亡的情况下无法杀死boss
	if self.props_type == 901603 then
		local monster_num = 0
		for k,v in pairs(ex.Player.dungeon_data.grid_list) do
			if v.is_open > 0 and v.grid_event_type < 0 then
				monster_num = monster_num + 1
				if tonumber(self.layer.selected_index) == 5 and tonumber(v.grid_event_num) ~= 5 then
					ex.MessageView:add(ex.Tools:getLang(47435))
					return
				end
			end
		end

		if monster_num <= 0 then
			ex.MessageView:add(ex.Tools:getLang(47144))
			return
		end
	end
	-- 如果是生命药剂，英雄满血状态下无法使用
	if self.props_type == 901602 then
		for i,v in pairs(ex.Player.dungeon_data.lineup_hero_list) do
			if tonumber(v.index) == tonumber(self.layer.selected_index) then
				if tonumber(v.hero_rate) <= 0 then
					ex.MessageView:add(ex.Tools:getLang(47612))
					return
				elseif tonumber(v.hero_rate) >= 10000 then
					ex.MessageView:add(ex.Tools:getLang(47474))
					return
				end
				break
			end
		end
	end
	ex.Player.dungeon_data:useProps(self.props_type, self.layer.selected_index)
	ex.EventManager:fire(EVENT.DUNGEON_EVENT.PROPS_INFO)

	self:updateLayer()

	if self.props_type == 901603 then
		local monster_num = 0
		for k,v in pairs(ex.Player.dungeon_data.grid_list) do
			if v.is_open > 0 and v.grid_event_type < 0 then
				monster_num = monster_num + 1
			end
		end
		if monster_num > 0 then
			self:closeWindow(0, nil)
		end
	end
end

return DungeonPotionUseCtr
