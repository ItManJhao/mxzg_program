local DailyCell = class("DailyCell", require("src.comp.LuaLayerBase"))
local language = {
    [1001]  = ex.Tools:getLang(47073),
    [1002]  = ex.Tools:getLang(47434),
    [1003]  = ex.Tools:getLang(47585),
    [1004]  = ex.Tools:getLang(47118),
    [1005]  = ex.Tools:getLang(47568),
    [1006]  = ex.Tools:getLang(47382),
    [1007]  = ex.Tools:getLang(47329),
    [1008]  = ex.Tools:getLang(47661),
    [1009]  = ex.Tools:getLang(47282),
    [1010]  = ex.Tools:getLang(47478),
    [1011]  = ex.Tools:getLang(47028),
    [1012]  = ex.Tools:getLang(47746),
    [1013]  = ex.Tools:getLang(47004),
}

function DailyCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.progressTimer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("achievement/item-progress.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_progress_bg:addChild(self.progressTimer)
    self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2 )
    self.items = {}
    self:createMenuWithItem()

    self:setBtnString()

    self.lbl_title = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_title:setFontSize(44)
	self.lbl_title:setScale(0.5)
	self.lbl_title:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_title:setFontColor("#7A472D")
	self.lbl_title:setAnchorTextShadow(false)
	self.lbl_title:setAnchorPoint(ex.a.left_center)
    self.lbl_title:setPosition(cc.p(25, 125))
    self.lbl_title:setLocalZOrder(10)
    self:addChild(self.lbl_title)
end

function DailyCell:setBtnString()
    self.lbl_btn_submit = cc.Label:createWithTTF(ex.Tools:getLang(47037), FONT_DEFAULT_NAME_BOLD, 24)
    self.btn_submit:addChild(self.lbl_btn_submit)
    self.lbl_btn_submit:setPosition(self.btn_submit:getContentSize().width * 0.5, self.btn_submit:getContentSize().height * 0.5)
    self.lbl_btn_submit:enableOutline(FONT_BROWN, 1)
    self.btn_submit:registerScriptTapHandler(handler(self, self.onClickSubmit))

    self.lbl_btn_goto = cc.Label:createWithTTF(ex.Tools:getLang(47627), FONT_DEFAULT_NAME_BOLD, 24)
    self.btn_goto:addChild(self.lbl_btn_goto)
    self.lbl_btn_goto:setPosition(self.btn_goto:getContentSize().width * 0.5, self.btn_goto:getContentSize().height * 0.5)
    self.lbl_btn_goto:enableOutline(FONT_DARK_BLUE, 1)
    self.btn_goto:registerScriptTapHandler(handler(self, self.onClickGoto))
end

function DailyCell:onClickGoto(tag, pSender)
    if self.data.jump_info.event_type == 1 then 

        local backToLayer =  function ( layer )
            require("src.layer.AchievementCtr"):instance():openWindow()
        end
        local params = {}
        params.backToLayer = backToLayer
        ex.JumpManager:jumpByAtom(self.data.jump_info.event_arg, params)

        local achievementCtr = require("src.layer.AchievementCtr"):instance()
        achievementCtr:closeWindow(nil,achievementCtr.layer)
    else
        ex.MessageView:add(ex.Tools:getLang(self.data.jump_info.no_jump_hint))
    end
end

function DailyCell:onClickSubmit(tag,pSender)

    local server_data = ex.Player.achievement_data:getDailyServerDataById(self.data.idx)
    local has_num = server_data.process

    local can_get = has_num >= self.data.task.target  
    local can_jump = self.data.jump_info.event_type == 1

    if not can_jump then 
        if server_data.state == 1 or not can_get then 
            ex.MessageView:add(ex.Tools:getLang(47252))
            return 
        end
    end
    -- local req_daily = cpp.ByteArray:create()
    -- req_daily:writeInt(ProtocolID.GReqDailyReward)
    -- req_daily:writeInt(self.data.idx)
    -- cpp.NetManager:instance():sendByteArray(req_daily)
	local req_daily = Achievement_pb.GReqDailyTaskGetReward()
	req_daily.task_id = self.data.idx
	NetManager:sendMessage(ProtocolID.GReqDailyTaskGetReward,req_daily)
end

function DailyCell:createMenuWithItem()
    self.menu = cpp.UIMenu:create()
    self:addChild(self.menu)
    self.menu:setPosition(0,0)
end

function DailyCell:updateMenuItem(data)

    self.menu:removeAllChildren()
    local begin = 30
    local margin = 5
    local posY = 60
    local scale = 0.75

    for k,v in pairs(data) do
        local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        self.menu:addChild(item)
        local posX = (begin + item:getContentSize().width * scale / 2) + (k - 1) * ((item:getContentSize().width * scale) + margin)
        item:setPosition(posX, posY)

        item:registerScriptTapHandler(handler(self, self.onClick))
        item:setScale(scale)
    end
end

function DailyCell:onClick(tag,pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function DailyCell:reset(data)
	if not data then print("DailyCell:reset() data is nil") return end
    self.data = data
	self:setCompleted(data.server_data.process,data.task.target)
	self:updateMenuItem(data.reward)
    local status = data.server_data.state
    local can_jump = data.jump_info.event_type == 1
	self.btn_submit:setVisible(data.is_red and status < 1)
    self.btn_goto:setVisible(not data.is_red and status < 1)
    
    if not can_jump then 
        self.btn_submit:setVisible(status == 0)
        self.btn_goto:setVisible(false) 
    end 

    -- add 熊梦 日常 红点
    if self.btn_submit:isVisible() then
        ex.Tools:addRedPoint(self.btn_submit, true, cc.p(0.95, 0.85))
    end

    local str = ex.Tools:taskString(data.lang,data.task.target,data.task.condition)
    self.lbl_title:setXmlTextLua(str)
    self.progressTimer:setVisible(status < 1)
    self.lbl_progress:setVisible(status < 1)
    self.spr_progress_bg:setVisible(status < 1)
    self.spr_geted:setVisible(status == 1)
end

function DailyCell:setCompleted(count, need_num)
	if need_num < 1 then
		count = 0
		need_num = 1
	end

	if count >= need_num then
        self.progressTimer:setPercentage(100.0)
    else
        self.progressTimer:setPercentage(100.0 * count / need_num)
    end
    self.lbl_progress:setString(string.format("%d/%d", count, need_num))
end

return DailyCell
