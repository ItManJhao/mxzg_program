local LadderBattleEndCtrl = class("LadderBattleEndCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local LadderBattleEndLayer = class("LadderBattleEndLayer", require("src.comp.EventLayer"))

local RewardPosition = {
	[1] = {{x = 0, y = 68}},
	[2] = {{x = -60, y = 68},{x = 60, y = 68}},
	[3] = {{x = -120, y = 68},{x = 0, y = 68},{x = 120, y = 68}},
}

function LadderBattleEndLayer:onCreate()
	self:setAutoClose(true)
	self:addBlackBackground()

	self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
end

function LadderBattleEndLayer:refreshPlayerData(player_info)
    -- 更改显示
	ex.Tools:setSpriteFrame(self.spr_wing, string.format("battle-end/spr-wing-%d.png", player_info.is_win and 1 or 0))
	ex.Tools:setSpriteFrame(self.spr_result, string.format("battle-end-lang/lbl-result-%d.png", player_info.is_win and 1 or 0))

	if player_info.is_win then
    	local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_battle_end")
    	spr_effect:setPosition(self.spr_wing:getContentSize().width / 2, self.spr_wing:getContentSize().height / 2 + 40)
    	spr_effect:setScale(1)
		self.spr_wing:addChild(spr_effect, 0, 10)
		
				
		local chibang = sp.SkeletonAnimation:create("spine/chibang.json","spine/chibang.atlas", 1)
        chibang:setAnimation(0, "idle", true);
	   chibang:setPosition(self.spr_wing:getPositionX(), self.spr_wing:getPositionY())
	   self:addChild(chibang)

		self.spr_result:setVisible(false)
		self.spr_wing:setVisible(false)


	end
	
	ex.Tools:setSpriteFrame(self.spr_up_photo, string.format("head-icon/%d.png", player_info.attacker.head_id))
	ex.Tools:setSpriteFrame(self.spr_up_photo_bg, ex.Tools:getBorderIconByIdx(player_info.attacker.border_id))
	self.lbl_up_name:setString(tostring(player_info.attacker.name))
	self.lbl_up_rank:setString(player_info.attacker.rank > 0 and tostring(player_info.attacker.rank) or "1000+")
	self.spr_up_rank:setVisible(player_info.is_up)
	if player_info.is_up then
		ex.Tools:setSpriteFrame(self.spr_up_rank, "fantasy-land/up.png")
	end
	
	ex.Tools:setSpriteFrame(self.spr_down_photo, string.format("head-icon/%d.png", player_info.defender.head_id))
	ex.Tools:setSpriteFrame(self.spr_down_photo_bg, ex.Tools:getBorderIconByIdx(player_info.defender.border_id))
	self.lbl_down_name:setString(tostring(player_info.defender.name))
	self.lbl_down_rank:setString(player_info.defender.rank > 0 and tostring(player_info.defender.rank) or "1000+")
	self.spr_down_rank:setVisible(player_info.is_up)
	if player_info.is_up then
		ex.Tools:setSpriteFrame(self.spr_down_rank, "fantasy-land/down.png")
	end
end

function LadderBattleEndLayer:refreshReward(vec_reward)
	self.menu:removeAllChildren()

	for i,v in ipairs(vec_reward) do
		local item = ex.Player.backpack_data:createWithData(v.type, v.num)
		item:setPosition(RewardPosition[#vec_reward][i])
		item:setScale(0.8)
        item:registerScriptTapHandler(handler(self, self.onClickItem))
        self.menu:addChild(item)
    end
end

function LadderBattleEndLayer:onClickItem(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


-----------------------------------------------------------------------------
function LadderBattleEndCtrl:onCreate()
	self:setCCBIPath("ccbi/LadderBattleEndLayer.ccbi")
	self:setIsSingle(false)

	self.data = {}
end

function LadderBattleEndCtrl:getLayerClass()
	return LadderBattleEndLayer
end

function LadderBattleEndCtrl:getLadderBattleEndLayer()
	return self.layer
end

function LadderBattleEndCtrl:openWindow(data)
	if self:isOpened() or data == nil then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/fantasy-land.plist")
    sfc:addSpriteFrames("ccbi-res/fantasy-land-lang.plist")
    
    self.data = data

	self:loadLayer()
	self:open()
	self:initData()
end

function LadderBattleEndCtrl:initData()
	self.layer.btn_report:registerScriptTapHandler(handler(self, self.onBattleDetail))

	local player_info = {
		is_win = self.data.battle_result == 1,
		is_up = self.data.rank_up,
		attacker = {
			head_id = self.data.report.log.attacker_log.head_id,
			border_id = self.data.report.log.attacker_log.border_id,
			name = self.data.report.log.attacker_log.name,
			rank = self.data.self_rank,
		},
		defender = {
			head_id = self.data.report.log.defender_log.head_id,
			border_id = self.data.report.log.defender_log.border_id,
			name = self.data.report.log.defender_log.name,
			rank = self.data.defend_rank,
		}
	}
    self.layer:refreshPlayerData(player_info)
    self.layer:refreshReward(self.data.reward)

    ex.AudioManager:playEffect(string.format("music/battle-end-%d.mp3", player_info.is_win and 1 or 0))
end

function LadderBattleEndCtrl:onceAnim(pos, str_spr, str_plist, str_png)
	local spr_effectOnce = cc.Sprite:createWithSpriteFrameName(str_spr)
    spr_effectOnce:setScale(1.35)
    spr_effectOnce:setPosition(pos)
    self.layer.scroll_view:getContainer():addChild(spr_effectOnce)

    local action = cpp.ActionFactory:createLuaAnimate(str_plist, str_png, 0.05)
    spr_effectOnce:runAction(cc.Sequence:create(action, cc.CallFunc:create(function()
    	spr_effectOnce:setVisible(false)
    end)))
end

function LadderBattleEndCtrl:onBattleDetail(tag, pSender)
	require("src.layer.BattleDetailCtr"):instance():openWindow(self.data.report.log)
end

return LadderBattleEndCtrl
