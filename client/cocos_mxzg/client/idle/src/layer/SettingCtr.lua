local SettingCtr = class("SettingCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SettingLayer = class("SettingLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
local UICheckBox = require("src.comp.UICheckBox")
local HeroAnim = require("src.person.Hero")

function SettingLayer:onCreate()
	self:addBlackBackground()

	-- local win_size = cc.Director:getInstance():getWinSize();
	-- local height = Maths.min(self:getContentSize().height, win_size.height);
	-- self:setScale(height / self:getContentSize().height);

	-- 替换
	local lbl_btn_txt = cc.Label:createWithTTF(ex.Tools:getLang(41015), FONT_DEFAULT_NAME_BOLD, 16)
	:enableOutline(ex.c3b.BLACK, 1)
	:setPosition(self.btn_head:getContentSize().width / 2, 30)
	self.btn_head:addChild(lbl_btn_txt, 100)

	-- 地区选择
	self.checkbox_province = UICheckBox:createWithContentSize(cc.size(180, 40))
	self.checkbox_province:setAnchorPoint(0, 0.5)
	self.checkbox_province:setPosition(self.lbl_province:getPositionX() + 55, self.lbl_province:getPositionY())
	self:addChild(self.checkbox_province, 15)

	self.checkbox_city = UICheckBox:createWithContentSize(cc.size(180, 40))
	self.checkbox_city:setAnchorPoint(0, 0.5)
	self.checkbox_city:setPosition(self.lbl_city:getPositionX() + 55, self.lbl_city:getPositionY())
	self:addChild(self.checkbox_city, 10)
end

function SettingLayer:onUse(event,data)
	self:setHead()
end

function SettingLayer:setHead()
	local spr_head = self.btn_head:getChildByTag(10)
	if spr_head then
		spr_head:removeFromParent()
		spr_head = nil
	end

	spr_head = cc.Sprite:createWithSpriteFrameName(string.format("head-icon/%d.png", ex.Player.head_id))
	:setScale(0.8)
	:setPosition(self.btn_head:getContentSize().width / 2, self.btn_head:getContentSize().height / 2)
	self.btn_head:addChild(spr_head, 10, 10)

	local border = self.btn_head:getChildByTag(11)
	if border then
		border:removeFromParent()
		border = nil
	end
	-- ex.Player.border_id
	local border = cc.Sprite:createWithSpriteFrameName(ex.Tools:getBorderIconByIdx(ex.Player.border_id))
	:setPosition(self.btn_head:getContentSize().width / 2, self.btn_head:getContentSize().height / 2)
	self.btn_head:addChild(border, 11, 11)
end

-----------------------------------------------------------------------------
function SettingCtr:onCreate()
	self:setCCBIPath("ccbi/SettingLayer.ccbi")
	self:setIsSingle(false)
end

function SettingCtr:getLayerClass()
	return SettingLayer
end

function SettingCtr:getSettingLayer()
	return self.layer
end

function SettingCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData()
end

function SettingCtr:initData()
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	
	self.layer.btn_head:registerScriptTapHandler(handler(self, self.onChangeHead))
	self.layer.btn_edit_nick:registerScriptTapHandler(handler(self, self.onChangeNick))

	self.layer.btn_image:registerScriptTapHandler(handler(self, self.onImage))
	self.layer.btn_title:registerScriptTapHandler(handler(self, self.onTitle))
	self.layer.btn_setting:registerScriptTapHandler(handler(self, self.onSetting))

	self.layer:addEvent(EVENT.BORDER_EVENT.ACTIVE_UPDATE,handler(self,self.updateLayer))
	self.layer:addEvent(EVENT.BORDER_EVENT.USE_UPDATE,handler(self,self.updateLayer))
	self.layer:addEvent(EVENT.BORDER_EVENT.HEAD_USE_UPDATE,handler(self,self.updateLayer))

	local vec_province, cur_province_idx = ex.Player:getChatProvinceList()
	local vec_city, cur_city_idx = ex.Player:getChatCityList()

	if is_show_battle_ship then
		ex.MessageView:add(vec_province[cur_province_idx].name)
		ex.MessageView:add(vec_city[cur_city_idx].name)
	end


	self.layer.checkbox_province:setCheckItemList(vec_province, cur_province_idx)
	self.layer.checkbox_province:setSelectedCallback(handler(self, self.onSelectedChatProvince))
	self.layer.checkbox_province:setMenuItemCallback(handler(self, self.onSelectedChatProvinceItem))
	self.layer.checkbox_city:setCheckItemList(vec_city, cur_city_idx)
	self.layer.checkbox_city:setSelectedCallback(handler(self, self.onSelectedChatCity))
	self.layer.checkbox_city:setMenuItemCallback(handler(self, self.onSelectedChatCityItem))

	self.layer.lbl_role_name:setString(ex.Player.nick)
	self.layer.lbl_role_id:setString(ex.Tools:getLang(87)..ex.Player.role_id)
	-- 等级：%d级
	self.layer.lbl_role_level:setString(ex.Player.level)

	if ex.Player.clan_data.clan_id > 0 then
		self.layer.lbl_clan_name:setString(ex.Player.clan_data.clan_name)
	else
		self.layer.lbl_clan_name:setString(ex.Tools:getLang(47033))
	end

	if cfg.socialplatform.isOpen("chat_province") ~= true then
		self.layer.lbl_province:setVisible(false)
		self.layer.lbl_city:setVisible(false)
		self.layer.checkbox_province:setVisible(false)
		self.layer.checkbox_city:setVisible(false)
	end
	
	self:updateLayer()
end

function SettingCtr:updateLayer()
	self.layer:setHead()
	self:updateHeroList()
end

function SettingCtr:onSelectedChatProvince(visible)
	if visible then
		self.layer.checkbox_city:showCheckMenu(false)
	end
end

function SettingCtr:onSelectedChatProvinceItem(idx, name)
	if idx <= 0 then
		return
	end
	if idx == ex.Player.area_idx then
		return
	end

	ex.Player:setChatAreaWithIdx(idx, true)

	-- 刷新城市checkbox显示
	local vec_city, cur_city_idx = ex.Player:getChatCityList()

	self.layer.checkbox_city:setCheckItemList(vec_city, cur_city_idx)
end

function SettingCtr:onSelectedChatCity(visible)
	if visible then
		self.layer.checkbox_province:showCheckMenu(false)
	end
end

function SettingCtr:onSelectedChatCityItem(idx, name)
	if idx <= 0 then

	end

	if idx == ex.Player.area_idx then
		return
	end

	ex.Player:setChatAreaWithIdx(idx, true)
end

function SettingCtr:onChangeHead(tag, pSender)
	-- 改头像
	require("src.layer.SettingChooseCtr"):instance():openWindow(1)
end

function SettingCtr:onImage(tag, pSender)
	-- 改形象
	require("src.layer.SettingChooseCtr"):instance():openWindow(3)
end

function SettingCtr:onIdentification(tag, pSender)
	-- 设置尊贵标识
	require("src.layer.SettingChooseCtr"):instance():openWindow(4)
end

function SettingCtr:onTitle(tag, pSender)
	-- 设置称号
	require("src.layer.SettingChooseCtr"):instance():openWindow(5)
end

function SettingCtr:onSetting(tag, pSender)
	-- 高级设置
	require("src.layer.SettingSuperCtr"):instance():openWindow()
end

function SettingCtr:onChangeNick(tag, pSender)
	-- 改昵称
	require("src.layer.ChangeNickCtr"):instance():openWindow(1)
end

function SettingCtr:onChangeNickDone()
	-- 改昵称成功，刷新昵称显示
	--通过道具改名卡改名layer会丢失防止报错
	if self.layer == nil then
		return
	end
	self.layer.lbl_role_name:setString(ex.Player.nick)
end

function SettingCtr:updateHeroList()
	-- 更新显示英雄列表
    local battle_config = cfg.battletype.battletype[BattleType.CHAPTER]
	local vec_selected = ex.Player.lineup_data:getLineup(battle_config.save_line_up_type).hero_list

	local vec_hero = {}
	for i,v in ipairs(vec_selected) do
		local hero_data = ex.Player.hero_data:getHeroDataById(v.hero_id)
		if hero_data ~= nil and i ~= LineupIdxAssist then
			table.insert(vec_hero, hero_data)
		end
	end

    -- 显示玩家队伍
    self.layer.menu_hero:removeAllChildren()

    local start_x = - #(vec_hero) * 80 / 2

    for i,v in ipairs(vec_hero) do
        local hero_data = v

        local item = UIMenuItemHero:createWithData(hero_data.hero_id, hero_data.hero_type, nil, hero_data.level, hero_data.star)

        item:setScale(0.7)
        item:setEnableAction(false)
        item:setTag(i + 1)
        item:setPosition(start_x + (i - 0.5) * 80, 0)
        :registerScriptTapHandler(handler(self, self.onHeroInfo))
        self.layer.menu_hero:add(item)

        item.server_id = cc.UserDefault:getInstance():getIntegerForKey("server_id")
        item.role_id = ex.Player.role_id
        item.hero_id = hero_data.hero_id
    end
end

function SettingCtr:onHeroInfo(tag, pSender)
    if pSender.server_id == nil or pSender.role_id == nil or pSender.hero_id == nil then
        return
    end

    local req = HeroShare_pb.GReqHeroBriefInfo()
    req.server_id = pSender.server_id
    req.rid = pSender.role_id
    req.hero_id = pSender.hero_id
    NetManager:sendMessage(ProtocolID.GReqHeroBriefInfo, req)
end

return SettingCtr
