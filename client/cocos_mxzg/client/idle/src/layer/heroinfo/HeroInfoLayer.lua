local HeroInfoLayer = class("HeroInfoLayer", require("src.comp.EventLayer"))

local btn_tab_list = {
	{idx = 1, name = "btn_up_level", label = ex.Tools:getLang(5741), tag = 1, condition = ""},
	{idx = 2, name = "btn_up_star", label = ex.Tools:getLang(5742), tag = 2, condition = "isShowStarLayer"},
	{idx = 3, name = "btn_awaken", label = ex.Tools:getLang(5746), tag = 3, condition = "isShowAwakenLayer"},
	{idx = 4, name = "btn_up_stone", label = ex.Tools:getLang(5743), tag = 4, condition = "isShowStoneLayer"},
	{idx = 5, name = "btn_talent", label = ex.Tools:getLang(5744), tag = 5, condition = "isShowTalentLayer"},
	{idx = 6, name = "btn_godequip", label = ex.Tools:getLang(5745), tag = 6, condition = "fv"},
	{idx = 7, name = "btn_alice", label = ex.Tools:getLang(580501), tag = 7, condition = "fv"},
}

local TAB_ID =
{
	UP_LEVEL = 1,
	UP_STAR = 2,
	AWAKEN = 3,
	UP_STONE = 4,
	TALENT = 5,
	GODEQUIP = 6,
	ALICE = 7,
}

local unflod_type = {
	FU_HUN 			= 1,--附魂
	PI_FU  			= 2,--皮肤
	CHONG_WU 		= 3,--宠物
	TU_TENG 		= 4,--图腾
	SIX_MANG_XING 	= 5,--六芒星
	MO_ZHANG 		= 6,--魔杖
	CHONG_SHENG 	= 7 --重生
}
local unflod_data = {
	{open_view = "onSoul",		add_red = "checkSoulReddot", 		sprite_icon = "hero-info-2/btn-fuhun.png", name = ex.Tools:getLang(6408)},
	{open_view = "onSkin",		add_red = "checkSkinReddot", 		sprite_icon = "hero-info-2/btn-pifu.png", name = ex.Tools:getLang(5507)},
	{open_view = "onPet", 		add_red = "checkPetReddot", 		sprite_icon = "hero-info-2/btn-chongwu-none.png", name = ex.Tools:getLang(4811)},
	{open_view = "onTotem", 	add_red = "checkTotemReddot", 		sprite_icon = "hero-info-2/btn-tuteng-none.png", name = ex.Tools:getLang(76801)},
	{open_view = "onHexagram", 	add_red = "checkHexagramReddot", 	sprite_icon = "hero-info-2/btn-lmx.png", name = ex.Tools:getLang(57000)},
	{open_view = "onMagicWand", add_red = "checkMagicWandReddot", 	sprite_icon = "hero-info-2/btn-mz.png", name = ex.Tools:getLang(57100)},
	{open_view = "onResetLife", add_red = "", sprite_icon = "hero-info-2/btn_reset.png", name = ex.Tools:getLang(47511)}
}

