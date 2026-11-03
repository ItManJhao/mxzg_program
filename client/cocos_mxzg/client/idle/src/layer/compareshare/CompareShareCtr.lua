local CompareShareCtr = class("CompareShareCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CompareShareLayer = class("CompareShareLayer", require("src.comp.EventLayer"))

local SHARE_TYEP = {
	[1] = "main_chat_cross_share",
	[2] = "main_chat_world_share",
	[3] = "main_chat_clan_share"
}

function CompareShareLayer:onCreate()
	self:addBlackBackground()
	-- self:setLocalZOrder(100)
	-- self:setLocalZOrder(100)
	self.can_share = true

	self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)

	local chapter_end_ctr = CompareShareCtr:instance()
	self.btn_world:registerScriptTapHandler(handler(self, self.onShare))
	self.btn_cross:registerScriptTapHandler(handler(self, self.onShare))
    self.btn_clan:registerScriptTapHandler(handler(self, self.onShare))
    self.btn_playback:registerScriptTapHandler(handler(self, self.onPlayBack))
	self.btn_report:registerScriptTapHandler(handler(self, self.onReport))
	
    self.btn_world:setLabelText(ex.Tools:getLang(73019)) -- 确 定
    -- self.btn_world:setTextColor(cc.c4b(255,255,255,255))
	self.btn_world:setLabelScale(0.5)
    self.btn_world:setLabelOutLine(cc.c4b(87,50,2,255))
    
    
    self.btn_clan:setLabelText(ex.Tools:getLang(73021)) -- 确 定
	self.btn_clan:setLabelScale(0.5)
    self.btn_clan:setLabelOutLine(cc.c4b(87,50,2,255))
	self.btn_clan:setLabelColor(cc.WHITE)
	
	self.btn_cross:setLabelText(ex.Tools:getLang(73020)) -- 确 定
	self.btn_cross:setLabelScale(0.5)
    self.btn_cross:setLabelOutLine(cc.c4b(87,50,2,255))
    self.btn_cross:setLabelColor(cc.WHITE)
    
    self.btn_playback:setLabelText(ex.Tools:getLang(73022)) -- 确 定
	self.btn_playback:setLabelScale(0.5)
    self.btn_playback:setLabelOutLine(cc.c4b(87,50,2,255))
	self.btn_playback:setLabelColor(cc.WHITE)

    -- self.scroll_view = cc.ScrollView:create(cc.size(self.spr_bg:getContentSize().width - 40, 150))
    -- :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    -- :setPosition(20, self.btn_confirm:getPositionY() + self.btn_confirm:getContentSize().height / 2 + 5)
    -- self:addChild(self.scroll_view)

	-- self.scroll_view:addChild(cc.LayerColor:create(FONT_WHITE_C4B, 1000, 1000))
end

function CompareShareLayer:onShare(tag,pSender)
	local is_open = ex.JumpManager:checkOpenConditionByAtomNoMsg(SHARE_TYEP[tag])
	if not is_open then 
		local conf = cfg.opencondition.condition[SHARE_TYEP[tag]]
		if tag == 1 then 
			ex.MessageView:add(string.format(ex.Tools:getLang(41212),conf.condition_value))
		elseif tag == 2 then 
			ex.MessageView:add(string.format(ex.Tools:getLang(41213),conf.condition_value))
		elseif tag == 3 then 
			ex.MessageView:add(ex.Tools:getLang(41214))
		end
		return 
	end 

	if tag == 3 and ex.Player.clan_data.clan_id == 0 then 
		ex.MessageView:add(ex.Tools:getLang(41214))
		return 
	end
	
	if self.can_share == false then 
		ex.MessageView:add(string.format( ex.Tools:getLang(73026),self.delay_time))
		return 
	end

	local req = Video_pb.GReqBattleShare()
	req.battleId = self.data.report.battle_id
	req.channel = tag
	NetManager:sendMessage(ProtocolID.GReqBattleShare,req)
	ex.MessageView:add(ex.Tools:getLang(73023))
	self:addTimer()
