local HallowsInfoCtr = class("HallowsInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HallowsBaseLayer = class("HallowsBaseLayer", require("src.comp.EventLayer"))
local HallowsInfoLayer = class("HallowsInfoLayer", require("src.comp.EventLayer"))
local HallowsInfoCell = class("HallowsInfoCell", require("src.comp.EventLayer"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function HallowsInfoCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function HallowsInfoCell:reset(skill_id, skill_level)
    self.menu:removeAllChildren()

    local skill_name = ex.Player.hero_data:getSkillName(skill_id, skill_level)
    self.lbl_skill_name:setString(skill_name)
    self.lbl_skill_type:setString(ex.Tools:getLang(41239))

    self.item_icon = cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", skill_id))
    if not self.item_icon then 
         self.item_icon = cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", 0))
    end
    self:addChild(self.item_icon)
    self.item_icon:setPosition(self.node_1:getPosition())
end

function HallowsBaseLayer:onCreate()
    self:onNodeLoaded(self, nil)
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    self.vec_layer = {}
end

function HallowsBaseLayer:resetSize()
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

function HallowsInfoLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:addBlackBackground()

    self.y = -130
    self.bottom_height = 20
    self.left_margin = -120 - 50 -- -self:getContentSize().width * 0.4
    self.right_margin = self:getContentSize().width * 0.4

    local info_ctr = HallowsInfoCtr:instance()
    self.btn_close:registerScriptTapHandler(handler(info_ctr, info_ctr.closeWindow))
end

function HallowsInfoLayer:resetSize()
    self:setContentSize(cc.size(self:getContentSize().width, -self.y + self.bottom_height))
    self.spr_bg:setContentSize(self:getContentSize())
    self.node:setPositionY(self:getContentSize().height - 3)
    self.base_layer:resetSize()
end

function HallowsInfoLayer:setItemInfo(item_type)
	local vec_rare_color = {}
	vec_rare_color[1] = cc.c3b(120,236,131)
	vec_rare_color[2] = cc.c3b(86,207,247)
	vec_rare_color[3] = cc.c3b(236,80,255)
	vec_rare_color[4] = cc.c3b(255,146,62)
	vec_rare_color[5] = cc.c3b(255,99,68)
    vec_rare_color[6] = cc.c3b(255,238,99)
    
    local config_relic = cfg.dragonrelic.dragonrelic[item_type]
    local config_item = cfg.item.item[item_type]
    -- self.spr_rare:setSpriteFrame("backpack-info/spr-banner-backpack-"..config_item.rare_mark..".png")
    ex.Tools:setSpriteFrame(self.spr_rare, "backpack-info/spr-banner-backpack-"..config_item.rare_mark..".png")
    self.spr_item_icon:setSpriteFrame(config_item.icon..".png")
    self.lbl_item_name:setString(ex.Tools:getLang(config_item.name))
	self.lbl_item_name:setColor(vec_rare_color[config_item.rare_mark])

    return self
end

function HallowsInfoLayer:addHeight(height)
    height = height or 5
    self.y = self.y - height
    self:resetSize()
    return self
end

function HallowsInfoLayer:addLine(width, height)
	height = height or 5
	width = width or self:getContentSize().width * 0.9
	local spr_line = cc.Sprite:createWithSpriteFrameName("backpack-info/spr-line.png")
	spr_line:setPosition(0, self.y - height * 0.5)
	self.node:addChild(spr_line)
	self.y = self.y - height

    self:resetSize()
	return self
end

function HallowsInfoLayer:addAbility(ability)
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

        if i % 2 == 0 then
            self.y = self.y - height - 15
        -- else
            spr_icon:setPositionX(spr_icon:getPositionX() + 180)
            lbl_ability:setPositionX(lbl_ability:getPositionX() + 180)
            lbl_ability_num:setPositionX(lbl_ability_num:getPositionX() + 180)
        end
    end

    self:resetSize()
    return self
end

function HallowsInfoLayer:addSkillInfo(skill_id, skill_level)
    self:addHeight(7)
    
    local lbl_set_text = cc.Label:createWithTTF(ex.Tools:getLang(74592), FONT_DEFAULT_NAME_BOLD, 22)
    :setAnchorPoint(cc.p(0, 0.5))
    :setTextColor(cc.c3b(255, 198, 116))
    lbl_set_text:setPosition(self.left_margin, self.y - lbl_set_text:getContentSize().height * 0.5)
    self.node:addChild(lbl_set_text)
    self.y = self.y - lbl_set_text:getContentSize().height - 5

    local cell = HallowsInfoCell:createWithCCBIFile("ccbi/HallowsInfoCell.ccbi")
    cell:reset(skill_id, skill_level)
    self.node:addChild(cell)

    cell:setPosition(self.left_margin, self.y - cell:getContentSize().height)
    self.y = self.y - cell:getContentSize().height
    -- self:addHeight(12)

    return self
end

function HallowsInfoLayer:addDesc(str_desc)
	self:addHeight(7)
	:addLine()
	:addHeight(7)

	local lbl_desc = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 20)
	:setTextColor(cc.c3b(144, 111, 72))
    :setAnchorPoint(cc.p(0, 0.5))
    :setDimensions(self:getContentSize().width * 0.8, 0)
	lbl_desc:setString(str_desc)
	lbl_desc:setPosition(self.left_margin, self.y - lbl_desc:getContentSize().height * 0.5)
	self.node:addChild(lbl_desc)

	-- 有最小高度
	local height = math.max(lbl_desc:getContentSize().height, 50)
	self.y = self.y - height - 10

    self:resetSize()
	return self
end

-- 如果要调用多个按钮请另外增加函数。避免出bug
-- 格式：(ex.Tools:getLang(47760)，handler(.., ..))
function HallowsInfoLayer:addWearButtion(...)
    local t = {...}
    local t_num = table.nums(t)
    if t_num <= 0 then
        return
    end

    -- self:addLine()
    -- :addHeight(7)
    -- :addHeight(7)

    local item_size = cc.size(self:getContentSize().width, 60)
    local col = t_num == 2 and 2 or 3
    local row = math.ceil(t_num / 3) -- 总行数
    local begin_x = item_size.width / col * 0.5 - item_size.width / 2
    local begin_y = self.y - item_size.height * 0.5
    for i, v in ipairs(t) do
        local x = (i - 1) % col
        local y = math.floor((i - 1) / col)
        local btn = cpp.UIMenuItemLabel:create("button/btn-small-1.png", "button/btn-small-1.png", "button/btn-small-1.png", nil)
        btn:setPosition(begin_x + x * item_size.width / col, begin_y - y * item_size.height)
        btn:setLabelText(v.str)
		btn:setLabelColor(cc.c3b(122,71,45))
        btn:setLabelSize(48)

        if v.enable ~= nil and v.enable == false then
            btn:setDisabledImage(cc.Sprite:createWithSpriteFrameName("button/btn-small-1.png"))
            ex.Tools:setGrayAuto(btn:getDisabledImage(), true)
            btn:setEnabled(false)
        end

        -- 设置属性
        btn.data = v.data
        if  v.keep == false or (not v.keep) then
            btn.call = v.call
            btn:registerScriptTapHandler(function(tag, pSender)
                pSender.call(tag, pSender)
                HallowsInfoCtr:instance():closeWindow(0, nil)
            end)
        else
            btn:registerScriptTapHandler(v.call)
        end
        self.menu:addChild(btn)
    end

    self.y = self.y - (item_size.height * row)

    self:resetSize()
    return self
end

-----------------------------------------------------------------------------

function HallowsInfoCtr:loadLayer()
    self.layer = HallowsBaseLayer:create()
    self:setLayer(self.layer)

    -- 创建点击事件
    self:registerTouchListen()
end

function HallowsInfoCtr:openWindow()
    if self:isOpened() then
        return
    end
    self:setIsSingle(false)

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/backpack-info.plist")
    sfc:addSpriteFrames("ccbi-res/skill-icon.plist")

    -- self:loadLayer()
    self:open()

    return self
end

function HallowsInfoCtr:addAbilityLayer()
    if not self:getLayer() then
        return nil
    end

    local layer = self.layer
    layer:setTag(999)

    local ability_layer = HallowsInfoLayer:createWithCCBIFile("ccbi/HallowsInfoLayer.ccbi")
    ability_layer.base_layer = layer
    layer:addChild(ability_layer)
    layer.ability_layer = ability_layer

    table.insert(layer.vec_layer, ability_layer)
    return ability_layer
end

function HallowsInfoCtr:addDataInfo(item_type)
    self.item_type = item_type

    local layer = self:addAbilityLayer()
    local config_relic = cfg.dragonrelic.dragonrelic[item_type]
    layer.item_type = item_type
    
    layer:setItemInfo(item_type)
    :addAbility(config_relic.ability)
    :addSkillInfo(config_relic.skill, config_relic.star)
    :addDesc(ex.Player.hero_data:getSkillDescription(config_relic.skill, config_relic.star))
    return layer
end

return HallowsInfoCtr
