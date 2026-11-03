--[[
* @Description: 圣诞活动-嗨翻圣诞
* @Author: 熊梦
* @Date: 2020-12-15 17:28:00
* ]]
local PROMChristmasHappyLayer = class("PROMChristmasHappyLayer", require("src.layer.promotion.PromotionBaseLayer"))
local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")


------------------------------------ PROMChristmasHappyLayer ------------------------------------
function PROMChristmasHappyLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:initEventListen()
    self:addPlist()
end

function PROMChristmasHappyLayer:addPlist()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/prom-christmas.plist")
end


function PROMChristmasHappyLayer:onCreateDone()
    self:initView()
end

function PROMChristmasHappyLayer:initEventListen()
   self:addEvent(EVENT.CHRISTMAS.EVENT_GACHA_DRAW, handler(self, self.handleDrawResult))
end

function PROMChristmasHappyLayer:initView()
    self.spr_bg:setPositionY(self.layer_promotion:getTopY())
    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    self.spr_bg:setScaleY(self.spr_bg:getPositionY() / (self.spr_bg:getContentSize().height))
    self.node_info:setPositionX(ex.p.width-10)


    ex.Tools:setLimitWidth(self.lbl_prom_text_1, 100)
    -- local go_lbl = self.btn_go:getLabel()
    -- ex.Tools:setLimitWidth(go_lbl, 140)
    ex.Tools:setLabelOffset(self.lbl_time_tip, self.lbl_time)
    self.node_act_time:setLocalZOrder(99)

    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
    self:updateTimer()
    
    self:addRedDotNode(RedDotType.ZCJ_DHZC_SDJHD_HFSD_DB, self.btn_go)
    self:iniTablebtn()
    self:createSlotItems()

end


function PROMChristmasHappyLayer:iniTablebtn()
    self.lottery_type = ex.Player.promotion_data.promotion87_data.bookmark 
    self.spr_xuanzhong:setPosition(self["btn_day_"..self.lottery_type]:getPosition())
    for i=1,5 do
        local btn_tab = self["btn_day_"..i]
        if btn_tab then
            btn_tab:setLabelText(" ")
            btn_tab:setContentSize(cc.size(130, 55))
            local lbl = btn_tab:getLabel()
            lbl:setPosition(btn_tab:getContentSize().width * 0.5, btn_tab:getContentSize().height * 0.5 - 5)
            lbl:setString(i)
            lbl:enableOutline(cc.c3b(65, 144, 199), 4)
            lbl:setTextColor(cc.c4b(20, 50, 89, 255))
        end
    end

    local btn_tab = self["btn_day_"..self.lottery_type]
    if btn_tab then
        local lbl = btn_tab:getLabel()
        lbl:enableOutline(cc.c3b(65, 144, 199), 0)
        lbl:setTextColor(cc.c4b(255, 246, 101, 255))
    end

    for i=1,5 do
        if ex.Player.promotion_data.promotion87_data.bookmark >= i then
            self["spr_suotou_"..i]:setVisible(false)
        else
            self["spr_suotou_"..i]:setVisible(true)
        end
    end

    local isVisible_red = true
    if ex.Player.promotion_data.promotion87_data.bookmark == #cfg.promotion087lotterytype.promotion087lotterytype then
        if ex.Player.promotion_data.promotion87_data.bookmark == #cfg.promotion087lotterytype.promotion087lotterytype then
            local index = 0
            for i,v in ipairs(ex.Player.promotion_data.promotion87_data.lottery_record) do
                if cfg.promotion087lotteryreward.promotion087lotteryreward[v].lottery_type == ex.Player.promotion_data.promotion87_data.bookmark then
                    index = index + 1
                end
            end
            if index == 6 then
                isVisible_red = false
            end
        end
    end
    self.btn_go:setVisible(isVisible_red)
end


function PROMChristmasHappyLayer:updateTimer()
    local is_open = cfg.funcopen["act_christmas_fantasynight"].isVisible()
    if is_open ~= true then
        if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
    end

    local data = ex.Player.promotion_data:getPromotion87Data()
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


