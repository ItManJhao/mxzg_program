--[[
* @Description: 五一
* ]]
local PROMFiveOneLuckDrawLayer = class("PROMFiveOneLuckDrawLayer", require("src.layer.promotion.PromotionBaseLayer"))

function PROMFiveOneLuckDrawLayer:onCreateDone()
    self:setSwallowTouches(false)
    self:setAutoClose(false)
    self:addPlist()

    -- self.menu:setLocalZOrder(1)

    ex.Tools:setLabelOffset(self.lbl_time_tip, self.lbl_time)
    -- self.btn_info:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60, self.btn_info:getPositionY())
    self.btn_info:registerScriptTapHandler(handler(self, self.onClickShowTips))
    self.btn_add:registerScriptTapHandler(handler(self, self.onAddClick))
    
    -- self.spr_bg2 = cc.Sprite:create("ccbi-res/five_one_rewardBg.png")
    -- self.spr_bg2:setAnchorPoint(0, 0)
    -- self.spr_bg2:setPosition(0, 0)
    -- self:addChild(self.spr_bg2, -5)

    self.spr_bg:setPositionY(self.layer_promotion:getTopY())
    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    self.spr_bg:setScaleY(self.spr_bg:getPositionY() / (self.spr_bg:getContentSize().height))

    self:addEvent(EVENT.FIVE_ONE.EVENT_UPDATE_ALL_LAYER, handler(self, self.updateLayer))
    self:addEvent(EVENT.FIVE_ONE.EVENT_REWARD_FINISH, handler(self, self.luckDrawCallBack))
    self:addEvent(EVENT.FIVE_ONE.EVENT_GIFT_CHOOSE, handler(self, self.updateChooseGiftShow))

    self.startPos = {}
    for i=1,16 do
        self["btn_choose"..i]:setTag(i)
        self["btn_choose"..i]:registerScriptTapHandler(handler(self, self.openChooseView))
        self["itemBg_btn"..i]:setTag(i)
        self["itemBg_btn"..i]:registerScriptTapHandler(handler(self, self.rewardClickShow))
        table.insert(self.startPos, cc.p(self["item_"..i]:getPositionX(), self["item_"..i]:getPositionY()))
    end
    self.btn_once:registerScriptTapHandler(handler(self, self.btn_once_click))
    self.btn_skip:setChecked(cc.UserDefault:getInstance():getBoolForKey("five_one_rewardChecked", false))

    local btn_size = self.btn_once:getContentSize()
    local lbl_btn_txt10 = cc.Label:createWithTTF(ex.Tools:getLang(6144), FONT_DEFAULT_NAME_BOLD, 24)
    :enableOutline(FONT_BROWN, 1)
    :enableShadow(FONT_BROWN, cc.size(1, -1))
    :setPosition(btn_size.width/2, btn_size.height/2)
    self.btn_once:addChild(lbl_btn_txt10)

    local spr_bg1 = cc.Sprite:createWithSpriteFrameName("prom-five_one/five_one_sprFrame.png")
    spr_bg1:setPosition(cc.p(self.btn_once:getPositionX(), self.btn_once:getPositionY() - self.btn_once:getContentSize().height/2 - 25));
    self.node_slot:addChild(spr_bg1)


    local lbl_draw_tips1 = cc.Label:createWithTTF(ex.Tools:getLang(6149), FONT_DEFAULT_NAME_BOLD, 20)
    :setColor(cc.c4b(255,230,58,255))
    :setAnchorPoint(cc.p(1, 0.5))
    :setPosition(cc.p(self.btn_once:getPositionX(), self.btn_once:getPositionY() - self.btn_once:getContentSize().height/2 - 25))
    self.node_slot:addChild(lbl_draw_tips1)

    local lbl_draw_tips2 = cc.Label:createWithTTF(ex.Tools:getLang(6150), FONT_DEFAULT_NAME_BOLD, 20)
    :setColor(cc.c4b(255,255,255,255))
    :setAnchorPoint(cc.p(0, 0.5))
    :setPosition(cc.p(self.btn_once:getPositionX() + 5, self.btn_once:getPositionY() - self.btn_once:getContentSize().height/2 - 25))
    self.node_slot:addChild(lbl_draw_tips2)

    spr_bg1:setContentSize(cc.size(lbl_draw_tips1:getContentSize().width * lbl_draw_tips1:getScaleX() + lbl_draw_tips2:getContentSize().width * lbl_draw_tips2:getScaleX() + 80, 44))

    self:updateLayer()
    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
    self:updateTimer()
end

function PROMFiveOneLuckDrawLayer:updateLayer()
    self:setRewardImgShow()
    self:updateRewardShow()
end

