local AliceBattleLogCtr = class("AliceBattleLogCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local AliceBattleLogLayer = class("AliceBattleLogLayer", require("src.layer.ui.UI_AliceBattleLogLayer"))
local AliceBattleLogTeamCell = class("AliceBattleLogTeamCell", require("src.layer.ui.UI_AliceBattleLogTeamCell"))

local UIItemHero = require("src.comp.menu.UIMenuItemHero")

function AliceBattleLogTeamCell:onCreate()
    self.super.onCreate(self)
	self:setName("AliceBattleLogTeamCell")

    self:setAnchorPoint(cc.p(0.5, 0.5))
    self:setIgnoreAnchorPointForPosition(false)
end

function AliceBattleLogTeamCell:resetData(data)
	self.lbl_title:setString(ex.Tools:getLang(580078 + data.team_idx))

    for hero_idx,hero_data in ipairs(data.alice_hero) do
		local item = UIItemHero:createWithData("1", hero_data.hero_type, 1, hero_data.level, hero_data.star)
		self.menu_item:addChild(item)
	end
end

------------------------------------------------
function AliceBattleLogLayer:onCreate()
	self.super.onCreate(self)
	self:setName("AliceBattleLogLayer")

	self:addBlackBackground()

    self.scroll_view.createItemFunction = function(data, scale)
		local item = AliceBattleLogTeamCell:create()
		item:resetData(data)
		return item
	end
end

function AliceBattleLogLayer:updateLayer(data)
	-- 顯示地方特殊增益
	local size = self.node_buff_enermy:getContentSize()
	size.height = size.height - 50
	local vec_enemy_attr = {}
	table.insert(vec_enemy_attr, {0})
	for _,v in ipairs(data.enemy_attr) do
		local config = cfg.aliceenemyattr.aliceenemyattr[v]
		if config.type ~= 1 then
			table.insert(vec_enemy_attr, v)
		end
	end
	for idx,attr in ipairs(vec_enemy_attr) do
		local node_item = cc.Node:create()
		node_item:setPosition(0, size.height - (idx - 0.5) * 30)
		self.node_buff_enermy:addChild(node_item)

		local spr_type = cc.Sprite:createWithSpriteFrameName(idx == 1 and "alice/spr-red.png" or "alice/spr-orange.png")
		spr_type:setAnchorPoint(cc.p(0, 0.5))
		spr_type:setPosition(0, 0)
		node_item:addChild(spr_type, 5)

		local lbl_type = cc.Label:createWithTTF(idx == 1 and ex.Tools:getLang(580054) or ex.Tools:getLang(580055), FONT_DEFAULT_NAME_BOLD, 20)
		lbl_type:setColor(cc.c3b(255,255,255))
		lbl_type:setPosition(25, 0)
		node_item:addChild(lbl_type, 10)

		local config = cfg.aliceenemyattr.aliceenemyattr[attr]
		local str_content = config == nil and ex.Tools:getLang(580058) or string.format(ex.Tools:getLang(580073), ex.Tools:getLang(2150000 + config.add_attr[1].attr), config.add_attr[1].value / 100)
		local lbl_content = cc.Label:createWithTTF(str_content, FONT_DEFAULT_NAME_BOLD, 20)
		lbl_content:setColor(cc.c3b(192,178,157))
		lbl_content:setAnchorPoint(cc.p(0, 0.5))
		lbl_content:setPosition(60, 0)
		node_item:addChild(lbl_content, 10)
	end

	-- 顯示大神選擇增益
	local size = self.node_buff_self:getContentSize()
	size.height = size.height - 50
	for idx,attr in ipairs(data.player_attr) do
		local node_item = cc.Node:create()
		node_item:setPosition(0, size.height - (idx - 0.5) * 30)
		self.node_buff_self:addChild(node_item)
		
		local config = cfg.aliceplayerattr.aliceplayerattr[attr]
		if config ~= nil then
			local spr_buff_num_bg = cc.Sprite:createWithSpriteFrameName("alice/spr-circle.png")
			spr_buff_num_bg:setAnchorPoint(cc.p(0, 0.5))
			spr_buff_num_bg:setPosition(0, 0)
			node_item:addChild(spr_buff_num_bg, 5)
			
			local lbl_buff_num = cc.Label:createWithTTF(config.cost_point, FONT_DEFAULT_NAME_BOLD, 20)
			lbl_buff_num:setColor(cc.c3b(255,255,255))
			lbl_buff_num:setPosition(13, 0)
			node_item:addChild(lbl_buff_num, 10)
			
			local spr_buff_icon = cc.Sprite:createWithSpriteFrameName("backpack-info/spr-attribute-"..config.add_attr[1].attr..".png")
			if spr_buff_icon then
				spr_buff_icon:setScale(0.5)
				spr_buff_icon:setPosition(50, 0)
				node_item:addChild(spr_buff_icon, 5)
			end
			
			local str_content = string.format(ex.Tools:getLang(580073), ex.Tools:getLang(2150000 + config.add_attr[1].attr), config.add_attr[1].value / 100)
			local lbl_content = cc.Label:createWithTTF(str_content, FONT_DEFAULT_NAME_BOLD, 20)
			lbl_content:setColor(cc.c3b(244,225,215))
			lbl_content:setAnchorPoint(cc.p(0, 0.5))
			lbl_content:setPosition(70, 0)
			node_item:addChild(lbl_content, 10)
		end
	end

	-- 顯示通關陣容
	for team_idx,team_data in ipairs(data.line_up) do
		data.line_up[team_idx].team_idx = team_idx
	end
	self.scroll_view:reloadData(data.line_up)
end

-----------------------------------------------
function AliceBattleLogCtr:loadLayer()
    local tmp_layer = AliceBattleLogLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function AliceBattleLogCtr:onCreate()
	self:setIsSingle(false)
end

function AliceBattleLogCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/backpack-info.plist")

	self:loadLayer()
	self:open()
    self:initData(data)
end

function AliceBattleLogCtr:initData(data)
	self.layer:updateLayer(data)
end

return AliceBattleLogCtr
