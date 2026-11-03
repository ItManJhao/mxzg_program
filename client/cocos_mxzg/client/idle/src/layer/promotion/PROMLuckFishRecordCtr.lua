local PROMLuckFishRecordLayer = class("PROMLuckFishRecordLayer", require("src.comp.EventLayerAdaptiveWidthFull"))
local PROMLuckFishRecordCtr = class("PROMLuckFishRecordCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMLuckFishRecordCell = class("PROMLuckFishRecordCell",require("src.comp.EventLayer"))

function PROMLuckFishRecordCell:onCreate( )
    self.rich_text = cpp.RichTextEx:createWithXMLLua("")
    :setFontSize(20)
    :setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setFontColor("#5E3E16")
    :setScale(1)
    :setAnchorTextShadow(true)
    :ignoreContentAdaptWithSize(false)
    :setWrapMode(1)
    :setContentSize(484, 30)
    :setAnchorPoint(ex.a.left_center)
    self:addChild(self.rich_text)
    local x,y  = self.rich_node:getPosition()
    self.rich_text:setPosition(x,y)
end

function PROMLuckFishRecordCell:reset(data)
    -- local str = "fuck you !"
    local str = ex.Tools:getLang(3257)
    local cell_cfg = ex.Player.promotion_data.luck_fish_data:getCfg()
    local item_data = cell_cfg[data.idx].reward[1]
    local item_cfg = cfg.item.item[item_data.item_type]
    local item_name = ex.Tools:getLang(item_cfg.name) .. "x" .. item_data.item_num
    str = string.format(str,data.nick,item_name)
    self.rich_text:setXmlTextLua(str)
end

----------------------------------------------------------

function PROMLuckFishRecordLayer:onCreate()
    self:addBlackBackground()
    local bg_size = self.spr_bg:getContentSize()
    local data = {}
    self.tableView = ex.Tools:initTableView(self.spr_bg,data, {PROMLuckFishRecordCell,"ccbi/PROMLuckFishRecordCell.ccbi"} , cc.size(bg_size.width, bg_size.height - 35), 0, cc.p(2,4))
    self:addEvent(EVENT.LUCK_FISH.UPDATE_RECORD,handler(self,self.onRecordData))
    
    NetManager:sendMessage(ProtocolID.GReqBlessingInfo)
end

function PROMLuckFishRecordLayer:onRecordData(event,data)
    self.tableView:initData(data)
end



function PROMLuckFishRecordLayer:onClickInfo(tag,pSender)
	ex.Tools:showItemInfo(tag,pSender)
end

----------------------------------------------------------

function PROMLuckFishRecordCtr:onCreate()
    self:setCCBIPath("ccbi/PROMLuckFishRecordLayer.ccbi")
    
	self:setIsSingle(false)
end

function PROMLuckFishRecordCtr:getLayerClass()
	return PROMLuckFishRecordLayer
end

function PROMLuckFishRecordCtr:getLayer()
	return self.layer
end

function PROMLuckFishRecordCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(data)
end

function PROMLuckFishRecordCtr:initData(data)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end


return PROMLuckFishRecordCtr
