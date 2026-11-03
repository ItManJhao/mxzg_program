local GRMissionListLayer = class("GRMissionListLayer", require("src.comp.EventLayer"))

local ExTimer = require("src.ex.ExTimer")

function GRMissionListLayer:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/map-bg-god-relic-1.png", remove_type=1},
    }
    return vec_image
end

function GRMissionListLayer:onCreate()
    local sfc = cc.SpriteFrameCache:getInstance() 
    sfc:addSpriteFrames("ccbi-res/god-relic-lang.plist")

    self.scroll_view:setItemType(1)
    self.scroll_view:setItemSize(cc.size(600 * ex.s.global_scale, 165 * ex.s.global_scale))
    self.scroll_view.nodeTouched = handler(self, self.onJump)
    self.spr_bg:setScaleX(ex.s.global_scale)

    self:addEvent(EVENT.GOD_RELIC.UPDATE, handler(self, self.updateLayer))
    self:addEvent(EVENT.GOD_RELIC.BUY_COUNT, handler(self, self.updateLayer))

    self:addRedDotNode(RedDotType.ZCJ_DHZC_YGZC_ZSYJ_SZTB, self.btn_summon)
    NetManager:sendMessage(ProtocolID.GReqGodRelicData)
    
    -- self:updateLayer()
    self.timer = ExTimer:new():bind(self):run(handler(self, self.updateCDTime), 1.0)
    self:updateCDTime()
end

function GRMissionListLayer:updateCDTime()
    if self.btn_gift == nil then
        return
    end
    
    local min_cd = ex.Player.promotion_data:getGodRelicGiftMinCD()
    -- min_cd = 1586443421 + 86300
    local left_time = min_cd - ex.Game:getServerTime()
    if left_time <= 0 then
        self.btn_gift:setVisible(false)
        return
    end

    self.btn_gift:setVisible(true)
    if self.btn_gift.lbl_cd == nil then
        self.btn_gift.lbl_cd = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 36)
        :setColor(cc.c3b(118,225,59))
        :enableOutline(FONT_BLACK, 4)
        :setScale(0.5)
        :setAnchorPoint(0.5, 1)
        :setPosition(self.btn_gift:getContentSize().width / 2, 5)
        self.btn_gift:addChild(self.btn_gift.lbl_cd, 10)
    end

	self.btn_gift.lbl_cd:setString(string.format("%02d:%02d:%02d", math.floor(left_time / 3600), math.floor(left_time % 3600 / 60), math.floor(left_time % 60)))
end

function GRMissionListLayer:updateLayer()


    -- 更新挑战次数
    self.lbl_challenge_count:setString(string.format("%s/%s",
                                                     ex.Player.god_relic_data.can_challenge_count,
                                                     ex.Tools:getSysCfg("relic_daily_free_times")))
    self.lbl_buy_count:setString(string.format("%s",
    ex.Tools:getSysCfg("relic_daily_buy_times") - ex.Player.god_relic_data.buy_count))

    local vec_chapter = ex.Player.god_relic_data:getOpenChapterList()
    self.scroll_view.createItemFunction = function(data, scale)
        local cell = require("src.layer.godrelic.GRMissionListCell"):createWithCCBIFile("ccbi/GRMissionListCell.ccbi")
        cell:reset(data)
        cell:setScale(ex.s.global_scale)

        return cell
    end
    -- self.scroll_view:reloadData({{1},{1},{1},{1},{1},{1},{1},{1},{1},{1},{1},{1},{1},{1},{1},{1},{1},{1},{1},{1},{1},{1},{1},{1},{1}})
    self.scroll_view:reloadData(vec_chapter)
    -- add 熊梦 tableview 显示最底下一条
    self.scroll_view:setContentOffset(cc.p(0,0))
    -- self.scroll_view:setFocus(table.nums(vec_chapter))
end

function GRMissionListLayer:onJump(tag, pSender)
    if not pSender.chapter then
        return
    end
    
    if ex.Player.god_relic_data:isOpenChapter(pSender.chapter) ~= true or ex.Player.god_relic_data:isCanBattle(pSender.chapter) == false then
        ex.MessageView:add(string.format(ex.Tools:getLang(54511), cfg.godrelicunlock.godrelicunlock[pSender.chapter].unlock_need_star, ex.Player.god_relic_data:getStarCount()))
        return
    end


    ex.Player.god_relic_data.selected_chapter = pSender.chapter
    ex.JumpManager:jumpByAtom("main_god_relic")
end

function GRMissionListLayer:onBuyTime()
    if ex.Tools:getSysCfg("relic_daily_buy_times") - ex.Player.god_relic_data.buy_count <= 0 then
       ex.MessageView:add(ex.Tools:getLang(54510))
        return
    end

    -- if ex.Tools:getSysCfg("relic_daily_free_times") - ex.Player.god_relic_data.can_challenge_count <= 0 then
    --     ex.MessageView:add(ex.Tools:getLang(54510))
    --     return
    -- end
    local buy_need = ex.Tools:getSysCfg("relic_daily_buy_need")
    ex.ConfirmCtr:openWindow(ex.Tools:getLang(41301), string.format(ex.Tools:getLang(54509), buy_need[1].item_type, buy_need[1].item_num), function()
        NetManager:sendMessage(ProtocolID.GReqGodRelicBuyCount)
    end)
end

function GRMissionListLayer:onBack()
    ex.JumpManager:jumpByAtom("main_ancient")
end

function GRMissionListLayer:onGift()
    local vec_gift = ex.Player.promotion_data:getGodRelicGiftData()
    require("src.layer.GRMissionGiftCtr"):instance():openWindow(vec_gift)
end

function GRMissionListLayer:onRank()
    require("src.layer.RankTopThreeCtr"):instance():openWindow(RankTopThreeLayerType.GOD_RELIC)
end

function GRMissionListLayer:onSummon()
    ex.JumpManager:jumpByAtom("main_god_equip_summon")
end

function GRMissionListLayer:onShop()
    ex.JumpManager:jumpByAtom("main_god_equip_shop")
end

function GRMissionListLayer:onIllustration()
    ex.JumpManager:jumpByAtom("main_god_equip_illustration")
end

return GRMissionListLayer