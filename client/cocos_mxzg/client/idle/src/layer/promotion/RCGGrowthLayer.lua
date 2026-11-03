local RCGGrowthLayer = class("RCGGrowthLayer", require("src.layer.promotion.PromotionBaseLayer"))

-------------------------------------RCGGrowthLayer----------------------------------------------------
function RCGGrowthLayer:onCreateDone()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    local win_size = cc.Director:getInstance():getWinSize()
    
    local spr_banner = self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(2))
    
    local sub_size = cc.size(60, 60)
    self:resetScrollView(nil, sub_size)

    self.spr_box:setContentSize(cc.size(self.scroll_view:getViewSize().width + sub_size.width, self.scroll_view:getViewSize().height + sub_size.height))
    self.spr_box:setPosition(cc.p(self.scroll_view:getPositionX() - sub_size.width * 0.5, self.scroll_view:getPositionY() - sub_size.height * 0.5))

    self.spr_bg:setContentSize(cc.size(self.scroll_view:getViewSize().width + sub_size.width * 0.5, self.scroll_view:getViewSize().height + sub_size.height * 0.5))
    self.spr_bg:setPosition(cc.p(self.scroll_view:getPositionX() - sub_size.width * 0.25, self.scroll_view:getPositionY() - sub_size.height * 0.25))

    --self.btn_buy:setLabelOutLine(cc.c3b(109,33,22))
    self.btn_buy:setPosition(win_size.width * 0.52, spr_banner:getPositionY()*0.15) 
    self.btn_buy:getParent():setLocalZOrder(1)

    -- 播放按钮流光特效 add 熊梦
    -- local spr_effect_grawth = ex.EffectFactory:createEffectWithNodeByName("eff_grawth_btn")
    -- spr_effect_grawth:setPosition(self.btn_buy:getContentSize().width / 2, self.btn_buy:getContentSize().height / 2)
    -- self.btn_buy:addChild(spr_effect_grawth, 100)

    if self.lbl_tips ~= nil then
        self.lbl_tips:setPosition(self:getContentSize().width - 40, self.spr_bg:getPositionY() - 50)
        self.lbl_tips:setString(ex.Tools:getLang(41041))
    end

    self:updateLayer()
    self:addEvent(EVENT.MAIN_CITY_RECHARGE.PROMATION_BUY, handler(self, self.updateLayer))
end

