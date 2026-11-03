--[[
    func: 第三号横幅层
    author:徐东浩
    time:2019-10-21 14:31:00
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local Common3BannerLayer = class("Common3BannerLayer", require("src.layer.promotion.Common1BannerLayer"))
local CommonUIHelper = require("src.layer.promotion.CommonUIHelper")

function Common3BannerLayer:onCreate()
    self.super.onCreate(self)
	self:setName("Common3BannerLayer")

    self.ext_info = {}

    self.progress_timer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("promotion/spr-progress-fg1.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setScaleX(1)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_progress_bg:addChild(self.progress_timer)
    self.progress_timer:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2 )
    
    self.btn_level_reward:registerScriptTapHandler(handler(self, self.onClick))
    self.btn_more:registerScriptTapHandler(handler(self, self.onClick))
    self.btn_do:registerScriptTapHandler(handler(self, self.onClick))
end

function Common3BannerLayer:onCreateDone(owner, ui_layout_arg, data, banner_id)
    self.super.onCreateDone(self, owner, ui_layout_arg, data, banner_id)
end

function Common3BannerLayer:refreshData()
    self.ext_info = ex.Player.promotion_data:getCommonActivityExtInfoTable(self.data.idx)
end

function Common3BannerLayer:updateProgress(value, total_value)
    total_value = total_value == 0 and 1
    self.progress_timer:setPercentage(math.min(1, value / total_value))
end

function Common3BannerLayer:refreshExpStatus()
    if self.ext_info == nil or self.ext_info.exp == nil then
        return
    end
    
    local level, config = self:getConfigExpLevel(self.ext_info.exp)
    ex.Tools:setSpriteFrame(self.spr_level, string.format("promotion/spr-number-%d.png", level))
    
    self:updateProgress(self.ext_info.exp, config.exp_need)
    
    self.lbl_progress:setString(tostring(self.ext_info.exp).."/"..tostring(config.exp_need))
    
    for i=1,3 do
        local node_name = "node_next_reward_"..i
        if config.reward[i] ~= nil then
            self[node_name]:setVisible(true)
            
            local icon_name = "spr_next_reward_"..i
            ex.Tools:setSpriteFrame(self[icon_name], ex.Tools:getItemImageName(config.reward[i].item_type))
            
            local number_name = "lbl_next_reward_"..i
            self[number_name]:setString(ex.StringUtil.getScientificNumber(config.reward[i].item_num))
        else
            self[node_name]:setVisible(false)
        end
    end
end

function Common3BannerLayer:getConfigExpLevel(exp)
    local config_table = cfg.promotionadventurenoteslevelreward.promotionadventurenoteslevelreward
    local level, config, last_config = 0, nil, nil
    for i,v in ipairs(config_table) do
        if self.data.turns == v.turns then
            if v.exp_need > exp then
                config = v
                break
            end
            level = v.level
            last_config = v
        end
    end
    
    if config == nil then   -- 超过最高级
        config = last_config
    end
    
    return level, config
end

function Common3BannerLayer:getConfigRecharge()
    local is_got = function(idx)
        for i,v in ipairs(self.ext_info.idx_recharge_reward) do
            if v == idx then  
                return true 
            end
        end
        return false
    end

    local config_table = cfg.promotionadventurenotesrechargereward.promotionadventurenotesrechargereward
    local idx, config, last_config = 1, nil, nil
    for i,v in ipairs(config_table) do
        if self.data.turns == v.turns then
            if v.recharge_need > self.ext_info.total_recharge or not is_got(v.idx) then
                idx = v.idx
                config = v
                break
            end

            last_config = v
        end
    end

    if config == nil then
        idx = last_config.idx
        config = last_config
    end

    return is_got(idx), config
end

function Common3BannerLayer:refreshRechargeStatus()
    local is_got, config = self:getConfigRecharge()

    self.title:setString(string.format(ex.Tools:getLang(52503), config.recharge_need / 100))
    self.num_lab:setString("("..self.ext_info.total_recharge / 100 .. "/" .. config.recharge_need / 100 ..")")

    if not is_got then
        self.btn_do:setLabelText(ex.Tools:getLang(2214))
    end
    self.btn_do:setVisible(not is_got)
    self.spr_got:setVisible(is_got)

    local begin = 24
    local margin = 5
    local posY = 58
    local scale = 0.75
    for i,v in ipairs(self.config.reward) do
        local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        local posX = (begin + item:getContentSize().width * scale / 2) + (i - 1) * ((item:getContentSize().width * scale) + margin)
        item:setPosition(posX, posY)
        item:setScale(scale)
        item:registerScriptTapHandler(handler(self, self.onClick))
        item:setLocalZOrder(i * 10)
        self.menu:addChild(item)
    end
end

function Common3BannerLayer:refresh()
    self.super.refresh(self)

    self:refreshData()
    
    self:refreshExpStatus()
    
    self:refreshRechargeStatus()
end

function Common3BannerLayer:onClick(tag, pSender)
    if pSender == self.btn_do then
        local is_got, config = self:getConfigRecharge()
        if not is_got and self.ext_info.total_recharge >= config.recharge_need then
            local req_get = Task4_pb.GReqAdventureNoteRechargeGet()
            req_get.idx = config.idx
            NetManager:sendMessage(ProtocolID.GReqAdventureNoteRechargeGet, req_get)
        else
            print("Common3BannerLayer:onClick is can get reward!")
        end
    elseif pSender == self.btn_level_reward then
        -- 打开窗口
    elseif pSender == self.btn_more then
        -- 打开窗口
    else
        if pSender.item_type ~= nil then
            ex.Tools:onClickItemInfo(pSender.item_type)
        else
            print("Common3BannerLayer:onClick no handle!")
        end
    end
end

return Common3BannerLayer