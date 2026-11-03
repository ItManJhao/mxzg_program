local UIMenuItemMission = class("UIMenuItemMission", function (params1, params2, params3)
	return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
end)

function UIMenuItemMission:onInit(idx)
	self.idx = idx
end

function UIMenuItemMission:createWithData(icon, idx)
	local pRet = UIMenuItemMission:create(icon, nil, nil)
	if pRet then
		pRet:onInit(idx)
		pRet:initDone()
		return pRet
	end
	pRet = nil
	return nil
end

function UIMenuItemMission:initDone()

end


function UIMenuItemMission:setLock(lock)
	if self.spr_lock then
		self.spr_lock:removeFromParent()
		self.spr_lock = nil
	end

	if lock then
		self.spr_lock = cc.Sprite:createWithSpriteFrameName("main-scene/spr-lock-1.png")
		self.spr_lock:setPosition(self:getContentSize().width * 0.5, self:getContentSize().height * 0.5)
		self:addChild(self.spr_lock, 1);
	end
end

function UIMenuItemMission:setSelected(is_select)
	self.is_selected = is_select

	if self.is_selected then
		self:setColor(cc.WHITE)
	else
		self:setColor(FONT_GRAY)
	end
end

function UIMenuItemMission:setLabelText(str)
	if self.lbl then
		self.lbl:setString(str)
	else
		self.lbl = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 50)
		self.lbl:setScale(0.5)
    	self.lbl:enableOutline(FONT_BLACK_C4B, 3)
		self.lbl:setPosition(self:getContentSize().width * 0.5, self:getContentSize().height * 0.5)
		self:addChild(self.lbl, 1)
	end	
end

return UIMenuItemMission
