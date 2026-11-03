local HeroInfoTalentLayer = class("HeroInfoTalentLayer", require("src.comp.EventLayer"))

function HeroInfoTalentLayer:onCreate()
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/skill-icon.plist")
    sfc:addSpriteFrames("ccbi-res/hero-info.plist")
    sfc:addSpriteFrames("ccbi-res/hero-info-lang.plist")

	self.hero_data = nil

	self:updateView()
	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UPDATE_TALENT, handler(self,self.updateView))

	self.btn_skill_1:registerScriptTapHandler(handler(self, self.onClickSkill))
	self.btn_skill_2:registerScriptTapHandler(handler(self, self.onClickSkill))
	self.btn_skill_preview:registerScriptTapHandler(handler(self, self.onPreview))
	self.btn_skill_shop:registerScriptTapHandler(handler(self, self.onShop))
	self.btn_info:registerScriptTapHandler(handler(self, self.onInfo))
end

function HeroInfoTalentLayer:updateView()
	self.hero_data = ex.Player.hero_data.promote:getSelectHero()
	
	self:refreshSlot()
end

function HeroInfoTalentLayer:refreshSlot()
	for i = 1, 2 do
		local btn = self["btn_skill_"..tostring(i)]
		local node = self["node_skill_"..tostring(i)]
		local label = self["lbl_skill_"..tostring(i)]

		local parent = btn:getNormalImage()
		parent:removeAllChildren()

		local local_data = {}
		local_data.slot = i

		local is_open = self.hero_data.star >= cfg.system.getTalentSlotOpenStar(i)
		local_data.unlock = is_open

		local btn_size = parent:getContentSize()
		if is_open then
			local talent = ex.Player.hero_data:getTalentByIDAndSlot(self.hero_data.hero_id, i)
			if talent and talent.skill_id ~= 0 then
				local_data.skill_id = talent.skill_id
				local_data.level = talent.level

				node:setVisible(true)
				local skill_config = cfg.heroskill.getConfigByType(talent.skill_id, talent.level)
				label:setString(skill_config and ex.Tools:getLang(skill_config.lan_name) or " ")

				local skill = cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", talent.skill_id + math.max(0, talent.level - 1)))  --cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", talent.skill_id))
				skill:setScale(1.645)
				skill:setAnchorPoint(ex.a.center)
				skill:setPosition(btn_size.width / 2, btn_size.height / 2)
				parent:addChild(skill, 10)

				local skill_border = cc.Sprite:createWithSpriteFrameName("other/spr-bg-12.png")
				skill_border:setScale(1)
				skill_border:setAnchorPoint(ex.a.center)
				skill_border:setPosition(btn_size.width / 2, btn_size.height / 2)
				parent:addChild(skill_border, 15)

				local pos = cc.p(btn_size.width * 0.15, btn_size.height * 0.85)
				local bg_level = cc.Sprite:createWithSpriteFrameName("win-bg/block-bg-29.png")
				bg_level:setPosition(pos)
				parent:addChild(bg_level, 20)

				local lbl_level = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 40)
				lbl_level:setColor(cc.c3b(122, 71, 45))
				lbl_level:setAnchorPoint(0.5, 0.5)
				lbl_level:setScale(0.5)
				lbl_level:setPosition(pos)
				parent:addChild(lbl_level, 30)

				lbl_level:setString(tostring(talent.level))
			else
				local_data.skill_id = 0
				local_data.level = 0

				local spr_add = cc.Sprite:createWithSpriteFrameName("other/spr-add-1.png")
				spr_add:setPosition(btn_size.width / 2, btn_size.height / 2)
				parent:addChild(spr_add)

				node:setVisible(false)
			end
		else
			node:setVisible(true)
			label:setString(string.format(ex.Tools:getLang(41300), cfg.system.getTalentSlotOpenStar(i)))

			local spr_lock = cc.Sprite:createWithSpriteFrameName("hero-info/spr-lock.png")
			spr_lock:setScale(1.5)
			spr_lock:setPosition(btn_size.width / 2, btn_size.height / 2)
			parent:addChild(spr_lock, 10)
		end

		btn.local_data = local_data
		btn:setEnabled(is_open)
	end
end

function HeroInfoTalentLayer:onClickSkill(tag ,pSender)
	local local_data = pSender.local_data
	if not local_data.unlock then
		return
	end

	if local_data.skill_id == 0 then
		require("src.layer.heroinfo.HeroTalentLearnCtr"):instance():openWindow(self.hero_data.hero_id, local_data.slot)
		return
	end

	-- 打开技能升级
	require("src.layer.heroinfo.HeroTalentUpLevelCtr"):instance():openWindow(self.hero_data.hero_id, local_data.skill_id, local_data.level, local_data.slot)
end

function HeroInfoTalentLayer:onPreview(tag ,pSender)
	require("src.layer.runes.RunesSkillCtr.lua"):instance():openWindow(ex.Tools:getLang(41303))
end

function HeroInfoTalentLayer:onShop(tag ,pSender)
	cfg.funcopen.main_shop.open(SHOP_TYPE.TALENT)
end

function HeroInfoTalentLayer:onInfo(tag, pSender)
	ex.InfoCtr:openWindow(ex.Tools:getLang(42062), ex.Tools:getLang(42063))
end

return HeroInfoTalentLayer
