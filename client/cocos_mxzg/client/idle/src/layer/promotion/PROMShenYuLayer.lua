local PROMShenYuLayer = class("PROMShenYuLayer", require("src.layer.promotion.PromotionBaseLayer"))
local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")
local MAX_FLOOR = 4

function PROMShenYuLayer:onCreateDone()
    self.cur_point = 1
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/shenyu-lang.plist")
    self:updateFloorData(ex.Player.promotion_data.shenyu_data:getFloor())
    self:autoBgPosY()
    self:initRes()
    self:updateReward()
    self:registerBtnEvent()
    self:addBtnText()
    self:createRich()
    self:addEvent(EVENT.BACK_PACK_EVENT.BACKPACK_UPDATA_LIST,handler(self,self.updateRes))
    self:addEvent(EVENT.SHEN_YU.UPDATE_REWARD,handler(self,self.onReward))
    self:addEvent(EVENT.SHEN_YU.RUN_END,handler(self,self.runEnd))
    self:changTimer()
    self:addTimer("timer1",1000,handler(self,self.changTimer),true)
end

function PROMShenYuLayer:createRich( )
    self.lbl_time = require("src.comp.RichTextEx"):create() 
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setAnchorPoint(cc.p(0,0.5))
    self.rich_node:addChild(self.lbl_time)
end

function PROMShenYuLayer:changTimer()
    local open_data = ex.Player.promotion_data:getPromotionDatas(72)
    if not open_data then
        self:removeTimerByName("timer1")
        if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
    end
    
    local end_time = open_data.end_time
    local cur_time = ex.Game:getServerTime()
	if end_time - cur_time <= 0 then 
		self:removeTimerByName("timer1")
        if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
	end
	local time_str = ex.Tools:formatTime4(end_time - cur_time)
    local str = string.format(ex.Tools:getLang(77009),time_str)
    self.lbl_time:setXmlTextLua(str)
end

function PROMShenYuLayer:runEnd(event,data)
    self:setBtnStatus(true)
end

function PROMShenYuLayer:onReward(event,data)
    if self.floor ~= MAX_FLOOR then 
        self:runSelect(data)
    else
        self:playEff(data)
        -- self:setBtnStatus(true)
    end
    -- self:updateReward()
    -- self:refreshRes()
end

function PROMShenYuLayer:getRunAction(run_time,callback)
    local action_callback = cc.CallFunc:create(callback)
    local delay = cc.DelayTime:create(run_time)
    local sequence = cc.Sequence:create(action_callback, delay)
    return sequence
end

function PROMShenYuLayer:runSelect(data)
    self.cur_selected = self["select_" .. self.floor]
    local reward_cfg = ex.Player.promotion_data.shenyu_data:getRewardByFloor(self.floor)
    local length = #reward_cfg
    local point = self.cur_point
    local callback = function ()
        local floor_node = self["reward_node_" .. self.floor]
        local node = floor_node:getChildByTag(point)
        local x,y = node:getPosition()
        self.cur_selected:setPosition(cc.p(x,y))
        point = point + 1
        if point > length then point = 1 end 
    end
    local max_time = 3
    local run_time = 0.01
    local total_time = 0
    local action_list = {}
    while total_time < max_time do 
        local sequence = self:getRunAction(run_time,callback)
        table.insert(action_list,sequence)
        run_time = run_time + 0.05
        total_time = total_time + run_time
    end
    local idx = data.idx[1]
    local target = 1
    local floor_cfg = ex.Player.promotion_data.shenyu_data:getRewardByFloor(self.floor)
    for i,v in ipairs(floor_cfg) do
        if v.idx == idx then 
            target = i 
            break
        end
    end
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
        run_time = run_time + 0.1
        total_time = total_time + run_time
    end

    local end_callback = cc.CallFunc:create(function()
        self:playEff(data)
        -- self:updateReward()
        self:refreshRes()
        -- ex.EventManager:fire(EVENT.SHEN_YU.RUN_END,data)
    end)

    local delay = cc.DelayTime:create(run_time)
    local end_sequence = cc.Sequence:create(end_callback, delay)
    table.insert(action_list,end_sequence)


    local sequence = cc.Sequence:create(action_list)
    self.cur_selected:runAction(sequence)
    self.cur_point = target