function PROMChristmasHappyLayer:createSlotItems()
    self.menu_item:removeAllChildren()
    
    local item_table = {}
    for i,v in ipairs(cfg.promotion087lotteryreward.promotion087lotteryreward) do
        if v.lottery_type == self.lottery_type then
            table.insert( item_table, v )
        end
    end

    -- 根据配置的道具位置显示道具位置
    local function sort_table (a,b)
        return a.point_id < b.point_id
    end 

    table.sort( item_table, sort_table )

    for i,v in ipairs(item_table) do
        local x,y = self["item_"..i]:getPosition()
        local show_cfg = v.reward[1]

        local item = UIMenuItemBag:createWithData(show_cfg.item_type,show_cfg.item_num)
        self.menu_item:addChild(item)
        item:setPosition(x,y)
        item:setTag(v.idx)
        item:registerScriptTapHandler(handler(self,self.onClickItem))
        item:setName("item_reward_"..i)
        item.data = v

        for k,n in ipairs(ex.Player.promotion_data.promotion87_data.lottery_record) do
            if v.idx == n then
                local spr_geted = cc.Sprite:createWithSpriteFrameName("promotion/spr-sign-2.png")
                spr_geted:setPosition(50,50)
                item:addChild(spr_geted,100) 
                break
            end
        end

        if i ==  1 then
            self.node_hero_skin:removeAllChildren()
            self.node_baoxiang_effect:removeAllChildren()
            self.menu_baoxiang:removeAllChildren()
            -- 读取品质框
            local item_config, source_config = ex.Player.backpack_data:getBagConfig(show_cfg.item_type)
            if item_config.mode == ItemData.IT_HERO_FASHION then
                self.spr_baoxiang_bg:setVisible(false)
                local item_fashon_data = cfg.herofashionunlock.getConfigByType(show_cfg.item_type)
                local spine_hero = require("src.person.Hero"):create("1", "1", 1, 1, ex.Tools:getHeroSkinByImageId(item_fashon_data.fashion_id))
                spine_hero:setAnimation(0, "stand", true);
                spine_hero:setShadowVisible(false)
                spine_hero:setScale(1.8)
                self.node_hero_skin:addChild(spine_hero, 1)
            elseif item_config.mode == ItemData.IT_SPECIAL_ELITE then
                self.spr_baoxiang_bg:setVisible(false)
                local hero_data = cfg.herotype.star[show_cfg.item_type - 10000000]
                local skin = ex.Tools:getIllustratHeroSkinByStar(hero_data.type,1)
                local hero = require("src.person.Hero"):create("12323", "123213", hero_data.type, 1,1,skin )
                hero:setScale(1.8)
                hero:setPositionY(-30)
                self.node_hero_skin:addChild(hero, 1)
            else
                local item_up = UIMenuItemBag:createWithData(show_cfg.item_type,show_cfg.item_num)
                item_up:registerScriptTapHandler(handler(self,self.onClickItem))
                self.menu_baoxiang:addChild(item_up)
                self.spr_baoxiang_bg:setVisible(true)

                local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_prom_87_xing")
                self.node_baoxiang_effect:addChild(spr_effect)
            end
        end
    end

    for k,v in pairs(cfg.promotion087lotterytype.promotion087lotterytype) do
        if v.idx == self.lottery_type then
            local cost_cfg = v.cost[1]
            self.spr_res_icon:setSpriteFrame(string.format("backpack/%d.png",cost_cfg.item_type))
            self.lbl_res_num:setString(ex.Player:getItemNum(cost_cfg.item_type).."/"..cost_cfg.item_num)
            break
        end
    end
   
end

function PROMChristmasHappyLayer:setBtnStatus(bool)
    self.btn_go:setEnabled(bool)
   for i=1,5 do
       self["btn_day_"..i]:setEnabled(bool)
   end
end

function PROMChristmasHappyLayer:handleDrawResult(event, data)
    
    local cost_cfg = {}
    for k,v in pairs(cfg.promotion087lotterytype.promotion087lotterytype) do
        if v.idx == self.lottery_type then
            cost_cfg = v.cost[1]
            break
        end
    end
    self.lbl_res_num:setString(ex.Player:getItemNum(cost_cfg.item_type).."/"..cost_cfg.item_num)

    local point = 1
    local length = 6
    local callback = function ()
        if point == 1 then
            self.spr_select_1:setVisible(false)
            self.spr_select_2:setVisible(true)
        else
            self.spr_select_1:setVisible(true)
            self.spr_select_2:setVisible(false)
            self.spr_select_1:setPosition(self["item_" .. point]:getPosition())
        end
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

    local win_prize_data = {}
    for k,n in ipairs(cfg.promotion087lotteryreward.promotion087lotteryreward) do
        if n.idx == data.lottery_record then
            table.insert(win_prize_data,n)
            break
        end
    end

    local target = win_prize_data[1].point_id 

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
        for i,v in ipairs(win_prize_data[1].reward) do
            local item = {}
            item.item_type = v.item_type 
            item.item_num = v.item_num
            table.insert(vec_reward,item)
        end
        require("src.layer.ItemRewardCtr"):instance():openWindow(vec_reward)
        self:setBtnStatus(true)
        if self.lottery_type == win_prize_data[1].lottery_type then
            local item = self.menu_item:getChildByName("item_reward_"..target)
            local spr_geted = cc.Sprite:createWithSpriteFrameName("promotion/spr-sign-2.png")
            spr_geted:setPosition(50,50)
            item:addChild(spr_geted,100)
        end
        self:updateLayer()
    end)

    local delay = cc.DelayTime:create(run_time)
    local end_sequence = cc.Sequence:create(end_callback, delay)
    table.insert(action_list,end_sequence)

    local sequence = cc.Sequence:create(action_list)
    self:runAction(sequence)
end

function PROMChristmasHappyLayer:getRunAction(run_time,callback)
    local action_callback = cc.CallFunc:create(callback)
    local delay = cc.DelayTime:create(run_time)
    local sequence = cc.Sequence:create(action_callback, delay)
    return sequence
