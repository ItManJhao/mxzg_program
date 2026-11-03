local BattleRoundCell = class("BattleRoundCell", require("src.layer.ui.UI_BattleRoundCell"))

function BattleRoundCell:onCreate()
    self.super.onCreate(self)
	self:setName("BattleRoundCell")

    self:setAnchorPoint(cc.p(0.5, 0.5))
    self:setIgnoreAnchorPointForPosition(false)
end

--[[
    @desc: 
    author:{author}
    time:2021-09-15 10:53:49
    --@round_data:  {bool} 当前round信息列表
	--@round_max: int   最大round值
    @return:
]]
function BattleRoundCell:resetData(round_data, round_max)
    if round_max == nil or round_max <= 0 then
        return
    end
    round_data = round_data or {}

    self.lbl_title:setString(ex.Tools:getLang(580569 + #round_data))

    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/battle-end-1.plist")

    self.node_round_info:removeAllChildren()
    for i=1,round_max do
        local round_info = round_data[i]

        local str_icon = "battle-end/spr-round-1.png"
        if round_info ~= nil then
            str_icon = "battle-end/spr-round-"..(round_info and 2 or 3)..".png"
        end
        local spr_icon = cc.Sprite:createWithSpriteFrameName(str_icon)
        spr_icon:setPosition((i - round_max / 2 - 0.5) * (spr_icon:getContentSize().width + 10), -spr_icon:getContentSize().height / 2)
        self.node_round_info:addChild(spr_icon)
    end
end

return BattleRoundCell
