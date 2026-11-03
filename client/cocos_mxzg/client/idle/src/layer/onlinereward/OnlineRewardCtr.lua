local OnlineRewardCtr = class("OnlineRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local OnlineRewardLayer = class("OnlineRewardLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function OnlineRewardLayer:onCreate()
	-- self.lbl_time
	-- self.scroll_view
	self.lbl_time_tips:enableOutline(cc.c3b(137,17,17),2)
	self.lbl_time:enableOutline(cc.c3b(8,88,95),2)
	self.btn_go:registerScriptTapHandler(handler(self,self.onGo))
	self.can_id = ex.Player.onlineReward_data:getCanGetId()
	self.has_month_card = ex.Player.onlineReward_data:getHasMonthCard()
	self:addBlackBackground()
	self.viewSize = cc.size(540,350)
	self.item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
    self.item_size = cc.size(self.item_size.width + 15, self.item_size.height + 12)
	self:setAutoClose(true)
	self:changeTime()
	self:addTimer("time",1000,handler(self,self.changeTime),true)
	self.data = {}
	for k,v in pairs(cfg.promotiononlinereward.online) do
		table.insert(self.data,v)
	end
	local function sor(a,b)
		-- if a.time ~= b.time then return a.time < b.time end
		return a.idx < b.idx
	end
	table.sort(self.data,sor)
	self:updateScrollView()
	self:addBlackBackground()
	self:addEvent(EVENT.ONLINE_REWARD.GET_REWARD_RESULT,handler(self,self.onResult))
	self:addEvent(EVENT.ONLINE_REWARD.CLOSE,handler(self,self.onClose))
	self:addEvent(EVENT.ONLINE_REWARD.UPDATE_STATUS,handler(self,self.updateStatus))
	self:addEvent(EVENT.ONLINE_REWARD.UPDATE_MONTH_CARD_STATUS,handler(self,self.updateStatus))
end

function OnlineRewardLayer:onMonthCardStatus(event,data)
	local items = self.menu:getChildren()

	local can_id = ex.Player.onlineReward_data:getCanGetId()
	for k,v in pairs(items) do
		local idx = v:getTag()
		local status = ex.Player.onlineReward_data:getStatus(idx)
		local can_again = cfg.promotiononlinereward.online[idx].once_again == 1
		local gray = status == 1
		local not_again = true
		if status == 1 and can_again then  
			if self.has_month_card == true then 
				not_again = ex.Player.onlineReward_data:getGainStatus(idx) 
				gray = not_again
			else
				gray = false
			end
			if v.getableSprite then
				v.getableSprite:removeFromParent()
				v.getableSprite = nil
			end
		end

		ex.Tools:setSpriteFrame(v.spr_geted, gray and "other/spr-geted.png" or "other/spr-sign-3.png")
		v.spr_geted:setVisible(status == 1)

		v:setAllGray(gray)
		v:setEnabled(not gray)

		if v.spr_effect then
			v.spr_effect:setVisible(idx <= can_id and (status ~= 1 or (status == 1 and not not_again)))
		end
		
		if gray and v.spr_effect ~= nil then
			print("remove effect")
			v.spr_effect:removeFromParent()
			v.spr_effect = nil
			if v.getableSprite then
				v.getableSprite:removeFromParent()
				v.getableSprite = nil
			end
		end
	end
end

function OnlineRewardLayer:onGo(tag,pSender)
	local levelCond = cfg.opencondition.condition['act_month_card_normal'].condition_value

	-- 数据统计
	local req = Click_pb.GResClick()
	req.click_code = 101
	NetManager:sendMessage(ProtocolID.GResClick, req)

	if ex.Player.level < levelCond then
		ex.MessageView:add(string.format(ex.Tools:getLang(47214), levelCond))
		return
	end
	
	cfg.funcopen.act_month_card_normal.open()
	OnlineRewardCtr:instance():closeWindow()
end

function OnlineRewardLayer:updateStatus(event,data)
	-- print(event,self.__cname)
	self:updateScrollView()
end

function OnlineRewardLayer:onClose(event,data)
	OnlineRewardCtr:instance():closeWindow()
end

function OnlineRewardLayer:onResult(event,data)
	self:changeTime()
	self:addTimer("time",1000,handler(self,self.changeTime),true)

	local items = self.menu:getChildren()

	local can_id = ex.Player.onlineReward_data:getCanGetId()
	for k,v in pairs(items) do
		local idx = v:getTag()
		local status = ex.Player.onlineReward_data:getStatus(idx)
		local gray = status == 1
		local can_again = cfg.promotiononlinereward.online[idx].once_again == 1
		local not_again = true
		if status == 1 and can_again then  
			if self.has_month_card == true then 
				not_again = ex.Player.onlineReward_data:getGainStatus(idx) 
				gray = not_again
			else
				gray = false
			end
			if v.getableSprite then
				v.getableSprite:removeFromParent()
				v.getableSprite = nil
			end
		end
		
		ex.Tools:setSpriteFrame(v.spr_geted, gray and "other/spr-geted.png" or "other/spr-sign-3.png")
		v.spr_geted:setVisible(status == 1)
		v:setAllGray(gray)
		v:setEnabled(not gray)

		if v.spr_effect then
			v.spr_effect:setVisible(idx <= can_id and (status ~= 1 or (status == 1 and not not_again)))
		end
		
		if gray and v.spr_effect ~= nil then
			print("remove effect")
			v.spr_effect:removeFromParent()
			v.spr_effect = nil
			if v.getableSprite then
				v.getableSprite:removeFromParent()
				v.getableSprite = nil
			end
		end
	end
end

function OnlineRewardLayer:changeTime()
	local can_id = ex.Player.onlineReward_data:getCanGetId()
	if can_id ~= self.can_id then 
		self.can_id = can_id
		self:updateScrollView()
	end 
	local target_id = ex.Player.onlineReward_data:getTargetIdx()
	local total = ex.Player.onlineReward_data:getTotalTimeByIdx(target_id)
	local online_time = ex.Player.onlineReward_data:getOnlineTime()

	local time = (total - online_time) <= 0 and 0 or (total - online_time)

	-- if not self.lbl_time then return end
	-- local _,h,m,s = ex.Tools:formatTime(time)
	-- local str = string.format("%02d:%02d:%02d",h,m,s)
	-- self.lbl_time:setString(str)

	-- local end_time = ex.Player.onlineReward_data:getEndTime()
	-- local server_time = ex.Game:getServerTime()
	-- local time = end_time - server_time
	-- if time <= 0 then 
	-- 	time = 0
	-- 	-- self:removeTimerByName("time")
	-- end
	if target_id == can_id and time  == 0 then self:removeTimerByName("time") end
	-- print(self.__cname,time,target_id,can_id,">>>????")
	if not self.lbl_time then return end
	local _,h,m,s = ex.Tools:formatTime(time)
	local str = string.format("%02d:%02d:%02d",h,m,s)
	self.lbl_time:setString(str)
	-- print(self.__cname,"has",">>>>")
end

function OnlineRewardLayer:updateScrollView( data )
	-- body
	self.scroll_view:getContainer():removeAllChildren()
	self.menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(self.scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    :setName("menu")
    self.scroll_view:addChild(self.menu)

    local margin = 0
    local len = table.nums(self.data)
    local col = math.floor((self.viewSize.width - margin * 2) / self.item_size.width) -- 列数
    local row = math.ceil(1.0 * len / col) -- 行数
    local cont_height = self.item_size.height * row + margin * 2
    cont_height = math.max(cont_height , self.viewSize.height)
    row = math.ceil((cont_height - margin * 2) / self.item_size.height) -- 总行数

    self.scroll_view:setContentSize(cc.size(self.viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, self.viewSize.height - cont_height))

    cont_height = cont_height - (self.item_size.height * 0.5 + margin * 0.5)

    local start = cc.p(self.viewSize.width * 0.5 - (self.item_size.width * col * 0.5), cont_height)
    start.x = start.x + self.item_size.width * 0.5

    local index = 0
    for _,v in pairs(self.data) do
        local x = index % col
        local y = math.floor(index / col)
        local item = nil
        local tag = ex.Player.backpack_data:getPropType(v.reward[1].item_type)
		local item_config = cfg.item.item[v.reward[1].item_type]
		if item_config.mode ~= ItemData.IT_HERO then 
        	item = UIItemBackpack:createWithData(v.reward[1].item_type, v.reward[1].item_num)
        else
        	local config = cfg.herotype.star[v.reward[1].item_type]
        	item = UIMenuItemHero:createWithData("0" , config.type, config.elem, 1, config.star)
			item:setEnableAction(false)
			local spr_tag = cc.Sprite:createWithSpriteFrameName("online-reward-lang/spr-hero-tag.png")
			item:addChild(spr_tag)
			item.spr_tag = spr_tag
			spr_tag:setPosition(item:getContentSize().width,item:getContentSize().height -20)
			spr_tag:setLocalZOrder(9999)
        end
        item:setPosition(start.x + x * self.item_size.width, start.y - y * self.item_size.height)
        item:registerScriptTapHandler(handler(self, self.onClick))
		item:setTag(v.idx)

		local status = ex.Player.onlineReward_data:getStatus(v.idx)
		local can_again = cfg.promotiononlinereward.online[v.idx].once_again == 1
		local gray = status == 1 -- and 2 or 0

		local not_again = true
		if status == 1 and can_again then  
			if self.has_month_card == true then 
				not_again = ex.Player.onlineReward_data:getGainStatus(v.idx) 
				gray = not_again
			else
				gray = false
			end
		end
		
		item:setAllGray(gray)
		item:setEnabled(not gray)
		
		item.spr_geted = cc.Sprite:createWithSpriteFrameName(gray and "other/spr-geted.png" or "other/spr-sign-3.png")
		item:addChild(item.spr_geted)
		item.spr_geted:setPosition(item:getContentSize().width/2,item:getContentSize().height / 2)
		item.spr_geted:setLocalZOrder(999)
		item.spr_geted:setVisible(status == 1)

		self.menu:addChild(item)

		local can_id = ex.Player.onlineReward_data:getCanGetId()
		-- local can = v.idx <= can_id and status == 0
		local is_show_effect = v.idx <= can_id and (status ~= 1 or (status == 1 and not not_again))

		item.spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_online_reward_1")
		item.spr_effect:setPosition(item:getContentSize().width * 0.5, item:getContentSize().height * 0.5 + 5)
		item:addChild(item.spr_effect, 200, 10)
		item.spr_effect:setVisible(is_show_effect)

		if is_show_effect and status ~= 1 then
			item.getableSprite = cc.Sprite:createWithSpriteFrameName('online-reward-lang/getable.png')
			item.getableSprite:setPosition(item:getContentSize().width * 0.5, item:getContentSize().height * 0.5 + 5)
			item:addChild(item.getableSprite, 200)
		end

        index = index + 1
    end
    self.scroll_view:setTouchEnabled(false)
end

function OnlineRewardLayer:onClick(tag,pSender)
	-- print(">>>>>>>1",self.__cname)
	local can_id = ex.Player.onlineReward_data:getCanGetId()
	-- print(self.__cname,can_id)
	if can_id < tag then return end
	-- print(">>>>>>>2",self.__cname)
	local status = ex.Player.onlineReward_data:getStatus(tag)
	print(">>>>>>>status",tag,status)
	local has_again = ex.Player.onlineReward_data:getGainStatus(tag)
	local can_once = cfg.promotiononlinereward.online[tag].once_again == 1
	-- if status == 1 then return end

	if (can_once == true and status == 1) and (self.has_month_card and has_again ~= true) then 
		print(">>>>>>>>")
		local req_online_reward = OnlineReward_pb.GReqOnceAgainOnlineReward()
		req_online_reward.idx = tag
		NetManager:sendMessage(ProtocolID.GReqOnceAgainOnlineReward,req_online_reward)
		return 
	elseif status == 1 then 
		self:onGo()
		return 
	end

	-- if time > 0 then return end
	-- print(">>>>>>>3",self.__cname)
	-- if can_id < tag or (tag == can_id and time > 0) then return end
	-- -- print(">>>>>>>4",self.__cname)

    local req_online_reward = OnlineReward_pb.GReqInitOnlineReward()
	req_online_reward.idx = tag
	NetManager:sendMessage(ProtocolID.GReqInitOnlineReward,req_online_reward)
	local again = cfg.promotiononlinereward.online[tag].once_again
	if again == 1 then 
		ex.MessageView:add(ex.Tools:getLang(47665))
	end
end

function OnlineRewardLayer:setGray(node,gray)
	local items = node:getChildren()
	for k,v in pairs(items) do
		ex.Tools:setGrayAuto(v,gray)
	end
end

function OnlineRewardLayer:onExit()

end


-----------------------------------------------------------------------------
function OnlineRewardCtr:ctor()
	local ccbi_file = "ccbi/OnlineRewardLayer.ccbi"
	self:setCCBIPath(ccbi_file)
	self:registerCCBLoader()
	self:setIsSingle(false)
end

function OnlineRewardCtr:getLayerClass()
	return OnlineRewardLayer
end

-- function OnlineRewardCtr:loadLayer()
-- 	local layer = OnlineRewardLayer
-- 	local ccbi_file = self:getCCBIPath()
-- 	self.layer = layer:create(ccbi_file)
-- 	self:setLayer(self.layer)

--     -- 创建点击事件
--     self:registerTouchListen()
-- end


function OnlineRewardCtr:getOnlineRewardLayer()
	return self.layer
end

function OnlineRewardCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(data)
end

function OnlineRewardCtr:initData(data)

	self:updateLayer(data)
	
end

function OnlineRewardCtr:updateLayer(data)
	local layer = self.layer
	layer.index = self.index
end


function OnlineRewardCtr:enterMake(tag,pSender)


end

return OnlineRewardCtr
