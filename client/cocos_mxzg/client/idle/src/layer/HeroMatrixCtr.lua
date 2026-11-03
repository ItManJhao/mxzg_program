local HeroMatrixCtr = class("HeroMatrixCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroMatrixLayer = class("HeroMatrixLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenu = require("src.comp.menu.UIMenu")

local HeroMatrixCell = class("HeroMatrixCell", require("src.comp.LuaLayerBase"))
function HeroMatrixCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function HeroMatrixCell:initData(data)
    self.data = data

    -- self.spr_icon:setSpriteFrame("hero-select/spr-matrix-1-"..data.idx..".png")
    ex.Tools:setSpriteFrame(self.spr_icon, "hero-select/spr-matrix-1-"..data.idx..".png")
    
    self.node_limit:setVisible(data.unlock ~= true)
    if data.unlock ~= true then
        self.lbl_limit_tip:setString(ex.Tools:getLang(data.mission_name2))
    end

    self.lbl_name:setString(ex.Tools:getLang(data.name_lang))
    self.lbl_type:setString(ex.Tools:getLang(data.ability_lang))
end

function HeroMatrixCell:setCur(is_cur)
    self.spr_cur:setVisible(is_cur)
end

function HeroMatrixCell:setSelected(is_select)
    self.spr_select:setVisible(is_select)
end

-----------------------------------------------------------------------------
function HeroMatrixLayer:onCreate()
    self:setAutoClose(true)
    self:addBlackBackground()

    local scale_label = 0.5
    self.lbl_tip = require("src.comp.RichTextEx"):create()
	:setFontSize(40)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#5A3509")
    :setScale(scale_label)
    :setAnchorPoint(0.5, 0.5)
    :setWrapMode(1)
    :setPosition(self.btn_confirm:getPosition())
    self:addChild(self.lbl_tip, 10001)
    self.lbl_tip:setVisible(false)

    self.scroll_view:setItemSize(cc.size(100,140))
    self.scroll_view:setItemType(1)
end

-----------------------------------------------------------------------------
function HeroMatrixCtr:onCreate()
	self:setCCBIPath("ccbi/HeroMatrixLayer.ccbi")
	self:setIsSingle(false)
end

function HeroMatrixCtr:getLayerClass()
	return HeroMatrixLayer
end

function HeroMatrixCtr:openWindow(matrix_type, callback)
	if self:isOpened() then
		return
    end
    
    self.matrix_type = matrix_type
    self.callback = callback

	self:loadLayer()
	self:open()
	self:initData()
end

function HeroMatrixCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))

    self.layer:addEvent(EVENT.BATTLE_EVENT.QUERY_FORMATIONS, handler(self, self.updateMatrix))

    self.unlock_list = {}
    self.select_idx = self.matrix_type

    self.layer.scroll_view:getContainer():removeAllChildren()
    self.layer.scroll_view.nodeTouched = handler(self, self.onItemSelect)
    self.layer.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = HeroMatrixCell:createWithCCBIFile("ccbi/HeroMatrixCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data)

        cell:setCur(self.matrix_type == data.idx)
        cell:setSelected(self.select_idx == data.idx)
    
        return cell
    end

    self:updateMatrix()
    self:updateLayer()

    NetManager:sendMessage(ProtocolID.GReqQueryFormation)
end

function HeroMatrixCtr:updateMatrix(event, data)
    if data ~= nil then
        self.unlock_list = data.unlockIds
    end

    local item_list = {}
    for i,v in ipairs(cfg.battlematrix.battlematrix) do
        local data = clone(v)

        data.unlock = false
        for _,v2 in pairs(self.unlock_list) do
            if data.idx == v2 then
                data.unlock = true
                break
            end
        end

        table.insert(item_list, data)
    end

    self.layer.scroll_view:reloadData(item_list)
end

function HeroMatrixCtr:updateLayer()
    if self.layer.menu_matrix == nil then
        self.layer.menu_matrix = UIMenu:create()
        self.layer.menu_matrix:setPosition(cc.p(0, 0))
        self.layer.menu_matrix:setSwallowsTouches(false)
        self.layer.menu_matrix:setName("menu_matrix")
        self.layer.node_pannel:addChild(self.layer.menu_matrix)
    end

    self.layer.menu_matrix:removeAllChildren()

    local item_list = {}
    local config_addition = cfg.battlematrixaddition.battlematrixaddition
    for i,v in ipairs(config_addition) do
        if v.type == self.select_idx then
            table.insert(item_list, v)
        end
    end

    -- 显示锁状态及属性加成
    for i,v in ipairs(item_list) do
        if self.layer["spr_lock_"..v.position] ~= nil then
            self.layer["spr_lock_"..v.position]:setVisible(v.is_open <= 0)
            self.layer["lbl_attr_add_"..v.position]:setVisible(v.is_open > 0)

            if v.ability[1] ~= nil and v.ability[1].attr > 0 then
                self.layer["lbl_attr_add_"..v.position]:setString(ex.Tools:getLang(122000 + v.ability[1].attr).."+"..(v.ability[1].value / 100).."%")
            end
        end
    end

    -- 显示是否解锁状态
    local unlock = false
    if #self.unlock_list <= 0 then
        unlock = true
    else
        for _,v in pairs(self.unlock_list) do
            if self.select_idx == v then
                unlock = true
                break
            end
        end
    end

    local lock_tip = 0
    for i,v in ipairs(cfg.battlematrix.battlematrix) do
        if self.select_idx == v.idx then
            lock_tip = v.mission_name
            break
        end
    end
    
    self.layer.btn_confirm:setVisible(unlock)

    self.layer.lbl_tip:setVisible(not unlock)

    self.layer.lbl_tip:setXmlTextLua(ex.Tools:getLang(lock_tip))
    self.layer.lbl_tip:formatText()
end

function HeroMatrixCtr:onItemSelect(tag, node)
    self.select_idx = node.data.idx

    local vec_child = self.layer.scroll_view:getContainer():getChildren()[1]:getChildren()
    for i,v in ipairs(vec_child) do
        if v.data ~= nil then
            v:setSelected(v.data.idx == self.select_idx)
        end
    end

    self:updateLayer()
end

function HeroMatrixCtr:onConfirm(tag, pSender)
    self.callback(self.select_idx)

    self:closeWindow()
end

return HeroMatrixCtr
