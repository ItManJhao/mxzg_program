--[[
* @Description: 爱丽丝仙境挑战界面
* @Author: 周向阳
* @Date: 2020-08-23 16:42:00
* ]]

local AliceWonderlandChallengeCtr = class("AliceWonderlandChallengeCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local AliceWonderlandChallengeLayer = class("AliceWonderlandChallengeLayer", require("src.layer.ui.UI_AliceWonderlandChallengeLayer"))
local AliceWonderlandChallengeCell = class("AliceWonderlandChallengeCell", require("src.layer.ui.UI_AliceWonderlandChallengeCell"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
------------------------------------------------
function AliceWonderlandChallengeCell:onCreate()
	self.super.onCreate(self)
	self:setName("AliceWonderlandChallengeCell")
	self:setSwallowsTouches(false)
end

function AliceWonderlandChallengeCell:initData(data)
	self.lbl_team_name:setString(ex.Tools:getLang(data.lang_id))
	self.lbl_fitting_num:setString(tostring(data.fighting))
	local hero_list = ex.Player.hero_data.hero_list

	self.team_scroll_view.createItemFunction =  function(hero_data)
		local elem = cfg.herotype.star[hero_data.hero_type].elem
		local item = UIMenuItemHero:createWithData("0", hero_data.hero_type, elem, hero_data.hero_level, hero_data.hero_star)
		item:setScale(0.7)
        return item
	end
	self.team_scroll_view:reloadData(data.heros)
end

---------------------------------------------------------------------------------
function AliceWonderlandChallengeLayer:onCreate()
	self.super.onCreate(self)
	self:setName("AliceWonderlandChallengeLayer")
	
end

function AliceWonderlandChallengeLayer:initData(tag)
	self.level_tag = tag
	self:addEvent(EVENT.ALICE.ALICE_UPDATE_RED_POINT, handler(self, self.updataRedPoint))
	self:updataRedPoint()
	self:updataLayer()
	-- self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(handler(self, self.updataLayer))))
end

function AliceWonderlandChallengeLayer:updataRedPoint()
	ex.Tools:addRedPoint(self.btn_select_gain, ctr.alice.data:getSurplusSkillPoint(), ex.r.p8)
end

function AliceWonderlandChallengeLayer:updataLayer()
	ex.Tools:setSpriteFrame(self.spr_banner_bg, string.format("alice/banner-bg-%d.png", self.level_tag) )
	local enemy_attr = ctr.alice.data:getEnemyAttr()
	if enemy_attr then
		for i,v in ipairs(enemy_attr) do
			self["spr_random_"..i]:setVisible(false)
			self["spr_add_"..i]:setVisible(true)
			self["lbl_add_attr_show_"..i]:setString(string.format(ex.Tools:getLang(580073),ex.Tools:getAttrTextOnly(v.attr), (v.value / 100)))
		end 
	end
	local monster_list = ctr.alice.data:getMonsterLineup(self.level_tag)
	local Max_lineup_num = #monster_list
	for i,v in ipairs(monster_list) do
		local cell = AliceWonderlandChallengeCell:create()
		cell:setName("cell")
		cell:setAnchorPoint(0, 1)
		cell:setPosition(0, (0 - ((i - 1) * cell:getContentSize().height)))
		cell:initData(v)
		self.team_node:addChild(cell)
		self.team_bg:setContentSize(self.team_bg:getContentSize().width, cell:getContentSize().height * i + 10)
	end
	-- for i=1,Max_lineup_num do
	-- local cell = AliceWonderlandChallengeCell:create()
	-- cell:setName("cell")
	-- cell:setAnchorPoint(0.5, 0.5)
	-- cell:setPosition(0,0)
	-- cell:initData()
	-- -- cell
	
	-- dump(cell:getPosition())
		
	-- end
	-- self.team_bg:setContentSize()

	local star_data = ctr.alice.data:getNowStarCongigData()
	local Max_lineup_num = 1
	for k,v in pairs(star_data) do
		if v.elem == self.level_tag then
			self.lbl_name:setString(ex.Tools:getLang(v.lan_id))
			Max_lineup_num = v.line_up_num
		end
	end
	
	self.lbl_attr_node:setPositionY(self.team_bg:getPositionY() - self.team_bg:getContentSize().height - 20)
end

function AliceWonderlandChallengeLayer:onItem(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

--布阵
function AliceWonderlandChallengeLayer:onChangeLineup()
	require("src.layer.alice.AliceChangeLineupCtr"):instance():openWindow(ex.Tools:getLang(47546),
																			ex.Tools:getLang(47649),
																			BattleType.ALICE_TEAM_ONE)
end

--挑战
function AliceWonderlandChallengeLayer:onBattle()
	local can_battle = true
	local lineup_num = ctr.alice.data:getLineupNumByStar()
	local is_hero_list = {}
	for i=1,lineup_num do
		is_hero_list[i] = {}
		local lineup_data = ex.Player.lineup_data:getLineup(38+i)
		if lineup_data then
			for k,v in ipairs(lineup_data.hero_list) do
				if v.hero_id ~= 0 then
					table.insert( is_hero_list[i], v.hero_id )
				end
				
			end
		else
			can_battle = false
			break
		end
		
		if not is_hero_list[i] or #is_hero_list[i] == 0 then
			can_battle = false
			break
		end
	end
	
	if can_battle then
		local now_level_data = ctr.alice.data:getNowStarCongigData()
		local level_idx = 0
		for i,v in ipairs(now_level_data) do
			if v.elem == self.level_tag then
				level_idx = v.idx
				break
			end
		end
		print(level_idx)
		local req = Alice_pb.GReqChallengeLevel()
		req.level = level_idx
		NetManager:sendMessage(ProtocolID.GReqChallengeLevel, req)
		self:onClose()
	else
		ex.MessageView:add(string.format(ex.Tools:getLang(580566),lineup_num))
	end
	
end

function AliceWonderlandChallengeLayer:onSelectGain(tag, pSender)
	require("src.layer.alice.AliceBuffSelectCtr"):instance():openWindow()
end

function AliceWonderlandChallengeLayer:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(580040), ex.Tools:getLang(580057))
end

-----------------------------------------------
function AliceWonderlandChallengeCtr:loadLayer()
	local tmp_layer = AliceWonderlandChallengeLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function AliceWonderlandChallengeCtr:onCreate()
	self:setIsSingle(false)
end

function AliceWonderlandChallengeCtr:openWindow(tag)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer:initData(tag)
end

return AliceWonderlandChallengeCtr