end

function PROMChristmasHappyLayer:updateLayer()
    for i=1,5 do
        if ex.Player.promotion_data.promotion87_data.bookmark >= i then
            self["spr_suotou_"..i]:setVisible(false)
        else
            self["spr_suotou_"..i]:setVisible(true)
        end

        if self.lottery_type == ex.Player.promotion_data.promotion87_data.bookmark then
            local isVisible_red = true
            if ex.Player.promotion_data.promotion87_data.bookmark == #cfg.promotion087lotterytype.promotion087lotterytype then
                if ex.Player.promotion_data.promotion87_data.bookmark == #cfg.promotion087lotterytype.promotion087lotterytype then
                    local index = 0
                    for i,v in ipairs(ex.Player.promotion_data.promotion87_data.lottery_record) do
                        if cfg.promotion087lotteryreward.promotion087lotteryreward[v].lottery_type == ex.Player.promotion_data.promotion87_data.bookmark then
                            index = index + 1
                        end
                    end
                    if index == 6 then
                        isVisible_red = false
                    end
                end
            end
            self.btn_go:setVisible(isVisible_red)
        else
            self.btn_go:setVisible(false)
        end
    end

    
end


------------------------------------------------------------------------------------
function PROMChristmasHappyLayer:onSlot(tag, pSender)
    local cost_cfg = {}
    for k,v in pairs(cfg.promotion087lotterytype.promotion087lotterytype) do
        if v.idx == self.lottery_type then
            cost_cfg = v.cost[1]
            break
        end
    end
    local item_type = cost_cfg.item_type
    local need_num = cost_cfg.item_num 
    local has_num = ex.Player:getItemNum(item_type)
    if has_num >= need_num then 
        self:setBtnStatus(false)
        local proto = Promotion087_pb.GReqChristmasLottery()
        NetManager:sendMessage(ProtocolID.GReqChristmasLottery, proto)
    else 
        ex.Tools:onClickItemSrc(item_type)
        return 
    end 
end

function PROMChristmasHappyLayer:onAdd(tag,pSender)
    local cost = {}
    for k,v in pairs(cfg.promotion087lotterytype.promotion087lotterytype) do
        if v.idx == self.lottery_type then
             cost = v.cost[1]
             break
        end
    end
    ex.Tools:onClickItemSrc(cost.item_type)
end

function PROMChristmasHappyLayer:onRewardPreview(tag, pSender)
    local table_data={}
    local max_weight = 0
    for k,v in ipairs(cfg.promotion087lotteryreward.promotion087lotteryreward) do
		if v.lottery_type == self.lottery_type then
			local table_data_temp = {}
			table_data_temp.cost = v.reward
			table_data_temp.weight = v.weight
			table_data_temp.idx = v.idx
			table.insert(table_data,table_data_temp)
            max_weight = max_weight + v.weight
		end
	end
    require("src.layer.PROMChristmasHappyPreviewCtr"):instance():openWindow(table_data,max_weight)
end

function PROMChristmasHappyLayer:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(6131), ex.Tools:getLang(6132))
end

function PROMChristmasHappyLayer:onClickItem(tag,pSender)
    ex.Tools:showItemInfo(tag,pSender)
end

function PROMChristmasHappyLayer:onSwitch(tag,pSender)
    if tag == self.lottery_type then return end
    self.spr_select_1:setVisible(false)
    self.spr_select_2:setVisible(false)
    local btn_tab = self["btn_day_"..tag]
    if btn_tab then
        local lbl = btn_tab:getLabel()
        lbl:enableOutline(cc.c3b(65, 144, 199), 0)
        lbl:setTextColor(cc.c4b(255, 246, 101, 255))
    end

    btn_tab = self["btn_day_"..self.lottery_type]
    if btn_tab then
        local lbl = btn_tab:getLabel()
        lbl:enableOutline(cc.c3b(65, 144, 199), 4)
        lbl:setTextColor(cc.c4b(20, 50, 89, 255))
    end

    for i=1,5 do
        if ex.Player.promotion_data.promotion87_data.bookmark == tag then
            local isVisible_red = true
            if ex.Player.promotion_data.promotion87_data.bookmark == #cfg.promotion087lotterytype.promotion087lotterytype then
                if ex.Player.promotion_data.promotion87_data.bookmark == #cfg.promotion087lotterytype.promotion087lotterytype then
                    local index = 0
                    for i,v in ipairs(ex.Player.promotion_data.promotion87_data.lottery_record) do
                        if cfg.promotion087lotteryreward.promotion087lotteryreward[v].lottery_type == ex.Player.promotion_data.promotion87_data.bookmark then
                            index = index + 1
                        end
                    end
                    if index == 6 then
                        isVisible_red = false
                    end
                end
            end
            self.btn_go:setVisible(isVisible_red)
        else
            self.btn_go:setVisible(false)
        end
    end

    self.lottery_type = tag
    self.spr_xuanzhong:setPosition(pSender:getPosition())
    self:createSlotItems()
end


return PROMChristmasHappyLayer
