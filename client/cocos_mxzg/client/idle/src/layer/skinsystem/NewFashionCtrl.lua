local NewFashionCtr = class("NewFashionCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local NewFashionLayer = class("NewFashionLayer", require("src.comp.LuaLayerBase"))

function NewFashionLayer:onCreate()
	self:setAutoClose(true)
	self:setSwallowTouches(true)

	self:setIgnoreAnchorPointForPosition(false)
	self:setAnchorPoint(ex.a.center)
	self:setPosition(ex.p.center())

	-- 是否可点击
	self.is_touch_enable = true

	-- 铺展到全屏
    self.spr_bg = cc.Sprite:create("ccbi-res/map-bg-summon-1.jpg")
    self.spr_bg:setScale(ex.p.width / self.spr_bg:getContentSize().width, ex.p.height / self.spr_bg:getContentSize().height)
    self.spr_bg:setPosition(self:convertToNodeSpace(ex.p.center()))
	self:addChild(self.spr_bg, -1)

	self.spr_bg_inner:setPreferredSize(cc.size(ex.p.width, self.spr_bg_inner:getPreferredSize().height))

	local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_reward")
    spr_effect:setPosition(self.spr_title:getPositionX() - 9, self.spr_title:getPositionY() - 10)
	self:addChild(spr_effect, 20, 100)

	self.spr_light_left:setOpacity(0)
end

-- 重写点击判断函数，用于控制界面是否可以点击，以及规避LuaNodeCtr对点击到Layer包围盒中不自动关闭的问题
function NewFashionLayer:isTouchInside(touch)
	return self.is_touch_enable
end

function NewFashionLayer:refreshShowGirl(fashion_id)
	self.node_animator:removeAllChildren()

	self.spr_action = cc.Sprite:createWithSpriteFrameName("reward-effect2/jin-0.png")
	self.spr_action:setPosition(0, 100)		
	self.spr_action:setScale(6)
	self.node_animator:addChild(self.spr_action, 0,10)
	self.spr_action:setGLProgram(cpp.ShaderFactory:instance():getGLProgram(1))

	local action = cpp.ActionFactory:createLuaAnimate("ccbi-res/reward-effect2.plist", "reward-effect2/jin-%d.png", 0.06)
	self.spr_action:runAction(cc.Spawn:create(action, cc.Sequence:create(cc.DelayTime:create(0.15), cc.CallFunc:create(function()
		self:showHero(fashion_id)
	end))))
end

function NewFashionLayer:showHero(fashion_id)
	self.spine_effect_left_2 = sp.SkeletonAnimation:create("spine/prophet-tree-effect-2.json","spine/prophet-tree-effect-2.atlas", 1)
    self.spine_effect_left_2:setAnimation(0, "stand", true);
	self.spine_effect_left_2:setPosition(0, -20)
	self.spine_effect_left_2:setScale(2.4)
    self.node_animator:addChild(self.spine_effect_left_2, 50)

    self.spine_effect_left_1 = sp.SkeletonAnimation:create("spine/prophet-tree-effect-1.json","spine/prophet-tree-effect-1.atlas", 1)
    self.spine_effect_left_1:setAnimation(0, "stand", true);
	self.spine_effect_left_1:setPosition(0, -20)
	self.spine_effect_left_1:setScale(2.4)
	self.node_animator:addChild(self.spine_effect_left_1, 10)

	ex.EffectCtr:playNormalEff(33, 0, 100, nil, self.node_animator, 100)
	
	self.spr_light_left:runAction(cc.FadeIn:create(0.2))

	self.animator = require("src.person.Hero"):create("1", "1", 1, 1, 1, fashion_id)
    self.animator:setAnimation(0, "stand", true);
    self.animator:setScale(1.5)
    self.animator:setPosition(cc.p(0, 100))
	self.animator:setShadowVisible(false)
	self.animator:setOpacity(0)
	self.node_animator:addChild(self.animator, 1000)

	self.animator:runAction(cc.Spawn:create(cc.ScaleTo:create(0.2, 2.2), cc.FadeIn:create(0.2)))

	self.node_animator:runAction(cc.Sequence:create(cc.DelayTime:create(0.3), cc.CallFunc:create(function()
		self.is_touch_enable = false
	end)))
end

function NewFashionLayer:refreshDesc(config)
	self.lbl_skin_name:setString(ex.Tools:getLang(config.fashion_name))

    self.lbl_skin_desc:setString(string.format(ex.Tools:getLang(3820), ex.Tools:getLang(config.hero_type)))
end


-----------------------------------------------------------------------------
function NewFashionCtr:onCreate()
	self:setCCBIPath("ccbi/NewFashionLayer.ccbi")
	self:setIsSingle(false)

	self.fashion_id = 0
	self.config = {}
end

function NewFashionCtr:getLayerClass()
	return NewFashionLayer
end

function NewFashionCtr:getNewFashionLayer()
	return self.layer
end

function NewFashionCtr:openWindow(fashion_id)
	if self:isOpened() then
		return
	end

	self.fashion_id = fashion_id
	self.config = cfg.herofashion.getConfigByType(self.fashion_id)

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/reward-effect2.plist")
	sfc:addSpriteFrames("ccbi-res/summon-effect.plist")

	self:loadLayer()
	self:open()
	self:updateLayer()

	ex.AudioManager:playEffect("music/summon-anime.mp3")
end

function NewFashionCtr:updateLayer()
	self.layer:refreshShowGirl(self.fashion_id)

    self.layer:refreshDesc(self.config)
end

return NewFashionCtr
