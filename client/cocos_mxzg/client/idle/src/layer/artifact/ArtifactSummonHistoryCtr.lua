local ArtifactSummonHistoryCtr = class("ArtifactSummonHistoryCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ArtifactSummonHistoryLayer = class("ArtifactSummonHistoryLayer", require("src.comp.EventLayerAdaptiveWidth"))

function ArtifactSummonHistoryLayer:onCreate()
    self:setAutoClose(true)
    self:addBlackBackground()
    
    local item_size = cc.size(560, 30)
    self.scroll_view_1.margin = 2.5
    self.scroll_view_1:setItemSize(item_size)

    local item_size = cc.size(560, 30)
    self.scroll_view_2.margin = 2.5
    self.scroll_view_2:setItemSize(item_size)
end

-----------------------------------------------------------------------------
function ArtifactSummonHistoryCtr:onCreate()
	self:setCCBIPath("ccbi/ArtifactSummonHistoryLayer.ccbi")
	self:setIsSingle(false)
end

function ArtifactSummonHistoryCtr:getLayerClass()
	return ArtifactSummonHistoryLayer
end

function ArtifactSummonHistoryCtr:getArtifactSummonHistoryLayer()
	return self.layer
end

function ArtifactSummonHistoryCtr:openWindow()
	if self:isOpened() then
		return
    end
    
	self:loadLayer()
	self:open()
	self:initData()
end

function ArtifactSummonHistoryCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self:updateLayer()
    
	NetManager:sendMessage(ProtocolID.GReqScanGodEquipRecord)
end

function ArtifactSummonHistoryCtr:updateLayer()
    self.layer.scroll_view_1:getContainer():removeAllChildren()
    self.layer.scroll_view_2:getContainer():removeAllChildren()

    local records_self = {}
    local nums_self = #ex.Player.god_equip_data.lottery_self_records
    for i=1,nums_self do
        table.insert(records_self, ex.Player.god_equip_data.lottery_self_records[nums_self - i + 1])
    end

    self.layer.scroll_view_1.createItemFunction = function(data)
        local lbl_history = require("src.comp.RichTextEx"):create()
        :setFontSize(40)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setFontColor("#7A472D")
        :setScale(0.5)
        :setAnchorPoint(0, 0.5)
        :setAnchorTextShadow(true)
        :setWrapMode(1)
        :setPosition(10, 10)

        local item_config = cfg.item.item[data.item_type]
        lbl_history:setXmlTextLua(string.format(ex.Tools:getLang(72360 + item_config.rare_mark), ex.Tools:getLang(item_config.name), data.item_num))
        lbl_history:formatText()

        local item = cpp.UIMenuItemImage:create()
        item:setEnableAction(false)
        item:setContentSize(cc.size(560, 30))
        item:addChild(lbl_history)
        
        return item
    end
    self.layer.scroll_view_1:reloadData(records_self)
    
    local records_server = {}
    local nums_server = #ex.Player.god_equip_data.lottery_server_records
    for i=1,nums_server do
        table.insert(records_server, ex.Player.god_equip_data.lottery_server_records[nums_server - i + 1])
    end

    self.layer.scroll_view_2.createItemFunction = function(data)
        local item = cpp.UIMenuItemImage:create()
        item:setEnableAction(false)
        item:setContentSize(cc.size(560, 30))

        local item_config = cfg.item.item[data.item_type]
        if item_config == nil then
            print(data.item_type, "is not exist ~")
            return item
        end
        
        local lbl_history = require("src.comp.RichTextEx"):create()
        :setFontSize(40)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setFontColor("#7A472D")
        :setScale(0.5)
        :setAnchorPoint(0, 0.5)
        :setAnchorTextShadow(true)
        :setWrapMode(1)
        :setPosition(10, 10)

        lbl_history:setXmlTextLua(string.format(ex.Tools:getLang(72370 + item_config.rare_mark), data.name, ex.Tools:getLang(item_config.name), data.item_num))
        lbl_history:formatText()
        
        item:addChild(lbl_history)
        
        return item
    end
    self.layer.scroll_view_2:reloadData(records_server)
end

return ArtifactSummonHistoryCtr