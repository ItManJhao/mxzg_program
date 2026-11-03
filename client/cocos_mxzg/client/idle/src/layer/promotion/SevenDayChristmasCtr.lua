

local SevenDayChristmasCtr = class("SevenDayChristmasCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SevenDayChristmasLayer = class("SevenDayChristmasLayer", require("src.comp.EventLayer"))
local DAY = {
    [1] = ex.Tools:getLang(47579),
    [2] = ex.Tools:getLang(47130),
    [3] = ex.Tools:getLang(47287),
    [4] = ex.Tools:getLang(47283),
    [5] = ex.Tools:getLang(47178),
    [6] = ex.Tools:getLang(47163),
    [7] = ex.Tools:getLang(47262),
}

local TARGET_ITEM = require("src.comp.menu.UIMenuItemSevenDayItem")

function SevenDayChristmasLayer:onCreate()

    self.cur_tag = ex.Player.promotion_data.save_festivanew_data.now_day
    self.cur_day = ex.Player.promotion_data.save_festivanew_data.now_day

    self.reward_ctr = require("src.layer.ItemRewardCtr"):instance()
    self:addBlackBackground()
    self.spr_bg:setVisible(false)

    local win_size = cc.Director:getInstance():getWinSize()
    local scaleX = win_size.width / self.spr_bg:getContentSize().width
    local scaleY = win_size.height / self.spr_bg:getContentSize().height

    local posX = self.btn_close:getPositionX() * ((scaleX - 1) / 2 + 1)
    local posY = self.btn_close:getPositionY() * ((scaleY - 1) / 2 + 1)
    self.btn_close:setPosition(posX,posY)
    self.btn_close:registerScriptTapHandler(handler(SevenDayChristmasCtr,SevenDayChristmasCtr.closeWindow))
    self.btn_get:registerScriptTapHandler(handler(self,self.onclickGet))

    self:createMenuItem()

    self:createItems()
    self:addEvent(EVENT.SEVEN_FESTIVANEW_DATA_EVENT.REWARD_RESULT,handler(self,self.onReward))
    self:addEvent(EVENT.SEVEN_FESTIVANEW_DATA_EVENT.UPDATE_SEVEN_DAY_DATA,handler(self,self.changeDay))

    local status = ex.Player.promotion_data:checkFestivalLoginDayISGain(self.cur_day)
    self.btn_get:setEnabled(self.cur_day >= self.cur_tag and status == 0)

    self:onOrderReward()
    -- self:addChild(item)
    -- item:setPosition(100,400)
end

function SevenDayChristmasLayer:changeDay(event,data)
    self.cur_day = ex.Player.promotion_data.save_festivanew_data.now_day

end

function SevenDayChristmasLayer:onOrderReward()

    for k,v in pairs(self.items) do
        local day = v:getTag()
        v.node_geted:setVisible(ex.Player.promotion_data:checkFestivalLoginDayISGain(day) == 1)
    end
end


function SevenDayChristmasLayer:onReward(event,data)

    self.btn_get:setEnabled(false)
    for k,v in pairs(self.items) do
        local day = v:getTag()
        v.node_geted:setVisible(ex.Player.promotion_data:checkFestivalLoginDayISGain(day) == 1)
    end
end

function SevenDayChristmasLayer:onclickGet(tag , pSender)
    ex.AudioManager:playEffect("music/item-get.mp3")
    
    ex.Player.promotion_data:gReqFestivalLoginReward(self.cur_tag)


end

function SevenDayChristmasLayer:createItems()


    local config = ex.Player.promotion_data.save_festivanew_data.list[self.cur_tag]
    self.lbl_day:setString(string.format(ex.Tools:getLang(47721),DAY[config.day]))

    local margin = 15
    local width = 586 * 0.5--cc.Director:getInstance():getWinSize().width / 2
    local size = TARGET_ITEM:createWithData():getContentSize()
    local beginX = width - (#config.item * (size.width + margin) - margin) / 2 


    self.reward_items = {}
    for i=1,#config.item do
        self.reward_items[i] = TARGET_ITEM:createWithData(config.item[i])
        self.menu_reward:addChild(self.reward_items[i])

        local posX = beginX + (i - 1) * (size.width + margin) + size.width / 2
        self.reward_items[i]:setPosition(posX , 67)

    end
end

function SevenDayChristmasLayer:createMenuItem()

    local beginX = -270
    local beginY = -165
    local margin = 10
    self.items = {}
    local config = ex.Player.promotion_data.save_festivanew_data.list
    for i=1,#config do

        local item = require("src.layer.SevenDayCell"):createWithCCBIFile("ccbi/SevenDayCell.ccbi")
        item:reset(config[i])
        self.menu_day:addChild(item)
        local size = item:getContentSize()
        local idx = i < 4 and i or i - 3
        local stardX = i < 4 and beginX + (size.width + margin) / 2 or beginX
        local posX = stardX + (size.width + margin) * (idx - 1)
        local posY = i > 3 and beginY or beginY + size.height + margin
        item:setPosition(posX,posY)
        item:setTag(config[i].day)
        item.item:setTag(config[i].day)
        item:setSelected(config[i].day == self.cur_tag)
        item.item:registerScriptTapHandler(handler(self,self.onClickItem))
        item.node_geted:setVisible( config.is_gain == 1 )
        self.items[i] = item
    end
end

function SevenDayChristmasLayer:onClickItem(tag , pSender)
    if tag == self.cur_tag then return end
    self.cur_tag = tag  
    -- print(self.__cname ,tag)

    for k,v in pairs(self.items) do
        v:setSelected(k == tag)
    end

    local config = ex.Player.promotion_data.save_festivanew_data.list[self.cur_tag]
    self.lbl_day:setString(string.format(ex.Tools:getLang(47721),DAY[config.day]))
    for k,v in pairs(config.item) do
        self.reward_items[k]:reset(v)
    end
    --local status = ex.Player.seven_login_data:getSevenDayLoginStatus(self.cur_tag)
    local status = ex.Player.promotion_data.save_festivanew_data.list[self.cur_tag].is_gain
    self.btn_get:setEnabled(self.cur_day >= self.cur_tag and status == 0)
end






----------------------------------------------------------------
function SevenDayChristmasCtr:onCreate()
    self:setCCBIPath("ccbi/SevenDayChristmasLayer.ccbi")
    self:setIsSingle(false)
end

function SevenDayChristmasCtr:getLayerClass()
    return SevenDayChristmasLayer
end

function SevenDayChristmasCtr:getConfirmLayer()
    return self.layer
end

function SevenDayChristmasCtr:openWindow(title, content, callback_confirm)
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData(title, content, callback_confirm)
end

function SevenDayChristmasCtr:initData(title, content, callback_confirm)
    local layer = self.layer
    local cur_day = ex.Player.promotion_data.save_festivanew_data.now_day
    local status = ex.Player.promotion_data:checkFestivalLoginDayISGain(cur_day)

    layer.btn_close:registerScriptTapHandler(handler(self,self.closeWindow))
end

function SevenDayChristmasCtr:onConfirm(tag, pSender)
    if self:getLayer() == nil then
        return
    end

    self:closeWindow(tag, pSender)
end

function SevenDayChristmasCtr:onCancel(tag, pSender)
    self:closeWindow(tag, pSender)
end



return SevenDayChristmasCtr