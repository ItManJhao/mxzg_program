local RunesSelect2Cell = class("RunesSelect2Cell", require("src.comp.LuaLayerBase"))

RunesSelect2Cell.cell_type =
{
    SELECT2_CTR = 1,    -- 选择器界面
    SMITH_RUNES = 2,    -- 合成界面
}

function RunesSelect2Cell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function RunesSelect2Cell:setTableView(table_view)
    self.tableView = table_view
    self.menu_item:setSwallowsTouches(false)
    self.menu_item:setIsTouchInsideNode(table_view)
end

-- 显示一行符文
function RunesSelect2Cell:reset(data)
    if not data then return end
    self.data = data
    -- self:updateItem()
    self:setScale(1)

    local begin = 0
    local margin = 10
    local posY = 0
    local scale = 1
    local offset = 10

    if self:getChildByName("spr_select_bg") then
        self:removeChildByName("spr_select_bg")
    end

    if self:getChildByName("spr_select") then
        self:removeChildByName("spr_select")
    end

    
    self.menu_item:removeAllChildren()

    local config = cfg.herotype.star

    local index = 1
    for k, runes_data in pairs(self.data) do
        local item = require("src.comp.menu.UIMenuItemBackpack"):createWithData(runes_data.runes_data.item_type)
        -- item:setScale(0.8)
        item.runes_data = runes_data
        item.item_id = runes_data.runes_data.item_id

        print("runes content size:("..item:getContentSize().width..", "..item:getContentSize().height..")")

        local item_width = (self.tableView:getViewSize().width / runes_data.col)
        local posX = (self.tableView:getViewSize().width * 0.5 - (runes_data.col - 1) * item_width * 0.5 + item_width * (index - 1)) 
        item:setPosition(posX, item:getContentSize().height * 0.5)
        :registerScriptTapHandler(handler(self, self.onItemClicked))
        self.menu_item:add(item)

        if runes_data.is_show_select ~= false then
            local spr_select_bg = cc.Sprite:createWithSpriteFrameName("win-bg/win-bg-18.png")
                :setPosition(posX + item:getContentSize().width * 0.33, item:getContentSize().height * 0.88)
                :setName("spr_select_bg")
            self:addChild(spr_select_bg, 99)

            local spr_select = cc.Sprite:createWithSpriteFrameName("backpack/spr-selected.png")
                :setPosition(posX + item:getContentSize().width * 0.33, item:getContentSize().height * 0.88)
                :setVisible(runes_data.setSelected)
                :setName("spr_select")
            self:addChild(spr_select, 99)

            spr_select_bg.listener = cc.EventListenerTouchOneByOne:create()
            spr_select_bg.listener:setSwallowTouches(true)
            spr_select_bg.listener:registerScriptHandler(
                function(touch, event)
                    local touchLocation = touch:getLocation()
                    touchLocation = spr_select_bg:getParent():convertToNodeSpace(touchLocation)
                    local bBox = spr_select_bg:getBoundingBox()

                    local tableViewBox = self.tableView:getBoundingBox()
                    
                    if cc.rectContainsPoint(tableViewBox, self.tableView:getParent():convertToNodeSpace(touch:getLocation())) and
                     touchLocation.x >= bBox.x and touchLocation.x <= bBox.x + bBox.width and touchLocation.y >= bBox.y and touchLocation.y <= bBox.y + bBox.height then
                        self:onSelectedRunes(item, spr_select)
                        return true
                    end

                    return false
                end,cc.Handler.EVENT_TOUCH_BEGAN)
            local event_dispatcher = spr_select_bg:getEventDispatcher()
            event_dispatcher:addEventListenerWithSceneGraphPriority(spr_select_bg.listener, spr_select_bg)
        end

        index = index + 1
    end
end

function RunesSelect2Cell:onSelectedRunes(pSender, spr_select)
    print("pSender.runes_data.tag", pSender.runes_data.tag)
    
    if pSender.runes_data.tag == RunesSelect2Cell.cell_type.SELECT2_CTR then
        ex.EventManager:fire(EVENT.RUNES_EVENT.SELECT_RUNES, pSender, spr_select)
    elseif pSender.runes_data.tag == RunesSelect2Cell.cell_type.SMITH_RUNES then
        ex.EventManager:fire(EVENT.RUNES_EVENT.SELECT_SMITH_RUNES, pSender, spr_select)
    end
end

function RunesSelect2Cell:onItemClicked(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type, pSender.item_id)
end

return RunesSelect2Cell