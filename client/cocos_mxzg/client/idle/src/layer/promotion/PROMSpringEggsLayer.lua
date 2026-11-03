--[[
* @Description: 春日活动-活动二：制作彩蛋
* @Author: 熊梦
* @Date: 2021-3-23 17:28:00
* ]]
local PROMSpringEggsLayer = class("PROMSpringEggsLayer", require("src.layer.promotion.PromotionBaseLayer"))
local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")


------------------------------------ PROMSpringEggsLayer ------------------------------------
function PROMSpringEggsLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:initEventListen()
    self:addPlist()
end

function PROMSpringEggsLayer:onCreateDone()
    self:initView()
end

function PROMSpringEggsLayer:initEventListen()
   self:addEvent(EVENT.SPRING.GIFTBOX_UPDATA, handler(self, self.updateLayer))
end

function PROMSpringEggsLayer:initView()

    self.spr_bg:setPositionY(self.layer_promotion:getTopY())
    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    self.spr_bg:setScaleY(self.spr_bg:getPositionY() / (self.spr_bg:getContentSize().height))
    
    self.node_info:setPositionX(ex.p.width)

    local spr_fdj = cc.Sprite:createWithSpriteFrameName(string.format("prom-spring-outing/spr-fdj.png"))
    spr_fdj:setPosition(self.btn_show_reward:getPositionX() + 35, self.btn_show_reward:getContentSize().height / 2)
    self.btn_show_reward:addChild(spr_fdj)
    local show_reward_lbl = self.btn_show_reward:getLabel()
    show_reward_lbl:setAnchorPoint(0,0.5)
    show_reward_lbl:setPositionX(spr_fdj:getPositionX() + 20)


    -- local label_lbl = self.btn_supplement:getLabel()
    -- ex.Tools:setLimitWidth(label_lbl, 100)
    -- ex.Tools:setLimitWidth(self.lbl_score_1, 100)
    self.scroll_view:setItemSize(cc.size(140, 180))
    self.scroll_view:setItemType(1)
    self.scroll_view:setAlignmentCenter(true)

    ex.Tools:setLabelOffset(self.lbl_time_tip, self.lbl_time)
    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
    self:updateTimer()

    self:addRedDotNode(RedDotType.ZCJ_DHZC_CRHD_ZZCD_BZ, self.btn_buy)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_CRHD_ZZCD_DJ, self.btn_box)
    
    self:createProgress()
    self:updateLayer()
end

function PROMSpringEggsLayer:addPlist()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/prom-spring-outing.plist")
end

function PROMSpringEggsLayer:updateLayer()

    local cost_item = {}
    for i,v in ipairs(cfg.promotion094score.promotion094score[1].cost_item) do
        table.insert(cost_item,v)
    end

    self.scroll_view.createItemFunction = function(data, scale)
        local menu = cpp.UIMenu:create()
        local item = UIMenuItemBag:createWithData(data.item_type,0)
        item:registerScriptTapHandler(handler(self,self.onClickItem))
        menu:addChild(item)

        local item_name_lang = cfg.item.item[data.item_type].name 
        -- 道具名字
        local lbl_item_name = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 20)
        lbl_item_name:setAnchorPoint(0.5, 0.5)
        lbl_item_name:setPosition(50,-15)
        lbl_item_name:setColor(cc.c3b(255,245,174))
        lbl_item_name:setString(ex.Tools:getLang(item_name_lang))
        lbl_item_name:enableOutline(ex.c3b.BLACK, 2)
        item:addChild(lbl_item_name, 10)
        ex.Tools:setLimitWidth(lbl_item_name, 90)

        -- 道具数量
        local has_num = ex.Player:getItemNum(data.item_type)
        local lbl_item_num = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 20)
        lbl_item_num:setAnchorPoint(1, 0.5)
        lbl_item_num:setPosition(95,15)
        lbl_item_num:enableOutline(cc.c3b(55,35,26), 2)
        lbl_item_num:setString(has_num.."/"..data.item_num)
        item:addChild(lbl_item_num, 10)
        if has_num >= data.item_num then
            lbl_item_num:setColor(cc.c3b(147,249,56))
        else
            lbl_item_num:setColor(cc.c3b(255,48,0))
        end


        return menu
    end
    
    self.scroll_view:reloadData(cost_item)

    local max_num = cfg.promotion094score.promotion094score[1].cost_score
    local num =  ex.Player.promotion_data.promotion94_score
    local percent = num / max_num * 100
    if percent > 100 then percent = 100 end
    self.progressTimer:setPercentage(percent)

    self.lbl_progress_num:setString(num.."/"..max_num)

    ex.Player.promotion_data:checkPromotion94RedDot()
