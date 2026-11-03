local MarketShopCtr = class("MarketShopCtr", require("src.comp.EventLayer"))
local MarketShopItemCell = require("src.layer.shop.MarketShopItemCell")

function MarketShopCtr:getAsynImage()
    local vec_image = {
    }
    return vec_image
end

function MarketShopCtr:onCreate()
	print(self.__cname,">>>>>>>>")
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    local last_content_size = self:getContentSize()
    local cur_content_size = cc.size(ex.p.width - 20, ex.p.height - 350)
    local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

    self:setContentSize(cur_content_size)
    self:setPosition(ex.p.width / 2 - self:getContentSize().width / 2, ex.p.height / 2 - self:getContentSize().height / 2 + 50)

	local notch_height = require("src.model.Game"):instance():getNotchHeight()
    self.btn_close:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60,
                              self:getContentSize().height / 2 + ex.p.height / 2 / self:getScaleY() - 100 / self:getScaleY() - 42 - notch_height)

    self.btn_close:registerScriptTapHandler(handler(self, self.onBack))

    self.spr_image_bg = cc.Sprite:create("ccbi-res/shop_bg_1.png")
    self.spr_image_bg:setScale(ex.p.width / self.spr_image_bg:getContentSize().width, ex.p.height / self.spr_image_bg:getContentSize().height)
    self.spr_image_bg:setPosition(ex.p.center().x - self:getPositionX(), ex.p.center().y - self:getPositionY())
    self:addChild(self.spr_image_bg, -1)

    self.lbl_name:enableOutline(cc.c4b(37,54,84,255), 2)
    
    self.list_bg:setPosition(self.list_bg:getPositionX() + offset.x / 2, self.list_bg:getPositionY() + offset.y )
    self.lbl_name:setPosition(self.lbl_name:getPositionX() + offset.x / 2, self.lbl_name:getPositionY() + offset.y)
    self.spr_bg:setPosition(self.spr_bg:getPositionX() + offset.x / 2, self.spr_bg:getPositionY() + offset.y)
    self.time_parent:setPosition(self.time_parent:getPositionX() + offset.x / 2, self.time_parent:getPositionY() + offset.y)
    self.btn_refresh:setPosition(self.btn_refresh:getPositionX() + offset.x / 2, self.btn_refresh:getPositionY() + offset.y)
    self.lbl_limit_time:setPosition(self.lbl_limit_time:getPositionX() + offset.x / 2, self.lbl_limit_time:getPositionY() + offset.y)
    self.effect:setPosition(self.effect:getPositionX() + offset.x / 2, self.effect:getPositionY() + offset.y)

    local heishi = sp.SkeletonAnimation:create("spine/shangcheng.json","spine/shangcheng.atlas", 1)
    heishi:setAnimation(0, "act", true);
    heishi:setPosition(0,0)
    self.effect:addChild(heishi)

	-- self.lbl_btn_refresh = cpp.RichTextEx:createWithXMLLua("")
	-- :setFontSize(20)
	-- :setFontFace(FONT_DEFAULT_NAME_BOLD)
    -- :setFontColor("#643200")
	-- :setAnchorTextShadow(true)
	-- :setAnchorPoint(ex.a.top_center)
	-- :ignoreContentAdaptWithSize(false)
	-- :setWrapMode(1)
	-- :setContentSize(self.btn_refresh:getContentSize().width , self.btn_refresh:getContentSize().height)


	self.lbl_btn_refresh = require("src.comp.RichTextEx"):create()
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setAnchorTextShadow(true)
    :setWrapMode(1)

	self.btn_refresh:addChild(self.lbl_btn_refresh)

	self.lbl_btn_refresh:setPosition(self.btn_refresh:getContentSize().width * 0.5 ,self.btn_refresh:getContentSize().height * 0.5)

    self.btn_refresh:registerScriptTapHandler(handler(self,self.onRefresh))
    self:initDone()

	-- local size = self.spr_bg:getContentSize()
	-- size.width = size.width 
	-- size.height = size.height 
    -- self.tableView = ex.Tools:initTableView(self.spr_bg,{}, {require("src.layer.shop.MarketShopItemCell"),"ccbi/MarketShopItemCell.ccbi"}, size, 2 , cc.p(0,0))


    --   刷新次数，*/*
    self.lbl_limit_time:setString("")
	self.lbl_limit_time:enableOutline(cc.c4b(74, 41, 33, 255), 2)

    self:updateShop()

    self:updateBtnStatus()

    self:addTime()

	self:changeTime()
	self:addEvent(EVENT.SHOP_EVENT.UPDATE,handler(self,self.onChangeView))
	self:addEvent(EVENT.SHOP_EVENT.UPDATE,handler(self,self.onRefreshEvent))
	self:addEvent(EVENT.SHOP_EVENT.UPDATE_FREE_REFRESH_TIME,handler(self,self.onRefreshEvent))
end

function MarketShopCtr:onRefreshEvent(event,data)
	self:updateShop()
	self:updateBtnStatus()
	self:addTime()
end

function MarketShopCtr:onRefreshTimeEvent(event,data)
	self:updateBtnStatus()
	self:addTime()
end


function MarketShopCtr:onRefresh(tag,pSender)

	local res_refresh = Shop_pb.GReqShopRefresh()
	res_refresh.type = self.shop_type
	NetManager:sendMessage(ProtocolID.GReqShopRefresh,res_refresh)
end



function MarketShopCtr:addTime()
	-- self:removeTimerByName("time")
	self:addTimer("time",1000,handler(self,self.changeTime),true)
end

function MarketShopCtr:changeTime()

	local need_free_refresh = ex.Player.market_data:getShopTypeIsNeedRefresh(self.shop_type)
	if need_free_refresh == false then 
		-- self.time_parent:setVisible(false)
		self.lbl_time:setString(string.format("%s:%s:%s",
		"00",
		"00",
		"00"))
		self:removeTimerByName("time")
		return 
	end 
	local conf = cfg.shopcontrol["shop"][self.shop_type]
	local last_time = ex.Player.market_data:getLastTimeByShopType(self.shop_type)
	local refresh_time = conf.free_refresh_time
	local end_time = last_time + refresh_time
	local cur_time = ex.Game:getServerTime()
	local remaining_time = end_time - cur_time
	-- self.time_parent:setVisible(remaining_time > 0)
	if remaining_time <= 0 then 
		-- self.time_parent:setVisible(false)
		self:removeTimerByName("time")
	end
	
	-- print(self.__cname,remaining_time)
	-- self.time_parent:setVisible(remaining_time < refresh_time)
    -- if remaining_time >= refresh_time then 
    --     self.time_parent:setVisible(remaining_time > 0)
	-- 	-- self:removeTimerByName("time")
	-- 	return 
	-- end

	self.lbl_time:setString(string.format("%d:%02d:%02d",
	   math.floor(remaining_time / 3600),
	   math.floor(remaining_time / 60 % 60),
	   math.floor(remaining_time % 60)))
	-- self.lbl_time:setString()
end

function MarketShopCtr:addShopCell(shop_data)
    local cell = MarketShopItemCell:createWithCCBIFile("ccbi/MarketShopItemCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
    cell:setAnchorPoint(ex.a.center)

    cell:reset(shop_data)
	return cell
end


function MarketShopCtr:onChangeView(event,data)

    --local offsetY = self.tableView:getContainer():getPositionY()
    
    self:updateShop()

    --self.tableView:setContentOffset(cc.p(0,offsetY))
end

function MarketShopCtr:updateShop()

    -- 处理数据
    local data = ex.Player.market_data:getMarketDataByType(SHOP_TYPE.MARKET)

	local shop_list = {}
	for k,v in pairs(data) do
		table.insert(shop_list,v)
	end
	local function sor(a,b)
		return a.idx < b.idx		
	end
	table.sort(shop_list,sor)
	if not self.shop_type then 
		for _,v in pairs(shop_list) do
			self.shop_type = v.type
			break
		end
	end
	self.conf = ex.Player.market_data.cfg[self.shop_type]
	
	local tmp_data = {}
	local idx = 1
	local count = 0
	for i,v in ipairs(shop_list) do
		if not tmp_data[idx] then tmp_data[idx] = {} end
		table.insert(tmp_data[idx],v)
		count = count + 1 
		if count % 3 == 0 then 
			idx = idx + 1
		end
	end

	self.data = tmp_data 

	--self.tableView:initData(self.data)
	if not self.cellList then 
		self.cellList ={}
		local index = 0 + self.spr_bg:getContentSize().width * 0.5
		for i,v in pairs(self.data) do
			local task_node = self:addShopCell(v)
			task_node:setName("shop_cell" .. index)
			self:addChild(task_node)
			task_node:setPosition(self.spr_bg:getPositionX() + self.spr_bg:getContentSize().width * 0.5 ,self.spr_bg:getPositionY() + self.spr_bg:getContentSize().height - (i - 1) * task_node:getContentSize().height - task_node:getContentSize().height * 0.5  )
			table.insert(self.cellList, task_node)
			index = index + 1
		end
	else 
		for i,v in ipairs(self.data) do
			self.cellList[i]:reset(v)
		end
	end 

	local conf = cfg.shopcontrol.shop[SHOP_TYPE.MARKET]
	local vip_level = ex.Player.fetter_data.vip:getVIP()
	local rechage_refresh_max = conf.daily_charge_refresh + cfg.goddessvip.goddessvip[vip_level].extra_market_times
	local rechage_refresh_num = ex.Player.market_data:getChargeRefreshNumByType(SHOP_TYPE.MARKET)
	self.lbl_limit_time:setString(string.format(ex.Tools:getLang(47398),rechage_refresh_max - rechage_refresh_num,rechage_refresh_max))
end 


function MarketShopCtr:initDone()
    local data = ex.Player.market_data:getMarketDataByType(SHOP_TYPE.MARKET)
    if not data then 
        ex.MessageView:add(ex.Tools:getLang(47239))
        return 
    end

end 


function MarketShopCtr:updateBtnStatus()
	local free_refresh = ex.Player.market_data:getFreeRefreshNumByType(self.shop_type)
	local charge_refresh = ex.Player.market_data:getChargeRefreshNumByType(self.shop_type)
	local charge_item = ex.Player.market_data:ChargeItemCostyType(self.shop_type)

    local str = ""
	local btn_status = false

	local conf = cfg.shopcontrol.shop[self.shop_type]

	if free_refresh > 0 then 
		str = string.format(ex.Tools:getLang(47291),free_refresh,conf.max_refresh_count)
		btn_status = true
	elseif charge_refresh > 0 then 
		str = string.format(ex.Tools:getLang(47465),charge_item.item_type,charge_item.item_num)
		btn_status = ex.Player:getItemNum(charge_item.item_type) >= charge_item.item_num

	elseif free_refresh == 0 and charge_refresh == 0 then 
		self.btn_refresh:setEnabled(false)
		str = ex.Tools:getLang(47018)
	else
		str = ex.Tools:getLang(47018)
	end
	

	self.lbl_btn_refresh:setXmlTextLua(str)



end

function MarketShopCtr:onSetCallBack(callback)
	self.callback = callback

end

function MarketShopCtr:onBack(tag , pSender)
	if not self.callback then 
		if not ex.MainSceneCtr:backLastLayer() then
			ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
		end
	else
		self.callback()
	end 
end

return MarketShopCtr