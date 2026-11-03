local HeroTalentUpLevelCtr = class("HeroTalentUpLevelCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroTalentUpLevelLayer = class("HeroTalentUpLevelLayer", require("src.comp.EventLayerAdaptiveWidth"))


function HeroTalentUpLevelLayer:onCreate()
	self:addBlackBackground()

	self.menu_res = cpp.UIMenu:create()
    self.menu_res:setPosition(0, 0)
    self.node_up_level_res:addChild(self.menu_res)
end

function HeroTalentUpLevelLayer:setMaxLevel(is_max)
	self.node_max_bg:setVisible(is_max)
	self.node_not_max_bg:setVisible(not is_max)

	if is_max then
		self.btn_remove:setPositionX(0)
		self.btn_uplevel:setVisible(false)
	end
end

function HeroTalentUpLevelLayer:setCurSkillInfo(skill_id, level, name, des)
	ex.Tools:setSpriteFrame(self.spr_cur_skill_icon, string.format("skill-icon/%d.png", skill_id + math.max(0, level - 1)))

	self.lbl_cur_skill_name:setString(name)
	local view_size = cc.size(360, 60)
	if not self.cur_skill_scroll_view then
		self.cur_skill_scroll_view = cc.ScrollView:create(view_size)
		self.cur_skill_scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
		self.cur_skill_scroll_view:setPosition(113, 10)
		self.node_cur_skill:addChild(self.cur_skill_scroll_view)
		self.lbl_cur_desc = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 20)
			:setTextColor(cc.c3b(135, 95, 51))
			:setAnchorPoint(cc.p(0, 1))
			:setDimensions(view_size.width, 0)
		self.cur_skill_scroll_view:addChild(self.lbl_cur_desc)
	end
	
	self.lbl_cur_desc:setString(des)
	local lbl_size = self.lbl_cur_desc:getContentSize()
	if lbl_size.height > view_size.height then
		self.cur_skill_scroll_view:setContentSize(cc.size(view_size.width, lbl_size.height))
		self.lbl_cur_desc:setPositionY(lbl_size.height)
		self.cur_skill_scroll_view:setContentOffset(cc.p(0, view_size.height - lbl_size.height))
	else
		self.cur_skill_scroll_view:setContentSize(cc.size(view_size.width, view_size.height))
		self.lbl_cur_desc:setPositionY(view_size.height)
	end
end

function HeroTalentUpLevelLayer:setNextSkillInfo(skill_id, level, name, des)
	ex.Tools:setSpriteFrame(self.spr_next_skill_icon, string.format("skill-icon/%d.png", skill_id + math.max(0, level - 1)))

	self.lbl_next_skill_name:setString(name)
	
	local view_size = cc.size(360, 60)
	if not self.next_skill_scroll_view then
		self.next_skill_scroll_view = cc.ScrollView:create(view_size)
		self.next_skill_scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
		self.next_skill_scroll_view:setPosition(113, 10)
		self.node_next_skill:addChild(self.next_skill_scroll_view)
		self.lbl_next_desc = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 20)
			:setTextColor(cc.c3b(135, 95, 51))
			:setAnchorPoint(cc.p(0, 1))
			:setDimensions(view_size.width, 0)
		self.next_skill_scroll_view:addChild(self.lbl_next_desc)
	end
	
	self.lbl_next_desc:setString(des)
	local lbl_size = self.lbl_next_desc:getContentSize()
	if lbl_size.height > view_size.height then
		self.next_skill_scroll_view:setContentSize(cc.size(view_size.width, lbl_size.height))
		self.lbl_next_desc:setPositionY(lbl_size.height)
		self.next_skill_scroll_view:setContentOffset(cc.p(0, view_size.height - lbl_size.height))
	else
		self.next_skill_scroll_view:setContentSize(cc.size(view_size.width, view_size.height))
		self.lbl_next_desc:setPositionY(view_size.height)
	end
end