function HeroInfoLayer:onCreate()
    self:setAutoClose(false)
	self:setSwallowTouches(false)

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/artifacts.plist")
	sfc:addSpriteFrames("ccbi-res/pet-icon.plist")

	self.node_name:setLocalZOrder(2)
    self.node_equip:setLocalZOrder(3)
	self.node_equip:reorderChild(self.menu_equip, 100)
	self.node_equip:setScale(math.min(1, ex.s.global_scale))

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/skill-icon.plist")
	sfc:addSpriteFrames("ccbi-res/runes.plist")

	self.last_attack = 0
	self.select_idx = 0

	self.onlyShowType = false

    self.spr_bg:setScale(ex.p.width / self.spr_bg:getContentSize().width, ex.p.height / self.spr_bg:getContentSize().height)
	self.spr_bg:setPosition(ex.p.center().x - self:getPositionX(), ex.p.center().y - self:getPositionY())
	
	self.spr_pannel_bg:setContentSize(cc.size(ex.p.width, self.spr_pannel_bg:getContentSize().height))

	self:setExitCallback(handler(self,self.exitCallback))

	self.hero_data = ex.Player.hero_data.promote:getSelectHero()
	self.hero_list = ex.Player.hero_data:getHeroList()
	for i,v in ipairs(self.hero_list) do
		if v.hero_id == self.hero_data.hero_id then 
			self.select_idx = i
			break
		end 
	end

	self.btn_left:setPositionX(-ex.p.width * 0.5 + 50)
	self.btn_right:setPositionX(ex.p.width * 0.5 - 50)

	self.btn_left:registerScriptTapHandler(handler(self, self.onLeft))
	self.btn_right:registerScriptTapHandler(handler(self, self.onRight))
	self.btn_right:getNormalImage():setFlippedX(true)

	local conf = cfg.herotype.star[self.hero_data.hero_type]
	self.icon_elem:setSpriteFrame("hero-icon/elem-" .. conf.elem .. ".png")

	self:addRedDotNode(RedDotType.ZCJ_DHYX_YXXX_SXT, self.btn_up_star)

	local notch_height = require("src.model.Game"):instance():getNotchHeight()
	self.btn_back:setPositionY(self.btn_back:getPositionY() - notch_height * 0.5)
	self.btn_back:registerScriptTapHandler(handler(self, self.onBack))
	
	print("self.hero_data.hero_type", self.hero_data.hero_type)
	self.lbl_hero_name:setString(ex.Tools:getLang(self.hero_data.hero_type))
	self.icon_elem:setPositionX(self.lbl_hero_name:getPositionX() - self.lbl_hero_name:getContentSize().width / 2 - 20)

	self.btn_wear:setLabelText(ex.Tools:getLang(47463))
    self.btn_disboard:setLabelText(ex.Tools:getLang(47385))
    self.btn_wear:registerScriptTapHandler(handler(self, self.onClickWear))
    self.btn_disboard:registerScriptTapHandler(handler(self, self.onClickDisboard))
    self.btn_wear:setLabelColor(cc.WHITE)
    self.btn_disboard:setLabelColor(cc.WHITE)
    self.btn_wear:setLabelSize(40)
    self.btn_disboard:setLabelSize(40)
    self.btn_wear:setLabelOutLine(FONT_BLACK_C4B)
	self.btn_disboard:setLabelOutLine(FONT_BLACK_C4B)
	
	-- 进化按钮
	self.btn_evolution:setLabelText(ex.Tools:getLang(76335))
	local can_evolution = cfg.heroevolvelevel.checkEvolution(self.hero_data, self.hero_data.evolve)
	self.btn_evolution:setVisible(can_evolution)
	self.btn_evolution:setLabelColor(cc.WHITE)
	self.btn_evolution:setLabelSize(44)
	self.btn_evolution:setLabelOffset(cc.p(0, -2))
    -- self.btn_evolution:setLabelOutLine(FONT_BLACK_C4B)
	self.btn_evolution:registerScriptTapHandler(handler(self, self.onEvolution))

	-- 进化标记
	if self.hero_data.evolve and type(self.hero_data.evolve.level) == "number" and self.hero_data.evolve.level > 0 then
		self.lbl_evolution_lv:setString(string.format("+%s", self.hero_data.evolve.level))
		self.node_evolve:setVisible(true)
	else
		self.node_evolve:setVisible(false)
	end

    local red = cc.Sprite:createWithSpriteFrameName("other/spr-reddot-1.png")
	red:setName("redPoint")
	self.btn_wear:addChild(red)
	red:setLocalZOrder(100)
	red:setPosition(self.btn_wear:getContentSize().width * 0.95,self.btn_wear:getContentSize().height * 0.9)
	red:setVisible(false)

    self.layer_up_level = require("src.layer.heroinfo.HeroInfoUpLevelLayer"):createWithCCBIFile("ccbi/HeroInfoUpLevelLayer.ccbi")
    self.layer_up_level:setAutoClose(false)
	self.layer_up_level:setSwallowTouches(false)
	self.layer_up_level:setPosition(self:getContentSize().width / 2 - self.layer_up_level:getContentSize().width / 2, -30)
	self:addChild(self.layer_up_level)
	btn_tab_list[1].layer = self.layer_up_level
	
	self.layer_up_level.btn_attr_detail:registerScriptTapHandler(handler(self, self.onAttrDetail))

	self.layer_up_star = require("src.layer.heroinfo.HeroInfoUpStarLayer"):createWithCCBIFile("ccbi/HeroInfoUpStarLayer.ccbi")
    self.layer_up_star:setAutoClose(false)
	self.layer_up_star:setSwallowTouches(false)
	self.layer_up_star:setPosition(self:getContentSize().width / 2 - self.layer_up_star:getContentSize().width / 2, -30)
	self.layer_up_star.btn_up_star:registerScriptTapHandler(handler(self, self.onClickUpStar))
    self:addChild(self.layer_up_star)
	local redPoint =  ex.Player.hero_data.promote:getHeroUpStarRedPoint(self.hero_data.hero_id)

	self.layer_up_star:setVisible(false)
	btn_tab_list[2].layer = self.layer_up_star

	-- add 熊梦 英雄觉醒
	self.layer_awaken = require("src.layer.heroinfo.HeroInfoAwakenLayer"):createWithCCBIFile("ccbi/HeroInfoAwakenLayer.ccbi")
    self.layer_awaken:setAutoClose(false)
	self.layer_awaken:setSwallowTouches(false)
	self.layer_awaken:setPosition(0, -30)
	self:addChild(self.layer_awaken)
	btn_tab_list[3].layer = self.layer_awaken

	self.layer_up_stone = require("src.layer.heroinfo.HeroInfoUpStoneLayer"):createWithCCBIFile("ccbi/HeroInfoUpStoneLayer.ccbi")
    self.layer_up_stone:setAutoClose(false)
	self.layer_up_stone:setSwallowTouches(false)
	self.layer_up_stone:setPosition(self:getContentSize().width / 2 - self.layer_up_stone:getContentSize().width / 2, -30)
	self.layer_up_stone.node_all:setScale(math.min(1, ex.s.global_scale))
    self:addChild(self.layer_up_stone)

	self.layer_up_stone:setVisible(false)
	btn_tab_list[4].layer = self.layer_up_stone

	self.layer_talent = require("src.layer.heroinfo.HeroInfoTalentLayer"):createWithCCBIFile("ccbi/HeroInfoTalentLayer.ccbi")
    self.layer_talent:setAutoClose(false)
	self.layer_talent:setSwallowTouches(false)
	self.layer_talent:setPosition(0, -30)
	self:addChild(self.layer_talent)
	self.layer_talent:setVisible(false)
	btn_tab_list[5].layer = self.layer_talent

	self.layer_godequip = require("src.layer.heroinfo.HeroInfoGodEquipLayer"):createWithCCBIFile("ccbi/HeroInfoGodEquipLayer.ccbi")
    self.layer_godequip:setAutoClose(false)
	self.layer_godequip:setSwallowTouches(false)
	self.layer_godequip:setPosition(0, -30)
	self.layer_godequip.node_all:setScale(math.min(1, ex.s.global_scale))
	self:addChild(self.layer_godequip)
	self.layer_godequip:setVisible(false)
	btn_tab_list[6].layer = self.layer_godequip
	
	self.cur_tag = self:getBtnTabTagList()[1].idx
	self:initScrollViewTab()

	self:updateHasRes()
	self:updateLayer()
    -- 创建一个骨骼动画
	self:createSpine()
	
    self:createStar()

    self:setEquipBtnEvent()
	self:setRunesBtnEvent()
	self:setArtifactBtnEvent()
    self:registerEvent()
    self:checkRedPoint()
	self:setRunesVisible()
	self:createBat()

	self:checkHasUpHeroStone()
	self:checkUnfoldVisible()

	local node_touch = cc.Node:create()
	self:addChild(node_touch, 9999)

	self:addEvent(EVENT.HERO_INFO_EVENT.UPDATA_HREO_RESET,handler(self,self.checkUnfoldVisible))
	
	self.menu_equip:setCascadeOpacityEnabled(true)
	self.listener_touch = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
    self.listener_touch:registerScriptHandler(function()
		return true
	end, cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener_touch:registerScriptHandler(
		function(touch, event)
			if touch:getLocation().y >= self.btn_disboard:convertToWorldSpace(cc.p(0, 0)).y - 10  then
				self:activeEquip()
			end
		end, cc.Handler.EVENT_TOUCH_ENDED)
    local event_dispatcher = node_touch:getEventDispatcher() 
	event_dispatcher:addEventListenerWithSceneGraphPriority(self.listener_touch, node_touch)
	self:activeEquip()

	local req_detail = Hero_pb.GReqHeroDetail()
    req_detail.hero_id = self.hero_data.hero_id
	NetManager:sendMessage(ProtocolID.GReqHeroDetail, req_detail)
end

function HeroInfoLayer:activeEquip()
	self.menu_equip:stopActionByTag(10)
	local ba = 255
	local ea = 150

	local action = cc.Sequence:create(
		cc.FadeTo:create(0.1, ba),
		cc.DelayTime:create(5),
		cc.FadeTo:create(2.3, ea)
	)
	action:setTag(10)
	self.menu_equip:runAction(action)
end

function HeroInfoLayer:onTotem(tag,pSender)
	local totem_data = ex.Player.hero_data.totems:getTotemByHero(self.hero_data.hero_id)
	if not totem_data then 
		local data = ex.Player.hero_data.totems:getTotemsList()
		require("src.layer.totems.TotemListCtr"):instance():openWindow(data)
	else
		require("src.layer.totems.TotemInfoCtr"):instance():openWindow(self.hero_data.hero_id)
	end
end

function HeroInfoLayer:changePetStatus( )
	local pet_data = ex.Player.hero_data.pet:getPetByHeroId(self.hero_data.hero_id)
	local is_red = ex.Player.hero_data.pet:checkRedPointByHeroId(self.hero_data.hero_id)
	self.menu_pet:removeAllChildren()
	
	if not pet_data then 
		self.btn_pet = cpp.UIMenuItemImage:createWithSpriteFrameName("pet/btn-icon.png", nil, nil)
		-- local spr = cc.Sprite:createWithSpriteFrameName("pet/btn-icon.png")
		-- ex.Tools:setGrayAuto(spr,not pet_data)
		-- self.btn_pet:setNormalImage(spr)
		-- ex.Tools:setGrayAuto(self.btn_pet:getNormalImage(),not pet_data)
		ex.Tools:addRedPoint(self.btn_pet,is_red,cc.p(0.9,0.9))

		local lbl_text = cc.Label:createWithTTF(ex.Tools:getLang(4811), FONT_DEFAULT_NAME_BOLD, 18)
		lbl_text:setAnchorPoint(cc.p(0.5, 0.5))
		lbl_text:setTextColor(cc.c3b(255,255,255))
		lbl_text:enableOutline(cc.c3b(0,75,129),2)
		self.btn_pet:addChild(lbl_text)
		lbl_text:setPosition(self.btn_pet:getContentSize().width / 2,9)
	else
		self.btn_pet = cpp.UIMenuItemImage:createWithSpriteFrameName("pet/spr-border.png", nil, nil)
		local spr = cc.Sprite:createWithSpriteFrameName(string.format("pet-icon/%s.png",pet_data.sys_id))
		-- spr:setScale(0.6)
		ex.Tools:setGrayAuto(spr,not pet_data)
		self.btn_pet:addChild(spr)
		spr:setPosition(self.btn_pet:getContentSize().width / 2,self.btn_pet:getContentSize().height / 2)
		local lbl_text = cc.Label:createWithTTF(ex.Tools:getLang(4811), FONT_DEFAULT_NAME_BOLD, 18)
		lbl_text:setAnchorPoint(cc.p(0.5, 0.5))
		lbl_text:setTextColor(cc.c3b(255,255,255))
		lbl_text:enableOutline(cc.c3b(0,75,129),2)
		self.btn_pet:addChild(lbl_text)
		lbl_text:setPosition(self.btn_pet:getContentSize().width / 2,9)
		ex.Tools:addRedPoint(self.btn_pet,is_red,cc.p(0.9,0.9))
	end
	self.menu_pet:addChild(self.btn_pet)
	self.btn_pet:registerScriptTapHandler(handler(self, self.onPet))
end

function HeroInfoLayer:initScrollViewTab()
	self:resetTabSelect()

	self.scroll_view_tab:setViewSize(cc.size(ex.p.width - 15, self.scroll_view_tab:getViewSize().height))
	self.scroll_view_tab:getContainer():removeAllChildren()

	self:initBtnTab()
    local menu_tab = cpp.UIMenu:create()
    menu_tab:setIsTouchInsideNode(self.scroll_view_tab)
    menu_tab:setSwallowsTouches(false)
    menu_tab:setPosition(cc.p(0, 0))
    self.scroll_view_tab:addChild(menu_tab)

    -- 添加导航条
	local margin_x, space_x, item_size, scale = 15, 10, nil, 1
	local tag_list = self:getBtnTabTagList()
	local tag_num = #tag_list
	for i,v in ipairs(tag_list) do
        self[v.name] = cpp.UIMenuItemTab:create("button/btn-tab-23.png", "button/btn-tab-24.png", "", 1, 1)
        self[v.name]:setScale(scale)
        if not item_size then 
            item_size = self[v.name]:getContentSize()
            item_size.width = item_size.width * scale
            item_size.height = item_size.height * scale
        end
        self[v.name]:setTag(v.idx)
        self[v.name]:registerScriptTapHandler(handler(self, self.onTab))
        self[v.name]:setAnchorPoint(ex.a.bottom_center)
        self[v.name]:setPosition(margin_x + (i - 0.5) * item_size.width + (i - 1) * space_x, 0)
        menu_tab:addChild(self[v.name])
        self[v.name]:setLabelText(v.label)
        self[v.name]:setLabelColor(cc.c4b(122,71,45,255))
		self[v.name]:setLabelOffset(cc.p(0, -3))
		
		-- 设置tab按钮是否为灰色
		ex.Tools:setGrayAuto(self[v.name]:getNormalImage(), self:checkTabGray(v.idx))
		ex.Tools:setGrayAuto(self[v.name]:getSelectedImage(), self:checkTabGray(v.idx))
    end
    self.scroll_view_tab:setContentSize(cc.size(2 * margin_x + tag_num * item_size.width + (tag_num - 1) * space_x, self.scroll_view_tab:getViewSize().height))
	self.scroll_view_tab:setContentOffset(self.scroll_view_tab:maxContainerOffset())
	
	-- 设置选中
	for i,v in ipairs(btn_tab_list) do
		if v.tag == self.cur_tag and self[v.name] then
			self[v.name]:setChecked(true)
		end
	end

	self:checkShowStoneBtn()
	self:checkRedPoint()
	self:setBtnTabLayerVisible()
end

function HeroInfoLayer:initBtnTab()
	for i,v in ipairs(btn_tab_list) do
		self[v.name] = nil
	end
end

function HeroInfoLayer:resetTabSelect()
	local default_tag = 1
	local tag = self.cur_tag
	for i,v in ipairs(btn_tab_list) do
		if self[v.name] and self[v.condition] and self[v.condition](self) == false then
			tag = default_tag
			break
		end
	end

	-- print("cur_tag" , tag)
	self.cur_tag = tag
end

function HeroInfoLayer:isShowStarLayer()
	local heroStarCfg = cfg.herotype.star[self.hero_data.hero_type]["to_" .. self.hero_data.star+1 .."_star"]
	self.showStarLayer = heroStarCfg ~= nil and heroStarCfg ~= "" and #heroStarCfg > 0
	return self.showStarLayer
end

function HeroInfoLayer:isShowStoneLayer()
	return ex.Player.hero_data:getHeroMaxStar(self.hero_data.hero_type) > 6
end

function HeroInfoLayer:isShowTalentLayer()
	return self.hero_data.star >= cfg.system.getTalentOpenStar()
end

function HeroInfoLayer:isShowGodEquipLayer()
	local is_show = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_god_equip_wear_show")
	return is_show and self.hero_data.star >= cfg.system.god_equipment_hero_star
end

-- add 熊梦 英雄觉醒
function HeroInfoLayer:isShowAwakenLayer()
	local heroStarCfg = cfg.heroawaken.heroawaken[self.hero_data.hero_type]
	local show = false
	if heroStarCfg ~= nil then
		show = self.hero_data.star >= heroStarCfg.need_star and true or false
	end
	return show
end

function HeroInfoLayer:getBtnTabTagList()
	local tag_list = {}
	for i,v in ipairs(btn_tab_list) do
		if self[v.condition] == nil or self[v.condition](self) == true then
			table.insert(tag_list, btn_tab_list[i])
		end
	end

	return tag_list
end

function HeroInfoLayer:checkTabGray(tag, is_show_tip)
	if tag == 2 then
		local config_star = cfg.herostar.star[self.hero_data.star]
		if config_star ~= nil and config_star.world_level_require > ex.Player.world_level and config_star.role_level_require > ex.Player.level then
			if is_show_tip ~= nil and is_show_tip == true then
				ex.MessageView:add(string.format(ex.Tools:getLang(41334), config_star.world_level_require, config_star.role_level_require))
			end
			return true
		end
	elseif tag == TAB_ID.ALICE then
		if ex.Player.level < cfg.system.alice_unicorn_open_level or self.hero_data.star < cfg.system.alice_unicorn_open_star then
			if is_show_tip ~= nil and is_show_tip == true then
				ex.MessageView:add(string.format(ex.Tools:getLang(580089), cfg.system.alice_unicorn_open_level, cfg.system.alice_unicorn_open_star))
			end
			return true
		end
	end

	return false
end

function HeroInfoLayer:onTab(tag, pSender, is_force)
	-- 世界等级限制
	if self:checkTabGray(tag, true) then
		for i,v in ipairs(btn_tab_list) do
			if self[v.name] then
				self[v.name]:setChecked(self.cur_tag == v.tag)
			end
		end
		return
	end

	if tag == TAB_ID.ALICE then
		for i,v in ipairs(btn_tab_list) do
			if self[v.name] then
				self[v.name]:setChecked(self.cur_tag == v.tag)
			end
		end
		local occupation = cfg.herotype.star[self.hero_data.hero_type].occupation

		require("src.layer.alice.AliceUnicornCtr"):instance():openWindow(self.hero_data.hero_id, occupation)

		return
	end

	for i,v in ipairs(btn_tab_list) do
		if v.layer then
			v.layer:setLocalZOrder(tag == v.tag and 100 or 50)
		end
	end

	if tag == TAB_ID.UP_LEVEL then
		self:updateUpLevelLayer(tag, nil, is_force)
	elseif tag == TAB_ID.UP_STAR then
		self:updateUpStarLayer(tag, nil, is_force)
	elseif tag == TAB_ID.UP_STONE then
		self:updateUpStoneLayer(tag, nil, is_force)
	elseif tag == TAB_ID.TALENT then
		self:updateTalentLayer(tag, nil, is_force)
	elseif tag == TAB_ID.GODEQUIP then
		self:updateGodEquip(tag, nil, is_force)
	elseif tag == TAB_ID.AWAKEN then
		self:updateAwakenLayer(tag, nil, is_force)
	end
end

function HeroInfoLayer:setBtnTabChecked()
	for i,v in ipairs(btn_tab_list) do
		if self[v.name] ~= nil then
			self[v.name]:setChecked(v.tag == self.cur_tag)
		end
	end
end

function HeroInfoLayer:setBtnTabLayerVisible()
	self.layer_up_level:setVisible(self.cur_tag == TAB_ID.UP_LEVEL)
	self.layer_up_star:setVisible(self.cur_tag == TAB_ID.UP_STAR)
	self.layer_up_stone:setVisible(self.cur_tag == TAB_ID.UP_STONE)
	self.layer_talent:setVisible(self.cur_tag == TAB_ID.TALENT)
	self.layer_godequip:setVisible(self.cur_tag == TAB_ID.GODEQUIP)
	self.layer_awaken:setVisible(self.cur_tag == TAB_ID.AWAKEN)

	-- add 熊梦 解决富文本层级过高 切换到别的页面也会触发回调 不管文本是否显示都会触发
	-- 暴力偷懒办法 如果有更好的再修改
	-- 选择的不是神装页面的话 移除掉回调函数
	-- 选择的是神装页面 再把回调添加回来
	if self.cur_tag == TAB_ID.GODEQUIP then
		for i=1,4 do
			self.layer_godequip["rich_"..i]:getChildByName("rich_text"):setCallback(handler(self.layer_godequip, self.layer_godequip.openRichTextUrl))
		end
	else
		for i=1,4 do
			self.layer_godequip["rich_"..i]:getChildByName("rich_text"):removeCallback()
		end
	end
	---------------------------------------------------------------
	
end

function HeroInfoLayer:changeLayerInEnd()
    ex.MainSceneCtr:getMainScene():updateNodeRes(900001, 900101)
end

function HeroInfoLayer:refreshBtnBar()
	self.btn_left:setVisible(self.select_idx ~= 1)
	self.btn_right:setVisible(self.select_idx ~= table.nums(self.hero_list))

	local heroStarCfg = cfg.herotype.star[self.hero_data.hero_type]["to_" .. self.hero_data.star+1 .."_star"]
	self.showStarLayer = heroStarCfg ~= nil and heroStarCfg ~= "" and #heroStarCfg > 0
	self.btn_up_star:setVisible(self.showStarLayer)
	self.btn_up_stone:setVisible(ex.Player.hero_data:getHeroMaxStar(self.hero_data.hero_type) > 6)

	local is_open_talent = self.hero_data.star >= cfg.system.getTalentOpenStar()
	self.btn_talent:setVisible(is_open_talent)

	if is_open_talent then
		self.btn_talent:setPositionX(self.btn_up_star:getPositionX() + (self.showStarLayer and 150 or 0))
		self.btn_up_stone:setPositionX(self.btn_talent:getPositionX() + 150)
	else
		self.btn_up_stone:setPositionX(self.btn_up_star:getPositionX() + (self.showStarLayer and 150 or 0))
	end
	
	self:checkShowStoneBtn()
	
	-- 页面检查
	if self.cur_tag == self.btn_up_star:getTag() and not self.btn_up_star:isVisible() then
		self.cur_tag = self.btn_up_level:getTag()
		self:updateLayer()
	end

	if self.cur_tag == self.btn_talent:getTag() and not self.btn_talent:isVisible() then
		self.cur_tag = self.btn_up_level:getTag()
		self:updateLayer()
	end
end

function HeroInfoLayer:checkShowStoneBtn()
	if  self.hero_data.star < cfg.system.jewel_open_star and self.btn_up_stone then 
		self.btn_up_stone:removeChildByName("neddStar")
		if self.btn_up_stone and self.btn_up_stone:getChildByName("neddStar") == nil then
			self.showStoneNeedStar = cc.Sprite:createWithSpriteFrameName("runes/spr-unlock.png")
			if self.showStoneNeedStar ~= nil then
				self.showStoneNeedStar:setName("neddStar")
				self.btn_up_stone:addChild(self.showStoneNeedStar)
				self.showStoneNeedStar:setLocalZOrder(100)
				self.showStoneNeedStar:setPosition( self.btn_up_stone:getContentSize().width * 0.5,self.btn_up_stone:getContentSize().height + 20)
				self.showStoneNeedStar:setVisible(true)
			end
		end
	elseif self.btn_up_stone then 
		self.btn_up_stone:removeChildByName("neddStar")
	end 
end 


function HeroInfoLayer:openRichTextUrl(url)
    -- if string.len(url) <= 0 then
    --     return
	-- end
    -- self:closeWindow(0, nil)
	-- ex.JumpManager:jumpByAtom(url)

		local hero_id = self.hero_data.hero_id
		
		local callback = function ( )

			ex.Player.hero_data.promote:setSelectHero(hero_id)
			ex.MainSceneCtr:changeLayer(MainSceneType.HERO_INFO_LAYER)
		
		end
    cfg.funcopen.main_shop.open(SHOP_TYPE.MARKET, callback)
end


function HeroInfoLayer:returnCallBack( )

	ex.Player.hero_data.promote:setSelectHero(self.hero_data.hero_id)
	ex.MainSceneCtr:changeLayer(MainSceneType.HERO_INFO_LAYER)

end

function HeroInfoLayer:checkHasUpHeroStone()
	local data = ex.Player.market_data:getMarketDataByType(SHOP_TYPE.MARKET)
	local shop_list = {}
	for k,v in pairs(data or {}) do
		if  v.buy_num == 0 then 
			local conf = ex.Player.market_data:getMarketItemCfg(v.type,v.idx)
			if conf.item_type[1].item_type == ItemType.IT_HERO_UP_STONE then 
				return true 
			end 
		end 
	end
	return false 
end

function HeroInfoLayer:checkUnfoldVisible()
	local needShowCounts = self:getNeedShowCounts()
	if needShowCounts == 1 then
		if self.onlyShowType and unflod_data[self.onlyShowType] then
			local onlyData = unflod_data[self.onlyShowType]
			if onlyData.sprite_icon then
				local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(onlyData.sprite_icon)
				if frame then
					self.btn_only_show:setNormalSpriteFrame(frame)
				end
				self.btn_only_show:setLabelText(onlyData.name)
			end
		end
	end
	self.btn_only_show:setVisible(needShowCounts == 1)
	self.btn_unfold:setVisible(needShowCounts > 1)
end

function HeroInfoLayer:checkUnfoldReddot()
	local needShowCounts = self:getNeedShowCounts()
	if needShowCounts == 1 then
		if not self.onlyShowType  then
			return
		end
		if unflod_data[self.onlyShowType] then
			local onlyData = unflod_data[self.onlyShowType]
			local redPoint = self.btn_only_show:getChildByName("redPoint")
			if redPoint then
				self.btn_only_show:removeChildByName("redPoint")
			end
			if self[onlyData.add_red] then
				local is_reddot = self[onlyData.add_red](self)
				ex.Tools:addRedPoint(self.btn_only_show, is_reddot, ex.r.p8)
			end
		end
	elseif needShowCounts > 1 then
		local is_reddot = self:checkSoulReddot() or
					  self:checkSkinReddot() or
					  self:checkPetReddot() or
					  self:checkTotemReddot() or 
					  self:checkMagicWandReddot() or
					  self:checkHexagramReddot()
		ex.Tools:addRedPoint(self.btn_unfold, is_reddot, ex.r.p8)
		
	end
end

function HeroInfoLayer:getNeedShowCounts()
	local is_open_soul 		= self.hero_data.star >= cfg.heroequipsoulextra.heroequipsoulextra[1].need_star
	local is_open_skin 		= #cfg.herofashion.getConfigsByHeroType(self.hero_data.hero_type) > 0
	local is_open_pet 		= ex.Player.hero_data.pet:isOpenPetByHero(self.hero_data.hero_id)
	local is_open_totem 	= ex.Player.hero_data.totems:checkTotemOpen(self.hero_data.hero_id)
	local is_open_hexagram 	= ex.Player.hero_data.hexagram:isVisibleHexagram(self.hero_data.hero_id)
	local is_open_magicWand = ex.Player.hero_data.magic_wand:isVisibleMagicWand(self.hero_data.hero_id)
	local is_open_resetLife = ex.Player.hero_data:isShowReset(self.hero_data)	
	local needShowCounts = 	(is_open_soul and 1 or 0) +
							(is_open_skin and 1 or 0) +
							(is_open_pet and 1 or 0) +
							(is_open_totem and 1 or 0) +
							(is_open_hexagram and 1 or 0) + 
							(is_open_magicWand and 1 or 0) +
							(is_open_resetLife and 1 or 0)
	if needShowCounts == 1 then
		self.onlyShowType = (is_open_soul and unflod_type.FU_HUN or false) or
							(is_open_skin and unflod_type.PI_FU or false) or 
							(is_open_pet and unflod_type.CHONG_WU or false) or
							(is_open_totem and unflod_type.TU_TENG or false) or
							(is_open_hexagram and unflod_type.SIX_MANG_XING or false) or
							(is_open_magicWand and unflod_type.MO_ZHANG or false) or
							(is_open_resetLife and unflod_type.CHONG_SHENG or false)
	else
		self.onlyShowType = false
	end
	return needShowCounts
end

function HeroInfoLayer:onOnlyShowClick()
	if not self.onlyShowType  then
		return
	end
	if unflod_data[self.onlyShowType] then
		local onlyData = unflod_data[self.onlyShowType]
		if self[onlyData.open_view] then
			self[onlyData.open_view](self)
		end
	end
end

function HeroInfoLayer:onSoul()
	require("src.layer.heroinfo.HeroSoulCtr"):instance():openWindow()
end

function HeroInfoLayer:onSkin()
	require("src.layer.skinsystem.HeroSkinSettingCtrl"):instance():openWindow(self.hero_data.hero_id)
end

function HeroInfoLayer:onPet()
	require("src.layer.pet.PetInfoCtr"):instance():openWindow(self.hero_data.hero_id)
end

function HeroInfoLayer:onTotem()
	local totem_data = ex.Player.hero_data.totems:getTotemByHero(self.hero_data.hero_id)
	if not totem_data then 
		local data = ex.Player.hero_data.totems:getTotemsList()
		require("src.layer.totems.TotemListCtr"):instance():openWindow(data)
	else
		require("src.layer.totems.TotemInfoCtr"):instance():openWindow(self.hero_data.hero_id)
	end
end

function HeroInfoLayer:onHexagram()
	if ex.JumpManager:checkOpenConditionByAtom("hero_hexagram") ~= true then
		return
	end

	require("src.layer.herohexagram.HeroHexagramCtr"):instance():openWindow(self.hero_data.hero_id)
end

function HeroInfoLayer:onMagicWand()
	if ex.JumpManager:checkOpenConditionByAtom("hero_magic_wand") ~= true then
		return
	end

	require("src.layer.heromagicwand.HeroMagicWandWearCtr"):instance():openWindow(self.hero_data.hero_id)
end

function HeroInfoLayer:onResetLife()
	if self.hero_data.star > cfg.system.hero_level_reset_limit then
		ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
		ex.JumpManager:jumpByAtom("act_altar_reborn")
	else
		require("src.layer.heroinfo.HeroResetLifeCtr"):instance():openWindow(self.hero_data)
		NetManager:sendMessage(ProtocolID.GReqHeroLevelResetTimes)
	end
end

function HeroInfoLayer:checkMagicWandReddot()
	return ex.Player.hero_data.magic_wand:checkReddot(self.hero_data.hero_id)
end

function HeroInfoLayer:checkHexagramReddot()
	return ex.Player.hero_data.hexagram:checkReddot(self.hero_data.hero_id)
end

function HeroInfoLayer:checkSoulReddot()
	return ex.Player.hero_data.equip:checkSoulReddot(self.hero_data.hero_id)
end

function HeroInfoLayer:checkTotemReddot()
	return ex.Player.hero_data.totems:checkRedPointByHeroId(self.hero_data.hero_id)
end

function HeroInfoLayer:checkPetReddot( )
	return ex.Player.hero_data.pet:checkRedPointByHeroId(self.hero_data.hero_id)
end

function HeroInfoLayer:checkSkinReddot()
	return ex.Player.hero_data.fashion:checkSkinReddot(self.hero_data.hero_type);
	-- local fashion_list = cfg.herofashion.getConfigsByHeroType(self.hero_data.hero_type)
	-- local is_actionable = false
	-- for i, h in ipairs(fashion_list) do
	-- 	local is_active = ex.Player.hero_data.fashion:isActive(h.fashion_id)
	-- 	-- add 熊梦 英雄皮肤是否可以激活
	-- 	if not is_active and ex.Player.hero_data.fashion:isActionable(h.fashion_id) then
	-- 		is_actionable = true
	-- 		break
	-- 	end
	-- 	-- add 熊梦 英雄皮肤是否可以升级
	-- 	local data = ex.Player.hero_data.fashion:getFashionDataByID(h.fashion_id)
	-- 	if data ~= nil then
	-- 		local max_config = cfg.herofashionup.getMaxConfigByType(h.fashion_id)
	-- 		local max_level = max_config.level
	-- 		local level = is_active and data.level or 0
	-- 		local up_config = cfg.herofashionup.getConfigByTypeAndLevel(h.fashion_id, math.max(0, math.min(max_level, level)))
	-- 		local is_upgrade_show =  is_active and data.status == 0 and up_config.level < max_level 
	-- 		if ex.Player.hero_data.fashion:isCanUpgrade(h.fashion_id, level) and is_upgrade_show then
	-- 			is_actionable = true
	-- 			break
	-- 		end
	-- 	end
	-- end
	-- return is_actionable
end

-- function HeroInfoLayer:checkPetReddot()
-- 	return ex.Player.hero_data.pet:checkRedPointByHeroId(self.hero_data.hero_id)
-- end

-- add 熊梦 附魂
-- function HeroInfoLayer:checkBtnSoul()
-- 	local need_star = cfg.heroequipsoulextra.heroequipsoulextra[1].need_star
-- 	self.btn_soul:setVisible(self.hero_data.star >= need_star)
-- 	local is_actionable = false

-- 	local max_level = {0,0,0,0}
-- 	for i,v in ipairs(cfg.heroequipsoul.heroequipsoul) do
-- 		max_level[v.place] = v.level > max_level[v.place] and v.level or max_level[v.place]
-- 	end

-- 	local equip = ex.Player.hero_data.equip:getHeroEquip(self.hero_data.hero_id).equip_list
-- 	for i,v in pairs(equip) do
-- 		if v.item_type ~= nil and v.item_type ~= 0 then
-- 			local config = cfg.equipmenttype.equip[v.item_type]
-- 			local requirement = cfg.heroequipsoulextra.heroequipsoulextra[i]
-- 			if config.star >= requirement.need_equip_star and config.rare >= requirement.need_euqip_rare then
-- 				if v.soul_lv < max_level[i] then
-- 					for j,k in pairs(cfg.heroequipsoul.heroequipsoul) do
-- 						if i == k.place then
-- 							if k.level == v.soul_lv + 1 then
-- 								local num = 0
-- 								for w,g in pairs(k.cost) do
-- 									if ex.Player:getItemNum( g.item_type) >= g.item_num then
-- 										num = num + 1
-- 									end
-- 								end
-- 								if num == 2 then
-- 									is_actionable = true
-- 									break
-- 								end
-- 							end
-- 						end
-- 					end
-- 				end
-- 			end
-- 		end
		
-- 		if is_actionable then
-- 			break
-- 		end
-- 	end
-- 	ex.Tools:addRedPoint(self.btn_soul, is_actionable, ex.r.p8)
-- end


function HeroInfoLayer:createBat()
	self.lbl_attack = cc.Label:createWithBMFont("font/red-26.fnt",self.hero_data.fighting)  --cpp.StringUtil:convertScientific(last_attack), cpp.StringUtil:convertScientific(math.abs(add_attack))))
	-- self.lbl_attack:setOpacity(last_opacity)
	self.lbl_attack:setAnchorPoint(cc.p(0.5, 0.5))
	self.bat_node:addChild(self.lbl_attack, 50)
	self.bat_node:setLocalZOrder(9999)
	self.lbl_attack:setPosition(20, 0)
