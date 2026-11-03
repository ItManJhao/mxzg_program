local PROMSpringDiceLayer = class("PROMSpringDiceLayer",require("src.layer.promotion.PromotionBaseLayer"))
local PROMSpringDiceCell =  class("PROMSpringDiceCell",require("src.comp.EventLayer"))

function PROMSpringDiceCell:onCreate()

    for i,v in ipairs(cfg.promotion093grid.promotion093grid) do
        if v.event_type == 1 then
            local num = v.idx % 5
            ex.Tools:setSpriteFrame(self["pos_"..i], string.format("prom-spring-outing/spr-scenic-spot-%d.png", num + 1))
        elseif v.event_type == 2 then
            if v.event_param == 1 then
                ex.Tools:setSpriteFrame(self["pos_"..i], string.format("prom-spring-outing/reward-green.png"))
            elseif v.event_param == 2 then
                ex.Tools:setSpriteFrame(self["pos_"..i], string.format("prom-spring-outing/reward-orange.png"))
            elseif v.event_param == 3 then
                ex.Tools:setSpriteFrame(self["pos_"..i], string.format("prom-spring-outing/reward-red.png"))
            end
        else
            ex.Tools:setSpriteFrame(self["pos_"..i], string.format("prom-spring-outing/spr-space.png"))
        end    
    end

    local spine_girl = sp.SkeletonAnimation:create("spine/10201001.json", "spine/10201001.atlas", 1)
    spine_girl:setAnimation(0, "run", true)
    spine_girl:setScale(0.5)
    self.spine_node:addChild(spine_girl)
    local pos_data = ex.Player.promotion_data.promotion93data
    if pos_data == nil or next(pos_data) == nil then
        pos_data.curr_idx = 1
    end
    self.spine_node:setPosition(self["pos_"..pos_data.curr_idx]:getPositionX(),self["pos_"..pos_data.curr_idx]:getPositionY() - 20)
    self.pos_num = pos_data.curr_idx
    
end

--英雄移动
function PROMSpringDiceCell:spineMove(max_pos,dice_num,bool,callback)
    --当英雄到达终点时数组超出索引，位置进行临时赋值

    --计算除初始的位置
    local pos = max_pos - dice_num
    --记录一下初始的位置
    local var_pos =  self.pos_num
    --初始位置加上点数是否大于42，即是否超出终点，如果超出终点临时赋值
    self.pos_num = self.pos_num + dice_num
    if self.pos_num >= 42 then
        max_pos = 42
        pos = var_pos 
        dice_num = max_pos - var_pos
    end

    --如过英雄到达终点，停留一秒后跳到起始位置
    local end_move = function ()
        if self.pos_num >= 42 then
            max_pos = ex.Player.promotion_data.grid_dice_data.curr_idx
            self.pos_num = max_pos
            local end_action = cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
                self.spine_node:setPosition(self["pos_"..max_pos]:getPositionX(),self["pos_"..max_pos]:getPositionY() - 20) end))   
            self.spine_node:runAction(end_action)  
            callback(0)    
        end
    end
    
    if bool then
        --播放英雄移动动作
        self.spine_node:setPosition(self["pos_"..pos]:getPositionX(),self["pos_"..pos]:getPositionY() - 20)
        local run = {}
        for i=1,dice_num do
            local pos = cc.p(self["pos_"..pos + i]:getPositionX(),self["pos_"..pos + i]:getPositionY() - 20)
            run[i] = cc.MoveTo:create(2, pos)    
        end
        --动作列表
        local action_list = {}

        --英雄移动动作
        local hero_move = cc.Sequence:create(run)
        table.insert( action_list, hero_move )

        --移动完成后动作
        local hero_move_end = cc.CallFunc:create(function()
            if callback then
                local height = (self.spine_node:getPositionY() - 20) / self:getContentSize().height
                callback(height)
            end
            if #ex.Player.promotion_data.grid_dice_data.reward > 0 then
                require("src.layer.ItemRewardCtr"):instance():openWindow(self:getRewardList())
            end
         end)
        table.insert( action_list, hero_move_end )

        local end_action = cc.CallFunc:create(function()
           end_move()
        end)
        table.insert( action_list, end_action )

        --按顺序执行动作列表
        local sequence = cc.Sequence:create(action_list) 
        self.spine_node:runAction(sequence)  
    else
        --跳过英雄移动动作，直接到达该位置
        self.spine_node:setPosition(self["pos_"..max_pos]:getPositionX(),self["pos_"..max_pos]:getPositionY() - 20)

        --到达后的动作顺序，延迟一秒后打开奖励界面
        local run_table = cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(function()
            if callback then
                local height = (self.spine_node:getPositionY() - 20) / self:getContentSize().height
                callback(height)
            end
            if #ex.Player.promotion_data.grid_dice_data.reward > 0  then
                require("src.layer.ItemRewardCtr"):instance():openWindow(self:getRewardList())
            end
        end),
        cc.CallFunc:create(function()
            end_move()
        end))
        self.spine_node:runAction(run_table)  
    end
    
