--[[
* @Description: 圣诞活动-圣诞奇幻夜
* @Author: 熊梦
* @Date: 2020-12-11 17:28:00
* ]]
local PROMChristmasFantasyNightLayer = class("PROMChristmasFantasyNightLayer", require("src.layer.promotion.PromotionBaseLayer"))
local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")


------------------------------------ PROMChristmasFantasyNightLayer ------------------------------------
function PROMChristmasFantasyNightLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:initEventListen()
    self:addPlist()
end

function PROMChristmasFantasyNightLayer:onCreateDone()
    self:initView()
end

function PROMChristmasFantasyNightLayer:addPlist()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/prom-christmas.plist")
end

function PROMChristmasFantasyNightLayer:initEventListen()
   -- self:addEvent(EVENT.BLACKFRIDAY.EVENT_BUY_GOODS, handler(self, self.updateLayer))
end

function PROMChristmasFantasyNightLayer:initView()
    self.spr_bg:setPositionY(self.layer_promotion:getTopY())
    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    self.spr_bg:setScaleY(self.spr_bg:getPositionY() / (self.spr_bg:getContentSize().height))
    self.spr_bg_text:setPositionY(self.layer_promotion:getTopY()-170) 
    self.spr_guang:setPositionY(self.layer_promotion:getTopY()-250) 


    self:addRedDotNode(RedDotType.ZCJ_DHZC_SDJHD_SDQHY_SDLX, self.btn_1)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_SDJHD_SDQHY_HFSD, self.btn_3)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_SDJHD_SDQHY_SDLH, self.btn_4)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_SDJHD_SDQHY_JXMH, self.btn_5)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_SDJHD_SDQHY_LDJZ, self.btn_6)

    local time_table = 
    {
        ex.Player.promotion_data:getPromotion85Data(),
        ex.Player.promotion_data:getPromotion86Data(),
        ex.Player.promotion_data:getPromotion87Data(),
        ex.Player.promotion_data:getPromotion88Data(),
        ex.Player.promotion_data:getPromotion91Data(),
        ex.Player.promotion_data:getPromotion97Data()
    }
    local node_table = {}

    for i=1,6 do
        local data = time_table[i]
        if data ~= nil then
            table.insert( node_table,i, data )
        else
            self["node_"..i]:setVisible(false)
            self["spr_start_tag_"..i]:setVisible(false)
            self["lbl_prom_time_"..i]:setVisible(false)
        end
    end
    local num = 0
    for k,v in pairs(node_table) do     
        local data = v
        num = num + 1
        if data ~= nil then
            local start_m = os.date("%m",data.start_time)
            local start_d = os.date("%d",data.start_time)
            local end_m = os.date("%m",data.end_time)
            local end_d = os.date("%d",data.end_time)
        
            local cur_time = ex.Game:getServerTime()
            if cur_time > data.end_time then
                self["node_"..k]:setVisible(false)
                self["spr_start_tag_"..k]:setVisible(false)
            else
                self["spr_start_tag_"..k]:setVisible(true)
            end
            self["lbl_prom_time_"..k]:setVisible(true)
            self["lbl_prom_time_"..k]:setString(string.format(ex.Tools:getLang(6105),start_m,start_d,end_m,end_d))
            self["node_"..k]:setPosition(self["pos_"..num]:getPosition())
            self["spr_coming_soon_"..num]:setVisible(false)
        end
    end

end

-- 跳转
function PROMChristmasFantasyNightLayer:onJump(tag,pSender)
    if tag == nil then return end

    local event_arg = 
    {
        "act_christmas_connection", -- 圣诞连线
        "act_christmas_discount", -- 约惠圣诞
        "act_christmas_happy", -- 嗨翻圣诞
        "act_christmas_giftbox", -- 圣诞礼盒
        "act_christmas_surprise_blind_box", -- 惊喜盲盒
        "act_five_one_draw", --五一抽奖
    }
    ex.JumpManager:jumpByAtom(event_arg[tag])

end


return PROMChristmasFantasyNightLayer
