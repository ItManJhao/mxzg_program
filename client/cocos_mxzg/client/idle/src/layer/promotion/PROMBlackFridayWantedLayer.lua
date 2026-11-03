--[[
* @Description: 黑色星期五-黑五通缉
* @Author: 熊梦
* @Date: 2020-07-29 15:28:00
* ]]
local PROMBlackFridayWantedLayer = class("PROMBlackFridayWantedLayer", require("src.layer.promotion.PromotionBaseLayer"))

local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")

function PROMBlackFridayWantedLayer:onCreateDone()
    self.select_idx = 1
    self:setSwallowTouches(false)
    self:setAutoClose(false)
    self.spr_jp:setLocalZOrder(100)
    self.spr_xy:setLocalZOrder(100)
    self.menu:setLocalZOrder(1)
    
    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(1301))

    self.node_main:setLocalZOrder(100)
    self.node_act_time:setPositionY(self.spr_banner:getPositionY() - self.spr_banner:getContentSize().height / 2 + 40)
    self.node_act_time:setLocalZOrder(100)

    ex.Tools:setLimitWidth(self.lbl_task_name, 100)

    self.node_main:setPositionY((self.spr_banner:getPositionY() - self.spr_banner:getContentSize().height / 2 + 40 - 180))

    self.spr_bg:setPositionY(self.layer_promotion:getTopY() - 126)
    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    self.spr_bg:setScaleY(self.spr_bg:getPositionY() / (self.spr_bg:getContentSize().height - 59.5))
    self:registerBtnEvent()
    self:createBtnLabel()

    self:createProgressAndBox()
    self:createSlotItems()
    self:createRichText()
    self:updateRes()

    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
    self:updateTimer()

    self:updateLayer()
    self:addEvent(EVENT.BLACKFRIDAY.SUMMON, handler(self, self.onSummon))
    self:addEvent(EVENT.BLACKFRIDAY.BOX_REWARD, handler(self, self.onBoxReward))
    --self:addEvent(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM, handler(self, self.onItemChange))
end

--function PROMBlackFridayWantedLayer:onItemChange(event,data)
    --local cost = cfg.system.promotion083_lottery_cost[1]
    --for i,v in ipairs(data) do
        --if v.type == cost.item_type then 
            --self:updateRes()
            --break
        --end 
    --end
--end 

function PROMBlackFridayWantedLayer:updateRes()
    local cost = cfg.system.promotion083_lottery_cost[1]
    local has_num = ex.Player:getItemNum(cost.item_type)
    self.lbl_res_num:setString(has_num)
    self.spr_res_icon:setSpriteFrame(string.format("backpack/%d.png",cost.item_type))
end 

function PROMBlackFridayWantedLayer:onExit()
    self:removeTimerByName("timer")
end

function PROMBlackFridayWantedLayer:updateTimer()
    local is_open = cfg.funcopen["act_black_friday"].isVisible()

    local data = ex.Player.promotion_data:getPromotionDatas(83)
    
    if not data then 
        if self.layer_promotion then
            self:removeTimerByName("timer")
            self.layer_promotion:resetTabView()
        end
        return 
    end 
    local cur_time = ex.Game:getServerTime()
    if cur_time > data.end_time then
        if self.layer_promotion then
            self:removeTimerByName("timer")
            self.layer_promotion:resetTabView()
        end
        return
    end
    self.lbl_time:setString(ex.Tools:formatTime5(data.end_time - ex.Game:getServerTime()))
end

function PROMBlackFridayWantedLayer:onBoxReward(event,data)
    self:updateProgress()
    self:updateBox()
end 

function PROMBlackFridayWantedLayer:onSummon(event,data)
    self:runSelect(data)
end 