end

--奖励由于后端数据格式不正确前端转换成正确格式
function PROMSpringDiceCell:getRewardList()
    local reward_list = {}
    for i,v in ipairs(ex.Player.promotion_data.grid_dice_data.reward) do
        reward_list[i] = {}
        reward_list[i].item_type = v.type
        reward_list[i].item_num = v.num
        reward_list[i].item_id = v.id
        reward_list[i].star = v.star
    end
    return reward_list
end

function PROMSpringDiceLayer:onCreate()

    local scale = ex.p.width / self.spr_bg:getContentSize().width
    self.spr_bg:setScaleX(scale)
    self.spr_bg_top:setScaleX(scale)
    self.spr_maks:setScaleX(scale)

    self.spr_bg_top:setZOrder(100) 
    self.node_act_time:setZOrder(101)
    self.info_menu:setZOrder(103)

    local sfc = cc.SpriteFrameCache:getInstance() 
    sfc:addSpriteFrames("ccbi-res/prom-spring-outing.plist")
    local cost_cfg = cfg.system.promotion093_dice_cost[1]
    ex.Tools:setLimitWidth(self.lbl_skip,85)

    local spr_fdj = cc.Sprite:createWithSpriteFrameName(string.format("prom-spring-outing/spr-fdj.png"))
    spr_fdj:setPosition(self.show_reward:getPositionX() + 25, self.show_reward:getContentSize().height / 2)
    self.show_reward:addChild(spr_fdj)
    local show_reward_lbl = self.show_reward:getLabel()
    show_reward_lbl:setAnchorPoint(0,0.5)
    show_reward_lbl:setPositionX(spr_fdj:getPositionX() + 20)

    self.cell = PROMSpringDiceCell:createWithCCBIFile("ccbi/PROMSpringDiceCell.ccbi")
    self.scrollview:setBounceable(false)
    self.scrollview:addChild(self.cell)
    self.cell:setAnchorPoint(0, 0)
    self.cell:setPosition(0,self.spr_maks:getContentSize().height)
    if scale < 1 then
        self.cell:setScaleX(scale)
    end
    local height = (self.cell.spine_node:getPositionY() - 20) / self.cell:getContentSize().height
    self.scrollview:setContentSize(2000,2000)
    self.scrollview:setContentOffset(cc.p(0, -1040 * height))
    self.spr_res_icon:setSpriteFrame(string.format("backpack/%d.png",cost_cfg.item_type))

    self:addRedDotNode(RedDotType.ZCJ_DHZC_CRHD_CRTQ_TZ, self.btn_dice)

    local is_jump = cc.UserDefault:getInstance():getBoolForKey(string.format("%s_is_jump", ex.Player.role_id), true)
    self.btn_is_jump:setChecked(not is_jump)
    self:updateTimer()
    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
    --箱子
    self.progressTimer =
    require("src.comp.UIProgressTimerEquidistant"):create(cc.Sprite:createWithSpriteFrameName("prom-spring-outing/jdt2.png")):setType(cc.PROGRESS_TIMER_TYPE_BAR):setScaleX(
    self.spr_progress_bg:getScaleX()
    ):setMidpoint(cc.p(0, 0.5)):setBarChangeRate(cc.p(1, 0))
    self.spr_progress_bg:addChild(self.progressTimer)
    self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2 - 8, self.spr_progress_bg:getContentSize().height / 2)
    ex.Tools:setLabelOffset(self.lbl_time_tip, self.lbl_time)
    self.node_point:setScale(math.min(1, ex.p.width / 600))
    self.box_list = {}
    local width = self.spr_progress_bg:getContentSize().width
    local reward_data = cfg.promotion093scenic.promotion093scenic
    for i,v in ipairs(reward_data) do
        local x = i / #reward_data
        local box = cpp.UIMenuItemImage:createWithSpriteFrameName("prom-spring-outing/spr-spring-box-" .. i .. ".png", nil, nil)
        box.data = v
        box:registerScriptTapHandler(handler(self, self.onClickBox))
        box:setTag(i)
        box:setScale(0.95)
        self.menu:addChild(box, 1)
        box:setPosition(x * width, 10)
        local lbl = cc.Label:createWithTTF(string.format(ex.Tools:getLang(6508), v.count), FONT_DEFAULT_NAME_BOLD, 18)
        self.spr_progress_bg:addChild(lbl)
        lbl:setColor(cc.c3b(253, 228, 181, 255))
        lbl:enableOutline(cc.c3b(87, 56, 29), 2)
        lbl:setPosition(box:getPositionX(), box:getPositionY() - 27.5)
        lbl:setLocalZOrder(1)

        local box_data = {}
        box_data.box = box
        box_data.lbl = lbl
        table.insert(self.box_list, box_data)
        self.progressTimer:addData({pos = x * 100, count = v.count}, false)
    end
   
    self:initEventListen() 
    self:updateLayer()
