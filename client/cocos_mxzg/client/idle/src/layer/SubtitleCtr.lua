local SubtitleCtr = class("SubtitleCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SubtitleLayer = class("SubtitleLayer", require("src.comp.LuaLayerBase"))

function SubtitleLayer:onCreate()
	self.lbl_pre_text = nil
	self.cur_index = 1
	self.vec_text = nil
	self.vec_lbl = {}
	self.offset = 30

	self:setAutoClose(false)
	-- self:setCascadeOpacityEnabled(true)

	local win_size = cc.Director:getInstance():getWinSize()
	-- local height = Maths.min(self:getContentSize().height, win_size.height)
	-- self:setScale(height / self:getContentSize().height)

	
	-- self.spr_bg:setScaleX(win_size.width  / self.spr_bg:getContentSize().width)
	-- self.spr_bg:setScaleY(win_size.height / self.spr_bg:getContentSize().height)
	
	local self_p = self;

	local touch_node = cc.Node:create()
	self:addChild(touch_node)


    self.listener_touch = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
    self.listener_touch:setSwallowTouches(false)
    self.listener_touch:registerScriptHandler(function()
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    self.listener_touch:registerScriptHandler(function()
    end, cc.Handler.EVENT_TOUCH_MOVED)

    self.listener_touch:registerScriptHandler(function(touch, event)
    	self_p:nextText()
    end, cc.Handler.EVENT_TOUCH_ENDED)

    local event_dispatcher = touch_node:getEventDispatcher() 
    event_dispatcher:addEventListenerWithSceneGraphPriority(self.listener_touch, touch_node)


	-- local eff2 = ex.EffectCtr:playNormalEff(14, ex.p.width * 0.5, ex.p.height * 0.5, nil, self, 10)
	-- eff2.anim:setAnchorPoint(0.5, 0)
	-- eff2.anim:getContentSize().width
end

function SubtitleLayer:initText()
	if self.vec_text == nil then
		return
	end

	local begin_x = ex.p.width * 0.1
	local begin_y = ex.p.height * 0.5
	local max_width = ex.p.width * 0.8


	local height = 0
	for i,v in ipairs(self.vec_text) do
		local lbl_text = cc.Label:createWithTTF(v, FONT_DEFAULT_NAME_BOLD, 26);
		lbl_text:setAnchorPoint(cc.p(0, 1))
		lbl_text:setDimensions(max_width, 0)
		lbl_text:setOpacity(0)
		self:addChild(lbl_text)

		table.insert(self.vec_lbl, lbl_text)
		height = height + lbl_text:getContentSize().height + self.offset
	end

	begin_y = begin_y + height * 0.5

	for i,v in ipairs(self.vec_lbl) do
		v.offset_y = begin_y - self.offset
		v:setPosition(begin_x, v.offset_y)
		v:setVisible(false)

		begin_y = v:getPositionY() - v:getContentSize().height
	end
end

function SubtitleLayer:nextText()
	local self_p = self
	local nums = self.vec_text and table.nums(self.vec_text) or 0
	
	print(self.cur_index > nums, self.cur_index , nums)
	if self.cur_index > nums then
		local func_close = function( ... )
			if require("src.layer.SubtitleCtr"):instance():isOpened() then
				require("src.layer.SubtitleCtr"):instance():closeWindow()
			end
		end
		self:runAction(cc.FadeTo:create(0.3, 0))
		self:runAction(cc.Sequence:create(cc.DelayTime:create(0.3), cc.CallFunc:create(func_close)))
		return
	end

	if self.cur_index > 1 then
		local lbl_pre_text = self.vec_lbl[self.cur_index - 1]
		lbl_pre_text:setVisible(true)
		lbl_pre_text:setOpacity(255)
		lbl_pre_text:stopAllActions()
		lbl_pre_text:setPositionY(lbl_pre_text.offset_y)
	end

	local lbl_text = self.vec_lbl[self.cur_index]
	lbl_text:setVisible(true)
	lbl_text:runAction(cc.EaseExponentialOut:create(cc.MoveTo:create(0.7, cc.p(lbl_text:getPositionX(), lbl_text.offset_y))))
	lbl_text:runAction(cc.FadeTo:create(0.3, 255))

	local func_next = function( ... )
		self_p:nextText()
	end

	lbl_text:runAction(cc.Sequence:create(cc.DelayTime:create(2.3), cc.CallFunc:create(func_next)))
	self.cur_index = self.cur_index + 1
end

function SubtitleLayer:clear()
	self.lbl_pre_text = nil
end

-----------------------------------------------------------------------------
function SubtitleCtr:onCreate()
	self:setCCBIPath("ccbi/SubtitleLayer.ccbi")
	self:setIsSingle(false)
end

function SubtitleCtr:getLayerClass()
	return SubtitleLayer
end

function SubtitleCtr:getSubtitleLayer()
	return self.layer
end

function SubtitleCtr:closeWindow()
	self.can_close = false
	self:fastClose()
end

function SubtitleCtr:openWindow(vec_text, is_quick)
	if not vec_text then
		return
	end
	
	dump(vec_text, "vec_text")
	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/guide.plist")

	if self:isOpened() then
		self:updateLayer(vec_text)
		return
	end


	self:loadLayer()
	-- self.open = 
	-- cpp.NodeCtr.open(self)
	self:open()

	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	if is_quick then
		local self_p = self
		ex.Tools:ergodicAllNode(self.layer, function(node)
			-- local action = node:getActionByTag(-999)
			-- if action == nil then
			-- 	node:stopAllActions()
			-- 	node:setOpacity(255)
			-- 	node:setScale(1)
			-- end
			node:stopAllActions()
			node:setOpacity(255)

			if node ~= self_p.layer.spr_bg then
				node:setScale(1)
			end
		end)

		self:openActionEnd()
	else
    	self.layer:setOpacity(0)
		self.layer:runAction(cc.FadeTo:create(0.3, 255))
	end

	local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_guide_fire")
	spr_effect:setPosition(ex.p.width * 0.5, 0)
	spr_effect:setAnchorPoint(cc.p(0.5, 0))
	spr_effect:setScale(ex.p.width / spr_effect:getContentSize().width)
	self.layer:addChild(spr_effect)

	self:updateLayer(vec_text)
end

function SubtitleCtr:updateLayer(vec_text)
	self.layer:clear()

	self.layer.cur_index = 1
	self.layer.vec_text = vec_text
	self.layer:initText()
	self.layer:nextText()
end

return SubtitleCtr
