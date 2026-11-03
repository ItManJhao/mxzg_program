local GRMissionStarRewardCell = class("GRMissionStarRewardCell", require("src.comp.EventLayer"))

function GRMissionStarRewardCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 0.5)

    self.scroll_view:setItemSize(cc.size(90, 90))
    self.scroll_view:setSwallowsTouches(false)
end

function GRMissionStarRewardCell:reset(data)
    self.data = data
    if not data or table.nums(self.data) <= 0 then
        return
    end

    local now_star = ex.Player.god_relic_data:getStarCount(self.data.chapter)

    self.lbl_text:setString(string.format(ex.Tools:getLang(54512), self.data.star, now_star, self.data.star))
    self.scroll_view.createItemFunction = function(data, scale)
        local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
        item:setScale(0.8)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        return item
    end
    self.scroll_view:reloadData(self.data.reward)

    local status = ex.Player.god_relic_data:getStarStatu(self.data.idx)
    self.btn_go:setVisible(status == 1)
    self.btn_reward:setVisible(status == 0)
    self.spr_geted:setVisible(status == -1)
end

function GRMissionStarRewardCell:onGo()
    ex.Player.god_relic_data.selected_chapter = self.data.chapter
    ex.JumpManager:jumpByAtom("main_god_relic")
    require("src.comp.LuaNodeCtr"):closeOtherWindow()
end

function GRMissionStarRewardCell:onReward()
    -- 领取
    local req_reward = GodRelic_pb.GReqGodRelicGetStarReward()
    req_reward.idx = self.data.idx
    NetManager:sendMessage(ProtocolID.GReqGodRelicGetStarReward, req_reward)
end

return GRMissionStarRewardCell