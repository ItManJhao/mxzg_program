local UIMenu = class("UIMenu", function ()
	return cpp.UIMenu:create()
end)


function UIMenu:ctor()
	self:registerTouchScriptHandler(handler(self, self.onMenuEvent))
end

function UIMenu:onMenuEvent(event, params1, params2, params3, params4)
	if self[event] then
		self[event](self, params1, params2, params3, params4)
	end
	
end

function UIMenu:getHeroSelect()
	local vec_hero = {}

	local children = self:getChildren()
	for i,v in ipairs(children) do
		local node = v
		if node.getHeroId and node.isSelected and node:isSelected() then
			table.insert(node:getHeroId())
		end
	end
	return vec_hero
end


function UIMenu:getItemByHeroId(hero_id)
	local children = self:getChildren()
	for i,v in ipairs(children) do
		local node = v
		--print("12312", node.getHeroId, node:getHeroId(), hero_id)
		if node.getHeroId and node:getHeroId() == hero_id then
			return node
		end
	end
	return nil
end


function UIMenu:unselectAll()

	local children = self:getChildren()
	for i,v in ipairs(children) do
		local node = v
		if node.setSelected then
			node:setSelected(false, node)
		end
	end
	
	return nil
end

function UIMenu:setExchangeCallback(callback)
	self.exchange_callback = callback
end

function UIMenu:setTouchMoveCallback(callback)
	self.touch_move_callback = callback
end

function UIMenu:setTouchEndCallback(callback)
	self.touch_end_callback = callback
end

function UIMenu:onTouchBegan(touch, event)
	self.item_touch = nil
	self.touch_begin = self:convertToNodeSpace(touch:getLocation())

	return self:getTouchItem(self.touch_begin) ~= nil
end

function UIMenu:onTouchMoved(touch, event)
	local touch_pos = self:convertToNodeSpace(touch:getLocation())
	local is_move = math.abs(self.touch_begin.x - touch_pos.x) > UI_ENABLE_MOVE_DISTANCE or math.abs(self.touch_begin.y - touch_pos.y) > UI_ENABLE_MOVE_DISTANCE

	if not is_move then
		return
	end
	if not self.item_touch then
		self.item_touch = self:getTouchItem(touch_pos)
		if self.item_touch then
			self.item_z = self.item_touch:getLocalZOrder()
			self.item_pos = {}
			self.item_pos.x , self.item_pos.y = self.item_touch:getPosition()

			self.item_touch:setLocalZOrder(9999)
		end
		return
	end

	if self.exchange_callback then
		if self.item_touch:isEnabled() then
			self.item_touch:setPosition(touch_pos)
		end
	elseif self.touch_move_callback ~= nil then
		self.touch_move_callback(self.item_touch, touch_pos)
	end
end

function UIMenu:onTouchEnded(touch, event)
	local touch_pos = self:convertToNodeSpace(touch:getLocation())

	if self.item_touch then
		local item_exchange = self:getTouchItem(touch_pos, self.item_touch)

		-- 检查回调函数
		if self.exchange_callback then
			-- 是否可以跟其他交换
			if item_exchange then
				-- 调用回调。如果返回值为真。则自动交换位置。返回假。则不执行位置相关操作
				if self.exchange_callback(self.item_touch, item_exchange) then
					-- 交换位置
					local x, y = item_exchange:getPosition()
					self.item_touch:setLocalZOrder(self.item_z)
					self.item_touch:setPosition(x, y)
					item_exchange:setPosition(self.item_pos)
				end
			else
				self.item_touch:setLocalZOrder(self.item_z)
				self.item_touch:setPosition(self.item_pos)
			end
		elseif self.touch_end_callback ~= nil then
			self.touch_end_callback()
		end
	end

	self.item_z = nil
	self.item_pos = nil
	self.item_touch = nil
end

function UIMenu:onTouchCancel(touch, event)
	self:onTouchEnded(touch, event)
end

function UIMenu:getTouchItem(pos, exinclude)
	local children = self:getChildren()

	for i,v in ipairs(children) do
		local node = v
		if node ~= exinclude then
			local rect = node:getBoundingBox()
			if cc.rectContainsPoint(rect, pos) then
				return node
			end
		end
	end

	return nil
end

function UIMenu:enableExchange(is_enable, is_swallow)
	if is_enable then
		if not self.listener_exchange then
			self.listener_exchange = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
    		self.listener_exchange:setSwallowTouches(is_swallow ~= nil and is_swallow or false)
    		self.listener_exchange:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN )
    		self.listener_exchange:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED )
    		self.listener_exchange:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED )
			self.listener_exchange:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_CANCELLED )
    		local event_dispatcher = self:getEventDispatcher() 
    		event_dispatcher:addEventListenerWithSceneGraphPriority(self.listener_exchange, self)
		end
	elseif self.listener_exchange then
		local event_dispatcher = self:getEventDispatcher() 
		event_dispatcher:removeEventListener(self.listener_exchange)
		self.listener_exchange = nil
	end
end

function UIMenu:longPress(menu, pSender)
	print(menu, pSender)
	if self.long_press_callback and pSender then
		self.long_press_callback(pSender:getTag(), pSender)
	end
end

function UIMenu:setLongPressCallback(callback)
	self.long_press_callback = callback
end

return UIMenu
