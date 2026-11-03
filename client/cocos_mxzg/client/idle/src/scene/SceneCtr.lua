local SceneCtr = class("SceneCtr", require("src.scene.NodeCtr"))
local node_protected = nil

local AnimationFactory = require("src.anim.AnimationFactory")
local AsynNode = require("src.comp.AsynNode")
local vec_scene_ctr = {}

function SceneCtr:ctor()
   self.is_entering = false
   self.is_load_finish = false
   self.layer = nil

   local table_leng = table.nums(vec_scene_ctr)
   vec_scene_ctr[table_leng] = self

   if self.onCreate then self:onCreate() end
end

function SceneCtr:isRuning()
	return self.scene == display.getRunningScene()
end

function SceneCtr:getScene()
	return self.layer
end

function SceneCtr:getLayerClass()
	return cc.Layer
end

function SceneCtr:loadLayer(scene)
	scene.scene_ctr = self
	self.scene = scene
	self.layer = self:getLayerClass():create()
	scene:addChild(self.layer)
  	
	-- scene.scene_ctr = self

	-- self.scene = scene
	-- self.layer = cc.Layer:create()
	-- cc.Label:createWithSystemFont("incorrect use of Scene", "Arial", 40)
 --        :move(display.cx, display.cy)
 --        :addTo(self.layer)
 --        :setVisible(false)

 --    self:getEnterAnimationNode(0)
 --        :addTo(self.layer)

	-- scene:addChild(self.layer)
	-- self.layer:showWithScene(transition, time, more)
end

function SceneCtr:getSceneCtrType()
	return 0
end


function SceneCtr:getEnterAnimationNode(opacity)
	-- math.randomseed(tostring(require("socket").gettime()):reverse():sub(1, 6))

	-- local r = math.random(6)
	-- local plist_name = string.format("ccbi-res/loading%d.plist", r)
	-- local image_name = string.format("ccbi-res/loading%d.pvr.ccz", r)
	-- local frames_format = string.format("#loading%d/%%02d.png", r)

	local viewsize = cc.Director:getInstance():getWinSize()

	-- display.loadSpriteFrames(plist_name, image_name)


-- 保护节点
	local node = cpp.ProtectedNodeEx:create()

-- 	local node_parent = cc.Node:create()
-- 	node_parent:setTag(1000)
-- 	-- node_parent:setScale(2)
-- 	node:addChild(node_parent)

-- -- 添加logo背景
-- 	local r = 1
--     local logo = cc.Sprite:create(string.format("ccbi-base/map-bg-loading-%d.png", r))
--     local scale_x = viewsize.width / logo:getContentSize().width
--     local scale_y = viewsize.height / logo:getContentSize().height
--     logo:setScale(scale_x > scale_y and scale_x or scale_y)
--     logo:setPosition(cc.p(viewsize.width * 0.5, viewsize.height * 0.5))
--     node_parent:addChild(logo)

-- 黑色背景
	-- display.newLayer(cc.c4b(0, 0, 0, 10), viewsize.width, viewsize.height)
 --        : addTo(node_parent)
 --        : setOpacity(opacity)

-- logo
	-- local loop_time = 5
	-- local animate_time = {}
	-- local animate = AnimationFactory:createAnimate(string.sub(frames_format, 2), 0.15, animate_time)
	-- local delay = cc.DelayTime:create(math.max(0, loop_time - animate_time[0]))
	-- local sequence = cc.Sequence:create(cc.Show:create(), animate, cc.Hide:create(), delay , nil)

	-- -- print("display.cx, display.cy", viewsize.cx, display.cy)
	-- display.newSprite(string.format(frames_format, 0))
	-- 	: move(viewsize.width * 0.5, viewsize.height*0.5)
	-- 	: addTo(node_parent)
	-- 	: setOpacity(opacity)
	-- 	: runAction(cc.RepeatForever:create(sequence))



	-- local vec_tip = {ex.Tools:getLang(47242),
	-- 				 ex.Tools:getLang(47091)}

	-- cc.Label:createWithSystemFont(vec_tip[math.random(2)], "Arial", 40)
	-- 		: move(viewsize.width * 0.5, viewsize.height * 0.5 - 100)
	-- 	 	: addTo(node_parent)
	-- 	  	: setScale(0.5)
	-- 	  	: setOpacity(opacity)
	
-- loading str
	-- local str_loading = "Loading..."
	-- local str_len = string.len(str_loading)
	-- for i=0, str_len do
	-- 	cc.Label:createWithSystemFont(string.sub(str_loading,i,i), "Arial", 40)
	-- 	  : move(viewsize.width * 0.5 - 20 * str_len * 0.5 + 20 * i, viewsize.height * 0.5 - 100)
	-- 	  : addTo(node_parent)
	-- 	  : setScale(0.5)
	-- 	  : setOpacity(opacity)
	-- end

	-- print("1111", node)
	return node
end

function SceneCtr:runOutAnimation(node)
	AnimationFactory:allChildrenFade(node, 0.5, 255)
	return 0
	-- return 10
