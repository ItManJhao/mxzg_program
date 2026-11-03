local RunesSelectCtr = class("RunesSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local RunesSelectLayer = class("RunesSelectLayer", require("src.comp.LuaLayerBase"), require("src.comp.EventLayer"))
local UIMenu = require("src.comp.menu.UIMenu")


local RunesSelectCell = class("RunesSelectCell", require("src.comp.LuaLayerBase"))
function RunesSelectCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function RunesSelectCell:setTableView(table_view)
    self.tableView = table_view
    self.menu:setSwallowsTouches(false)
    self.menu:setIsTouchInsideNode(table_view)
end

function RunesSelectCell:reset(data)
    if not data then return end
    self.data = data

    self.btn_runes:setNormalImage(cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", data.runes_data.item_type)))
    self.btn_runes:setSelectedImage(cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", data.runes_data.item_type)))
    self.btn_runes:setDisabledImage(cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", data.runes_data.item_type)))
    self.btn_runes:setTag(data.runes_data.item_type)
    self.btn_runes.runes_id = data.runes_data.item_id
    self.btn_runes:registerScriptTapHandler(data.callback_info)
    -- self.spr_attr:setSpriteFrame(string.format("head-icon/%d.png", data.head_id))
    -- self.lbl_attr:setString(data.name)
    local runes_cfg = cfg.runestype.runestype[data.runes_data.item_type]
    local ability = ex.Player.backpack_data:getRunesAbilityConfig(runes_cfg.rare, data.runes_data.ability_id)
    local str = ex.Tools:getLang(2140000 + ability.attr) 
    str = ex.StringUtil.formatAttrStr(str, "##" , ability.value)

    self.spr_frame:setSpriteFrame("backpack/rare-"..runes_cfg.rare .. ".png")
    -- self.spr_attr:setSpriteFrame("runes/elem-"..ability.attr .. ".png")
    ex.Tools:setSpriteFrame(self.spr_attr, "runes/elem-"..ability.attr .. ".png")
    self.lbl_attr:setString(str)

    if data.runes_data.skill[1] ~= nil and data.runes_data.skill[1].skill_id > 0 then
        local skill_type = data.runes_data.skill[1].skill_id 
        local skill_name = ex.Player.hero_data:getSkillName(skill_type, data.runes_data.skill[1].level)

        local lbl_skill = cc.Label:createWithTTF("【" .. skill_name .. "】", FONT_DEFAULT_NAME_BOLD, 42)
        -- lbl_skill:enableUnderline()
        lbl_skill:setColor(cc.c3b(230, 120, 2))
        lbl_skill:setAnchorPoint(0, 0)

        local item = cpp.UIMenuItemImage:create()
        item:setEnableAction(false)
        item:addChild(lbl_skill)
        item:setContentSize(lbl_skill:getContentSize())
        item:setAnchorPoint(0, 0)
        item:setScale(0.5)
        item:setPosition(120, 30)
        self.menu:addChild(item)

        item.skill_type = data.runes_data.skill[1].skill_id
        item.skill_level = data.runes_data.skill[1].level

        item:registerScriptTapHandler(data.callback_skill)
    end

    if data.runes_data.skill[2] ~= nil and data.runes_data.skill[2].skill_id > 0 then
        local skill_type = data.runes_data.skill[2].skill_id 
        local skill_name = ex.Player.hero_data:getSkillName(skill_type, data.runes_data.skill[2].level)

        local lbl_skill = cc.Label:createWithTTF("【" .. skill_name .. "】", FONT_DEFAULT_NAME_BOLD, 42)
        -- lbl_skill:enableUnderline()
        lbl_skill:setColor(cc.c3b(230, 120, 2))
        lbl_skill:setAnchorPoint(0, 0)

        local item = cpp.UIMenuItemImage:create()
        item:setEnableAction(false)
        item:addChild(lbl_skill)
        item:setContentSize(lbl_skill:getContentSize())
        item:setAnchorPoint(0, 0)
        item:setScale(0.5)
        item:setPosition(250, 30)
        self.menu:addChild(item)

        item.skill_type = data.runes_data.skill[2].skill_id
        item.skill_level = data.runes_data.skill[2].level

        item:registerScriptTapHandler(data.callback_skill)
    end

    self.btn_select:registerScriptTapHandler(data.callback_select)
    self.btn_select.runes_id = data.runes_data.item_id

    ex.Tools:setGrayAuto(self.btn_select:getDisabledImage(), false)

    if data.setSelected == false then
        self.btn_select:setLabelText(ex.Tools:getLang(47255))
        self.btn_select:setLabelSize(42)
    else
        self.btn_select:setLabelText(ex.Tools:getLang(47205))
        self.btn_select:setLabelSize(42)
        self.btn_select:setEnabled(false)
    end
end

function RunesSelectLayer:onCreate()
    -- 初始化tableview
    local view_size = cc.size(self.spr_tableview_bg:getContentSize().width - 20, self.spr_tableview_bg:getContentSize().height - 10)
    local pos = cc.p(self.spr_tableview_bg:getPositionX() + 10, self.spr_tableview_bg:getPositionY() + 5)
    self.tableView = ex.Tools:initTableView(self, {}, {RunesSelectCell, "ccbi/RunesSelectCell.ccbi"}, view_size, 7, pos)

    self.lbl_tip:setString(ex.Tools:getLang(41156))
end

-----------------------------------------------------------------------------
function RunesSelectCtr:onCreate()
	self:setCCBIPath("ccbi/RunesSelectLayer.ccbi")
    self:setIsSingle(false)
    
end

function RunesSelectCtr:getLayerClass()
	return RunesSelectLayer
end

function RunesSelectCtr:getHeroSelectLayer()
	return self.layer
end

function RunesSelectCtr:openWindow(callback, place)
	if self:isOpened() then
		return
	end
	
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/runes.plist")

	self:loadLayer()
	self:open()
	self:initData(callback, place)

end

function RunesSelectCtr:initData(callback, place)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    
    self.callback = callback
    self.place = place

	self:updateTableView()
end

function RunesSelectCtr:updateTableView()
    if not self:getLayer() then
        return
    end

    local vec_runes = clone(ex.Player.backpack_data:getRunesListNotWear())

    local runes_data = {}
    for k,v in pairs(vec_runes) do
        local nowData = {}
        nowData.tag = 1
        nowData.runes_data = v
        nowData.setSelected = false
        nowData.callback_select = handler(self, self.onRunesSelect)
        nowData.callback_info = handler(self, self.onRunesIcon)
        nowData.callback_skill = handler(self, self.onRunesSkill)

        -- if TableEx.isInTable(self.layer.vec_selected, v.item_id) then
        --     nowData.setSelected = true
        -- end
        
        table.insert(runes_data, nowData)
    end

    -- local bg_size = layer.tableView:getContentSize()
    self.layer.tableView:initData(runes_data)
    local offsetY = self.layer.tableView:getContainer():getPositionY()
end

function RunesSelectCtr:onRunesSelect(tag, pSender)
    if pSender == nil or pSender.runes_id == nil then
        return
    end

    if self.callback then
        self.callback(pSender.runes_id, self.place)

        self:closeWindow(0 , nil)
    end
end

function RunesSelectCtr:onRunesIcon(tag, pSender)
    local runes = ex.Player.backpack_data:getRunesById(pSender.runes_id)
    require("src.layer.runes.RunesTipsCtr"):instance():openWindow()
    :addEquipInfo(runes)
end

function RunesSelectCtr:onRunesSkill(tag, pSender)
    require("src.layer.HeroSkillInfoCtr"):instance():openWindow(pSender.skill_type, pSender.skill_level)
end

return RunesSelectCtr
