local NpcTalkCtr = class("NpcTalkCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local NpcTalkLayer = class("NpcTalkLayer", require("src.comp.EventLayer"))

function NpcTalkLayer:onCreate()
	self:setAutoClose(false)
	self.audio_effect_id = nil

	local win_size = cc.Director:getInstance():getWinSize();

	self.spr_npc = sp.SkeletonAnimation:create("spine/new.json","spine/new.atlas", 1)
    self.spr_npc:setAnimation(0, "act", true);
    self.spr_npc:setPosition(60, 0)
    self.spr_npc:setScale(1)
	self:addChild(self.spr_npc)
	

	self.lbl_npc_content = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#7A472D")
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	:setAnchorPoint(cc.p(0, 1))
	:setPosition(cc.p(260, 220))
	self:addChild(self.lbl_npc_content)


	self.npc_point = cc.p(self.spr_npc:getPositionX(), self.spr_npc:getPositionY())
	self.spr_content_bg:setContentSize(cc.size(win_size.width + 20, self.spr_content_bg:getContentSize().height))
	self.lbl_auto_content:setPositionX(win_size.width - 50)
	-- self.lbl_npc_content:setLineHeight(40)
	self.lbl_npc_content:setContentSize(cc.size(win_size.width - 40 - self.lbl_npc_content:getPositionX(), 0))
	self.spr_text_bg:setContentSize(cc.size(win_size.width - self.spr_text_bg:getPositionX() - 10))

	self:setPosition(0, 0)
	self.lbl_cv_tip:setVisible(cfg.socialplatform.isOpen("cv_tip"))

end

function NpcTalkLayer:onExit()
	NpcTalkCtr:instance().can_close = false
	
	if self.audio_effect_id then
		ex.AudioManager:stopEffect(self.audio_effect_id)
	end

end

-----------------------------------------------------------------------------
function NpcTalkCtr:onCreate()
	self:setCCBIPath("ccbi/NpcTalkLayer.ccbi")
	self:setIsSingle(false)
end

function NpcTalkCtr:getLayerClass()
	return NpcTalkLayer
end

function NpcTalkCtr:getNpcTalkLayer()
	return self.layer
end

function NpcTalkCtr:openWindowAuto(npc_name, content, audio_effect)
	self.can_close = true
	self:openWindow(npc_name, content, audio_effect)
	-- self.layer.lbl_auto_content:setVisible(false)
end

function NpcTalkCtr:openWindow(npc_name, content, audio_effect)
	if self:isOpened() then
		self.can_close = true
		self:setNPCName(npc_name)
		self:setNpcTalk(content)
		return
	end
	
	self:loadLayer()
	self:open()

	self:setNPCName(npc_name)
	self:setNpcTalk(content)


	if audio_effect ~= nil then
		self.layer.audio_effect_id = ex.AudioManager:playEffect(audio_effect) 
	end

	local spr_npc = self.layer.spr_npc
	spr_npc:setPosition(-spr_npc:getContentSize().width * math.abs(spr_npc:getScaleX()),
						-spr_npc:getContentSize().height * spr_npc:getScaleY() * 0.1)

	local act_move = cc.MoveTo:create(1.5, cc.p(self.layer.npc_point.x, self.layer.npc_point.y))
    spr_npc:runAction(cc.EaseExponentialOut:create(act_move))
end

function NpcTalkCtr:closeWindow()
	self.can_close = false
	self:fastClose()
end

function NpcTalkCtr:canClose()
	local is_close = false
	if self:isOpened() then
		if self.can_close and cc.pGetDistance(cc.p(self.layer.spr_npc:getPositionX(), self.layer.spr_npc:getPositionY()), self.layer.npc_point) < 20 then
			self:closeWindow()
			is_close = true
		end
	end
	return is_close
end

function NpcTalkCtr:setNPCName(npc_name)
	self.layer.lbl_npc_name:setString(npc_name)
end

function NpcTalkCtr:setNpcTalk(content)
	-- self.layer.lbl_npc_content:setString(content)
	self.layer.lbl_npc_content:setXmlTextLua(content)
	self.layer.lbl_npc_content:formatText()
	-- self.layer.lbl_npc_content:setXmlTextLua("1123123")
	local size = self.layer.lbl_npc_content:getContentSize()
	self.layer.spr_text_bg:setContentSize(cc.size(self.layer.spr_text_bg:getContentSize().width, size.height + 100))
	self.layer.lbl_auto_content:setPositionY(self.layer.lbl_npc_content:getPositionY() - size.height - 15)

	-- cv_tip
	local config = cfg.socialplatform.getConfig("cv_tip")
	if config then
		self.layer.lbl_cv_tip:setString(ex.Tools:getLang(config.para1))
		self.layer.lbl_cv_tip:setPositionY(self.layer.lbl_auto_content:getPositionY() - 7.5)
	end

end

return NpcTalkCtr
