local ClanPhotoCtr = class("ClanPhotoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ClanPhotoLayer = class("ClanPhotoLayer", require("src.comp.LuaLayerBase"))

function ClanPhotoLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()

    self:reorderChild(self.menu_close, 20) 
end

-----------------------------------------------------------------------------
function ClanPhotoCtr:onCreate()
    self:setCCBIPath("ccbi/ClanPhotoLayer.ccbi")
    self:setIsSingle(false)
end

function ClanPhotoCtr:getLayerClass()
    return ClanPhotoLayer
end

function ClanPhotoCtr:getClanPhotoLayer()
    return self.layer
end

function ClanPhotoCtr:openWindow(layer_type)
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/clan.plist")
    sfc:addSpriteFrames("ccbi-res/clan-photo.plist")

    self.layer_type = layer_type

    self:loadLayer()
    self:open()
    self:initData()
end

function ClanPhotoCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    -- 英雄列表scroll_view
    self.layer.viewSize = self.layer.spr_bg:getContentSize()
    self.layer.viewSize.height = self.layer.viewSize.height - 4

    self.layer.scroll_view = cc.ScrollView:create(self.layer.viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(self.layer.spr_bg:getPositionX() - self.layer.spr_bg:getContentSize().width / 2, self.layer.spr_bg:getPositionY() - self.layer.spr_bg:getContentSize().height / 2 + 2)
    self.layer:addChild(self.layer.scroll_view)

    self.layer.menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(self.layer.scroll_view)
    :setSwallowsTouches(false)
    self.layer.menu:setPosition(0, 0)
    self.layer.scroll_view:addChild(self.layer.menu)

    for i=1,43 do
        local idx = 46 - i
        local str_photo = string.format("clan-photo/%02d.png", idx - 2)
        local item = cpp.UIMenuItemImage:createWithSpriteFrameName(str_photo, str_photo, str_photo)
        item:registerScriptTapHandler(handler(self, self.onPhotoSelect))
        item:setScale(0.75)
        item:setTag(idx - 2)
        local row = math.floor((idx - 1) % 5)
        local col = math.floor((idx - 1) / 5)
        item:setPosition(cc.p((4 - row) * 80 + 100, col * 80 + 40))
        self.layer.menu:addChild(item)
    end

    self.layer.scroll_view:setContentSize(cc.size(self.layer.scroll_view:getViewSize().width, 45 / 5 * 80))
    self.layer.scroll_view:setContentOffset(cc.p(0, -45 / 5 * 80 + self.layer.scroll_view:getViewSize().height))
end

function ClanPhotoCtr:onPhotoSelect(tag , pSender)
    self.photo_idx = tag

    self:onConfirm()
end

function ClanPhotoCtr:onConfirm()
    ex.Player.clan_data.clan_photo = self.photo_idx

    if ex.Player.clan_data.clan_id ~= 0 then
        local req_edit = Clan_pb.GReqClanChangInfo()
        req_edit.clan_photo = self.photo_idx 
        req_edit.clan_desc = ex.Player.clan_data.clan_notice
        NetManager:sendMessage(ProtocolID.GReqClanChangInfo, req_edit)

    	NetManager:sendMessage(ProtocolID.GReqClanInfo)

        ex.MessageView:add(ex.Tools:getLang(47223), 0)
    else
        -- 请求刷新公会创建显示
        ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_CREATE_UPDATE_PHOTO)
    end

    self:closeWindow(0, nil)
end

return ClanPhotoCtr
