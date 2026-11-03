local AbilityInfoCtr = class("AbilityInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local AbilityBaseLayer = class("AbilityBaseLayer", require("src.comp.EventLayer"))
local AbilityInfoLayer = class("AbilityInfoLayer", require("src.comp.EventLayer"))
local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
local UIMenuItemSkill = require("src.comp.menu.UIMenuItemSkill")

function AbilityBaseLayer:onCreate()
	self:onNodeLoaded(self, nil)
	self:setAutoClose(true)
	self:setSwallowTouches(true)

	self.vec_layer = {}
end

function AbilityBaseLayer:resetSize()
	--dump(self.vec_layer)
	if table.nums(self.vec_layer) == 0 then
		-- 销毁自己 和 AbilityInfoCtr
		return
	end
   
	local win_size = cc.Director:getInstance():getWinSize();
	-- 更新自身位置和尺寸
	local size = cc.size(0, 0)
	for i,v in ipairs(self.vec_layer) do
		size.width = size.width + v:getContentSize().width
		size.height = math.max(size.height, v:getContentSize().height)
	end

	self:setContentSize(size)
	self:setPosition(win_size.width * 0.5 - size.width * 0.5, win_size.height * 0.5 - size.height * 0.5)
       
	-- 更新属性图层位置
	size.width = 0
	for i,v in ipairs(self.vec_layer) do
		v:setPosition(size.width, size.height - v:getContentSize().height)
		size.width = size.width + v:getContentSize().width
	end
end

function AbilityInfoLayer:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.y = -130
	self.bottom_height = 20
	self.left_margin = -120 - 50 -- -self:getContentSize().width * 0.4
	self.right_margin = self:getContentSize().width * 0.4

	local info_ctr = AbilityInfoCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(info_ctr, info_ctr.closeWindow))
	self.btn_src:registerScriptTapHandler(handler(info_ctr, info_ctr.onItemSrc))

	self:addBlackBackground()
end

function AbilityInfoLayer:resetSize()
	self:setContentSize(cc.size(self:getContentSize().width, -self.y + self.bottom_height))
	self.spr_bg:setContentSize(self:getContentSize())
	self.node:setPositionY(self:getContentSize().height - 3)
	self.base_layer:resetSize()
end

function AbilityInfoLayer:setEquipInfo(data)
	local item = UIItemBackpack:createWithData(data.equipment_type, 0)
    item:setPosition(-130, -65)
    if item.lbl_num then 
    	item.lbl_num:setVisible(false)
    end
	self.menu:addChild(item)

	local vec_rare_color = {}
	vec_rare_color[1] = cc.c3b(120,236,131)
	vec_rare_color[2] = cc.c3b(86,207,247)
	vec_rare_color[3] = cc.c3b(236,80,255)
	vec_rare_color[4] = cc.c3b(255,146,62)
	vec_rare_color[5] = cc.c3b(255,99,68)
	vec_rare_color[6] = cc.c3b(255,238,99)
	local config = cfg.equipmenttype.equip[data.equipment_type]
	ex.Tools:setSpriteFrame(self.spr_rare, string.format("backpack-info/spr-banner-equip-%d.png", config.rare))
	-- self.spr_rare:setSpriteFrame(string.format("backpack-info/spr-banner-equip-%d.png", config.rare))
	self.lbl_name:setString(ex.Tools:getLang(data.equipment_type))
	self.lbl_name:setTextColor(vec_rare_color[config.rare])
    self.lbl_score:setString(ex.Player.hero_data.equip:getEquipScore(data.equipment_type))
	self.lbl_type:setString(ex.Tools:getLang(47086)..ex.Tools:getLang(50 + data.place))
    self:resetSize()
    return self
    -- self:resetAttrLabel(data.ability,notBottom)
end


function AbilityInfoLayer:addHeight(height)
	height = height or 5
	self.y = self.y - height
    self:resetSize()
	return self
end

function AbilityInfoLayer:addLine(width, height)
	height = height or 5
	width = width or self:getContentSize().width * 0.9
	local spr_line = cc.Sprite:createWithSpriteFrameName("backpack-info/spr-line.png")
	spr_line:setPosition(0, self.y - height * 0.5)
	self.node:addChild(spr_line)
	self.y = self.y - height

    self:resetSize()
	return self
end