end

function HeroInfoLayer:onLeft(tag,pSender)
	if self.hero_list[self.select_idx - 1] ~= nil then 
		self.select_idx = self.select_idx - 1 
		self:changeHero(self.select_idx)
	end
end

function HeroInfoLayer:onRight(tag,pSender)
	if self.hero_list[self.select_idx + 1] ~= nil then 
		self.select_idx = self.select_idx + 1 
		
		self:changeHero(self.select_idx)
	end
end

function HeroInfoLayer:changeHero(idx)
	self.hero_data = self.hero_list[idx]


	local req_detail = Hero_pb.GReqHeroDetail()
    req_detail.hero_id = self.hero_data.hero_id
	NetManager:sendMessage(ProtocolID.GReqHeroDetail, req_detail)
	
	
	self:initScrollViewTab()	-- 刷新按钮

	self.layer_up_level.hero_data = self.hero_data
	self.layer_up_star.hero_data = self.hero_data
	ex.Player.hero_data.promote:setSelectHero(self.hero_data.hero_id)
	ex.Player.hero_data.promote:resetComsumeHeroList()

	-- 更新天赋界面
	self:eventUpdateTalentLayer(nil, nil, true)
	self.layer_up_stone:setHeroData(self.hero_data.hero_id, self.hero_data.star) 

	self.layer_godequip:updateItems(self.hero_data.hero_id, self.hero_data.star)

	self:createSpine()
	self:updateHeroEquip()
	self:updateRunes()
	self:updateLayer()
	self:createStar()
	self:setRunesVisible()
	self:changeFighting(nil, self.hero_data.fighting)
	
	self:updateArtifact()

	self:checkRedPoint()

	local conf = cfg.herotype.star[self.hero_data.hero_type]
	self.icon_elem:setSpriteFrame("hero-icon/elem-" .. conf.elem .. ".png")

	self.lbl_hero_name:setString(ex.Tools:getLang(self.hero_data.hero_type))
	self.icon_elem:setPositionX(self.lbl_hero_name:getPositionX() - self.lbl_hero_name:getContentSize().width / 2 - 20)

	local can_evolution = cfg.heroevolvelevel.checkEvolution(self.hero_data, self.hero_data.evolve)
    self.btn_evolution:setVisible(can_evolution)

	-- 进化标记
	if self.hero_data.evolve and type(self.hero_data.evolve.level) == "number" and self.hero_data.evolve.level > 0 then
		self.lbl_evolution_lv:setString(string.format("+%s", self.hero_data.evolve.level))
		self.node_evolve:setVisible(true)
	else
		self.node_evolve:setVisible(false)
	end

	self:checkUnfoldVisible()
	self:checkUnfoldReddot()
	-- self:checkBtnSoul()
