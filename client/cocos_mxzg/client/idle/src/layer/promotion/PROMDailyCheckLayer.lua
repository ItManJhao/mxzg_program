local PROMDailyCheckLayer = class("PROMDailyCheckLayer", require("src.layer.promotion.PromotionBaseLayer"))

local UIItemSignIn = require("src.comp.menu.UIMenuItemSignIn")
local table_insert = table.insert;
function PROMDailyCheckLayer:onCreateDone()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/promotion.plist")
    sfc:addSpriteFrames("ccbi-res/promotion-effect.plist")
    

	self.item_size = cc.Sprite:createWithSpriteFrameName("promotion/sign-bg.png"):getContentSize()
    self.item_size = cc.size(self.item_size.width + 3, self.item_size.height + 1)

    self.scroll_view = cc.ScrollView:create(cc.size(100, 100))
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(self.spr_bg:getPositionX(), self.spr_bg:getPositionY() + 2)
    self:addChild(self.scroll_view)
    
    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(1))

    local sub_size = cc.size(60, 60)
    self:resetScrollView(nil, sub_size)

    self.viewSize = self.scroll_view:getViewSize()

    self.spr_box:setContentSize(cc.size(self.viewSize.width + sub_size.width, self.viewSize.height + sub_size.height))
    self.spr_box:setPosition(cc.p(self.scroll_view:getPositionX() - sub_size.width * 0.5, self.scroll_view:getPositionY() - sub_size.height * 0.5))

    self.spr_bg:setContentSize(cc.size(self.viewSize.width + sub_size.width * 0.5, self.viewSize.height + sub_size.height * 0.5))
    self.spr_bg:setPosition(cc.p(self.scroll_view:getPositionX() - sub_size.width * 0.25, self.scroll_view:getPositionY() - sub_size.height * 0.25))

    self:updateStarView()
end

function PROMDailyCheckLayer:updateStarView()
	self.scroll_view:getContainer():removeAllChildren()

	local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(self.scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    self.scroll_view:addChild(menu)


    -- local start_server_month = os.date("%m", ex.Player.server_create_time)
    -- local now_month = os.date("%m",os.time())
    local now_month = ex.Player.promotion_data.sign_in.month
    local reward_list = {}
    if ex.Player.promotion_data.sign_in.newServer == 1 then 
        for k,v in pairs(cfg.sign.sign) do
            if tonumber(now_month) == tonumber( v.month) then 
                reward_list[v.day] = v.new_server_reward
            end
        end
    else
        for k,v in pairs(cfg.sign.sign) do
            if  tonumber(now_month) ==tonumber(v.month) then 
                reward_list[v.day] = v.reward
            end
        end
    end 

    local signInLen = #reward_list

    local col = 5 --math.floor(self.viewSize.width / self.item_size.width) -- 列数
    local scale = 1.0
    local cont_width = self.item_size.width * col + 20
    if cont_width > self.viewSize.width then
        scale = self.viewSize.width / cont_width
        self.item_size.width = self.item_size.width * scale + 3
        self.item_size.height = self.item_size.height * scale
    end

    local row = math.ceil(1.0 * signInLen / col) -- 行数
    local cont_height = self.item_size.height * row
    cont_height = math.max(cont_height , self.viewSize.height)
    row = math.ceil(cont_height / self.item_size.height) -- 总行数

    self.scroll_view:setContentSize(cc.size(self.viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, self.viewSize.height - cont_height))

    cont_height = cont_height - self.item_size.height * 0.5

    local start = cc.p(self.viewSize.width * 0.5 - (self.item_size.width * col * 0.5), cont_height)
    start.x = start.x + self.item_size.width * 0.5
    self.spr_select_bg = {}
    --ex.log(string.format("signInLen=%d, col=%d, row=%d", signInLen, col, row))

    -- 当前签到
    local cur_signIn = ex.Player.promotion_data.sign_in.days

    -- local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")
    for i=1,signInLen do
        local index = i - 1
        local x = index % col
        local y = math.floor(index / col)
        --local reward = cfg.promotion30daylogin.sign[i].reward[1]
        local reward = reward_list[i][1]

        local item = UIItemSignIn:createWithData(reward.item_type, reward.item_num)  -- UIItemSignIn:createWithData(i, reward.item_type, reward.item_num)
        item:setPosition(start.x + x * self.item_size.width, start.y - y * self.item_size.height)
        item:setScale(scale)
        item:registerScriptTapHandler(handler(self, self.onBtnSignIn))
        menu:addChild(item)

        local show_select = false
        local is_show = true
        if ex.Player.promotion_data.sign_in.is_sign == 0 then 
            if index > cur_signIn then 
                item:setState(3)
            elseif index == cur_signIn then  -- 可领取
                item:setState(0)
                show_select = true
            else 
                item:setState(2)
            end
        elseif ex.Player.promotion_data.sign_in.is_sign ==  1 then   
            -- 一签完成
            local nowData = cur_signIn - 1
            if index == nowData then  -- 可领取
                item:setState(1)
            elseif index > nowData then  
                item:setState(3)
            else 
                item:setState(2)
            end
        else 
            if index > cur_signIn then 
                item:setState(3)
            elseif index == cur_signIn then  
                item:setState(0)
            else 
                item:setState(2)
            end

        end 

        if is_show == true and x - (math.floor(x / 2) * 2) <= 0 then
            local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_promotion_3")
            spr_effect:setPosition(item:getContentSize().width / 2 - 2, item:getContentSize().height / 2)
            item:addChild(spr_effect, 20, 20)
        end

        if show_select then 
            if not self.spr_select_bg[i] then   
            
                self.spr_select_bg[i] = cc.Sprite:createWithSpriteFrameName("promotion/sign-box.png")
                self.spr_select_bg[i]:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
                :setScale(1.1, 1.13)
                item:addChild(self.spr_select_bg[i], 20, 20)

                --self.spr_select_bg[i]:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeIn:create(0.6), cc.DelayTime:create(0.5), cc.FadeOut:create(0.6),  nil)))
            end 
        else
            if self.spr_select_bg[i] then  
                self.spr_select_bg[i]:setVisible(false)
            end 
        end 


    end

