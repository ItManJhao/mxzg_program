local FloatingIslandsDamageCtr = class("FloatingIslandsDamageCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local FloatingIslandsDamageLayer = class("FloatingIslandsDamageLayer", require("src.comp.EventLayerAdaptiveWidth"))

function FloatingIslandsDamageLayer:onCreate()
    self:addBlackBackground()  
    
    local win_size = cc.Director:getInstance():getWinSize();
	local width = Maths.min(self:getContentSize().width, win_size.width);
    self:setScale(width / self:getContentSize().width);
    
	local bet_ctr = FloatingIslandsDamageCtr:instance()
    self.btn_close:registerScriptTapHandler(handler(bet_ctr, bet_ctr.closeWindow))

    self.scroll_view:setItemType(1)
    self.scroll_view:setCreateNum(4)
    
    self:addEvent(EVENT.RANK_EVENT.CLOSE_SINGLE_VIEW, handler(self, self.closeWindow))
    -- self:updateLayer()
end

function FloatingIslandsDamageLayer:closeWindow()
    FloatingIslandsDamageCtr:instance():closeWindow()
end

function FloatingIslandsDamageLayer:updateLayer()
    local data = self.data.data_func()
    if data == nil then
        return
    end
    local cell = self.data.class:createWithCCBIFile(self.data.file)
    self.scroll_view:setItemSize(cell:getContentSize())
    
    self.scroll_view.createItemFunction = function(item_data, scale, index)
        local cell = self.data.class:createWithCCBIFile(self.data.file)
        cell:reset(item_data, index)
        return cell
    end

    self.scroll_view:reloadData(data)
end

-----------------------------------------------------------------------------
function FloatingIslandsDamageCtr:onCreate()
	self:setCCBIPath("ccbi/FloatingIslandsDamageLayer.ccbi")
	self:setIsSingle(false)
end

function FloatingIslandsDamageCtr:getLayerClass()
	return FloatingIslandsDamageLayer
end

function FloatingIslandsDamageCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(data)
end

function FloatingIslandsDamageCtr:initData(data)
    self.layer.data = data

    if data.event ~= nil and data.event ~= "" then
        self.layer:addEvent(data.event, handler(self.layer, self.layer.updateLayer))
    end
    self.layer:updateLayer()
    self.layer.lbl_title:setString(data.title)

    self.layer.lbl_tip1:setVisible(data.tip ~= nil)
    if data.tip ~= nil then
        self.layer.lbl_tip1:setString(data.tip)
    end
end

return FloatingIslandsDamageCtr