end

function HeroInfoLayer:checkRedPoint()
	-- 检查升星条件
	ex.Player.hero_data.promote:checkUpStar(self.hero_data.hero_id)
	local star_red = ex.Player.hero_data.promote:getHeroUpStarRedPoint(self.hero_data.hero_id)
	if self.btn_up_star then
		ex.Tools:addRedPoint(self.btn_up_star, star_red)
	end 

	local maxLevel = cfg.herostar.star[self.hero_data.star].level_limit
	local grade_red = self.hero_data.level < maxLevel and self.layer_up_level.canUp and not self.layer_up_level.btn_up_grade:isVisible()
	local canUpgrade = ex.Player.hero_data.promote:getHeroCanUpgrade(self.hero_data.hero_id)
	local level_red = self.hero_data.level < maxLevel and canUpgrade

    local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(self.hero_data.hero_id) == true 

    local level_bool 
    if is_cube_hero then 
        level_bool = false 
    else 
        level_bool = grade_red or level_red
    end 

	ex.Tools:addRedPoint(self.btn_up_level, level_bool, ex.r.p9)

	-- local isred = ex.Player.hero_data.promote:getHeroUpStarRedPoint()
	-- self.layer_up_star:updateStarView()

    local update_stone_type_list = ex.Player.hero_data:checkHeroJewelRed(self.hero_data.hero_id, self.hero_data.star)
	ex.Tools:addRedPoint(self.btn_up_stone,#update_stone_type_list > 0, ex.r.p9)

	ex.Tools:addRedPoint(self.btn_talent, ex.Player.hero_data.promote:checkTalentReddot(self.hero_data.hero_id), ex.r.p9)
	
	ex.Tools:addRedPoint(self.btn_godequip, ex.Player.backpack_data:checkGodEquipRedDot(self.hero_data.hero_id,self.hero_data.star), ex.r.p9)

	ex.Tools:addRedPoint(self.btn_awaken, ex.Player.hero_data.promote:checkAwakenReddot(self.hero_data.hero_type,self.hero_data.star,self.hero_data.awaken), ex.r.p9)

	local occupation = cfg.herotype.star[self.hero_data.hero_type].occupation
	local red_point_stage = ctr.alice.data:checkNobilityReddot(self.hero_data.hero_id, occupation)
	local level_star_stage = ex.Player.level >= cfg.system.alice_unicorn_open_level and self.hero_data.star >= cfg.system.alice_unicorn_open_star
	ex.Tools:addRedPoint(self.btn_alice, level_star_stage and red_point_stage >= 0 , ex.r.p9)

	self:checkShowStoneBtn()


	local is_battle = ex.Player.hero_data.promote:heroIsBattle(self.hero_data.hero_id)
	if is_battle == false then return end 

	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXXX_SXT, star_red)

	self:checkUnfoldReddot()

end

function HeroInfoLayer:createSpine()
	if self.hero ~= nil then 
		self.hero:removeFromParent()
		self.hero = nil
	end

	local fashion_id = ex.Player.hero_data.fashion:getWearByID(self.hero_data.hero_id) or 0

	if fashion_id == 0 then
		local skin = ex.Tools:getHeroSkinByStar(self.hero_data.hero_type, self.hero_data.star, self.hero_data.evolve)
		self.hero = require("src.person.Hero"):create("12323", "123213", self.hero_data.hero_type, self.hero_data.level, self.hero_data.star, skin)

	else
		self.hero = require("src.person.Hero"):create("1", "1", 1, 1, 1, fashion_id)
	end
	self.hero:setShadowVisible(false)
    self.hero:setScale(1.5 * 1.42)
    self.hero:setPosition(0, -10)
	self.hero:registerScriptTapHandler(handler(self, self.onTouchHero))
    -- self.menu:addChild(self.hero, -1)
    self.menu_hero:addChild(self.hero)
end

function HeroInfoLayer:onBack(tag,pSender)
	ex.MainSceneCtr:changeLayer(MainSceneType.HERO_LAYER)
end