end


function PROMSpringEggsLayer:createProgress()
    self.progressTimer = require("src.comp.UIProgressTimerEquidistant"):create(cc.Sprite:createWithSpriteFrameName("prom-spring-outing/jdt2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setScaleX(1)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_progress_bg:addChild(self.progressTimer)
    self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2 )
end

function PROMSpringEggsLayer:onClickItem(tag,pSender)
    ex.Tools:showItemInfo(tag,pSender)
end

function PROMSpringEggsLayer:updateTimer()
    local is_open = cfg.funcopen["act_spring"].isVisible()
    if is_open ~= true then
        if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
    end

    local data = ex.Player.promotion_data:getPromotion94Data()
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

function PROMSpringEggsLayer:getPromotion94BoxRewardStatus()
    local isVisible = false
    local max_num = cfg.promotion094score.promotion094score[1].cost_score
    local num =  ex.Player.promotion_data.promotion94_score
    if num >= max_num then
        isVisible = true
    end
    return isVisible
end

--------------------------------------------------------------------------------
function PROMSpringEggsLayer:onBuy(tag, pSender)
    local isbool = true
    for i,v in ipairs(cfg.promotion094score.promotion094score[1].cost_item) do
        local has_num = ex.Player:getItemNum(v.item_type)
        local max_num = v.item_num
        if has_num < max_num then
            isbool = false
            break
        end
    end
 
    if isbool then
        local proto = Promotion094_pb.GReqMakeEggExchangeScore()
        NetManager:sendMessage(ProtocolID.GReqMakeEggExchangeScore, proto)
    else
        ex.MessageView:add(ex.Tools:getLang(30503))
    end
end

function PROMSpringEggsLayer:onSupplement(tag, pSender)
    cfg.funcopen.main_shop.open(SHOP_TYPE.SPRING)
end

function PROMSpringEggsLayer:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(6515), ex.Tools:getLang(6516))
end

function PROMSpringEggsLayer:onRewardPreview(tag, pSender)
    local table_data={}
    local max_weight = 0
    for k,v in ipairs(cfg.promotion094randomreward.promotion094randomreward) do
        local table_data_temp = {}
        table_data_temp.cost = v.reward
        table_data_temp.weight = v.weight
        table_data_temp.idx = v.idx
        table.insert(table_data,table_data_temp)
        max_weight = max_weight + v.weight
	end
    require("src.layer.PROMChristmasHappyPreviewCtr"):instance():openWindow(table_data,max_weight)
end


function PROMSpringEggsLayer:onClickBox(tag, pSender)
    local can_get = self:getPromotion94BoxRewardStatus()
    if can_get then
        local req = Promotion094_pb.GReqMakeEggBox()
        NetManager:sendMessage(ProtocolID.GReqMakeEggBox, req)
    else
        local function callback()
            local req = Promotion094_pb.GReqMakeEggBox()
            NetManager:sendMessage(ProtocolID.GReqMakeEggBox, req)
        end
        local table_data =  cfg.promotion094score.promotion094score[1].reward
        require("src.layer.PROMChristmasGiftBoxRewardInfoCtr"):instance():openWindow(table_data, can_get, callback)
    end
end


return PROMSpringEggsLayer
