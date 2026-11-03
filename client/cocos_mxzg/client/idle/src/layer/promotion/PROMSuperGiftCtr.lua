--[[
    周向阳   超值赠礼
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-08-07 14:42:57
]]
local PROMSuperGiftCtr = class("PROMSuperGiftCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMSuperGiftLayer = class("PROMSuperGift", require("src.comp.EventLayerAdaptiveWidth"))

local LayerType = {}
    LayerType.first = 0
    LayerType.rmb100 = 1

local GiftType = {
    NotBuy = 1, -- 未购买
    CanGet = 2, -- 可领取
    Got = 3 -- 已领取
}

local Spine = {
    {"10505011", "10405005"},
    {"10105020", "10205021"},
    {"10305008", "10405005"},
    {"10505011", "10105020"},
    {"10405005", "10205021"},
    {"10505011", "10305008"}
}

function PROMSuperGiftLayer:onCreate()
    self:addBlackBackground()

    self.spr_bg:setScaleX(cc.Director:getInstance():getWinSize().width / self.spr_bg:getContentSize().width)

    self:addEvent(EVENT.SUPER_GIFT.UPDATA,handler(self,self.updata))

    self.layer_type = 0

    self.scroll_view_node = cc.Node:create()
    self:addChild(self.scroll_view_node)
 
    self.loop_next_idx = 0
    self.spine_node = cc.Node:create()
    self:addChild(self.spine_node)
    self.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self:addSpineAction()
    self:addTimer("timer", 3000, handler(self, self.addSpineAction), true)

    self.btn_gift_2:setLabelText(ex.Tools:getLang(91102))
    self.btn_gift_1:setLabelText(ex.Tools:getLang(91101))
end

function PROMSuperGiftLayer:updata()
    self:updataLayer(self.layer_type)
end
--添加骨骼动画
function PROMSuperGiftLayer:addSpineAction()
    self.spine_node:removeAllChildren()

    if self.loop_next_idx >= #Spine then
        self.loop_next_idx = 1
    else
        self.loop_next_idx = self.loop_next_idx + 1
    end

    local spine_date = Spine[self.loop_next_idx]
    for k, n in ipairs(spine_date) do
        --创建一个用来承载骨骼动画信息的节点
        self["spine" .. k] = cc.Node:create()
        --创建一个骨骼动画名字的背景
        self["spr_txt_" .. k .. "_bg"] = cc.Sprite:createWithSpriteFrameName("promotion/spr-txt-bg-9.png")
        --创建一个骨骼动画的名字
        self["spr_txt_" .. k] = cc.Label:createWithTTF(ex.Tools:getLang(tonumber((spine_date[k]))), FONT_DEFAULT_NAME_BOLD, 24)
        self["spr_txt_" .. k]:setDimensions(24,0)
        --创建一个骨骼动画
        self["spine_grass_" .. k] = sp.SkeletonAnimation:create("spine/" .. n .. ".json", "spine/" .. n .. ".atlas", 1)
        self["spine_grass_" .. k]:setAnimation(0, "stand", true)
        self["spine_grass_" .. k]:setPosition(0, 0)
        if k == 1 then
            self["spine" .. k]:setPosition(-100, 400)
            self["spr_txt_" .. k .. "_bg"]:setPosition(self["spine_grass_" .. k]:getPositionX() - 120, self["spine_grass_" .. k]:getPositionY() + 200)
        else
            self["spine" .. k]:setPosition(600, 400)
            self["spr_txt_" .. k .. "_bg"]:setPosition(self["spine_grass_" .. k]:getPositionX() + 100, self["spine_grass_" .. k]:getPositionY() + 200)
        end
        self["spr_txt_" .. k]:setPosition(self["spr_txt_" .. k .. "_bg"]:getPosition())
        self["spine" .. k]:setName("spine" .. k)
        self["spine" .. k]:addChild(self["spine_grass_" .. k], 10)
        self["spine" .. k]:addChild(self["spr_txt_" .. k .. "_bg"], 20)
        self["spine" .. k]:addChild(self["spr_txt_" .. k ], 40)

        self.spine_node:addChild(self["spine" .. k])
    end

    local action1 = cc.Sequence:create(cc.MoveTo:create(1, cc.p(200, 400))),
                    cc.CallFunc:create(function()self.spine_node:removeAllChildren()end)
    self.spine_node:getChildByName("spine1"):runAction(action1)

    local action2 = cc.Sequence:create(cc.MoveTo:create(1, cc.p(426, 400))),
                    cc.CallFunc:create(function()self.spine_node:removeAllChildren()end)
    self.spine_node:getChildByName("spine2"):runAction(action2)
end

function PROMSuperGiftLayer:closeWindow(tag, pSender)
    PROMSuperGiftCtr:instance():closeWindow()
end

function PROMSuperGiftLayer:updataLayer(cur_type)
    self.layer_type = cur_type

    ex.Tools:addRedPoint(self.btn_gift_1, ex.Player.promotion_data:hasSupreGiftAward(0), ex.r.p9)
    ex.Tools:addRedPoint(self.btn_gift_2, ex.Player.promotion_data:hasSupreGiftAward(1), ex.r.p9)

    self.recharge_lbl:setString(string.format(ex.Tools:getLang(91104),ex.Player.promotion_data:rechargeNum() / 100))

    local gift_type = GiftType.NotBuy
    if not ex.Player.promotion_data:isBuySupreGiftForType(cur_type) then
        gift_type = GiftType.NotBuy
    elseif ex.Player.promotion_data:hasSupreGiftAward(cur_type) then
        gift_type = GiftType.CanGet -- 领取奖励
    else
        gift_type = GiftType.Got -- 已领取
    end

    ex.Tools:setAllGrayAuto(self.btn_go:getNormalImage(), false)
    -- self.btn_go:setEnabled(gift_type ~= GiftType.Got)
    self.btn_go:setTag(gift_type)
    if gift_type == 1 then
        self.btn_go:setLabelText(ex.Tools:getLang(91108))
    elseif gift_type == 2 then  
        self.btn_go:setLabelText(ex.Tools:getLang(91110))
    else
        ex.Tools:setAllGrayAuto(self.btn_go:getNormalImage(), true)
        self.btn_go:setLabelText(ex.Tools:getLang(91110))   
        --每个档次的领取状态
        local type_list = ex.Player.promotion_data:typeList()
        if #type_list > 0 then
            for i,v in ipairs(type_list) do
                if  v.type == cur_type and v.status == 1 then
                    self.btn_go:setLabelText(ex.Tools:getLang(91111)) 
                end             
            end
        end
    end
   
    local item_size = cc.size(100, 100)
    local item_scale = 0.7
    local data = cfg.promotionrechargegift.promotionrechargergift

    self.scroll_view_node:removeAllChildren()
    local scroll_view = cpp.UIScrollViewZoom:create(cc.size(600, 120))  
    :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    :setIgnoreAnchorPointForPosition(false)
    :setAnchorPoint(0.5, 0.5)
    :setPosition(313, 180)
    :setContentSize(cc.size(600, 120))
    :setTouchEnabled(true)
    self.scroll_view_node:addChild(scroll_view)

    self.award_menu = cpp.UIMenu:create()
    self.award_menu:setName("menu")
    :setIsTouchInsideNode(scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    scroll_view:addChild(self.award_menu)
    for i, v in ipairs(data) do
        if v.type == cur_type then
            --道具位置的算法
            local lbl_bg = cc.Sprite:createWithSpriteFrameName("promotion/spr-txt-bg-10.png")
            lbl_bg:setPosition(cc.p(i * 114, 68))
            lbl_bg:setPosition((lbl_bg:getContentSize().width) * (i - 0.5) + i * 18, lbl_bg:getContentSize().height / 2)
            if v.type == 1 then
                scroll_view:setBounceable(false)
                lbl_bg:setPosition((lbl_bg:getContentSize().width) * (i - 3 - 0.5) + (i - 3) * 18, lbl_bg:getContentSize().height / 2)
            end
            scroll_view:addChild(lbl_bg, 110)

            local lbl = cc.Label:createWithTTF(string.format(ex.Tools:getLang(91103),v.need_day), FONT_DEFAULT_NAME_BOLD, 20)
            if v.idx == 3 then
                lbl = cc.Label:createWithTTF(string.format(ex.Tools:getLang(91105)), FONT_DEFAULT_NAME_BOLD, 20)
            end
            lbl:setPosition(lbl_bg:getPosition())
            scroll_view:addChild(lbl, 111)
            local spr_geted = cc.Sprite:createWithSpriteFrameName("promotion/spr-sign-2.png")
            spr_geted:setPosition(lbl_bg:getPositionX(),lbl_bg:getPositionY() + 60)
            spr_geted:setVisible(false)
            scroll_view:addChild(spr_geted, 130)
            --是否显示已领取
            local spr_geted_day = ex.Player.promotion_data:getSprGeted()
            for q,v in ipairs(spr_geted_day) do
                if v == i then
                    spr_geted:setVisible(true)
                end
            end
            --添加道具
            for j = 1, 2 do
                local btn = ex.Player.backpack_data:createWithData(data[i].reward[j].item_type, data[i].reward[j].item_num)
                btn:setPosition((item_size.width + 10) * item_scale * (j - 1.5) + lbl_bg:getPositionX(), 80)
                btn:setScale(0.7)
                btn:registerScriptTapHandler(handler(self, self.onBtnInfo))
                self.award_menu:addChild(btn, 100)
                scroll_view:setContentSize(cc.size(btn:getPositionX() + 50, 120))
            end
        end
    end  
end

function PROMSuperGiftLayer:onBtnInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end
---------------------------------------------------------------------------------

function PROMSuperGiftCtr:onCreate()
    self:setCCBIPath("ccbi/PROMSuperGift.ccbi")
    self:setIsSingle(false)
end

function PROMSuperGiftCtr:getLayerClass()
    return PROMSuperGiftLayer
end

function PROMSuperGiftCtr:openWindow(layer_type)
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initDone()
end

function PROMSuperGiftCtr:initDone()
    self.layer.btn_gift_1:setTag(LayerType.first)
    self.layer.btn_gift_2:setTag(LayerType.rmb100)

    self.layer.btn_gift_1:setChecked(true)
    self.layer.btn_go:setTag(GiftType.NotBuy)

    self.layer.btn_gift_1:registerScriptTapHandler(handler(self, self.btnGift))
    self.layer.btn_gift_2:registerScriptTapHandler(handler(self, self.btnGift))
    self.layer.btn_go:registerScriptTapHandler(handler(self, self.onBtnGo))

    self:changerLayer(LayerType.first)
end

function PROMSuperGiftCtr:changerLayer(cur_type)
    self.cur_layer_type = cur_type
    self.layer:updataLayer(cur_type)
end

function PROMSuperGiftCtr:btnGift(tag, pSender)
    self.layer.spr_logo_1:setVisible(tag == 0)
    self.layer.spr_logo_2:setVisible(tag == 1)
    self.cur_layer_type = tag
    self:changerLayer(self.cur_layer_type)
end

function PROMSuperGiftCtr:onBtnGo(tag, pSender)
    if tag == 1 then
        -- 转跳每日礼包
        ex.JumpManager:jumpByAtom("act_recharge_smart")
        self:closeWindow()
    elseif tag == 2 then
        -- 获取超值奖励协议
        local req = promotion069_pb.GReqGetRechargeGiftReward()
        req.type = self.cur_layer_type
        NetManager:sendMessage(ProtocolID.GReqGetRechargeGiftReward, req)
    else  
        --飘字提示
        local type_list = ex.Player.promotion_data:typeList()
        if #type_list > 0 then
            for i,v in ipairs(type_list) do
                if  v.type == self.cur_layer_type and v.status == 1 then
                    ex.MessageView:add(ex.Tools:getLang(91106))
                    return
                end             
            end     
        end
        ex.MessageView:add(ex.Tools:getLang(91107))
    end
end

return PROMSuperGiftCtr
