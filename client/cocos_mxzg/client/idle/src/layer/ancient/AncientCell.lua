local AncientCell = class("AncientCell", require("src.comp.EventLayer"))

function AncientCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 0.5)

    self.scroll_view:setSwallowsTouches(false)
    self.scroll_view:setItemSize(cc.size(80, 90))
    self.scroll_view:setBounceable(false)
end

function AncientCell:reset(data)
    self.data = data
    
    self.is_lock = ex.JumpManager:checkOpenConditionByAtomNoMsg(self.data.atom)

    self.lbl_tip:setString(ex.Tools:getLang(self.data.tip1))
    ex.Tools:setSpriteFrame(self.spr_bg, data.image)

    self.scroll_view.createItemFunction = function(data, scale)
        local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
        item:setScale(0.63)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        item:setAllGray(self.is_lock == false)
        return item
    end
    self.scroll_view:reloadData(data.reward_show ~= "" and data.reward_show or {})
    self.scroll_view.menu:setSwallowsTouches(true)

    self:setFuncUnlockInfo()
end



function AncientCell:setFuncUnlockInfo()

    local is_unlock = self.is_lock

    if not is_unlock then
        ex.Tools:ergodicAllNode(self, function(node)
            if node.getSpriteFrame ~= nil then
                ex.Tools:setAllGrayAuto(node, true)
            end
        end)

        local config = cfg.opencondition.condition[self.data.atom]
        local str_text = ""

        local btn_size= self:getContentSize()
        local spr_bg = ccui.Scale9Sprite:createWithSpriteFrameName("win-bg/block-bg-23.png", cc.rect(0, 0, 0, 0))
        spr_bg:setAnchorPoint(cc.p(0.5, 0.5))
        spr_bg:setIgnoreAnchorPointForPosition(false)
        spr_bg:setPosition(btn_size.width / 2, btn_size.height / 2)
        self:addChild(spr_bg, 10)

        local tip_lbl = cc.Label:createWithTTF(ex.Tools:getLabelTextByAtom(self.data.atom), FONT_DEFAULT_NAME_BOLD, 56)
        tip_lbl:setScale(0.5)
        tip_lbl:setAnchorPoint(cc.p(0.5, 0.5))
        local real_size = spr_bg:getPreferredSize()
        tip_lbl:setPosition(real_size.width / 2, real_size.height / 2)
        tip_lbl:enableOutline(FONT_BLACK_C4B, 3)
        spr_bg:addChild(tip_lbl)
    end
end

return AncientCell