function HeroInfoLayer:onExit()
	self.cur_tag = nil
	ex.Player.hero_data.promote:checkMainCityRedPoint()
	require("src.layer.heroinfo.HeroInfoUnfoldCtr"):instance():closeWindow()
end

function HeroInfoLayer:onClickWear(tag,pSender)

	local wear_data = ex.Player.hero_data.equip:checkWearEquip(self.hero_data.hero_id)
	local count = table.nums(wear_data)
	if count == 0 then return end
	
	local req_equip_oneKey = Hero_pb.GReqHeroEquipOneKeyWear()
	req_equip_oneKey.hero_id = self.hero_data.hero_id
   for k,v in pairs(wear_data) do
		table.insert(req_equip_oneKey.sys_id, v.item_type)
	end
	
	NetManager:sendMessage(ProtocolID.GReqHeroEquipOneKeyWear,req_equip_oneKey)
    
	ex.AudioManager:playEffect("music/equip-wear-1.mp3")
end

function HeroInfoLayer:onClickDisboard(tag,pSender)
    local req_equip_disboard = Hero_pb.GReqHeroEquipOneKeyDisboard()
    req_equip_disboard.hero_id = self.hero_data.hero_id
	NetManager:sendMessage(ProtocolID.GReqHeroEquipOneKeyDisboard,req_equip_disboard)
end

function HeroInfoLayer:onAttrDetail(tag, pSender)
	require("src.layer.HeroInfoAttrCtr"):instance():openWindow(self.hero_data)

end

function HeroInfoLayer:onClickUpStar(tag,pSender)
	-- 判定升阶石是否足够
	local config_star = cfg.herostar.star[self.hero_data.star]
	if config_star.upstar_cost and next(config_star.upstar_cost) then	
		local has_num = ex.Player:getItemNum(config_star.upstar_cost[1].item_type)
		if has_num < config_star.upstar_cost[1].item_num then
			ex.Tools:showEnoughTip(config_star.upstar_cost[1].item_type, true)
			return    
		end
	end
	if config_star.need_item and config_star.need_item ~= "" then
		for i,v in ipairs(config_star.need_item) do
			local has_num = ex.Player:getItemNum(v.item_type)
			if has_num < v.item_num then
				ex.Tools:showEnoughTip(v.item_type, true)
				return    
			end
		end
	end

	local config = cfg.herotype.star[self.hero_data.hero_type]["to_".. self.hero_data.star + 1 .."_star"]
	local bool = true
	local count = 0
	for i,v in ipairs(config) do
		local num = #ex.Player.hero_data.promote:getComsumeHeroList(i)

		if v.replace_item and v.replace_item > 0 and ex.Player.hero_data.promote:getSlectReplace(i) and  ex.Player.hero_data.promote:getSlectReplace(i) == true  then 
			num = num + 1
		end 

		bool = num >= v.num 
		count = count + v.num
		if bool == false then break end
	end

	if bool == false then 
		ex.MessageView:add(ex.Tools:getLang(47186))
		return 
	end


	-- add 熊梦 策划需求 升14星(觉醒) 需要拥有3个13星以上的英雄才可以升14星
	if self.hero_data.star + 1 == ex.Player.awaken_star then
		local hero_list = ex.Player.hero_data:getHeroList()
		local hero_star = 0
		for i,v in ipairs(hero_list) do
			if v.star >= cfg.system.need_star_num[1] then 
				hero_star = hero_star + 1
				if hero_star >= cfg.system.need_star_num[2] then
					break
				end
			end 
		end

		if hero_star < cfg.system.need_star_num[2] then 
			ex.MessageView:add(ex.Tools:getLang(6309))
			return 
		end
	end

	local req_up_star = Hero_pb.GReqHeroUpStar()
	req_up_star.hero_id = self.hero_data.hero_id
    for i = 1, #config do
    	local data = ex.Player.hero_data.promote:getComsumeHeroList(i)
    	for k,v in pairs(data) do
			table.insert(req_up_star.list_hero_id,v.hero_id)
    	end
    end
	NetManager:sendMessage(ProtocolID.GReqHeroUpStar,req_up_star)

end

function HeroInfoLayer:setEquipBtnEvent()
	self.equips = {}
	for i=1,EquipMaxCount do
		self.equips[i] = self["btn_equip_" .. i]
		self.equips[i]:registerScriptTapHandler(handler(self,self.onClickEquip))
		self.equips[i]:setTag(i)
		local red = cc.Sprite:createWithSpriteFrameName("other/spr-reddot-1.png")
		red:setName("redPoint")
		self.equips[i]:addChild(red)
		red:setLocalZOrder(100)
		red:setPosition(self.equips[i]:getContentSize().width * 0.8, self.equips[i]:getContentSize().height * 0.8)
		red:setVisible(false)
		local node_star = cc.Node:create()
		node_star:setName("node_star")
		node_star:setCascadeOpacityEnabled(true)
		self.equips[i]:addChild(node_star)
		node_star:setLocalZOrder(20)
		node_star:setPosition(0, 10)

		local spr_not_equip = cc.Sprite:createWithSpriteFrameName(string.format("other/spr-equip-%s.png",i))
		self.equips[i].not_equip = spr_not_equip
		self.equips[i]:addChild(spr_not_equip)
		local size = self.equips[i]:getContentSize()
		spr_not_equip:setPosition(size.width /2 ,size.height / 2)
	end
	self:updateHeroEquip()
end

function HeroInfoLayer:onClickEquip(tag,pSender)

	local equips = ex.Player.hero_data.equip:getHeroEquip(self.hero_data.hero_id).equip_list
	if equips[tag] ~= nil and equips[tag].item_type ~= 0 then
		local data = cfg.equipmenttype.equip[equips[tag].item_type]
		local info_ctr = require("src.layer.AbilityInfoCtr"):instance()
		info_ctr:openWindow()
		:addEquipInfo(data, equips)
		:addWearButtion({str = ex.Tools:getLang(47236), call = handler(self, self.onRepleace), data = data.place},
						{str = ex.Tools:getLang(47622), call = handler(self, self.onDisboard), data = data.place, keep = false})
		:addBlackBackground()
	else
		require("src.layer.HeroEquipCtr"):instance():openWindow(tag)
	end
end

function HeroInfoLayer:setRunesBtnEvent()
	self.btn_runes = {}
	local _,reds = ex.Player.backpack_data:checkRunesRedByHero(self.hero_data.hero_id)
	for i=1, 2 do
		self.btn_runes[i] = self["btn_runes_" .. i]
		self.btn_runes[i]:registerScriptTapHandler(handler(self,self.onClickRunes))
		self.btn_runes[i]:setTag(i)
		local red = cc.Sprite:createWithSpriteFrameName("other/spr-reddot-1.png")
		red:setName("redPoint")
		self.btn_runes[i]:addChild(red)
		red:setLocalZOrder(100)
		red:setPosition(self.btn_runes[i]:getContentSize().width * 0.8, self.btn_runes[i]:getContentSize().height * 0.8)
		red:setVisible(reds[i])
		local node_star = cc.Node:create()
		node_star:setName("node_star")
		self.btn_runes[i]:addChild(node_star)
		node_star:setLocalZOrder(20)
		node_star:setPosition(0, 10)
		local key = i == 1 and "elf_1_unlock_level" or "elf_2_unlock_star"
		local value = ex.Tools:getSysCfg(key)
		local str = i == 1 and ex.Tools:getLang(47061) or ex.Tools:getLang(47566)
		str = string.format(str,value)
		str = string.format(ex.Tools:getLang(47550),str)
		-- self.btn_runes[i].lbl = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 12)
		-- self.btn_runes[i].lbl:setColor(cc.c4b(217,200,175,255))
		self.btn_runes[i].lbl = cpp.RichTextEx:createWithXMLLua("")
		:setFontSize(16)
		:setFontFace(FONT_DEFAULT_NAME_BOLD)
		:setFontColor("#ffffff")
		:setScale(1)
		:setAnchorTextShadow(true)
		:ignoreContentAdaptWithSize(true)
		:setWrapMode(1)
		:setAnchorPoint(ex.a.top_center)
		:setXmlTextLua(str)
		self.btn_runes[i]:addChild(self.btn_runes[i].lbl, 20)
		local size = self.btn_runes[i]:getContentSize()
		self.btn_runes[i].lbl:setPosition(size.width / 2, 30)
		self.btn_runes[i].lock = cc.Sprite:createWithSpriteFrameName("hero-info/spr-lock.png")
		self.btn_runes[i].lock:setScale(1.5)
		self.btn_runes[i].lock:setPosition(size.width / 2 , 55)
		self.btn_runes[i]:addChild(self.btn_runes[i].lock, 10)
	end

	self:updateRunes()
end

function HeroInfoLayer:setRunesVisible( )
	for i,v in ipairs(self.btn_runes) do
		local up_max_star = self.hero_data.star
		local hero_cfg = cfg.herotype.star[self.hero_data.hero_type]
		for j = self.hero_data.star + 1,100 do 
			local key = string.format("to_%s_star",j)
			if type(hero_cfg[key]) ~= "table" then break end 
			up_max_star = j
		end
		if i == 1 then 
			local visible = cfg.herostar.star[up_max_star] and cfg.herostar.star[up_max_star].level_limit >= ex.Tools:getSysCfg("elf_1_unlock_level")
			v:setVisible(visible)
		elseif i == 2 then 
			local need = ex.Tools:getSysCfg("elf_2_unlock_star")
			local visible = up_max_star >= ex.Tools:getSysCfg("elf_2_unlock_star")
			v:setVisible(visible)
		end
	end
end

function HeroInfoLayer:onClickRunes(tag,pSender)
	-- if pSender.isOpen == false then return end
	-- require("src.layer.runes.RunesSkillCtr"):instance():openWindow()
	if pSender.isOpen == false then
		local key = tag == 1 and "elf_1_unlock_level" or "elf_2_unlock_star"
		local value = ex.Tools:getSysCfg(key)
		if tag == 1 then 
			if self.hero_data.level < (value or 100) then
				ex.MessageView:add(ex.Tools:getLang(47188)..(value or 100))
			end
		else 
			if self.hero_data.star < (value or 8) then
				ex.MessageView:add(ex.Tools:getLang(47280)..(value or 8))
			end
		end
		return 
	end

	local runes = ex.Player.backpack_data:getRunesDataByHeroId(self.hero_data.hero_id)
	if runes[tag] ~= nil then 
		local ctr = require("src.layer.runes.RunesTipsCtr"):instance()
		ctr:openWindow()
		:addEquipInfo(runes[tag])
		:addWearButtion({str = ex.Tools:getLang(47438) , call = function()
							local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SMITH)
							layer:changeLayer(20)
							ctr:closeWindow(0, nil)
						end,data = 1 , keep = false},
						{str = ex.Tools:getLang(47520) , call = function()
							local runes = ex.Player.backpack_data:getRunesDataByHeroId(self.hero_data.hero_id)
							require("src.layer.runes.RunesRecastCtr"):instance():openWindow(runes[tag])
						end,data = 1 , keep = false},
						{str = ex.Tools:getLang(47622) , call = function()
							local runes = ex.Player.backpack_data:getRunesDataByHeroId(self.hero_data.hero_id)
							local res_up_runes = Rune_pb.GReqRuneOnOff()
							res_up_runes.hero_id = self.hero_data.hero_id
							res_up_runes.rune_id = (runes[tag].item_id or 0)
							res_up_runes.place = tag 
							res_up_runes.sign = 0
							NetManager:sendMessage(ProtocolID.GReqRuneOnOff, res_up_runes)
						end,data = 1 , keep = false},
						{str = ex.Tools:getLang(47236) , call = function()
							require("src.layer.runes.RunesSelectCtr"):instance():openWindow(handler(self, self.onClickRunesDone), tag)
							ctr:closeWindow(0, nil)
						end,data = 1 , keep = false, is_show_red = true, hero_id = self.hero_data.hero_id, place = tag})
	else
		require("src.layer.runes.RunesSelectCtr"):instance():openWindow(handler(self, self.onClickRunesDone), tag)
	end
