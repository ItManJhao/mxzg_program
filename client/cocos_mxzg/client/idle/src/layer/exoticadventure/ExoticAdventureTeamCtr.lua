--[[
* @Description: 异界冒险-我的队伍
* @Author: 熊梦
* @Date: 2020-08-3 20:00:00
* ]]
local ExoticAdventureTeamCtr = class("ExoticAdventureTeamCtr",require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ExoticAdventureTeamLayer = class("ExoticAdventureTeamLayer",require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function ExoticAdventureTeamLayer:onCreate()
    self:addBlackBackground()
	self:registerBtnEvent()
	self:inidata()
end

-- 关闭按钮
function ExoticAdventureTeamLayer:registerBtnEvent( )
	local ctr = ExoticAdventureTeamCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))
end

function ExoticAdventureTeamLayer:inidata()

	self.menu_hero_1 = cpp.UIMenu:create()
    self.menu_hero_1:setPosition(0, 0)
    self.menu_hero_1:setSwallowsTouches(false)
    self.menu_hero_1:setLocalZOrder(1)
	self.node_hero_1:addChild(self.menu_hero_1)

	self.menu_hero_2 = cpp.UIMenu:create()
    self.menu_hero_2:setPosition(0, 0)
    self.menu_hero_2:setSwallowsTouches(false)
    self.menu_hero_2:setLocalZOrder(1)
	self.node_hero_2:addChild(self.menu_hero_2)

	local node_pos_list1 ={self.node_pos_1_1, self.node_pos_1_2, self.node_pos_1_3, self.node_pos_1_4, self.node_pos_1_5, self.node_pos_1_6}
	local node_pos_list2 ={self.node_pos_2_1, self.node_pos_2_2, self.node_pos_2_3, self.node_pos_2_4, self.node_pos_2_5, self.node_pos_2_6}
	self.node_pos_list = {node_pos_list1,node_pos_list2}
	-- 更新显示英雄列表
	local battletype = {BattleType.EXOTIC_ADVENTURE_POWER,BattleType.EXOTIC_ADVENTURE_ARMS}
	for i=1,2 do
		local battle_config = cfg.battletype.battletype[battletype[i]]
		local vec_selected, fetter_type = ex.Player.lineup_data:getIdList(battle_config.save_line_up_type, {NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID})
	
		local vec_hero = {}
		for i,v in ipairs(vec_selected) do
			local hero_data = ex.Player.hero_data:getHeroDataById(v)
			if hero_data ~= nil then
				table.insert(vec_hero, hero_data)
			end
		end
		self:updataHero(i,vec_hero)
	end
	--self:updataHero(2,vec_hero)
end

function ExoticAdventureTeamLayer:updataHero(idx,vec_hero)
	-- self.btn_head:getNormalImage():setSpriteFrame(string.format("head-icon/%d.png", vec_hero.member.head_id))
    -- self.border:setSpriteFrame(ex.Tools:getBorderIconByIdx(self.data.member.border_id))

    -- local img_size = self.btn_head:getNormalImage():getContentSize()
    -- local btn_scale = self.btn_head:getScale()
    -- self.btn_head:setPosition(cc.p((120 - img_size.width) * btn_scale / 2, (120 - img_size.height) * btn_scale / 2))
    -- self.border:setPosition(img_size.width / 2, img_size.height / 2)

    -- self.lbl_level:setString(self.data.member.level)
    -- self.lbl_name:setString(self.data.member.nick)
    -- self.lbl_power:setString(self.data.fighting)
	
    local index = 1
    for i, v in ipairs(vec_hero) do
		if self.node_pos_list ~= nil and self.node_pos_list[idx] ~= nil and self.node_pos_list[idx][index] ~= nil then
			local node_pos = self.node_pos_list[idx][index]
			node_pos:setVisible(false)

			local hero_config = cfg.herotype.star[v.hero_type]
			local item = UIMenuItemHero:createWithData(v.hero_id, v.hero_type, hero_config ~= nil and hero_config.elem or 0, v.level, v.star)
			item.local_data = v
			item:setScale(0.7)
			item:setPosition(node_pos:getPosition())
			self["menu_hero_"..idx]:addChild(item)
			item:registerScriptTapHandler(handler(self, self.onHero))
		end

		index = index + 1
	end
	
	--self.lbl_power:setString(self.data.fighting)
end

function ExoticAdventureTeamLayer:onHero(tag, pSender)
    ex.Tools:showHeroInfo(ex.Player.role_id, nil, pSender.hero_id)
end

-----------------------------------------------------------------------------
function ExoticAdventureTeamCtr:onCreate()
	self:setCCBIPath("ccbi/ExoticAdventureTeamLayer.ccbi")
	self:setIsSingle(false)
end

function ExoticAdventureTeamCtr:getLayerClass()
	return ExoticAdventureTeamLayer
end

function ExoticAdventureTeamCtr:getAchievementLayer()
	return self.layer
end

function ExoticAdventureTeamCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
end

function ExoticAdventureTeamCtr:initData()

end

return ExoticAdventureTeamCtr
