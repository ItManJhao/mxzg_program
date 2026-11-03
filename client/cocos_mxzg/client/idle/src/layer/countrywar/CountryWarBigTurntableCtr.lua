local CountryWarBigTurntableCtr = class("CountryWarBigTurntableCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CountryWarBigTurntableLayer = class("CountryWarBigTurntableLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")

------------------------------------ CountryWarBigTurntableLayer ------------------------------------
function CountryWarBigTurntableLayer:onCreate()
    -- self:setAutoClose(false)
    self:addBlackBackground()
    self:setSwallowTouches(false)
    self:onCreateDone()
    self:initEventListen()
    self:updateLayer()
end

function CountryWarBigTurntableLayer:onCreateDone()
    ex.Tools:setLimitWidth(self.lbl_tittle, 200)
    ex.Tools:setLimitWidth(self.lbl_lucky_reward, 150)
    ex.Tools:setLimitWidth(self.btn_one:getLabel(), 140)
    ex.Tools:setLimitWidth(self.btn_ten:getLabel(), 140)
    local cost_cfg = cfg.system.country_war_lottery_cost[1] 
    self.spr_item_need_1:setSpriteFrame(string.format("backpack/%d.png", cost_cfg.item_type))
    self.spr_item_need_10:setSpriteFrame(string.format("backpack/%d.png", cost_cfg.item_type))
    self.item_need_num_1:setString(string.format("%d", cost_cfg.item_num))
    self.item_need_num_10:setString(string.format("%d", cost_cfg.item_num * 10))
    local is_jump = cc.UserDefault:getInstance():getBoolForKey(string.format("%sbig_turntable_is_jump_animation", ex.Player.role_id), true)
    self.btn_is_jump:setChecked(not is_jump)

    local reward_data = {}
    local round = ctr.country_war.data.lottery_round
    for i,v in ipairs(cfg.countrywarlottery.countrywarlottery) do
        if v.round == round then
            table.insert( reward_data, clone(v) )
        end
    end
    for i,v in ipairs(reward_data) do
        if v.round == round then
            local x,y = self["item_"..i]:getPosition()
            local show_cfg = v.reward[1]
            local item = UIMenuItemBag:createWithData(show_cfg.item_type,show_cfg.item_num)
            self.menu_item:addChild(item)
            item:setPosition(x,y)
            item:setScale(0.8)
            item:setTag(v.idx)
            item:registerScriptTapHandler(handler(self,self.onClickItem))
            item.data = v
        end          
    end
end

function CountryWarBigTurntableLayer:onClickItem(tag,pSender)
        ex.Tools:showItemInfo(tag,pSender)
end

function CountryWarBigTurntableLayer:initEventListen()
    self:addEvent(EVENT.COUNTRY_WAR.LOTTERY, handler(self, self.playEfftct))
end

function CountryWarBigTurntableLayer:updateLayer()
    self:setBtnStatus(true)
    local cost_cfg = cfg.system.country_war_lottery_cost[1] 
    local spr = self.btn_res_icon:getNormalImage()
    spr:setSpriteFrame(string.format("backpack/%d.png", cost_cfg.item_type))
    self.lbl_res_num:setString(ex.Player:getItemNum(cost_cfg.item_type))
    --道具不足按钮置灰
    ex.Tools:addRedPoint(self.btn_one, true, ex.r.p8)   
    ex.Tools:addRedPoint(self.btn_ten, true, ex.r.p8)   
    local item_num = ex.Player:getItemNum(cost_cfg.item_type)  
    if item_num < 1 then
        ex.Tools:setAllGrayAuto(self.btn_one:getNormalImage(), true)
        self.btn_one:setEnabled(false)
        ex.Tools:setAllGrayAuto(self.btn_ten:getNormalImage(), true)    
        self.btn_ten:setEnabled(false)  
        ex.Tools:addRedPoint(self.btn_one, false, ex.r.p9)   
        ex.Tools:addRedPoint(self.btn_ten, false, ex.r.p9)  
    elseif item_num < 10 then
        ex.Tools:setAllGrayAuto(self.btn_ten:getNormalImage(), true)    
        self.btn_ten:setEnabled(false)  
        ex.Tools:addRedPoint(self.btn_one, true, ex.r.p9)   
        ex.Tools:addRedPoint(self.btn_ten, false, ex.r.p9)  
    end
end

--抽奖
function CountryWarBigTurntableLayer:onDraw(tag)
    local is_jump = cc.UserDefault:getInstance():getBoolForKey(string.format("%sbig_turntable_is_jump_animation", ex.Player.role_id), true)
    local cost_cfg = cfg.system.country_war_lottery_cost[1]
    local item_num = ex.Player:getItemNum(cost_cfg.item_type)  

    if item_num >= tag then
        ctr.country_war:gReqCountryWarLottery(tag)
    else
        ex.MessageView:add(ex.Tools:getLang(30503))
    end
    self:setBtnStatus(false)
    
end

function CountryWarBigTurntableLayer:playEfftct(null, data)
    local is_jump = cc.UserDefault:getInstance():getBoolForKey(string.format("%sbig_turntable_is_jump_animation", ex.Player.role_id), true)
    if not is_jump then
        local vec_reward = {}
        for i,v in ipairs(data.reward) do
            local item = {}
            item.item_type = v.type 
            item.item_num = v.num
            table.insert(vec_reward,item)
        end
        require("src.layer.ItemRewardCtr"):instance():openWindow(vec_reward)
        self.spr_select_1:setVisible(false)
        self:setBtnStatus(true)
        self:updateLayer()
        return
    end
    self.spr_select_1:setVisible(true)
    local point = 1
    local length = 8
    local callback = function ()
        local x,y = self["item_" .. point]:getPosition()
        self.spr_select_1:setPosition(cc.p(x,y))
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
        self.spr_select_1:setVisible(false)
        self:setBtnStatus(true)
        self:updateLayer()
        
    end)

    local delay = cc.DelayTime:create(run_time)
    local end_sequence = cc.Sequence:create(end_callback, delay)
    table.insert(action_list,end_sequence)


    local sequence = cc.Sequence:create(action_list)
    self.spr_select_1:runAction(sequence)
