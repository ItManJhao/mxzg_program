local HeroSkillInfoCtr = class("HeroSkillInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroSkillInfoLayer = class("HeroSkillInfoLayer", require("src.comp.LuaLayerBase"))

function HeroSkillInfoLayer:onCreate()
	self:addBlackBackground()

	local scale_label = 0.5
	self.lbl_unlock_tip = require("src.comp.RichTextEx"):create()
	:setFontSize(40)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	-- :setFontColor("#613C19")
	:setFontColor("#FFE0BF")
	:setScale(scale_label)
	:setAnchorPoint(0, 0)
	:setAnchorTextShadow(true)
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	self.lbl_unlock_tip:setContentSize(cc.size(360 / scale_label, 0))
	self.lbl_unlock_tip:setPosition(20, 0)
	self.node_level_tip:addChild(self.lbl_unlock_tip, 10)

	-- add 熊梦 技能冷却label
	self.lbl_cooling_time = require("src.comp.RichTextEx"):create()
	:setFontSize(18)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FFE0BF")
	:setAnchorPoint(0, 0)
	:setAnchorTextShadow(true)
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	self.lbl_cooling_time:setContentSize(cc.size(360 / scale_label, 0))
	self.lbl_cooling_time:setPosition(20, -16)
	self.node_skill_info:addChild(self.lbl_cooling_time)
	-- self.node:addChild()
end

function HeroSkillInfoLayer:setSkillIcon(skill_type, skill_level, active_type, str_info_1, str_coolingtime)
	-- 暂时写死
	if math.floor(skill_type / 10000000) == 15 then
		ex.Tools:setSpriteFrame(self.spr_icon, "skill-icon/"..(skill_type + skill_level - 1)..".png")
	else
		ex.Tools:setSpriteFrame(self.spr_icon, "skill-icon/"..skill_type..".png")
	end

	local str_skill_name =  ex.Player.hero_data:getSkillName(skill_type, math.max(1, skill_level)) --ex.Tools:getLang(10000000 + skill_type + skill_level - 1)
	if str_skill_name == "" then
		str_skill_name = "--"
	else
		if skill_level > 0 then
			str_skill_name = str_skill_name.."Lv."..tostring(skill_level)
		end
	end
	self.lbl_name:setString(str_skill_name)
	self.lbl_active_type:setString(ex.Tools:getLang((active_type == 1) and 41239 or 41240))

	if str_info_1 == "" then
		str_info_1 = ex.Tools:getLang(47710)
	end
	self.lbl_info_1:setString(str_info_1)

	-- 更新节点内控件位置，并计算节点总大小
	self.spr_line_1:setPositionY(self.lbl_info_1:getPositionY() + self.lbl_info_1:getContentSize().height * self.lbl_info_1:getScaleY() + 10)
	self.lbl_active_type:setPositionY(self.spr_line_1:getPositionY() + 35)
	self.lbl_name:setPositionY(self.spr_line_1:getPositionY() + 65)
	self.spr_icon:setPositionY(self.spr_line_1:getPositionY() + 50)

	self.node_skill_info.total_height = 100 + self.lbl_info_1:getContentSize().height * self.lbl_info_1:getScaleY()
	
	if str_coolingtime ~= "" then
		self.lbl_cooling_time:setVisible(true)
		self.lbl_cooling_time:setXmlTextLua(str_coolingtime)
		self.lbl_cooling_time:formatText()
	end
end

function HeroSkillInfoLayer:setNodeBuff(buff_des)
	if buff_des == nil or buff_des <= 0 then
		self.node_buff:setVisible(false)
		self.node_buff.total_height = 0
		return
	end
	
	self.node_buff:setVisible(true)

	local left_height = 150 - self.lbl_info_1:getContentSize().height * self.lbl_info_1:getScaleY()
	self.node_buff:setPositionY(210 - left_height)

	if self.lbl_buff_des == nil then
		local scale_label = 0.5
		self.lbl_buff_des = require("src.comp.RichTextEx"):create()
		:setFontSize(40)
		:setFontFace(FONT_DEFAULT_NAME_BOLD)
		-- :setFontColor("#613C19")
		:setFontColor("#5A3509")
		:setScale(scale_label)
		:setAnchorPoint(0, 0)
		:setAnchorTextShadow(true)
		:ignoreContentAdaptWithSize(false)
		:setWrapMode(1)
		self.lbl_buff_des:setContentSize(cc.size(360 / scale_label, 0))
		self.lbl_buff_des:setPosition(20, 0)
		self.node_buff:addChild(self.lbl_buff_des, 10)
	end

	self.lbl_buff_des:setXmlTextLua(ex.Tools:getLang(buff_des))
	self.lbl_buff_des:formatText()

	-- 更新节点内控件位置，并计算节点总大小
	self.spr_line_2:setPositionY(self.lbl_buff_des:getPositionY() + self.lbl_buff_des:getContentSize().height * self.lbl_buff_des:getScaleY() + 10)
	self.node_buff.total_height = 10 + self.lbl_buff_des:getContentSize().height * self.lbl_buff_des:getScaleY()
end

function HeroSkillInfoLayer:setLevelTip(str_info, next_skill_unlock_star, is_level_max, level_des)
	local left_height = 150 - self.lbl_info_1:getContentSize().height * self.lbl_info_1:getScaleY()
	if self.node_buff:isVisible() then
		left_height = left_height - self.lbl_buff_des:getContentSize().height * self.lbl_buff_des:getScaleY() - 20
	end

	if next_skill_unlock_star == nil or next_skill_unlock_star <= 0 then
		if is_level_max ~= nil and is_level_max == true then
			self.lbl_unlock_tip:setVisible(true)
			self.lbl_unlock_tip:setXmlTextLua(ex.Tools:getLang(41243))
			self.lbl_unlock_tip:formatText()
		else
			if level_des <= 0 then
				self.node_level_tip:setVisible(false)
				self.node_level_tip:setPositionY(0)
				self.node_level_tip.total_height = 0
				return
			end
			self.lbl_unlock_tip:setVisible(false)
		end
	else
		self.lbl_unlock_tip:setVisible(true)
		if str_info == nil or str_info == "" then
			self.lbl_unlock_tip:setXmlTextLua(string.format(ex.Tools:getLang(41241), next_skill_unlock_star))
		else
			self.lbl_unlock_tip:setXmlTextLua(string.format(ex.Tools:getLang(41242), next_skill_unlock_star))
		end
		self.lbl_unlock_tip:formatText()
	end

	self.node_level_tip:setVisible(true)
	self.node_level_tip:setPositionY(10)

	self.lbl_next_level_des:setVisible(level_des > 0)
	if level_des > 0 then
		self.lbl_next_level_des:setString(ex.Tools:getLang(level_des))
		self.lbl_unlock_tip:setPositionY(self.lbl_next_level_des:getPositionY() + self.lbl_next_level_des:getContentSize().height * self.lbl_next_level_des:getScaleY() + 10)
		if not self.lbl_unlock_tip:isVisible() then
			self.lbl_unlock_tip:setPositionY(self.lbl_unlock_tip:getPositionY() - 10)
			self.lbl_unlock_tip:setContentSize(cc.size(0, 0))
		end
	else
		self.lbl_next_level_des:setContentSize(cc.size(0, 0))
	end

	-- 更新节点内控件位置，并计算节点总大小
	self.spr_line_3:setPositionY(self.lbl_unlock_tip:getPositionY() + self.lbl_unlock_tip:getContentSize().height * self.lbl_unlock_tip:getScaleY() + 10)
	self.node_level_tip.total_height = 20 + self.lbl_unlock_tip:getContentSize().height * self.lbl_unlock_tip:getScaleY()
										  + self.lbl_next_level_des:getContentSize().height * self.lbl_next_level_des:getScaleY()
end

function HeroSkillInfoLayer:updateNodePos()
	self.node_buff:setPositionY(self.node_level_tip:getPositionY() + self.node_level_tip.total_height + 10)
	self.node_skill_info:setPositionY(self.node_buff:getPositionY() + self.node_buff.total_height + 10)

	local total_height = self.node_skill_info:getPositionY() + self.node_skill_info.total_height + 20
	self.btn_close:setPositionY(total_height - 25)
	self.spr_bg:setContentSize(cc.size(self.spr_bg:getContentSize().width, total_height))
	self:setContentSize(self.spr_bg:getContentSize())
	self:setPosition(ex.p.cx - self:getContentSize().width / 2, ex.p.cy - self:getContentSize().height / 2)
end

-----------------------------------------------------------------------------
function HeroSkillInfoCtr:onCreate()
	self:setCCBIPath("ccbi/HeroSkillInfoLayer.ccbi")
	self:setIsSingle(false)
end

function HeroSkillInfoCtr:getLayerClass()
	return HeroSkillInfoLayer
end

function HeroSkillInfoCtr:getHeroSkillInfoLayer()
	return self.layer
end

-- 打开技能详细界面，next_skill_unlock_star为下一级技能解锁星级，nil时不显示下一级
function HeroSkillInfoCtr:openWindow(skill_type, skill_level, next_skill_unlock_star)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	self:initData(skill_type, skill_level, next_skill_unlock_star)
end

function HeroSkillInfoCtr:openWindowWithFetter(fetter_type, skill_type, skill_level)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	skill_level = math.max(skill_level, 1)

	local layer = self.layer
	layer:setSkillIcon(skill_type, skill_level)

	local str_info = ex.Player.fetter_data:getSkillInfo(fetter_type, math.max(skill_level, 1), 0)
	layer:setSkillContent(str_info)
end

function HeroSkillInfoCtr:initData(skill_type, skill_level, next_skill_unlock_star)
	-- skill_level = math.max(skill_level, 1)

	local layer = self.layer

	local tmp_skill_level = (skill_level > 0) and skill_level or 1
	local skill_config = cfg.heroskill.getConfigByType(skill_type, tmp_skill_level)
	
	local str_info = ex.Player.hero_data:getSkillDescription(skill_type, math.max(1, skill_level))
	local str_coolingtime = ex.Player.hero_data:getSkillCoolingtime(skill_type, math.max(1, skill_level))
	layer:setSkillIcon(skill_type, skill_level, skill_config.active_type, str_info,str_coolingtime)
	layer:setNodeBuff(tonumber(skill_config.buff_lan_describe))


	if next_skill_unlock_star ~= nil and next_skill_unlock_star > 0 then
		local config = cfg.heroskill.getConfigByType(skill_type, skill_level + 1)
		if config ~= nil and skill_level > 0 then
			-- 非满级或者零级的才有下一等级技能详细显示
			local str_info_2 = ex.Player.hero_data:getSkillDescription(skill_type, skill_level + 1)
			layer:setLevelTip(str_info, next_skill_unlock_star, false, (skill_config.buff_lan_on > 0) and skill_config.levelup_describe or -1)
		else
			layer:setLevelTip(nil, next_skill_unlock_star, true, (skill_config.buff_lan_on > 0) and skill_config.levelup_describe or -1)
		end
	else
		if next_skill_unlock_star == nil then
			layer:setLevelTip(str_info, nil, false, (skill_config.buff_lan_on > 0) and skill_config.levelup_describe or -1)
		else
			layer:setLevelTip(str_info, next_skill_unlock_star, true, (skill_config.buff_lan_on > 0) and skill_config.levelup_describe or -1)
		end
	end

	layer:updateNodePos()
end

return HeroSkillInfoCtr
