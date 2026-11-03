-- 功能预告的每日奖励弹框
local PROM66DailyAwardCtr = class("PROM66DailyAwardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROM66DailyAwardLayer = class("PROM66DailyAwardLayer", require("src.comp.EventLayer"))

function PROM66DailyAwardLayer:onCreate()
    self:addBlackBackground()
end

function PROM66DailyAwardLayer:showLayerData(reward, receive_time)
	if not reward or #reward == 0 then
		self.btn_award:setEnabled(false)
		return;
	end

	local isAwarded = false;
	if type(receive_time) == "number" then
		local isSameDay = Maths.isSameDay(cpp.Game:instance():getServerTime(), receive_time)

		if isSameDay then
			-- 已领取按钮变灰
			isAwarded = true;
			self.btn_award:setEnabled(false)
		else 
			self.btn_award:setEnabled(true)
        end
	end

	local width = 542
	local itemWidth = 100
	local offsetX = 50
	local startX = width / 2 - ((itemWidth + offsetX) * (#reward - 1) + itemWidth) / 2 + itemWidth / 2
	for i = 1, #reward do
		local itemData = reward[i]
		local x = startX + (i - 1) * (itemWidth + offsetX)
		local item = ex.Tools:createBackpackItem(itemData.item_type, itemData.item_num)
		local scale = 100 / item:getContentSize().width;
		item:setScale(scale)
		item:setPosition(x , 165)
		item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
		self:addChild(item)

		-- 已领取按钮变灰，加已领取标签
		if isAwarded then
			local spr_geted = cc.Sprite:createWithSpriteFrameName("other/spr-geted.png")
			spr_geted:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
			spr_geted:setLocalZOrder(999)
			item:addChild(spr_geted)
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------

function PROM66DailyAwardCtr:onCreate()
    self:setCCBIPath("ccbi/PROM66DailyAwardLayer.ccbi")
	self:setIsSingle(false)
end

function PROM66DailyAwardCtr:getLayerClass()
	return PROM66DailyAwardLayer
end

function PROM66DailyAwardCtr:openWindow()
    if self:isOpened() then
        return
	end

	local receive_time = ex.Player.promotion_data.promotion66_receive_time;
	local config = ex.Player.promotion_data.promotion66_config;
	local reward;
    if config and #config > 0 then
        local aConfig = config[1]
        if not aConfig or not aConfig.reward then
            return
		end
		reward = aConfig.reward
    end

    self:loadLayer()
    self:open()
    self:initData(reward, receive_time)    
end 


function PROM66DailyAwardCtr:btnClose(tag, pSender)
    if self.closeCallback then 
        self.closeCallback()
    end 
    self:closeWindow()
end

function PROM66DailyAwardCtr:initData(reward, receive_time)
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.onBtnClose))
	self.layer.btn_award:registerScriptTapHandler(handler(self, self.onBtnAward))
    self.layer:showLayerData(reward, receive_time)
end

function PROM66DailyAwardCtr:onBtnClose()
    self:closeWindow(nil, self.layer)
end

-- 点击领取
function PROM66DailyAwardCtr:onBtnAward()
	NetManager:sendMessage(ProtocolID.GReqGetEveryDayReward)
	self:closeWindow(nil, self.layer)
end

return PROM66DailyAwardCtr