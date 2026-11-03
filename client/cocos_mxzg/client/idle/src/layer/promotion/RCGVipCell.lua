local RCGVipCell = class("RCGVipCell", require("src.comp.EventLayer"))

function RCGVipCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    local win_size = cc.Director:getInstance():getWinSize()

    self.progress_exp = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("promotion/prog-vip-1.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setPosition(self.spr_exp_bg:getPositionX(), self.spr_exp_bg:getPositionY())
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_exp_bg:getParent():addChild(self.progress_exp)

    self.lbl_vip_exp:setLocalZOrder(1)
    self.spr_banner:setScaleX(win_size.width / self.spr_banner:getContentSize().width)
    self:addEvent(EVENT.MAIN_CITY_RECHARGE.PROMATION_VIP_EXP, handler(self, self.updateLayer))
end


function RCGVipCell:updateLayer()

    local max_vip_level = table.nums(cfg.vip.vip) - 1 
    local next_level = math.min(max_vip_level, ex.Player.vip_level)
    self.lbl_now_level:setString(string.format("%d", ex.Player.vip_level))
    self.lbl_next_level:setString(string.format("%d", next_level + 1))

    local config_level = cfg.vip.vip[next_level]
    self.progress_exp:setPercentage(100.0 * ex.Player.vip_exp / config_level.vip_exp)
    self.lbl_vip_exp:setString(string.format("%d/%d", ex.Player.vip_exp, config_level.vip_exp))

    -- 计算需要充值的钻石数量
    local need_gem = ex.Player.shop_data:getNeedGem(config_level.vip_exp - ex.Player.vip_exp)
    self.lbl_need_gem:setString(tostring(need_gem))
    if self.lbl_need_gem:getContentSize().width > 95 then
        self.lbl_need_gem:setScale(95 / self.lbl_need_gem:getContentSize().width)
    else
        self.lbl_need_gem:setScale(1)
    end
end

return RCGVipCell