end

function PROMSpringDiceLayer:updateTimer()
    local is_open = cfg.funcopen["act_spring"].isVisible()
    if is_open ~= true then
        if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
    end

    local data = ex.Player.promotion_data:getPromotion93Data()
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

function PROMSpringDiceLayer:updateLayer()
    local cost_cfg = cfg.system.promotion093_dice_cost[1]
    self.lbl_res_num:setString(ex.Player:getItemNum(cost_cfg.item_type).."/"..cost_cfg.item_num)
    self.lbl_task_num:setString(ex.Player.promotion_data:getPromotion93MissionRewardNum())
    -- 更新箱子状态
    for i, v in ipairs(self.box_list) do
        local box = v.box
        local status = ex.Player.promotion_data:getPromotion93BoxRewardStatus(box.data.idx)

        box:removeChildByName("box_effect")
        local node_eff = cc.Node:create()
        node_eff:setName("box_effect")
        box:addChild(node_eff)

        local image = status > 0 and ("prom-spring-outing/spr-spring-box-" .. i .. ".png") or ("other/spr-box-open-" .. i .. ".png")
        ex.Tools:setSpriteFrame(box:getNormalImage(), image)

        local effId = status == 0 and 11 or 10
        ex.EffectCtr:playNormalEff(effId, box:getContentSize().width * 0.5, box:getContentSize().height * 0.5, nil, node_eff, 10):setAnchorPoint(0.55, 0.12)
    end

    -- 更新宝箱进度条
    self.progressTimer:setPercentageCount(ex.Player.promotion_data:getPromotion93MissionRewardNum()) --景点次数

    -- 检测红点
    ex.Player.promotion_data:checkPromotion93RedDot()
end

--监听事件
function PROMSpringDiceLayer:initEventListen( )
    --1.等待掷骰子后接收后端返回的协议数据（点数以及奖励）
    self:addEvent(EVENT.SPRING.EVENT_UPDAT_LAYER, handler(self, self.updateLayer))
    self:addEvent(EVENT.SPRING.EVENT_DICE_POINT, handler(self, self.showDicePoint))
    
end