--刷新奖励领取显示
function PROMFiveOneLuckDrawLayer:updateRewardShow()
    self:updateResumeShow() --刷新抽奖消耗

    --显示以抽到的图标
    local nowFiveOneData = ex.Player.promotion_data:getSaveFiveOneData()
    if nowFiveOneData and nowFiveOneData.reward_record then
        for i,v in ipairs(nowFiveOneData.reward_record) do
            if self["finish_spr"..v] then
                self["finish_spr"..v]:setVisible(true)
            end
        end
    end
end


function PROMFiveOneLuckDrawLayer:rewardShowClick(  )
    print("点击奖励预览按钮")
    require("src.layer.promotion.PROMFiveOneRewardCtr"):instance():openWindow()
   
end

--打开重新选择奖励按钮
function PROMFiveOneLuckDrawLayer:openChooseView(tag, pSender)
    local isFinish = ex.Player.promotion_data:isFinishByPosIndex(tag)
    if isFinish then
        ex.MessageView:add(ex.Tools:getLang(6148))
        return
    end
    local data = {}
    data.place_reward = {}
    data.posData = {}
    local nowFiveOneData = ex.Player.promotion_data:getSaveFiveOneData()
    if nowFiveOneData.cur_round then
        local nowShowConfigInfo = ex.Player.promotion_data:getConfigInfByRound(nowFiveOneData.cur_round)
        if nowShowConfigInfo then
            for i,v in ipairs(nowShowConfigInfo) do
                if v.canChoice == 1 then
                    table.insert(data.place_reward, v.reward)
                    table.insert(data.posData, v.position)
                end
            end
        end
    end
    require("src.layer.promotion.PROMFiveOneSelectedCtr"):instance():openWindow(data, tag)
end

--  抽奖返回
function PROMFiveOneLuckDrawLayer:luckDrawCallBack(_, rewardData)
   if self.btn_skip:isChecked() then
        require("src.layer.ItemRewardCtr"):instance():openWindow(self:getRewardList(rewardData))
        self:updateRewardShow()
   else
        self:playActionShow(rewardData)
   end
end

function PROMFiveOneLuckDrawLayer:getRewardList(rewardData)
    local reward_list = {}
    local smallList = {}
    smallList.item_type = rewardData.id
    smallList.item_num = rewardData.num
    smallList.item_id = rewardData.id
    smallList.star = rewardData.star
    table.insert(reward_list, smallList)
    return reward_list
end

--播放动画
function PROMFiveOneLuckDrawLayer:playActionShow(rewardData)
    self.node_slot:runAction(cc.Sequence:create(cc.CallFunc:create(function (repeatAction)
                                local action = cc.RepeatForever:create(cc.RotateBy:create(0.7, 360))
                                action:setTag(1000)
                                self.zhuanpan_bg:runAction(action)
                            end),
                            cc.CallFunc:create(function ()
                                for i=1,16 do
                                    self["item_"..i]:runAction(cc.Sequence:create(  cc.MoveTo:create(2, cc.p(self.centent_node:getPositionX(), self.centent_node:getPositionY())),
                                                                                    cc.DelayTime:create(0.1),
                                                                                    cc.CallFunc:create(function ()
                                                                                        self["item_"..i]:setVisible(false)
                                                                                    end)))
                                end
                            end),
                            cc.DelayTime:create(2.2),
                            cc.CallFunc:create(function ()
                                --弹出奖励界面
                                require("src.layer.ItemRewardCtr"):instance():openWindow(self:getRewardList(rewardData))
                            end),
                            cc.DelayTime:create(0.1),
                            cc.CallFunc:create(function ()
                                for i=1,16 do
                                    self["item_"..i]:setPosition(self.startPos[i])
                                    self["item_"..i]:setVisible(true)
                                end
                                self.zhuanpan_bg:stopActionByTag(1000)
                                self.zhuanpan_bg:setRotation(0)
                            end),
                            cc.CallFunc:create(function ()
                                self:updateRewardShow()
                            end)))
end

--请求抽奖按钮
function PROMFiveOneLuckDrawLayer:btn_once_click()
    local nowFiveOneData = ex.Player.promotion_data:getSaveFiveOneData()
    if nowFiveOneData then
        local resumeInfo = ex.Player.promotion_data:getResumeByRoundsAndCounts(nowFiveOneData.cur_round, nowFiveOneData.times)
        if resumeInfo and resumeInfo[1] then
            local nowHaveNum = ex.Player:getItemNum(resumeInfo[1].item_type)
            if nowHaveNum >= resumeInfo[1].item_num then
                NetManager:sendMessage(ProtocolID.GReqLaborDayLuckDraw) 
                self.btn_once:setEnabled(false)
            end
        end
    end
end