end

function HeroInfoLayer:onClickRunesDone(runes_id, place)
	print("HeroInfoLayer:onClickRunesDone", self.hero_data.hero_id, runes_id, place)
	local req_runes_operate = Rune_pb.GReqRuneOnOff()
	req_runes_operate.hero_id = self.hero_data.hero_id
	req_runes_operate.rune_id = runes_id
	req_runes_operate.place = place
	-- 0卸下 1穿戴
	req_runes_operate.sign = 1
	NetManager:sendMessage(ProtocolID.GReqRuneOnOff, req_runes_operate)
end

function HeroInfoLayer:onDisboard(tag, pSender)
	local hero_id = ex.Player.hero_data.promote:getSelectHeroById()
    local equip_data = ex.Player.hero_data.equip:getHeroEquip(hero_id)
	local equip = equip_data.equip_list[pSender.data]
	-- dump(equip)
    local req_equip_disboard = Hero_pb.GReqHeroEquipDisboard()
    req_equip_disboard.hero_id = hero_id
    req_equip_disboard.equip_id = equip.item_id
    NetManager:sendMessage(ProtocolID.GReqHeroEquipDisboard,req_equip_disboard)
	ex.AudioManager:playEffect("music/equip-wear-1.mp3")
end

function HeroInfoLayer:onRepleace(tag,pSender)
    require("src.layer.HeroEquipCtr"):instance():openWindow(pSender.data)
end

function HeroInfoLayer:onEvolution(tag, pSender)
	local hero_data = self.hero_data
	if cfg.system.heroevo_need_herostar then
		if hero_data.star < cfg.system.heroevo_need_herostar then
			ex.MessageView:add(ex.Tools:getLang(76341))
			return
		end

		if cfg.system.heroevo_open then
			local hero_list = ex.Player.hero_data:getHerosByStarAndCondition(cfg.system.heroevo_need_herostar, ">=")
			if #hero_list < cfg.system.heroevo_open then
				ex.MessageView:add(ex.Tools:getLang(76342))
				return
			end
		end 
	end
	
	ex.MainSceneCtr:changeLayer(MainSceneType.HERO_EVOLUTION_LAYER)
end

function HeroInfoLayer:createStar()
	local typeData = cfg.herotype.star[self.hero_data.hero_type]
	local curStar = self.hero_data.star
	self.node_star:removeAllChildren()

	if self.hero_data.star < 10 then
		local star_type = math.floor(self.hero_data.star / 5)
		local star_count

		if self.hero_data.star % 5 == 0 then 
			if self.hero_data.star > 5 then
				star_count = 1
			else 
				star_count = 5
				star_type = 0
			end
		else
			star_count = self.hero_data.star % 5
		end

		local path = string.format("other/star-%d.png",star_type)

		if self.hero_data.star > 10 then star_count = star_count + 1 end

		for i=1,star_count do
			local sp = cc.Sprite:createWithSpriteFrameName(path)
			self.node_star:addChild(sp,star_count-i)
			local margin = 12
			local width = sp:getContentSize().width + margin
			local posX = -(width / 2 * star_count) / 2 + width / 2 * (i - 0.5) 
			sp:setPosition(posX,0)
		end
	else
		local spr_star_bg = cc.Sprite:createWithSpriteFrameName("backpack/spr-star-bg-2.png")
		:setPosition(cc.p(0, 0))
		self.node_star:addChild(spr_star_bg, 5)

		-- 英雄觉醒 add 熊梦 图标修改 如果加到15星需要再次修改
		if curStar == ex.Player.awaken_star then
			spr_star_bg:setSpriteFrame("backpack/spr-star-bg-4.png")
		elseif curStar > 10 then
			local spr_star = cc.Sprite:createWithSpriteFrameName("backpack/lbl-star-"..(curStar - 10)..".png")
			spr_star:setPosition(spr_star_bg:getPosition())
			self.node_star:addChild(spr_star, 10)
		end
	end
end

function HeroInfoLayer:setArtifactBtnEvent()
	self.btn_artifact = {}
	local artifact_data = ex.Player.hero_data.artifact:getArtifactDataByHeroId(self.hero_data.hero_id)
	-- local _,reds = ex.Player.backpack_data:checkRunesRedByHero(self.hero_data.hero_id)
	for i=1, 2 do

		local active_cfg = cfg.reikiequipactive.reikiequipactive[i]
		local is_visible = self.hero_data.star >= active_cfg.start 

		self.btn_artifact[i] = self["btn_artifact_" .. i]
		self.btn_artifact[i]:registerScriptTapHandler(handler(self,self.onArtifact))
		self.btn_artifact[i]:setTag(i)
		local red = cc.Sprite:createWithSpriteFrameName("other/spr-reddot-1.png")
		red:setName("redPoint")
		self.btn_artifact[i]:addChild(red)
		red:setLocalZOrder(100)
		red:setPosition(self.btn_artifact[i]:getContentSize().width * 0.75, self.btn_artifact[i]:getContentSize().height * 0.75)
		red:setVisible(false)
		self.btn_artifact[i].red = red
		local node_star = cc.Node:create()
		node_star:setName("node_star")
		self.btn_artifact[i]:addChild(node_star)
		node_star:setLocalZOrder(20)
		node_star:setPosition(0, 10)

		local size = self.btn_artifact[i]:getContentSize()
		self.btn_artifact[i].lbl = cc.Label:createWithTTF(string.format(ex.Tools:getLang(75001),active_cfg.level), FONT_DEFAULT_NAME_BOLD, 12)
		self.btn_artifact[i].lbl:setColor(cc.c4b(217,200,175,255))
		self.btn_artifact[i].lbl:setPosition(size.width / 2 , 30)
		self.btn_artifact[i]:addChild(self.btn_artifact[i].lbl, 10)

		
		-- self.btn_artifact[i].lbl:setPosition(size.width / 2, 30)
		self.btn_artifact[i].lock = cc.Sprite:createWithSpriteFrameName("hero-info/spr-lock.png")
		self.btn_artifact[i].lock:setScale(1.5)
		self.btn_artifact[i].lock:setPosition(size.width / 2 , 70)
		self.btn_artifact[i]:addChild(self.btn_artifact[i].lock, 10)


		self.btn_artifact[i].rare = cc.Sprite:create()
		-- self.btn_artifact[i].rare:setScale(1.5)
		self.btn_artifact[i].rare:setPosition(size.width / 2 , size.height / 2)
		self.btn_artifact[i]:addChild(self.btn_artifact[i].rare)
		-- local can_active = self.hero_data.level >= active_cfg.level
		-- local active = self.hero_data.reiki_places[i] ~= nil
		-- print(self.__cname,i,self.hero_data.level < active_cfg.level)
		self.btn_artifact[i].lock:setVisible(false)
		self.btn_artifact[i].lbl:setVisible(false)

		self.btn_artifact[i].icon = cc.Sprite:create()
		self.btn_artifact[i].icon:setVisible(false)
		self.btn_artifact[i]:addChild(self.btn_artifact[i].icon)
		self.btn_artifact[i].icon:setPosition(self.btn_artifact[i]:getContentSize().width / 2,self.btn_artifact[i]:getContentSize().height / 2)
		self.btn_artifact[i].icon:setVisible(false)
	end

	self:updateArtifact()
end

function HeroInfoLayer:onArtifact(tag,pSender)
	local active = type(self.hero_data.reiki_places) == "table" and self.hero_data.reiki_places[tag] ~= nil
	local artifact_data = ex.Player.hero_data.artifact:getArtifactDataByHeroId(self.hero_data.hero_id)
	if active then 
		-- local req = ReikiEquip_pb.GReqWearReikiEquip()
		-- req.hero_id = self.hero_data.hero_id
		-- req.reiki_equip_id = 10070000000015
		-- NetManager:sendMessage(ProtocolID.GReqWearReikiEquip,req)
		local btn_call_list = {}
		btn_call_list[1] = {str = ex.Tools:getLang(47236), call = function ()
			require("src.layer.artifacts.ArtifactSelectCtr"):instance():openWindow(tag)
		end, data = artifact_data[tag], atom = "replace"}

		btn_call_list[2] = {str = ex.Tools:getLang(47622), call = function()
			local req = ReikiEquip_pb.GReqDisboardReikiEquip()
			req.reiki_equip_id = artifact_data[tag].reiki_equip_id
			NetManager:sendMessage(ProtocolID.GReqDisboardReikiEquip,req)
		end, data = artifact_data[tag], atom = "wear_out"}

		if artifact_data[tag] ~= nil and
		   cfg.reikiequip.reikiequip[artifact_data[tag].sys_id].up_star_target ~= "" and 
		   table.nums(cfg.reikiequip.reikiequip[artifact_data[tag].sys_id].up_star_target) > 0 then 
			local btn_call = {str = ex.Tools:getLang(5653), call = function ()
				require("src.layer.artifacts.SmithArtifactCtr"):instance():openWindow(artifact_data[tag])
			end, data = artifact_data[tag], atom = "level_up"}
			table.insert(btn_call_list,btn_call)
		end

		if artifact_data[tag] ~= nil and cfg.reikiequip.reikiequip[artifact_data[tag].sys_id].transform_target > 0 then 
			local btn_call = {str = ex.Tools:getLang(75021), call = function ()
				require("src.layer.artifacts.ArtifactTransformCtr"):instance():openWindow(artifact_data[tag])
			end, data = artifact_data[tag], atom = "transform"}
			table.insert(btn_call_list,btn_call)
		end
		

		if artifact_data[tag] ~= nil then 
			local equip_list = {}
			local data = {}
			for k,v in pairs(artifact_data) do
				table.insert(equip_list,v.sys_id)
			end
			data.equip_list = equip_list
			local equip = {}
			equip.sys_id = artifact_data[tag].sys_id
			equip.reiki_equip_id = artifact_data[tag].reiki_equip_id
			data.equip = equip
			local ctr = require("src.layer.artifacts.ArtifactTipsCtr"):instance()
			ctr:openWindow()
			local layer = ctr:addEquipInfo(data)
			layer:addWearButtion(btn_call_list[1],btn_call_list[2],btn_call_list[3],btn_call_list[4])
			-- dump(layer.btn_level_up)
			if layer.btn_level_up then 
				local reds = ex.Player.hero_data.artifact:checkUpLevelRed(self.hero_data)
				ex.Tools:addRedPoint(layer.btn_level_up,reds[tag],cc.p(0.9,0.8))
			end
		else
			print(self.__cname,"not has equip")
			require("src.layer.artifacts.ArtifactSelectCtr"):instance():openWindow(tag)
		end
	else
		local data = {}
		data.hero_id = self.hero_data.hero_id
		local active_cfg = cfg.reikiequipactive.reikiequipactive[tag]

        local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(self.hero_data.hero_id)
        if is_cube_hero == true then 
            ex.MessageView:add(ex.Tools:getLang(77322))
            return 
        end 
		if active_cfg.level > self.hero_data.level then 
			ex.MessageView:add(string.format(ex.Tools:getLang(75001),active_cfg.level))
		else
			data.cost_item = active_cfg.cost_item
			data.place = tag
			data.reiki_equip_id = active_cfg.reiki_equip_id
			require("src.layer.artifacts.ArtifactActiveCtr"):instance():openWindow(data)
		end
	end
