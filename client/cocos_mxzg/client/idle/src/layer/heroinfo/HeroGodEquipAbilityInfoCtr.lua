
local HeroGodEquipAbilityInfoCtr = class("HeroGodEquipAbilityInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroGodEquipAbilityBaseLayer = class("HeroGodEquipAbilityBaseLayer", require("src.comp.EventLayer"))
local HeroGodEquipAbilityInfoLayer = class("HeroGodEquipAbilityInfoLayer", require("src.comp.EventLayer"))
local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")


function HeroGodEquipAbilityBaseLayer:onCreate()
	self:onNodeLoaded(self, nil)
	self:setAutoClose(true)
	self:setSwallowTouches(true)

	self.vec_layer = {}

end

function HeroGodEquipAbilityBaseLayer:resetSize()
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

	self:addBlackBackground()

end


-----------------------------------------------------------------------------


function HeroGodEquipAbilityInfoLayer:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.y = -130
	self.bottom_height = 20
	self.left_margin = -120 - 50 -- -self:getContentSize().width * 0.4
	self.right_margin = self:getContentSize().width * 0.4

	local info_ctr = HeroGodEquipAbilityInfoCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(info_ctr, info_ctr.closeWindow))
	self.btn_src:registerScriptTapHandler(handler(info_ctr, info_ctr.onItemSrc))
	self.btn_type:registerScriptTapHandler(handler(info_ctr, info_ctr.onItemType))

	-- self:addBlackBackground()
end

function HeroGodEquipAbilityInfoLayer:resetSize()
	self:setContentSize(cc.size(self:getContentSize().width, -self.y + self.bottom_height))
	self.spr_bg:setContentSize(self:getContentSize())
	self.node:setPositionY(self:getContentSize().height - 3)
	self.base_layer:resetSize()
end

function HeroGodEquipAbilityInfoLayer:setDataInfo(equip_data)

	local item_config_data = cfg.item.item[equip_data.item_type]
	local item = UIItemBackpack:createWithData(item_config_data.idx, 0)
    item:setPosition(-130, -65)
    if item.lbl_num then 
    	item.lbl_num:setVisible(false)
    end
	self.menu:addChild(item)

	local config = cfg.godequipment.godequipment[item_config_data.idx]
	-- ex.Tools:generationStar(item, config.star, "other/star-%d.png", 0.6, -10, cc.p(item:getContentSize().width * 0.5, 15), 1000)

	-- local settype_config = cfg.godequipmentsettype.godequipmentsettype[config.settype]
	local settype_config = nil
	for i,v in ipairs(cfg.godequipmentsettype.godequipmentsettype) do
		if v.settype == config.settype then 
			settype_config = v
		end 	
	end 

	local vec_rare_color = {}
	vec_rare_color[1] = cc.c3b(120,236,131)
	vec_rare_color[2] = cc.c3b(86,207,247)
	vec_rare_color[3] = cc.c3b(236,80,255)
	vec_rare_color[4] = cc.c3b(255,146,62)
	vec_rare_color[5] = cc.c3b(255,99,68)
	vec_rare_color[6] = cc.c3b(255,238,99)
	-- self.spr_rare:setSpriteFrame(string.format("backpack-info/spr-banner-equip-%d.png", config.rare))
	ex.Tools:setSpriteFrame(self.spr_rare, string.format("backpack-info/spr-banner-equip-%d.png", config.rare))
	self.lbl_name:setString(ex.Tools:getLang(item_config_data.name))
	self.lbl_name:setTextColor(vec_rare_color[config.rare])
	self.lbl_type:setString(ex.Tools:getLang(47420))
    self.lbl_score:setString(ex.Tools:getLang(settype_config.name))
    self.lbl_score_text:setString("")


	local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("artifact/spr-suit-type-%d.png", config.settype))
	spr_icon:setScale(1.5)
	:setAnchorPoint(cc.p(0.5, 0.5))
	spr_icon:setPosition( - 40, 25)
	self.lbl_score:addChild(spr_icon)

	self.lbl_score:setPosition(self.lbl_score:getPositionX() - 30, self.lbl_score:getPositionY())

    self:resetSize()
    return self
    -- self:resetAttrLabel(data.ability,notBottom)
end


