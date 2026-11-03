--[[
    func: 组队竞技场修改队伍条件
    author:徐东浩
    time:2020-04-15 22:24:40
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local TeamArenaConditionCtrl = class("TeamArenaConditionCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local TeamArenaConditionLayer = class("TeamArenaConditionLayer", require("src.comp.EventLayer"))
local UICheckBox = require("src.comp.UICheckBox")

-------------------------------TeamArenaConditionLayer-----------------------------------------------
function TeamArenaConditionLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(false)
    self:addBlackBackground()
    
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

function TeamArenaConditionLayer:isNeedCheck()
    return self.btn_check:isChecked()
end

function TeamArenaConditionLayer:setNeedCheck(is_need)
    self.btn_check:setChecked(is_need)
end

-----------------------------------------------------------------------------
function TeamArenaConditionCtrl:onCreate()
    self:setCCBIPath("ccbi/TeamArenaConditionLayer.ccbi")
    
    self:setIsSingle(false)

    self.team_data = nil
    self.min_level_idx = 1
    self.min_score_idx = 1
end

function TeamArenaConditionCtrl:openWindow(team_data)
	if self:isOpened() then
		return
    end

    if not team_data then
        printError("TeamArenaConditionCtrl:openWindow 请传入队伍数据")
        return
    end

    self.team_data = team_data

    self:loadLayer()
    self:open()

	self:init()
end

function TeamArenaConditionCtrl:getLayerClass()
	return TeamArenaConditionLayer
end

function TeamArenaConditionCtrl:init()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer.btn_cancel:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer.btn_ok:registerScriptTapHandler(handler(self, self.onOK))

    self.layer:addEvent(EVENT.TEAM_ARENA.TEAM_MAIN_TEAM_CONDITION, handler(self, self.closeWindow))

    local level_str_list = cfg.teamarenagetinlevel.getStringForCheckBox()
    local idx_level = cfg.teamarenagetinlevel.getIdxForLevel(self.team_data.team.min_lv)
    self.layer.checkbox_min_level:setCheckItemList(level_str_list, idx_level)
	self.layer.checkbox_min_level:setSelectedCallback(handler(self, self.onSelectedMinLevel))
    self.layer.checkbox_min_level:setMenuItemCallback(handler(self, self.onSelectedMinLevelItem))
    
    local score_str_list = cfg.teamarenagetinscore.getStringForCheckBox()
    local idx_score = cfg.teamarenagetinscore.getIdxForScore(self.team_data.team.min_fighting)
    self.layer.checkbox_min_power:setCheckItemList(score_str_list, idx_score)
	self.layer.checkbox_min_power:setSelectedCallback(handler(self, self.onSelectedMinScore))
    self.layer.checkbox_min_power:setMenuItemCallback(handler(self, self.onSelectedMinScoreItem))
    
    self.layer:setNeedCheck(not self.team_data.team.auto_agree)
end

function TeamArenaConditionCtrl:onOK(tag, pSender)
    local level_config = cfg.teamarenagetinlevel.getConfigByIdx(self.min_level_idx)
    local power_config = cfg.teamarenagetinscore.getConfigByIdx(self.min_score_idx)
    local auto_agree = not self.layer:isNeedCheck()

    if self.team_data.team.min_fighting == power_config.need_score and self.team_data.team.min_lv == level_config.need_level and auto_agree == self.team_data.team.auto_agree then
        self:closeWindow()
        return
    end

    local req = TeamArena_pb.GReqTeamReset()
    req.team_name = self.team_data.team.team_name
    req.min_fighting = power_config.need_score
    req.min_lv = level_config.need_level
    req.auto_agree = auto_agree
    NetManager:sendMessage(ProtocolID.GReqTeamReset, req)
end

function TeamArenaConditionCtrl:onSelectedMinLevel(visible)
	if visible then
        self.layer.checkbox_min_power:showCheckMenu(false)
	end
end

function TeamArenaConditionCtrl:onSelectedMinLevelItem(idx, name)
	self.min_level_idx = idx
end

function TeamArenaConditionCtrl:onSelectedMinScore(visible)
	if visible then
        self.layer.checkbox_min_level:showCheckMenu(false)
	end
end

function TeamArenaConditionCtrl:onSelectedMinScoreItem(idx, name)
	self.min_score_idx = idx
end

-- function TeamArenaConditionCtrl:refreshData(event, data)
--     if not self:isOpened() or not data then
-- 		return
--     end
-- end

return TeamArenaConditionCtrl