end

function HeroInfoLayer:updateArtifact(event,data)
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/artifacts.plist")
	local artifact_data = ex.Player.hero_data.artifact:getArtifactDataByHeroId(self.hero_data.hero_id)
	local artifact_reds = ex.Player.hero_data.artifact:checkRedPointByHeroId(self.hero_data.hero_id)
	for k,v in pairs(self.btn_artifact) do
		local active_cfg = cfg.reikiequipactive.reikiequipactive[k]
		local is_visible = self.hero_data.star >= active_cfg.start 
		-- local unlock = v.isOpen
		-- v.lbl:setVisible(not unlock)
		v:setVisible(is_visible)
		if is_visible then 
			local can_active = self.hero_data.level >= active_cfg.level
			local active = type(self.hero_data.reiki_places) == "table" and self.hero_data.reiki_places[k] ~= nil
			v.lock:setVisible(not active and self.hero_data.level < active_cfg.level)
			v.lbl:setVisible(not active and self.hero_data.level < active_cfg.level)
			self.btn_artifact[k].icon:setVisible(can_active or active)
			self.btn_artifact[k].rare:setVisible(active and artifact_data[k] ~= nil)
			self.btn_artifact[k].red:setVisible(artifact_reds[k])

			local place_name = k == 1 and "artifacts/jiezhi.png" or "artifacts/xianglian.png"
			local icon_name = (active and artifact_data[k] ~= nil) and string.format("backpack/%d.png",  artifact_data[k].sys_id) or place_name
			-- self.btn_artifact[k].icon:setSpriteFrame(icon_name)
			ex.Tools:setSpriteFrame(self.btn_artifact[k].icon, icon_name)
			if active and artifact_data[k] ~= nil then 
				ex.Tools:setSpriteFrame(self.btn_artifact[k].rare, string.format("backpack/rare-%d.png",  cfg.item.item[artifact_data[k].sys_id].rare_mark))
				-- self.btn_artifact[k].rare:setSpriteFrame(string.format("backpack/rare-%d.png",  cfg.item.item[artifact_data[k].sys_id].rare_mark))
			end
		else

		end
	end
end



function HeroInfoLayer:updateGodEquip(tag, pSender, is_force)
	if self.cur_tag == tag and not is_force then return end 
	self.cur_tag = tag

	self:setBtnTabChecked()
	self:setBtnTabLayerVisible()

	self.layer_godequip:updateItems(self.hero_data.hero_id, self.hero_data.star)

end 



function HeroInfoLayer:updateUpStoneLayer(tag, pSender, is_force)
	if  self.hero_data.star < cfg.system.jewel_open_star then 
		ex.MessageView:add(string.format(ex.Tools:getLang(54401), cfg.system.jewel_open_star))

		self:setBtnTabChecked()

		return 
	end 

	if self.cur_tag == tag and not is_force then return end 
	self.cur_tag = tag

	self:setBtnTabChecked()
	self:setBtnTabLayerVisible()

	--end
	self.layer_up_stone:setHeroData(self.hero_data.hero_id, self.hero_data.star)
end

function HeroInfoLayer:updateTalentLayer(tag, pSender, is_force)
	if self.cur_tag == tag and not is_force then return end

	self.cur_tag = tag

	self:setBtnTabChecked()
	self:setBtnTabLayerVisible()

	self.layer_talent:updateView()
end

function HeroInfoLayer:updateUpLevelLayer(tag, pSender, is_force)
	if self.cur_tag == tag and not is_force then return end 
	self.cur_tag = tag

	self:setBtnTabChecked()
	self:setBtnTabLayerVisible()

	self.layer_up_level:updateLevelView(true, true, nil, true)
end

function HeroInfoLayer:updateUpStarLayer(tag, pSender, is_force)
	if self.cur_tag == tag and not is_force then return end 
	self.cur_tag = tag

	self:setBtnTabChecked()
	self:setBtnTabLayerVisible()

	self.layer_up_star:updateStarView()
end

-- 觉醒
function HeroInfoLayer:updateAwakenLayer(tag, pSender, is_force)
	if self.cur_tag == tag and not is_force then return end

	self.cur_tag = tag

	self:setBtnTabChecked()
	self:setBtnTabLayerVisible()

	self.layer_awaken:updateView()

	self.layer_godequip:setVisible(false)

end

function HeroInfoLayer:registerEvent()
	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_LEVEL,handler(self,self.updateLevelLayer))
	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_LEVEL,handler(self,self.updateRunes))
	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_LEVEL,handler(self,self.updateArtifact))
	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_GRADE,handler(self,self.updateGradeLayer))
	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_GRADE,handler(self,self.updateRunes))
	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_STAR,handler(self,self.updateStarLayer))
	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_STAR,handler(self,self.updateHasRes))
	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_STAR,handler(self,self.updateRunes))
	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_STAR,handler(self,self.eventUpdateTalentLayer))
	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_STAR,handler(self,self.initScrollViewTab))
	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_STAR,handler(self,self.updateArtifact))
	self:addEvent(EVENT.HERO_INFO_EVENT.AWAKEN, handler(self,self.updateAwaken))
	self:addEvent(EVENT.HERO_INFO_EVENT.AWAKEN_TIPS,handler(self,self.gotoAwaken))
	
	self:addEvent(EVENT.BACK_PACK_EVENT.BACK_PACK_REFUND,handler(self,self.openRefundView))
	self:addEvent(EVENT.HERO_EQUIP_EVENT.HERO_EQUIP_CHANGE,handler(self,self.updateHeroEquip))
	self:addEvent(EVENT.HERO_EQUIP_EVENT.HERO_EQUIP_INIT_FINISH,handler(self,self.updateHeroEquip))
	self:addEvent(EVENT.BACKPACK_RES_CHANGE.ITEM_TYPE_IT_GOLD,handler(self,self.updateLevelLayer))
	self:addEvent(EVENT.RUNES_EVENT.UPDATE_HERO_RUNES,handler(self,self.updateRunes))

	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_FIGHTING_CHANGE, handler(self, self.changeFighting))
	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UPDATE_STONE,handler(self,self.updateStoneLayer))

	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UPDATE_GODEQUIP,handler(self,self.updateGodEquipLayer))


	self:addEvent(EVENT.HERO_INFO_EVENT.UPDATE_REDDOT, handler(self, self.checkRedPoint))
	
	self:addEvent(EVENT.HERO_INFO_EVENT.SOUL, handler(self, self.eventHeroSoulDataDirty))

	self:addEvent(EVENT.FASHION_SETTING.WEAR, handler(self, self.eventWearFashion))
	self:addEvent(EVENT.FASHION_SETTING.DATA_DIRTY, handler(self, self.eventFashionDataDirty))
	
	self:addEvent(EVENT.ARTIFACTS.ARTIFACT_ACTIVE, handler(self, self.onActive))
	self:addEvent(EVENT.ARTIFACTS.ARTIFACT_OUT, handler(self, self.updateArtifact))
	self:addEvent(EVENT.ARTIFACTS.ARTIFACT_CHANGE, handler(self, self.updateArtifact))
	self:addEvent(EVENT.ARTIFACTS.ARTIFACT_COMPOSE, handler(self, self.onCompose))
	self:addEvent(EVENT.ARTIFACTS.ARTIFACT_TRANSFORM, handler(self, self.onTransform))
	
	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_COMMENT_INFO,handler(self,self.openComment))

	self:addEvent(EVENT.PET.PET_CHANGE,handler(self, self.checkUnfoldReddot))
	self:addEvent(EVENT.PET.PET_OUT,handler(self,self.checkUnfoldReddot))
	self:addEvent(EVENT.PET.PET_UP_LEVEL,handler(self,self.checkUnfoldReddot))
	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_STAR,handler(self,self.checkUnfoldReddot))

	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_STAR,handler(self,self.checkUnfoldReddot))
	self:addEvent(EVENT.TOTEM.UP_GRADE,handler(self,self.checkUnfoldReddot))
	self:addEvent(EVENT.TOTEM.UP_LEVEL,handler(self,self.checkUnfoldReddot))
	self:addEvent(EVENT.TOTEM.UPDATA_EQUIP_INFO,handler(self,self.checkUnfoldReddot))
	self:addEvent(EVENT.TOTEM.RESET,handler(self,self.checkUnfoldReddot))
	
	self:addEvent(EVENT.HERO_INFO_EVENT.MAGIC_WAND_WEAR, handler(self, self.checkUnfoldReddot))
	self:addEvent(EVENT.HERO_INFO_EVENT.MAGIC_WAND_STRENGTHEN, handler(self, self.checkUnfoldReddot))
	self:addEvent(EVENT.HERO_INFO_EVENT.MAGIC_WAND_REFINE, handler(self, self.checkUnfoldReddot))

    self:addEvent(EVENT.HERO_HEXAGRAM_EVENT.UPDATE, handler(self, self.checkUnfoldReddot))
    self:addEvent(EVENT.HERO_HEXAGRAM_EVENT.UPGRADE, handler(self, self.checkUnfoldReddot))
    self:addEvent(EVENT.HERO_HEXAGRAM_EVENT.RESET, handler(self, self.checkUnfoldReddot))
end

function HeroInfoLayer:onTransform(event,data)
	self:updateArtifact(event,data)
	self:playEffect(data.place)
	local req_detail = Hero_pb.GReqHeroDetail()
    req_detail.hero_id = self.hero_data.hero_id
	NetManager:sendMessage(ProtocolID.GReqHeroDetail, req_detail)
	ex.MessageView:add(ex.Tools:getLang(75022))
end

function HeroInfoLayer:playEffect(place)
	local btn = self.btn_artifact[place]
	local size = btn:getContentSize()
	btn.spr_effect_bomb = ex.EffectFactory:createEffectWithNodeByName("active-reiki")
	btn.spr_effect_bomb:setPosition(size.width / 2, size.height / 2)
	btn:addChild(btn.spr_effect_bomb, 100)
end

function HeroInfoLayer:onActive(event,data)
	dump(data)
	self:updateArtifact(event,data)
	self:playEffect(data.place)
end

function HeroInfoLayer:onCompose(event,data)
	self:updateArtifact(event,data)
	self:playEffect(data.place)
end