function HeroGodEquipAbilityInfoLayer:addHeight(height)
	height = height or 5
	self.y = self.y - height
    self:resetSize()
	return self
end

function HeroGodEquipAbilityInfoLayer:addLine(width, height)
	height = height or 5
	width = width or self:getContentSize().width * 0.9
	local spr_line = cc.Sprite:createWithSpriteFrameName("backpack-info/spr-line.png")
	spr_line:setPosition(0, self.y - height * 0.5)
	self.node:addChild(spr_line)
	self.y = self.y - height

    self:resetSize()
	return self
end

function HeroGodEquipAbilityInfoLayer:addAbility(equip_data)
    
    local config = cfg.godequipment.godequipment[equip_data.item_type]

    local ability = config.ability

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

		local attstr = ex.Tools:getLang(2141000 + v.attr)
		local flag = ex.StringUtil.formatAttrStrBool(attstr, "##" , v.value, "<font color='#219A00'>%s</font>")

		local str = ex.Tools:getLang(2150000 + v.attr)..":"

		local lbl_ability = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 20)
		:setTextColor(cc.c3b(144,111,72))
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(self.left_margin + 35, self.y - height * 0.5)
		self.node:addChild(lbl_ability)

		local show_nums_str = tostring(v.value)
		if flag == true then 
			show_nums_str = string.format("%.1f", v.value / 100) .. "%"
		end 

		local lbl_ability_num = cc.Label:createWithTTF(show_nums_str, FONT_DEFAULT_NAME_BOLD, 20)
		:setTextColor(cc.c3b(255,255,178))
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(lbl_ability:getPositionX() + lbl_ability:getContentSize().width + 10, lbl_ability:getPositionY())
		self.node:addChild(lbl_ability_num)

		self.y = self.y - height - 10
	end

    self:resetSize()
	return self
end


function HeroGodEquipAbilityInfoLayer:addOrderAbility(equip_data)
	if equip_data.attrs == nil then
		return self
	end

    local equip_ment_config = cfg.godequipment.godequipment[equip_data.item_type]


    local add_virst_data = {}
    local ability = {}
	for i,v in ipairs(equip_data.attrs) do
		if v.sys_id > 0 then
			local rand_attr, cur_rare = ex.Player.backpack_data:getgodequipmentrandomability(equip_ment_config.place, equip_ment_config.star, v.sys_id, v.level)
			for ki,kv in ipairs(rand_attr) do
				local now_data = {}
				now_data.attr = kv.attr
				now_data.value = kv.value
				now_data.level =v.level
				now_data.rare = cur_rare
				table.insert(ability, now_data)
			end 
		else
			local now_data = {}
			now_data.attr = AbilityType.AT_ATTACK_UP
			now_data.value = -1
			now_data.level = 1
			now_data.rare = 1
			table.insert(ability, now_data)
		end
	end

	if table.nums(ability) > 0 then
		self.y = self.y - 10
		
		if table.nums(ability) == 1 then 
			table.insert( add_virst_data, ex.Tools:getLang(72507) )
		end 
    else 
		-- 需要虚拟一条
		table.insert( add_virst_data, ex.Tools:getLang(72506) )
		
	end

	local lbl_ability_text = cc.Label:createWithTTF(ex.Tools:getLang(47634), FONT_DEFAULT_NAME_BOLD, 22)
	:setAnchorPoint(cc.p(0, 0.5))
	:setTextColor(cc.c3b(255, 198, 116))
	lbl_ability_text:setPosition(self.left_margin, self.y - lbl_ability_text:getContentSize().height * 0.5)
	self.node:addChild(lbl_ability_text)


	self.btn_type:setVisible(true)
	self.btn_type:setPositionY(self.y - lbl_ability_text:getContentSize().height * 0.5)

	self.y = self.y - lbl_ability_text:getContentSize().height - 10

	local max_level = cfg.system.god_equipment_random_ability_level

	local height = 25
	for i,v in ipairs(ability) do
		local str_attr_icon = "backpack-info/spr-attr-random.png"
		if v.value > 0 then
			local attr_show_type = cfg.attrshow.attrshow[v.attr].icon	
			str_attr_icon = string.format("backpack-info/spr-attr-%d.png", attr_show_type)
		end
		local spr_icon = cc.Sprite:createWithSpriteFrameName(str_attr_icon)

        spr_icon:setScale(0.6)
        :setAnchorPoint(cc.p(0, 0.5))
        spr_icon:setPosition(self.left_margin, self.y - height * 0.5)
		self.node:addChild(spr_icon)

		local color  = GOD_EQUIP_RARE_COLOR.RGB[v.rare]

		local attstr = ex.Tools:getLang(2141000 + v.attr)
		local flag = ex.StringUtil.formatAttrStrBool(attstr, "##" , v.value, "<font color='#219A00'>%s</font>")

		local str = "???"
		if v.value > 0 then
			str = ex.Tools:getLang(2150000 + v.attr)..":"
		end

		local lbl_ability = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 20)
		:setTextColor(cc.c3b(144,111,72))
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(self.left_margin + 35, self.y - height * 0.5)
		self.node:addChild(lbl_ability)

		local show_nums_str = ""
		if v.value > 0 then
			show_nums_str = tostring(v.value)
			if flag == true then 
				show_nums_str = string.format("%.1f", v.value / 100) .. "%"
			end
		end

		if v.level == max_level then 
			show_nums_str = show_nums_str .. "(max)"
		end 

		local lbl_ability_num = cc.Label:createWithTTF(show_nums_str, FONT_DEFAULT_NAME_BOLD, 20)
		:setTextColor(color)
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(lbl_ability:getPositionX() + lbl_ability:getContentSize().width + 10, lbl_ability:getPositionY())
		self.node:addChild(lbl_ability_num)

		self.y = self.y - height - 10
	end

	-- 显示提示
	if table.nums(add_virst_data) > 0 then 

		local lbl_ability = cc.Label:createWithTTF(add_virst_data[1], FONT_DEFAULT_NAME_BOLD, 18)
		:setTextColor(cc.c3b(144,111,72))
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(self.left_margin + 35, self.y - height * 0.5)
		self.node:addChild(lbl_ability)

		self.y = self.y  - 20
	end 

    self:resetSize()
	return self
