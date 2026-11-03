local PopupMenuCtr = class("PopupMenuCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PopupMenuLayer = class("FriendCtr", require("src.comp.EventLayer"))

function PopupMenuLayer:onCreate()
    self.menu = cpp.UIMenu:create()
    self.menu:setSwallowsTouches(false)
    self:addChild(self.menu)
    self.menu:setPosition(0,0)
end

function PopupMenuLayer:initView(data)
    self.menu:removeAllChildren()

    local btn_size = cc.Size(205,40)
    local frame_size = cc.Size(self:getContentSize().width , 70 + btn_size.height * table.nums(data))

    local begin_y = frame_size.height - 52 - btn_size.height * 0.5
    for i,v in ipairs(data) do
        local spr_normal = cc.Scale9Sprite:createWithSpriteFrameName("CommonShandow1.png",cc.Rect(12,12,1,1))
        spr_normal:setContentSize(btn_size - cc.Size(0,5))

        local spr_selected = cc.Scale9Sprite:createWithSpriteFrameName("CommonShandow1.png",cc.Rect(12,12,1,1))
        spr_selected:setContentSize(btn_size - cc.Size(0,5))

        local btn = cpp.UIMenuItemImage:create()
        btn:setNormalImage(spr_normal)
        btn:setSelectedImage(spr_selected)
        btn:setCallback(v.call_back)
        btn:setEnableAction(false)
        btn:setTag(i)
        btn:setPosition(frame_size.width * 0.5, begin_y - button_size.height * i)
        menu:addChild(button)

        local lbl_text = cc.Label.createWithTTF(v.title,FONT_DEFAULT_NAME_BOLD,45)
        lbl_text:setScale(0.5)
        lbl_text:setTextColor(Color4B(255, 227, 180, 255))
        lbl_text:setAnchorPoint(cc.p(0,0.5))
        lbl_text:setPosition(7, btn:getContentSize().height * 0.5 - 2)
        button:addChild(lbl_text)
    end
    self:setContentSize(frame_size)
    self.spr_bg:setContentSize(frame_size)
    self.spr_photo:setPositionY(frame_size.height - 24)
    self.lbl_name:setPositionY(frame_size.height - 30)
    self.spr_line:setPositionY(self.lbl_name:getPositionY() - 20)
    
end
---------------------------------

function PopupMenuCtr:onCreate()
    self:setCCBIPath("ccbi/PopupMenuLayer.ccbi")
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/dungeon.plist")
    self:setIsSingle(false)
end

function PopupMenuCtr:getLayerClass()
    return PopupMenuLayer
end

function PopupMenuCtr:getLayer()
    return self.layer
end

function PopupMenuCtr:openWindow(pos,photo,name,data)
    if self:isOpened() then
        return
    end
    self:loadLayer()
    self:open()
    self:initView(pos,photo,name,data)
    -- return self
end

function PopupMenuCtr:initView(pos,photo,name,data)
    -- body
    local layer = self.layer
    layer.spr_photo:setSpriteFrame(string.format("head-icon/%d.png", photo))
    layer.lbl_name:setString(name)
    layer:initView(data)
    pos.y = pos.y - layer:getContentSize().height

    local win_size = cc.Director:getInstance():getWinSize()

    local x = cc.clampf(pos.x, 0, win_size.width - layer:getContentSize().width);
    local y = cc.clampf(pos.y, 0, win_size.height - layer:getContentSize().height);
    layer:setPosition(x,y)
end

return PopupMenuCtr