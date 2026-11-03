--[[
    func:功能说明
    author:徐东浩
    time:2019-10-29 16:14:57
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local Common3ContentLayer = class("Common3ContentLayer", require("src.layer.promotion.Common1ContentLayer"))


function Common3ContentLayer:refreshBtnStatus()
    if self.data ~= nil then
        if self.data.is_got then
            if ex.Player.promotion_data:isHappyMonthPrivilege() and not ex.Player.promotion_data:isHappyMonthItemGetPrivilege(self.data.idx) then
                self.item_btn_status = CommonUIDefine.ItemBtnStatus.GET    -- 领取了普通奖励，没有领特权奖励
            else
                self.item_btn_status = CommonUIDefine.ItemBtnStatus.GOT
            end
        elseif self.data.progress >= self.config.target_num then
            self.item_btn_status = CommonUIDefine.ItemBtnStatus.GET
        else
            if self.config.jump_info.event_type ~= 0 then
                self.item_btn_status = CommonUIDefine.ItemBtnStatus.JUMP
            else
                self.item_btn_status = CommonUIDefine.ItemBtnStatus.HINT
            end
        end
    else
        self.item_btn_status = CommonUIDefine.ItemBtnStatus.NONE
    end
end

function Common3ContentLayer:createMenuWithItem()
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
end

return Common3ContentLayer