end


function HeroGodEquipAbilityInfoLayer:addDesc(equip_data)

    local item_config_data = cfg.item.item[equip_data.item_type]

    local language_num = item_config_data.equipment_type + 100000

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
function HeroGodEquipAbilityInfoLayer:addGroupSet(equip_data)
    self:addHeight(7)
    :addLine()
	:addHeight(7)
	
	local god_equip_config = cfg.godequipment.godequipment[equip_data.item_type]

	local min_typ = god_equip_config.settype 
	local min_star = god_equip_config.star 
	local nums = 1

	if equip_data.is_share then
		min_typ, min_star , nums = ex.Player.backpack_data:getGodEquipGroupByList(equip_data.hero_id, equip_data.item_type, equip_data.equip_list)
	elseif equip_data.hero_id > 0 then
		min_typ, min_star , nums = ex.Player.backpack_data:getGodEquipGroupBySystemid(equip_data.hero_id, equip_data.item_type)
	end

	-- local settype_config = cfg.godequipmentsettype.godequipmentsettype[god_equip_config.settype]
	local settype_config = nil
	for i,v in ipairs(cfg.godequipmentsettype.godequipmentsettype) do
		if v.settype == god_equip_config.settype then 
			settype_config = v
		end 	
	end 


	local str = string.format( "%s（%s/4）",ex.Tools:getLang(settype_config.name ),nums)
		
    local lbl_set_text = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 20)
    :setAnchorPoint(cc.p(0, 0.5))
    :setTextColor(cc.c3b(255, 198, 116))
    lbl_set_text:setPosition(self.left_margin, self.y - lbl_set_text:getContentSize().height * 0.5)
    self.node:addChild(lbl_set_text)
    self.y = self.y - lbl_set_text:getContentSize().height - 10

	local show_list = {}
	for i,v in ipairs(cfg.godequipmentsettype.godequipmentsettype) do
		if min_typ == v.settype and min_star == v.star   then    -- and nums >= v.num
			local ability_data = {}
			ability_data.nums = v.num
			ability_data.ability = {}
			if v.ability ~= "" then 
				for ki,kv in ipairs(v.ability) do
					table.insert( ability_data.ability, kv)
				end
			end 
			ability_data.skill = 0 
			if v.skill ~= 0 then 
				ability_data.skill = v.skill
			end 
			table.insert( show_list, ability_data )
		end 
	end

	for i,v in ipairs(show_list) do
		if #v.ability >  0 then 
			local lbl_ability = nil
			for ia,va in ipairs(v.ability) do
				local str = ex.Tools:getLang(2150000 + va.attr)..":"
			
				lbl_ability = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 20)
				:setTextColor(nums >= v.nums and FONT_GREEN  or cc.c3b(255,255,178) )
				:setAnchorPoint(cc.p(0, 0.5))
				lbl_ability:setPosition(self.left_margin + (ia - 1) * 100 + 35, self.y - lbl_ability:getContentSize().height * 0.5 - 3)
				self.node:addChild(lbl_ability)
			
				local attr_show_type = cfg.attrshow.attrshow[va.attr].icon
				local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack-info/spr-attr-%d.png", attr_show_type))
				spr_icon:setScale(0.6)
				:setAnchorPoint(cc.p(0, 0.5))
				spr_icon:setPosition(self.left_margin, self.y - lbl_ability:getContentSize().height * 0.5 - 3)
				self.node:addChild(spr_icon)

				local attstr = ex.Tools:getLang(2141000 + va.attr)
				local flag = ex.StringUtil.formatAttrStrBool(attstr, "##" , va.value, "<font color='#219A00'>%s</font>")

				local show_nums_str = tostring(va.value)
				if flag == true then 
					show_nums_str = string.format("%.1f", va.value / 100) .. "%"
				end 

				local lbl_ability_num = cc.Label:createWithTTF(show_nums_str, FONT_DEFAULT_NAME_BOLD, 18)
				:setTextColor(nums >= v.nums and FONT_GREEN or cc.c3b(255,255,178) )
				:setAnchorPoint(cc.p(0, 0.5))
				:setPosition(lbl_ability:getPositionX() + lbl_ability:getContentSize().width + 10, lbl_ability:getPositionY())
				self.node:addChild(lbl_ability_num)

				local lbl_ability_visible = cc.Label:createWithTTF(v.nums.."件激活("..min_star..ex.Tools:getLang(47305), FONT_DEFAULT_NAME_BOLD, 18)
				:setTextColor(nums >= v.nums and FONT_GREEN or cc.c3b(255,255,178))
				:setAnchorPoint(cc.p(1, 0.5))
				:setPosition(170, lbl_ability:getPositionY())
				self.node:addChild(lbl_ability_visible)
			end
			self.y = self.y - (lbl_ability:getContentSize().height + 10)				 
		end 

		-- 持有技能效果
		if v.skill >  0 then 
			-- 找到技能
			local skill_config = cfg.heroskill.getConfigByType(v.skill, min_star)

			local str = string.format( ex.Tools:getLang(47331), ex.Tools:getLang(skill_config.lan_name))
			
			lbl_ability = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 20)
			:setTextColor(nums >= v.nums and FONT_GREEN or cc.c3b(255,255,178))
			:setAnchorPoint(cc.p(0, 0.5))
			lbl_ability:setPosition(self.left_margin + (1 - 1) * 100 + 35, self.y - lbl_ability:getContentSize().height * 0.5 - 3)
			self.node:addChild(lbl_ability)

			local spr_icon = cc.Sprite:createWithSpriteFrameName("backpack-info/spr-attr-jn.png")
			spr_icon:setScale(0.6)
			:setAnchorPoint(cc.p(0, 0.5))
			spr_icon:setPosition(self.left_margin, self.y - lbl_ability:getContentSize().height * 0.5 - 3)
			self.node:addChild(spr_icon)


			local lbl_ability_visible = cc.Label:createWithTTF(v.nums.."件激活("..min_star..ex.Tools:getLang(47305), FONT_DEFAULT_NAME_BOLD, 18)
			:setTextColor(nums >= v.nums and FONT_GREEN or cc.c3b(255,255,178))
			:setAnchorPoint(cc.p(1, 0.5))
			:setPosition(170, lbl_ability:getPositionY())
			self.node:addChild(lbl_ability_visible)

			-- getSpriteFrame(string.format("skill-icon/%d.png", skill_type))
			-- 显示技能图标

			local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", skill_config.type))
			spr_icon:setScale(1)
			:setAnchorPoint(cc.p(0, 0.5))
			spr_icon:setPosition(self.left_margin + 10, self.y - lbl_ability:getContentSize().height * 0.5 - 3 - spr_icon:getContentSize().height)
			self.node:addChild(spr_icon)

			--创建文本
			local show_skill_msg = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 18)
			:setTextColor( cc.c3b(255,255,178) )
			:setAnchorPoint(cc.p(0, 1))
			:setPosition(self.left_margin + 20 + spr_icon:getContentSize().width, lbl_ability:getPositionY() - 23)
			:setDimensions(self:getContentSize().width * 0.6, 0)
			self.node:addChild(show_skill_msg)

			show_skill_msg:setString(ex.Tools:getLang(skill_config.lan_describe))
				
			local sub_need_num = spr_icon:getContentSize().height 
			if sub_need_num < show_skill_msg:getContentSize().height then 
				sub_need_num = show_skill_msg:getContentSize().height
			end 

			self.y = self.y - (lbl_ability:getContentSize().height + 10) - sub_need_num	- 20 			 
		end	
	end

	self:resetSize()
		
	return self
