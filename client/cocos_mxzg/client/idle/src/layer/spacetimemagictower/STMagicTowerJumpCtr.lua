local STMagicTowerJumpCtr = class("STMagicTowerJumpCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local STMagicTowerJumpLayer = class("STMagicTowerJumpLayer", require("src.comp.EventLayerAdaptiveWidth"))

function STMagicTowerJumpLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
end

function STMagicTowerJumpLayer:updateLayer(data)
    local lbl_comment = cpp.RichTextEx:createWithXMLLua("")
    :setFontSize(44)
    :setScale(0.5)
    :setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setFontColor("FFDF91")
    :setAnchorPoint(0.5, 0.5)
    :setAnchorTextShadow(true)
    :setWrapMode(1)
    :setPosition(self.spr_top_bg:getPositionX(),self.spr_top_bg:getPositionY())
    self:addChild(lbl_comment)
    
    local str = string.format(ex.Tools:getLang(75625), data.info.mission_id + 1)
    lbl_comment:setXmlTextLua(str)
    lbl_comment:formatText()

    local settle_data = data.settle_data
    if not settle_data or not settle_data.jump_reward or #settle_data.jump_reward == 0 then
        return
    end

    local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    item_size = cc.size(item_size.width + 35, item_size.height + 35)

    local viewSize = cc.size(ex.p.width, 270)
    
    local scroll_view = cc.ScrollView:create(viewSize):setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL):setPosition(0, 60)
    self:addChild(scroll_view)

    local menu = cpp.UIMenu:create()
    menu:setPosition(cc.p(0, 0))
    scroll_view:getContainer():addChild(menu)

    -- 求最大列数
    local col = math.min(4, #settle_data.jump_reward)
    local row = math.ceil(1.0 * #settle_data.jump_reward / col) -- 行数
    local cont_height = item_size.height * row
    cont_height = math.max(cont_height, viewSize.height)

    scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))

    cont_height = cont_height - item_size.height * 0.5
    if row == 1 then
        cont_height = cont_height - item_size.height * 0.5
    end

    local start = cc.p(viewSize.width * 0.5 - (item_size.width * col * 0.5), cont_height)
    start.x = start.x + item_size.width * 0.5

    local index = 0
    for _, v in pairs(settle_data.jump_reward) do
        local x = index % col
        local y = math.floor(index / col)

        local pos = cc.p(start.x + x * item_size.width, start.y - y * item_size.height)

        local node = ex.Tools:createBackpackItem(v.type, v.num)
        node:registerScriptTapHandler(handler(self, self.onItemInfo))
        menu:addChild(node)
        node:setPosition(pos)
        index = index + 1
    end
end

function STMagicTowerJumpLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function STMagicTowerJumpCtr:onCreate()
    self:setCCBIPath("ccbi/STMagicTowerJumpLayer.ccbi")
    self:setIsSingle(false)
end

function STMagicTowerJumpCtr:getLayerClass()
    return STMagicTowerJumpLayer
end

function STMagicTowerJumpCtr:openWindow(data)
    if self:isOpened() then
        return
    end

    self.data = data

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/time-tower-lang.plist")
    sfc:addSpriteFrames("ccbi-res/lang-1.plist")

    self:loadLayer()
    self:open()
    self:initData(data)
end

function STMagicTowerJumpCtr:closeWindow(params1, params2)
    self.super.closeWindow(self, params1, params2)
    ex.EventManager:fire(EVENT.SPACE_TIME_MAGIC_TOWER.JUMP_CLOSE)
end

function STMagicTowerJumpCtr:initData(data)
    local settle_data = data.settle_data
    if not settle_data or not settle_data.report then
        return
    end

    self.layer:updateLayer(data)
end

return STMagicTowerJumpCtr
