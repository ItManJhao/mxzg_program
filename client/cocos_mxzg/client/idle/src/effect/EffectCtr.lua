local EffectCtr = class("EffectCtr")

local eff_cfg = cfg.effect.effect

local director = cc.Director:getInstance()

function EffectCtr:ctor()
	self.loadComCallBack = nil

	-- self.deltaTime = 0

	-- self.nowTime = 0

	self.effList = {}

	self.isAddedLoop = false

	self.moverffFreeTime = 0

	self.moveTargetList = {}

	self.followRoleList = {}

	self.moveTargetId = 1

	self.effTimerList = {}

	self.limitTimeEff = {}

	self.totalEffectList = {}

	self:addLoop()
end

function EffectCtr:clear()
	self:removeLoop()
	ex.TimerManager:removeTimerByToken("effect")

	if self.effTimerList and #self.effTimerList > 0 then 
		for i ,timerId in ipairs(self.effTimerList) do 
			ex.TimerManager:removeTimerById(timerId)
		end
	end

	if self.efflist then 
		for layer, v in pairs(self.effList) do 
			for i ,eff in pairs(self.efflist[layer]) do 
				eff:remove()
			end
		end
	end

	self.effList = nil
	self.totalEffectList = nil

end

function EffectCtr:addLoop()
	if not self.isAddedLoop then 
		-- ex.FrameRunner:add(self)

		if not self.timerId then 
			self.timerId = ex.Timer:addFrame(0,handler(self,self.loop),true)
		end
		self.isAddedLoop = true
	end
end

function EffectCtr:removeLoop()
	if self.isAddedLoop then 
		-- ex.FrameRunner:remove(self)
		if self.timerId then 
			ex.Timer:removeTimerById(self.timerId)
			self.timerId = nil
		end
		self.isAddedLoop = false
	end
end

function EffectCtr:loop(dt,ct)
	-- local ctime = ex.TimerManager.nowTime
	-- local etime = 20
	for _,layer in pairs(self.effList) do
		for i,eff in pairs(layer) do
			if eff ~= nil and eff.is_Free == true then 
				layer[i] = nil
			end
		end
	end
end



function EffectCtr:playNormalEff(effId, x, y, rotate, layer, zOrder , loadComCallBack , overCallBack , param, timeScale)
	if not eff_cfg then return nil end

	local info = eff_cfg[effId]
	timeScale = timeScale or 1

	if not info then print(self.__cname,effId , "is not config") return nil end

	-- local scene = cc.Director:getInstance():getRunningScene()
	local scene = cc.Director:getInstance():getRunningScene()

	local eff = require("src.effect.Effect").new()
	if layer then 
		eff:setEffLayer(layer,zOrder)
	else
		eff:setEffLayer(scene,zOrder)
	end

	-- print("EffectCtr:playNormalEff", effId, x, y, rotate, layer, zOrder , loadComCallBack , overCallBack , param, timeScale)
	eff:playEff(effId,x,y,rotate,layer,zOrder,sX,sY,loadComCallBack,overCallBack,param, timeScale)
	return eff
end

function EffectCtr:addEffTo(layer,eff,zOrder)

	if not layer or tolua.isnull(layer) or not eff or not tolua.isnull(eff) then 
		print(self.__cname,"addEffTo" , "layer" , tolua.isnull(layer) , "eff" , tolua.isnull(eff))
		return 
	end

	if not self.effList[layer] then self.effList[layer] = {} end

	if not self.effList[layer][eff] then 
		self.effList[layer][eff] = eff 

		local effLayer = eff:getLayer()

		if effLayer and not tolua.isnull(effLayer) and not effLayer:getParent() and layer and not tolua.isnull(layer) then 
			if zOrder then 
				layer:addChild(eff:getLayer(),zOrder)
			else
				layer:addChild(eff:getLayer(),0)
			end

		end
	end
end

function EffectCtr:removeEffFromLayer(layer,eff)
	if layer and self.effList[layer] then 
		self.effList[layer][eff]:remove()
		self.effList[layer][eff] = nil
	end
end

function EffectCtr:removeAllEffFromLayer(layer)
	if not layer then return end
	if not self.effList[layer] then return end
	for k,v in pairs(self.effList[layer]) do
		v:remove()
		self.effList[layer][v] = nil
	end
	self.effList[layer] = nil
end

return EffectCtr