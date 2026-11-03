local RemainsSelectCtr = class("RemainsSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local RemainsSelectLayer = class("RemainsSelectLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function RemainsSelectLayer:onCreate()
    self:addBlackBackground()

    -- 遗物爆率提示
    self.lbl_tip = require("src.comp.RichTextEx"):create()
	:setFontSize(44)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#219A00")
    :setScale(0.5)
    :setAnchorPoint(0.5, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(320, 160)
    self:addChild(self.lbl_tip, 10001)
end

-----------------------------------------------------------------------------
function RemainsSelectCtr:onCreate()
    self:setCCBIPath("ccbi/RemainsSelectLayer.ccbi")
    
    self:setIsSingle(false)
end

function RemainsSelectCtr:getLayerClass()
	return RemainsSelectLayer
end

function RemainsSelectCtr:openWindow(room_type)
	if self:isOpened() then
		return
	end

    self.room_type = room_type

	self:loadLayer()
    self:open()
    self:initData()
end

function RemainsSelectCtr:initData()
    self.layer.btn_src:registerScriptTapHandler(handler(self, self.onItemSrc))
    self.layer.btn_identify:registerScriptTapHandler(handler(self, self.onIdentify))

    self.layer:addEvent(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM, handler(self, self.showIdentifyItem))
    self.layer:addEvent(EVENT.DRAGON_EVENT.REMAINS_BUY, handler(self, self.showIdentifyItem))
    
    self.select_idx = 0
    for k,v in pairs(cfg.dragonremains.dragonremains) do
        if v.type == 1 then
            if v.level > self.select_idx and ex.Player:getItemNum(v.cost[1].item_type) > 0 then
                self.select_idx = v.level
            end
        end
    end
    if self.select_idx <= 0 then
        for k,v in pairs(cfg.dragonremains.dragonremains) do
            if v.type == 1 and v.level > self.select_idx then
                self.select_idx = v.level
            end
        end
    end

    self:showIdentifyItem()
end

-- 显示加速物品列表
function RemainsSelectCtr:showIdentifyItem()
    self.layer.menu_item:removeAllChildren()

    local vec_item = {}
    for k,v in pairs(cfg.dragonremains.dragonremains) do
        if v.type == 1 then
            table.insert(vec_item, v)
        end
    end

    table.sort(vec_item, function(a, b)
        return a.level < b.level
    end)

    local item_num = #vec_item
    local vec_color = {}
    table.insert(vec_color, cc.c3b(4,149,196))
    table.insert(vec_color, cc.c3b(170,77,187))
    table.insert(vec_color, cc.c3b(229,143,27))
    for i,v in ipairs(vec_item) do
        local item = UIMenuItemBackpack:createWithData(v.cost[1].item_type, 1)
        item:setEnableAction(false)
        item:registerScriptTapHandler(handler(self, self.onItemSelect))
        item:setTag(v.level)
        item:setPosition((i - item_num / 2 - 0.5) * 160 + self.layer:getContentSize().width / 2, 300)
        self.layer.menu_item:addChild(item)

        item.data = v

        item.lbl_num:setString(ex.Player:getItemNum(v.cost[1].item_type).."/1")

        item.spr_select = cc.Sprite:createWithSpriteFrameName("backpack/spr-select-3.png")
        item.spr_select:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
        item:addChild(item.spr_select, 100)

        item.spr_select:setVisible(false)

        local spr_name = cc.Sprite:createWithSpriteFrameName("dragon-lang/spr-name-"..v.level..".png")
        spr_name:setPosition(item:getContentSize().width / 2, -30)
        item:addChild(spr_name, 10)
    end

    self:onItemSelect(self.select_idx)
end

-- 遗物选中响应
function RemainsSelectCtr:onItemSelect(tag, pSender)
    self.select_idx = tag

    self.layer.lbl_tip:setXmlTextLua(ex.Tools:getLang(74596 + self.select_idx))
    self.layer.lbl_tip:formatText()

    for k,v in pairs(cfg.dragonremains.dragonremains) do
        if v.type == 1 and v.level == self.select_idx then
            self.layer.btn_src.item_type = v.cost[1].item_type
        end
    end

    local vec_children = self.layer.menu_item:getChildren()
    for i,v in ipairs(vec_children) do
        if v.spr_select ~= nil then
            v.spr_select:setVisible(self.select_idx == v:getTag())
        end
    end
end

function RemainsSelectCtr:onItemSrc(tag, pSender)
    ex.Tools:onClickItemSrc(pSender.item_type)
end

-- 开始鉴定响应
function RemainsSelectCtr:onIdentify(tag, pSender)
    local data = nil
    for k,v in pairs(cfg.dragonremains.dragonremains) do
        if v.type == 1 and v.level == self.select_idx then
            data = v
            break
        end
    end
    if data == nil then
        return
    end

    if ex.Player:getItemNum(data.cost[1].item_type) <= 0 then
        -- ex.MessageView:add(ex.Tools:getLang(74568))
        ex.Tools:onClickItemSrc(data.cost[1].item_type)
        return
    end

    local room_data = ex.Player.dragon_data.vec_dragon_rooms[self.room_type]
    if room_data == nil then
        return
    end

    if room_data.level > 0 then
        ex.MessageView:add(ex.Tools:getLang(74569))
        return
    end

    local req = Dragon_pb.GReqDragonPutStone()
    req.type = self.room_type
    req.level = data.level
    NetManager:sendMessage(ProtocolID.GReqDragonPutStone, req)

	self:closeWindow()
end

return RemainsSelectCtr