end

function PROMShenYuLayer:playEff(data)
    local is_unlock = #data.floors > 0 
    local rewards = {}
    for i,v in ipairs(data.rewards) do
        local data = {}
        data.item_id   = v.id 
        data.item_type = v.type
        data.item_num  = v.num

        table.insert(rewards, data)
    end

    local again_callback = function()
        if self.sommun_type == 3 then 
            local cost_cfg = ex.Player.promotion_data.shenyu_data:getCostByFloor(self.floor)
            local money_cfg = cost_cfg.cost_money[1]
            if ex.Player:getItemNum(money_cfg.item_type) < money_cfg.item_num then 
                ex.Tools:onClickItemSrc(money_cfg.item_type)
                return 
            end
            local max_num = cfg.system.promotion_zsjt_money_buynum
            local count = ex.Player.promotion_data.shenyu_data:getMoney()
            if count >= max_num then 
                ex.MessageView:add(ex.Tools:getLang(77020))
                return 
            end 
        else
            local cost_cfg = ex.Player.promotion_data.shenyu_data:getCostByFloor(self.floor)
            local money_cfg = cost_cfg.cost_item[1]
            local need_num = self.sommun_type == 1 and money_cfg.item_num or money_cfg.item_num * 5
            if ex.Player:getItemNum(money_cfg.item_type) < need_num then 
                ex.Tools:onClickItemSrc(money_cfg.item_type)
                return 
            end
        end
        local req = Promotion072_pb.GReqZSJTLuckDraw()
        req.type = self.sommun_type
        NetManager:sendMessage(ProtocolID.GReqZSJTLuckDraw, req)
        self:setBtnStatus(false)
    end
    if is_unlock then 
        
        local function func()
            self.floor = ex.Player.promotion_data.shenyu_data:getFloor()
            self:updateReward()
            if self.floor == 1 then 
                ex.MessageView:add(ex.Tools:getLang(77025))
                -- if self.palm then self.palm:removeFromParent() end
            end
            local again = {}
            again.callback = again_callback
            again.title = string.format(ex.Tools:getLang(77024),self.sommun_type == 2 and 5 or 1)
            require("src.layer.promotion.ShenYuRewardCtr"):instance():openWindow(rewards,again)
            ex.EventManager:fire(EVENT.SHEN_YU.RUN_END)
        end
        local callback = cc.CallFunc:create(func)
        local action = cc.Sequence:create(callback, cc.RemoveSelf:create(), nil)
        self.palm = ex.EffectFactory:createEffectWithNodeByName("eff_shen_yu",action)
        self.palm:setPosition(cc.p(self:getContentSize().width * 0.5, self:getContentSize().height * 0.5))
        self:addChild(self.palm)
        self.cur_point = 1
       
    else
        -- ex.MessageView:add("!!!!!!!!")
        local again = {}
        again.callback = again_callback
        again.title = string.format(ex.Tools:getLang(77024),self.sommun_type == 2 and 5 or 1)
        require("src.layer.promotion.ShenYuRewardCtr"):instance():openWindow(rewards,again)
        ex.EventManager:fire(EVENT.SHEN_YU.RUN_END)
    end
end

