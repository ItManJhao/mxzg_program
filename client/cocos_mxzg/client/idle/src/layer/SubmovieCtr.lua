local SubmovieCtr = class("SubmovieCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SubmovieLayer = class("SubmovieLayer", require("src.comp.EventLayer"))

function SubmovieLayer:onCreate()
	self:setAutoClose(false)
	self:removeAllChildren()
	-- local layer = cc.LayerColor:create(cc.c4b(0,0,0,255), ex.p.width, ex.p.height)
	-- self:addChild(layer)
	local main_scene = require("src.scene.MainSceneCtr"):instance():getMainScene()
	if main_scene then
		main_scene:setVisible(false)
	end

    local menu = cpp.UIMenu:create()
    menu:setPosition(cc.p(0, 0))
    self:addChild(menu, 99999)

    self.btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("guide/btn-1.png", nil, nil)
    self.btn_close:setPosition(ex.p.width * 0.8, ex.p.height * 0.9)
    menu:addChild(self.btn_close)

	-- self:setCascadeOpacityEnabled(true)
	if device.platform == "android" or device.platform == "ios" then

		if device.platform == "android" then
			self.video_player = ccexp.VideoPlayer:create()
			local function onVideoEventCallback(sener, eventType)
				if eventType == ccexp.VideoPlayerEvent.PLAYING then
				elseif eventType == ccexp.VideoPlayerEvent.PAUSED then
					self.video_player:play()
				elseif eventType == ccexp.VideoPlayerEvent.STOPPED then
				elseif eventType == ccexp.VideoPlayerEvent.COMPLETED then
					self.video_player:stop()
					-- self.video_player:runAction(cc.Sequence:create(cc.RemoveSelf:create()))
					local act_remove = cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function()
						SubmovieCtr:instance():closeWindow()
						ex.AudioManager:setPlayMusic(ex.AudioManager:isPlayMusic())
						-- ex.Tools:autoPlaySceneMusic()
					end))
					self:runAction(act_remove)
				end
			end
			self.video_player:addEventListener(onVideoEventCallback)
		elseif device.platform == "ios" then
			self.video_player = ccui.VideoPlayer:create()
			local function onVideoEventCallback(sener, eventType)
				if eventType == ccexp.VideoPlayerEvent.PLAYING then
				elseif eventType == ccexp.VideoPlayerEvent.PAUSED then
					self.video_player:play()
				elseif eventType == ccexp.VideoPlayerEvent.STOPPED then
				elseif eventType == ccexp.VideoPlayerEvent.COMPLETED then
					self.video_player:stop()
					-- self.video_player:runAction(cc.Sequence:create(cc.RemoveSelf:create()))
					local act_remove = cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function()
						SubmovieCtr:instance():closeWindow()
						ex.AudioManager:setPlayMusic(ex.AudioManager:isPlayMusic())
						-- ex.Tools:autoPlaySceneMusic()
					end))
					self:runAction(act_remove)
				end
			end
			self.video_player:addEventListener(onVideoEventCallback)
		end
		

		self.video_player:setContentSize(cc.size(ex.p.width,ex.p.height))
		self.video_player:setAnchorPoint(cc.p(0.5, 0.5))
		self.video_player:setPosition(cc.p(ex.p.width/2, ex.p.height/2))
		self.video_player:setFullScreenEnabled(false)
		self:addChild(self.video_player)
		
		local touch_node = cc.Node:create()
		self:addChild(touch_node, 9999)
		self.listener_touch = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
		self.listener_touch:setSwallowTouches(true)
		self.listener_touch:registerScriptHandler(function()
			return true
		end, cc.Handler.EVENT_TOUCH_BEGAN)

		self.listener_touch:registerScriptHandler(function()
		end, cc.Handler.EVENT_TOUCH_MOVED)

		self.listener_touch:registerScriptHandler(function(touch, event)
		end, cc.Handler.EVENT_TOUCH_ENDED)

		local event_dispatcher = touch_node:getEventDispatcher() 
		event_dispatcher:addEventListenerWithSceneGraphPriority(self.listener_touch, touch_node)
	

	else
		local act_remove = cc.Sequence:create(cc.DelayTime:create(0.6), cc.CallFunc:create(function()
				ex.MessageView:add(ex.Tools:getLang(47136))
                SubmovieCtr:instance():closeWindow()
                -- ex.Tools:autoPlaySceneMusic()
                ex.AudioManager:setPlayMusic(ex.AudioManager:isPlayMusic())
			end))
		self:runAction(act_remove)
	end
end

function SubmovieLayer:onExit()
	local main_scene = require("src.scene.MainSceneCtr"):instance():getMainScene()
	if main_scene then
		main_scene:setVisible(true)
	end
	ex.AudioManager:setPlayMusic(ex.AudioManager:isPlayMusic())
end

-----------------------------------------------------------------------------
function SubmovieCtr:onCreate()
	self:setCCBIPath("ccbi/SubtitleLayer.ccbi")
	self:setIsSingle(false)
end

function SubmovieCtr:getLayerClass()
	return SubmovieLayer
end

function SubmovieCtr:closeWindow()
	self.can_close = false
	self:fastClose()
end

function SubmovieCtr:openWindow(movie)
	if not movie then
		return
	end

	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()

    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    
    ex.AudioManager:stopMusic()

    if device.platform == "android" or device.platform == "ios" then
        self.layer.video_player:setFileName(movie)
        self.layer.video_player:play()
        ex.AudioManager.is_play_music = false
    else
        ex.AudioManager.is_play_music = false 
    end
end

return SubmovieCtr