end

function SceneCtr:runEnterAnimation(node)
	AnimationFactory:allChildrenFade(node, 0.5, 0)
	return 0
	-- return 10
end


function SceneCtr:instance()

end

function SceneCtr:enterWithAnimation()
	if self.is_entering then
		return
	end
	self.is_entering = true
	self.is_load_finish = false

	local running_scene = display.getRunningScene()
	-- print(tolua.type(你的对象))
	
	if running_scene then
		if not node_protected then
			node_protected = self:getEnterAnimationNode(255)
			running_scene:addChild(node_protected, 99)

			local listenner = cc.EventListenerTouchOneByOne:create()
			listenner:registerScriptHandler(function(touch, event)  
   					print("onTouch")  
   					return true  
				end, cc.Handler.EVENT_TOUCH_BEGAN )

			listenner:registerScriptHandler(function(touch, event)
   					print("onTouchMoved")  
				end, cc.Handler.EVENT_TOUCH_MOVED )  

			listenner:registerScriptHandler(function(touch, event)  
   					print("onTouched")  
			end, cc.Handler.EVENT_TOUCH_ENDED )

			cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listenner, node_protected)

			local self_p = self;
			local anim_time	= self:runOutAnimation(node_protected)
			self_p:startChangeScene(0)
			-- local callbackEntry = nil
			-- callbackEntry = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
			-- 		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(callbackEntry)
      		-- 		self_p:startChangeScene(0)
			-- end, anim_time, false)
		else
			-- node_protected:retain()
			node_protected:removeFromParent()
			running_scene:addChild(node_protected, 99)

			local self_p = self;
			local anim_time	= self:runEnterAnimation(node_protected)
			self_p:startChangeScene(0)
			-- local callbackEntry = nil
			-- callbackEntry = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
			-- 		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(callbackEntry)
      		-- 		self_p:startChangeScene(0)
      		-- end, anim_time, false)
		end
	else
		-- local scene = display.newScene(self.__cname)
		self:enter()
		self:didEnter()
		-- display.runScene(scene, "fade", 0.5)
		-- self:didEnter()
	end
end

function SceneCtr:releaseOldScene()
	local running_scene = display.getRunningScene()
	-- 旧场景退出
	-- running_scene:removeFromParent()
	if running_scene.scene_ctr and running_scene.scene_ctr.onExit then
		running_scene.scene_ctr:onExit()
	end

	-- 加载临时场景
	local scene = display.newScene("tmp-change-scene")
	if node_protected then
		-- node_protected:retain()
		node_protected:removeFromParent()
		scene:addChild(node_protected)
	end
	
	-- 替换旧的场景
	display.runScene(scene)
end

function SceneCtr:startChangeScene(dt)
	self:releaseOldScene()
	self:enter()

	cc.Director:getInstance():pause()
	cc.Director:getInstance():mainLoop()
	cc.Director:getInstance():resume()
	
	self:loadImageFile()
	self:didEnter()
	-- local self_p = self
	-- -- self_p:didEnter()
	-- local callbackEntry = nil
	-- callbackEntry = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
	-- 	if self_p:isLoadingFinish() ~= true then
	-- 		return
	-- 	end
	-- 	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(callbackEntry)
    --   	self_p:didEnter()
	-- end, 0.01, false)
end

function SceneCtr:getAsynImage()

end

function SceneCtr:loadImageFile()
	local self_p = self
	-- 界面加载失败
	if not self.layer then
		return
	end

	local node_asyn = AsynNode:create()
	node_asyn.callback = function(cur, count, is_finish)
		self_p:asynCallback(cur, count, is_finish)
	end
	node_asyn.vec_image = self:getAsynImage()
	self.layer:addChild(node_asyn)
	node_asyn:startAsynLoad()
end

function SceneCtr:isLoadingFinish()
	return true
end

function SceneCtr:asynCallback(cur, count, is_finish)

end

function SceneCtr:addProtocolWaiting(net_protocol)
	if self.vec_protocol == nil then
		self.vec_protocol = {}
	end
	self.vec_protocol[net_protocol] = false
end

function SceneCtr:receivedProtocol(net_protocol)
	if self.vec_protocol == nil then
		return
	end
	self.vec_protocol[net_protocol] = true
end


function SceneCtr:enter()
	local scene = display.newScene(self.__cname)
	self:loadLayer(scene)

	if node_protected then
		node_protected:removeFromParent()
		scene:addChild(node_protected, 99)
	end
	display.runScene(scene)

end

function SceneCtr:didEnter()
	if node_protected then
		local tmp_node_protected = node_protected 
		node_protected = nil
		tmp_node_protected:removeAllChildren()
		tmp_node_protected:removeFromParent()
		tmp_node_protected:destroy(true)
	end
	self.is_entering = false
end

function SceneCtr:getRunningSceneCtr()
	for k,v in pairs(vec_scene_ctr) do
		if v:isRuning() then
			return v
		end
	end

	return nil
end

return SceneCtr
