-- 讨伐团- 出征界面
local CrusadeGroupSetOffLayer = class("CrusadeGroupSetOffLayer", require("src.comp.EventLayer"))
local CrusadeGroupHeroItem = require("src.layer.crusadegroup.CrusadeGroupHeroItem")
local CrusadeGroupEnergy = class("CrusadeGroupEnergy", require("src.comp.EventLayer"))

function CrusadeGroupSetOffLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(true)

    self:initEventListen()
    self.scroll_view:setItemSize(cc.size(120, 158))
    self.scroll_view:setItemType(1)

    self.touch_layer = cc.Layer:create()
    self:addChild(self.touch_layer, -1)
    self.btn_close:registerScriptTapHandler(handler(self, self.onClose))

    self.lbl_tip = require("src.comp.RichTextEx"):create()
        :setFontSize(22)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setWrapMode(1)
        :setAnchorPoint(0.5, 0.5)
    self.node_tip:addChild(self.lbl_tip)
    self.lbl_tip:setPosition(self.node_tip:getContentSize().width / 2, self.node_tip:getContentSize().height / 2)
    local str = string.format(ex.Tools:getLang(77452), cfg.system.crusade_group_energy_resume_rate)
    self.lbl_tip:setXmlTextLua(str)
end

function CrusadeGroupSetOffLayer:addPlist()
end

function CrusadeGroupSetOffLayer:initEventListen()
    self:addEvent(EVENT.CRUSADE_GROUP.UPDATE_SET_OFF, handler(self, self.handleRefreshHero))
end

function CrusadeGroupSetOffLayer:refreshHero()
    if not ctr.crusade_group:requestRefreshHero() then
        self.is_refresh = true
    end

    self:reloadData()
end

function CrusadeGroupSetOffLayer:reloadData()
    self.scroll_view:getContainer():removeAllChildren()

    self.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = CrusadeGroupHeroItem:createWithCCBIFile("ccbi/CrusadeGroupHeroItem.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.3)
        local energy_item = CrusadeGroupEnergy:createWithCCBIFile("ccbi/CrusadeGroupEnergy.ccbi")
        energy_item:setIgnoreAnchorPointForPosition(false)
        energy_item:setAnchorPoint(0.5, 0.5)
        energy_item:setPosition(cell:getContentSize().width / 2, - energy_item:getContentSize().height / 2 - 5)
        cell:addChild(energy_item)
        local physical_strength = data.physical_strength or 0
        energy_item.lbl_num:setString(physical_strength)
        cell:reloadData(data, CRUSADE_GROUP_HERO_ITEM_TYPE.SET_OFF)
        cell.btn_item.data = data
        cell.btn_item:registerScriptTapHandler(handler(self, self.onClickItem))
        cell.menu:setSwallowsTouches(false)
        cell.menu:setIsTouchInsideNode(self.scroll_view)
        return cell
    end

    local list = {}
    local hero_box_list = ctr.crusade_group.data.game_data.hero_box_list
    for i = 1, cfg.system.crusade_group_max_setoff do
        local hero
        local box_id
        local physical_strength = cfg.system.crusade_group_init_energy
        if i <= #hero_box_list then
            hero = hero_box_list[i].hero
            box_id = hero_box_list[i].box_id
            physical_strength = hero_box_list[i].physical_strength
        end

        local model = {
            box_id = box_id,
            hero = hero,
            physical_strength = physical_strength
        }

        table.insert(list, model)
    end

    self.scroll_view:reloadData(list)
end

function CrusadeGroupSetOffLayer:setTouchesHandler(is_touch)
    if is_touch then
        self.touch_layer:setTouchEnabled(true)
        self.touch_layer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
        self.touch_layer:registerScriptTouchHandler(
            function(event, x, y)
                local pos = self:getParent():convertToNodeSpace(cc.p(x, y))
                if event == "began" then
                    local startX = self:getPositionX()
                    local endX = self:getPositionX() + self:getContentSize().width
                    local startY = self:getPositionY()
                    local endY = self:getPositionY() + self:getContentSize().height

                    -- 不在表情layer里的就隐藏表情layer
                    if pos.x > endX or pos.x < startX or pos.y > endY or pos.y < startY then
                        self.touch_layer:unregisterScriptTouchHandler()
                        if self.is_layer_showing then
                            self:stopAllActions()
                            self.is_layer_showing = false
                        end

                        self:runAction(cc.MoveTo:create(0.5, cc.p(0, -self:getContentSize().height))) 
                    end

                    return true
                end
            end
        )
    else
        self.touch_layer:unregisterScriptTouchHandler()
    end
end

function CrusadeGroupSetOffLayer:onClickItem(tag, sender)
    if not self.is_refresh then
        ex.MessageView:add(ex.Tools:getLang(77937)) 
        return
    end

    
    local data = sender.data
    if (not data.hero or data.hero.hero_id == 0) and data.box_id then
        require("src.layer.crusadegroup.CrusadeGroupSetOffSelectCtr"):instance():openWindow(data.box_id)
    elseif data.hero and data.hero.hero_id > 0 then
        require("src.layer.crusadegroup.CrusadeGroupUnloadCtr"):instance():openWindow(data)
    else
        ex.MessageView:add(ex.Tools:getLang(77936)) 
    end
end

function CrusadeGroupSetOffLayer:onClose()
    self.touch_layer:unregisterScriptTouchHandler()
    self:runAction(cc.MoveTo:create(0.5, cc.p(0, -self:getContentSize().height)))
end

function CrusadeGroupSetOffLayer:handleRefreshHero()
    self.is_refresh = true
    self:reloadData()
end

return CrusadeGroupSetOffLayer