end




function PROMDailyCheckLayer:onBtnSignIn(tag, pSender)
    if pSender.state == 3 then
        ex.MessageView:add(ex.Tools:getLang(41066)) -- ex.Tools:getLang(1121)
        return
    end
    
    --pSender:onSignIn()
    if ex.Player.promotion_data.sign_in.is_sign == 0 then
        pSender:setState(1)
    elseif ex.Player.promotion_data.sign_in.is_sign == 1 then
        
        if  ex.Player.promotion_data.sign_in.charged > 0 then 
            pSender:setState(2)
        else 

            local content = ex.Tools:getLang(41067)
            ex.ConfirmCtr:openWindow(ex.Tools:getLang(41068), content, function()

                -- local params = {}
                -- params.cur_id = 102
                -- params.backToLayer =  function ( layer )
                --     local vec_idx = ex.Player.promotion_data:getPromotionByType(RechargeKindType.PROMOTION)
                --     layer:initWithTable(nil, vec_idx, 0)
                -- end
                
                -- ex.MainSceneCtr:changeToRechargePage(params)

                local params = {}
                params.cur_id = 102
                params.backToLayer =  function ( layer )
                    local vec_idx = ex.Player.promotion_data:getPromotionByType(RechargeKindType.PROMOTION)
                    layer:initWithTable(nil, vec_idx, 0)
                end

                ex.JumpManager:jumpByAtom("act_daily_gift", params)
            end)

            return 
        end 
        
    else 
        ex.MessageView:add(ex.Tools:getLang(41066)) 
        return
    end 

    pSender:removeChildByTag(20)

    -- ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HD_QD, false)

	-- 发送签到协议
    -- local req_signIn = SignIn_pb.GReqSignInAward()
    -- req_signIn.idx = pSender.idx
    NetManager:sendMessage(ProtocolID.GReqSignInAward)
end


return PROMDailyCheckLayer