function PROMBlackFridayWantedLayer:createBtnLabel()
    
    self.lbl_btn_one = cc.Label:createWithTTF(ex.Tools:getLang(91814), FONT_DEFAULT_NAME_BOLD, 24)
    self.lbl_btn_one:setColor(cc.c3b(14,8,94))
    self.btn_one:addChild(self.lbl_btn_one)
    self.lbl_btn_one:setPosition(self.btn_one:getContentSize().width * 0.5, self.btn_one:getContentSize().height * 0.5)

    -- 繁体适配注释 别的版本就解除掉
    --ex.Tools:setLimitWidth(self.lbl_btn_one, 140)
    --------------------------------------
    
    

    
    self.lbl_btn_ten = cc.Label:createWithTTF(ex.Tools:getLang(91815), FONT_DEFAULT_NAME_BOLD, 24)
    self.lbl_btn_ten:setColor(cc.c3b(14,8,94))
    self.btn_ten:addChild(self.lbl_btn_ten)
    self.lbl_btn_ten:setPosition(self.btn_ten:getContentSize().width * 0.5, self.btn_ten:getContentSize().height * 0.5)

    -- 繁体适配注释 别的版本就解除掉
    --ex.Tools:setLimitWidth(self.lbl_btn_ten, 140)
    --------------------------------------
    
end

function PROMBlackFridayWantedLayer:registerBtnEvent()
    self.btn_one:registerScriptTapHandler(handler(self,self.onSlot))
    self.btn_ten:registerScriptTapHandler(handler(self,self.onSlot))
    self.btn_info:registerScriptTapHandler(handler(self,self.onInfo))
    self.btn_add:registerScriptTapHandler(handler(self,self.onAdd))
end

function PROMBlackFridayWantedLayer:onAdd(tag,pSender)
    local cost = cfg.system.promotion083_lottery_cost[1]
    ex.Tools:onClickItemSrc(cost.item_type)
end

function PROMBlackFridayWantedLayer:onInfo(tag,pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(91811),ex.Tools:getLang(91812))
end

function PROMBlackFridayWantedLayer:onSlot(tag,pSender)

    local is_selected_reward = ex.Player.promotion_data:BlackFiveLotteryisSelected()
    if is_selected_reward then 
        local cost_cfg = cfg.system.promotion083_lottery_cost[1]
        local item_type = cost_cfg.item_type
        local need_num = cost_cfg.item_num * (tag == 1 and 1 or 10)
        local has_num = ex.Player:getItemNum(item_type)
        if has_num >= need_num then 
            self:setBtnStatus(false)
            local proto = Promotion083_pb.GReqBlackFiveLotteryLottery()
            proto.num = tag == 1 and 1 or 10
            NetManager:sendMessage(ProtocolID.GReqBlackFiveLotteryLottery, proto)
        else 
            ex.Tools:onClickItemSrc(item_type)
            return 
        end 
    else 
        
        local function callback(idx)
            
        end 
        local cfg_data = cfg.promotion083lotteryreward.promotion083lotteryreward[1].show_hero_reward
        dump(cfg_data)
        require("src.layer.promotion.PROMBlackFridayWantedHeroCtr"):instance():openWindow(cfg_data,callback) 
    end 
end

