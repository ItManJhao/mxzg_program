--惊喜盲盒
local PROMChristmasSurpriseBlindBoxLayer = class("PROMChristmasSurpriseBlindBoxLayer", require("src.layer.promotion.PromotionBaseLayer"))
local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
------------------------------------ PROMChristmasSurpriseBlindBoxLayer ------------------------------------
function PROMChristmasSurpriseBlindBoxLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:initEventListen()
    self:addPlist()
    self:tipsIsOpen()
    self:updateLayer()
    self:onBreakEggReward()
    
    
end

function PROMChristmasSurpriseBlindBoxLayer:onBreakEggReward()
    local super_reward_is_open = cc.UserDefault:getInstance():getBoolForKey(string.format("%s_super_reward_is_open", ex.Player.role_id),true)
    local start_x = self.spine_supre_reward_pos:getPositionX()
    local start_y = self.spine_supre_reward_pos:getPositionY() - 70
    if super_reward_is_open then
        require("src.layer.promotion.PROMChristmasSuperRewardCtr"):instance():openWindow(ex.Player.promotion_data.promotion91_break_egg_turns_data.curr_lottery_turns,  cc.p(start_x,start_y))
    end
end

function PROMChristmasSurpriseBlindBoxLayer:onCreateDone()
    if self.spr_bg:getContentSize().width * self:getScaleX() < ex.p.width then
        self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    end
    ex.Tools:setLabelOffset(self.lbl_time_tip, self.lbl_time)
    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
    self:updateTimer()
    ex.Tools:setLimitWidth(self.label_show_reward, 100)
     --创建一个骨骼动画
    local upre_reward= sp.SkeletonAnimation:create("spine/chaojidajiang.json", "spine/chaojidajiang.atlas", 1)
          upre_reward:setAnimation(0, "stand", true);
    self.spine_supre_reward_pos:addChild(upre_reward, 10)
    
    self.spr_super_reward = cpp.UIMenuItemImage:create()
    self.spr_super_reward:setContentSize(100,100)
    self.spr_super_reward:setPosition(0,0)
    self.btn_menu:addChild(self.spr_super_reward, 30)
    self.spr_super_reward:registerScriptTapHandler(handler(self, self.onSuperReward))
    self.btn_show_reward:setContentSize(100,25)

    self.btn_skip:setChecked(cc.UserDefault:getInstance():getBoolForKey(string.format("%s_is_checked", ex.Player.role_id), false))

    self:addRedDotNode(RedDotType.ZCJ_DHZC_SDJHD_JXMH_DB, self.btn_draw)
end

function PROMChristmasSurpriseBlindBoxLayer:onExit()
    self:removeTimerByName("timer")
    if self.btn_skip:isChecked() then
        cc.UserDefault:getInstance():setBoolForKey(string.format("%s_is_checked", ex.Player.role_id), true)
    else
        cc.UserDefault:getInstance():setBoolForKey(string.format("%s_is_checked", ex.Player.role_id), false)
    end
    
end

function PROMChristmasSurpriseBlindBoxLayer:updateTimer()
    local is_open = cfg.funcopen["act_christmas"].isVisible()
    if is_open ~= true then
        if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
    end

    local data = ex.Player.promotion_data:getPromotion91Data()
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


function PROMChristmasSurpriseBlindBoxLayer:initEventListen()
    self:addEvent(EVENT.CHRISTMAS.EVEN_GET_REWARD, handler(self, self.updateLayer))
    self:addEvent(EVENT.CHRISTMAS.EVEN_GET_BLIND_BOX_REWARD, handler(self, self.blindBoxEffect))
    self:addEvent(EVENT.CHRISTMAS.EVEN_GET_BREAK_EGG_REWARD,handler(self, self.breakEggEffect))
end

function PROMChristmasSurpriseBlindBoxLayer:addPlist()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/prom-christmas.plist")
end

function PROMChristmasSurpriseBlindBoxLayer:tipsIsOpen()
    local super_reward_is_open = ex.Player.promotion_data:surpriseBlindBoxTipsisOpen(cc.UserDefault:getInstance():getIntegerForKey(string.format("%s_super_reward_time", ex.Player.role_id), -1))
    local break_egg_is_open = ex.Player.promotion_data:surpriseBlindBoxTipsisOpen(cc.UserDefault:getInstance():getIntegerForKey(string.format("%s_break_egg_time", ex.Player.role_id), -1))
    local blind_box_is_open = ex.Player.promotion_data:surpriseBlindBoxTipsisOpen(cc.UserDefault:getInstance():getIntegerForKey(string.format("%s_blind_box_time", ex.Player.role_id), -1))
    if super_reward_is_open then
        cc.UserDefault:getInstance():setBoolForKey(string.format("%s_super_reward_is_open", ex.Player.role_id), true)
    end
    if break_egg_is_open then
        cc.UserDefault:getInstance():setBoolForKey(string.format("%s_break_egg_is_open", ex.Player.role_id), true)
    end
    if blind_box_is_open then
        cc.UserDefault:getInstance():setBoolForKey(string.format("%s_blind_box_is_open", ex.Player.role_id), true)
    end