function AbilityInfoLayer:addAbility(ability)
	-- 排序属性
	local function sortAbility(a, b)
		-- local compA = cfg.scorecount.mapping[a.attr]
		local compA = TableEx.findValueFunction(cfg.scorecount.equip, function(value)
			return value.mapping == a.attr
		end)
        compA = compA and compA.idx or 100

		-- local compB = cfg.scorecount.mapping[b.attr]
		local compB = TableEx.findValueFunction(cfg.scorecount.equip, function(value)
			return value.mapping == b.attr
		end)
        compB = compB and compB.idx or 100

        return compA < compB
    end
	table.sort(ability, sortAbility)

	if table.nums(ability) > 0 then
		self.y = self.y - 10
	end

	local lbl_ability_text = cc.Label:createWithTTF(ex.Tools:getLang(47011), FONT_DEFAULT_NAME_BOLD, 22)
	:setAnchorPoint(cc.p(0, 0.5))
	:setTextColor(cc.c3b(255, 198, 116))
	lbl_ability_text:setPosition(self.left_margin, self.y - lbl_ability_text:getContentSize().height * 0.5)
	self.node:addChild(lbl_ability_text)
	self.y = self.y - lbl_ability_text:getContentSize().height - 10

	local height = 25
	for i,v in ipairs(ability) do
		local attr_show_type = cfg.attrshow.attrshow[v.attr].icon
        local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack-info/spr-attr-%d.png", attr_show_type))
        spr_icon:setScale(0.6)
        :setAnchorPoint(cc.p(0, 0.5))
        spr_icon:setPosition(self.left_margin, self.y - height * 0.5)
		self.node:addChild(spr_icon)

		local str = ex.Tools:getLang(2150000 + v.attr)..":"

		local lbl_ability = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 20)
		:setTextColor(cc.c3b(144,111,72))
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(self.left_margin + 35, self.y - height * 0.5)
		self.node:addChild(lbl_ability)

		local lbl_ability_num = cc.Label:createWithTTF(tostring(v.value), FONT_DEFAULT_NAME_BOLD, 20)
		:setTextColor(cc.c3b(255,255,178))
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(lbl_ability:getPositionX() + lbl_ability:getContentSize().width + 10, lbl_ability:getPositionY())
		self.node:addChild(lbl_ability_num)

		self.y = self.y - height - 10
	end

    self:resetSize()
	return self
end

function AbilityInfoLayer:addDesc(language_num)
	self:addHeight(7)
	:addLine()
	:addHeight(7)

	local spr_book = cc.Sprite:createWithSpriteFrameName("backpack-info/spr-book.png")
	:setAnchorPoint(cc.p(0, 0.5))
	spr_book:setPosition(self.left_margin, self.y - spr_book:getContentSize().height * 0.5)
	self.node:addChild(spr_book)

	local lbl_desc = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 20)
	:setTextColor(cc.c3b(144, 111, 72))
    :setAnchorPoint(cc.p(0, 0.5))
    :setDimensions(self:getContentSize().width * 0.8, 0)
	lbl_desc:setString("       "..ex.Tools:getLang(language_num))
	lbl_desc:setPosition(self.left_margin, self.y - lbl_desc:getContentSize().height * 0.5)
	self.node:addChild(lbl_desc)

	-- 有最小高度
	local height = math.max(lbl_desc:getContentSize().height, 50)
	self.y = self.y - height - 10

    self:resetSize()
	return self
end