function PROMBlackFridayWantedLayer:createProgressAndBox()
    
    self.progressTimer = require("src.comp.UIProgressTimerEquidistant"):create(cc.Sprite:createWithSpriteFrameName("prom-dragonboat/spr-jdt2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setScaleX(self.spr_progress_bg:getScaleX())
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0))
    self.spr_progress_bg:addChild(self.progressTimer)
    self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2 - 8 ,self.spr_progress_bg:getContentSize().height / 2 )

    ex.Tools:setLabelOffset(self.lbl_time_tip, self.lbl_time)

    self.node_point:setScale(math.min(1, ex.p.width / 600))

    local width = self.spr_progress_bg:getContentSize().width
    self.box_list = {}
    for i,v in ipairs(cfg.promotion083lotterycountreward.promotion083lotterycountreward) do        
        local x = i / #cfg.promotion083lotterycountreward.promotion083lotterycountreward
        
        local box = cpp.UIMenuItemImage:createWithSpriteFrameName("other/spr-box-" .. i .. ".png", nil, nil)
        box.data = v
        box:registerScriptTapHandler(handler(self, self.onClickBox))
        box:setTag(i)
        box:setScale(0.95)
        self.menu:addChild(box, 1)
        box:setPosition(x * width, 10)

        local lbl = cc.Label:createWithTTF(string.format(ex.Tools:getLang(75103), v.count),FONT_DEFAULT_NAME_BOLD,18)
        self.spr_progress_bg:addChild(lbl)
        lbl:setColor(cc.c3b(253,228,181,255))
        lbl:enableOutline(cc.c3b(87,56,29),2)
        lbl:setPosition(box:getPositionX(), box:getPositionY() - 27.5)
        lbl:setLocalZOrder(1)
        ex.Tools:setLimitWidth(lbl, 100)

        local box_data = {}
        box_data.box = box
        box_data.lbl = lbl
        table.insert(self.box_list, box_data)

        self.progressTimer:addData({pos = x * 100, count = v.count}, false)
    end
end

function PROMBlackFridayWantedLayer:updateProgress()
    local str = ex.Tools:getLang(91810)
    str = string.format(str,ex.Player.promotion_data.blackfivelottery_remaining_count)
    self.rich_text:setXmlTextLua(str)
    local num = ex.Player.promotion_data.blackfivelottery_summon_count
    self.lbl_task_num:setString(num)
    -- 更新宝箱进度条
    self.progressTimer:setPercentageCount(num)
end

function PROMBlackFridayWantedLayer:updateBox()
    -- 更新箱子状态
    for i,v in ipairs(self.box_list) do
        local box = v.box
        local status = ex.Player.promotion_data:checkBlackFiveLotteryBoxStatus(box.data.idx)

        box:removeChildByName("box_effect")
        local node_eff = cc.Node:create()
        node_eff:setName("box_effect")
        box:addChild(node_eff)


        local image = status > 0 and ("other/spr-box-" .. i ..".png") or ("other/spr-box-open-" .. i ..".png")
        ex.Tools:setSpriteFrame(box:getNormalImage(), image)

        local effId = status == 0 and 11 or 10
        ex.EffectCtr:playNormalEff(effId, box:getContentSize().width * 0.5, box:getContentSize().height * 0.5, nil, node_eff, 10)
        :setAnchorPoint(0.55, 0.12)
    end
end

function PROMBlackFridayWantedLayer:updateLayer()
    self:updateProgress()
    self:updateBox()
    self:updateRes()
end

function PROMBlackFridayWantedLayer:createRichText()
    local size = self.spr_tips_bg:getContentSize()
    self.rich_text = ex.Tools:createRichText(self.spr_tips_bg, "", 22, false, cc.p(size.width  / 2 + 7.5, size.height / 2+5), nil, nil, 3, ex.a.center)

    local str = ex.Tools:getLang(91810)
    str = string.format(str,ex.Player.promotion_data.zhongqiu_data:getRemainingCount())
    self.rich_text:setXmlTextLua(str)

    -- 繁体适配注释 别的版本就解除掉
    --self.rich_text:formatText()
    --ex.Tools:setLimitWidth(self.rich_text, 400)
    --------------------------------------
end

function PROMBlackFridayWantedLayer:createSlotItems()
    self.menu_item:removeAllChildren()
    for i,v in ipairs(cfg.promotion083lotteryreward.promotion083lotteryreward) do
        local x,y = self["item_"..i]:getPosition()
        local show_cfg = v.show_reward[1]

        local item = UIMenuItemBag:createWithData(show_cfg.item_type,show_cfg.item_num)
        self.menu_item:addChild(item)
        item:setPosition(x,y)
        item:setTag(v.idx)
        item:registerScriptTapHandler(handler(self,self.onClickItem))
        item.data = v

        if v.type == 1 then 
            self.spr_jp:setPosition(cc.p(x - item:getContentSize().width / 2 ,y + item:getContentSize().height / 2))
        elseif v.type == 2 then 
            self.spr_xy:setPosition(cc.p(x + item:getContentSize().width / 2 ,y + item:getContentSize().height / 2))
        end 
    end
    self.spr_select:setPosition(self.item_1:getPosition())
