local UpStarSuccessLayer = class("UpStarSuccessLayer", require("src.comp.LuaLayerBase"))
local UpStarSuccessCtr = class("UpStarSuccessCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

function UpStarSuccessLayer:onCreate()
	self:setAutoClose(true)
	self:addBlackBackground()
	self.lbl_btn_enter = cc.Label:createWithTTF(ex.Tools:getLang(47589), FONT_DEFAULT_NAME_BOLD, 24)
	self.lbl_btn_enter:setColor(FONT_BLACK)
	self.btn_enter:addChild(self.lbl_btn_enter)
	self.lbl_btn_enter:setPosition(self.btn_enter:getContentSize().width / 2, self.btn_enter:getContentSize().height / 2)
	-- self.lbl_btn_enter:enableOutline(ex.c3b.BLACK, 1)
	self:findAttrLable()

    self.node_effect:setLocalZOrder(100)

	-- 英雄升星特效
	local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_hero_upstar")
    spr_effect:setPosition(self.spr_upstar_success_tip:getPositionX() + 4, self.spr_upstar_success_tip:getPositionY() - 21)
    self:addChild(spr_effect, 120, 10)
end

function UpStarSuccessLayer:findAttrLable()
	self.attrNames = {}
	self.attrPres = {}
	self.attrCurs = {}
	for i = 1, 5 do
		self.attrNames[i] = self["lbl_attr_" .. i]
		self.attrPres[i] = self["lbl_pre_" .. i]
		self.attrCurs[i] = self["lbl_cur_" .. i]
		self.attrPres[i]:enableOutline(FONT_BLACK, 1)
		self.attrCurs[i]:enableOutline(FONT_BLACK, 1)
	end
end
----------------------------------------------------------

function UpStarSuccessCtr:ctor()
	local ccbi_file = "ccbi/UpStarSuccessLayer.ccbi"
	self:setCCBIPath(ccbi_file)
	self:registerCCBLoader()
	self:setIsSingle(false)
end

function UpStarSuccessCtr:loadLayer()
	local layer = UpStarSuccessLayer
	local ccbi_file = self:getCCBIPath()
	self.layer = layer:create(ccbi_file)
	self:setLayer(self.layer)

    -- 创建点击事件
    self:registerTouchListen()
end

function UpStarSuccessCtr:getShopLayer()
	return self.layer
end

function UpStarSuccessCtr:openWindow(str_title, str_content)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(str_title, str_content)
end

function UpStarSuccessCtr:initData(data, str_content)
	-- self.layer.btn_up_grade:registerScriptTapHandler(handler(self, self.onClickUpgrade))
	self.layer.btn_enter:registerScriptTapHandler(handler(self, self.onClick))
	-- self.layer:setPosition(193,368)
	self:updateLayer(data)
	
	ex.AudioManager:playEffect("music/hero-up-star.mp3")
end

function UpStarSuccessCtr:onClick(tag,pSender)
	if self.data.star > 4 then
		-- 检查显示礼包是否解锁并开启
		local is_show = ex.Player.promotion_data:isExistStarGiftForStar(self.data.star)

        if is_show then
			-- 获得5星以上英雄 限时礼包跳转
			ex.ConfirmCtr:openWindow("", string.format(ex.Tools:getLang(2725), self.data.star), function()
				ex.EventManager:fire(EVENT.OPEN_LAYER_CLOSE_OTHER.OPEN_HERO_STAR_GIFT)	-- 关闭其他打开controller，底层功能缺陷，先这样
				ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LIMIT_GIFT)
			end)
		elseif self.data.star == ex.Player.awaken_star then
			-- 获得5星以上英雄 限时礼包跳转
			ex.ConfirmCtr:openWindow(ex.Tools:getLang(75993), ex.Tools:getLang(6307), function()
				ex.EventManager:fire(EVENT.HERO_INFO_EVENT.AWAKEN_TIPS)
			end)
		end
	end
	self.super.closeWindow(self)
end

-- add 熊梦 重写closeWindow
function UpStarSuccessCtr:closeWindow()
	if self.data.star == ex.Player.awaken_star then
		ex.ConfirmCtr:openWindow(ex.Tools:getLang(75993), ex.Tools:getLang(6307), function()
			ex.EventManager:fire(EVENT.HERO_INFO_EVENT.AWAKEN_TIPS)
		end)
	end
	self.super.closeWindow(self)
end

function UpStarSuccessCtr:onClickUpgrade(tag, pSender)
end

