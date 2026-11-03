--[[
    func: 组队竞技场添加玩家主界面
    author:徐东浩
    time:2020-04-17 15:04:12
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local TeamArenaTeamAddMainCtrl = class("TeamArenaTeamAddMainCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local TeamArenaTeamAddMainLayer = class("TeamArenaTeamAddMainLayer", require("src.comp.EventLayer"))


-------------------------------TeamArenaTeamAddMainLayer-----------------------------------------------
function TeamArenaTeamAddMainLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(false)
    self:addBlackBackground()
    
    self.btn_request_list:registerScriptTapHandler(handler(self,self.onRequestList))
    self.btn_invite_player:registerScriptTapHandler(handler(self,self.onInviteList))

    self.cur_layer = nil
    self.cur_layer_tab = TeamArenaTeamAddPanelIdxType.NULL
    self.layer_parent_size = self.node_layer_parent:getContentSize()

    self.node_layer_parent:setLocalZOrder(100)

    self:addRedDotNode(RedDotType.ZCJ_DHZC_KFSK_ZDJJC_ZDDT_WDDW_TJWJ_RDSQ, self.btn_request_list)
end

function TeamArenaTeamAddMainLayer:changeLayer(tab)
    if self.cur_layer_tab == tab then
        return
    end

    self.cur_layer_tab = tab

    self.btn_request_list:setChecked(self.cur_layer_tab == TeamArenaTeamAddPanelIdxType.REQUEST_LIST)
    self.btn_invite_player:setChecked(self.cur_layer_tab == TeamArenaTeamAddPanelIdxType.INVITE_PLAYER)

    self:refreshBtnLabelColor(self.cur_layer_tab)

    if self.cur_layer ~= nil then
        self.cur_layer:removeFromParent()
        self.cur_layer = nil
    end

    if self.cur_layer_tab == TeamArenaTeamAddPanelIdxType.REQUEST_LIST then
        self.cur_layer = require("src.layer.teamarena.TeamArenaTeamAddReqLayer"):createWithCCBIFile("ccbi/TeamArenaTeamAddReqLayer.ccbi")
        self.cur_layer:reqData()
    elseif self.cur_layer_tab == TeamArenaTeamAddPanelIdxType.INVITE_PLAYER then
        self.cur_layer = require("src.layer.teamarena.TeamArenaTeamAddInviteLayer"):createWithCCBIFile("ccbi/TeamArenaTeamAddInviteLayer.ccbi")
        self.cur_layer:reqData()
    end

    self.cur_layer:setIgnoreAnchorPointForPosition(false)
    self.cur_layer:setAnchorPoint(ex.a.top_center)
    self.cur_layer:setPosition(self.layer_parent_size.width / 2, self.layer_parent_size.height)
    self.node_layer_parent:addChild(self.cur_layer)
end

function TeamArenaTeamAddMainLayer:refreshBtnLabelColor(panel_type)
    self.btn_request_list:setLabelColor(panel_type == TeamArenaTeamAddPanelIdxType.REQUEST_LIST and FONT_LABEL_SELECTED or FONT_LABEL_NOT_SELECTED)
    self.btn_invite_player:setLabelColor(panel_type == TeamArenaTeamAddPanelIdxType.INVITE_PLAYER and FONT_LABEL_SELECTED or FONT_LABEL_NOT_SELECTED)
end

function TeamArenaTeamAddMainLayer:onRequestList(tag, pSender)
    self:changeLayer(TeamArenaTeamAddPanelIdxType.REQUEST_LIST)
end

function TeamArenaTeamAddMainLayer:onInviteList(tag, pSender)
    self:changeLayer(TeamArenaTeamAddPanelIdxType.INVITE_PLAYER)
end

-----------------------------------------------------------------------------
function TeamArenaTeamAddMainCtrl:onCreate()
    self:setCCBIPath("ccbi/TeamArenaTeamAddMainLayer.ccbi")
    
    self:setIsSingle(false)
end

function TeamArenaTeamAddMainCtrl:openWindow(panel_type)
	if self:isOpened() then
		return
    end

    self:loadLayer()
    self:open()

	self:init(panel_type)
end

function TeamArenaTeamAddMainCtrl:changeLayer(panel_type)
    if not self:isOpened() then
		return
    end

    self.layer:changeLayer(panel_type or TeamArenaTeamAddPanelIdxType.REQUEST_LIST)
end

function TeamArenaTeamAddMainCtrl:getLayerClass()
	return TeamArenaTeamAddMainLayer
end

function TeamArenaTeamAddMainCtrl:init(panel_type)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer:changeLayer(panel_type or TeamArenaTeamAddPanelIdxType.REQUEST_LIST)
end

return TeamArenaTeamAddMainCtrl

