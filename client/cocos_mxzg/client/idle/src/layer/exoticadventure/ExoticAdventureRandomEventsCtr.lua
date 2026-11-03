--[[
* @Description: 异界冒险-触发事件页面
* @Author: 熊梦
* @Date: 2020-08-3 14:00:00
* ]]
local ExoticAdventureRandomEventsCtr = class("ExoticAdventureRandomEventsCtr",require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ExoticAdventureRandomEventsLayer = class("ExoticAdventureRandomEventsLayer",require("src.comp.EventLayerAdaptiveWidthFull"))

function ExoticAdventureRandomEventsLayer:onCreate()
	self:setAutoClose(false)
	self:addBlackBackground()
	self:registerEvent()
	self:inidata()
end

function ExoticAdventureRandomEventsLayer:inidata()
	-- 播放彩带爆炸
	local spr_effect_bomb = ex.EffectFactory:createEffectWithNodeByName("eff_reward_bomb")
	self.node_spin:addChild(spr_effect_bomb)

	local idx = ex.Player.exotic_adventure_data.event_type
	-- self.spr_icon:setSpriteFrame(string.format("exotic-adventure/exotic-adventure-spr-shijian-%d.png", idx))
	ex.Tools:setSpriteFrame(self.spr_icon, string.format("exotic-adventure/exotic-adventure-spr-shijian-%d.png", idx))

	self.node_consume:setVisible(false)

	local con = cfg.spacetimeevent.spacetimeevent[idx]

	self.lbl_name:setString(ex.Tools:getLang(con.nick_language_id))

	self.lbl_details:setString(ex.Tools:getLang(con.details_language_id))


	if idx == 101 then			--舰队残骸
		self.menu_type2:setVisible(false)
		self.menu_type1:setVisible(true)
		self.btn_type1_sure:setLabelText(ex.Tools:getLang(5341))
	elseif idx == 102 then		--舰队残骸（怪物）
		self.menu_type2:setVisible(true)
		self.menu_type1:setVisible(false)
		self.btn_type2_sure:setLabelText(ex.Tools:getLang(47212))
		-- 进入布阵界面
	elseif idx == 103 then		--其他舰队
		self.menu_type2:setVisible(true)
		self.menu_type1:setVisible(false)
		self.btn_type2_sure:setLabelText(ex.Tools:getLang(76551))
	elseif idx == 104 then		--隐藏航线
		self.menu_type2:setVisible(false)
		self.menu_type1:setVisible(true)
		self.btn_type1_sure:setLabelText(ex.Tools:getLang(2401))
	elseif idx == 105 then		--风暴降临
		self.menu_type2:setVisible(false)
		self.menu_type1:setVisible(true)
		self.btn_type1_sure:setLabelText(ex.Tools:getLang(2401))
	elseif idx == 106 then		--土著商人
		self.menu_type2:setVisible(false)
		self.menu_type1:setVisible(true)
		self.btn_type1_sure:setLabelText(ex.Tools:getLang(5341))
	elseif idx == 107 then		--搁浅舰队
		self.menu_type2:setVisible(true)
		self.menu_type1:setVisible(false)
		self.btn_type2_sure:setLabelText(ex.Tools:getLang(76547))
		self:showSummon()
	elseif idx == 108 then		--天降宝箱
		self.menu_type2:setVisible(true)
		self.menu_type1:setVisible(false)
		self.btn_type2_sure:setLabelText(ex.Tools:getLang(5341))
		self:showSummon()
	elseif idx == 110 then		--航线礼包
		self.menu_type2:setVisible(false)
		self.menu_type1:setVisible(true)
		self.btn_type1_sure:setLabelText(ex.Tools:getLang(5341))
	elseif idx == 111 then		--顺风前行
		self.menu_type2:setVisible(true)
		self.menu_type1:setVisible(false)
		self.btn_type2_sure:setLabelText(ex.Tools:getLang(73403))
		self:showSummon()
	end

	
end

function ExoticAdventureRandomEventsLayer:registerEvent()
	self:addEvent(EVENT.EXOTICADVENTURE.EVENT_LEAVE,handler(self,self.leave))

	self:addEvent(EVENT.EXOTICADVENTURE.EVENT_ONE,handler(self,self.startevent))
	self:addEvent(EVENT.EXOTICADVENTURE.EVENT_TWO,handler(self,self.startevent))
	self:addEvent(EVENT.EXOTICADVENTURE.EVENT_THREE,handler(self,self.startevent))
	self:addEvent(EVENT.EXOTICADVENTURE.EVENT_FOUR,handler(self,self.startevent))
	self:addEvent(EVENT.EXOTICADVENTURE.EVENT_FIVE,handler(self,self.startevent))
	self:addEvent(EVENT.EXOTICADVENTURE.EVENT_SEVEN,handler(self,self.startevent))
	self:addEvent(EVENT.EXOTICADVENTURE.EVENT_EIGHT,handler(self,self.startevent))
	self:addEvent(EVENT.EXOTICADVENTURE.EVENT_NINE,handler(self,self.startevent))
	self:addEvent(EVENT.EXOTICADVENTURE.ENEMY_INFO,handler(self,self.openEnemyInfo))
	self:addEvent(EVENT.EXOTICADVENTURE.EVENT_TEN,handler(self,self.startevent))
	self:addEvent(EVENT.EXOTICADVENTURE.EVENT_LEVEN,handler(self,self.startevent))
end

function ExoticAdventureRandomEventsLayer:showSummon()
	local item_summon_one_need = {}
	for k,v in pairs(cfg.spacetimeeventshow.spacetimeeventshow) do
		if ex.Player.exotic_adventure_data.not_route == v.route_id then
			if ex.Player.exotic_adventure_data.event_type == v.event_id then
				item_summon_one_need = v.cost[1]
			end
		end
	end

	self.node_consume:setVisible(true)
	self.spr_summon_one_icon:setSpriteFrame("backpack/"..item_summon_one_need.item_type..".png")
	self.lbl_summon_one_num:setString(item_summon_one_need.item_num)
end


-- 确定进入事件
function ExoticAdventureRandomEventsLayer:onSure(tag,pSender)
	local idx = ex.Player.exotic_adventure_data.event_type
	if idx == 102 then
		-- 进入布阵界面
		require('src.layer.HeroSelectCtr'):instance():openWindow(ex.Tools:getLang(47524),
							ex.Tools:getLang(47064),
							BattleType.EXOTIC_ADVENTURE,
							handler(self, self.sendExecuteEvent))
	elseif idx == 103 then
		local req = SpaceTimeAdventure_pb.GReqEnemyInfo()
		NetManager:sendMessage(ProtocolID.GReqEnemyInfo, req)
	elseif idx == 106 then
		local ctr = ExoticAdventureRandomEventsCtr:instance()
		ctr:closeWindow()
		-- 进入土著商人界面
		require("src.layer.exoticadventure.ExoticAdventureShopCtr"):instance():openWindow()
	elseif idx == 110 then  -- 航行礼包
		local ctr = ExoticAdventureRandomEventsCtr:instance()
		ctr:closeWindow()
		-- 进入航线礼包页面
		require("src.layer.exoticadventure.ExoticAdventureGiftPageCtr"):instance():openWindow()
	else
		self:sendExecuteEvent()
	end
end

function ExoticAdventureRandomEventsLayer:sendExecuteEvent()
	local req = SpaceTimeAdventure_pb.GReqExecuteEvent()
	req.event_type = ex.Player.exotic_adventure_data.event_type
	NetManager:sendMessage(ProtocolID.GReqExecuteEvent, req)
end

-- 放弃事件
function ExoticAdventureRandomEventsLayer:onOut(tag,pSender)
	local req = SpaceTimeAdventure_pb.GReqQuitEvent()
	NetManager:sendMessage(ProtocolID.GReqQuitEvent, req)
end

-- 放弃事件 直接关闭页面
function ExoticAdventureRandomEventsLayer:leave()
	if self.plunderCtr ~= nil then
		self.plunderCtr:closeWindow()
		self.plunderCtr = nil
	end
	local ctr = ExoticAdventureRandomEventsCtr:instance()
	ctr:closeWindow()
end

function ExoticAdventureRandomEventsLayer:openEnemyInfo()
	-- 进入攻击选择界面
	self.plunderCtr = require("src.layer.exoticadventure.ExoticAdventurePlunderCtr"):instance()
	self.plunderCtr:openWindow()
end

-- 执行事件 
function ExoticAdventureRandomEventsLayer:startevent()
	local idx = ex.Player.exotic_adventure_data.event_type
	if idx == 101 then			--舰队残骸
		self.sure_layer = "src.layer.exoticadventure.ExoticAdventureGetItemsCtr"
		require(self.sure_layer):instance():openWindow()
	elseif idx == 102 then		--舰队残骸（怪物）
		
	elseif idx == 103 then		--其他舰队
	
	elseif idx == 104 then		--隐藏航线

	elseif idx == 105 then		--风暴降临
	
	elseif idx == 106 then		--土著商人
		
	elseif idx == 107 then		--搁浅舰队
		local buff = ex.Player.exotic_adventure_data.event[idx][1]
		 -- 文字
		local str = ""
		for k,v in ipairs(buff.buff) do
			local effect = v.effect
			if v.effect > 0 then
				effect = "+"..effect
			end
			if v.buff_id == 101 then
				str = str .. ex.Tools:getLang(76580)..("+"..(v.effect / 100 ).."%")
			elseif v.buff_id == 102 then
				str = str .. ex.Tools:getLang(76581)..effect
			elseif v.buff_id == 103 then
				str = str .. ex.Tools:getLang(76582)..effect
			end
		end
		-- 添加提示
		ex.MessageView:add(str)
	elseif idx == 108 then		--天降宝箱
		self.sure_layer = "src.layer.exoticadventure.ExoticAdventureGetItemsCtr"
		require(self.sure_layer):instance():openWindow()
	elseif idx == 110 then		--航行礼包

	elseif idx == 111 then		--顺风航行
		local buff = ex.Player.exotic_adventure_data.event[idx][1]
			-- 文字
		local str = ""
		for k,v in ipairs(buff.buff) do
			if v.buff_id == 101 then
				str = str .. ex.Tools:getLang(76580)..("+"..(v.effect / 100 ).."%")
			elseif v.buff_id == 102 then
				str = str .. ex.Tools:getLang(76581)..v.effect
			elseif v.buff_id == 103 then
				str = str .. ex.Tools:getLang(76582)..v.effect
			end
		end
		-- 添加提示
		ex.MessageView:add(str)
	end
	local ctr = ExoticAdventureRandomEventsCtr:instance()
	ctr:closeWindow()
end


-----------------------------------------------------------------------------
function ExoticAdventureRandomEventsCtr:onCreate()
	self:setCCBIPath("ccbi/ExoticAdventureRandomEventsLayer.ccbi")
	self:setIsSingle(false)
end

function ExoticAdventureRandomEventsCtr:getLayerClass()
	return ExoticAdventureRandomEventsLayer
end

function ExoticAdventureRandomEventsCtr:getAchievementLayer()
	return self.layer
end

function ExoticAdventureRandomEventsCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
end

function ExoticAdventureRandomEventsCtr:initData()

end

return ExoticAdventureRandomEventsCtr
