local CountryWarLogCtr = class("CountryWarLogCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CountryWarLogLayer = class("CountryWarLogLayer", require("src.comp.EventLayerAdaptiveWidth"))
local CountryWarLogCell = class("CountryWarLogCell", require("src.comp.LuaLayerBase"))

local LAYER_TYPE = {
    WAR_LOG= 1,                     -- 战场日志
    MY_LOG = 2,             -- 我的日志  
}
function CountryWarLogCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

end

function CountryWarLogCell:initData(data)
    local lang_tab = 
    {
        string.format(ex.Tools:getLang(55801), ex.StringUtil.getServerName(tonumber(data.param[1])), ex.StringUtil.getServerName(tonumber(data.param[2]))),
        string.format(ex.Tools:getLang(55802), ex.StringUtil.getServerName(tonumber(data.param[1])), data.param[2]),
        ex.Tools:getLang(55803),
        string.format(ex.Tools:getLang(55804), ex.StringUtil.getServerName(tonumber(data.param[1])), data.param[2], ex.StringUtil.getServerName(tonumber(data.param[3])), data.param[4]),
        string.format(ex.Tools:getLang(55805), ex.StringUtil.getServerName(tonumber(data.param[1])), data.param[2], data.param[3],  ex.StringUtil.getServerName(tonumber(data.param[4])), data.param[5], data.param[6]),
        string.format(ex.Tools:getLang(55806), ex.StringUtil.getServerName(tonumber(data.param[1])), data.param[2]),
        string.format(ex.Tools:getLang(55807), ex.StringUtil.getServerName(tonumber(data.param[1])), data.param[2], data.param[3]),
        string.format(ex.Tools:getLang(55808), data.param[1], ex.StringUtil.getServerName(tonumber(data.param[2])), data.param[3], data.param[4]),
        string.format(ex.Tools:getLang(55809)),
    }

    self.lbl_time:setString(os.date("%Y-%m-%d %H:%M:%S", data.time))

    local lbl_desc = cpp.RichTextEx:createWithXMLLua("") 
    :setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#784008")
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	:setContentSize(cc.size(450, 0))
	:setPosition(cc.p(10, self:getContentSize().height * 0.5 + 35))
	:setAnchorPoint(ex.a.left_top)
    :setXmlTextLua(lang_tab[data.type])
    self:addChild(lbl_desc)
    
end
-------------------------------------------------------------------------------------------------------------
function CountryWarLogLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()
    self:initDone() 
    self:updateTableView()
end

function CountryWarLogLayer:initDone()
    self.btn_war_log:setLabelText(ex.Tools:getLang(55502))
    self.btn_my_log:setLabelText(ex.Tools:getLang(55503))
    ex.Tools:setLimitWidth(self.lbl_title, 150)
    ex.Tools:setLimitWidth(self.btn_war_log:getLabel(), 90)
    ex.Tools:setLimitWidth(self.btn_my_log:getLabel(), 90)
    self.cut_layer = 1     
    self.btn_war_log:setChecked(true)
    self.scroll_view:setItemSize(cc.size(470,170))
    self.scroll_view:setItemType(1)
end

function CountryWarLogLayer:onCheckLayer(tag)
    -- 1战场日志  ， 2我的日志
    if  self.cut_layer == tag then
        return
    end
    self.cut_layer = tag
    self:updateTableView()
end

function CountryWarLogLayer:updateTableView()
    local log_data = ctr.country_war.data:getLogData(self.cut_layer)
    local sort = function ( a,b )
        return a.time > b.time
    end
    table.sort(log_data, sort )
    self.scroll_view:getContainer():removeAllChildren()
    self.scroll_view.createItemFunction = function(data)
       local cell = CountryWarLogCell:createWithCCBIFile("ccbi/CountryWarLogCell.ccbi")
       cell:setIgnoreAnchorPointForPosition(false)
       cell:setAnchorPoint(0.5, 0.5)
       cell:initData(data, self.scroll_view)
       return cell
   end
   self.scroll_view:reloadData(log_data)

end

-----------------------------------------------------------------------------
function CountryWarLogCtr:onCreate()
    self:setCCBIPath("ccbi/CountryWarLogLayer.ccbi")
    self:setIsSingle(false)
end

function CountryWarLogCtr:getLayerClass()
    return CountryWarLogLayer
end

function CountryWarLogCtr:getClanRankLayer()
    return self.layer
end

function CountryWarLogCtr:openWindow(layer_type)
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData()
end

function CountryWarLogCtr:initData()
    self.layer.btn_continue:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end

return CountryWarLogCtr