end

function CompareShareLayer:addTimer( )
    self:removeTimer()
    self.delay_time = 10 
    self.can_share = false
    self.timer_id = ex.Timer:addTimer(1000, function()
        self.delay_time = self.delay_time - 1
        print(self.__cname,self.delay_time)
        if self.delay_time <= 0 then 
            self.can_share = true
            self:removeTimer()
        end
    end, true)

end

function CompareShareLayer:removeTimer( )
    if self.timer_id then 
        ex.Timer:removeTimerById(self.timer_id)
    end
    self.timer_id = nil
end

-- function CompareShareLayer:onShareWorld(tag,pSender)
    
-- end

-- function CompareShareLayer:onShareClan(tag,pSender)
    
-- end

function CompareShareLayer:onPlayBack(tag,pSender)
    local cur_type = ex.MainSceneCtr:getCurLayerType()

    local battle_layer = self:addBattleLayer(BattleType.PVP_DEFENSE,
                                            cur_type,
                                            "",
                                            EVENT.VIDEO_STUDIO_EVENT.SHARE_BATTLE_PLAY_BACK_CALLBACK,
                                            function()
                                                return true, false
                                            end)
	battle_layer:showCloseBtn(true)
	battle_layer:showSpeedBtn(true,false)
    -- battle_layer:setScale(1.0 / self:getParent():getScale())
    battle_layer:setPosition(self:getContentSize().width * 0.5  / battle_layer:getScale() - ex.p.width  * 0.5,
                            self:getContentSize().height * 0.5 / battle_layer:getScale() - ex.p.height * 0.5)
                            
    ex.EventManager:fire(EVENT.VIDEO_STUDIO_EVENT.SHARE_BATTLE_PLAY_BACK_CALLBACK, self.data.report, {}, self.data)    
end

function CompareShareLayer:onReport(tag, pSender)
    require("src.layer.BattleDetailCtr"):instance():openWindow(self.data.report.log)
end

function CompareShareLayer:onExit( )
	self:removeTimer()
end


-----------------------------------------------------------------------------
function CompareShareCtr:onCreate()
	self:setCCBIPath("ccbi/CompareShareLayer.ccbi")
	self:setIsSingle(false)
end

function CompareShareCtr:getLayerClass()
	return CompareShareLayer
end

function CompareShareCtr:getPvpEndLayer()
	return self.layer
end

function CompareShareCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/summon-effect.plist")
	sfc:addSpriteFrames("ccbi-res/battle-end.plist")
	sfc:addSpriteFrames("ccbi-res/battle-end-lang.plist")
	
	self:loadLayer()
	self:open()
	self.layer.data = data
	local is_cross = data.report.log.attacker_log.serverId ~= data.report.log.defender_log.serverId
	self.layer.btn_cross:setVisible(is_cross)
	self.layer.btn_world:setVisible(not is_cross)
	local is_win = ex.Player.role_id == data.report.win_id
	self:initData(is_win, data.report.log, vec_reward, ext, callback)
end