end

function PROMBlackFridayWantedLayer:onClickItem(tag,pSender)
    local is_show_window = pSender.data.type == 1
    if is_show_window then 
        local cfg_data = cfg.promotion083lotteryreward.promotion083lotteryreward[1].show_hero_reward
        
        require("src.layer.promotion.PROMBlackFridayWantedHeroCtr"):instance():openWindow(cfg_data) 
    else
        ex.Tools:showItemInfo(tag,pSender)
    end 
end

function PROMBlackFridayWantedLayer:onClickBox(tag, pSender)

    local data = clone(pSender.data)
    local status = ex.Player.promotion_data:checkBlackFiveLotteryBoxStatus(data.idx)
    local can_get = status == 0
    local function callback()
        local req = Promotion083_pb.GReqBlackFiveLotteryGetLotteryCountReward()
        req.idx = pSender.data.idx
        NetManager:sendMessage(ProtocolID.GReqBlackFiveLotteryGetLotteryCountReward, req)
    end
	require("src.layer.SevenTargetRewardInfoCtr"):instance():openWindow(data, can_get, callback)
end

function PROMBlackFridayWantedLayer:getRunAction(run_time,callback)
    local action_callback = cc.CallFunc:create(callback)
    local delay = cc.DelayTime:create(run_time)
    local sequence = cc.Sequence:create(action_callback, delay)
    return sequence
end

function PROMBlackFridayWantedLayer:runSelect(data)
    --self:removeAutoRun()
    local point = self.select_idx
    local length = 12
    local callback = function ()
        local x,y = self["item_" .. point]:getPosition()
        self.spr_select:setPosition(cc.p(x,y))
        point = point + 1
        if point > length then 
            point = 1
        end
    end
    local max_time = 3
    local run_time = 0.01 
    local total_time = 0
    local action_list = {}
    while total_time < max_time do 
        local sequence = self:getRunAction(run_time,callback)
        table.insert(action_list,sequence)
        run_time = run_time + 0.01
        total_time = total_time + run_time
    end

    local target = data.idx

    local all_run_count = #action_list + point 
    local mod = all_run_count % length
    local count = 0
    if mod ~= target then 
        if mod == 0 then 
            count = target
        else
            if target > mod then 
                count = target - mod

            else
                count = length - mod + target 
            end
        end
    end

    for i=1,count + 1 do
        local sequence = self:getRunAction(run_time,callback)
        table.insert(action_list,sequence)
        run_time = run_time + 0.05
        --run_time = run_time + 0.1
        total_time = total_time + run_time
    end

    local end_callback = cc.CallFunc:create(function()
        local vec_reward = {}
        for i,v in ipairs(data.reward) do
            local item = {}
            item.item_type = v.type 
            item.item_num = v.num
            table.insert(vec_reward,item)
        end
        require("src.layer.ItemRewardCtr"):instance():openWindow(vec_reward)
        self:setBtnStatus(true)
        self:updateLayer()
    end)

    local delay = cc.DelayTime:create(run_time)
    local end_sequence = cc.Sequence:create(end_callback, delay)
    table.insert(action_list,end_sequence)


    local sequence = cc.Sequence:create(action_list)
    self.spr_select:runAction(sequence)
    self.select_idx = target
end

function PROMBlackFridayWantedLayer:setBtnStatus(bool)
    self.btn_one:setEnabled(bool)
    self.btn_ten:setEnabled(bool)
    
end

return PROMBlackFridayWantedLayer

