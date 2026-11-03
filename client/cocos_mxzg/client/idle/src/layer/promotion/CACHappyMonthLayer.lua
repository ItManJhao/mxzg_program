--[[
    func: 狂欢时刻
    author:徐东浩
    time:2019-10-25 16:21:15
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local CACHappyMonthLayer = class("CACHappyMonthLayer", require("src.layer.promotion.Common1ContentLayer"), require("src.layer.promotion.Common1BannerLayer"))


function CACHappyMonthLayer:createMenuWithItem()
    -- body
    self.item_menu = cpp.UIMenu:create()
    self.item_menu:setSwallowsTouches(false)
    self:addChild(self.item_menu)
    self.item_menu:setLocalZOrder(10)
    self.item_menu:setPosition(0,0)

    local begin = 24
    local margin = 5
    local posY = 55
    local scale = 0.75
    local index = 1
    for i,v in ipairs(self.config.finish_reward) do
        local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        local posX = (begin + item:getContentSize().width * scale / 2) + (index - 1) * ((item:getContentSize().width * scale) + margin)
        item:setPosition(posX, posY)
        item:setScale(scale)
        item:registerScriptTapHandler(handler(self, self.onClick))

        if self.data.is_got then
            local content_size = item:getContentSize()
            local gray_bg = ccui.Scale9Sprite:createWithSpriteFrameName("win-bg/block-gray-2.png", cc.rect(1, 1, 1, 1))
            gray_bg:setContentSize(content_size)
            gray_bg:setPosition(content_size.width / 2, content_size.height / 2)
            gray_bg:setLocalZOrder(100)
            item:addChild(gray_bg)

            local spr_flag = cc.Sprite:createWithSpriteFrameName("backpack/spr-selected.png")
            spr_flag:setPosition(content_size.width / 2, content_size.height / 2)
            spr_flag:setLocalZOrder(200)
            gray_bg:addChild(spr_flag)
        end

        self.item_menu:addChild(item)
        self.items[index] = item
        index = index + 1
    end

    for i,v in ipairs(self.config.privilege_reward) do
        local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        local posX = (begin + item:getContentSize().width * scale / 2) + (index - 1) * ((item:getContentSize().width * scale) + margin)
        item:setPosition(posX, posY)
        item:setScale(scale)
        item:registerScriptTapHandler(handler(self, self.onClick))

        if not ex.Player.promotion_data:isHappyMonthItemGetPrivilege(self.data.idx) then
            local content_size = item:getContentSize()
            -- local gray_bg = ccui.Scale9Sprite:createWithSpriteFrameName("win-bg/block-gray-2.png", cc.rect(1, 1, 1, 1))
            -- gray_bg:setContentSize(content_size)
            -- gray_bg:setPosition(content_size.width / 2, content_size.height / 2)
            -- gray_bg:setLocalZOrder(100)
            -- item:addChild(gray_bg)

            local gray_bg = cc.LayerColor:create(cc.c4b(0, 0, 0, 255), content_size.width, content_size.height)
            gray_bg:setIgnoreAnchorPointForPosition(false)
            gray_bg:setAnchorPoint(ex.a.center)
            gray_bg:setPosition(content_size.width / 2, content_size.height / 2)
            gray_bg:setLocalZOrder(100)
            item:addChild(gray_bg)

            local spr_flag = cc.Sprite:createWithSpriteFrameName("promotion/spr-common-2.png")
            spr_flag:setPosition(content_size.width / 2, content_size.height / 2)
            spr_flag:setLocalZOrder(200)
            gray_bg:addChild(spr_flag)
        end

        self.item_menu:addChild(item)
        self.items[index] = item
        index = index + 1
    end
end

return CACHappyMonthLayer