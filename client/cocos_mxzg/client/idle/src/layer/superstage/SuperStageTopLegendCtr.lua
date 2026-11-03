local SuperStageTopLegendCtr = class("SuperStageTopLegendCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SuperStageTopLegendLayer = class("SuperStageTopLegendLayer", require("src.comp.EventLayerAdaptiveWidth"))

-----------------------------------------------------------------------------
function SuperStageTopLegendLayer:onCreate()
	self:addBlackBackground()
end

-----------------------------------------------------------------------------
function SuperStageTopLegendCtr:onCreate()
	self:setCCBIPath("ccbi/SuperStageTopLegendLayer.ccbi")
	self:setIsSingle(false)
end

function SuperStageTopLegendCtr:getLayerClass()
	return SuperStageTopLegendLayer
end

function SuperStageTopLegendCtr:openWindow()
	if self:isOpened() then
		return
    end
    
	self:loadLayer()
	self:open()
	self:initData()
end

function SuperStageTopLegendCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_like1:registerScriptTapHandler(handler(self, self.onLike))
    self.layer.btn_like2:registerScriptTapHandler(handler(self, self.onLike))
    self.layer.btn_like3:registerScriptTapHandler(handler(self, self.onLike))

    self.layer:addEvent(EVENT.SUPER_STAGE.RANK_INFO, handler(self, self.updateLayer))
    self.layer:addEvent(EVENT.SUPER_STAGE.UPDATE_LIKE, handler(self, self.updateLike))
    
    NetManager:sendMessage(ProtocolID.GReqPreliminariesRank)
    
    self:updateLayer()
end

function SuperStageTopLegendCtr:updateLayer()
    local super_stage_data = ex.Player.super_stage_data

    for i=1,3 do
        local player_data = TableEx.findValueFunction(super_stage_data.vec_top_rank or {}, function(value)
            return value.rank == i
        end)
        self.layer["node_hero"..i]:removeAllChildren()
        self.layer["btn_like"..i]:setVisible(player_data ~= nil)
        self.layer["lbl_like"..i]:setVisible(player_data ~= nil)
        self.layer["lbl_stage"..i]:setVisible(player_data ~= nil)
        if player_data then
            local hero = require("src.person.Hero"):create("1", "1", 1, 1, ex.Tools:getHeroSkinByImageId(player_data.image_id)) 
            hero:setScale(i == 1 and 1.2 * 1.2 or 1 * 1.2)
            self.layer["node_hero"..i]:addChild(hero)

            self.layer["btn_like"..i].rid = player_data.rid

            self.layer["lbl_name"..i]:setString(player_data.name)
            self.layer["lbl_like"..i]:setString(player_data.like)

            local config_stage = cfg.superstage.superstage[player_data.stage_id]
            if config_stage ~= nil then
                self.layer["lbl_stage"..i]:setString(ex.Tools:getLang(config_stage.name_lang))
            end

            local is_like = super_stage_data:isLike(player_data.rid)
            ex.Tools:setGrayAuto(self.layer["btn_like"..i]:getNormalImage(), is_like)
            self.layer["btn_like"..i]:setEnabled(not is_like)
        else
            self.layer["lbl_name"..i]:setString(ex.Tools:getLang(47593))
        end
    end
end

function SuperStageTopLegendCtr:updateLike()
    local super_stage_data = ex.Player.super_stage_data

    for i=1,3 do
        local data = TableEx.findValueFunction(super_stage_data.vec_top_rank or {}, function(value)
            return value.rank == i
        end)

        if data ~= nil then
            self.layer["lbl_like"..i]:setString(data.like)

            local is_like = super_stage_data:isLike(data.rid)
            ex.Tools:setGrayAuto(self.layer["btn_like"..i]:getNormalImage(), is_like)
            self.layer["btn_like"..i]:setEnabled(not is_like)
        end
    end
end

function SuperStageTopLegendCtr:onLike(tag, pSender)
    if pSender.rid == nil then
        return
    end

    if ex.Player.super_stage_data:isLike(pSender.rid) then
        return
    end

    if ex.Player.super_stage_data:isLimitLike() then
        ex.MessageView:add(ex.Tools:getLang(70768))
        return
    end

    local req_like = Pinnacle_pb.GReqPreliminariesLike()
    req_like.rid = pSender.rid
    NetManager:sendMessage(ProtocolID.GReqPreliminariesLike, req_like)
end

return SuperStageTopLegendCtr
