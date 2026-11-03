local MagicCubeDisboardCtr = class("MagicCubeDisboardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local MagicCubeDisboardLayer = class("MagicCubeDisboardLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

--------------------------------------------

function MagicCubeDisboardLayer:onCreate()
    self:addBlackBackground()
    self:registerBtnEvent()
    self:createItem()
    self:createRich()
end

function MagicCubeDisboardLayer:updateView(data)
   self:updateItems(data)
end

function MagicCubeDisboardLayer:createRich()
    self.rich_text = cpp.RichTextEx:createWithXMLLua("")
    :setFontSize(24)
    :setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setFontColor("#7A472D")
    :setAnchorTextShadow(true)
    :ignoreContentAdaptWithSize(true)
    :setWrapMode(1)
    --:setContentSize(400, 48)
    :setAnchorPoint(ex.a.top_center)
    :setName("lbl_count_left")
    self.node_rich:addChild(self.rich_text)
    self.rich_text:setPosition(0,0)
    local str = ex.Tools:getLang(77311)
    self.rich_text:setXmlTextLua(str)

    
    local d,h,m,s = ex.Tools:formatTime(cfg.system.tweak_cube_trench_cd)
    str = string.format(ex.Tools:getLang(77312),24,0,0)


    self.rich_text1 = cpp.RichTextEx:createWithXMLLua("")
    :setFontSize(24)
    :setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setFontColor("#7A472D")
    :setAnchorTextShadow(true)
    :ignoreContentAdaptWithSize(true)
    :setWrapMode(1)
    --:setContentSize(400, 48)
    :setAnchorPoint(ex.a.top_center)
    :setName("lbl_count_left")
    self.node_rich1:addChild(self.rich_text1)
    self.rich_text1:setPosition(0,0)
    self.rich_text1:setXmlTextLua(str)
end

function MagicCubeDisboardLayer:createItem()
    for i=1,2 do
        local item = UIMenuItemHero:createWithData()
        self.menu:addChild(item)
        local x,y = self["item_node_" .. i]:getPosition()
        item:setPosition(cc.p(x,y))
        self["item_" .. i] = item
    end
end

function MagicCubeDisboardLayer:updateItems(data)
    local cube_hero = clone(data)
    cube_hero.level = cube_hero.tweak_cube_lv 
    local hero_data = clone(data)
    self.item_1:reset(cube_hero)
    self.item_2:reset(hero_data)
    self.item_2:setLevel(hero_data.level,true)
    print(data,cube_hero,hero_data)
end

function MagicCubeDisboardLayer:registerBtnEvent()

    self.btn_close:registerScriptTapHandler(handler(self,self.onClose))
    self.btn_cannel:registerScriptTapHandler(handler(self,self.onClose))
    self.btn_enter:registerScriptTapHandler(handler(self,self.onCommit))
end

function MagicCubeDisboardLayer:onCommit(tag,pSender)
    if self.callback then 
        self.callback()
    end 
    MagicCubeDisboardCtr:instance():closeWindow()
end

function MagicCubeDisboardLayer:onClose(tag,pSender)
    MagicCubeDisboardCtr:instance():closeWindow()
end

-----------------------------------------------------------------------------
function MagicCubeDisboardCtr:onCreate()
	self:setCCBIPath("ccbi/MagicCubeDisboardLayer.ccbi")
	self:setIsSingle(false)
end

function MagicCubeDisboardCtr:getLayerClass()
	return MagicCubeDisboardLayer
end

function MagicCubeDisboardCtr:getMagicCubeDisboardLayer()
	return self.layer
end

function MagicCubeDisboardCtr:openWindow(data,callback)
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    -- sfc:addSpriteFrames("ccbi-res/achievement.plist")
    -- sfc:addSpriteFrames("ccbi-res/box-effect.plist")
    --sfc:addSpriteFrames("ccbi-res/runes.plist")

	self:loadLayer()
    self:open()
    self.layer.callback = callback
    self.layer:updateView(data)
end

return MagicCubeDisboardCtr