-- 参数1:点击的装备  参数2：身上所有穿的装备
function AbilityInfoLayer:addEquipSet(equip_type, vec_equip)
	local equip_config = cfg.equipmenttype.equip[equip_type]
	local set_num = 0

	if equip_config.set_type ~= 0 then

		self:addHeight(7)
		:addLine()
		:addHeight(7)

		-- 计算激活的数量
		for k,v in pairs(vec_equip) do
			local config = cfg.equipmenttype.equip[v.item_type]
			
			if config and equip_config.set_type == config.set_type then
				set_num = set_num + 1
			end
		end

		-- 显示套装名字
		local max_num = 4

		local str = ex.Tools:getLang(equip_config.set_type) .. string.format("（%d/%d）", set_num, max_num)
		local lbl_set_text = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 20)
        :setAnchorPoint(cc.p(0, 0.5))
       	:setTextColor(cc.c3b(255, 198, 116))
        lbl_set_text:setPosition(self.left_margin, self.y - lbl_set_text:getContentSize().height * 0.5)
		self.node:addChild(lbl_set_text)
		self.y = self.y - lbl_set_text:getContentSize().height - 10
		
		-- local config_set = cfg.equipmentsettype.set[equip_config.set_type]
		for i=2,max_num do
			-- local data = config_set["num_"..i]
			local data = ex.Player.hero_data.equip:getEquipSetConfig(equip_config.set_type, i)

			if data then
				local lbl_ability = nil
				for ia,va in ipairs(data.attr) do
					local str = ex.Tools:getLang(2150000 + va.attr)..":"
			
					lbl_ability = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 20)
					:setTextColor(cc.c3b(144,111,72))
					:setAnchorPoint(cc.p(0, 0.5))
					lbl_ability:setPosition(self.left_margin + (ia - 1) * 100 + 35, self.y - lbl_ability:getContentSize().height * 0.5 - 3)
					self.node:addChild(lbl_ability)
			
					local attr_show_type = cfg.attrshow.attrshow[va.attr].icon
					local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack-info/spr-attr-%d.png", attr_show_type))
					spr_icon:setScale(0.6)
					:setAnchorPoint(cc.p(0, 0.5))
					spr_icon:setPosition(self.left_margin, self.y - lbl_ability:getContentSize().height * 0.5 - 3)
					self.node:addChild(spr_icon)

					local str_attr = ex.StringUtil.formatAttrStr(" "..ex.Tools:getLang(2160000 + va.attr), "##" , va.value)
					local lbl_ability_num = cc.Label:createWithTTF(str_attr, FONT_DEFAULT_NAME_BOLD, 20)
					:setTextColor(cc.c3b(255,255,178))
					:setAnchorPoint(cc.p(0, 0.5))
					:setPosition(lbl_ability:getPositionX() + lbl_ability:getContentSize().width + 10, lbl_ability:getPositionY())
					self.node:addChild(lbl_ability_num)

					local lbl_ability_visible = cc.Label:createWithTTF("("..data.num..ex.Tools:getLang(47200), FONT_DEFAULT_NAME_BOLD, 20)
					:setTextColor(set_num >= data.num and FONT_GREEN or cc.c3b(255,255,178))
					:setAnchorPoint(cc.p(1, 0.5))
					:setPosition(170, lbl_ability:getPositionY())
					self.node:addChild(lbl_ability_visible)
				end
				self.y = self.y - (lbl_ability:getContentSize().height + 10)
			end
		end
	end


	-- add 熊梦 附魂属性
	if equip_config.equipment_type ~= 0 then
		local hero_data = ex.Player.hero_data.promote:getSelectHero()
		local config_eq = cfg.equipmenttype.equip[equip_config.equipment_type]
		local requirement = cfg.heroequipsoulextra.heroequipsoulextra[equip_config.place]
		if config_eq.star >= requirement.need_equip_star and config_eq.rare >= requirement.need_euqip_rare and hero_data and hero_data.star >= requirement.need_star then
			local soul_skill_table = nil
			for k,v in pairs(vec_equip) do
				if soul_skill_table ~= nil and v.soul_lv == 0 then break end
				if equip_config.place == k then
					for j,k in ipairs(cfg.heroequipsoul.heroequipsoul) do
						if k.place == equip_config.place then
							if k.level == v.soul_lv then
								soul_skill_table = k
								break
							end
						end
					end
				end
			end
			
			if soul_skill_table ~= nil then
				self:addHeight(7)
				:addLine()
				:addHeight(7)

				local str = string.format(ex.Tools:getLang(6403)..ex.Tools:getLang(47139) , soul_skill_table.skill_level)
				local lbl_set_text = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 20)
				:setAnchorPoint(cc.p(0, 0.5))
				:setTextColor(cc.c3b(255, 198, 116))
				lbl_set_text:setPosition(self.left_margin, self.y - lbl_set_text:getContentSize().height * 0.5)
				self.node:addChild(lbl_set_text)
				self.y = self.y - lbl_set_text:getContentSize().height - 10

				local lbl_ability_1 = cc.Label:createWithTTF(ex.Tools:getLang(6406), FONT_DEFAULT_NAME_BOLD, 20)
				:setTextColor(cc.c3b(144,111,72))
				:setAnchorPoint(cc.p(0, 0.5))
				lbl_ability_1:setPosition(self.left_margin, self.y - lbl_set_text:getContentSize().height * 0.5)
				self.node:addChild(lbl_ability_1)


				local str_skill_name =  ex.Player.hero_data:getSkillName(soul_skill_table.skill, math.max(1, soul_skill_table.skill_level))
				if str_skill_name == "" then
					str_skill_name = "--"
				end
				local lbl_ability_2 = cc.Label:createWithTTF(str_skill_name.." ", FONT_DEFAULT_NAME_BOLD, 20)
				:setTextColor(cc.c3b(255, 198, 116))
				:setAnchorPoint(cc.p(0, 0.5))
				lbl_ability_2:setPosition(self.left_margin + lbl_ability_1:getContentSize().width, self.y - lbl_set_text:getContentSize().height * 0.5)
				self.node:addChild(lbl_ability_2)

				local lbl_ability_3 = require("src.comp.RichTextEx"):create()
				:setFontSize(20)
				:setFontFace(FONT_DEFAULT_NAME_BOLD)
				:setFontColor("#906F48")
				:setAnchorPoint(cc.p(0, 0.5))
				:setAnchorTextShadow(true)
				:ignoreContentAdaptWithSize(false)
				:setWrapMode(1)
				lbl_ability_3:setContentSize(cc.size(200, 0))
				lbl_ability_3:setPosition(self.left_margin + lbl_ability_1:getContentSize().width+ lbl_ability_2:getContentSize().width, self.y - lbl_set_text:getContentSize().height * 0.5)
				lbl_ability_3:setXmlTextLua(string.format(ex.Tools:getLang(6412),soul_skill_table.skill_level) )
				lbl_ability_3:formatText()
				self.node:addChild(lbl_ability_3)
				self.y = self.y - lbl_set_text:getContentSize().height * 0.5 - 20

				local spr_skill = UIMenuItemSkill:createWithIcon(soul_skill_table.skill, soul_skill_table.skill_level, false, nil)
				spr_skill:setPosition(self.left_margin + lbl_ability_1:getContentSize().width + spr_skill:getContentSize().width / 2, self.y - spr_skill:getContentSize().height* 0.5)
				spr_skill:resetLblName()
				self.node:addChild(spr_skill)
				self.y = self.y - spr_skill:getContentSize().height
			end
		end
	end


	return self
