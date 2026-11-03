local DragonSkillCtr = class("DragonSkillCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local DragonSkillLayer = class("DragonSkillLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenu = require("src.comp.menu.UIMenu")
local UIMenuItemDragonSkill = require("src.comp.menu.UIMenuItemDragonSkill")

local vec_pos = {}
table.insert(vec_pos, cc.p(180, 195))
table.insert(vec_pos, cc.p(340, 195))
table.insert(vec_pos, cc.p(180, 75))
table.insert(vec_pos, cc.p(340, 75))

function DragonSkillLayer:onCreate()
    self:setAutoClose(true)
	self:addBlackBackground()

	self.vec_selected = {}

	local scale_label = 0.5

	self:reorderChild(self.node_pannel, 100)

    -- 提示
    self.lbl_tip = require("src.comp.RichTextEx"):create()
	:setFontSize(40)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#7A472D")
    :setScale(scale_label)
    :setAnchorPoint(0.5, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(320, 390)
	self:addChild(self.lbl_tip, 10)
	
    self.lbl_tip:setXmlTextLua(ex.Tools:getLang(74536))
	self.lbl_tip:formatText()
	
	self.scroll_view:setItemSize(cc.size(130, 150))
    -- self.scroll_view:setItemType(1)
	self.scroll_view:setResetOffset(true)

	self.menu_selected = UIMenu:create()
    self.menu_selected:setPosition(cc.p(0, 0))
    self.menu_selected:setSwallowsTouches(false)
    self.menu_selected:setName("menu_selected")
    self.node_pannel:addChild(self.menu_selected)
end

-----------------------------------------------------------------------------
function DragonSkillCtr:onCreate()
	self:setCCBIPath("ccbi/DragonSkillLayer.ccbi")
	self:setIsSingle(false)
end

function DragonSkillCtr:getLayerClass()
	return DragonSkillLayer
end

function DragonSkillCtr:openWindow()
	if self:isOpened() then
		return
    end
	
	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/skill-icon.plist")
	sfc:addSpriteFrames("ccbi-res/dragon.plist")

	self:loadLayer()
	self:open()
	self:initData()
end

function DragonSkillCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))

    -- 启用menu的touch事件，并设置exchange回调
    self.layer.menu_selected:enableExchange(true)
	self.layer.menu_selected:setExchangeCallback(handler(self, self.exchangeCallback))
	
	-- 创建技能按钮
	local config_level = cfg.dragonlevel.dragonlevel[ex.Player.dragon_data.dragon_level]
	local skill_num = config_level.relic_unlock
	local vec_wear = ex.Player.dragon_data.vec_hallows
	for i=1,4 do
		local hallows_data = vec_wear[i]

		local btn = UIMenuItemDragonSkill:createWithIcon(0, 0)
		:setEnableAction(false)
		:setPosition(vec_pos[i])
		btn:setTag(i)

        btn:registerScriptTapHandler(handler(self, self.onBackpackIcon))
		self.layer.menu_selected:addChild(btn)

		btn:setLock(i > skill_num)
	end

	-- 初始数据
	self.vec_selected = {{item_type = 0, is_lock = true}, 
						 {item_type = 0, is_lock = true}, 
						 {item_type = 0, is_lock = true}, 
						 {item_type = 0, is_lock = true}}
	for i,v in ipairs(vec_wear) do
		if v.pos > 0 then
			local hallows_data = v

			self.vec_selected[hallows_data.pos].is_lock = v.pos > skill_num
			if hallows_data ~= nil then
				self.vec_selected[hallows_data.pos].item_type = hallows_data.item_type
			end
		end
	end

	-- 更新界面
    self:updateLayer()
end

function DragonSkillCtr:updateLayer()
	self:updateSelectSkill()
	self:updateBackpack()
end

function DragonSkillCtr:onBackpackIcon(tag, pSender)
	self.vec_selected[tag] = {item_type = 0, is_lock = false}

	self:updateSelectSkill()
	self:updateBackpack()
end