function HeroInfoLayer:updateRunes(event, data)
	local runes = ex.Player.backpack_data:getRunesDataByHeroId(self.hero_data.hero_id)
	local _,reds = ex.Player.backpack_data:checkRunesRedByHero(self.hero_data.hero_id)
	for k,v in pairs(self.btn_runes) do
		local key = k == 1 and "elf_1_unlock_level" or "elf_2_unlock_star"
        local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(self.hero_data.hero_id)
        local level = is_cube_hero and self.hero_data.tweak_cube_lv or self.hero_data.level 
		local value = ex.Tools:getSysCfg(key)
		if k == 1 then 
			v.isOpen = level >= value
		else 
			v.isOpen = self.hero_data.star >= value
		end
		local unlock = v.isOpen
		v.lbl:setVisible(not unlock)
		v.lock:setVisible(not unlock)
		local red_point = v:getChildByName("redPoint")
		red_point:setVisible(reds[k])
		local config = nil
		if runes[k] ~= nil then 
			config = ex.Player.backpack_data:getTypeConfig(runes[k].item_type)
			if config ~= nil then
				if v.icon ~= nil then
					v.icon:setSpriteFrame(string.format("backpack/%d.png", runes[k].item_type))
					
					-- v.icon_frame:setSpriteFrame(string.format("backpack/rare-%d.png",  config.rare))

					v.icon_frame:setSpriteFrame(string.format("backpack/rare-%d.png", cfg.item.item[runes[k].item_type].rare_mark))
				else
					v.icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", runes[k].item_type))
					v:addChild(v.icon, 20)
					local size = v:getContentSize()
					v.icon:setScale(1.5)
					v.icon:setPosition(size.width / 2, size.height / 2 - 3)

					-- v.icon_frame = cc.Sprite:createWithSpriteFrameName(string.format("backpack/rare-%d.png", config.rare))

					v.icon_frame = cc.Sprite:createWithSpriteFrameName(string.format("backpack/rare-%d.png", cfg.item.item[runes[k].item_type].rare_mark))
					v:addChild(v.icon_frame, 10)
					v.icon_frame:setScale(1)
					local size = v:getContentSize()
					v.icon_frame:setPosition(size.width / 2, size.height / 2 - 3)

					local scale = cc.p(size.width / v.icon:getContentSize().width, size.height / v.icon:getContentSize().height)
					scale = math.min(scale.x, scale.y) * 0.8
					v.icon:setScale(scale)
				end
			end
		end
		if runes[k] == nil or config == nil then
			if v.icon ~= nil and not tolua.isnull(v.icon) then 
				v.icon:removeFromParent()
				v.icon = nil
			end
			if v.icon_frame ~= nil and not tolua.isnull(v.icon_frame) then 
				v.icon_frame:removeFromParent()
				v.icon_frame = nil
			end
		end
	end

	if event == EVENT.RUNES_EVENT.UPDATE_HERO_RUNES then
	
		self.layer_up_level:updateLevelAttrInfo()

	end
end

function HeroInfoLayer:updateHeroEquip(event,data)

	local equips = ex.Player.hero_data.equip:getHeroEquip(self.hero_data.hero_id).equip_list
	local redPoints = ex.Player.hero_data.equip:checkHeroEquipRedPoint(self.hero_data.hero_id)

	local wearRed = false
	for k,v in pairs(redPoints) do
		if v == true then wearRed = v break end
	end

	self.btn_wear:getChildByName("redPoint"):setVisible(wearRed)
	self.btn_wear:setVisible(wearRed)
	self.btn_disboard:setVisible(not wearRed and table.nums(equips) > 0)

	for i=1,EquipMaxCount do
		local equip = equips[i]

		local bg = self.equips[i]:getChildByName("bg")
		local icon = self.equips[i]:getChildByName("icon")
		local node_star = self.equips[i]:getChildByName("node_star")
		node_star:removeAllChildren()
		if bg ~= nil then 
	 		self.equips[i]:removeChildByName("bg")
	 		bg = nil 
	 	end
		if icon ~= nil then 
	 		self.equips[i]:removeChildByName("icon")
	 		icon = nil 
	 	end
	 	if equip ~= nil and equip.item_type ~= 0 then 
	 		local size = self.equips[i]:getContentSize()
	 		local config = cfg.equipmenttype.equip[equip.item_type]
	 		bg = cc.Sprite:createWithSpriteFrameName(string.format("other/rare-%d.png", cfg.item.item[equip.item_type].rare_mark))
	 		bg:setName("bg")
	 		local scale = cc.p(size.width / bg:getContentSize().width, size.height / bg:getContentSize().height)
	 		scale = math.min(scale.x, scale.y)
	 		bg:setScale(scale)
	 		bg:setPosition(size.width * 0.5, size.height * 0.5)
	 		self.equips[i]:addChild(bg, 9)
	 		
			icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", equip.item_type))
			icon:setName("icon")

			scale = cc.p(size.width / icon:getContentSize().width, size.height / icon:getContentSize().height)
			scale = math.min(scale.x, scale.y) * 0.8

			icon:setPosition(size.width * 0.5, size.height * 0.5)
			icon:setScale(scale)
			self.equips[i]:addChild(icon, 10)
			self:createEquipStar(self.equips[i],equip.item_type)
	 	end
	 	local red = self.equips[i]:getChildByName("redPoint")
	 	red:setVisible(redPoints[i])
	 	

	end


	self.layer_up_level:updateLevelAttrInfo()
    local score = self:getEquipScore()
	
	self:eventHeroSoulDataDirty()
end

function HeroInfoLayer:handleEvolution(event, data)
	
end

function HeroInfoLayer:changeFighting(evt, new_fighting)
	if new_fighting ~= nil then
		self.lbl_attack:setString(new_fighting)
	end
end

function HeroInfoLayer:createEquipStar(parent,equip_type)
	local config = cfg.equipmenttype.equip[equip_type]
	local node_star = parent:getChildByName("node_star")
	node_star:removeAllChildren()

	local star_type = math.floor(config.star / 5)
	local star_count

	if config.star % 5 == 0 then 
		if config.star > 5 then
			star_count = 1
		else 
			star_count = 5
			star_type = 0
		end
	else
		star_count = config.star % 5
	end

	local path = string.format("other/star-%d.png",star_type)

	if config.star > 10 then star_count = star_count + 1 end

	local scale = 0.5
	for i=1,star_count do
		local sp = cc.Sprite:createWithSpriteFrameName(path)
		node_star:addChild(sp,star_count-i)
		local margin = 12
		local width = sp:getContentSize().width * scale-- + margin
		local length = (width / 2 * (star_count - 1))
		local offset = (parent:getContentSize().width - length) / 2
		local posX = offset + (width / 2) * (i - 1)
		sp:setPosition(posX,0)
		sp:setScale(scale)
	end

end

function HeroInfoLayer:openRefundView(event,data)
	if table.nums(data.reward) <= 0 then 
		ex.EventManager:fire(data.eventData.event,data.eventData.data)
	else
		require("src.layer.ItemRewardCtr"):instance():openWindow(data)
	end
end

function HeroInfoLayer:openComment(event,data)
	local ctr = require("src.layer.heroinfo.HeroCommentCtr"):instance()
	ctr:openWindow(self.hero_data,data.hero_comment_data)
end

function HeroInfoLayer:exitCallback()
	--ex.Player.hero_data.promote:setSelectHero(nil)
	ex.Player.hero_data.promote:resetComsumeHeroList()
	ex.EventManager:fire(EVENT.POWER_EFFECT.CLOSE_EFFECT_LAYER)
end

function HeroInfoLayer:updateStarLayer(event,data)
	require("src.layer.UpStarSuccessCtr"):instance():openWindow(self.hero_data)
	local heroStarCfg = cfg.herotype.star[self.hero_data.hero_type]["to_" .. self.hero_data.star+1 .."_star"]
	self.showStarLayer = heroStarCfg ~= nil and heroStarCfg ~= "" and #heroStarCfg > 0 and not self:checkTabGray(2)
	self.layer_up_star:setVisible(self.showStarLayer == true)

	if self.showStarLayer == false then
		self.cur_tag = 1
	end

	self:initScrollViewTab()

	if self.showStarLayer == true then
		self.layer_up_star:updateStarView()
	else
		self.layer_up_level:updateGradeInfo()
	end 

	self:createStar()
	self.layer_up_level:updateLevelView()

    self:createSpine()

	self:checkRedPoint()

	self:checkShowStoneBtn()
end

function HeroInfoLayer:updateLevelLayer(event,data)
	self.layer_up_level:updateLevelView(true, true, nil, true)

 	ex.EffectCtr:playNormalEff(7,self.node_equip:getPositionX() , self.node_equip:getPositionY(),nil,self,10)

    self:updateHasRes()
	self:checkRedPoint()

end


function HeroInfoLayer:updateGodEquipLayer( event,data)
	self.layer_godequip:updateItems(self.hero_data.hero_id, self.hero_data.star) 

	self:checkRedPoint()

	self.layer_up_level:updateLevelView()

end

function HeroInfoLayer:updateStoneLayer(event,data)
	self.layer_up_stone:setHeroData(self.hero_data.hero_id, self.hero_data.star) 
	self:checkRedPoint()
	self.layer_up_level:updateLevelView()
end 

function HeroInfoLayer:eventUpdateTalentLayer(event, data, is_force)
	if not self.btn_talent then return end 
	if self.cur_tag ~= self.btn_talent:getTag() and not is_force then return end
	self.layer_talent:updateView()
	self:checkRedPoint()
end 

function HeroInfoLayer:updateAwaken(event, data, is_force)
	self.layer_awaken:updateView()
	self:checkRedPoint()
end

function HeroInfoLayer:eventWearFashion()
	-- 刷新皮肤
	self:createSpine()
end

function HeroInfoLayer:eventFashionDataDirty()
	self:checkUnfoldReddot()
end

function HeroInfoLayer:eventHeroSoulDataDirty()
	self:checkUnfoldReddot()
end

function HeroInfoLayer:updateHasRes()
	
	-- self.lbl_stone:setString(ex.StringUtil.getScientificNumber(ex.Player:getItemNum(ItemType.IT_HERO_UP_STONE))) 
	-- self.lbl_exp:setString(ex.StringUtil.getScientificNumber(ex.Player:getItemNum(ItemType.IT_HERO_EXP)))
	-- self.spr_stone:setSpriteFrame(string.format("backpack/%s.png",ItemType.IT_HERO_UP_STONE))
	-- self.spr_exp:setSpriteFrame(string.format("backpack/%s.png",ItemType.IT_HERO_EXP))
	-- self.spr_stone:setScale(0.5)
	-- self.spr_exp:setScale(0.5)
end

function HeroInfoLayer:getEquipScore()
    local equips = ex.Player.hero_data.equip:getHeroEquip(self.hero_data.hero_id).equip_list

    local score = 0
	for k,v in pairs(equips) do
		if v.item_type ~= 0 then 
			score = ex.Player.hero_data.equip:getEquipScore(v.item_type) + score
		end
    end

    return score
end

function HeroInfoLayer:updateGradeLayer(event,data)
	
 	require("src.layer.UpgradeSuccessCtr"):instance():openWindow(self.hero_data,data)
	self.layer_up_level:updateLevelView()


	self:updateHasRes()
	self:checkRedPoint()
end

function HeroInfoLayer:updateLayer()
	self:onTab(self.cur_tag, nil, true)
end

function HeroInfoLayer:gotoAwaken()
	self:onTab(TAB_ID.AWAKEN, nil, true)
end

function HeroInfoLayer:onTouchHero()
	self.hero:attack()
end

function HeroInfoLayer:onSkin(tag ,pSender)
	require("src.layer.skinsystem.HeroSkinSettingCtrl"):instance():openWindow(self.hero_data.hero_id)
end

-- 附魂
function HeroInfoLayer:onSoul(tag ,pSender)
	require("src.layer.heroinfo.HeroSoulCtr"):instance():openWindow()
end 

function HeroInfoLayer:onSetting(tag ,pSender)
	local position = cc.p(pSender:getContentSize().width * pSender:getScaleX(), pSender:getContentSize().height * pSender:getScaleY() + 20)
	position = pSender:convertToWorldSpace(position)
	require("src.layer.heroinfo.HeroInfoSettingCtr"):instance():openWindow(position, self.hero_data)
end

function HeroInfoLayer:onUnfold(tag ,pSender)
	local position = cc.p(0, pSender:getContentSize().height * pSender:getScaleY() + 20)
	position = pSender:convertToWorldSpace(position)
	require("src.layer.heroinfo.HeroInfoUnfoldCtr"):instance():openWindow(position, self.hero_data)
end

return HeroInfoLayer
