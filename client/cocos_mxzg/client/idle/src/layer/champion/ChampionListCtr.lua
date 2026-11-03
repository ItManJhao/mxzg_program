local ChampionListCtr = class("ChampionListCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ChampionListLayer = class("ChampionListLayer", require("src.comp.EventLayer"))

function ChampionListLayer:onCreate()
    self:addBlackBackground()
    
    local win_size = cc.Director:getInstance():getWinSize();
	local width = Maths.min(self:getContentSize().width, win_size.width);
    self:setScale(width / self:getContentSize().width);
    
	local bet_ctr = ChampionListCtr:instance()
    self.btn_close:registerScriptTapHandler(handler(bet_ctr, bet_ctr.closeWindow))

    self.scroll_view:setItemSize(cc.size(540, 140))
    self.scroll_view:setItemType(1)
    self.scroll_view:setCreateNum(4)


    self:addEvent(EVENT.CHAMPION_EVENT.CLOSE_LIST_VIEW, handler(self, self.closeWindow))
    -- self:updateLayer()
end

function ChampionListLayer:closeWindow()
    ChampionListCtr:instance():closeWindow()
end

function ChampionListLayer:updateLayer()
    local data = self.data.data_func()
    if data == nil then
        return
    end

    self.scroll_view.createItemFunction = function(item_data, scale)
        local cell = self.data.class:createWithCCBIFile(self.data.file)
        cell:initData(item_data)
        return cell
    end

    self.scroll_view:reloadData(data)
end

-----------------------------------------------------------------------------
function ChampionListCtr:onCreate()
	self:setCCBIPath("ccbi/ChampionListLayer.ccbi")
	self:setIsSingle(false)
end

function ChampionListCtr:getLayerClass()
	return ChampionListLayer
end

function ChampionListCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(data)
end

function ChampionListCtr:initData(data)
    self.layer.data = data
    self.layer:addEvent(data.event, handler(self.layer, self.layer.updateLayer))
    self.layer:updateLayer()
    self.layer.lbl_title:setString(data.title)
end

return ChampionListCtr
