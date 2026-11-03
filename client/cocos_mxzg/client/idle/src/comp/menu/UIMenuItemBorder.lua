local UIMenuItemBorder = class("UIMenuItemBorder", function (params1, params2, params3)
	return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
end)

local BoderIcon = class("BoderIcon",require("src.comp.EventLayer"))

function BoderIcon:onCreate( )
	
end


function UIMenuItemBorder:onInit(icon_id, is_selected, is_used, can_activate)
	self.icon_id = icon_id or 0
	self.is_selected = is_selected or false
	self.is_used = is_used or false
	self.can_activate = can_activate or false
	self:setName()
end

function UIMenuItemBorder:isActive()
	return ex.Player.border_data:borderActiveById(self.icon_id)
end

function UIMenuItemBorder:autoGray()
	local active = self:isActive()
	ex.Tools:setGrayAuto(self.layer.spr_border,not active)
end

function UIMenuItemBorder:initDone()
	-- self:setEnableAction(false)
	ex.Tools:setSpriteFrame(self.layer.spr_border, ex.Tools:getBorderIconByIdx(self.icon_id))
	-- self.layer.spr_border:setSpriteFrame(ex.Tools:getBorderIconByIdx(self.icon_id))
	self:setSelected(self.is_selected)
	self:setUsed(self.is_used)
	self:setCanActivate(self.can_activate)
	self:autoGray()
end

function UIMenuItemBorder:setName()
	local conf = cfg.border.icon[self.icon_id]
	local str = ex.Tools:getLang(conf.name_lang)
	self.layer.lbl_name:setString(str)
end

function UIMenuItemBorder:setSelected(is_selected)
	self.is_selected = is_selected
	self.layer.spr_selected:setVisible(is_selected)
end

function UIMenuItemBorder:setUsed(is_used)
	self.is_used = is_used
	self.layer.spr_use:setVisible(is_used)
	-- if not self.spr_used  then
	-- 	local btn_size = self:getContentSize()
	-- 	self.spr_used = cc.Sprite:createWithSpriteFrameName("other/spr-used.png")
	-- 	:setPosition(btn_size.width * 0.6 , btn_size.height * 0.16)
	-- 	:setRotation(-15)
	-- 	self:addChild(self.spr_used, 2)
	-- end

	-- self.is_used = is_used
	-- self.spr_used:setVisible(is_used)
end

function UIMenuItemBorder:setCanActivate(can_activate)
	self.can_activate = can_activate
	self.layer.spr_activate:setVisible(can_activate)
end

function UIMenuItemBorder:isSelected()
	return self.is_selected
end

function UIMenuItemBorder:isUsed()
	return self.is_used
end

function UIMenuItemBorder:createHead(icon_id, is_selected, is_used, can_activate)
	local pRet = UIMenuItemBorder:create("", nil, nil)
	if pRet then
		pRet.layer = BoderIcon:createWithCCBIFile("ccbi/BorderIcon.ccbi")
		pRet:addChild(pRet.layer)
		pRet.layer:setPosition(0,0)
		local size = pRet.layer:getContentSize()
		pRet:setContentSize(size)
		pRet:onInit(icon_id, is_selected, is_used, can_activate)
		pRet:initDone()
		return pRet
	end
	return nil
end

return UIMenuItemBorder