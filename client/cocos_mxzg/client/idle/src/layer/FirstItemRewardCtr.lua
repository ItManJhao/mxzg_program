local FirstItemRewardCtr = class("FirstItemRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local FirstItemRewardLayer = class("FirstItemRewardLayer", require("src.comp.EventLayer"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function FirstItemRewardLayer:onCreate()
	self:setAutoClose(true)
	self:addBlackBackground()

	self:setExitCallback(handler(self,self.exitCallBack))

	self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)

    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_reward")
    spr_effect:setPosition(self.spr_title:getPositionX(), self.spr_title:getPositionY())
    self:addChild(spr_effect, 20, 100)

	local top = self.spr_title:getPositionY() - self.spr_title:getContentSize().height / 2 - 5
	local bottom = 20

    self.scroll_view = cc.ScrollView:create(cc.size(self.spr_bg:getContentSize().width - 40, top - bottom))
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(20, bottom)
	self:addChild(self.scroll_view)
end

function FirstItemRewardLayer:exitCallBack()
	if self.eventData ~= nil and self.eventData.event ~= "" then 
		ex.EventManager:fire(self.eventData.event,self.eventData.data)
	end
	self.eventData = nil
end


-----------------------------------------------------------------------------
function FirstItemRewardCtr:onCreate()
	self:setCCBIPath("ccbi/ItemRewardLayer.ccbi")
	self:setIsSingle(false)
end

function FirstItemRewardCtr:getLayerClass()
	return FirstItemRewardLayer
end

function FirstItemRewardCtr:getFirstItemRewardLayer()
	return self.layer
end

function FirstItemRewardCtr:openWindow()
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/summon-effect.plist")
    sfc:addSpriteFrames("ccbi-res/reward-layer.plist")

	self:loadLayer()
	self:open()

	self:_spineHandler()

	ex.AudioManager:playEffect("music/item-get.mp3")
end

function FirstItemRewardCtr:_spineHandler()
	local spr_spine = sp.SkeletonAnimation:create("spine/zuanshi02.json","spine/zuanshi02.atlas", 1)
	spr_spine:setAnimation(0, "ect1", false)
	spr_spine:setPosition(
		self.layer.spr_bg:getPositionX(),
		self.layer.spr_bg:getPositionY() - (self.layer.spr_bg:getContentSize().height * 0.2)
	)
	self.layer.spr_bg:addChild(spr_spine)

	spr_spine:registerSpineEventHandler(function(e)
		if e.animation == 'ect1' then
			spr_spine:setAnimation(0, "ect2", true)
			local action = cc.Sequence:create(
				cc.FadeOut:create(1),
				cc.CallFunc:create(function()
					self:closeWindow(0, nil)
				end),
				nil
			)
			spr_spine:runAction(action)
		end
	end, sp.EventType.ANIMATION_COMPLETE)
end

return FirstItemRewardCtr