end

function CountryWarBigTurntableLayer:getRunAction(run_time,callback)
    local action_callback = cc.CallFunc:create(callback)
    local delay = cc.DelayTime:create(run_time)
    local sequence = cc.Sequence:create(action_callback, delay)
    return sequence
end

function CountryWarBigTurntableLayer:setBtnStatus(bool)
    self.btn_one:setEnabled(bool)
    self.btn_ten:setEnabled(bool)  
end

--是否跳过动画
function CountryWarBigTurntableLayer:isJump()
    if not self.btn_is_jump:isChecked() then
        cc.UserDefault:getInstance():setBoolForKey(string.format("%sbig_turntable_is_jump_animation", ex.Player.role_id), true)
    else
        cc.UserDefault:getInstance():setBoolForKey(string.format("%sbig_turntable_is_jump_animation", ex.Player.role_id), false)
    end
end

function CountryWarBigTurntableLayer:showItemInfo()
    local cost_cfg = cfg.system.country_war_lottery_cost[1] 
    ex.Tools:onClickItemInfo(cost_cfg.item_type)
end

function CountryWarBigTurntableLayer:onInfo(  )
    require("src.layer.InfoCtr"):instance():openWindow(ex.Tools:getLang(55521), ex.Tools:getLang(55573))
end

---------------------------------------------------------------------------

function CountryWarBigTurntableCtr:onCreate()
    self:setCCBIPath("ccbi/CountryWarBigTurntableLayer.ccbi")
    self:setIsSingle(false)
end

function CountryWarBigTurntableCtr:getLayerClass()
    return CountryWarBigTurntableLayer
end

function CountryWarBigTurntableCtr:getClanRankLayer()
    return self.layer
end

function CountryWarBigTurntableCtr:openWindow()
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData()
end

function CountryWarBigTurntableCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end

return CountryWarBigTurntableCtr
