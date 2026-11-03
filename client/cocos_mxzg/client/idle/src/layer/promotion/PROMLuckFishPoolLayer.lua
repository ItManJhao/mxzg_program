local PROMLuckFishPoolLayer = class("PROMLuckFishRewardPoolLayer", require("src.layer.promotion.PromotionBaseLayer"))
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBag")

function PROMLuckFishPoolLayer:onCreate()
    self.select_idx = 1
    self:createItem()
    self:registerBtnEvent()
    self:updateRes()
    self:createRewardNode()
    self:updateNick()
    self:updateBtnStatus()
	self:changTimer()
	self:addTimer("timer",1000,handler(self,self.changTimer),true)
    self:addEvent(EVENT.LUCK_FISH.UPDATE_BLESSING,handler(self,self.onBlessing))
    self:addEvent(EVENT.LUCK_FISH.UPDATE_NICK,handler(self,self.onNick))
end

function PROMLuckFishPoolLayer:onExit()
    self:removeAutoRun()
end

function PROMLuckFishPoolLayer:removeAutoRun( )
    if self.run_timer ~= nil then 
        ex.Timer:removeTimerById(self.run_timer)
        self.run_timer = nil 
    end
end

function PROMLuckFishPoolLayer:startRun( )
    -- self:addTimer("default",500,handler(self,self.autoRun),true)
    self:removeAutoRun()
    self.run_timer = ex.Timer:addTimer(1000, handler(self,self.autoRun), true)
end

function PROMLuckFishPoolLayer:autoRun( )
    local x,y = self["node_" .. self.select_idx]:getPosition()
    self.spr_select:setPosition(cc.p(x,y))
    self.select_idx = self.select_idx + 1
    if self.select_idx > 5 then 
        self.select_idx = 1
    end
end

function PROMLuckFishPoolLayer:changTimer()
    local open_data = ex.Player.promotion_data:getPromotionDatas(67)
    local end_time = open_data.end_time
    local cur_time = ex.Game:getServerTime()
	if end_time - cur_time <= 0 then 
		self:removeTimerByName("timer")
		-- HeroArriveCtr:instance():closeWindow()
	end
	local d,h,m,s = ex.Tools:formatTime(end_time - cur_time)
	local str = string.format(ex.Tools:getLang(47289),d,h)
    -- print(time,self.__cname,str,ex.Game:getServerTime(),ex.Player.heroarrive_data:getEndTime())
    self.lbl_time:setPositionX(self.lbl_time_tips:getPositionX() + self.lbl_time_tips:getContentSize().width)
	self.lbl_time:setString(str)
end

function PROMLuckFishPoolLayer:onNick(event,data)
    self:updateNick()
end

function PROMLuckFishPoolLayer:onBlessing(event,data)
    self:runSelect(data)
end

function PROMLuckFishPoolLayer:registerBtnEvent()
    local item_cfg = cfg.system.weekend_koi_blessing_cost[1]
    self.spr_icon:setSpriteFrame(string.format("backpack/%s.png",item_cfg.item_type))
    local spr = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%s.png",item_cfg.item_type))
    spr:setScale(0.3)
    self.btn_buy:addChild(spr)
    spr:setPosition(85,self.btn_buy:getContentSize().height / 2)
    self.btn_buy.spr = spr
    self.btn_reward:registerScriptTapHandler(handler(self,self.onClickBigReward))
    self.btn_info:registerScriptTapHandler(handler(self,self.onClickInfo))
    self.btn_buy:registerScriptTapHandler(handler(self,self.onClickBuy))
    self.btn_record:registerScriptTapHandler(handler(self,self.onRecord))
end

function PROMLuckFishPoolLayer:createRewardNode()
    self.btn_reward:setContentSize(cc.size(137,137))
    self.btn_reward.spine = sp.SkeletonAnimation:create("spine/jldj.json","spine/jldj.atlas", 1)
    self.btn_reward.spine:setAnimation(0, "stand", true)
    self.btn_reward:addChild(self.btn_reward.spine)
    self.btn_reward.spine:setPosition(self.btn_reward:getContentSize().width / 2 , self.btn_reward:getContentSize().height / 2)
    local node = cc.Node:create()
    node:setName("info")
    local spr = cc.Sprite:createWithSpriteFrameName("promotion-luck-fish/spr-reward-bg.png")
    node:addChild(spr)

    local lbl = cc.Label:createWithTTF("11", FONT_DEFAULT_NAME_BOLD, 18)
    lbl:enableOutline(cc.c3b(87,56,29),2)
    lbl:setColor(cc.c3b(253,228,181))
    lbl:setPositionY(-18)
    node:addChild(lbl)

    node:setPosition(self.btn_reward:getContentSize().width / 2, -spr:getContentSize().height / 2 + 15)
    self.btn_reward:addChild(node)
    self.node_info = node
    self.node_info.lbl = lbl
