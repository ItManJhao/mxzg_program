local SevenDayGiftCtr = class("SevenDayGiftCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SevenDayGiftLayer = class("SevenDayGiftLayer", require("src.comp.EventLayerAdaptiveWidth"))

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

function SevenDayGiftLayer:onCreate()
    self:resetScaleAtWidth(true, 20)

    self.cur_tag = ex.Player.seven_login_data:getLoginCurDay()
    self.cur_day = ex.Player.seven_login_data:getLoginCurDay()
    self.reward_ctr = require("src.layer.ItemRewardCtr"):instance()
    self:addBlackBackground()
    self.spr_bg:setVisible(false)

    local win_size = cc.Director:getInstance():getWinSize()
    local scaleX = win_size.width / self.spr_bg:getContentSize().width
    local scaleY = win_size.height / self.spr_bg:getContentSize().height

    local posX = self.btn_close:getPositionX() * ((scaleX - 1) / 2 + 1)
    local posY = self.btn_close:getPositionY() * ((scaleY - 1) / 2 + 1)
    self.btn_close:setPosition(posX,posY)
    self.btn_close:registerScriptTapHandler(handler(SevenDayGiftCtr,SevenDayGiftCtr.closeWindow))
    self.btn_get:registerScriptTapHandler(handler(self,self.onclickGet))

    self:createMenuItem()

    self:createItems()
    self:addEvent(EVENT.SEVEN_TARGET_DATA_EVENT.SEVENT_DAY_REWARD_RESULE,handler(self,self.onReward))
    self:addEvent(EVENT.SEVEN_TARGET_DATA_EVENT.UPDATE_SEVEN_DAY_CHANGE,handler(self,self.changeDay))

    local status = ex.Player.seven_login_data:getSevenDayLoginStatus(self.cur_day)

    self.btn_get:setEnabled(self.cur_day >= self.cur_tag and status == 0)

end

function SevenDayGiftLayer:changeDay(event,data)
    self.cur_day = ex.Player.seven_login_data.login_cur_day
end

function SevenDayGiftLayer:onReward(event,data)
    -- self.reward_ctr:openWindow(data)
    self.btn_get:setEnabled(false)
    for k,v in pairs(self.items) do
        local day = v:getTag()
        if ex.Player.seven_login_data:getSevenDayLoginStatus(day) == 1 then
            v:setGray()
        end
        -- v.node_geted:setVisible()
    end
end

function SevenDayGiftLayer:onclickGet(tag , pSender)
    -- print(self.__cname,tag,self.cur_tag,"get~~~")
    ex.AudioManager:playEffect("music/item-get.mp3")
    
    -- local req_reward = cpp.ByteArray:create()
    -- req_reward:writeInt(ProtocolID.GReqSevenDayLoginReward)
    -- req_reward:writeInt(self.cur_tag)
    -- cpp.NetManager:instance():sendByteArray(req_reward)
    -- ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
    
	local req_reward = SevenDayLogin_pb.GReqSevenDayLoginReward()
    req_reward.day = self.cur_tag
	NetManager:sendMessage(ProtocolID.GReqSevenDayLoginReward,req_reward)
end

function SevenDayGiftLayer:createItems()

    local config = cfg.promotionnew7daylogin.login[self.cur_tag]
    self.lbl_day:setString(string.format(ex.Tools:getLang(47721),DAY[config.day]))

    local margin = 15
    local width = 586 * 0.5--cc.Director:getInstance():getWinSize().width / 2
    local size = TARGET_ITEM:createWithData():getContentSize()
    local beginX = width - (#config.item * (size.width + margin) - margin) / 2 

    self.menu_reward:removeAllChildren()

    self.reward_items = {}
    for i=1,4 do
        self.reward_items[i] = ex.Tools:createBackpackItem(config.item[i].item_type, config.item[i].item_num)
        self.menu_reward:addChild(self.reward_items[i])

        local posX = beginX + (i - 1) * (size.width + margin) + size.width / 2
        self.reward_items[i]:setPosition(posX , 67)
        self.reward_items[i]:registerScriptTapHandler(handler(self, self.onBtnInfo))
    end
end

function SevenDayGiftLayer:onBtnInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function SevenDayGiftLayer:createMenuItem()
    local config = cfg.promotionnew7daylogin.login
    local beginX = -270
    local beginY = -165
    local margin = 10
    self.items = {}

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

        if ex.Player.seven_login_data:getSevenDayLoginStatus(config[i].day) == 1 then
            item:setGray()
        end
        self.items[i] = item
    end
end

function SevenDayGiftLayer:onClickItem(tag , pSender)
    if tag == self.cur_tag then return end
    self.cur_tag = tag  
    -- print(self.__cname ,tag)

    for k,v in pairs(self.items) do
        v:setSelected(k == tag)
    end

    local config = cfg.promotionnew7daylogin.login[self.cur_tag]
    self.lbl_day:setString(string.format(ex.Tools:getLang(47721),DAY[config.day]))
    
    self:createItems()
    local status = ex.Player.seven_login_data:getSevenDayLoginStatus(self.cur_tag)

    self.btn_get:setEnabled(self.cur_day >= self.cur_tag and status == 0)

end

----------------------------------------------------------------
function SevenDayGiftCtr:onCreate()
    self:setCCBIPath("ccbi/SevenDayGiftLayer.ccbi")
    self:setIsSingle(false)
end

function SevenDayGiftCtr:getLayerClass()
    return SevenDayGiftLayer
end

function SevenDayGiftCtr:getConfirmLayer()
    return self.layer
end

function SevenDayGiftCtr:openWindow(title, content, callback_confirm)
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData(title, content, callback_confirm)
end

function SevenDayGiftCtr:initData(title, content, callback_confirm)
    local layer = self.layer
    local cur_day = ex.Player.seven_login_data.login_cur_day
    local status = ex.Player.seven_login_data:getSevenDayLoginStatus(cur_day)

    layer.btn_close:registerScriptTapHandler(handler(self,self.closeWindow))
end

function SevenDayGiftCtr:onConfirm(tag, pSender)
    if self:getLayer() == nil then
        return
    end

    self:closeWindow(tag, pSender)
end

function SevenDayGiftCtr:onCancel(tag, pSender)
    self:closeWindow(tag, pSender)
end


return SevenDayGiftCtr
