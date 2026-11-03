--[[
    func: 星盘星座激活界面
    author:徐东浩
    time:2020-04-30 14:58:30
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local HeroAstrolabeActiveCtrl = class("HeroAstrolabeActiveCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroAstrolabeActiveLayer = class("HeroAstrolabeActiveLayer", require("src.comp.EventLayer"))

function HeroAstrolabeActiveLayer:onCreate()
	self:setAutoClose(true)
	self:addBlackBackground()

	self.propertys = {self.lbl_property_1, self.lbl_property_2, self.lbl_property_3}

	-- local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_reward")
    -- spr_effect:setPosition(self.spr_title:getPositionX() - 5, self.spr_title:getPositionY() - 27)
    -- self:addChild(spr_effect, 20)
end

function HeroAstrolabeActiveLayer:refershStar(cur_star, need_star)
	self.lbl_star:setString(tostring(need_star))

	self.lbl_star_rate:setString(string.format("（%d/%d）", cur_star, need_star))
	if cur_star < need_star then
		self.lbl_star_rate:setColor(cc.c3b(250, 0, 0))
	else
		self.lbl_star_rate:setColor(cc.c3b(0, 250, 0))
	end
end

function HeroAstrolabeActiveLayer:refershAttr(attrs)
	local attrs_data = {}
	if type(attrs) == "table" then
		attrs_data = attrs
	end
	
	for i, v in ipairs(self.propertys) do
		local attr = attrs_data[i]

		if attr then
			local value = 0
			if attr.percent == 1 then
				value = string.format("%d%%", attr.value / 100)
			else
				value = tostring(attr.value)
			end
		
			local str = string.format(ex.Tools:getLang(4114), ex.Tools:getLang(122000 + attr.attr), value)
			v:setString(str)
		else
			v:setVisible(false)
		end
	end
end

function HeroAstrolabeActiveLayer:setActionable(is_actionable, is_actived)
	if is_actived then
		self.btn_active:setVisible(false)
		self.no_active:setVisible(true)

		self.no_active:setString(ex.Tools:getLang(4113))
	else
		if is_actionable then
			self.btn_active:setVisible(true)
			self.no_active:setVisible(false)
		else
			self.btn_active:setVisible(false)
			self.no_active:setVisible(true)

			self.no_active:setString(ex.Tools:getLang(4112))
		end
	end
end

-----------------------------------------------------------------------------
function HeroAstrolabeActiveCtrl:onCreate()
	self:setCCBIPath("ccbi/HeroAstrolabeActiveLayer.ccbi")
	self:setIsSingle(false)

	self.idx = 0
	self.is_actionable = false
	self.is_actived = false
	self.config = nil
end

function HeroAstrolabeActiveCtrl:getLayerClass()
	return HeroAstrolabeActiveLayer
end

function HeroAstrolabeActiveCtrl:getHeroAstrolabeActiveLayer()
	return self.layer
end

function HeroAstrolabeActiveCtrl:openWindow(idx)
	if self:isOpened() then
		return
	end

	self.idx = idx

	self:loadLayer()
	self:open()

	self:refreshData()

	self:init()

	-- ex.AudioManager:playEffect("music/item-get.mp3")
end

function HeroAstrolabeActiveCtrl:init()
	self.layer.btn_active:registerScriptTapHandler(handler(self, self.onActive))

	self:updateLayer()
end

function HeroAstrolabeActiveCtrl:refreshData()
	self.config = cfg.astrolabe.getConfigByIdx(self.idx)
	
	local star_actionable_idx = ex.Player.hero_data.astrolabe:getNextStarActionable()
	self.is_actionable = star_actionable_idx == self.idx

	self.is_actived = ex.Player.hero_data.astrolabe:isActivedByStar(self.idx)
end

function HeroAstrolabeActiveCtrl:updateLayer()
	self.layer:refershStar(ex.Player.hero_data.astrolabe.max_star, self.config.star)

	self.layer:refershAttr(self.config.attrs)

	self.layer:setActionable(self.is_actionable, self.is_actived)
end

function HeroAstrolabeActiveCtrl:onActive(tag ,pSender)
	if ex.Player.hero_data.astrolabe.max_star < self.config.star then
		ex.MessageView:add(ex.Tools:getLang(4115))
		return
	end

	local req = Astrolabe_pb.GReqAstrolabeLight()
	req.idx = self.idx
	req.skill_id = 0
	NetManager:sendMessage(ProtocolID.GReqAstrolabeLight, req)

	self:closeWindow()
end



return HeroAstrolabeActiveCtrl