end

-- 如果要调用多个按钮请另外增加函数。避免出bug
-- 格式：(ex.Tools:getLang(47760)，handler(.., ..))
function AbilityInfoLayer:addWearButtion(...)
	local t = {...}
	local t_num = table.nums(t)
	if t_num <= 0 then
		return
	end

	self:addHeight(7)
	-- :addLine()
	-- :addHeight(7)

	local item_size = cc.size(self:getContentSize().width * 0.5, 60)
	local col = 2
    local row = math.ceil(t_num / 2) -- 总行数
    local begin_x = -(col - 1) * item_size.width * 0.5
	local begin_y = self.y - item_size.height * 0.5
	for i, v in ipairs(t) do
		local x = (col - i) % col
		local y = math.floor((i - 1) / col)
		local btn = cpp.UIMenuItemLabel:create("button/btn-old-1.png", "", "", nil)
		:setPosition(begin_x + x * item_size.width, begin_y - item_size.height * y)
		btn:setLabelText(v.str)
		btn:setLabelColor(cc.c3b(122,71,45))
		btn:setLabelSize(48)

		-- 设置属性
		btn.data = v.data
		if  v.keep == false or (not v.keep) then
			btn.call = v.call
			btn:registerScriptTapHandler(function(tag, pSender)
				pSender.call(tag, pSender)
				AbilityInfoCtr:instance():closeWindow(tag, pSender)
			end)
		else
			btn:registerScriptTapHandler(v.call)
		end
		-- btn:registerScriptTapHandler(v.callback)
		self.menu:addChild(btn)
	end

	self.y = self.y - (item_size.height * row)

	self:resetSize()
	return self
end

-----------------------------------------------------------------------------

function AbilityInfoCtr:loadLayer()
	self.layer = AbilityBaseLayer:create()
	self:setLayer(self.layer)

    -- 创建点击事件
    self:registerTouchListen()
end


function AbilityInfoCtr:getAbilityInfoLayer()
	return self.layer
end

function AbilityInfoCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:setIsSingle(false)

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/backpack-info.plist")
	self:loadLayer()
	self:open()
	
	return self
end

function AbilityInfoCtr:onItemSrc(tag, pSender)
	ex.Tools:onClickItemSrc(self.item_type)
end

function AbilityInfoCtr:addAbilityLayer()
	if not self:getLayer() then
		return nil
	end

	local layer = self.layer
	layer:setTag(999)

	local ability_layer = AbilityInfoLayer:createWithCCBIFile("ccbi/AbilityInfoLayer.ccbi")
	ability_layer.base_layer = layer
	layer:addChild(ability_layer)

	table.insert(layer.vec_layer, ability_layer)
	return ability_layer  
end

function AbilityInfoCtr:addEquipInfo(data, equips)
	self.item_type = data.equipment_type

	local layer = self:addAbilityLayer()
	layer:setEquipInfo(data)
	:addAbility(data.ability)
	:addEquipSet(data.equipment_type, equips)
	:addDesc(data.equipment_type + 100000)
	return layer
end


return AbilityInfoCtr