function PROMSpringDiceLayer:showDicePoint()
    local data = ex.Player.promotion_data.grid_dice_data
    local is_jump = cc.UserDefault:getInstance():getBoolForKey(string.format("%s_is_jump", ex.Player.role_id), true)
    if not self.btn_is_jump:isChecked() then
        --播放
        self.spine = sp.SkeletonAnimation:create("spine/crtq_touzi.json", "spine/crtq_touzi.atlas", 1)
        self.spine:setAnimation(0, "stand", true)
        self.spine_effect:addChild(self.spine)
        self.spine_effect:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), 
                                    cc.CallFunc:create(function() self.spine_effect:removeAllChildren() end),
                                    cc.CallFunc:create(function()
                                        local spr = cc.Sprite:createWithSpriteFrameName(string.format("prom-spring-outing/spr-dice-%d.png", data.point))
                                        self.spine_effect:addChild(spr) end),
                                    cc.DelayTime:create(0.5),
                                    cc.CallFunc:create(function() 
                                        self.spine_effect:removeAllChildren() 
                                        self.cell:spineMove(data.curr_idx, data.point, true, 
                                        function(pos)
                                            self.btn_dice:setEnabled(true)
                                            self.scrollview:setContentOffset(cc.p(0, -1040 * pos))
                                        end)
                                    end)))
    else
        --不播放
        local spr = cc.Sprite:createWithSpriteFrameName(string.format("prom-spring-outing/spr-dice-%d.png", data.point))
        if not spr then
            local sfc = cc.SpriteFrameCache:getInstance() 
            sfc:addSpriteFrames("ccbi-res/prom-spring-outing.plist")
            spr = cc.Sprite:createWithSpriteFrameName(string.format("prom-spring-outing/spr-dice-%d.png", data.point))
        end
        self.spine_effect:addChild(spr)
        self.spine_effect:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), 
                                    cc.CallFunc:create(function() 
                                        self.spine_effect:removeAllChildren() 
                                        local pos = data.curr_idx - data.point
                                        self.cell:spineMove(data.curr_idx, data.point, false, function(pos)
                                            self.btn_dice:setEnabled(true)
                                            self.scrollview:setContentOffset(cc.p(0, -1040 * pos))
                                        end)
                                    end)))
    end
     
end

--------------------------------------------点击事件-------------------------

--是否跳过动画
function PROMSpringDiceLayer:isJump()
    if not self.btn_is_jump:isChecked() then
        cc.UserDefault:getInstance():setBoolForKey(string.format("%s_is_jump", ex.Player.role_id), true)
    else
        cc.UserDefault:getInstance():setBoolForKey(string.format("%s_is_jump", ex.Player.role_id), false)
    end
end

--点击掷骰子
function PROMSpringDiceLayer:onBtnDice()
    self.spine_effect:removeAllChildren()
    local cost_cfg = cfg.system.promotion093_dice_cost[1]
    --判断道具是否足够
    local item_num = ex.Player:getItemNum(cost_cfg.item_type)
    if item_num >= cost_cfg.item_num then
        NetManager:sendMessage(ProtocolID.GReqSpringOutingGridDice)
        self.btn_dice:setEnabled(false)
    else
        --道具不足
        ex.MessageView:add(ex.Tools:getLang(30503))
    end
end

--点击箱子
function PROMSpringDiceLayer:onClickBox(tag, pSender)
    local data = clone(pSender.data)
    local can_get = ex.Player.promotion_data:getPromotion93BoxRewardStatus(data.idx) == 0
    local function callback()
        local req = Promotion093_pb.GReqSpringOutingGridScenicReward()
        req.idx = pSender.data.idx
        NetManager:sendMessage(ProtocolID.GReqSpringOutingGridScenicReward, req)
    end
    require("src.layer.SevenTargetRewardInfoCtr"):instance():openWindow(data, can_get, callback)
end

--添加道具
function PROMSpringDiceLayer:onAdd(tag)
    local cost_cfg = cfg.system.promotion093_dice_cost[1]
    ex.Tools:onClickItemSrc(cost_cfg.item_type)
end

--功能信息
function PROMSpringDiceLayer:onInfo()
    ex.InfoCtr:openWindow(ex.Tools:getLang(6513), ex.Tools:getLang(6514))
end

--奖励预览
function PROMSpringDiceLayer:onRewardPreview(tag, pSender)
    local table_data = {{},{},{}} 
    for k,v in ipairs(cfg.promotion093randomreward.promotion093randomreward) do
        local table_data_temp = {}
        table_data_temp.cost = v.reward
        table_data_temp.weight = v.weight
        table_data_temp.idx = v.idx
        table_data_temp.type = v.type
        table.insert(table_data[v.type],table_data_temp)
	end
    require("src.layer.promotion.PROMSpringDiceRewardCtr"):instance():openWindow(table_data)
end

return PROMSpringDiceLayer