function RCGGrowthLayer:updateLayer()
    -- 数据排序
    -- add 熊梦 成长基金排序
    local sort_list = {}
    for i,v in ipairs(cfg.promotionfoundation.promotionfoundation) do
        local is_buy = ex.Player.promotion_data:getPromotionRewardStatus(v.idx)
        if not is_buy then
            table.insert(sort_list, v.idx)
        end
    end
    -- 把foundation_list中已经领取的数据下标进行排序，然后加入到sort_list的末尾。
    table.sort(ex.Player.promotion_data.foundation_list)
    for i=1,#ex.Player.promotion_data.foundation_list do
        local idx = ex.Player.promotion_data.foundation_list[i]
        table.insert(sort_list, idx)
    end

    -- -- 排序。如果已经领取过的。就在最下面限时  此排序有问题 ，未修复
    -- table.sort(sort_list, function(a,b)
    --     local is_buy = ex.Player.promotion_data:getPromotionRewardStatus(a)
    --     local x = ex.Player.promotion_data.foundation_list[a] and 1000 or 0
    --     x = x + a

    --     local y = ex.Player.promotion_data.foundation_list[b] and 1000 or 0
    --     y = y + b

    --     return x < y--x > y
    -- end)

    
    
    local y = self.scroll_view:getContentOffset().y
    local cell_size = cc.size(550, 80)
    local scale = self.scroll_view:getViewSize().width / cell_size.width
    cell_size.height = cell_size.height * scale + 5
    local height = table.nums(sort_list) * cell_size.height
    height = math.max(height , self.scroll_view:getViewSize().height)
    self.scroll_view:getContainer():removeAllChildren()
    self.scroll_view:setContentSize(cc.size(self.scroll_view:getViewSize().width, height))
    self.scroll_view:setContentOffset(cc.p(0, self.scroll_view:getViewSize().height - height))

    -- 记录位置
    if self.scroll_view:getTag() ~= -1 then
        self.scroll_view:setContentOffset(cc.p(0, y))
    end
    self.scroll_view:setTag(0)


    local item_size = cc.size(60, 0)
    for i,v in ipairs(sort_list) do
        local data = cfg.promotionfoundation.promotionfoundation[sort_list[i]]

        local cell = require("src.layer.promotion.RCGGrowthCell"):createWithCCBIFile("ccbi/RCGGrowthCell.ccbi")
        cell:setScale(scale)
        cell:setPosition(0, height - i * cell_size.height)
        self.scroll_view:getContainer():addChild(cell)

        cell.menu:setIsTouchInsideNode(self.scroll_view)
        cell.btn_buy:registerScriptTapHandler(handler(self, self.onReward))
        cell.lbl_name:setString(string.format(ex.Tools:getLang(47278), data.level))
        cell.lbl_one:setString(string.format("X%d", data.item_one))
        cell.lbl_two:setString(string.format("X%d", data.item_two))
        
        cell.btn_buy.data = data
        local is_buy = ex.Player.promotion_data:getPromotionRewardStatus(data.idx)
        if is_buy then
            cell.btn_buy:setLabelText(ex.Tools:getLang(47677))
            ex.Tools:setAllGrayAuto( cell.btn_buy:getNormalImage(), true)
            cell.btn_buy:setEnabled(false)
        else

            if  ex.Player.promotion_data.is_buy_foundation == true and  ex.Player.level >= data.level then 
                ex.Tools:addRedPoint(cell.btn_buy,true)
            else 
                ex.Tools:addRedPoint(cell.btn_buy,false)
            end 

            cell.btn_buy:setLabelText(ex.Tools:getLang(47695))
        end
    end

    local vec_idx = ex.Player.shop_data:getRechargeList(RechargeKindType.PROMOTION)
    self.btn_buy:setLabelText(string.format(ex.Tools:getLang(47107) , vec_idx[1].rmb / 100))
    self.btn_buy:setVisible(ex.Player.promotion_data.is_buy_foundation == false)
end


function RCGGrowthLayer:onReward(tag, pSender)
    -- print("1111")
    if not ex.Player.promotion_data.is_buy_foundation then
        ex.MessageView:add(ex.Tools:getLang(47328), 0)
        return
    end
    -- print("222")

    if pSender.data.level > ex.Player.level then
        ex.MessageView:add(string.format(ex.Tools:getLang(47214), pSender.data.level))
        return
    end
    -- print("3333")

    -- 发送领取协议
	-- local req_reward = Promotion_pb.GReqPromotionReward()
	-- req_reward.type = 1 --4月卡 5至尊月卡
	-- req_reward.index = pSender.data.idx -- 已领天数
	-- NetManager:sendMessage(ProtocolID.GReqPromotionReward, req_reward)

	local req_reward = Promotion_pb.GReqFoundationReward()
	req_reward.idx = pSender.data.idx -- 已领天数
	NetManager:sendMessage(ProtocolID.GReqFoundationReward, req_reward)


    --ex.MessageView:add(string.format(ex.Tools:getLang(47358), ItemType.IT_GEM, ex.Tools:getLang(ItemType.IT_GEM), pSender.data.item_one), 0)
    --ex.MessageView:add(string.format(ex.Tools:getLang(47358), ItemType.IT_GEM, ex.Tools:getLang(ItemType.IT_GEM), pSender.data.item_two), 0)

    -- ex.Player:addRes(ItemType.IT_GEM, pSender.data.item_one + pSender.data.item_two)
    table.insert(ex.Player.promotion_data.foundation_list, pSender.data.idx)

    NetManager:sendMessage(ProtocolID.GReqPromotionList)
    
    self:updateLayer()
end

function RCGGrowthLayer:onBuy(tag, pSender)
    print(ex.Tools:getLang(47114))
    if ex.Player.promotion_data.is_buy_foundation then
        ex.MessageView:add(ex.Tools:getLang(47534), 0)
        return
    end

    local vec_recharge = ex.Player.shop_data:getRechargeList(RechargeKindType.PROMOTION)
    -- dump(cfg.buygem.buygem, RechargeKindType.PROMOTION)
    if table.nums(vec_recharge) <= 0 then
        return
    end
    ex.Player:pay(vec_recharge[1].idx)
end

return RCGGrowthLayer