end

function PROMLuckFishPoolLayer:updateNick()
    local nick = ex.Player.promotion_data.luck_fish_data:getKoiNick()
    self.node_info:setVisible(nick ~= "")
    self.node_info.lbl:setString(nick)
end

function PROMLuckFishPoolLayer:updateRes( )
    local item_cfg = cfg.system.weekend_koi_blessing_cost[1]
    local has_num = ex.Player:getItemNum(item_cfg.item_type)
    self.lbl_num:setString("x".. has_num)
end

function PROMLuckFishPoolLayer:updateBtnStatus( )
    local blessing_num = cfg.system.weekend_koi_blessing_num
    local num = ex.Player.promotion_data.luck_fish_data:getBlessingNum()
    self.btn_buy:setEnabled(blessing_num > num)
    if blessing_num >= num then 
        local normal_img = self.btn_buy:getNormalImage()
        local select_img = self.btn_buy:getSelectedImage()
        ex.Tools:setGrayAuto(normal_img,blessing_num <= num)
        ex.Tools:setGrayAuto(select_img,blessing_num <= num)
        ex.Tools:setGrayAuto(self.btn_buy.spr,blessing_num <= num)
    end
end

function PROMLuckFishPoolLayer:onClickBigReward(tag,pSender)
    require("src.layer.promotion.PROMLuckFishBigRewardCtr"):instance():openWindow()
end

function PROMLuckFishPoolLayer:onClickInfo(tag,pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(3260), ex.Tools:getLang(3261))
end

function PROMLuckFishPoolLayer:onClickBuy(tag,pSender)
    local item_cfg = cfg.system.weekend_koi_blessing_cost[1]
    local has_num = ex.Player:getItemNum(item_cfg.item_type)
    if has_num >= item_cfg.item_num then 
        NetManager:sendMessage(ProtocolID.GReqUseBlessing)
        pSender:setEnabled(false)
    else
        ex.MessageView:add(string.format(ex.Tools:getLang(1108),ex.Tools:getLang(cfg.item.item[item_cfg.item_type].name)))
    end
end

function PROMLuckFishPoolLayer:getRunAction(run_time,callback)
    local action_callback = cc.CallFunc:create(callback)
    local delay = cc.DelayTime:create(run_time)
    local sequence = cc.Sequence:create(action_callback, delay)
    return sequence
end

function PROMLuckFishPoolLayer:runSelect(data)
    self:removeAutoRun()
    local point = self.select_idx
    local length = 5
    local callback = function ()
        local x,y = self["node_" .. point]:getPosition()
        self.spr_select:setPosition(cc.p(x,y))
        point = point + 1
        if point > 5 then 
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
        run_time = run_time + 0.05
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
        run_time = run_time + 0.1
        total_time = total_time + run_time
    end

    local end_callback = cc.CallFunc:create(function()
        self:startRun()
        self.btn_buy:setEnabled(true)
        self:updateRes()
        self:updateBtnStatus()
        local vec_reward = {}
        for i,v in ipairs(data.item) do
            local item = {}
            item.item_type = v.type 
            item.item_num = v.num
            table.insert(vec_reward,item)
        end
        require("src.layer.ItemRewardCtr"):instance():openWindow(vec_reward)
        -- self:playEff(data)
        -- self:updateReward()
        -- self:refreshRes()
        -- ex.EventManager:fire(EVENT.SHEN_YU.RUN_END,data)
    end)

    local delay = cc.DelayTime:create(run_time)
    local end_sequence = cc.Sequence:create(end_callback, delay)
    table.insert(action_list,end_sequence)


    local sequence = cc.Sequence:create(action_list)
    self.spr_select:runAction(sequence)
    self.select_idx = target
end

function PROMLuckFishPoolLayer:onRecord(tag,pSender)
    require("src.layer.promotion.PROMLuckFishRecordCtr"):instance():openWindow()
end

function PROMLuckFishPoolLayer:createItem( )
    local item_cfg = ex.Player.promotion_data.luck_fish_data:getCfg()
	self.menu_reward:removeAllChildren()
    for i,v in ipairs(item_cfg) do
        local item_data = v.reward[1]
		local x,y = self["node_" .. i]:getPosition()
		local item = UIMenuItemBackpack:createWithData(item_data.item_type,item_data.item_num)
		self.menu_reward:addChild(item)
		item:setPosition(x,y)
		item:registerScriptTapHandler(handler(self,self.onClickItemInfo))
	end
end

function PROMLuckFishPoolLayer:onClickItemInfo(tag,pSender)
	ex.Tools:showItemInfo(tag,pSender)
end

return PROMLuckFishPoolLayer
