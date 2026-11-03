local FetterUnlockIcon = class("FetterUnlockIcon", function (params1, params2, params3)
	return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
end)


function FetterUnlockIcon:onNodeEvent(event)
    if event == "exit" then
        self:onExit()
    end
end

function FetterUnlockIcon:onExit()
    for k,v in pairs(self.event_list) do
    	ex.EventManager:remove(v)
    end
end

function FetterUnlockIcon:createMenu()

end

function FetterUnlockIcon:reset(data)
	self.data = data
	
	if self.spine ~= nil then 
		self.spine:removeFromParent()
		self.spine = nil
	end

	local json = string.format("spine/%d.json",data.type)
	local atlas = string.format("spine/%d.atlas",data.type)

	self.spine = sp.SkeletonAnimation:create(json,atlas, 1)
    self.spine:setAnimation(0, "stand", true);
    -- self.spine:setPosition(self:getContentSize().width/2, 50)
    self.spine:setPosition(data.x, data.y)
    self:addChild(self.spine)
    self.spine:setScale(0.5)
    local str = ex.Tools:getLang(data.type + 3000000)
	self.lbl_name:setString(str)
	self:lock(data.vip_level > ex.Player.fetter_data.vip:getVIP())
end

function FetterUnlockIcon:lock(bool)
	self.spr_lock:setVisible(bool)
	ex.Tools:setGrayAuto(self.icon,bool)
	ex.Tools:setGrayAuto(self.spine,bool)
end

function FetterUnlockIcon:getData()
	return self.data 
end

-- function FetterUnlockIcon:initNode()

-- end

function FetterUnlockIcon:createWithData(data)
	local pRet = FetterUnlockIcon:create("", nil, nil)
	if pRet then
		pRet:initDone()
		pRet:reset(data)
		return pRet
	end
	pRet = nil
	return nil
end

function FetterUnlockIcon:initDone()
	self:setContentSize(cc.size(148,155))
	local spr_bg = cc.Sprite:createWithSpriteFrameName("fetters/spr-unlockitem-bg.png")
	local size = spr_bg:getContentSize()
	self:addChild(spr_bg)
	spr_bg:setAnchorPoint(0.5,0.5)
	spr_bg:setPosition(size.width / 2,size.height / 2)
	self:setContentSize(size)

	local icon_bg = cc.Sprite:createWithSpriteFrameName("fetters/spr-unlockitem-title.png")
	self:addChild(icon_bg)
	icon_bg:setPosition(size.width / 2,22)
	icon_bg:setAnchorPoint(0.5,0.5)
	icon_bg:setLocalZOrder(1)

	self.lbl_name = cc.Label:createWithTTF("六六六六六六", FONT_DEFAULT_NAME_BOLD, 20)
	self:addChild(self.lbl_name)
	self.lbl_name:setAnchorPoint(0.5,0.5)
	self.lbl_name:setPosition(size.width / 2,22)
	self.lbl_name:setLocalZOrder(1)

	self.spr_lock = cc.Sprite:createWithSpriteFrameName("fetters/spr-unlockitem-lock.png")
	local lock_size = self.spr_lock:getContentSize()
	self:addChild(self.spr_lock)
	-- self.spr_lock:setPosition(lock_size.width / 2 - 4,22)
	self.spr_lock:setPosition(-4,22)
	self.spr_lock:setAnchorPoint(0.5,0.5)
	self.spr_lock:setLocalZOrder(1)

	self:registerEvent()
end

function FetterUnlockIcon:registerEvent()
	self.event_list = {

	}
end



return FetterUnlockIcon
