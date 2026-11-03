local ArtifactTipsCtr = class("ArtifactTipsCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ArtifactBaseLayer = class("ArtifactBaseLayer", require("src.comp.EventLayer"))
local ArtifactInfoLayer = class("ArtifactInfoLayer", require("src.comp.EventLayer"))
local ArtifactTipsCell = class("ArtifactTipsCell", require("src.comp.EventLayer"))
local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function ArtifactTipsCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function ArtifactTipsCell:reset(skill_id, skill_level,active_data)
    self.menu:removeAllChildren()

    local skill_name = ex.Player.hero_data:getSkillName(skill_id, skill_level)

    self.lbl_name:setString(skill_name)

    -- self.lbl_active:setVisible(active_data.active)
    local color = active_data.active and FONT_GREEN or cc.c3b(255,255,178)
    self.lbl_active:setColor(color)
    self.lbl_active:setString("("..active_data.max_num..ex.Tools:getLang(47200))

    local skill_data = ex.Player.backpack_data:getRunesSkillConfig(skill_id, skill_level)
    -- for k,v in pairs(cfg.runeskilltype.skill) do
    --     if v.skill_id == skill_id then
    --         skill_data = v
    --         break
    --     end
    -- end
    local info_str = ex.Player.hero_data:getSkillDescription(skill_id, skill_level)
    self.lbl_info:setString(info_str)
    -- local item = require("src.comp.menu.UIMenuItemRunesSkill"):createWithIcon(skill_data)
    -- item.lbl_skill_name:setVisible(false)
    -- self.menu:addChild(item)
    local x,y = self.node_1:getPosition()
    -- item:setPosition(x-2,y-18) 
    self.item_icon = cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", skill_id))

    if not self.item_icon then 
         self.item_icon = cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", 0))
    end
    self:addChild(self.item_icon)
    self.item_icon:setPosition(x,y)
end

function ArtifactBaseLayer:onCreate()
    self:onNodeLoaded(self, nil)
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    self.vec_layer = {}
end

function ArtifactBaseLayer:resetSize()
    --dump(self.vec_layer)
    if table.nums(self.vec_layer) == 0 then
        -- 销毁自己 和 ArtifactTipsCtr
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

function ArtifactInfoLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    local spr_bg = self:addBlackBackground()
    spr_bg:setContentSize(cc.size(spr_bg:getContentSize().width * 100, spr_bg:getContentSize().height * 100))

    self.y = -130
    self.bottom_height = 20
    self.left_margin = -120 - 50 -- -self:getContentSize().width * 0.4
    self.right_margin = self:getContentSize().width * 0.4

    local info_ctr = ArtifactTipsCtr:instance()
    self.btn_close:registerScriptTapHandler(handler(info_ctr, info_ctr.closeWindow))
	self.btn_src:registerScriptTapHandler(handler(info_ctr, info_ctr.onItemSrc))
end

function ArtifactInfoLayer:resetSize()
    self:setContentSize(cc.size(self:getContentSize().width, -self.y + self.bottom_height))
    self.spr_bg:setContentSize(self:getContentSize())
    self.node:setPositionY(self:getContentSize().height - 3)
    self.base_layer:resetSize()
end

function ArtifactInfoLayer:setEquipInfo(data)
    local artifact_cfg = cfg.item.item[data.equip.sys_id]
    self.spr_rare:setSpriteFrame("backpack-info/spr-banner-backpack-"..artifact_cfg.rare_mark .. ".png")
    self.spr_rare1:setSpriteFrame(string.format("backpack/rare-%d.png",  cfg.item.item[data.equip.sys_id].rare_mark))
    self.spr_icon:setSpriteFrame("backpack/"..artifact_cfg.idx .. ".png")
    local vec_rare_color = {}
	vec_rare_color[1] = cc.c3b(120,236,131)
	vec_rare_color[2] = cc.c3b(86,207,247)
	vec_rare_color[3] = cc.c3b(236,80,255)
	vec_rare_color[4] = cc.c3b(255,146,62)
	vec_rare_color[5] = cc.c3b(255,99,68)
    vec_rare_color[6] = cc.c3b(255,238,99)
    self.lbl_name:setColor(vec_rare_color[cfg.item.item[data.equip.sys_id].rare_mark])
    self.lbl_name:setString(ex.Tools:getLang(cfg.item.item[data.equip.sys_id].name))

    return self
end

function ArtifactInfoLayer:addHeight(height)
    height = height or 5
    self.y = self.y - height
    self:resetSize()
    return self
end

function ArtifactInfoLayer:addLine(width, height)
	height = height or 5
	width = width or self:getContentSize().width * 0.9
	local spr_line = cc.Sprite:createWithSpriteFrameName("backpack-info/spr-line.png")
	spr_line:setPosition(0, self.y - height * 0.5)
	self.node:addChild(spr_line)
	self.y = self.y - height

    self:resetSize()
	return self
end

function ArtifactInfoLayer:addAbility(ability)
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
    table.sort(ability.ability, sortAbility)
    table.sort(ability.special_ability, sortAbility)

    if table.nums(ability.ability) > 0 then
        self.y = self.y - 10
    end

    local height = 25

	local lbl_special_ability_text = cc.Label:createWithTTF(ex.Tools:getLang(75008), FONT_DEFAULT_NAME_BOLD, 22)
	:setAnchorPoint(cc.p(0, 0.5))
	:setTextColor(cc.c3b(255, 198, 116))
	lbl_special_ability_text:setPosition(self.left_margin, self.y - lbl_special_ability_text:getContentSize().height * 0.5)
	self.node:addChild(lbl_special_ability_text)
	self.y = self.y - lbl_special_ability_text:getContentSize().height - 10

    for i,v in ipairs(ability.special_ability) do
        local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack-info/spr-attr-%d.png", cfg.attrshow.attrshow[v.attr].icon))
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

		local lbl_ability_num = cc.Label:createWithTTF(ex.StringUtil.formatAttrStr(" "..ex.Tools:getLang(2160000 + v.attr), "##" , v.value), FONT_DEFAULT_NAME_BOLD, 20)
		:setTextColor(cc.c3b(255,255,178))
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(lbl_ability:getPositionX() + lbl_ability:getContentSize().width + 10, lbl_ability:getPositionY())
		self.node:addChild(lbl_ability_num)

		self.y = self.y - height - 15
    end

	local lbl_ability_text = cc.Label:createWithTTF(ex.Tools:getLang(75009), FONT_DEFAULT_NAME_BOLD, 22)
	:setAnchorPoint(cc.p(0, 0.5))
	:setTextColor(cc.c3b(255, 198, 116))
	lbl_ability_text:setPosition(self.left_margin, self.y - lbl_ability_text:getContentSize().height * 0.5)
	self.node:addChild(lbl_ability_text)
	self.y = self.y - lbl_ability_text:getContentSize().height - 10

    for i,v in ipairs(ability.ability) do
        
        local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack-info/spr-attr-%d.png", cfg.attrshow.attrshow[v.attr].icon))
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

		local lbl_ability_num = cc.Label:createWithTTF(ex.StringUtil.formatAttrStr(" "..ex.Tools:getLang(2160000 + v.attr), "##" , v.value), FONT_DEFAULT_NAME_BOLD, 20)
		:setTextColor(cc.c3b(255,255,178))
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(lbl_ability:getPositionX() + lbl_ability:getContentSize().width + 10, lbl_ability:getPositionY())
		self.node:addChild(lbl_ability_num)

		self.y = self.y - height - 15
    end

    local has_suit_num = 0
    local suit_id = cfg.reikiequip.reikiequip[self.data.equip.sys_id].suit_id
    local suit_rare = cfg.reikiequip.reikiequip[self.data.equip.sys_id].rare
    local suit_cfg = cfg.reikiequipsuit.reikiequipsuit[suit_id]
    local max_num = suit_cfg.active_need_num

    for k,v in pairs(self.data.equip_list) do
        local suit = cfg.reikiequip.reikiequip[v].suit_id
        local rare = cfg.reikiequip.reikiequip[v].rare  -- 两件装备品质
        if suit_rare == rare then 
            if suit == suit_id then 
                has_suit_num = has_suit_num + 1
            -- elseif suit ~= suit_id then 
            --     has_suit_num = has_suit_num + 1
            end
        elseif suit_rare < rare then 
            has_suit_num = has_suit_num + 1
        end
    end

    local suit_name = ex.Tools:getLang(suit_cfg.name) .. "(%s/%s)"
	local lbl_suit_text = cc.Label:createWithTTF(string.format(suit_name,has_suit_num,max_num), FONT_DEFAULT_NAME_BOLD, 22)
	:setAnchorPoint(cc.p(0, 0.5))
	:setTextColor(cc.c3b(255, 198, 116))
	lbl_suit_text:setPosition(self.left_margin, self.y - lbl_suit_text:getContentSize().height * 0.5)
	self.node:addChild(lbl_suit_text)
    self.y = self.y - lbl_suit_text:getContentSize().height - 10

    for i,v in ipairs(suit_cfg.suit_ability) do
        local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack-info/spr-attr-%d.png", cfg.attrshow.attrshow[v.attr].icon))
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

		local lbl_ability_num = cc.Label:createWithTTF(ex.StringUtil.formatAttrStr(" "..ex.Tools:getLang(2160000 + v.attr), "##" , v.value), FONT_DEFAULT_NAME_BOLD, 20)
		:setTextColor(cc.c3b(255,255,178))
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(lbl_ability:getPositionX() + lbl_ability:getContentSize().width + 10, lbl_ability:getPositionY())
        self.node:addChild(lbl_ability_num)
        
        local lbl_ability_visible = cc.Label:createWithTTF("("..max_num..ex.Tools:getLang(47200), FONT_DEFAULT_NAME_BOLD, 20)
        :setTextColor(has_suit_num >= max_num and FONT_GREEN or cc.c3b(255,255,178))
        :setAnchorPoint(cc.p(1, 0.5))
        :setPosition(170, lbl_ability:getPositionY())
        self.node:addChild(lbl_ability_visible)

		self.y = self.y - height - 15
    end


    self:resetSize()
    return self
end

function ArtifactInfoLayer:addSkillInfo(skill_id, skill_level,active_data)
    local cell = ArtifactTipsCell:createWithCCBIFile("ccbi/ArtifactTipsCell.ccbi")
    cell:reset(skill_id, skill_level,active_data)
    return cell
end

-- 参数1:点击的装备  参数2：身上所有穿的装备
function ArtifactInfoLayer:addEquipSet(data)
    local has_skill = false

    local artifact_cfg = cfg.reikiequip.reikiequip[data.equip.sys_id]
    local suit_cfg = cfg.reikiequipsuit.reikiequipsuit[artifact_cfg.suit_id]

    has_skill = suit_cfg.skill ~= 0 and suit_cfg.skill_level ~= 0

    -- for i=1,2 do
    --     if runes.skill[i] ~= nil and runes.skill[i].skill_id ~= nil and runes.skill[i].skill_id > 0 then 
    --         has_skill = true
    --         break
    --     end
    -- end

    if has_skill then 
		-- self:addHeight(7)
		-- :addLine()
		-- :addHeight(7)

        -- local lbl_set_text = cc.Label:createWithTTF(ex.Tools:getLang(41114), FONT_DEFAULT_NAME_BOLD, 22)
        -- :setAnchorPoint(cc.p(0, 0.5))
        -- :setTextColor(cc.c3b(255, 198, 116))
        -- lbl_set_text:setPosition(self.left_margin, self.y - lbl_set_text:getContentSize().height * 0.5)
        -- self.node:addChild(lbl_set_text)
        -- self.y = self.y - lbl_set_text:getContentSize().height - 10

        local suit_id = cfg.reikiequip.reikiequip[data.equip.sys_id].suit_id
        local suit_rare = cfg.reikiequip.reikiequip[data.equip.sys_id].rare  -- 当前装备品质
        local active = false  
        local has_suit_num = 0

        for k,v in pairs(data.equip_list) do
            local suit = cfg.reikiequip.reikiequip[v].suit_id
            local rare = cfg.reikiequip.reikiequip[v].rare  -- 两件装备品质
            if suit_rare == rare then 
                if suit == suit_id then 
                    has_suit_num = has_suit_num + 1
                -- elseif suit ~= suit_id then 
                --     has_suit_num = has_suit_num + 1
                end
            elseif suit_rare < rare then 
                has_suit_num = has_suit_num + 1
            end
        end
        local active_data = {}
        
        active = has_suit_num >= cfg.reikiequipsuit.reikiequipsuit[suit_id].active_need_num
        active_data.active = active
        active_data.has_suit_num = has_suit_num
        active_data.max_num = cfg.reikiequipsuit.reikiequipsuit[suit_id].active_need_num

        local cell = self:addSkillInfo(suit_cfg.skill, suit_cfg.skill_level,active_data)
        self.node:addChild(cell)
        cell:setPosition(self.left_margin, self.y - cell:getContentSize().height)
        self.y = self.y - cell:getContentSize().height
        self:addHeight(7)
    end

    -- for i=1,2 do
    --     if runes.skill[i] ~= nil and runes.skill[i].skill_id ~= nil and runes.skill[i].skill_id > 0 then 
    --         local cell = self:addSkillInfo(runes.skill[i].skill_id, runes.skill[i].level)
    --         self.node:addChild(cell)
    --         cell:setPosition(self.left_margin, self.y - cell:getContentSize().height)
    --         self.y = self.y - cell:getContentSize().height
    --         self:addHeight(7)
    --     end
    -- end

    return self
end
 
-- 如果要调用多个按钮请另外增加函数。避免出bug
-- 格式：(ex.Tools:getLang(47760)，handler(.., ..))
function ArtifactInfoLayer:addWearButtion(...)
    local t = {...}
    local t_num = table.nums(t)
    if t_num <= 0 then
        return
    end

    self:addLine()
    :addHeight(7)
    :addHeight(7)

    local item_size = cc.size(self:getContentSize().width * 0.5, 60)
    local col = t_num > 1 and 2 or 1
    local row = math.ceil(t_num / 2) -- 总行数
    local begin_x = -(col - 1) * item_size.width * 0.5
    local begin_y = self.y - item_size.height * 0.5
    for i, v in ipairs(t) do
        local x = (i - 1) % col
        local y = math.floor((i - 1) / col)
        local btn = cpp.UIMenuItemLabel:create("button/btn-old-1.png", "", "", nil)
        :setPosition(begin_x + x * item_size.width, begin_y - item_size.height * y)
        btn:setLabelText(v.str)
		btn:setLabelColor(cc.c3b(122,71,45))
        btn:setLabelSize(48)
        if v.atom ~= nil then 
            btn:setName(v.atom)
            self["btn_" .. v.atom] = btn
        end

        if v.is_show_red ~= nil and v.is_show_red == true then
            local _,reds = ex.Player.backpack_data:checkRunesRedByHero(v.hero_id)

            if reds[v.place] then
                local red = cc.Sprite:createWithSpriteFrameName("other/spr-reddot-1.png")
                red:setName("redPoint")
                btn:addChild(red)
                red:setLocalZOrder(100)
                red:setPosition(btn:getContentSize().width * 0.9, btn:getContentSize().height * 0.9)
            end
        end

        -- 设置属性
        btn.data = v.data
        if  v.keep == false or (not v.keep) then
            btn.call = v.call
            btn:registerScriptTapHandler(function(tag, pSender)
                pSender.call(tag, pSender)
                ArtifactTipsCtr:instance():closeWindow(0, nil)
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

function ArtifactTipsCtr:loadLayer()
    self.layer = ArtifactBaseLayer:create()
    self:setLayer(self.layer)

    -- 创建点击事件
    self:registerTouchListen()
end


function ArtifactTipsCtr:getArtifactInfoLayer()
    return self.layer
end

function ArtifactTipsCtr:openWindow()
    if self:isOpened() then
        return
    end
    self:setIsSingle(false)

    local path = cc.FileUtils:getInstance():fullPathForFilename("ccbi-res/backpack-info-lang.plist")

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/backpack-info.plist")
    sfc:addSpriteFrames("ccbi-res/skill-icon.plist")

    -- self:loadLayer()
    self:open()

    return self
end

function ArtifactTipsCtr:onItemSrc(tag, pSender)
	ex.Tools:onClickItemSrc(self.sys_id)
end

function ArtifactTipsCtr:addAbilityLayer()
    if not self:getLayer() then
        return nil
    end

    local layer = self.layer
    layer:setTag(999)

    local ability_layer = ArtifactInfoLayer:createWithCCBIFile("ccbi/ArtifactTipsLayer.ccbi")
    ability_layer.base_layer = layer
    layer:addChild(ability_layer)

    table.insert(layer.vec_layer, ability_layer)
    return ability_layer
end

function ArtifactTipsCtr:addEquipInfo(data)
    self.data = data
    self.sys_id = data.equip.sys_id

    local layer = self:addAbilityLayer()
    local artifact_cfg = cfg.reikiequip.reikiequip[data.equip.sys_id]
    local ability = artifact_cfg.ability
    local special_ability = artifact_cfg.special_ability
    local vec_ability = {}
    vec_ability.ability = ability
    vec_ability.special_ability = special_ability
    -- table.insert(vec_ability, ability)
    layer.data = data
    
    layer:setEquipInfo(data)
    :addAbility(vec_ability)
    :addEquipSet(data)
    return layer
end


return ArtifactTipsCtr
