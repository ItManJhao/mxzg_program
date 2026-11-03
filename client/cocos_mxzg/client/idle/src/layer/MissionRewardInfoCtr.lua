local MissionRewardInfoCtr = class("MissionRewardInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local MissionRewardInfoLayer = class("MissionRewardInfoLayer", require("src.comp.EventLayer"))

local MissionRewardInfoCell = class("MissionRewardInfoCell", require("src.comp.LuaLayerBase"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function MissionRewardInfoCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.scroll_view = cpp.UIScrollViewZoom:create(cc.size(450, 100))
    :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    :setBounceable(true)
    :setPosition(15, 5)
    :setSwallowsTouches(false)
    self:addChild(self.scroll_view)

    self.menu = cpp.UIMenu:create()
    self.menu:setName("menu")
    :setIsTouchInsideNode(self.scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    self.scroll_view:addChild(self.menu)
end

function MissionRewardInfoCell:initData(data)
    self.lbl_title:setString(string.format(ex.Tools:getLang(47515), data.idx))

    local item_size = cc.size(90, 90)
    
    for i,v in ipairs(data.vec_reward) do
        local item_backpack = ex.Tools:createBackpackItem(v.item_type, 0)
        item_backpack:registerScriptTapHandler(handler(self, self.onItemInfo))
        item_backpack:setPosition((item_size.width + 10) * (i - 0.5), item_size.height * 0.5 + 5)
        item_backpack:setScale(0.8)
        self.menu:addChild(item_backpack)
    end
    if #data.vec_reward <= 5 then
        self.scroll_view:setContentSize(cc.size(450, 100))
    else 
        self.scroll_view:setContentSize(cc.size(#data.vec_reward * 100, 100))
    end
end

function MissionRewardInfoCell:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function MissionRewardInfoLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    self.scroll_view:setItemSize(cc.size(480, 155))
    self.scroll_view:setItemType(1)

    self.btn_left:setChecked(true)
    self.btn_left:setTag(1)
    self.btn_right:setTag(2)



    self.btn_left:setLabelText(ex.Tools:getLang(47514))
    self.btn_right:setLabelText(ex.Tools:getLang(47774))
end

-----------------------------------------------------------------------------
function MissionRewardInfoCtr:onCreate()
    self:setCCBIPath("ccbi/MissionRewardInfoLayer.ccbi")
    self:setIsSingle(false)
end

function MissionRewardInfoCtr:getLayerClass()
    return MissionRewardInfoLayer
end

function MissionRewardInfoCtr:openWindow()
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData()
end

function MissionRewardInfoCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer.btn_right:registerScriptTapHandler(handler(self, self.onTab))
    self.layer.btn_left:registerScriptTapHandler(handler(self, self.onTab))

    self:onTab(1)
end

function MissionRewardInfoCtr:onTab(tag, pSender)
    self.layer_type = tag

    self:updateScrollView()
end

function MissionRewardInfoCtr:updateScrollView()
    local item_list = {}
    for _,v in ipairs(cfg.chapterreward.chapterreward) do
        local data = {}
        data.idx = v.idx
        if self.layer_type == 1 then
            data.vec_reward = v.first_reward
        elseif self.layer_type == 2 then
            data.vec_reward = {}
            for _,v2 in ipairs(v.reward_base) do
                local is_have = false
                for _,v3 in ipairs(data.vec_reward) do
                    if v3.item_type == v2.item_type then
                        is_have = true
                        break
                    end
                end
                if is_have == false then
                    table.insert(data.vec_reward, {item_type = v2.item_type})
                end
            end
            for _,v2 in ipairs(v.reward_unique) do
                local is_have = false
                for _,v3 in ipairs(data.vec_reward) do
                    if v3.item_type == v2.type then
                        is_have = true
                        break
                    end
                end
                if is_have == false then
                    table.insert(data.vec_reward, {item_type = v2.type})
                end
            end
        end
        table.insert(item_list, data)
    end

    self.layer.scroll_view:getContainer():removeAllChildren()
    self.layer.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = MissionRewardInfoCell:createWithCCBIFile("ccbi/MissionRewardInfoCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data)
    
        return cell
    end

    self.layer.scroll_view:reloadData(item_list)
end

return MissionRewardInfoCtr
