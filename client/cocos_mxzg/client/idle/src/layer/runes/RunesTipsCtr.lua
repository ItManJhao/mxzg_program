local RunesTipsCtr = class("RunesTipsCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local RunesBaseLayer = class("RunesBaseLayer", require("src.comp.EventLayer"))
local RunesInfoLayer = class("RunesInfoLayer", require("src.comp.EventLayer"))
local RunesTipsCell = class("RunesTipsCell", require("src.comp.EventLayer"))
local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function RunesTipsCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function RunesTipsCell:reset(skill_id, skill_level)
    self.menu:removeAllChildren()

    local skill_name = ex.Player.hero_data:getSkillName(skill_id, skill_level)

    self.lbl_name:setString(skill_name)

    local skill_data = ex.Player.backpack_data:getRunesSkillConfig(skill_id, skill_level)
    -- for k,v in pairs(cfg.runeskilltype.skill) do
    --     if v.skill_id == skill_id then
    --         skill_data = v
    --         break
    --     end
    -- end
    local info_str = ex.Player.hero_data:getSkillDescription(skill_data.skill_id, skill_data.level)
    -- self.lbl_info:setString(info_str)
    self.lbl_info_scroll = ex.Tools:getNodeWithScrollLabel(cc.size(480,160),40, cc.c3b(161,129,89),info_str)
    self.lbl_info_scroll:setAnchorPoint(ex.a.left_top)
	self.node_info:addChild(self.lbl_info_scroll)

    -- local item = require("src.comp.menu.UIMenuItemRunesSkill"):createWithIcon(skill_data)
    -- item.lbl_skill_name:setVisible(false)
    -- self.menu:addChild(item)
    local x,y = self.node_1:getPosition()
    -- item:setPosition(x-2,y-18) 
    self.item_icon = cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", skill_data.skill_id + skill_data.level - 1))

    if not self.item_icon then 
         self.item_icon = cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", 0))
    end
    self:addChild(self.item_icon)
    self.item_icon:setPosition(x,y)
end

function RunesBaseLayer:onCreate()
    self:onNodeLoaded(self, nil)
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    self.vec_layer = {}
end

function RunesBaseLayer:resetSize()
    --dump(self.vec_layer)
    if table.nums(self.vec_layer) == 0 then
        -- 销毁自己 和 RunesTipsCtr
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

function RunesInfoLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:addBlackBackground()

    self.y = -130
    self.bottom_height = 20
    self.left_margin = -120 - 50 -- -self:getContentSize().width * 0.4
    self.right_margin = self:getContentSize().width * 0.4

    local info_ctr = RunesTipsCtr:instance()
    self.btn_close:registerScriptTapHandler(handler(info_ctr, info_ctr.closeWindow))
	self.btn_src:registerScriptTapHandler(handler(info_ctr, info_ctr.onItemSrc))
end

function RunesInfoLayer:resetSize()
    self:setContentSize(cc.size(self:getContentSize().width, -self.y + self.bottom_height))
    self.spr_bg:setContentSize(self:getContentSize())
    self.node:setPositionY(self:getContentSize().height - 3)
    self.base_layer:resetSize()
end

function RunesInfoLayer:setEquipInfo(data)
    local runes_cfg = cfg.runestype.runestype[data.item_type]
    self.spr_rare:setSpriteFrame("backpack-info/spr-banner-backpack-"..runes_cfg.rare .. ".png")
    self.spr_icon:setSpriteFrame("backpack/"..runes_cfg.type .. ".png")
    self.lbl_name:setSpriteFrame("backpack-info-lang/lbl-runes-"..runes_cfg.type .. ".png")

    return self
end

function RunesInfoLayer:addHeight(height)
    height = height or 5
    self.y = self.y - height
    self:resetSize()
    return self
end

function RunesInfoLayer:addLine(width, height)
	height = height or 5
	width = width or self:getContentSize().width * 0.9
	local spr_line = cc.Sprite:createWithSpriteFrameName("backpack-info/spr-line.png")
	spr_line:setPosition(0, self.y - height * 0.5)
	self.node:addChild(spr_line)
	self.y = self.y - height

    self:resetSize()
	return self
end

function RunesInfoLayer:addAbility(ability)
    -- 排序属性
    local function sortAbility(a, b)
        -- local compA = cfg.scorecount.mapping[a.attr]
        local compA = TableEx.findValueFunction(cfg.scorecount.equip, function(value)
			return value.mapping == a.attr
		end)
        compA = compA and compA.idx or 100

        local compB = TableEx.findValueFunction(cfg.scorecount.equip, function(value)
			return value.mapping == b.attr
		end)
        -- local compB = cfg.scorecount.mapping[b.attr]
        compB = compB and compB.idx or 100

        return compA < compB
    end
    --table.insert(ability, ability[1])
    table.sort(ability, sortAbility)

    if table.nums(ability) > 0 then
        self.y = self.y - 10
    end

	local lbl_ability_text = cc.Label:createWithTTF(ex.Tools:getLang(41113), FONT_DEFAULT_NAME_BOLD, 22)
	:setAnchorPoint(cc.p(0, 0.5))
	:setTextColor(cc.c3b(255, 198, 116))
	lbl_ability_text:setPosition(self.left_margin, self.y - lbl_ability_text:getContentSize().height * 0.5)
	self.node:addChild(lbl_ability_text)
	self.y = self.y - lbl_ability_text:getContentSize().height - 10

    local height = 25
    for i,v in ipairs(ability) do
        local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack-info/spr-attr-%d.png", v.attr))
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

		self.y = self.y - height - 15
    end

    self:resetSize()
    return self
end

function RunesInfoLayer:addSkillInfo(skill_id, skill_level)
    local cell = RunesTipsCell:createWithCCBIFile("ccbi/RunesTipsCell.ccbi")
    cell:reset(skill_id, skill_level)
    return cell
end

-- 参数1:点击的装备  参数2：身上所有穿的装备
function RunesInfoLayer:addEquipSet(runes)
    local has_skill = false

    for i=1,2 do
        if runes.skill[i] ~= nil and runes.skill[i].skill_id ~= nil and runes.skill[i].skill_id > 0 then 
            has_skill = true
            break
        end
    end

    if has_skill then 
		-- self:addHeight(7)
		-- :addLine()
		-- :addHeight(7)

        local lbl_set_text = cc.Label:createWithTTF(ex.Tools:getLang(41114), FONT_DEFAULT_NAME_BOLD, 22)
        :setAnchorPoint(cc.p(0, 0.5))
        :setTextColor(cc.c3b(255, 198, 116))
        lbl_set_text:setPosition(self.left_margin, self.y - lbl_set_text:getContentSize().height * 0.5)
        self.node:addChild(lbl_set_text)
        self.y = self.y - lbl_set_text:getContentSize().height - 10
    end

    for i=1,2 do
        if runes.skill[i] ~= nil and runes.skill[i].skill_id ~= nil and runes.skill[i].skill_id > 0 then 
            local cell = self:addSkillInfo(runes.skill[i].skill_id, runes.skill[i].level)
            self.node:addChild(cell)
            cell:setPosition(self.left_margin, self.y - cell:getContentSize().height)
            self.y = self.y - cell:getContentSize().height
            self:addHeight(7)
        end
    end

    return self
end

-- 如果要调用多个按钮请另外增加函数。避免出bug
-- 格式：(ex.Tools:getLang(47760)，handler(.., ..))
function RunesInfoLayer:addWearButtion(...)
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
                RunesTipsCtr:instance():closeWindow(0, nil)
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

function RunesTipsCtr:loadLayer()
    self.layer = RunesBaseLayer:create()
    self:setLayer(self.layer)

    -- 创建点击事件
    self:registerTouchListen()
end


function RunesTipsCtr:getRunesInfoLayer()
    return self.layer
end

function RunesTipsCtr:openWindow()
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

function RunesTipsCtr:onItemSrc(tag, pSender)
	ex.Tools:onClickItemSrc(self.item_type)
end

function RunesTipsCtr:addAbilityLayer()
    if not self:getLayer() then
        return nil
    end

    local layer = self.layer
    layer:setTag(999)

    local ability_layer = RunesInfoLayer:createWithCCBIFile("ccbi/RunesTipsLayer.ccbi")
    ability_layer.base_layer = layer
    layer:addChild(ability_layer)

    table.insert(layer.vec_layer, ability_layer)
    return ability_layer
end

function RunesTipsCtr:addEquipInfo(data)
    self.item_type = data.item_type

    local layer = self:addAbilityLayer()
    local runes_cfg = cfg.runestype.runestype[data.item_type]
    local ability = ex.Player.backpack_data:getRunesAbilityConfig(runes_cfg.rare, data.ability_id)
    local vec_ability = {}
    table.insert(vec_ability, ability)
    layer.data = data
    
    layer:setEquipInfo(data)
    :addAbility(vec_ability)
    :addEquipSet(data)
    return layer
end


return RunesTipsCtr