end

-- 如果要调用多个按钮请另外增加函数。避免出bug
-- 格式：(ex.Tools:getLang(47760)，handler(.., ..))
function HeroGodEquipAbilityInfoLayer:addWearButtion(...)
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
				HeroGodEquipAbilityInfoCtr:instance():closeWindow(tag, pSender)
			end)
		else
			btn:registerScriptTapHandler(v.call)
		end

		if v.gray_flag == true then 
			-- btn
			ex.Tools:setGrayAuto( btn:getNormalImage(), true)
		end 

		-- btn:registerScriptTapHandler(v.callback)
		self.menu:addChild(btn)
	end

	self.y = self.y - (item_size.height * row)

	self:resetSize()
	return self
end


-----------------------------------------------------------------------------

function HeroGodEquipAbilityInfoCtr:loadLayer()
	self.layer = HeroGodEquipAbilityBaseLayer:create()
	self:setLayer(self.layer)

    -- 创建点击事件
    self:registerTouchListen()
end


function HeroGodEquipAbilityInfoCtr:getAbilityInfoLayer()
	return self.layer
end

function HeroGodEquipAbilityInfoCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:setIsSingle(false)

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/backpack-info.plist")
	sfc:addSpriteFrames("ccbi-res/skill-icon.plist")
	sfc:addSpriteFrames("ccbi-res/artifact.plist")
	
	self:loadLayer()
	self:open()
	
	return self