function DragonSkillCtr:exchangeCallback(item_touch, item_exchange)
	if item_touch:isEnabled() == false or item_exchange:isEnabled() == false then
		self:updateSelectSkillPos()
		return
	end

    local exchange_tag = item_exchange:getTag()
    local touch_tag = item_touch:getTag()

    -- 交换tag
    item_exchange:setTag(item_touch:getTag())
    item_touch:setTag(exchange_tag)

    -- 交换id
    local tmp_data = self.vec_selected[exchange_tag]
    self.vec_selected[exchange_tag] = self.vec_selected[touch_tag]
    self.vec_selected[touch_tag] = tmp_data
    
    return true
end

-- 刷新背包圣物显示
function DragonSkillCtr:updateBackpack()
	local vec_show = {}

	for i,v in ipairs(ex.Player.dragon_data.vec_hallows) do
		if v.item_type > 0 then
			table.insert(vec_show, v)
		end
	end

	local vec_item = ex.Player.backpack_data:getItemsByPageSign(ItemData.IT_HALLOWS)
	for i,v in ipairs(vec_item) do
		local is_have = TableEx.findValueFunction(vec_show, function(value)
			return v.item_type == value.item_type
		end)

		if is_have == nil then
			table.insert(vec_show, v)
		end
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
	self.layer.scroll_view:reloadData(vec_show)

    self.layer.scroll_view.menu:setLuaModel(true)
    self.layer.scroll_view.menu:enableLongPress(true)
    self.layer.scroll_view.menu:setLongPressCallback(handler(self, self.longTouch))
end

function DragonSkillCtr:longTouch(tag, pSender)
    if pSender.item_type == nil or pSender.item_type <= 0 then
        return
	end
	
	local info_ctr = require("src.layer.dragon.HallowsInfoCtr"):instance()
	info_ctr:openWindow()
	info_ctr:addDataInfo(pSender.item_type)
end

function DragonSkillCtr:updateSelectSkill()
	local vec_children = self.layer.menu_selected:getChildren()
	for i,v in ipairs(vec_children) do
		local data = self.vec_selected[v:getTag()]
		if data ~= nil and data.is_lock == false then
			local config_relic = cfg.dragonrelic.dragonrelic[data.item_type]

			v:setLocalZOrder(0)
			if config_relic == nil then
				v:setIcon(0)
				v:setLevel(0)
			else
				v:setIcon(config_relic.skill)
				v:setLevel(config_relic.star)
			end
		end
	end
end

function DragonSkillCtr:updateSelectSkillPos()
	local vec_children = self.layer.menu_selected:getChildren()
	for i,v in ipairs(vec_children) do
		local data = self.vec_selected[v:getTag()]
		v:setLocalZOrder(0)
		if data ~= nil then
			v:setPosition(vec_pos[v:getTag()])
		end
	end
end

-- 背包圣物被选中回调
function DragonSkillCtr:onItemSelect(tag, pSender)
	local item_type = pSender.item_type
	if item_type == nil or item_type <= 0 then
		return
	end

	if pSender.item:isSelected() then
		-- 卸下
		for i,v in ipairs(self.vec_selected) do
			if v.item_type == item_type then
				v.item_type = 0
				self:updateSelectSkill()
				pSender.item:setSelected(false)
				return
			end
		end
	else
		local config_relic = cfg.dragonrelic.dragonrelic[item_type]
		-- 检查是否有同类型圣物已装载
		for i,v in ipairs(self.vec_selected) do
			if v.is_lock == false then
				local tmp_config = cfg.dragonrelic.dragonrelic[v.item_type]
				if tmp_config ~= nil and tmp_config.kind == config_relic.kind then
					ex.MessageView:add(ex.Tools:getLang(74559))
					return
				end
			end
		end

		-- 装载
		for i,v in ipairs(self.vec_selected) do
			if v.is_lock == false and v.item_type <= 0 then
				v.item_type = item_type
				self:updateSelectSkill()
				pSender.item:setSelected(true)
				return
			end
		end

		ex.MessageView:add(ex.Tools:getLang(74560))
	end
end

function DragonSkillCtr:onConfirm(tag, pSender)
	local req = Dragon_pb.GReqDragonChangeSort()
	for i=1, #self.vec_selected do
		if self.vec_selected[i].is_lock == false then
			local data = req.slots:add()
			data.id = i
			data.sys_id = self.vec_selected[i].item_type
		end
	end
	NetManager:sendMessage(ProtocolID.GReqDragonChangeSort, req)

	self:closeWindow()
end

return DragonSkillCtr