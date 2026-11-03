--[[
    func: 组队竞技场组队主界面
    author:徐东浩
    time:2020-04-14 22:14:12
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local TeamArenaTeamMainCtrl = class("TeamArenaTeamMainCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local TeamArenaTeamMainLayer = class("TeamArenaTeamMainLayer", require("src.comp.EventLayer"))


-------------------------------TeamArenaTeamMainLayer-----------------------------------------------
function TeamArenaTeamMainLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(false)
    self:addBlackBackground()
    
    self.btn_team:registerScriptTapHandler(handler(self,self.onTeam))
    self.btn_recv_invite:registerScriptTapHandler(handler(self,self.onRecvInvite))
    self.btn_my_team:registerScriptTapHandler(handler(self,self.onMyTeam))

    self.cur_layer = nil
    self.cur_layer_tab = TeamArenaTeamPanelIdxType.NULL
    self.layer_parent_size = self.node_layer_parent:getContentSize()

    self.node_layer_parent:setLocalZOrder(100)

    self:addRedDotNode(RedDotType.ZCJ_DHZC_KFSK_ZDJJC_ZDDT_SDYQ, self.btn_recv_invite)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_KFSK_ZDJJC_ZDDT_WDDW, self.btn_my_team)
end

function TeamArenaTeamMainLayer:changeLayer(tab)
    if self.cur_layer_tab == tab then
        return
    end

    self.cur_layer_tab = tab

    self.btn_team:setChecked(self.cur_layer_tab == TeamArenaTeamPanelIdxType.TEAM)
    self.btn_recv_invite:setChecked(self.cur_layer_tab == TeamArenaTeamPanelIdxType.RECV_INVITE)
    self.btn_my_team:setChecked(self.cur_layer_tab == TeamArenaTeamPanelIdxType.MY_TEAM)

    self:refreshBtnLabelColor(self.cur_layer_tab)

    if self.cur_layer ~= nil then
        self.cur_layer:removeFromParent()
        self.cur_layer = nil
    end

    if self.cur_layer_tab == TeamArenaTeamPanelIdxType.TEAM then
        self.cur_layer = require("src.layer.teamarena.TeamArenaTeamLayer"):createWithCCBIFile("ccbi/TeamArenaTeamLayer.ccbi")
        self.cur_layer:reqData()
    elseif self.cur_layer_tab == TeamArenaTeamPanelIdxType.RECV_INVITE then
        self.cur_layer = require("src.layer.teamarena.TeamArenaRecvInviteLayer"):createWithCCBIFile("ccbi/TeamArenaRecvInviteLayer.ccbi")
        self.cur_layer:reqData()
    elseif self.cur_layer_tab == TeamArenaTeamPanelIdxType.MY_TEAM then
        self.cur_layer = require("src.layer.teamarena.TeamArenaMyTeamLayer"):createWithCCBIFile("ccbi/TeamArenaMyTeamLayer.ccbi")
        self.cur_layer:reqData()
    end

    self.cur_layer:setIgnoreAnchorPointForPosition(false)
    self.cur_layer:setAnchorPoint(ex.a.top_center)
    self.cur_layer:setPosition(self.layer_parent_size.width / 2, self.layer_parent_size.height)
    self.node_layer_parent:addChild(self.cur_layer)
end

function TeamArenaTeamMainLayer:refreshBtnLabelColor(panel_type)
    self.btn_team:setLabelColor(panel_type == TeamArenaTeamPanelIdxType.TEAM and FONT_LABEL_SELECTED or FONT_LABEL_NOT_SELECTED)
    self.btn_recv_invite:setLabelColor(panel_type == TeamArenaTeamPanelIdxType.RECV_INVITE and FONT_LABEL_SELECTED or FONT_LABEL_NOT_SELECTED) 
    self.btn_my_team:setLabelColor(panel_type == TeamArenaTeamPanelIdxType.MY_TEAM and FONT_LABEL_SELECTED or FONT_LABEL_NOT_SELECTED)
end

function TeamArenaTeamMainLayer:onTeam(tag, pSender)
    self:changeLayer(TeamArenaTeamPanelIdxType.TEAM)
end

function TeamArenaTeamMainLayer:onRecvInvite(tag, pSender)
    self:changeLayer(TeamArenaTeamPanelIdxType.RECV_INVITE)
end

function TeamArenaTeamMainLayer:onMyTeam(tag, pSender)
    self:changeLayer(TeamArenaTeamPanelIdxType.MY_TEAM)
end

-----------------------------------------------------------------------------
function TeamArenaTeamMainCtrl:onCreate()
    self:setCCBIPath("ccbi/TeamArenaTeamMainLayer.ccbi")
    
    self:setIsSingle(false)
end

function TeamArenaTeamMainCtrl:openWindow(panel_type)
	if self:isOpened() then
		return
    end

    self:loadLayer()
    self:open()

	self:init(panel_type)
end

function TeamArenaTeamMainCtrl:changeLayer(panel_type)
    if not self:isOpened() then
		return
    end

    self.layer:changeLayer(panel_type or TeamArenaTeamPanelIdxType.TEAM)
end

function TeamArenaTeamMainCtrl:getLayerClass()
	return TeamArenaTeamMainLayer
end

function TeamArenaTeamMainCtrl:init(panel_type)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer:changeLayer(panel_type or TeamArenaTeamPanelIdxType.TEAM)
end

return TeamArenaTeamMainCtrl

