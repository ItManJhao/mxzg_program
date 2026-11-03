local GRMissionListCell = class("GRMissionListCell", require("src.comp.EventLayer"))

function GRMissionListCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 0.5)

	self:addEvent(EVENT.GOD_RELIC.STAR_REWARD, handler(self, self.updateReddot))
end

function GRMissionListCell:reset(data)
    self.data = data
    if not data or table.nums(self.data) <= 0 then
        return
    end

    local star_count = ex.Player.god_relic_data:getStarCount()
    self.chapter = self.data[1].chapter
    self.lbl_chapter:setString(string.format(ex.Tools:getLang(47427), self.chapter))
    self.spr_perfect:setVisible(ex.Player.god_relic_data:isPerfect(self.chapter))
    -- self.cfg.godrelicunlock.godrelicunlock[chapter].unlock_need_star <= star
    self.lbl_tip:setString(string.format(ex.Tools:getLang(54511), cfg.godrelicunlock.godrelicunlock[self.chapter].unlock_need_star, star_count))

    if ex.Player.god_relic_data:isCanBattle(self.chapter) == true then
        self.spr_tip_bg:setVisible(false)
        self.lbl_tip:setVisible(false)
    else
        ex.Tools:setGrayAuto(self.spr_bg, true)
    end

    local is_red = false
    for k,v in pairs(cfg.godrelicstarreward.godrelicstarreward) do
        if v.chapter == self.chapter and ex.Player.god_relic_data:getStarStatu(v.idx) == 0 then
            is_red = true
            break
        end
    end
    
    ex.Tools:addRedPoint(self.btn_reward, is_red, cc.p(0.8, 0.8))

end

function GRMissionListCell:updateReddot()
    self:reset(self.data)
end

function GRMissionListCell:onReward()
    local vec_data = cfg.godrelicstarreward.getChapterList(self.data[1].chapter)
    require("src.layer.godrelic.GRMissionStarRewardCtr"):instance():openWindow(vec_data)
end

return GRMissionListCell