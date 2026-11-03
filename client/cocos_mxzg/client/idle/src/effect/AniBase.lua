local AniBase = class("AniBase")

local res_manager = require("src.model.ResManager"):instance()

function AniBase:ctor()
	self.eff_cfg = cfg.effect.effect

	self.isLoop = true

	self._callback = nil

	self.sFrame = 0

	self.eFrame = 0

	self.delay = 0.1

	self.isPlayEff = false

	self.curAnim = nil

	self.animOffy = 0

	self.loadComCallBack = nil

	self.overCallBack = nil


	-- self.anim = ex.PoolManager.spritePool:getItem()
	self.anim = cc.Sprite:create()
	self.anim:setAnchorPoint(0.5,0.5)
	self.anim:setGLProgram(cpp.ShaderFactory:instance():getGLProgram(1))
	
	self.anim:registerScriptHandler(function(event)
		if event == "exit" then
			self:removeFrameFile()
		end
	end)
end

function AniBase:playEff(effid,plist,fileName,sFrame,eFrame,delay,isLoop,callback,cbParam, timeScale)
	self.effid = effid
	self.plist = plist
	self.isPlayEff = true
	self.sFrame =sFrame
	self.eFrame = eFrame
	self.delay = delay * 0.001
	self.callback = callback
	self.cbParam = cbParam
	-- self.isLoop = isLoop
	if isLoop ~= false then 
		self.isLoop = true
	else
		self.isLoop = isLoop
	end

	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames(plist)

	local frame = sfc:getSpriteFrame(string.format(fileName, 0))
	-- print("frame", fileName, sFrame, string.format(fileName, 0))
    if frame then
        self.anim:setSpriteFrame(frame)
    end
	
	res_manager:addPlist({plist})

	-- self.anim:setS
	local animate = self:getAnimate(plist,fileName,sFrame, self.delay * timeScale)
	self:runAnim(animate)
end

function AniBase:runAnim(animate)
	if not animate then print(self.plist,"is nil") return end

	local overCallBack = cc.CallFunc:create(function ()
			if self.overCallBack then 
				self.overCallBack(self.cbParam) 
			end
		end)

	animate = cc.Sequence:create(animate,overCallBack)
	if self.isLoop then 
		animate = cc.RepeatForever:create(animate)
	end

	if self.animate then 
		self.animate:release()
		self.animate = nil
	end

	self.animate = animate
	self.animate:retain()
	self:stopAnim()
	if self.callback and not self.isLoop then 
		local cbf = cc.CallFunc:create(function ()
			if self.callback then self.callback(self.cbParam) end
		end)
		local action = cc.Sequence:create(animate,cbf)
		self.anim:runAction(action)
	else
		self.anim:runAction(animate)
	end

	if self.loadComCallBack then 
		self.loadComCallBack(self.param)
	end
end

function AniBase:stopAnim()
	if self.anim then self.anim:stopAllActions() end
end

function AniBase:runAction(action)
	if self.anim then 
		self.anim:runAction(action) 
	end
end

function AniBase:getAnimate(plist,fileName,sFrame,delay)
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames(plist)

    local i = sFrame or 0
    local frames = {}
    while i do 
    	local str = string.format(fileName,i)
    	local frame = sfc:getSpriteFrame(str)
    	if not frame then break end
    	table.insert(frames,frame)
    	i = i + 1
    end
	local animation = cc.Animation:createWithSpriteFrames(frames)
	animation:setDelayPerUnit(delay)
	local animate = cc.Animate:create(animation)

	return animate
end

function AniBase:rePlay()
	if self.anim and self.animate then 
		self:stopAnim()

		if self.callback and not self.isLoop then
			local cbf = cc.CallFunc:create(function ()
				if self.callback then self.callback(self.cbParam) end
			end)
			local action = cc.Sequence:create(self.animate,cbf)
			self.anim:runAction(action)
		else
			self.anim:runAction(self.animate)
		end
	end

end

function AniBase:setAnchorPoint(x,y)
	self.anim:setAnchorPoint(x,y)
end

function AniBase:setPosition(x,y)
	self.anim:setPosition(x,y)
end

function AniBase:setScaleX(x)
	if self.anim then 
		self.anim:setScaleX(x)
	end
end

function AniBase:setScaleY(y)
	if self.anim then 
		self.anim:setScaleY(y)
	end
end

function AniBase:getParent()
	return self.anim:getParent()
end

function AniBase:addTo(parent,zOrder)
	if parent and not tolua.isnull(parent) and not tolua.isnull(self.anim) then 
		if zOrder == nil then zOrder = 0 end
		parent:addChild(self.anim,zOrder)
	end
	
end

function AniBase:getAnim()
	return self.anim 
end

function AniBase:getCurFrame()
	return self.anim:getSpriteFrame()
end

function AniBase:getContentSize()
	if self.anim then 
		return self.anim:getContentSize()
	end
	return nil
end

function AniBase:removeTo()
	if self.anim then 
		self.anim:removeFromParent()
		-- ex.PoolManager.spritePool:putItem(self.anim)
	end
	self.anim = nil
end

function AniBase:isFlippedX()
	return self.anim:isFlippedX()
end

function AniBase:setFlippedX(x)
	if self.anim then 
		self.flippedX = x 
		self.anim:setFlippedX(x)
	end
end

function AniBase:setRotation(r)
	if self.anim then 
		self.anim:setRotation(r)
	end
end

function AniBase:setOpacity(o)
	if self.anim then 
		self.anim:setOpacity(0)
	end
end

function AniBase:setScale(s)
	if self.anim then 
		self.anim:setScale(s)
	end
end

function AniBase:resume()
	if self.anim then 
		self.anim:resume()
	end
end

function AniBase:pause()
	if self.anim then 
		self.anim:pause()
	end
end

function AniBase:remove()
	if self.animate then 
		self.animate:release()
		self.animate = nil
	end
	self.callback = nil
	self.isPlayEff = nil
	self.sFrame =nil
	self.eFrame = nil
	self.delay = nil
	self.callback = nil
	self.cbParam = nil
	self.isLoop = nil
	self:removeTo()
	self:removeFrameFile()
end

function AniBase:removeFrameFile()
	-- local sfc = cc.SpriteFrameCache:getInstance()
	-- sfc:removeSpriteFramesFromFile(self.plist)

	-- 这个判断或许可以去掉（未测试）
	if self.is_remove_plist == nil then
		self.is_remove_plist = true
		res_manager:removePlist({self.plist})
	end
	self.plist = nil
end


return AniBase