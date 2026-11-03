local GuideAnimationLayer = class("GuideAnimationLayer", require("src.comp.EventLayer"))

function GuideAnimationLayer:onCreate()
    self:setAutoClose(false)
    -- self:setSwallowTouches(false)

    self.touch_size = cc.size(0, 0)
    self.touch_position = cc.p(0, 0)
    self.is_wait_touch = false

    self:setPosition(cc.p(0, 0))
    self:setLocalZOrder(999998)
end

function GuideAnimationLayer:onExit()
    if self.guide_ctr then
        self.guide_ctr.lay_animation = nil
    end
end

function GuideAnimationLayer:getGuideSprite()
    return self:getChildByTag(99)
end

function GuideAnimationLayer:addGuideSprite(bubble_text)
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/guide.plist")

    local win_size = cc.Director:getInstance():getWinSize()

    local position = cc.p(self.touch_position.x + self.touch_size.width * 0.5, self.touch_position.y + self.touch_size.height * 0.5)

    local node = cc.Node:create()
    node:setTag(99)
    node:setPosition(position)
    self:addChild(node)

    if self.is_mask == true then
        local opacity = 153
        local act_fade = cc.FadeTo:create(0.15, opacity)
    
        -- 添加黑色遮罩
        local spr_mask = cc.Sprite:createWithSpriteFrameName("guide/spr-mask.png")
        spr_mask:setOpacity(0)
        spr_mask:runAction(act_fade:clone())
        node:addChild(spr_mask)
    
        local mask_size = spr_mask:getContentSize()
    
        -- 添加顶部黑色
        local top_y = self.touch_position.y + self.touch_size.height * 0.5 + mask_size.height * 0.5
        if top_y < win_size.height then
            local layer_mask_top = cc.LayerColor:create(cc.c4b(0,0,0,0), win_size.width, win_size.height - top_y)
            -- layer_mask_top:setOpacity(opacity)
            layer_mask_top:setIgnoreAnchorPointForPosition(false)
            layer_mask_top:setAnchorPoint(cc.p(0.5, 0))
            layer_mask_top:setPosition(cc.p(win_size.width * 0.5 - (self.touch_position.x + self.touch_size.width * 0.5), mask_size.height * 0.5))
            layer_mask_top:runAction(act_fade:clone())
            node:addChild(layer_mask_top)
        end
    
        -- 添加底部黑色
        local bottom_y = self.touch_position.y + self.touch_size.height * 0.5 - mask_size.height * 0.5
        if bottom_y > 0 then
            local layer_mask_bottom = cc.LayerColor:create(cc.c4b(0,0,0,0), win_size.width, top_y)
            -- layer_mask_top:setOpacity(opacity)
            layer_mask_bottom:setIgnoreAnchorPointForPosition(false)
            layer_mask_bottom:setAnchorPoint(cc.p(0.5, 1))
            layer_mask_bottom:setPosition(cc.p(win_size.width * 0.5 - (self.touch_position.x + self.touch_size.width * 0.5), -mask_size.height * 0.5))
            layer_mask_bottom:runAction(act_fade:clone())
            node:addChild(layer_mask_bottom)
        end
    
        -- 添加左边黑色
        local left_x = self.touch_position.x + self.touch_size.width * 0.5 - mask_size.width * 0.5
        if left_x > 0 then
            local layer_mask_left = cc.LayerColor:create(cc.c4b(0,0,0,0), left_x, mask_size.height)
            -- layer_mask_top:setOpacity(opacity)
            layer_mask_left:setIgnoreAnchorPointForPosition(false)
            layer_mask_left:setAnchorPoint(cc.p(1, 0.5))
            layer_mask_left:setPosition(cc.p(-mask_size.width * 0.5, 0))
            layer_mask_left:runAction(act_fade:clone())
            node:addChild(layer_mask_left)
        end
    
    
        -- 添加右边黑色
        local right_x = self.touch_position.x + self.touch_size.width * 0.5 + mask_size.width * 0.5
        if right_x > 0 then
            local layer_mask_right = cc.LayerColor:create(cc.c4b(0,0,0,0), win_size.width - right_x, mask_size.height)
            layer_mask_right:setIgnoreAnchorPointForPosition(false)
            layer_mask_right:setAnchorPoint(cc.p(0, 0.5))
            layer_mask_right:setPosition(cc.p(mask_size.width * 0.5, 0))
            layer_mask_right:runAction(act_fade:clone())
            node:addChild(layer_mask_right)
        end
    end
    

    local spr_ring = ex.EffectFactory:createEffectWithNodeByName("eff_guide_ring")
    ex.Tools:setSpriteFrame(spr_ring, "guide/ring00.png")
    spr_ring:setTag(99)
    node:addChild(spr_ring)

    local palm = ex.EffectFactory:createEffectWithNodeByName("eff_guide_palm")
    palm:setAnchorPoint(cc.p(0.1, 0.9))
    palm:setPosition(cc.p(spr_ring:getContentSize().width * 0.5, spr_ring:getContentSize().height * 0.5))
    spr_ring:addChild(palm)

    local atc_move = cc.Sequence:create(cc.MoveTo:create(1.2, cc.p(palm:getPositionX(), palm:getPositionY() + 10)),
                                        cc.MoveTo:create(1.2, cc.p(palm:getPositionX(), palm:getPositionY())))
    palm:runAction(cc.RepeatForever:create(atc_move))

    -- 判断是否移动
    if self.old_position then
        spr_ring:setPosition(self.old_position.x - position.x, self.old_position.y - position.y)
        spr_ring:runAction(cc.EaseExponentialOut:create(cc.MoveTo:create(1, cc.p(0, 0))))
    end

    return node
end

function GuideAnimationLayer:addBubble(bubble_text, anchor, bubble_pos, dimensions)
    if bubble_text == nil or bubble_text == "" then
        return
    end

    self.spr_bubble = require("src.comp.UISpriteBubble"):createWithText(bubble_text, dimensions)
    if anchor then
        self.spr_bubble:setAnchorPoint(anchor)
    end

    if bubble_pos then
        self.spr_bubble:setPosition(bubble_pos.x, bubble_pos.y)
    end
    
    self:getGuideSprite():addChild(self.spr_bubble)
end

function GuideAnimationLayer:remove()
    self:removeGuideSprite()
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.07), cc.RemoveSelf:create()))
end

function GuideAnimationLayer:removeGuideSprite()
    local arrow = self:getGuideSprite()
    if arrow then
        arrow:setTag(-1)
        arrow:removeChildByTag(99)
        local children = arrow:getChildren()
        for i,v in ipairs(children) do
            local node = v
            local act_fade = cc.FadeTo:create(0.1, 0)
            node:runAction(act_fade)
        end
        arrow:runAction(cc.Sequence:create(cc.DelayTime:create(0.07), cc.RemoveSelf:create()))
    end
end


return GuideAnimationLayer