--刷新抽奖消耗显示
function PROMFiveOneLuckDrawLayer:updateResumeShow(  )
    local nowFiveOneData = ex.Player.promotion_data:getSaveFiveOneData()
    if nowFiveOneData then
        local resumeInfo = ex.Player.promotion_data:getResumeByRoundsAndCounts(nowFiveOneData.cur_round, nowFiveOneData.times)
        if resumeInfo and resumeInfo[1] then
            local file_name = ex.Tools:getItemImageName(resumeInfo[1].item_type) or ""
            ex.Tools:setSpriteFrame(self.spr_res_icon, file_name)
            self.lbl_res_num:setString(ex.Player:getItemNum(resumeInfo[1].item_type).. "/" .. resumeInfo[1].item_num)
            ex.Tools:addRedPoint(self.btn_once, ex.Player:getItemNum(resumeInfo[1].item_type) >= resumeInfo[1].item_num, cc.p(0.85,0.8))
            self.btn_once:setEnabled(ex.Player:getItemNum(resumeInfo[1].item_type) >= resumeInfo[1].item_num)
            local spr = self.btn_once:getNormalImage()
            ex.Tools:setGrayAuto(spr, not (ex.Player:getItemNum(resumeInfo[1].item_type) >= resumeInfo[1].item_num))
            if (nowFiveOneData.cur_round == #cfg.promotion097labordayreward.promotion097labordayreward and #nowFiveOneData.reward_record >= 16) or
                (nowFiveOneData.cur_round > #cfg.promotion097labordayreward.promotion097labordayreward) then
                    self.btn_once:setEnabled(false)
                    ex.Tools:addRedPoint(self.btn_once,false)
                    ex.Tools:setGrayAuto(spr, true)
                    local is_open = ex.Player.promotion_data:getIsShowFiveOneRed()
	                ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_LDJZ, is_open)
                    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_SDQHY_LDJZ, is_open)
            end
        end
    end
end

--刷新自选奖励显示
function PROMFiveOneLuckDrawLayer:updateChooseGiftShow(_, data)
    if data then
        local rewardData = ex.Player.promotion_data:getChoiceReward(data.position)
        if rewardData then
            -- local file_name = ex.Tools:getItemImageName(rewardData.id) or ""
            -- ex.Tools:setSpriteFrame(self["itemSpr" .. data.position], file_name)
            self["itemSpr".. data.position]:removeAllChildren()
            local file_name = ex.Tools:createBackpackItem(rewardData.id, rewardData.num) 
            if file_name then
                file_name.lbl_num:setVisible(false)
                file_name:setScale(0.8)
                self["itemSpr".. data.position]:addChild(file_name)
            end
            self["item_count".. data.position]:setString(rewardData.num)
            self["item_numBg".. data.position]:setContentSize(cc.size(self["item_count"..data.position]:getContentSize().width + 10, 18))
        end
    end 
end

--设置配置奖励资源显示（以及协议下发数据）
function PROMFiveOneLuckDrawLayer:setRewardImgShow()
    local nowFiveOneData = ex.Player.promotion_data:getSaveFiveOneData()
    if nowFiveOneData.cur_round then
        local nowShowConfigInfo = ex.Player.promotion_data:getConfigInfByRound(nowFiveOneData.cur_round)
        if nowShowConfigInfo then
            for i=1,16 do
                if nowShowConfigInfo[i] then
                    self["itemSpr"..i]:removeAllChildren()
                    self["btn_choose"..i]:setVisible(nowShowConfigInfo[i].canChoice == 1)
                    self["finish_spr"..i]:setVisible(false)
                    self["item_star"..i]:setVisible(i <= 4)
                    self["itemBg_btn"..i]:setTag(i)
                    self["itemBg_btn"..i]:registerScriptTapHandler(handler(self, self.rewardClickShow))
                    local file_name = ""
                    local showNum = 0
                    if nowShowConfigInfo[i].canChoice == 1 then
                        local rewardData = ex.Player.promotion_data:getChoiceReward(nowShowConfigInfo[i].position)
                        if rewardData then
                            file_name = ex.Tools:createBackpackItem(rewardData.id, rewardData.num) --ex.Tools:getItemImageName(rewardData.id) or ""
                            showNum = rewardData.num
                        end
                    else
                        file_name = ex.Tools:createBackpackItem(nowShowConfigInfo[i].reward[1].item_type, nowShowConfigInfo[i].reward[1].item_num) --ex.Tools:getItemImageName(nowShowConfigInfo[i].reward[1].item_type) or ""
                        showNum = nowShowConfigInfo[i].reward[1].item_num
                    end
                    if file_name then
                        file_name.lbl_num:setVisible(false)
                        file_name:setScale(0.8)
                        self["itemSpr"..i]:addChild(file_name)
                    end
                    -- ex.Tools:setSpriteFrame(self["itemSpr"..i], file_name)
                    self["item_count"..i]:setString(showNum)
                    self["item_numBg"..i]:setContentSize(cc.size(self["item_count"..i]:getContentSize().width + 10, 18))
                end
            end
        end
    end
    if nowFiveOneData then
        local str = string.format(ex.Tools:getLang(6143),nowFiveOneData.cur_round, ex.Player.promotion_data:getMaxRound())
        self.resertNum:setString(str)
        
        ex.Tools:setLimitWidth(self.resertNum, 80)
    end
