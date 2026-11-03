local GrowUpGiftBanner = class("GrowUpGiftBanner", require("src.comp.EventLayer"))

function GrowUpGiftBanner:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)


	self.item_menu = cpp.UIMenu:create()
	self.item_node:addChild(self.item_menu)
	-- local x,y = self.item_node:getPosition()
	-- self.item_menu:setPosition(x,y)
	self.item_menu:setPosition(0,0)
	-- self:addFont()
	self.btn_get:registerScriptTapHandler(handler(self, self.onClickGet))
	self:addFont()
end

function GrowUpGiftBanner:addFont()
	local str = ""

	if ex.Player.promotion_data:hasSuperCard() == false then 
		str = ex.Tools:getLang(47464)
	else
		if ex.Player.promotion_data:isRewardSuperCard() then 
			str = ex.Tools:getLang(47677)
		else
			str = ex.Tools:getLang(47444)
		end
	end
	if not self.lbl_get then 
		self.lbl_get = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 20)
		self.lbl_get:setTextColor(cc.c3b(66, 21, 14))
		self.btn_get:addChild(self.lbl_get)
		-- self.lbl_get:enableOutline(FONT_BROWN, 1)
		self.lbl_get:setPosition(self.btn_get:getContentSize().width/2,self.btn_get:getContentSize().height/2)
	end
	self.lbl_get:setString(str)
end

function GrowUpGiftBanner:onClickGet(tag,pSender)

    if ex.Player.promotion_data:hasSuperCard() == false then
        local function callback()
        	cfg.funcopen.act_month_card.open()
        end
        local content = ex.Tools:getLang(47189)
        local confirm_str = ex.Tools:getLang(47083)
        require("src.layer.ConfirmCtr"):instance():openWindow("",content,callback,confirm_str)

    elseif ex.Player.promotion_data:isRewardSuperCard() then
        -- self.btn_monthly:setLabelText(ex.Tools:getLang(47677))
        -- self.btn_monthly:setEnabled(false)
        ex.MessageView:add(ex.Tools:getLang(47603))
    else
        -- 至尊月卡奖励
		NetManager:sendMessage(ProtocolID.GReqMonthVipReward)
    end

	
end

function GrowUpGiftBanner:reset(data)
	-- if not data or data == "" then return end
	self.data = data

	self.item_menu:removeAllChildren()

	local day_item = data.gift_every_day

	if day_item == "" then return end

	local size = ex.Tools:createBackpackItem(day_item[1].item_type, day_item[1].item_num):getContentSize()
	local margin = 10
	local scale = 0.6
	for i,v in ipairs(day_item) do
		local dt = v
		local item = ex.Tools:createBackpackItem(dt.item_type, dt.item_num)
		item:setScale(scale)
		local posX = (i - 1) * size.width * scale + (i - 1) * margin
		self.item_menu:addChild(item)
		item:setPosition(posX,0)
		item:registerScriptTapHandler(handler(self, self.onClickItem))
		-- print(self.__cname,item:getPosition())
	end
	local red = ex.Player.promotion_data:hasSuperCard() and not ex.Player.promotion_data:isRewardSuperCard()
	ex.Tools:addRedPoint(self.btn_get,red)
	self:addFont()

end

function GrowUpGiftBanner:onClickItem(tag,pSender)
	ex.Tools:showItemInfo(tag, pSender)
end

return GrowUpGiftBanner
