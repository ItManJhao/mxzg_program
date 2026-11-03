--[[
* @Description: 异界冒险-战斗结算页面
* @Author: 熊梦
* @Date: 2020-08-5 10:13:00
* ]]
local ExoticAdventureBattleEndCtr = class("ExoticAdventureBattleEndCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ExoticAdventureBattleEndLayer = class("BattleEndLayer",require("src.comp.EventLayerAdaptiveWidth"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function ExoticAdventureBattleEndLayer:onCreate()
	self:addBlackBackground()
end

function ExoticAdventureBattleEndLayer:initData(is_win,vec_reward,settlement) 
	self.vec_reward = vec_reward
	self.settlement = settlement

	ex.Tools:setSpriteFrame(self.spr_wing, string.format("battle-end/spr-wing-%d.png", is_win and 1 or 0))
	--ex.Tools:setSpriteFrame(self.spr_result, string.format("battle-end-lang/lbl-result-%d.png", is_win and 1 or 0))(  )

	if is_win == true then
		local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_battle_end")
    	spr_effect:setPosition(self.spr_wing:getContentSize().width / 2, self.spr_wing:getContentSize().height / 2 + 40)
    	spr_effect:setScale(1)
		self.spr_wing:addChild(spr_effect, 0, 10)	
		

		local chibang = sp.SkeletonAnimation:create("spine/chibang.json","spine/chibang.atlas", 1)
        chibang:setAnimation(0, "idle", true);
       -- chibang:setPosition(layer.spr_wing:getPositionX() + layer.spr_wing:getContentSize().width / 2, layer.spr_wing:getPositionY() +  layer.spr_wing:getContentSize().height / 2)
	   chibang:setPosition(self.spr_wing:getPositionX(), self.spr_wing:getPositionY())
	   self:addChild(chibang)

	   self.spr_result:setVisible(false)
	   self.spr_wing:setVisible(false)
	else
		
	end
	-- optional int32 buff_id = 1; //类型
	-- optional int32 effect = 2; //效果
	
-- 	/**
-- 	* 航队速度
-- 	*/
--    JIAN_DUI_SU_DU(101),
--    /**
-- 	* 航队耐久
-- 	*/
--    JIAN_DUI_NAI_JIU(102),
--    /**
-- 	* 航队进度
-- 	*/
--    JIAN_DUI_JIN_DU(103)
	
	 -- 文字
	local idx = ex.Player.exotic_adventure_data.event_type
	local str = ""
	for k,v in pairs(self.vec_reward.buff) do
		local effect = v.effect
		if v.effect > 0 then
			effect = "+"..effect
		end
		if v.buff_id == 101 then
			str = str .. ex.Tools:getLang(76580)..effect
		elseif v.buff_id == 102 then
			str = str .. ex.Tools:getLang(76581)..effect
		elseif v.buff_id == 103 then
			str = str .. ex.Tools:getLang(76582)..effect
		end
	end
	self.lbl_faild:setString(str)
	self.spr_get:setVisible(#self.vec_reward.itme_list > 0 and true or false)
	-- 道具
	for i,v in ipairs(self.vec_reward.itme_list) do
		local item = UIItemBackpack:createWithData(v.type, v.num)
		item:registerScriptTapHandler(handler(self, self.onItemInfo))
		item.reward = nil
		if v.id ~= 0 then
			for index,value in pairs(cfg.spacetimebox.spacetimebox) do
				if value.idx == v.id then
					item.reward = value.reward
					break
				end
			end
		end
		--item:setPosition(PropPos[i])
		item:setScale(0.8)
		self.menu:addChild(item)
   end

end

function ExoticAdventureBattleEndLayer:onItemInfo(tag, pSender)
	if pSender.reward ~= nil then
		require("src.layer.exoticadventure.ExoticAdventureBackpackInfoCtr"):instance():openWindow(pSender.item_type,pSender.reward)
	else
		ex.Tools:onClickItemInfo(pSender.item_type)
	end
end

function ExoticAdventureBattleEndLayer:onConfirm()
	if self.settlement then
		ex.EventManager:fire(EVENT.EXOTICADVENTURE.SAILING_END)
	end
	local ctr = ExoticAdventureBattleEndCtr:instance()
	ctr:closeWindow()
end
-----------------------------------------------------------------------------
function ExoticAdventureBattleEndCtr:onCreate()
	self:setCCBIPath("ccbi/ExoticAdventureBattleEndLayer.ccbi")
	self:setIsSingle(false)
end

function ExoticAdventureBattleEndCtr:getLayerClass()
	return ExoticAdventureBattleEndLayer
end

function ExoticAdventureBattleEndCtr:getChapterEndLayer()
	return self.layer
end

function ExoticAdventureBattleEndCtr:openWindow(is_win, vec_reward, ext, settlement)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/battle-end.plist")
	sfc:addSpriteFrames("ccbi-res/battle-end-lang.plist")
    
	self:loadLayer()
	self:open()
	self.vec_battle_detail = ext
	self.layer.btn_report:registerScriptTapHandler(handler(self, self.onBattleDetail))
	self.layer:initData(is_win,vec_reward,settlement)
end

function ExoticAdventureBattleEndCtr:onBattleDetail(tag, pSender)
	require("src.layer.BattleDetailCtr"):instance():openWindow(self.vec_battle_detail)
end


return ExoticAdventureBattleEndCtr
