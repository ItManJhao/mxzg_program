local AchievementCell = class("AchievementCell", require("src.comp.LuaLayerBase"))

function AchievementCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.progressTimer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("achievement/item-progress.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_progress_bg:addChild(self.progressTimer)
    self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2)
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

function AchievementCell:setBtnString()

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

function AchievementCell:onClickGoto(tag,pSender)
    if self.data.jump_info.event_type == 1 then 
        
        local backToLayer =  function ( layer )
            require("src.layer.AchievementCtr"):instance():openWindow()
            --require("src.layer.AchievementCtr"):instance():selectAchievement()
        end
        local params = {}
        params.backToLayer = backToLayer

        ex.JumpManager:jumpByAtom(self.data.jump_info.event_arg, params)
        local achievementCtr = require("src.layer.AchievementCtr"):instance()
        achievementCtr:closeWindow(nil,achievementCtr.layer)
    else
        ex.MessageView:add(ex.Tools:taskString(self.data.jump_info.no_jump_hint))
    end
end

function AchievementCell:onClickSubmit(tag,pSender)
    -- local req_achievement = cpp.ByteArray:create()
    -- req_achievement:writeInt(ProtocolID.GReqAchievementReward)
    -- req_achievement:writeInt(self.data.idx)
    -- cpp.NetManager:instance():sendByteArray(req_achievement)

    local server_data = ex.Player.achievement_data:getAchievementServerDataById(self.data.idx)
    local has_num = server_data.process

    local can_get = has_num >= self.data.task.target  
    local can_jump = self.data.jump_info.event_type == 1

    if not can_jump then 
        if server_data.state == 1 or not can_get then 
            ex.MessageView:add(ex.Tools:getLang(47252))
            return 
        end
    end

    print(self.__cname,"????????")
	local req_achievement = Achievement_pb.GReqAchievementGetReward()
	req_achievement.idx = self.data.idx
	NetManager:sendMessage(ProtocolID.GReqAchievementGetReward,req_achievement)
end

function AchievementCell:createMenuWithItem()
	-- body
    self.menu = cpp.UIMenu:create()
    self:addChild(self.menu)
    self.menu:setPosition(0,0)
end

function AchievementCell:updateMenuItem(data)

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

function AchievementCell:onClick(tag,pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function AchievementCell:reset(data)

	if not data then print("not data") return end
    self.data = data
    local server_data = ex.Player.achievement_data:getAchievementServerDataById(self.data.idx)
    local has_num = server_data.process
	self:setCompleted(has_num,data.task.target)
	self:updateMenuItem(data.reward)
    local can_get = has_num >= data.task.target  
    local can_jump = data.jump_info.event_type == 1
	self.btn_submit:setVisible(can_get and server_data.state == 0)
    self.btn_goto:setVisible(not can_get and server_data.state == 0)
    if not can_jump then 
        self.btn_submit:setVisible(server_data.state == 0)
        self.btn_goto:setVisible(false)
    end 

    -- add 熊梦 成就 红点
    if self.btn_submit:isVisible() then
        ex.Tools:addRedPoint(self.btn_submit, true, cc.p(0.95, 0.85))
    end

    self.lbl_title:setXmlTextLua(ex.Tools:taskString(data.lang,data.task.target,data.task.condition))
    -- -- getAchievementLevelByType
    local geted = server_data.state == 1
    self.spr_geted:setVisible(geted)
    self.lbl_progress:setVisible(not geted)
    self.spr_progress_bg:setVisible(not geted)
end

function AchievementCell:setCompleted(count, need_num)
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

return AchievementCell
