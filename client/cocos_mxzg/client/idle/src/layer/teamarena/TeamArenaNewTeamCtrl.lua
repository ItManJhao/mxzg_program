--[[
    func: 组队竞技场创建队伍
    author:徐东浩
    time:2020-04-15 17:21:12
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local TeamArenaNewTeamCtrl = class("TeamArenaNewTeamCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local TeamArenaNewTeamLayer = class("TeamArenaNewTeamLayer", require("src.comp.EventLayer"))
local UICheckBox = require("src.comp.UICheckBox")

-------------------------------TeamArenaNewTeamLayer-----------------------------------------------
function TeamArenaNewTeamLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(false)
    self:addBlackBackground()
    
    -- 创建输入框
    local input_size = self.spr_input_name_bg:getContentSize()
	self.name_input = ccui.EditBox:create(input_size, "other/spr-null.png",1)
    self.name_input:setPosition(cc.p(input_size.width / 2, input_size.height / 2))
    self.name_input:setAnchorPoint(cc.p(0.5, 0.5))
    self.name_input:setFontSize(20)
    self.name_input:setMaxLength(6)
    self.name_input:setFontColor(FONT_BROWN_2)
    self.name_input:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND) --输入键盘返回类型，done，send，go等
    self.name_input:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE) --输入模型，如整数类型，URL，电话号码等，会检测是否符合
    self.name_input:setPlaceholderFontSize(20)
    self.name_input:setPlaceHolder(ex.Tools:getLang(74219))
    self.spr_input_name_bg:addChild(self.name_input, 9999)

    self.checkbox_min_level = UICheckBox:createWithContentSize(cc.size(242, 33), nil, nil, 1, 2)
	self.checkbox_min_level:setAnchorPoint(0, 0.5)
    self.checkbox_min_level:setPosition(-43, 0)
    self.node_min_level:addChild(self.checkbox_min_level, 15)
    self.node_min_level:setLocalZOrder(110)
    
    self.checkbox_min_power = UICheckBox:createWithContentSize(cc.size(242, 33), nil, nil, 1, 2)
	self.checkbox_min_power:setAnchorPoint(0, 0.5)
	self.checkbox_min_power:setPosition(-43, 0)
    self.node_min_power:addChild(self.checkbox_min_power, 15)
    self.node_min_power:setLocalZOrder(100)
end

function TeamArenaNewTeamLayer:getInputText()
    local input = self.name_input:getText()
    input = string.trim(input)

    return input
end

function TeamArenaNewTeamLayer:isNeedCheck()
    return self.btn_check:isChecked()
end

-----------------------------------------------------------------------------
function TeamArenaNewTeamCtrl:onCreate()
    self:setCCBIPath("ccbi/TeamArenaNewTeamLayer.ccbi")
    
    self:setIsSingle(false)

    self.min_level_idx = 1
    self.min_score_idx = 1
end

function TeamArenaNewTeamCtrl:openWindow()
	if self:isOpened() then
		return
    end

    self:loadLayer()
    self:open()

	self:init()
end

function TeamArenaNewTeamCtrl:getLayerClass()
	return TeamArenaNewTeamLayer
end

function TeamArenaNewTeamCtrl:init()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer.btn_cancel:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer.btn_ok:registerScriptTapHandler(handler(self, self.onOK))

    self.layer:addEvent(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_CREATE, handler(self, self.successCreate))

    local level_str_list = cfg.teamarenagetinlevel.getStringForCheckBox()
    self.layer.checkbox_min_level:setCheckItemList(level_str_list, 1)
	self.layer.checkbox_min_level:setSelectedCallback(handler(self, self.onSelectedMinLevel))
    self.layer.checkbox_min_level:setMenuItemCallback(handler(self, self.onSelectedMinLevelItem))
    
    local score_str_list = cfg.teamarenagetinscore.getStringForCheckBox()
    self.layer.checkbox_min_power:setCheckItemList(score_str_list, 1)
	self.layer.checkbox_min_power:setSelectedCallback(handler(self, self.onSelectedMinScore))
	self.layer.checkbox_min_power:setMenuItemCallback(handler(self, self.onSelectedMinScoreItem))
end

function TeamArenaNewTeamCtrl:onOK(tag, pSender)
    local input = self.layer:getInputText()
    if string.len(input) <= 0 then
        ex.MessageView:add(ex.Tools:getLang(74219))
        return
    end

    local level_config = cfg.teamarenagetinlevel.getConfigByIdx(self.min_level_idx)
    local power_config = cfg.teamarenagetinscore.getConfigByIdx(self.min_score_idx)

    local req = TeamArena_pb.GReqTeamCreate()
    req.team_name = input
    req.min_fighting = power_config.need_score
    req.min_lv = level_config.need_level
    req.auto_agree = not self.layer:isNeedCheck()
    NetManager:sendMessage(ProtocolID.GReqTeamCreate, req)
end

function TeamArenaNewTeamCtrl:onSelectedMinLevel(visible)
	if visible then
        self.layer.checkbox_min_power:showCheckMenu(false)
	end
end

function TeamArenaNewTeamCtrl:onSelectedMinLevelItem(idx, name)
	self.min_level_idx = idx
end

function TeamArenaNewTeamCtrl:onSelectedMinScore(visible)
	if visible then
        self.layer.checkbox_min_level:showCheckMenu(false)
	end
end

function TeamArenaNewTeamCtrl:onSelectedMinScoreItem(idx, name)
	self.min_score_idx = idx
end

-- function TeamArenaNewTeamCtrl:refreshData(event, data)
--     if not self:isOpened() or not data then
-- 		return
--     end
-- end

function TeamArenaNewTeamCtrl:successCreate()
    self:closeWindow()

    ex.JumpManager:jumpByAtom("team_arena_team_main_my_team")
end

return TeamArenaNewTeamCtrl

