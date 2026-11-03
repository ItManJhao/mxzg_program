local UIMenuItemHead = class("UIMenuItemHead", function (params1, params2, params3)
	return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
end)


function UIMenuItemHead:onInit(head_id, is_selected, is_used)
	self.head_id = head_id or 0
	self.is_selected = is_selected or false
	self.is_used = is_used or false
	local is_active = ex.Player.border_data:headActiveById(head_id)
	local img = self:getNormalImage()
	ex.Tools:setGrayAuto(img,(not is_active))
	self.spr_selected = nil
	self.spr_used = nil
end

function UIMenuItemHead:initDone()
	--self:setEnableAction(false)

	self:setSelected(self.is_selected)
	self:setUsed(self.is_used)
	local sp = cc.Sprite:createWithSpriteFrameName(string.format("head-icon/%d.png", self.head_id))
	if not sp then 
		dump(sp,self.head_id)
	end
end

function UIMenuItemHead:setSelected(is_selected)
	if not self.spr_selected  then
		local btn_size = self:getContentSize()
		self.spr_selected = cc.Sprite:createWithSpriteFrameName("head-icon/spr-selected.png")
		:setPosition(btn_size.width / 2, btn_size.height / 2)
		self:addChild(self.spr_selected, 1)

		-- self.spr_selected:setCascadeOpacityEnabled(true)
	end

	self.is_selected = is_selected
	self.spr_selected:setVisible(is_selected)

	if is_selected then
		self.spr_selected:setOpacity(255)
		self.spr_selected:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeOut:create(1.0),
			cc.FadeIn:create(0.4))))
	else
		self.spr_selected:stopAllActions()
	end
end

function UIMenuItemHead:setUsed(is_used)
	if not self.spr_used  then
		local btn_size = self:getContentSize()
		self.spr_used = cc.Sprite:createWithSpriteFrameName("other/spr-used.png")
		:setPosition(btn_size.width * 0.6 , btn_size.height * 0.16)
		:setRotation(-15)
		self:addChild(self.spr_used, 2)
	end

	self.is_used = is_used
	self.spr_used:setVisible(is_used)
end

function UIMenuItemHead:isSelected()
	return self.is_selected
end

function UIMenuItemHead:isUsed()
	return self.is_used
end

function UIMenuItemHead:createHead(head_id, is_selected, is_used)
	local pRet = UIMenuItemHead:create(string.format("head-icon/%d.png", head_id), nil, nil)
	if pRet then
		pRet:onInit(head_id, is_selected, is_used)
		pRet:initDone()
		return pRet
	end
	return nil
end


return UIMenuItemHead