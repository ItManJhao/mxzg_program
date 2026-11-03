local ListCtr = class("ListCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ListLayer = class("ListLayer", require("src.comp.EventLayer"))

function ListLayer:onCreate()
    self:addBlackBackground()
    
    local win_size = cc.Director:getInstance():getWinSize();
	local width = Maths.min(self:getContentSize().width, win_size.width);
    self:setScale(width / self:getContentSize().width);
    
    self.scroll_view:setItemSize(cc.size(540, 140))
    self.scroll_view:setItemType(1)
end

-----------------------------------------------------------------------------
function ListCtr:onCreate()
	self:setCCBIPath("ccbi/ListLayer.ccbi")
	self:setIsSingle(false)
end

function ListCtr:getLayerClass()
	return ListLayer
end

function ListCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(data)
end

function ListCtr:initData(data)
    self.layer:addEvent(EVENT.MAIN_SCENE.CLOSE_LIST_VIEW, handler(self, self.closeWindow))
    self.layer:addEvent(data.event, handler(self.layer, self.layer.updateLayer))

    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer.lbl_title:setString(data.title)
    
    self.data = data
    self:updateLayer()
end

function ListCtr:updateLayer()
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

return ListCtr
