local FetterSkillIcon = class("FetterSkillIcon", function (params1, params2, params3)
	return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
end)


function FetterSkillIcon:onNodeEvent(event)
    if event == "exit" then
        self:onExit()
    end
end

function FetterSkillIcon:onExit()
	self:removeTimer()
    for k,v in pairs(self.event_list) do
    	ex.EventManager:removeById(v)
    end
end

function FetterSkillIcon:createMenu()

end

function FetterSkillIcon:reset(data)
	local fetter_type = type(data) == "number" and data or data.type

	self.fetter_type = fetter_type
	self.skill_type = ex.Player.fetter_data:getSkillType(fetter_type)
	ex.Tools:setSpriteFrame(self.icon, "skill-icon/".. self.skill_type .. ".png")
	self.lbl_name:setString(ex.Tools:getLang(10000000 + self.skill_type))
end

function FetterSkillIcon:lock(bool)
	self.spr_lock:setVisible(bool)
	ex.Tools:setGrayAuto(self.icon,bool)
end

function FetterSkillIcon:getData()
	return self.data 
end

-- function FetterSkillIcon:initNode()

-- end

function FetterSkillIcon:createWithData(data)
	local pRet = FetterSkillIcon:create("", nil, nil)
	if pRet then
		pRet:initDone()
		-- pRet:reset(data)
		return pRet
	end
	pRet = nil
	return nil
end

function FetterSkillIcon:initDone()
	self:setContentSize(cc.size(148,155))
	local spr_bg = cc.Sprite:createWithSpriteFrameName("fetters/spr-skill-bg.png")
	spr_bg:setLocalZOrder(1)
	local size = spr_bg:getContentSize()
	self:addChild(spr_bg)
	spr_bg:setAnchorPoint(0.5,0.5)
	spr_bg:setPosition(size.width / 2,size.height / 2)
	self:setContentSize(size)

	self.icon = cc.Sprite:createWithSpriteFrameName("hero-icon/10404002.png")
	self:addChild(self.icon)
	self.icon:setAnchorPoint(0.5,0.5)
	self.icon:setPosition(size.width / 2,size.height / 2)
	self.icon:setScale(0.76)

	self.lbl_name = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 20)
	self:addChild(self.lbl_name)
	self.lbl_name:setAnchorPoint(0.5,0.5)
	self.lbl_name:setPosition(size.width / 2,5)
	self.lbl_name:setLocalZOrder(1)
	self.lbl_name:enableOutline(cc.c3b(69,37,166), 1)

	self:registerEvent()
end

function FetterSkillIcon:registerEvent()
	self.event_list = {

	}
end



return FetterSkillIcon