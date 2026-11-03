--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-02-09 20:51:29
]]

local FantasyTowerRewardCell = class("FantasyTowerRewardCell", require("src.comp.LuaLayerBase"))


function FantasyTowerRewardCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.btn_battle:setLabelText("--")
    self.btn_battle:setLabelColor(FONT_BLACK)
end

function FantasyTowerRewardCell:onInit(data, idx)
    self.data = data
    local config = cfg.firstrewardtower.firstrewardtower[self.data.idx]

    -- 显示奖励
    for i,v in ipairs(config.reward) do
        -- dump(v)
        local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        item:setPosition(60 + 100 * (i - 1), 60)
        item:setScale(0.9)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        self.menu:addChild(item)
    end

    self.lbl_title:setString(string.format(ex.Tools:getLang(47523), config.chapter, ex.Player.tower_data.now_stage - 1, config.chapter))

    if data.status == 0 then
        self.btn_battle:setEnabled(false)
        self.btn_battle:setLabelText(ex.Tools:getLang(47677))
        self.btn_battle:setLabelColor(cc.WHITE)
        self.btn_battle:setLabelOutLine(FONT_GRAY_C4B, 4)
    elseif data.status == 1 then
        self.btn_battle:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-green-1.png"))
        self.btn_battle:setSelectedImage(cc.Sprite:createWithSpriteFrameName("button/btn-green-1.png"))
        self.btn_battle:setLabelText(ex.Tools:getLang(47627))
        self.btn_battle:setLabelColor(cc.WHITE)
        self.btn_battle:setLabelOutLine(FONT_DARK_BLUE_C4B, 4)
    elseif data.status == 2 then
        self.btn_battle:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-1.png"))
        self.btn_battle:setSelectedImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-1.png"))
        self.btn_battle:setLabelText(ex.Tools:getLang(47695))
        self.btn_battle:setLabelColor(cc.WHITE)
        self.btn_battle:setLabelOutLine(FONT_RED, 4)
    end
end

-- 点击了领取奖励
function FantasyTowerRewardCell:onReward(tag, pSender)
    local mission_ctr = require("src.layer.MissionRewardCtr"):instance()
    if self.data.status == 2 then
        local config = cfg.firstrewardtower.firstrewardtower[self.data.idx]

        -- 发送领取奖励
        -- local req_tower_first_reward = ProtocolRequest.ReqTowerFirstReward
        -- req_tower_first_reward.idx.value = self.data.idx
        -- NetManager:sendLuaData(req_tower_first_reward)
        local req_tower_first_reward = Tower_pb.GReqTowerFirstReward()
        req_tower_first_reward.idx = config.chapter
        NetManager:sendMessage(ProtocolID.GReqTowerFirstReward, req_tower_first_reward)


        ex.Player.tower_data:rewardFirst(config.chapter)
        ex.Player.tower_data:sortReward()
        ex.Player.tower_data:updateFirstRewardRedDot()
        
        -- require("src.layer.ItemRewardCtr"):instance():openWindow(self.data.reward)
        mission_ctr:updateLayer()
    else
        -- require("src.layer.SevenTargetRewardInfoCtr"):instance():openWindow(self.data, false, nil)
        mission_ctr:closeWindow(0, nil)
    end
end

return FantasyTowerRewardCell