end

--获取抽到大奖的个数
function PROMFiveOneLuckDrawLayer:getMaxDrawNummer()
    local maxNum = 0
    local nowFiveOneData = ex.Player.promotion_data:getSaveFiveOneData()
    if nowFiveOneData and nowFiveOneData.reward_record then
        for i,v in ipairs(nowFiveOneData.reward_record) do
            if v <= 4 then
                maxNum  = maxNum + 1
            end
        end
    end
    return maxNum
end

--点击重置按钮
function PROMFiveOneLuckDrawLayer:resertClick()
    print("点击重置按钮")
    local nowFiveOneData = ex.Player.promotion_data:getSaveFiveOneData()
    if nowFiveOneData then
        local maxNum = self:getMaxDrawNummer()
        if maxNum < 4 then
            ex.MessageView:add(ex.Tools:getLang(47126))
            return
        end
        if #nowFiveOneData.reward_record < 16 then
            local reset_times = nowFiveOneData.reset_times
            ex.ConfirmCtr:openWindow(ex.Tools:getLang(41068), ex.Tools:getLang(6142), function()
                if reset_times > 0 then
                    ex.Player.promotion_data:GReqLaborDayLuckDrawReset()
                else
                    --输出次数不足的提示
                end
            end)
        else
            if nowFiveOneData.reset_times > 0 then
                ex.Player.promotion_data:GReqLaborDayLuckDrawReset()
            else
                --输出次数不足的提示
            end
        end
    end
end

--加号点击
function PROMFiveOneLuckDrawLayer:onAddClick()
    local nowFiveOneData = ex.Player.promotion_data:getSaveFiveOneData()
    if nowFiveOneData then
        local resumeInfo = ex.Player.promotion_data:getResumeByRoundsAndCounts(nowFiveOneData.cur_round, nowFiveOneData.times)
        if resumeInfo and resumeInfo[1] then
            ex.Tools:onClickItemSrc(resumeInfo[1].item_type)
        end
    end
end

--tips点击
function PROMFiveOneLuckDrawLayer:onClickShowTips()
    ex.InfoCtr:openWindow(ex.Tools:getLang(6146), ex.Tools:getLang(6147))
end

--点击创建物品tips
function PROMFiveOneLuckDrawLayer:rewardClickShow(tag, pSender)
    local nowFiveOneData = ex.Player.promotion_data:getSaveFiveOneData()
    if nowFiveOneData.cur_round then
        local nowShowConfigInfo = ex.Player.promotion_data:getConfigInfByRound(nowFiveOneData.cur_round)
        if nowShowConfigInfo and nowShowConfigInfo[tag] then
            if nowShowConfigInfo[tag].canChoice == 1 then
                local rewardData = ex.Player.promotion_data:getChoiceReward(nowShowConfigInfo[tag].position)
                if rewardData then
                    ex.Tools:onClickItemInfo(rewardData.id)
                end
            else
                ex.Tools:onClickItemInfo(nowShowConfigInfo[tag].reward[1].item_type)
            end
        end
    end
end

function PROMFiveOneLuckDrawLayer:onExit()
    self:removeTimerByName("timer")
    if self.btn_skip:isChecked() then
        cc.UserDefault:getInstance():setBoolForKey("five_one_rewardChecked", true)
    else
        cc.UserDefault:getInstance():setBoolForKey("five_one_rewardChecked", false)
    end
end

function PROMFiveOneLuckDrawLayer:updateTimer()
    --显示倒计时
    local is_open = ex.Player.promotion_data:getPromotion097IsOpen()
    if is_open ~= true then
        if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
    end

    local data = ex.Player.promotion_data:getPromotion97Data()
    if data == nil then
         if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
    end

    local cur_time = ex.Game:getServerTime()
    if cur_time > data.end_time then
         if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
    end

    self.lbl_time:setString(ex.Tools:formatTime5(data.end_time - ex.Game:getServerTime()))
end

function PROMFiveOneLuckDrawLayer:addPlist()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/prom-five_one.plist")
end

return PROMFiveOneLuckDrawLayer
