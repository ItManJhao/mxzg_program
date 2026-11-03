local Effect = class("Effect")
local _effect = cfg.effect.effect

function Effect:ctor()
	self.anim = require("src.effect.AniBase").new()
	self.info = nil
	self.effLayer = nil 
	self.zOrder = 0
	self.is_Free = false
	self.effId = 0

	-- self.layer = ex.PoolManager.nodePool:getItem()
	self.layer = cc.Node:create()
	-- self.layer:setCascadeOpacityEnabled(true)
end

function Effect:playEff(effid,x,y,rotate,layer,zOrder,sX,sY,loadComCallBack,overCallBack,param, timeScale)

	-- print(" Effect:playEff", loadComCallBack, timeScale)
	-- print(" Effect:playEff", effid,x,y,rotate,layer,zOrder,sX,sY,loadComCallBack,overCallBack,param, timeScale)
	if self.is_Free then return end

	self.effId = effid 
	local info = _effect[self.effId]

	if not info then print(self.__cname,self.effId , "is not config") return end
	self.param = param
	self.info = info
	self.anim.loadComCallBack = loadComCallBack
	self.anim.overCallBack = overCallBack

	self._realPlayAnim = function ()
		self:realPlayAnim(effid,x,y,rotate,layer,zOrder,sX,sY, timeScale)
	end

	if info.sdelay == 0 then 
		self._realPlayAnim()

	else
		local token = "effect"
		if self.is_UI then token = "ui_effect" end
		if self.timerId then 
			ex.Timer:removeTimerById(self.timerId)
			self.timerId = nil
		end
		self.timerId = ex.Timer:addFrame(info.sdelay,self._realPlayAnim,false,nil,token)
	end
end

function Effect:realPlayAnim(effid,x,y,rotate,layer,zOrder,sX,sY, timeScale)

	local info = self.info
	if not info then print(self.__cname,self.effId , "is not config") return end
	local scaleX = 1
	if sX ~= nil then 
		scaleX = sX / 100
	elseif info.scalex ~= 0 then 
		scaleX = info.scalex / 100
	end
	self:setScaleX(scaleX)

	local scaleY = 1
	if sY ~= nil then 
		scaleY = sY / 100
	elseif info.scaley ~= 0 then 
		scaleY = info.scaley / 100
	end
	self:setScaleY(scaleY)
	self.anim:setFlippedX(info.flippedX == 1)

	local r = rotate
	if not r or r == 0 then r = info.rotation end
	self.layer:setRotation(r)
	self.layer:setPositionX(x)
	self.layer:setPositionY(y)
	self.anim:addTo(self.layer)

	if info.fadein ~= "" and info.fadein > 0 then 
		self.layer:setOpacity(0)
		self.layer:runAction(cc.FadeIn:create(info.fadein / 1000 * timeScale))
	end

	if info.aniscale ~= "" then 
		self.layer:setScale(info.aniscale[1] / 100,info.aniscale[2] / 100)
	end 
	-- print(debug.traceback())
	if layer then self:setEffLayer(layer,(zOrder or 0)) end

	self:addTo(self.effLayer,self.zOrder)

	self:play(info.id,info.plist,info.fileName,info.sframe,info.eframe,info.delay,info.isloop == 1, timeScale)
end

function Effect:play(effid,plist,fileName,sFrame,eFrame,delay,isLoop, timeScale)
	if self.is_Free then return end

	self.anim:playEff(effid,plist,fileName,sFrame,eFrame,delay,isLoop,
		function ()
			if self then 
				self:remove() 
			end
	end,self.param, timeScale)
end

function Effect:setAnchorPoint(x,y)
	if self.layer then 
		self.layer:setAnchorPoint(x,y)
	end

	if self.anim then 
		self.anim:setAnchorPoint(x,y)
	end
end

function Effect:runAction(action)
	if self.anim then 
		self.anim:runAction(action) 
	end
end

function Effect:setScaleX(x)
	if self.layer then 
		self.layer:setScaleX(x)
	end

	if self.anim then 
		self.anim:setScaleX(x)
	end
end

function Effect:setScaleY(y)
	if self.layer then 
		self.layer:setScaleY(y)
	end

	if self.anim then 
		self.anim:setScaleY(y)
	end
end

function Effect:setScale(s)
	if self.layer then 
		self.layer:setScale(s)
	end

	if self.anim then 
		self.anim:setScale(s)
	end
end

function Effect:setVisible(visible)
	if self.layer then 
		self.layer:setVisible(visible)
	end
end

function Effect:isVisible()
	if self.layer then 
		return self.layer:isVisible()
	end
	return false
end

function Effect:addTo(layer , zOrder)
	if layer and not tolua.isnull(layer) then 
		-- layer:addChild(self.layer ,zOrder or 0)
		ex.EffectCtr:addEffTo(layer,self,zOrder)
	else
		self:remove()
	end
end

function Effect:setEffLayer(layer,zOrder)
	self.effLayer = layer 
	self.zOrder = zOrder
end

function Effect:getLayer()
	return self.layer 
end

function Effect:remove()

	if self.timerId then 
		ex.Timer:removeTimerById(self.timerId)
		self.timerId = nil
	end
	if self.is_Free then return end
	self.info = nil
	self.effId = 0 
	self.realPlayAnim = nil
	self.anim:remove()
	self.anim = nil
	if self.layer then 
		self.layer:stopAllActions()
		self.layer:removeFromParent()
		-- ex.PoolManager.nodePool:putItem(self.layer)
		self.layer = nil
	end 
	self.zOrder = nil
	self.is_Free = true
end

return Effect