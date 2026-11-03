local HeroInfoSettingCtr = class("HeroInfoSettingCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local HeroInfoSettingLayer = class("HeroInfoSettingLayer", require("src.layer.ui.UI_HeroInfoSettingLayer"))
------------------------------------------------
function HeroInfoSettingLayer:onCreate()
	self.super.onCreate(self)
	self:setName("HeroInfoSettingLayer")

	-- self:addBlackBackground()

	local open_config = cfg.opencondition.condition["hero_comments"]
	local open_level = open_config.condition_value
	if ex.Player.level >= open_level then
		self.btn_comment:setVisible(true)
	else
		self.btn_comment:setVisible(false)
	end

	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_FIGHTING_CHANGE, handler(self, self.changeFighting))
end

function HeroInfoSettingLayer:changeFighting()
	self.spr_lock_mask1:setVisible(self.hero_data.is_lock == true)
	self.spr_lock_mask2:setVisible(self.hero_data.is_lock == false)
	-- self["btn_lock_mask"..mask]:setVisible(mask)
	-- self.btn_lock:setChecked(self.hero_data.is_lock)
end

function HeroInfoSettingLayer:resetData(position, hero_data)
	self.hero_data = hero_data
	self:setPosition(math.max(0, position.x - self:getContentSize().width), position.y)
	self:changeFighting()
end  

function HeroInfoSettingLayer:onComment()
	local req = HeroComment_pb.GReqGetData()
	req.hero_type = self.hero_data.hero_type
	NetManager:sendMessage(ProtocolID.GReqGetData, req)
end

function HeroInfoSettingLayer:onShare(tag, pSender)
	local position = cc.p(pSender:getContentSize().width * pSender:getScaleX(), pSender:getContentSize().height * pSender:getScaleY() + 20)
	position = pSender:convertToWorldSpace(position)

	local ctr = require("src.layer.heroinfo.HeroShareMenuCtr"):instance()
	local callback = handler(self,self.onShareMenuClick)
	ctr:openWindow(callback)

	ctr.layer:setPosition(position)
end

function HeroInfoSettingLayer:onShareMenuClick(tag,pSender)
    local hero_data = self.hero_data
    if not hero_data then return end 
    local req = HeroShare_pb.GReqHeroShare()
    
    req.hero_id = hero_data.hero_id
    req.channel_type = tag
	NetManager:sendMessage(ProtocolID.GReqHeroShare,req)
end

function HeroInfoSettingLayer:onLock( )
	if self.hero_data.is_lock == true then
		return
	end
	-- self.btn_lock:setChecked(self.hero_data.is_lock)
	local req_lock = Hero_pb.GReqHeroLock()
	req_lock.hero_id = self.hero_data.hero_id
	req_lock.is_lock = 1 
	NetManager:sendMessage(ProtocolID.GReqHeroLock, req_lock)
end

function HeroInfoSettingLayer:onUnlock()
	if self.hero_data.is_lock == false then
		return
	end
	-- self.btn_lock:setChecked(self.hero_data.is_lock)
	local req_lock = Hero_pb.GReqHeroLock()
	req_lock.hero_id = self.hero_data.hero_id
	req_lock.is_lock = 0 
	NetManager:sendMessage(ProtocolID.GReqHeroLock, req_lock)
end

-----------------------------------------------
function HeroInfoSettingCtr:loadLayer()
    local tmp_layer = HeroInfoSettingLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function HeroInfoSettingCtr:onCreate()
	self:setIsSingle(false)
end

function HeroInfoSettingCtr:getLayerClass()
	return HeroInfoSettingLayer
end

function HeroInfoSettingCtr:openWindow(position, hero_data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self.layer:resetData(position, hero_data)

    -- self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end

return HeroInfoSettingCtr

