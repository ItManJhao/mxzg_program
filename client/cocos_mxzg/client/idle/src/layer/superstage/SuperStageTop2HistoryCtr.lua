local SuperStageTop2HistoryCtr = class("SuperStageTop2HistoryCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SuperStageTop2HistoryLayer = class("SuperStageTop2HistoryLayer", require("src.comp.EventLayerAdaptiveWidth"))

function SuperStageTop2HistoryLayer:onCreate()
    self:addBlackBackground()
    
    local win_size = cc.Director:getInstance():getWinSize();
	local width = Maths.min(self:getContentSize().width, win_size.width);
    self:setScale(width / self:getContentSize().width);
    
    self.scroll_view:setItemSize(cc.size(540, 140))
    self.scroll_view:setItemType(1)
    self.scroll_view:setCreateNum(4)
end

-----------------------------------------------------------------------------
function SuperStageTop2HistoryCtr:onCreate()
	self:setCCBIPath("ccbi/SuperStageTop2HistoryLayer.ccbi")
	self:setIsSingle(false)
end

function SuperStageTop2HistoryCtr:getLayerClass()
	return SuperStageTop2HistoryLayer
end

function SuperStageTop2HistoryCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(data)
end

function SuperStageTop2HistoryCtr:initData(data)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer:addEvent(EVENT.MAIN_SCENE.CLOSE_LIST_VIEW, handler(self, self.closeWindow))
    self.layer:addEvent(data.event, handler(self, self.updateLayer))

    self.data = data

    self:updateLayer()
end

function SuperStageTop2HistoryCtr:updateLayer()
    self.layer.lbl_title:setString(self.data.title)

    local data = self.data.data_func()
    if data == nil then
        return
    end

    self.layer.scroll_view.createItemFunction = function(item_data, scale)
        local cell = self.data.class:createWithCCBIFile(self.data.file)
        cell:initData(item_data)
        return cell
    end

    self.layer.scroll_view:reloadData(data)
end

return SuperStageTop2HistoryCtr