function PROMShenYuLayer:addBtnText( )
    local cost_cfg = ex.Player.promotion_data.shenyu_data:getCostByFloor(self.floor)
    self.btn_money_summon.text = require("src.comp.RichTextEx"):create() 
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setContentSize((self.btn_money_summon:getContentSize().width - 35), self.btn_money_summon:getContentSize().height)
	:setAnchorPoint(ex.a.top_center)
	self.btn_money_summon:addChild(self.btn_money_summon.text)
    self.btn_money_summon.text:setPosition(self.btn_money_summon:getContentSize().width / 2,60)

    local str = string.format(ex.Tools:getLang(77012),cost_cfg.cost_money[1].item_type)
    self.btn_money_summon.text:setXmlTextLua(str)

    self.btn_item_sommun_1.text = require("src.comp.RichTextEx"):create() 
    :setFontSize(20)
    :setFontColor("#ffffff")
    :setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setContentSize((self.btn_item_sommun_1:getContentSize().width - 35), self.btn_item_sommun_1:getContentSize().height)
	:setAnchorPoint(ex.a.top_center)
	self.btn_item_sommun_1:addChild(self.btn_item_sommun_1.text)
    self.btn_item_sommun_1.text:setPosition(self.btn_item_sommun_1:getContentSize().width / 2,60)

    local str = string.format(ex.Tools:getLang(77013),cost_cfg.cost_item[1].item_type)
    self.btn_item_sommun_1.text:setXmlTextLua(str)

    self.btn_item_sommun_2.text = require("src.comp.RichTextEx"):create() 
    :setFontSize(20)
    :setFontColor("#ffffff")
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setContentSize((self.btn_item_sommun_2:getContentSize().width - 35), self.btn_item_sommun_2:getContentSize().height)
	:setAnchorPoint(ex.a.top_center)
	self.btn_item_sommun_2:addChild(self.btn_item_sommun_2.text)
    self.btn_item_sommun_2.text:setPosition(self.btn_item_sommun_2:getContentSize().width / 2,60)

    local str = string.format(ex.Tools:getLang(77014),cost_cfg.cost_item[1].item_type)
    self.btn_item_sommun_2.text:setXmlTextLua(str)


    self.btn_shop.lbl_shop = cc.Label:createWithTTF(ex.Tools:getLang(77011), FONT_DEFAULT_NAME_BOLD, 16)
    self.btn_shop:addChild(self.btn_shop.lbl_shop)
    self.btn_shop.lbl_shop:setPosition(self.btn_shop:getContentSize().width * 0.5,8)
    self.btn_shop.lbl_shop:enableOutline(cc.c3b(32,70,129), 2)
end

function PROMShenYuLayer:registerBtnEvent( )
    self.btn_money_summon:registerScriptTapHandler(handler(self,self.onMoneySummon))
    self.btn_item_sommun_1:registerScriptTapHandler(handler(self,self.onItemSummon))
    self.btn_item_sommun_2:registerScriptTapHandler(handler(self,self.onItemSummon))

    self.btn_info:registerScriptTapHandler(handler(self,self.onInfo))
    self.btn_shop:registerScriptTapHandler(handler(self,self.onShop))
end

function PROMShenYuLayer:onMoneySummon(tag,pSender)
    local max_num = cfg.system.promotion_zsjt_money_buynum
    local count = ex.Player.promotion_data.shenyu_data:getMoney()
    if count >= max_num then 
        ex.MessageView:add(ex.Tools:getLang(77020))
        return 
    end 
    
    local cost_cfg = ex.Player.promotion_data.shenyu_data:getCostByFloor(self.floor)
    local money_cfg = cost_cfg.cost_money[1]
    if ex.Player:getItemNum(money_cfg.item_type) < money_cfg.item_num then 
        ex.Tools:onClickItemSrc(money_cfg.item_type)
        return 
    end


    
    -- self:runSelect()

    local str = string.format(ex.Tools:getLang(77019), money_cfg.item_num)

    ex.ConfirmCtr:openWindow("", str, function()
        local req = Promotion072_pb.GReqZSJTLuckDraw()
        req.type = 3
        NetManager:sendMessage(ProtocolID.GReqZSJTLuckDraw, req)
        self.sommun_type = 3
        self:setBtnStatus(false)
    end)   


end

function PROMShenYuLayer:onItemSummon(tag,pSender)
    local cost_cfg = ex.Player.promotion_data.shenyu_data:getCostByFloor(self.floor)
    local money_cfg = cost_cfg.cost_item[1]
    local need_num = tag == 1 and money_cfg.item_num or money_cfg.item_num * 5
    if ex.Player:getItemNum(money_cfg.item_type) < need_num then 
        ex.Tools:onClickItemSrc(money_cfg.item_type)
        return 
    end
    self:setBtnStatus(false)

    local req = Promotion072_pb.GReqZSJTLuckDraw()
	req.type = tag
    NetManager:sendMessage(ProtocolID.GReqZSJTLuckDraw, req)
    self.sommun_type = tag
end

function PROMShenYuLayer:onInfo(tag,pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(77027), ex.Tools:getLang(77028))
end