end


function HeroGodEquipAbilityInfoCtr:onItemType(tag, pSender)
	-- ex.Tools:onClickItemSrc(self.item_type)
	-- 打开窗口
	require("src.layer.heroinfo.HeroGodEquipOrderAttrCtr"):instance():openWindow(self.equip_data)

end


function HeroGodEquipAbilityInfoCtr:onItemSrc(tag, pSender)
	ex.Tools:onClickItemSrc(self.item_type)
end

function HeroGodEquipAbilityInfoCtr:addGodEquipAbilityLayer()
	if not self:getLayer() then
		return nil
	end

	local layer = self.layer
	layer:setTag(999)

	local ability_layer = HeroGodEquipAbilityInfoLayer:createWithCCBIFile("ccbi/AbilityInfoLayer.ccbi")
	ability_layer.base_layer = layer
	layer:addChild(ability_layer)

	table.insert(layer.vec_layer, ability_layer)
	return ability_layer
end

function HeroGodEquipAbilityInfoCtr:setDataInfo(equip_data)
	self.equip_data = equip_data
	self.item_type = self.equip_data.item_type

    -- local data = cfg.item.item[jewel_type]
    -- local jewel_data = cfg.jeweltype.jeweltype[jewel_type]
	local layer = self:addGodEquipAbilityLayer()
    layer:setDataInfo(self.equip_data)
    :addAbility(self.equip_data)
    :addOrderAbility(self.equip_data)
	:addGroupSet(self.equip_data)
	-- :addDesc(equip_data)
	return layer
end


return HeroGodEquipAbilityInfoCtr