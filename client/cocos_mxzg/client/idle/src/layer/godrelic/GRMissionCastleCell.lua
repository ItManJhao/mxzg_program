local GRMissionCastleCell = class("GRMissionCastleCell", require("src.comp.EventLayer"))

local cell_type = {
    1,1,1,2,1,1,1,2,1,3
}

function GRMissionCastleCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 0.5)

    -- 旋转升天特效
    -- self.node_act:runAction()
    self.node_act:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveTo:create(1.3, cc.p(0, 10)), cc.MoveTo:create(1.6, cc.p(0, 0)))))

end

function GRMissionCastleCell:reset(data)
    self.data = data
    self:setType(cell_type[self.data.level])
    self.lbl_chapter:setString(string.format("%s-%s", self.data.chapter, self.data.level))

    local mission_data = ex.Player.god_relic_data:getMissionData(self.data.chapter, self.data.level)
    for i=1,3 do
        if mission_data == nil or table.nums(mission_data.complete_id) < i then
            ex.Tools:setSpriteFrame(self["spr_star"..i], "god-relic/xxwx.png")
        end
    end
end

function GRMissionCastleCell:setType(type)
    if type == 1 then
        self.spr_chapter_bg:setContentSize(cc.size(84, self.spr_chapter_bg:getContentSize().height))
        self.spr_main:setVisible(false)
        self.node_star:setPosition(cc.p(0, 0))
        ex.Tools:setSpriteFrame(self.spr_relic, "god-relic/spr-relic-1.png")
    elseif type == 2 then
        self.spr_chapter_bg:setContentSize(cc.size(84, self.spr_chapter_bg:getContentSize().height))
        self.spr_main:setVisible(false)
        self.node_star:setPosition(cc.p(0, 20))
        ex.Tools:setSpriteFrame(self.spr_relic, "trial/btn-unbroken.png")
    elseif type == 3 then
        self.spr_chapter_bg:setContentSize(cc.size(104, self.spr_chapter_bg:getContentSize().height))
        self.spr_main:setVisible(true)
        self.lbl_chapter:setVisible(false)
        self.node_star:setPosition(cc.p(0, 35))
        ex.Tools:setSpriteFrame(self.spr_relic, "god-relic/spr-relic-3.png")
    end
end

return GRMissionCastleCell