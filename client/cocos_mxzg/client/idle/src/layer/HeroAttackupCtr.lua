local HeroAttackupCtr = class("HeroAttackupCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroAttackupLayer = class("HeroAttackupLayer", require("src.comp.LuaLayerBase"))

function HeroAttackupLayer:showAttackupEffect(last_attack, add_attack)
    if last_attack <= 0 or add_attack == 0 then
        return
    end
    
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/hero-attack-effect.plist")
    sfc:addSpriteFrames("ccbi-res/lang-1.plist")

    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_hero_attack")
    spr_effect:setPosition(ex.p.width / 2, ex.p.height * 0.75)
    spr_effect:setScaleX(ex.p.width / spr_effect:getContentSize().width)
    self:addChild(spr_effect, 100, 100)

    if self.spr_attack_bg == nil then
        self.spr_attack_bg = cc.Sprite:createWithSpriteFrameName("hero-attack-effect/spr-attack-bg.png")
        self.spr_attack_bg:setScaleY(1.2)
        self.spr_attack_bg:setPosition(ex.p.width / 2, ex.p.height * 0.75)
        self.spr_attack_bg:setOpacity(0)
        self:addChild(self.spr_attack_bg, 40)
    else 
        self.spr_attack_bg:stopAllActions()
    end

    self.spr_attack_bg:runAction(cc.Sequence:create(cc.FadeIn:create(0.5), cc.DelayTime:create(1), cc.FadeOut:create(0.5), cc.CallFunc:create(handler(self, self.showAttackupEffectEnd)), nil))

    if self.spr_attack_tip == nil then
        self.spr_attack_tip = cc.Sprite:createWithSpriteFrameName("lang-1/spr-attack-tip.png")
        self.spr_attack_tip:setPosition(self.spr_attack_bg:getPositionX() - 100, self.spr_attack_bg:getPositionY())
        self.spr_attack_tip:setOpacity(0)
        self:addChild(self.spr_attack_tip, 50)
    else 
        self.spr_attack_tip:stopAllActions()
    end

    self.spr_attack_tip:runAction(cc.Sequence:create(cc.FadeIn:create(0.5), cc.DelayTime:create(1), cc.FadeOut:create(0.5), nil))

    local last_opacity = 0
    if self.lbl_attack_tip ~= nil then
        last_opacity = self.lbl_attack_tip:getOpacity()
        self.lbl_attack_tip:removeFromParent()
        self.lbl_attack_tip = nil
    end

    if self.lbl_attack_tip2 ~= nil then
        self.lbl_attack_tip2:removeFromParent()
        self.lbl_attack_tip2 = nil
    end

    local act_fade = cc.Sequence:create(cc.FadeIn:create(0.5), cc.DelayTime:create(1), cc.FadeOut:create(0.5), nil)
    if add_attack > 0 then
        self.lbl_attack_tip = cc.Label:createWithBMFont("font/red-26.fnt", string.format("%s", last_attack))  --cpp.StringUtil:convertScientific(last_attack), cpp.StringUtil:convertScientific(add_attack)))
        self.lbl_attack_tip:setOpacity(last_opacity)
        self.lbl_attack_tip:setAnchorPoint(cc.p(0, 0.5))
        self.lbl_attack_tip:setPosition(self.spr_attack_bg:getPositionX() - 50, self.spr_attack_bg:getPositionY())
        self:addChild(self.lbl_attack_tip, 50)
        self.lbl_attack_tip:runAction(act_fade:clone())


        self.lbl_attack_tip2 = cc.Label:createWithBMFont("font/green-26.fnt", string.format("+%s", add_attack))  --cpp.StringUtil:convertScientific(last_attack), cpp.StringUtil:convertScientific(add_attack)))
        self.lbl_attack_tip2:setOpacity(last_opacity)
        self.lbl_attack_tip2:setAnchorPoint(cc.p(0, 0.5))
        self.lbl_attack_tip2:setPosition(self.lbl_attack_tip:getPositionX() + self.lbl_attack_tip:getContentSize().width, self.spr_attack_bg:getPositionY())
        self:addChild(self.lbl_attack_tip2, 50)
        self.lbl_attack_tip2:runAction(act_fade)

    else 
        self.lbl_attack_tip = cc.Label:createWithBMFont("font/red-26.fnt", string.format("%s-%s", last_attack, math.abs(add_attack)))  --cpp.StringUtil:convertScientific(last_attack), cpp.StringUtil:convertScientific(math.abs(add_attack))))
        self.lbl_attack_tip:setOpacity(last_opacity)
        self.lbl_attack_tip:setAnchorPoint(cc.p(0, 0.5))
        self.lbl_attack_tip:setPosition(self.spr_attack_bg:getPositionX() - 50, self.spr_attack_bg:getPositionY())
        self:addChild(self.lbl_attack_tip, 50)
        self.lbl_attack_tip:runAction(act_fade)
    end


end

function HeroAttackupLayer:showAttackupEffectEnd()
    -- print("HeroInfoLayer:showAttackupEffectEnd")
    -- ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_ATTACKUP_END)
end

function HeroAttackupCtr:receiveEvent(event, cur_attack, add_attack)
    print("HeroAttackupCtr:receiveEvent event, cur_attack, add_attack", event, cur_attack, add_attack)

    if event == EVENT.HERO_INFO_EVENT.HERO_ATTACKUP then
        local scene = cc.Director:getInstance():getRunningScene()
    	local hero_attackup_layer = scene:getChildByName("hero_attackup_layer")
    	if not hero_attackup_layer then 
            hero_attackup_layer = HeroAttackupLayer:create()
        	scene:addChild(hero_attackup_layer, 99999)
        	hero_attackup_layer:setName("hero_attackup_layer")
        end

        hero_attackup_layer:showAttackupEffect(cur_attack, add_attack)
    elseif event == EVENT.HERO_INFO_EVENT.HERO_ATTACKUP_END then
        local scene = cc.Director:getInstance():getRunningScene()
    	local hero_attackup_layer = scene:getChildByName("hero_attackup_layer")
        if hero_attackup_layer ~= nil then
            hero_attackup_layer:removeFromParent()
            hero_attackup_layer = nil
        end
    end
end

function HeroAttackupCtr:getLayerClass()
    return HeroAttackupLayer
end

function HeroAttackupCtr:getHeroAttackupLayer()
    local scene = cc.Director:getInstance():getRunningScene()
   	local hero_attackup_layer = scene:getChildByName("hero_attackup_layer")
    return hero_attackup_layer
end

function HeroAttackupCtr:openWindow()
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/hero-attack-effect.plist")
    sfc:addSpriteFrames("ccbi-res/lang-1.plist")

    -- self:registerEvent()
end

function HeroAttackupCtr:ctor()
	
    self:registerEvent()
end

function HeroAttackupCtr:registerEvent()
	print("HeroAttackupCtr:registerEvent")
   	ex.EventManager:add(EVENT.HERO_INFO_EVENT.HERO_ATTACKUP, handler(self, self.receiveEvent))
  	ex.EventManager:add(EVENT.HERO_INFO_EVENT.HERO_ATTACKUP_END, handler(self, self.receiveEvent))
end

return HeroAttackupCtr