function UpStarSuccessCtr:updateLayer(data)
	local layer = self.layer
	local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
	self.data = data
	local preData = clone(data)
	preData.star = data.star - 1
	local preItem = UIMenuItemHero:createWithData()

    local pre_level = data.level 
    local cur_level = data.level
    local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(data.hero_id)
    if is_cube_hero then 
        pre_level = cfg.herostar.star[data.star - 1].level_limit
        --preData.tweak_cube_lv = pre_level
        cur_level = data.tweak_cube_lv
    end 

	local hero_attr_pre = ex.Player.hero_data:getHeroAttribute(data.hero_type, data.stage, data.star - 1, pre_level)
	local hero_attr_now = ex.Player.hero_data:getHeroAttribute(data.hero_type, data.stage, data.star, cur_level)

    dump(pre_level)
    print(self.__cname,data.level,data.tweak_cube_lv)
	preItem:reset(preData)
    preItem:setSelectNum(pre_level)
	preItem:setEnabled(false)
	layer.menu:add(preItem)
	preItem:setPosition(180, 520)

	local curItem = UIMenuItemHero:createWithData()
	curItem:reset(data)
	curItem:setEnabled(false)
	layer.menu:add(curItem)
	curItem:setPosition(380, 520)
	-- layer:createStar(data.stage)

	local vec_title = {}
	vec_title.bat = ex.Tools:getLang(47569)
	vec_title.atk = ex.Tools:getLang(47372)
	vec_title.hp = ex.Tools:getLang(47704)
	vec_title.def = ex.Tools:getLang(47195)
	vec_title.spd = ex.Tools:getLang(47389)

	local vec_attr = {}
	for k, v in pairs(hero_attr_now) do
		-- 属性一样。则忽略对应属性
		if hero_attr_pre[k] ~= v then
			local data = {}
			data.title = vec_title[k]
			data.pre = hero_attr_pre[k]
			data.cur = v
			table.insert(vec_attr, data)
		end
	end

	-- 隐藏所有属性节点
	local node_num = 5
	for i = 1, node_num do
		local lbl_attr = layer["lbl_attr_" .. tostring(i)]
		if lbl_attr then
			lbl_attr:getParent():setVisible(false)
		end
	end

	for i, v in ipairs(vec_attr) do
		local lbl_attr = layer["lbl_attr_" .. tostring(i)]
		local lbl_pre = layer["lbl_pre_" .. tostring(i)]
		local lbl_cur = layer["lbl_cur_" .. tostring(i)]
		lbl_pre:getParent():setVisible(true)
		lbl_pre:setString(string.format("%d", v.pre))
		lbl_cur:setString(string.format("%d", v.cur))
		lbl_attr:setString(v.title)
	end

	-- 计算技能提升
	local vec_skill = ex.Player.hero_data:getHeroSkillUpgrade(data.star - 1, data.star, data.stage, data.hero_type, data.evolve)
	if table.nums(vec_skill) <= 0 then
		layer.spr_arrow:setVisible(false)
		return
	end

	-- 只显示一个
	local skill_level_data = vec_skill[1]
	local skill_type = cfg.herotype.star[data.hero_type]["skill_" .. skill_level_data.index]
	if skill_type == 0 then
		layer.spr_arrow:setVisible(false)
		return
	end

	local UIMenuItemSkill = require("src.comp.menu.UIMenuItemSkill")
	local btn_skill_pre = UIMenuItemSkill:createWithIcon(skill_type, skill_level_data.pre_level, skill_level_data.is_pre_evolve_skill, handler(self, self.onSkillInfo))
	btn_skill_pre:setPosition(layer.spr_arrow:getPositionX() - 100, 155.0)
	btn_skill_pre.lbl_name:setPositionY(-8)
	layer.btn_enter:getParent():addChild(btn_skill_pre)

	local btn_skill_now = UIMenuItemSkill:createWithIcon(skill_type, skill_level_data.now_level, skill_level_data.is_now_evolve_skill, handler(self, self.onSkillInfo))
	btn_skill_now:setPosition(layer.spr_arrow:getPositionX() + 100, 155.0)
	btn_skill_now.lbl_name:setPositionY(-8)
	layer.btn_enter:getParent():addChild(btn_skill_now)
end

function UpStarSuccessCtr:onSkillInfo(tag, pSender)
	require("src.layer.HeroSkillInfoCtr"):instance():openWindow(pSender.skill_type, pSender.skill_level)
end

return UpStarSuccessCtr
