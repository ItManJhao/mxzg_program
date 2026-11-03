local HallowsSelectCtr = class("HallowsSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HallowsSelectLayer = class("HallowsSelectLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function HallowsSelectLayer:onCreate()
    self:setAutoClose(true)
    self:addBlackBackground()

    local scale_label = 0.5
    self.lbl_tip = require("src.comp.RichTextEx"):create()
	:setFontSize(40)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#7A472D")
    :setScale(scale_label)
    :setAnchorPoint(0, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(50, 655)
    self:addChild(self.lbl_tip, 10001)

    self.lbl_tip:setXmlTextLua(ex.Tools:getLang(74534))
    self.lbl_tip:formatText()

    self.scroll_view:setItemSize(cc.size(130, 150))
    -- self.scroll_view:setItemType(1)
end

-----------------------------------------------------------------------------
function HallowsSelectCtr:onCreate()
    self:setCCBIPath("ccbi/HallowsSelectLayer.ccbi")
    
    self:setIsSingle(false)

    self.data = {}

    self.show_heros = {}

    self.selected_item = {}
end

function HallowsSelectCtr:openWindow(pos)
	if self:isOpened() then
		return
	end

    self.pos = pos

	self:loadLayer()
    self:open()
    
	self:initDone()
end

function HallowsSelectCtr:getLayerClass()
	return HallowsSelectLayer
end

function HallowsSelectCtr:initDone()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))

    self.vec_item = ex.Player.backpack_data:getItemsByPageSign(ItemData.IT_HALLOWS)
    self.selected_item = 0
    if #self.vec_item > 0 then
        self.selected_item = self.vec_item[1].item_type
    end

    self.layer.scroll_view.createItemFunction = function(data, scale)
		local node = cpp.UIMenuItemImage:create()
		node:registerScriptTapHandler(handler(self, self.onItemSelect))
		node:setContentSize(cc.size(130, 150))
		node.item_type = data.item_type

		node.item = ex.Tools:createBackpackItem(data.item_type, 0)
		local is_wear = TableEx.findValueFunction(self.vec_selected, function(value)
			return data.item_type == value.item_type
		end)
        node.item:setPosition(node:getContentSize().width / 2, node:getContentSize().height / 2 + 20)
        node:addChild(node.item)

		node.item:setSelected(is_wear ~= nil)

        local spr_name_bg = cc.Scale9Sprite:createWithSpriteFrameName("win-bg/block-bg-9.png", cc.rect(15,15,1,1))
        spr_name_bg:setContentSize(cc.size(100, 30))
        spr_name_bg:setPosition(node.item:getContentSize().width / 2, -20)
        node.item:addChild(spr_name_bg, 10)

        local lbl_name = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 40)
        lbl_name:setScale(0.5)
        lbl_name:setPosition(spr_name_bg:getPosition())
        node.item:addChild(lbl_name, 20)

        local config_item = cfg.item.item[data.item_type]
        lbl_name:setString(ex.Tools:getLang(config_item.name))
        lbl_name:setColor(COLOR_RARE_HALLOWS[config_item.rare_mark] or FONT_BROWN)

        return node
	end
	self.layer.scroll_view:reloadData(self.vec_item)

    self.layer.scroll_view.menu:setLuaModel(true)
    self.layer.scroll_view.menu:enableLongPress(true)
    self.layer.scroll_view.menu:setLongPressCallback(handler(self, self.longTouch))

	self:updateLayer()
end

function HallowsSelectCtr:longTouch(tag, pSender)
    if pSender.item_type == nil or pSender.item_type <= 0 then
        return
	end
	
	local info_ctr = require("src.layer.dragon.HallowsInfoCtr"):instance()
	info_ctr:openWindow()
	info_ctr:addDataInfo(pSender.item_type)
end

function HallowsSelectCtr:updateLayer()
    local vec_children = self.layer.scroll_view.menu:getChildren()
    for _,v in pairs(vec_children) do
        if v.item ~= nil and v.item.item_type ~= nil then
            v.item:setSelected(v.item.item_type == self.selected_item)
        end
    end

    if self.selected_item <= 0 then
        self.layer.node_pannel:setVisible(false)
        self.layer.lbl_tips:setVisible(true)
        return
    end
    self.layer.node_pannel:setVisible(true)
    self.layer.lbl_tips:setVisible(false)

    local config_item = cfg.item.item[self.selected_item]

	if self.layer.item ~= nil then
		self.layer.item:removeFromParent()
		self.layer.item = nil
	end
	self.layer.item = UIMenuItemBackpack:createWithData(self.selected_item, 0)
	self.layer.item:setPosition(80, 100)
    self.layer.node_pannel:addChild(self.layer.item, 10)
    
    self.layer.lbl_item_name:setString(ex.Tools:getLang(config_item.name))

    local config_relic = cfg.dragonrelic.dragonrelic[self.selected_item]
	local str_skill_name =  ex.Player.hero_data:getSkillName(config_relic.skill, config_relic.star)
    local str_skill_desc = ex.Player.hero_data:getSkillDescription(config_relic.skill, config_relic.star)
    self.layer.spr_skill_icon:setSpriteFrame(string.format("skill-icon/%d.png", config_relic.skill))
    self.layer.lbl_skill_name:setString(str_skill_name)
    self.layer.lbl_skill_desc:setString(str_skill_desc)
end

function HallowsSelectCtr:onItemSelect(tag, pSender)
    if pSender.item_type == nil or pSender.item_type <= 0 then
        return
    end

    if self.selected_item == pSender.item_type then
        self.selected_item = 0
    else
        self.selected_item = pSender.item_type
    end
    
    self:updateLayer()
end

function HallowsSelectCtr:onConfirm(tag, pSender)
    if self.selected_item == nil then
        return
    end

    if self.selected_item > 0 then
        local config_relic = cfg.dragonrelic.dragonrelic[self.selected_item]
        -- 检查是否有同类型圣物已装载
        for i,v in ipairs(ex.Player.dragon_data.vec_hallows) do
            if v.item_type > 0 then
                local tmp_config = cfg.dragonrelic.dragonrelic[v.item_type]
                if tmp_config ~= nil and tmp_config.kind == config_relic.kind then
                    ex.MessageView:add(ex.Tools:getLang(74559))
                    return
                end
            end
        end
    end

    local req = Dragon_pb.GReqDragonChange()
    req.slot_id = self.pos
    req.sys_id = self.selected_item
    NetManager:sendMessage(ProtocolID.GReqDragonChange, req)

	self:closeWindow()
end

return HallowsSelectCtr
