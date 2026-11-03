local UIMenuGeneral = class("UIMenuGeneral", function ()
	return cpp.UIMenuGeneral:create()
end)


function UIMenuGeneral:ctor()
	self:registerTouchEventScriptHandler(handler(self, self.onNodeEvent))
end

function UIMenuGeneral:onNodeEvent(event, params1, params2, params3, params4)
	if self[event] then
		self[event](self, params1, params2, params3, params4)
	end
end

function UIMenuGeneral:itmeTouchBegan(touch_node)

end

function UIMenuGeneral:itmeTouchMoved(touch_node)
	
end

function UIMenuGeneral:itmeTouchEnded(touch_node)
	if touch_node and self.callback then
		self.callback(touch_node:getTag(), touch_node)
	end
end

function UIMenuGeneral:itmeTouchCancelled(touch_node)
	
end

function UIMenuGeneral:setTouchCallback(callback)
	self.callback = callback
end

function UIMenuGeneral:unselectAll()
	local children = self:getChildren()
	for i,v in ipairs(children) do
		local node = v
		if node.setSelected then
			node:setSelected(false)
		end
	end
	return nil
end

return UIMenuGeneral
