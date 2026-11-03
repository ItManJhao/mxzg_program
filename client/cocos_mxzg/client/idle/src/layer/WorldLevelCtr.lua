local WorldLevelCtr = class("WorldLevelCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local WorldLevelLayer = class("WorldLevelLayer", require("src.comp.EventLayer"))

function WorldLevelLayer:onCreate()
	local scale_label = 0.5
    self.lbl_content = require("src.comp.RichTextEx"):create()
        :setFontSize(36)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setFontColor("#FFE0B1")
        :setScale(scale_label)
        :setAnchorPoint(0, 1)
        :setAnchorTextShadow(true)
        :ignoreContentAdaptWithSize(false)
        :setWrapMode(1)
        :setPosition(25, 100)
        :setContentSize(cc.size(280 / scale_label, 0))
    self:addChild(self.lbl_content, 10000)
end

-----------------------------------------------------------------------------
function WorldLevelCtr:onCreate()
	self:setCCBIPath("ccbi/WorldLevelLayer.ccbi")
	self:setIsSingle(false)
end

function WorldLevelCtr:getLayerClass()
	return WorldLevelLayer
end

function WorldLevelCtr:openWindow(world_level)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(world_level)
end

function WorldLevelCtr:initData(world_level)
    self.layer.lbl_title:setString(ex.Tools:getLang(41225))

    self:updateLayer(world_level)

    if self.pos and self.interval_x then
        self:setPosition(self.pos, self.interval_x)
    end
end

function WorldLevelCtr:updateLayer(world_level)
    local str_content = string.format(ex.Tools:getLang(41226), ex.Tools:getSysCfg("world_level_people")).."\n"..string.format(ex.Tools:getLang(41227), tostring(world_level))
    
    local level = ex.Player.level or 1
    local minLvLimit = ex.Tools:getSysCfg("world_gain_level") or 1
    if level >= minLvLimit then
        local bonus = cfg.worldlevelgainexp.getBonusByLevelDisp(world_level - level)
        if bonus > 0 then
            str_content = str_content .. "<br />" .. string.format(ex.Tools:getLang(75107), bonus)
        end
    end
    
    self.layer.lbl_content:setXmlTextLua(str_content)
    self.layer.lbl_content:formatText()

end

function WorldLevelCtr:setPosition(pos, interval_x)
    self.pos = pos
    self.interval_x = interval_x
    if self.layer then
        self.layer:setPosition(pos.x - interval_x - self.layer:getContentSize().width, pos.y - self.layer:getContentSize().height)
    end
end

return WorldLevelCtr
