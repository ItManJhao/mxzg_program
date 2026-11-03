local RunesSelect2Ctr = class("RunesSelect2Ctr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local RunesSelect2Layer = class("RunesSelect2Layer", require("src.comp.EventLayerAdaptiveWidth"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
local UIMenu = require("src.comp.menu.UIMenu")

function RunesSelect2Layer:onCreate()
    self.select_max_num = 1
    self.select_num = 0
    self.vec_selected = {}
    self:addBlackBackground()


    local view_size = cc.size(self.spr_tableview_bg:getContentSize().width - 20, self.spr_tableview_bg:getContentSize().height - 10)
    local pos = cc.p(self.spr_tableview_bg:getPositionX() + 10, self.spr_tableview_bg:getPositionY() + 5)
    self.tableView = ex.Tools:initTableView(self, {}, {require("src.layer.runes.RunesSelect2Cell"), "ccbi/RunesSelect2Cell.ccbi"} , view_size, 7 , pos)

    self:addEvent(EVENT.RUNES_EVENT.SELECT_RUNES, handler(self,self.onSelectedRunes))
    self:addEvent(EVENT.RUNES_EVENT.REMOVE, handler(self, self.onRunesComposeDone))
end

function RunesSelect2Layer:onSelectedRunes(event, pSender, spr_select)
    local is_select = not spr_select:isVisible()

    local select_num = table.nums(self.vec_selected)

    local runes_data = ex.Player.backpack_data:getRunesById(pSender.item_id)
    if runes_data then
        local config = ex.Player.backpack_data:getCombineConfig(runes_data.item_type)
        if not config then
            ex.MessageView:add(ex.Tools:getLang(47115))
            return
        end
    end

    if is_select == true then
        if self.select_max_num - select_num <= 0  then
            ex.MessageView:add(ex.Tools:getLang(47773))
            return
        end

        select_num = select_num + 1
        table.insert(self.vec_selected, pSender.item_id)
    else
        select_num = select_num - 1
        TableEx.removeTableData(self.vec_selected, function(value)
            if value == pSender.item_id then
                return true
            end
        end)
    end

    self.lbl_num:setString(string.format(ex.Tools:getLang(47636), select_num, self.select_max_num))

    spr_select:setVisible(is_select)
    pSender.runes_data.setSelected = is_select
end

function RunesSelect2Layer:onRunesComposeDone(event, pSender)
    require("src.layer.runes.RunesSelect2Ctr"):instance():updateTableView()
end

-----------------------------------------------------------------------------
function RunesSelect2Ctr:onCreate()
	self:setCCBIPath("ccbi/RunesSelect2Layer.ccbi")
    self:setIsSingle(false)
    
end

function RunesSelect2Ctr:getLayerClass()
	return RunesSelect2Layer
end

function RunesSelect2Ctr:getHeroSelectLayer()
	return self.layer
end

function RunesSelect2Ctr:openWindow(vec_selected, callback, max_num, vec_excluded)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/runes.plist")

	self:loadLayer()
	self:open()
	self:initData(vec_selected, callback, max_num)
end

function RunesSelect2Ctr:initData(vec_selected, callback, max_num, vec_excluded)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    
    self.layer.btn_done:registerScriptTapHandler(handler(self, self.onConfirm))
    
    self.callback = callback
    self.layer.select_max_num = max_num
    self.layer.vec_selected = vec_selected or {}
    self.layer.vec_excluded = vec_excluded
	self:updateTableView()
end

function RunesSelect2Ctr:updateTableView()
    if not self:getLayer() then
        return
    end

    local layer = self.layer
    local vec_runes = clone(ex.Player.backpack_data:getRunesListNotWear())

    local item_count = table.nums(vec_runes)
    local view_size = layer.tableView:getViewSize()
    local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    item_size = cc.size(item_size.width + 10, item_size.height + 12)


    local margin = 10
    local heroLen = item_count
    local col = math.floor((view_size.width - margin * 2) / item_size.width) -- 列数
    local row = math.ceil(1.0 * heroLen / col) -- 行数
    local cont_height = item_size.height * row + margin * 2
    cont_height = math.max(cont_height , view_size.height)
    row = math.ceil((cont_height - margin * 2) / item_size.height) -- 总行数

    local index = 0
    local runes_data = {}
    for k,v in pairs(vec_runes) do
        local nowData = {}
        nowData.tag = 1
        nowData.col = col
        nowData.runes_data = v
        nowData.setSelected = false

        -- dump(v, "v")

        if TableEx.isInTable(layer.vec_selected, v.item_id) then
            nowData.setSelected = true
        end
        
        local x = index % col
        local y = math.floor(index / col) + 1

        if not runes_data[y] then 
            runes_data[y] = {}
        end 
        table.insert(runes_data[y] , nowData )

        index = index + 1
    end

    -- local bg_size = layer.tableView:getContentSize()
    layer.tableView:initData(runes_data)
    local offsetY = self.layer.tableView:getContainer():getPositionY()

    self.layer.lbl_num:setString(string.format(ex.Tools:getLang(47411), table.nums(layer.vec_selected or {}), self.layer.select_max_num))
end

function RunesSelect2Ctr:onConfirm(tag, pSender)
    if self.callback then
        self.callback(self.layer.vec_selected, table.nums(self.layer.vec_selected) > 0 and self.layer.vec_selected[1] or NULL_ID)
        self:closeWindow(0 , nil)
    end
end

return RunesSelect2Ctr