end

function PROMChristmasSurpriseBlindBoxLayer:updateLayer()
    local data = ex.Player.promotion_data.promotion91_break_egg_turns_data
    self.break_egg_reward_item_node:removeAllChildren()
    
    self.lbl_res_num:setString(string.format( "%s/%s",ex.Player:getItemNum(cfg.system.promotion091_box_cost[1].item_type),cfg.system.promotion091_box_cost[1].item_num))
    self.lbl_res_num_2:setString(string.format( "%s/%s",ex.Player:getItemNum(cfg.system.promotion091_gashapon_cost[1].item_type),cfg.system.promotion091_gashapon_cost[1].item_num))
    self.rutn_num:setString(string.format(ex.Tools:getLang(75102),data.curr_lottery_turns))  
    ex.Tools:setLimitWidth( self.rutn_num, 100)
    --红点 
    for i=1,3 do
        ex.Tools:addRedPoint(self["btn_egg_"..i], ex.Player:getItemNum(901819) > 0, ex.r.p9)
    end
    for i,v in ipairs(data.lottery_record) do
        if data.curr_lottery_turns == v.turns then
            if ex.Player.promotion_data:getBreakEggIsOver() then
                self.rutn_num:setString(string.format(ex.Tools:getLang(6133))) 
            end
            for k,j in ipairs(v.place_record) do
                self["btn_egg_"..j.key]:setEnabled(false)
                self["btn_egg_"..j.key]:setVisible(false)
                ex.Tools:addRedPoint(self["btn_egg_"..j.key], false, ex.r.p9)
                self["break_egg_"..j.key]:setVisible(true)
                local reward = UIItemBackpack:createWithData(self:getRewardItemType(j.value), 0)
                      reward:setScale(0.5)
                      reward:setPosition(self["break_egg_"..j.key]:getPositionX(), self["break_egg_"..j.key]:getPositionY()) 
                self.break_egg_reward_item_node:addChild(reward)
            end 
        end 
    end
end

--获取对应奖励的type值
function PROMChristmasSurpriseBlindBoxLayer:getRewardItemType(idx)
    local reward_data = cfg.promotion091Gashaponlotteryreward.promotion091Gashaponlotteryreward
    for i,v in ipairs(reward_data) do
        if v ~= nil and v.idx == idx and v.reward ~= nil then
            for k,v in pairs(v.reward) do
                return v.item_type
            end
        end
    end 
end

--砸蛋
function PROMChristmasSurpriseBlindBoxLayer:onEgg(tag, pSender)
    self.spine_break_egg_pos:removeAllChildren()
    local break_egg_is_open = cc.UserDefault:getInstance():getBoolForKey(string.format("%s_break_egg_is_open", ex.Player.role_id),true)
    local name = "break_egg_is_open"
    local item_num = ex.Player:getItemNum(901819)
    local num =cfg.system.promotion091_gashapon_cost[1].item_num
    if item_num > 0 then
        if not break_egg_is_open then
            pSender:setEnabled(false)
        end
        require("src.layer.PROMChrismasTipsCtr"):instance():openWindow(ex.Tools:getLang(77864), string.format(ex.Tools:getLang(6138),num),function()
            local req = Promotion091_pb.GReqSpringFestivalGashaponLottery()
            req.place = tag
            NetManager:sendMessage(ProtocolID.GReqSpringFestivalGashaponLottery, req)

            local req_1 = Promotion091_pb.GReqSpringFestivalGetDataInfo()
            NetManager:sendMessage(ProtocolID.GReqSpringFestivalGetDataInfo, req_1)

        end,break_egg_is_open,name)
    else
        ex.MessageView:add(ex.Tools:getLang(30503))

    end
end

--砸蛋特效
function PROMChristmasSurpriseBlindBoxLayer:breakEggEffect()
    local action = cc.Sequence:create(
        cc.CallFunc:create(function (  )
            local win_size = cc.Director:getInstance():getWinSize()
            local layer_color = cc.Scale9Sprite:createWithSpriteFrameName("win-bg/spr-black-1.png",cc.rect(4,4,2,2)) or cc.Sprite:create()
            layer_color:setName("layer_background_black")
            layer_color:setIgnoreAnchorPointForPosition(false)
            layer_color:setContentSize(cc.size((win_size.width + 100) / self:getScaleX(), (win_size.height + 300) / self:getScaleY()))
            layer_color:setPosition(self:getContentSize().width * 0.5, self:getContentSize().height * 0.5)
            self.spine_break_egg_pos:addChild(layer_color, 9)
        end),
        cc.CallFunc:create(function()
            local break_egg= sp.SkeletonAnimation:create("spine/zadan.json", "spine/zadan.atlas", 1)
            break_egg:setAnimation(0, "stand", true);
            break_egg:setPosition(self:getContentSize().width * 0.5, self:getContentSize().height * 0.5)
            self.spine_break_egg_pos:addChild(break_egg, 10)
        end),
        cc.DelayTime:create(1),
        cc.CallFunc:create(function()
            require("src.layer.ItemRewardCtr"):instance():openWindow(ex.Player.promotion_data:getPromotion91BreakEggRewardData())
            self.spine_break_egg_pos:removeAllChildren()
        end),
        cc.DelayTime:create(1),
        cc.CallFunc:create(function()
            local data = ex.Player.promotion_data.promotion91_break_egg_data
            if data.lottery_turns ~= data.curr_lottery_turns then
                require("src.layer.ItemRewardCtr"):instance():closeWindow()
                self:onSuperReward()
                self.break_egg_reward_item_node:removeAllChildren()
                for i=1,3 do
                    self["btn_egg_"..i]:setEnabled(true)
                    self["btn_egg_"..i]:setVisible(true)
                    self["break_egg_"..i]:setVisible(false)
                end
            end
        end)
    )
    self:runAction(action)   
