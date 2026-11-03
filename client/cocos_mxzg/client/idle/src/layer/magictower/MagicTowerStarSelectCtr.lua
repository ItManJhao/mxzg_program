local MagicTowerStarSelectCtr = class('MagicTowerStarSelectCtr', require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local MagicTowerStarSelectLayer = class('MagicTowerStarSelectLayer', require("src.layer.ui.UI_MagicTowerStarSelectLayer"))
local MagicTowerStarSelectCell = class("MagicTowerStarSelectCell", require("src.layer.ui.UI_MagicTowerStarSelectCell"))

function MagicTowerStarSelectCell:onCreate()
    self.super.onCreate(self)
	self:setName("MagicTowerStarSelectCell")

    self:setAnchorPoint(cc.p(0.5, 0.5))
    self:setIgnoreAnchorPointForPosition(false)
end

function MagicTowerStarSelectCell:resetData(stage)
    self.stage = stage

    self.lbl_name:setString(string.format(ex.Tools:getLang(57500), self.stage))
end

-----------------------------------------------------------------------------
function MagicTowerStarSelectLayer:onCreate()
	self.super.onCreate(self)
	self:setName("MagicTowerStarSelectLayer")

    self:addBlackBackground()

    self.btn_tab_1:setLabelText(string.format(ex.Tools:getLang(57530), 1))
    self.btn_tab_2:setLabelText(string.format(ex.Tools:getLang(57530), 2))

    self.scroll_view:setItemType(1)
    self.scroll_view.createItemFunction = function(data, scale)
		local item = MagicTowerStarSelectCell:create()
		item:resetData(data)
		return item
	end
    self.scroll_view.nodeTouched = handler(self, self.onGo)

    self.layer_type = -1
end

function MagicTowerStarSelectLayer:onTab(tag, pSender)
    if (self.layer_type == tag) then return end

    self.layer_type = tag

    self:updateLayer()
end

function MagicTowerStarSelectLayer:updateLayer()
    self.btn_tab_1:setChecked(self.layer_type == 1)
    self.btn_tab_2:setChecked(self.layer_type == 2)

    local magic_tower_data = ex.Player.magic_tower_data
    local data = magic_tower_data:getStageListByStar(self.layer_type)

    self.scroll_view:reloadData(data)

	self:resetLyt()
end

-- 前往
function MagicTowerStarSelectLayer:onGo(tag, pSender)
    ex.EventManager:fire(EVENT.MAGIC_TOWER_EVENT.STAGE_GOTO, pSender.stage)

    self:onClose()
end

-----------------------------------------------------------------------------
function MagicTowerStarSelectCtr:loadLayer()
	local tmp_layer = MagicTowerStarSelectLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function MagicTowerStarSelectCtr:openWindow()
    if self:isOpened() then
        return
    end
    
    self:loadLayer()
    self:open()
    self:initData()
end

function MagicTowerStarSelectCtr:initData()
    self.layer:onTab(1)
end

return MagicTowerStarSelectCtr
