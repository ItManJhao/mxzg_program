local UIMenuItemMainCity = class("UIMenuItemMainCity", function (params1, params2, params3)
	return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
end)


function UIMenuItemMainCity:ctor()

end

function UIMenuItemMainCity:createWithIcon(str_icon, callback)
	local pRet = UIMenuItemMainCity:create(str_icon, nil, nil)
	-- local pRet = UIMenuItemMainCity:create(str_icon, nil, nil)
	if pRet then
		pRet:initDone(callback)
		return pRet
	end
	pRet = nil
	return nil
end


function UIMenuItemMainCity:initDone(callback)
	if  callback then
		self:registerScriptTapHandler(callback)
	end
end

return UIMenuItemMainCity
