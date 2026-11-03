local FetterRewardIcon = class("FetterRewardIcon", function (params1, params2, params3)
	return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
end)


function FetterRewardIcon:onNodeEvent(event)
    if event == "exit" then
        self:onExit()
    end
end

function FetterRewardIcon:onExit()
	self:removeTimer()
    for k,v in pairs(self.event_list) do
    	ex.EventManager:removeById(v)
    end
end

function FetterRewardIcon:createMenu()

end

function FetterRewardIcon:reset(data)
	-- dump(data)
	if not data then return end
	local str = string.format("VIP%d领取",data.vip_level)
	self.lbl_name:setString(str)
	self.icon:setSpriteFrame(string.format("hero-icon/%d.png", data.type))
end

function FetterRewardIcon:lock(bool)
	self.spr_lock:setVisible(bool)
	ex.Tools:setGrayAuto(self.icon,bool)
end

function FetterRewardIcon:getData()
	return self.data 
end

-- function FetterRewardIcon:initNode()

-- end

function FetterRewardIcon:createWithData(data)
	local pRet = FetterRewardIcon:create("", nil, nil)
	if pRet then
		pRet:initDone()
		pRet:reset(data)
		return pRet
	end
	pRet = nil
	return nil
end

function FetterRewardIcon:initDone()
	
	local spr_bg = cc.Sprite:createWithSpriteFrameName("fetters/btn-add.png")
	spr_bg:setLocalZOrder(0)
	local size = spr_bg:getContentSize()
	self:addChild(spr_bg)
	spr_bg:setAnchorPoint(0.5,0.5)
	spr_bg:setPosition(size.width / 2,size.height / 2)
	self:setContentSize(size)

	self.icon = cc.Sprite:createWithSpriteFrameName("hero-icon/10404002.png")
	self:addChild(self.icon)
	self.icon:setAnchorPoint(0.5,0.5)
	self.icon:setPosition(size.width / 2,size.height / 2)
	-- self.icon:setScale(0.6)

	self.lbl_name = cc.Label:createWithTTF("六六六六六六", FONT_DEFAULT_NAME_BOLD, 20)
	self:addChild(self.lbl_name)
	self.lbl_name:setAnchorPoint(0.5,0.5)
	self.lbl_name:setPosition(size.width / 2,0)
	self.lbl_name:setLocalZOrder(1)
	self.lbl_name:enableOutline(cc.c3b(69,37,166), 1)

	local width = math.max(spr_bg:getContentSize().width,self.lbl_name:getContentSize().height)
	local height = spr_bg:getContentSize().height + self.lbl_name:getContentSize().height / 2
	self:setContentSize(cc.size(width,height))
	self:setScale(0.8)
	self:registerEvent()
end

function FetterRewardIcon:registerEvent()
	self.event_list = {

	}
end



return FetterRewardIcon