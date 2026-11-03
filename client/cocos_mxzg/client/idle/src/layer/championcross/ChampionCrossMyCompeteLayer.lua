local ChampionMyCompeteLayer = class("ChampionCrossMyCompeteLayer", require("src.comp.EventLayer"))

function ChampionMyCompeteLayer:onCreate()
    self.lbl_content = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FEDFAA")
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	:setContentSize(cc.size(200, 100))
	:setPosition(cc.p(0, -107))
	:setAnchorPoint(ex.a.top_center)
    self.node:addChild(self.lbl_content)
end

function ChampionMyCompeteLayer:updateLayer()
    
end

function ChampionMyCompeteLayer:reset(type, data)

end


function ChampionMyCompeteLayer:onLineup()
    self:getParent():onLineup()
end


return ChampionMyCompeteLayer