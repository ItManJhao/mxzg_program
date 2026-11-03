local MagicCubeSelectHeroCtr = class("MagicCubeSelectHeroCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local MagicCubeSelectHeroLayer = class("MagicCubeSelectHeroLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

--------------------------------------------

function MagicCubeSelectHeroLayer:onCreate()
    self.viewSize = self.scroll_view:getViewSize()
    self:addBlackBackground()
    self:registerBtnEvent()
end

function MagicCubeSelectHeroLayer:registerBtnEvent()
    self.btn_elem_select = require("src.layer.HeroElemSelect"):new()
    for i=0,5 do
       local btn = self["btn_elem"..i] 
        btn:setTag(i)
        btn:registerScriptTapHandler(handler(self, self.onElem))

        self.btn_elem_select:bindSelect(btn)
    end

    self.btn_elem_select:setSelected(0)
    self.tag = 0

    self.btn_close:registerScriptTapHandler(handler(self,self.onClose))
    self.btn_cannel:registerScriptTapHandler(handler(self,self.onClose))
    self.btn_enter:registerScriptTapHandler(handler(self,self.onCommit))
end

function MagicCubeSelectHeroLayer:onCommit(tag,pSender)
    if self.selected then
        print(self.__cname,"send proto ")
        if self.callback then 
            self.callback(self.selected.data.hero_id)
        end 
    end
    MagicCubeSelectHeroCtr:instance():closeWindow()
end

function MagicCubeSelectHeroLayer:onClose(tag,pSender)
    MagicCubeSelectHeroCtr:instance():closeWindow()
end

function MagicCubeSelectHeroLayer:updateScrollView(data)
    local scroll_view = self.scroll_view
    scroll_view:getContainer():removeAllChildren()
    self.selected = nil 

	self.menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    scroll_view:getContainer():addChild(self.menu)
    local height 
    --local data = ex.Player.hero_data.magicCube:getSelectList()
    local scale = 1
    local row_num = 4
    for i=#data,1,-1 do
        local item = UIMenuItemHero:createWithData()
        item:reset(data[i])
        self.menu:addChild(item)
        local save_cell_props = item:getContentSize()
        item:setTag(i)
        item.data = data[i]

        if not height then 
            height = math.ceil((#data / row_num)) * (save_cell_props.height * scale+10) + (10 * scale) 
        end
        local idx = (i - 1) % row_num
        local posX = (save_cell_props.width + 25) * scale * (idx) + 24 + save_cell_props.width / 2 * scale
        local posY = height - (math.ceil(i / row_num)) * scale * (save_cell_props.height + 10) + save_cell_props.height / 2 * scale
        --item:setAnchorPoint(0,0)
        item:setPosition(posX,posY)
        item:setScale(scale)
        item:registerScriptTapHandler(handler(self,self.onItem))

        cell_content = item:getContentSize()

    end


    local size = cc.size(self.viewSize.width,height)
    scroll_view:setContentSize(size)
    scroll_view:setContentOffset(cc.p(0,self.viewSize.height - (height or 0))) 
end

function MagicCubeSelectHeroLayer:onElem(tag,pSender)
    if tag == self.tag then return end 
    self.btn_elem_select:setSelected(tag)
    self.tag = tag
    local data = {}
    if tag ~= 0 then 
        for i,v in ipairs(self.hero_list) do
            if v.elem == tag then 
                table.insert(data,v)
            end 
        end
    else 
        data = self.hero_list 
    end

    self:updateScrollView(data)
end

function MagicCubeSelectHeroLayer:onItem(tag,pSender)
    print(self.__cname,tag)
    --if self.selected ~= nil and pSender ~= self.selected then 
        --return 
    --end 

    if pSender == self.selected then 
        pSender:setSelected(false)
        self.selected = nil
        return 
    end 
    local childrens = self.menu:getChildren()
    for i,v in ipairs(childrens) do
        v:setSelected(false)
    end

    pSender:setSelected(true)
    self.selected = pSender
end


-----------------------------------------------------------------------------
function MagicCubeSelectHeroCtr:onCreate()
	self:setCCBIPath("ccbi/MagicCubeSelectHeroLayer.ccbi")
	self:setIsSingle(false)
end

function MagicCubeSelectHeroCtr:getLayerClass()
	return MagicCubeSelectHeroLayer
end

function MagicCubeSelectHeroCtr:getMagicCubeSelectHeroLayer()
	return self.layer
end

function MagicCubeSelectHeroCtr:openWindow(data,callback)
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    -- sfc:addSpriteFrames("ccbi-res/achievement.plist")
    -- sfc:addSpriteFrames("ccbi-res/box-effect.plist")
    --sfc:addSpriteFrames("ccbi-res/runes.plist")

	self:loadLayer()
    self:open()
    self.layer.hero_list = data 
    self.layer.callback = callback
    self.layer:updateScrollView(data)
end

return MagicCubeSelectHeroCtr
