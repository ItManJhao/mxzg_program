local FantasyTowerTipRewardCell = class("FantasyTowerTipRewardCell", require("src.comp.EventLayer"))


function FantasyTowerTipRewardCell:onCreate()
    self.scroll_view_reward1:setItemSize(cc.size(90, 90))
    self.scroll_view_reward1:setSwallowsTouches(false)
    self.btn_touch:setContentSize(cc.size(150, 180))
    self.lbl_tip:setTextColor(cc.c4b(215,0,234,255))
    self:setPosition(cc.p(ex.p.width - 150, ex.p.height - 300 - require("src.model.Game"):instance():getNotchHeight()))
end

function FantasyTowerTipRewardCell:reset()
    local str_stage , str_reward, reward, stage , str_fight_tip = ex.Player.tower_data:getNextTip()
    if stage == nil then
        self:removeFromParent()
        return
    end
    self.lbl_mission:setString(string.format(ex.Tools:getLang(47218), stage))
    self.lbl_tip:setString(str_fight_tip)

    self.scroll_view_reward1.createItemFunction = function(data, scale)
        local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
        item:setScale(0.6)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        return item
    end
    self.scroll_view_reward1:reloadData(reward)

end

function FantasyTowerTipRewardCell:onReward()
    ex.Player.tower_data:sortReward()
    require("src.layer.MissionRewardCtr"):instance():openWindow(ex.Player.tower_data.vec_tower_reward_status,
                                                                require("src.layer.fantasytower.FantasyTowerRewardCell"))
end

return FantasyTowerTipRewardCell