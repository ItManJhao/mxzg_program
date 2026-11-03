local PopupMenuCtr = class("PopupMenuCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PopupMenuLayer = class("PopupMenuLayer", require("src.comp.EventLayer"))

function PopupMenuLayer:onCreate()
	print("PopupMenuLayer:onCreate")
	-- self:setAutoClose(false)
end

function PopupMenuLayer:initLayer(vec_data)
    local menu = cpp.UIMenu:create()
    :setSwallowsTouches(false)
    :setPosition(0, 0)
    self:addChild(menu);

    local button_size = cc.size(205, 40);
    local frame_size = cc.size(self:getContentSize().width, 70 + button_size.height * table.nums(vec_data));

    local begin_y = frame_size.height - 52 - button_size.height * 0.5;

    -- 生成按钮
    for i=1,table.nums(vec_data) do
        local data = vec_data[i];
        dump(data, "popmenu data info: ")
        -- print("popmenu data info: ", data[1], data[2])
        local spr_normal = ccui.Scale9Sprite:createWithSpriteFrameName("win-bg/block-bg-17.png", cc.rect(12, 12, 1, 1));
        spr_normal:setContentSize(cc.size(button_size.width, button_size.height - 5));
        
        local spr_selected = ccui.Scale9Sprite:createWithSpriteFrameName("win-bg/block-bg-17.png", cc.rect(12, 12, 1, 1));
        spr_selected:setContentSize(cc.size(button_size.width, button_size.height - 5));
        
        local callback = function(tag, pSender)
            pSender.data[2](tag, pSender)

            PopupMenuCtr:instance():closeWindow(1, nil)
        end 

        local button = cpp.UIMenuItemImage:create()
        button.data = data
        button:setNormalImage(spr_normal)
        button:setSelectedImage(spr_selected)
        button:registerScriptTapHandler(callback) 
        button:setEnableAction(false)
        button:setTag(i)
        button:setPosition(frame_size.width * 0.5, begin_y - button_size.height * (i - 1))
        menu:addChild(button)
        
        
        local lbl_text = cc.Label:createWithTTF(data[1], FONT_DEFAULT_NAME_BOLD, 45)
        lbl_text:setScale(0.5)
        lbl_text:setTextColor(cc.c4b(255,227,183,255))
        lbl_text:setAnchorPoint(cc.p(0, 0.5))
        lbl_text:setPosition(7, button:getContentSize().height * 0.5 - 2)
        button:addChild(lbl_text)
    end
    
    
    self:setContentSize(frame_size)
    self.spr_bg:setContentSize(frame_size)
    self.spr_photo:setPositionY(frame_size.height - 24)
    self.lbl_name:setPositionY(frame_size.height - 30)
    self.spr_line:setPositionY(self.lbl_name:getPositionY() - 20)
end

-----------------------------------------------------------------------------
function PopupMenuCtr:onCreate()
    self:setCCBIPath("ccbi/PopupMenuLayer.ccbi")
    self:setIsSingle(false)
end

function PopupMenuCtr:getLayerClass()
    return PopupMenuLayer
end

function PopupMenuCtr:getPopupMenuLayer()
    return self.layer
end

function PopupMenuCtr:openWindow(pos, photo, str_name, vec_data)
    if self:isOpened() then
        return
    end
    if table.nums(vec_data) <= 0 then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/photo.plist")

    self:loadLayer()
    self:open()
    self:initData(pos, photo, str_name, vec_data)
end

function PopupMenuCtr:initData(pos, photo, str_name, vec_data)
    self.layer:getParent():reorderChild(self.layer, 100)

    local sfc = cc.SpriteFrameCache:getInstance()
    local frame = sfc:getSpriteFrameByName(string.format("head-icon/%d.png", photo))
    if frame == nil then
        frame = sfc:getSpriteFrameByName("head-icon/0.png")
    end
    self.layer.spr_photo:setSpriteFrame(frame)
    self.layer.lbl_name:setString(str_name)
    self.layer:initLayer(vec_data)

    pos.y = pos.y - self.layer:getContentSize().height
    
    local x = cc.clampf(pos.x, 0, ex.p.width - self.layer:getContentSize().width)
    local y = cc.clampf(pos.y, 0, ex.p.height - self.layer:getContentSize().height)
    self.layer:setPosition(x, y);
end

return PopupMenuCtr
