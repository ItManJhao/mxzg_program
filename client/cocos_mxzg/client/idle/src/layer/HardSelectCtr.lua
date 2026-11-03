local HardSelectCtr = class("HardSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HardSelectLayer = class("HardSelectLayer", require("src.comp.EventLayerAdaptiveWidth"))
local HardSelectCell = class("HardSelectCell", require("src.comp.LuaLayerBase"))

function HardSelectCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
end

function HardSelectCell:initData(data)
	if not data then 
		self:setVisible(false)
		return 
	end
    
    -- self.spr_cell_bg:setSpriteFrame("trial-lang/spr-level-"..data.idx..".png")
    ex.Tools:setSpriteFrame(self.spr_cell_bg, "trial-lang/spr-level-"..data.idx..".png")

    self.node_limit:setVisible(not data.is_unlock)
    self.btn_confirm:setVisible(data.is_unlock)
    self.btn_confirm.hard_idx = data.idx
    if not data.is_unlock then
        self.lbl_tip:setString(ex.Tools:getLang(41246 + data.idx))
        self.lbl_combat_num:setString(data.bat)
    end

    local scale = 0.75
    local margin = 5
    local pos_start = cc.p(190, 25)
    table.sort(data.reward, function(a, b)
        return a.item_type < b.item_type
    end)
    for i,v in ipairs(data.reward) do
        local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        local item_size = item:getContentSize()
        
        item:setAnchorPoint(ex.a.left_center)
        item:setPosition(pos_start.x + (i - 1) * (item_size.width * scale + margin), pos_start.y + item_size.height * scale / 2)
        item:setScale(scale)
        -- item:setAllGray(not isEnabled)
        item:registerScriptTapHandler(handler(self, self.onClickItem))
        self.menu_reward:addChild(item)
    end
end

function HardSelectCell:onClickItem(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type, pSender.item_num)
end

function HardSelectLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()

    self.lbl_tip:setString(ex.Tools:getLang(41251))
end

-----------------------------------------------------------------------------
function HardSelectCtr:onCreate()
    self:setCCBIPath("ccbi/HardSelectLayer.ccbi")
    self:setIsSingle(false)
end

function HardSelectCtr:getLayerClass()
    return HardSelectLayer
end

function HardSelectCtr:getHardSelectLayer()
    return self.layer
end

function HardSelectCtr:openWindow(vec_hard_cell, callback)
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/trial.plist")

    self.vec_hard_cell = vec_hard_cell
    self.callback = callback

    self:loadLayer()
    self:open()
    self:initData()
end

function HardSelectCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    local cell_count = table.nums(self.vec_hard_cell)
    for i,v in ipairs(self.vec_hard_cell) do
        local cell = HardSelectCell:createWithCCBIFile("ccbi/HardSelectCell.ccbi")
        cell.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
        cell:initData(v)
        cell:setPosition(cc.p(3, (cell_count - i) * 200))
        self.layer.scroll_view:addChild(cell)
    end

    self.layer.scroll_view:setContentSize(cc.size(self.layer.scroll_view:getViewSize().width, cell_count * 200))
    -- self.layer.scroll_view:setContentOffset(cc.p(0, cell_count * 200 + self.layer.scroll_view:getViewSize().height))
end

function HardSelectCtr:onConfirm(tag, pSender)
    local hard_idx = pSender.hard_idx

    if self.callback ~= nil then
        self.callback(hard_idx)
    end

    self:closeWindow(0, nil)
end

return HardSelectCtr
