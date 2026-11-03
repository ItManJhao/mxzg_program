local ChapterRewardCell = class("ChapterRewardCell", require("src.comp.LuaLayerBase"))
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function ChapterRewardCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function ChapterRewardCell:onInit(data, idx)
    self.data = data
    if data == nil then
        return
    end

    local config = cfg.firstrewardchapter.firstrewardchapter[self.data.idx]
     
    -- 显示奖励
    for i,v in ipairs(config.reward) do
        -- dump(v)
        local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        item:setPosition(60 + 100 * (i - 1), 60)
        item:setScale(0.9)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        self.menu:addChild(item)
    end

    self.lbl_title:setString(string.format(ex.Tools:getLang(47173), config.chapter, ex.Player.chapter_data.chapter_id, config.chapter))

    if data.status == 0 then
        self.btn_battle:setEnabled(false)
        self.btn_battle:setLabelText(ex.Tools:getLang(47677))
    elseif data.status == 1 then
        self.btn_battle:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-green-1.png"))
        self.btn_battle:setSelectedImage(cc.Sprite:createWithSpriteFrameName("button/btn-green-1.png"))
        self.btn_battle:setLabelText(ex.Tools:getLang(47627))
        self.btn_battle:setLabelColor(cc.WHITE)
        self.btn_battle:setLabelOutLine(FONT_BROWN_C4B)
    elseif data.status == 2 then
        self.btn_battle:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-1.png"))
        self.btn_battle:setSelectedImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-1.png"))
        self.btn_battle:setLabelText(ex.Tools:getLang(47695))
        self.btn_battle:setLabelColor(cc.WHITE)
        self.btn_battle:setLabelOutLine(FONT_BROWN_C4B)
    end
end


-- 点击了领取奖励
function ChapterRewardCell:onReward(tag, pSender)
    local mission_ctr = require("src.layer.ChapterRewardCtr"):instance()
    if self.data.status == 2 then
        -- 发送领取奖励
        local config = cfg.firstrewardchapter.firstrewardchapter[self.data.idx]

        local req_chapter_first_reward = Battle_pb.GReqChapterFirstReward()
        req_chapter_first_reward.idx = config.chapter
        NetManager:sendMessage(ProtocolID.GReqChapterFirstReward, req_chapter_first_reward)
        ex.Player.chapter_data:rewardFirst(config.chapter)
        ex.Player.chapter_data:updateFirstRewardRedDot()
        -- ex.Player.chapter_data:update
        mission_ctr:updateLayer()
    elseif self.data.status == 1 then
        ex.MainSceneCtr:changeLayer(MainSceneType.MLT_BATTLE)
        mission_ctr:closeWindow(tag, pSender)
    end
end

return ChapterRewardCell