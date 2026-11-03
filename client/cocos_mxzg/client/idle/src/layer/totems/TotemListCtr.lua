local TotemListCtr = class("TotemListCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local TotemListLayer = class("TotemListLayer", require("src.comp.EventLayerAdaptiveWidth"))

--------------------------------------------

function TotemListLayer:onCreate()
    self:showBtnTitle()
    self:registerBtnEvent()
    self.btn_1:setChecked(true)
    self:addBlackBackground()

    local size = cc.size(540,600)--self.spr_panel_bg:getContentSize()
    self.data = ex.Player.hero_data.totems:getTotemsList()
    self.tableView_1 = ex.Tools:initTableView(self.spr_panel_bg,self.data.active, {require("src.layer.totems.TotemActiveCell"),"ccbi/TotemActiveCell.ccbi"} , size, 8,cc.p(11,5))
    self.tableView_2 = ex.Tools:initTableView(self.spr_panel_bg,self.data.not_active, {require("src.layer.totems.TotemNotActiveCell"),"ccbi/TotemNotActiveCell.ccbi"} , size, 8,cc.p(11,5))
    self:changeLayer(1)
    self.cur_tag = 1


    local lbl_get = cc.Label:createWithTTF(ex.Tools:getLang(76813), FONT_DEFAULT_NAME_BOLD, 24)
    lbl_get:setAnchorPoint(cc.p(0.5, 0.5))
    lbl_get:setTextColor(cc.c3b(255,255,255))
    lbl_get:enableOutline(cc.c3b(131,43,22),2)
    self.btn_get:addChild(lbl_get)
    lbl_get:setPosition(self.btn_get:getContentSize().width / 2,self.btn_get:getContentSize().height / 2)
    self.btn_get:registerScriptTapHandler(handler(self,self.onGoTo))
    self:addEvent(EVENT.TOTEM.UPDATA_EQUIP_INFO,handler(self,self.updateTable))
end

function TotemListLayer:onGoTo(tag,pSender)
    cfg.funcopen.main_exotic_adventure.open()
    local ctr = require("src.layer.totems.TotemInfoCtr"):instance()
    if ctr:isOpened() then 
        ctr:closeWindow()
    end
    TotemListCtr:instance():closeWindow()
end 

function TotemListLayer:updateTable(event,data)
    TotemListCtr:instance():closeWindow()
end

function TotemListLayer:showBtnTitle()
    self.btn_1:setLabelText(ex.Tools:getLang(76809))
    self.btn_2:setLabelText(ex.Tools:getLang(76810))
end

function TotemListLayer:registerBtnEvent( )
    for i=1,2 do
        local btn = self["btn_" .. i]
        btn:registerScriptTapHandler(handler(self,self.onChange))
    end
end

function TotemListLayer:onChange(tag,pSender)
    if tag == self.cur_tag then return end

    for i=1,2 do
        local btn = self["btn_" .. i]
        btn:setChecked(tag == btn:getTag())
    end
    self:changeLayer(tag)
end

function TotemListLayer:changeLayer(tag)
    print(self.__cname,tag)
    self.cur_tag = tag
    local data = ex.Player.hero_data.totems:getTotemsList()
    local table_data = tag == 1 and data.active or data.not_active
    for i=1,2 do
        local table_view = self["tableView_" .. i]
        table_view:setVisible(tag == i)
        if tag == i then 
            table_view:initData(table_data)
        end
    end
    self.lbl_max:setVisible(tag == 2 and ex.Player.hero_data.totems:hasAllTotems())
end

function TotemListLayer:onExit()
    print("TotemListLayer:onExit")

end

-----------------------------------------------------------------------------
function TotemListCtr:onCreate()
	self:setCCBIPath("ccbi/TotemListLayer.ccbi")
	self:setIsSingle(false)
end

function TotemListCtr:getLayerClass()
	return TotemListLayer
end

function TotemListCtr:getTotemListLayer()
	return self.layer
end

function TotemListCtr:openWindow(data)
	if self:isOpened() then
		return
    end
    
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/achievement.plist")
    sfc:addSpriteFrames("ccbi-res/box-effect.plist")
    
	self:loadLayer()
	self:open()
	self:initData(data)
end

function TotemListCtr:initData(data)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end

return TotemListCtr
