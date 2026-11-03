

--cpp.LuaLayer.__ctype = 1

-- bug
-- 富文本中包含 &# 会导致引擎崩溃
-- const char* StrPair::GetStr() 需要将 while( p < _end ) 改成 while( p < _end && p != NULL )

local RichTextEx = class("RichTextEx", function(params1, params2)
                                 	return cpp.RichTextEx:createWithXMLLua("")
                            end)

function RichTextEx:ctor()
	self:registerHandler(handler(self, self.onNodeEvent))
end

function RichTextEx:onNodeEvent(event, params1, params2, params3, params4, params5, params6)
	print("event", event, params1, params2, params3, params4, params5, params6)
	return self[event](self, params1, params2, params3, params4, params5, params6)
end

function RichTextEx:setCallback(func)
	self.url_callback = func
end

function RichTextEx:openUrl(url)
	if self.url_callback ~= nil then
		self.url_callback(url)
	end
end

function RichTextEx:removeCallback()
	self.url_callback = nil
end

return RichTextEx
   