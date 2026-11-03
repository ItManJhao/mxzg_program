local PROMLuckFishBuyLayer = class("PROMLuckFishRewardPoolLayer", require("src.layer.promotion.PromotionBaseLayer"))
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBag")

function PROMLuckFishBuyLayer:onCreate()
    self:createItem()
    self:registerBtnEvent()
    -- self:updateRes()
    self:createRewardNode()
    self:changeBtnStatus()
    self:changTimer()
    self:addTimer("timer",1000,handler(self,self.changeBtnStatus),true)
    self:addTimer("timer1",1000,handler(self,self.changTimer),true)
    self:addEvent(EVENT.LUCK_FISH.UPDATE_NICK,handler(self,self.onNick))
end

function PROMLuckFishBuyLayer:changTimer()
    local open_data = ex.Player.promotion_data:getPromotionDatas(67)
    local end_time = open_data.end_time
    local cur_time = ex.Game:getServerTime()
	if end_time - cur_time <= 0 then 
		self:removeTimerByName("timer1")
		-- HeroArriveCtr:instance():closeWindow()
	end
	local d,h,m,s = ex.Tools:formatTime(end_time - cur_time)
    local str = string.format(ex.Tools:getLang(47289),d,h)
    local tips_str = ex.Tools:getLang(77009)

    -- print(time,self.__cname,str,ex.Game:getServerTime(),ex.Player.heroarrive_data:getEndTime())
    self.lbl_time:setPositionX(self.lbl_time_tips:getPositionX() + self.lbl_time_tips:getContentSize().width)
	self.lbl_time:setString(str)
end

function PROMLuckFishBuyLayer:onNick(event,data)
    self:updateNick()
end

function PROMLuckFishBuyLayer:changeBtnStatus( )
    local open_data = ex.Player.promotion_data:getPromotionDatas(67)

    if not open_data then 
        self.btn_buy:setEnabled(false)
        local normal_img = self.btn_buy:getNormalImage()
        local select_img = self.btn_buy:getSelectedImage()
        ex.Tools:setGrayAuto(normal_img,true)
        ex.Tools:setGrayAuto(select_img,true)
        self:removeTimerByName("timer")
        return 
    end 
    
    local end_buy = open_data.start_time + cfg.system.weekend_koi_buy_end_time
    local cur_time = ex.Game:getServerTime()
    if cur_time >= end_buy then 
        self.btn_buy:setEnabled(false)
        local normal_img = self.btn_buy:getNormalImage()
        local select_img = self.btn_buy:getSelectedImage()
        ex.Tools:setGrayAuto(normal_img,true)
        ex.Tools:setGrayAuto(select_img,true)
        self:removeTimerByName("timer")
    end
end

function PROMLuckFishBuyLayer:registerBtnEvent()
    self.btn_reward:registerScriptTapHandler(handler(self,self.onClickBigReward))
    self.btn_info:registerScriptTapHandler(handler(self,self.onClickInfo))
    self.btn_buy:registerScriptTapHandler(handler(self,self.onClickBuy))
    self.btn_reward_pool:registerScriptTapHandler(handler(self,self.showRewardPool))
end

function PROMLuckFishBuyLayer:createRewardNode()
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

    

    node:setPosition(self.btn_reward:getContentSize().width / 2 , -spr:getContentSize().height / 2 + 15)
    self.btn_reward:addChild(node)
    self.node_info = node
    self.node_info.lbl = lbl
    self:updateNick()
end

function PROMLuckFishBuyLayer:updateNick()
    local nick = ex.Player.promotion_data.luck_fish_data:getKoiNick()
    self.node_info:setVisible(nick ~= "")
    self.node_info.lbl:setString(nick)
end

-- function PROMLuckFishBuyLayer:updateRes( )
--     local item_cfg = cfg.system.weekend_koi_blessing_cost[1]
--     local has_num = ex.Player:getItemNum(item_cfg.item_type)
--     self.lbl_num:setString("x".. has_num)
-- end

function PROMLuckFishBuyLayer:onClickBigReward(tag,pSender)
    require("src.layer.promotion.PROMLuckFishBigRewardCtr"):instance():openWindow()
end

function PROMLuckFishBuyLayer:onClickInfo(tag,pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(3260), ex.Tools:getLang(3261))
end

function PROMLuckFishBuyLayer:onClickBuy(tag,pSender)
    local product = cfg.promotionweekendkoi.promotionweekendkoi[1].product_id
    ex.Player:pay(product)
end

function PROMLuckFishBuyLayer:showRewardPool(tag,pSender)
    require("src.layer.promotion.PROMLuckFishRewardPoolCtr"):instance():openWindow()
end

function PROMLuckFishBuyLayer:createItem( )
    local product = cfg.promotionweekendkoi.promotionweekendkoi[1].product_id
    local item_cfg = cfg.buygem.buygem[product].item --ex.Player.promotion_data.luck_fish_data:getCfg()
	self.scroll_view:getContainer():removeAllChildren()
	local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(self.scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    self.scroll_view:getContainer():addChild(menu)
    local margin = 10
    for i,v in ipairs(item_cfg) do
		local item = UIMenuItemBackpack:createWithData(v.item_type,v.item_num)
        local size = item:getContentSize()
        local x = size.width / 2 + margin + (i - 1) * (size.width + margin)
        local y = size.height / 2
        menu:addChild(item)
		item:setPosition(x,y)
        item:registerScriptTapHandler(handler(self,self.onClickItemInfo))
        local limit_num = cfg.promotionweekendkoi.promotionweekendkoi[1].buy_limit
        local buy_num = ex.Player.promotion_data.luck_fish_data:getLimitNum() 
        self.lbl_num:setString(string.format(ex.Tools:getLang(3254),buy_num,limit_num))
	end
end

function PROMLuckFishBuyLayer:onClickItemInfo(tag,pSender)
	ex.Tools:showItemInfo(tag,pSender)
end

return PROMLuckFishBuyLayer