end

--砸蛋超级大奖预览
function PROMChristmasSurpriseBlindBoxLayer:onSuperReward(tag, pSender)
    local start_x = self.spine_supre_reward_pos:getPositionX()
    local start_y = self.spine_supre_reward_pos:getPositionY()-70
    require("src.layer.promotion.PROMChristmasSuperRewardCtr"):instance():openWindow(ex.Player.promotion_data.promotion91_break_egg_turns_data.curr_lottery_turns,cc.p(start_x,start_y))
end

--盲盒抽奖
function PROMChristmasSurpriseBlindBoxLayer:onDraw(tag, pSender)
    self.btn_draw:setEnabled(false)
    --判断道具是否足够
    local item_num = ex.Player:getItemNum(901820)
    local name = "blind_box_is_open"
    if item_num > 0 then
        if ex.Player.promotion_data:getBreakEggIsOver() then
            local blind_box_is_open = cc.UserDefault:getInstance():getBoolForKey(string.format("%s_blind_box_is_open", ex.Player.role_id),true)
            require("src.layer.PROMChrismasTipsCtr"):instance():openWindow(ex.Tools:getLang(77864), string.format(ex.Tools:getLang(6134)),function()
            end,blind_box_is_open,name)
        end
        local req = Promotion091_pb.GReqSpringFestivalBoxLottery()
        NetManager:sendMessage(ProtocolID.GReqSpringFestivalBoxLottery, req)
    else
        ex.MessageView:add(ex.Tools:getLang(30503))
    end
end

--盲盒抽奖特效
function PROMChristmasSurpriseBlindBoxLayer:blindBoxEffect()
    if self.btn_skip:isChecked() then
        require("src.layer.ItemRewardCtr"):instance():openWindow(ex.Player.promotion_data.promotion91_blind_box_reward)
        self.btn_draw:setEnabled(true)
        return
    end
    local point = 1
    local length = 9
    local callback = function ()
        self.spr_reward_select:setVisible(true)
        self.spr_reward_select:setPosition(self["box_"..point]:getPositionX() - 5, self["box_"..point]:getPositionY() + 5)
        point = point + 1
        if point > length then 
            point = 1
        end
    end
    local max_time = 2
    local run_time = 0.01 
    local total_time = 0
    local action_list = {}
    while total_time < max_time do 
        local sequence = self:getRunAction(run_time,callback)
        table.insert(action_list,sequence)
        run_time = run_time + 0.01
        total_time = total_time + run_time
    end
    local target = math.random(9)  
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
        total_time = total_time + run_time
    end
    local end_callback = cc.CallFunc:create(function()
        require("src.layer.ItemRewardCtr"):instance():openWindow(ex.Player.promotion_data.promotion91_blind_box_reward)
        self.spr_reward_select:setVisible(false)
        self.btn_draw:setEnabled(true)
    end)

    local delay = cc.DelayTime:create(run_time)
    local end_sequence = cc.Sequence:create(end_callback, delay)
    table.insert(action_list,end_sequence)

    local sequence = cc.Sequence:create(action_list)
    self:runAction(sequence)
end

--盲盒奖励预览
function PROMChristmasSurpriseBlindBoxLayer:onRewardPreview(tag, pSender)
    local table_data={}
    local max_weight = 0
    for k,v in ipairs(cfg.promotion091boxlotteryreward.promotion091boxlotteryreward) do
			local table_data_temp = {}
			table_data_temp.cost = v.reward
			table_data_temp.weight = v.weight
			table_data_temp.idx = v.idx
			table.insert(table_data,table_data_temp)
            max_weight = max_weight + v.weight
	end
    require("src.layer.PROMChristmasHappyPreviewCtr"):instance():openWindow(table_data,max_weight)
end

function PROMChristmasSurpriseBlindBoxLayer:getRunAction(run_time,callback)
    local action_callback = cc.CallFunc:create(callback)
    local delay = cc.DelayTime:create(run_time)
    local sequence = cc.Sequence:create(action_callback, delay)
    return sequence
end

function PROMChristmasSurpriseBlindBoxLayer:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(6136), ex.Tools:getLang(6137))
end

--添加道具
function PROMChristmasSurpriseBlindBoxLayer:onAdd(tag, pSender)
    ex.Tools:onClickItemSrc(tag)   
end


return PROMChristmasSurpriseBlindBoxLayer