function HeroTalentUpLevelLayer:setUpLevelRes(res_list)
	for i = 1, 2 do
		self["node_res_"..i]:setVisible(#res_list >= i)

		if #res_list >= i then
			local item_config = cfg.item.item[res_list[i].item_type]
			self["lbl_res_name_"..i]:setString(ex.Tools:getLang(item_config.name))

			local res_num = ex.Player:getItemNum(res_list[i].item_type)
			self["lbl_res_num_"..i]:setString(string.format("%d/%d", res_num, res_list[i].item_num))
			if res_num >= res_list[i].item_num then
				self["lbl_res_num_"..i]:setTextColor(cc.c3b(255, 224, 178))
			else
				self["lbl_res_num_"..i]:setTextColor(cc.c3b(245, 100, 50))
			end

			local item = ex.Tools:createBackpackItem(res_list[i].item_type, res_list[i].item_num)
			item:setScale(1)
			item:setAnchorPoint(ex.a.center)
			item:setPosition(self["node_res_"..i]:getPosition())
			item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
			self.menu_res:addChild(item)
		end
	end
end

-----------------------------------------------------------------------------

function HeroTalentUpLevelCtr:onCreate()
	self:setCCBIPath("ccbi/HeroTalentUpLevelLayer.ccbi")
	self:setIsSingle(false)

	self.data = {}
	self.is_max = false
	self.talent_config = {}
	self.talent_next_config = nil
	self.heroskill_config = {}
	self.heroskill_next_config = nil
end

function HeroTalentUpLevelCtr:getLayerClass()
	return HeroTalentUpLevelLayer
end

function HeroTalentUpLevelCtr:getHeroTalentUpLevelLayer()
	return self.layer
end

function HeroTalentUpLevelCtr:openWindow(hero_id, skill_id, level, slot)
	if self:isOpened() then
		return
	end

	self.data = {}
	self.data.hero_id = hero_id
	self.data.skill_id = skill_id
	self.data.level = level
	self.data.slot = slot

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/skill-icon.plist")

	self:loadLayer()
	self:open()
	self:initData()

	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	self.layer.btn_remove:registerScriptTapHandler(handler(self, self.onRemove))
	self.layer.btn_uplevel:registerScriptTapHandler(handler(self, self.onUpLevel))
end

function HeroTalentUpLevelCtr:refresh(hero_id, skill_id, level, slot)
	if not self:isOpened() then
		return
	end

	if hero_id ~= self.data.hero_id or slot ~= self.data.slot then
		return
	end

	self.data = {}
	self.data.hero_id = hero_id
	self.data.skill_id = skill_id
	self.data.level = level
	self.data.slot = slot

	self:initData()
end

function HeroTalentUpLevelCtr:initData()
	self.talent_config = cfg.talent.getConfigByType(self.data.skill_id, self.data.level)
	self.heroskill_config = cfg.heroskill.getConfigByType(self.data.skill_id, self.data.level)

	self.is_max = cfg.heroskill.isMaxLevel(self.data.skill_id, self.data.level)
	if self.is_max then
		self.heroskill_next_config = nil
		self.talent_next_config = nil
	else
		self.heroskill_next_config = cfg.heroskill.getConfigByType(self.data.skill_id, self.data.level + 1)
		self.talent_next_config = cfg.talent.getConfigByType(self.data.skill_id, self.data.level + 1)
	end

	self:updateLayer()
end

function HeroTalentUpLevelCtr:updateLayer()
	self.layer:setCurSkillInfo(self.data.skill_id, self.data.level, ex.Tools:getLang(self.heroskill_config.lan_name), ex.Tools:getLang(self.heroskill_config.lan_describe))

	self.layer:setMaxLevel(self.is_max)

	if not self.is_max then
		self.layer:setNextSkillInfo(self.data.skill_id, self.data.level + 1, ex.Tools:getLang(self.heroskill_next_config.lan_name), ex.Tools:getLang(self.heroskill_next_config.lan_describe))

		self.layer:setUpLevelRes(self.talent_next_config.upgrade_need)
	end
end

function HeroTalentUpLevelCtr:onRemove(tag, pSender)
	local doRemove = function()
		local is_res_enough = true
		local res_num = ex.Player:getItemNum(self.talent_config.forget_need[1].item_type)
		if res_num < self.talent_config.forget_need[1].item_num then
			is_res_enough = false
		end
		
		if not is_res_enough then
			ex.MessageView:add(ex.Tools:getLang(41004))
			return
		end
		
		local req = HeroTalent_pb.GReqHeroTalentForget()
		req.hero_id = self.data.hero_id
		req.slot = self.data.slot
		NetManager:sendMessage(ProtocolID.GReqHeroTalentForget, req)
		
		self:closeWindow()
	end
	
	local res_need_path = string.format("backpack/%d.png", self.talent_config.forget_need[1].item_type)
	local str_reward = string.format("backpack/%d.png", self.talent_config.forget_reward[1].item_type)
	local str_content = string.format(ex.Tools:getLang(41302), res_need_path, self.talent_config.forget_need[1].item_num, str_reward, self.talent_config.forget_reward[1].item_num)
	ex.ConfirmCtr:openWindow(ex.Tools:getLang(41301), str_content, doRemove)
end

function HeroTalentUpLevelCtr:onUpLevel(tag, pSender)
	local is_res_enough = true
	for i,v in ipairs(self.talent_next_config.upgrade_need) do
		local res_num = ex.Player:getItemNum(v.item_type)
		if res_num < v.item_num then
			is_res_enough = false
			break
		end
	end

	if not is_res_enough then
		ex.MessageView:add(ex.Tools:getLang(41004))
		return
	end

	local req = HeroTalent_pb.GReqHeroTalentUpgrade()
	req.hero_id = self.data.hero_id
	req.slot = self.data.slot
	NetManager:sendMessage(ProtocolID.GReqHeroTalentUpgrade, req)

	self:closeWindow()
end

return HeroTalentUpLevelCtr
