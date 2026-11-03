local FetterBattleIcon = class("FetterBattleIcon", function (params1, params2, params3)
	return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
end)


function FetterBattleIcon:onNodeEvent(event)
    if event == "exit" then
        self:onExit()
    end
end

function FetterBattleIcon:onExit()
	-- self:removeTimer()
	if self.timer_id then 
		ex.Timer:removeTimerById(self.timer_id)
		self.timer_id = nil
	end

    for k,v in pairs(self.event_list) do
    	ex.EventManager:remove(v)
    end
end

function FetterBattleIcon:createMenu()

end

function FetterBattleIcon:reset()
	-- self:startTimer()
	local isRed = ex.Player.fetter_data.vip:checkRedPoint()
	ex.Tools:addRedPoint(self,isRed, ex.r.p8)
	self:updateProgress()
	self:addSpine()
end

function FetterBattleIcon:addSpine()
	if self.spine ~= nil then 
		self.spine:removeFromParent()
		self.spine = nil
	end

	local data = ex.Player.fetter_data.vip:getNextVIPSpine()
	if not data then 
		self:removeFromParent()
		return 
	end

	if data.type == 0 then 
		self:removeFromParent()
		return 
	end
    self.spine = sp.SkeletonAnimation:create("spine/"..data.type..".json","spine/"..data.type..".atlas", 1)
    self.spine:setAnimation(0, "stand", true)
    self:addChild(self.spine)
    self.spine:setPosition(75,20)
    self.spine:setScale(0.4)
end

function FetterBattleIcon:createProgress()
    self.progressTimer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("fetters/spr-jdt-2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setScaleX(1)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_progress_bg:addChild(self.progressTimer)
    self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2 )
    self:updateProgress()
end

function FetterBattleIcon:updateProgress()
	local num = 0 
	local total = 0
	local cfg_data = ex.Player.fetter_data.vip:getVIPCfg()

	for k,v in pairs(cfg_data) do
		local status = ex.Player.fetter_data.vip:getStatus(v.idx)
		if status == 1 then num = num + 1 end
		total = total + 1
	end
    local percent = num / total * 100
    if percent > 100 then percent = 100 end
    self.progressTimer:setPercentage(percent)
    local str = string.format("%s/%s",num,total)
    self.text:setString(str)
end

function FetterBattleIcon:getData()
	return self.data 
end

-- function FetterBattleIcon:initNode()

-- end

function FetterBattleIcon:createWithData(data)
	local pRet = FetterBattleIcon:create("", nil, nil)
	if pRet then
		pRet:initDone()
		pRet:reset(data)
		return pRet
	end
	pRet = nil
	return nil
end

function FetterBattleIcon:initDone()

	self:setContentSize(150,150)

	self.spr_progress_bg = cc.Sprite:createWithSpriteFrameName("fetters/spr-jdt-bg1.png")
	self:addChild(self.spr_progress_bg)
	self.spr_progress_bg:setPosition(75,10)
	self.spr_progress_bg:setLocalZOrder(1)

	local border = cc.Sprite:createWithSpriteFrameName("fetters/spr-jdt-border.png")
	local size = self.spr_progress_bg:getContentSize()
	self.spr_progress_bg:addChild(border)
	border:setPosition(size.width/2,size.height/2)
	border:setLocalZOrder(1)

	self.text = cc.Label:createWithTTF(ex.Tools:getLang(47647), FONT_DEFAULT_NAME_BOLD, 20)
	self.spr_progress_bg:addChild(self.text)
	self.text:setLocalZOrder(1)
	self.text:setPosition(size.width/2,size.height/2)

	self:createProgress()
	self:registerEvent()
end

function FetterBattleIcon:registerEvent()
	self:registerScriptHandler(handler(self, self.onNodeEvent))

	self.event_list = {
		ex.EventManager:add(EVENT.FETTER_EVENT.VIP_REWARD,handler(self,self.reset)),
		ex.EventManager:add(EVENT.FETTER_EVENT.VIP_UPDATE,handler(self,self.reset)),
		ex.EventManager:add(EVENT.FETTER_EVENT.UPDATE_PROGRESS,handler(self,self.reset)),
	}
end

function FetterBattleIcon:onClose(event,data)
	-- body
	if self.timer_id then 
		ex.Timer:removeTimerById(self.timer_id)
		self.timer_id = nil
	end
	self:removeFromParent()
	ex.EventManager:fire(EVENT.FETTER_EVENT.REMOVE_ICON)
end

function FetterBattleIcon:onOnlineRewardResult(event,data)

	self:reset()
end



return FetterBattleIcon