function CompareShareCtr:initData(is_win, log, vec_reward, ext, callback)
	local layer = self.layer
	layer.is_win = is_win
	layer.callback = callback

    -- 更改显示
    -- layer.spr_wing:setSpriteFrame(string.format("battle-end/spr-wing-%d.png", is_win and 1 or 0))
    -- layer.spr_result:setSpriteFrame(string.format("battle-end-lang/lbl-result-%d.png", is_win and 1 or 0))
	ex.Tools:setSpriteFrame(layer.spr_wing, string.format("battle-end/spr-wing-%d.png", is_win and 1 or 0))
	ex.Tools:setSpriteFrame(layer.spr_result, string.format("battle-end-lang/lbl-result-%d.png", is_win and 1 or 0))

    if is_win == true then
    	-- print("play effect wing")
    	local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_battle_end")
    	spr_effect:setPosition(layer.spr_wing:getContentSize().width / 2, layer.spr_wing:getContentSize().height / 2 + 40)
    	spr_effect:setScale(1)
		layer.spr_wing:addChild(spr_effect, 0, 10)
		
		local chibang = sp.SkeletonAnimation:create("spine/chibang.json","spine/chibang.atlas", 1)
        chibang:setAnimation(0, "idle", true);
	   chibang:setPosition(layer.spr_wing:getPositionX(), layer.spr_wing:getPositionY())
	   layer:addChild(chibang)

		layer.spr_result:setVisible(false)
		layer.spr_wing:setVisible(false)

    end

	ex.AudioManager:playEffect(string.format("music/battle-end-%d.mp3", is_win and 1 or 0))
	
    -- 显示角色信息
	local sfc = cc.SpriteFrameCache:getInstance()
	-- layer.spr_head1:setSpriteFrame()
	local margin = 20
	ex.Tools:setSpriteFrame(layer.spr_head1, string.format("head-icon/%d.png", log.attacker_log.head_id))
	ex.Tools:setSpriteFrame(layer.spr_border1, ex.Tools:getBorderIconByIdx(log.attacker_log.border_id))
    layer.lbl_name1:setString(string.format("%s%s",ex.StringUtil.getServerName(log.attacker_log.serverId),log.attacker_log.name))
	layer.lbl_score1:setString(log.attacker_log.fighting)
	layer.spr_bat1:setPositionX(layer.lbl_name1:getPositionX() + layer.lbl_name1:getContentSize().width + margin*2)
	layer.lbl_score1:setPositionX(layer.spr_bat1:getPositionX() + layer.spr_bat1:getContentSize().width + margin)
	-- layer.lbl_add_score1:setString(ext.self_score > 0 and ("+" .. ext.self_score) or ext.self_score)
	
	-- local enemy_data = ex.Player.pvp_data:getEnemyData(enemy_id)
	-- layer.spr_head2:setSpriteFrame(string.format("head-icon/%d.png", enemy_data.head_id))
	ex.Tools:setSpriteFrame(layer.spr_head2, string.format("head-icon/%d.png", log.defender_log.head_id))
	ex.Tools:setSpriteFrame(layer.spr_border2, ex.Tools:getBorderIconByIdx(log.defender_log.border_id))
    layer.lbl_name2:setString(string.format("%s%s",ex.StringUtil.getServerName(log.defender_log.serverId),log.defender_log.name))
	layer.lbl_score2:setString(log.defender_log.fighting)
	layer.spr_bat2:setPositionX(layer.lbl_name2:getPositionX() - layer.lbl_name2:getContentSize().width - margin*2)
	layer.lbl_score2:setPositionX(layer.spr_bat2:getPositionX() - layer.spr_bat2:getContentSize().width - margin)
	-- layer.lbl_add_score2:setString(ext.enemy_score > 0 and ("+" .. ext.enemy_score) or ext.enemy_score)
end

function CompareShareCtr:onceAnim(pos, str_spr, str_plist, str_png)
	local spr_effectOnce = cc.Sprite:createWithSpriteFrameName(str_spr)
    spr_effectOnce:setScale(1.35)
    spr_effectOnce:setPosition(pos)
    self.layer.scroll_view:getContainer():addChild(spr_effectOnce)

    local action = cpp.ActionFactory:createLuaAnimate(str_plist, str_png, 0.05)
    spr_effectOnce:runAction(cc.Sequence:create(action, cc.CallFunc:create(function()
    	spr_effectOnce:setVisible(false)
    end)))
end

function CompareShareCtr:onItem(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function CompareShareCtr:onConfirm(tag, pSender)
	local layer = self.layer

	if layer.callback then
		layer.callback(layer.is_win)
	end
	
	self:closeWindow(tag, pSender)
end

return CompareShareCtr