function PROMShenYuLayer:onShop(tag,pSender)
    cfg.funcopen.main_shop.open(SHOP_TYPE.SHEN_YU) 
end

function PROMShenYuLayer:setBtnStatus( bool )
    self.btn_money_summon:setEnabled(bool)
    self.btn_item_sommun_1:setEnabled(bool)
    self.btn_item_sommun_2:setEnabled(bool)
end

function PROMShenYuLayer:updateReward( )
    for i=1,MAX_FLOOR do
        self:updateFloorReward(i)
    end
end

function PROMShenYuLayer:updateFloorReward(floor)
    local reward_cfg = ex.Player.promotion_data.shenyu_data:getRewardByFloor(floor)
    local floor_cfg = ex.Player.promotion_data.shenyu_data:getCostByFloor(floor)
    local floor_node = self["reward_node_" .. floor]
    local menu = self["menu_" .. floor]
    menu:removeAllChildren()
    for i,v in ipairs(reward_cfg) do
        local item = UIMenuItemBag:createWithData(v.reward[1].item_type,v.reward[1].item_num)
        local node = floor_node:getChildByTag(i)
        local x,y = node:getPosition()
        menu:addChild(item)
        item:setPosition(cc.p(x,y))
        item:registerScriptTapHandler(handler(self, self.showInfo))
        if v.idx == floor_cfg.lock_reward then 
            local spr = cc.Sprite:createWithSpriteFrameName("shenyu-lang/spr-unlock.png")
            item:addChild(spr)
            local item_size = item:getContentSize()
            spr:setPosition(item_size.width / 2,item_size.height - spr:getContentSize().height / 2)
            spr:setLocalZOrder(100000)
        end
    end
    local shadow = self["shadow_" .. floor]
    shadow:setVisible(floor ~= self.floor)

    local line = self["line_" .. floor]
    line:setVisible(floor ~= self.floor)

    local lock = self["lock_" .. floor]
    if lock then 
        lock:setVisible(floor ~= self.floor and floor > self.floor)
    end

    local selected = self["select_" .. floor]
    selected:setVisible(floor == self.floor)
end

function PROMShenYuLayer:showInfo(tag,pSender)
    ex.Tools:showItemInfo(tag,pSender)
end

function PROMShenYuLayer:updateFloorData(floor)
    self.floor = floor
    self.floor_cost_cfg = ex.Player.promotion_data.shenyu_data:getCostByFloor(self.floor)
end

function PROMShenYuLayer:autoBgPosY( )
    local origin_bg_y = self.spr_bg:getPositionY()
    local offset_y = self.layer_promotion:getTopY() - origin_bg_y
    local origin_main_y = self.node_main:getPositionY()
    self.node_main:setPositionY(origin_main_y + math.abs(offset_y))
    self.spr_bg:setPositionY(self.layer_promotion:getTopY())
    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    self.spr_bg:setScaleY(self.spr_bg:getPositionY() / (self.spr_bg:getContentSize().height))
    self.node_main:setScale(math.min(ex.s.global_scale, 1))
end

function PROMShenYuLayer:initRes( )
    self:refreshRes()
end

function PROMShenYuLayer:refreshRes()
    local cost_cfg = ex.Player.promotion_data.shenyu_data:getCostByFloor(self.floor)

    ex.Tools:setSpriteFrame(self.spr_icon,string.format("backpack/%s.png",cost_cfg.cost_item[1].item_type))
    local has_num = ex.Player:getItemNum(cost_cfg.cost_item[1].item_type)
    self.lbl_item_num:setString(has_num)

    local str_num = string.format("%s/%s",cfg.system.promotion_zsjt_money_buynum - ex.Player.promotion_data.shenyu_data:getMoney(),cfg.system.promotion_zsjt_money_buynum)
    local str = ex.Tools:getLang(77022) .. str_num
    self.lbl_summon_num:setString(str)
end

function PROMShenYuLayer:updateRes(event,item_type)
    local cost_cfg = ex.Player.promotion_data.shenyu_data:getCostByFloor(self.floor)
    if item_type ~= cost_cfg.cost_item[1].item_type then 
        return 
    end

    self:refreshRes()
end


return PROMShenYuLayer
