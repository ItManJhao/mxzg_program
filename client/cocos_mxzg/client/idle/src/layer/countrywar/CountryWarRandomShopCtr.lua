--[[
    func: 国战 - 随机商城
    版权所有:广州暗耀晶石网络信息科技有限公司
]]
local CountryWarRandomShopCtr = class("CountryWarRandomShopCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CountryWarRandomShopLayer = class("CountryWarRandomShopLayer", require("src.comp.EventLayer"))
local CountryWarRandomShopItemCell = class("CountryWarRandomShopItemCell", require("src.comp.EventLayer"))

---------------------------------------------------CountryWarRandomShopItemCell---------------------------
local limit_lang = 
{
	[0] = 2607,
	[1] = 2608,
	[2] = 2609,
	[3] = 2610,
}

function CountryWarRandomShopItemCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	for i=1,3 do
		self:reorderChild(self["spr_sold_out_"..i], 100)
		self["spr_sold_out_"..i]:setVisible(false)
	end
end

function CountryWarRandomShopItemCell:setTableView(tableView)
	for i=1,3 do
		self["menu_" .. i]:setIsTouchInsideNode(tableView)
		self["menu_" .. i]:setSwallowsTouches(false)

	end
end

function CountryWarRandomShopItemCell:onclickItem(tag,pSender)
	-- print(self.__cname,">>>>>>>>>>>")
	ex.Tools:showItemInfo(tag, pSender)
end

function CountryWarRandomShopItemCell:onclick(tag,pSender)
	local is_buy , city_id = ctr.country_war.data:getRandomShopIsBuy()
	if not is_buy then	
		local str = string.format(ex.Tools:getLang(55547), ex.Tools:getLang(cfg.countrywarcity.countrywarcity[city_id].lan_id[ctr.country_war.data:getRound()]))
		ex.ConfirmCtr:openWindow(ex.Tools:getLang(3500), str, function()
			if self.city_layer == nil then
				ctr.country_war.data:setChoiceidx(city_id)
				ex.MainSceneCtr:runCloudAnimation(0.3, function()
					ex.MainSceneCtr:changeLayer(MainSceneType.MAIN_COUNTRY_WAR)
				end)
			else	
				self.city_layer:onShowLastTile(city_id)	
			end
			require("src.layer.countrywar.CountryWarRandomShopCtr"):instance():closeWindow()
		end)
		return
	end
	local conf = self.data[tag]
	local can_buy
	can_buy = true
	if conf.buy_limit == 0 then 
		can_buy = true
	else
		can_buy = conf.buy_limit > self.data[tag].buy_num
	end

	if not can_buy then
		ex.MessageView:add(ex.Tools:getLang(41112)) 
		return 
	end

	local need_item = conf.need_item[1]
	can_buy = ex.Player:getItemNum(need_item.item_type) >= need_item.item_num
	if not can_buy then
		ex.Tools:showEnoughTip(need_item.item_type, true)
		return 
	end

	local function callback( num )
		ctr.country_war:gReqCountryWarRandomShopBuy(self.data[tag].idx,num)
	end

	if GUIDE_STEP_CONTROL == "skip" then
		callback()
	else
		local conf = self.data[tag]

		local item = {}
		item.item_type = conf.item_type[1].item_type
		item.item_num = conf.item_type[1].item_num
		local item_price = {}
		item_price.item_type = conf.need_item[1].item_type
		item_price.item_num = conf.need_item[1].item_num
		local limit_num = -1
		if conf.buy_limit > 0 then
			limit_num = conf.buy_limit - self.data[tag].buy_num
		end
		require("src.layer.ItemSelectCtr"):instance():openWindow(ex.Tools:getLang(41228), item, callback, item_price, limit_num)
	end
end

function CountryWarRandomShopItemCell:reset(data, city_layer)
	local sfc = cc.SpriteFrameCache:getInstance() 
	sfc:addSpriteFrames("ccbi-res/shop-lang.plist")
	self.city_layer = data[1].city_layer
	self.data = data
	for i=1,3 do
		self["node_" .. i]:setVisible(self.data[i] ~= nil) 
		if self.data[i] ~= nil then 
			local conf = self.data[i]
			self["node_" .. i]:setVisible(conf ~= nil) 
			if conf ~= nil then
				local item_data = conf.item_type[1]
				
				self["lbl_item_name_" .. i]:setString(ex.Tools:getLang(cfg.item.item[item_data.item_type].name))
				if self["lbl_item_name_" .. i]:getContentSize().width * self["lbl_item_name_" .. i]:getScaleX() > 170 then 
					self["lbl_item_name_" .. i]:setScale(170 / self["lbl_item_name_" .. i]:getContentSize().width)
				end

				if self.data[i].is_special ~= nil and self.data[i].is_special == true then
					self["lbl_item_name_" .. i]:setColor(cc.c3b(255,183,28))
				end
				local need_item = conf.need_item[1]
				self["node_" .. i]:setVisible(need_item ~= nil)

				local need_privilege = conf.clergy_require and conf.clergy_require > 0 or false
				local is_clergy_privilege = need_privilege and cfg.clergyprivilege.isPrivilege(CLERGY_PRIVILEGE_TYPE.STALL_SHOP, ex.Player.clergy_level) or false
				if need_privilege and not is_clergy_privilege then
					local lbl_active = require("src.comp.RichTextEx"):create()
					lbl_active:setFontSize(20)
					lbl_active:setFontFace(FONT_DEFAULT_NAME_BOLD)
					lbl_active:setAnchorTextShadow(false)
					lbl_active:setWrapMode(1)
					lbl_active:setPosition(self["lbl_count_" .. i]:getPosition())
					lbl_active:setXmlTextLua(ex.Tools:getLang(49313))
					lbl_active:setCallback(function(atom)
						ex.JumpManager:jumpByAtom(atom)
					end)
					self["lbl_count_" .. i]:getParent():addChild(lbl_active)
					self["lbl_count_" .. i]:setVisible(false)
				else
					local is_limit_show = conf.buy_limit > 0
					self["lbl_count_" .. i]:setVisible(is_limit_show)
					if is_limit_show then
						local str = ex.Tools:getLang(2608) .. self.data[i].buy_num .. "/" .. conf.buy_limit
						self["lbl_count_" .. i]:setString(str) 
						ex.Tools:setLimitWidth(self["lbl_count_" .. i], 170)
						if self.data[i].buy_num >= conf.buy_limit then
							self["spr_sold_out_"..i]:setVisible(true)
						end
					end
				end

				self["spr_comprehend_"..i]:setVisible(self.data[i].is_comprehend ~= nil and self.data[i].is_comprehend == true)
				local x,y = self["node_item_" .. i]:getPosition()
				self["menu_"..i]:removeAllChildren()
				
				self.item = ex.Tools:createBackpackItem(item_data.item_type,item_data.item_num)
				self["menu_"..i]:addChild(self.item)
				self.item:setScale(0.8)
				self.item:setPosition(x,y)
				self.item:registerScriptTapHandler(handler(self,self.onclickItem))
				self.item:setLocalZOrder(10)

				if conf.buy_limit > 0 and self.data[i].buy_num >= conf.buy_limit then
					self.item:setGrayed()
				end
				
				local btn = cpp.UIMenuItemLabel:create("button/btn-old-1.png", "", " ", nil)
				self["menu_"..i]:addChild(btn)
				btn:setPosition(94, 73)
				btn:registerScriptTapHandler(handler(self,self.onclick))
				btn:setTag(i)
				btn:setLabelSize(48)
				btn:setLabelColor(cc.c3b(141, 89, 58))
				btn:setLabelText(ex.StringUtil.getScientificNumber(need_item.item_num))
				ex.Tools:addImgToUIMenuItemLabel(btn, nil, string.format("%s.png", cfg.item.item[need_item.item_type].icon), 0.4, 2)
				
				self["bg_new_" .. i]:setVisible(false)
				--是否有打折
				if conf.discount and conf.discount > 0 and conf.discount < 100 then
					local discount = conf.discount
					local spr_discount_bg = cc.Sprite:createWithSpriteFrameName("other/spr-discount-bg.png")
					spr_discount_bg:setPosition(self.item:getPositionX() - self.item:getContentSize().width * 0.5 - 5, self.item:getPositionY() + self.item:getContentSize().height * 0.5 - 28)
					spr_discount_bg:setScale(0.9)
					self["node_" .. i]:addChild(spr_discount_bg)
		
					if math.floor(discount / 10) == discount / 10 then
						discount = math.floor(discount / 10)
					end
		
					local lbl_discount_1 = cc.Label:createWithTTF(tostring(discount), FONT_DEFAULT_NAME_BOLD, 60)
					lbl_discount_1:setScale(0.5)
					:setColor(cc.c4b(255,238,145,255))
					:enableOutline(cc.c4b(190, 0, 0, 255), 2)
					lbl_discount_1:setPosition(spr_discount_bg:getContentSize().width / 2 - 10, spr_discount_bg:getContentSize().height / 2 + 5)
					spr_discount_bg:addChild(lbl_discount_1)
		
					local lbl_discount_2 = cc.Label:createWithTTF(ex.Tools:getLang(47553), FONT_DEFAULT_NAME_BOLD, 44)
					lbl_discount_2:setScale(0.5)
					:setColor(cc.c4b(255,255,255,255))
					:enableOutline(cc.c4b(190, 0, 0, 255), 2)
					lbl_discount_2:setPosition(spr_discount_bg:getContentSize().width / 2 + 10, spr_discount_bg:getContentSize().height / 2 - 5)
					spr_discount_bg:addChild(lbl_discount_2)

					local must = cfg.system.shop_must_buy_item_type
					local must_min = cfg.system.shop_must_min
					local must_max = cfg.system.shop_must_max
					local recommend_min = cfg.system.shop_recommend_min
					local recommend_max = cfg.system.shop_recommend_max
					local res_type = cfg.system.shop_res_type
					if must == conf.item_type[1].item_type then 
						if conf.discount >= must_min and conf.discount <= must_max then 
							local tag = cc.Sprite:createWithSpriteFrameName("shop-lang/spr-type-1.png")
							self["bg_new_" .. i]:addChild(tag)
							tag:setPosition(self["bg_new_" .. i]:getContentSize().width - 15,self["bg_new_" .. i]:getContentSize().height - 10)
						end
					elseif conf.need_item[1].item_type == res_type then 

						if conf.discount >= recommend_min and conf.discount <= recommend_max then 
							local tag = cc.Sprite:createWithSpriteFrameName("shop-lang/spr-type-2.png")
							self["bg_new_" .. i]:addChild(tag)
							tag:setPosition(self["bg_new_" .. i]:getContentSize().width - 15,self["bg_new_" .. i]:getContentSize().height - 10)
						end
					end
				end

				if SHOP_TYPE.STALL == data[i].type or SHOP_TYPE.MARKET == data[i].type  then 
					self["bg_new_" .. i]:setVisible(true)
				end

			else
				print(self.__cname,data[i].idx,data[i].type,"is nil")
			end
		end
	end
end

---------------------------------------------------CountryWarRandomShopLayer---------------------------
 
function CountryWarRandomShopLayer:onCreate()

	local size = self.spr_bg:getContentSize()
	size.width = size.width - 20
	size.height = size.height - 20
	self:resetScaleAtWidth()
	self:addBlackBackground()
	ex.Tools:setLimitWidth(self.lbl_name, 100)
	self.tableView = ex.Tools:initTableView(self.spr_bg, {}, {CountryWarRandomShopItemCell,"ccbi/CountryWarRandomShopItemCell.ccbi"}, size, 5 , cc.p(10,10))

	self:addEvent(EVENT.COUNTRY_WAR.UPDATA_RANDOM_SHOP_LAYER,handler(self,self.onChangeView))
	
	self.lbl_name:enableOutline(cc.c4b(84,63,34,255), 4)
end

function CountryWarRandomShopLayer:onChangeView(event,data)
	self:updateView(self.city_layer)
end

function CountryWarRandomShopLayer:updateRes()
	self.res_node:setVisible(900002 ~= "")
	self.spr_icon:setSpriteFrame(string.format("backpack/%d.png", 900002))
	local num = ex.Player:getItemNum(900002)
	self.lbl_num:setString(num)
end

function CountryWarRandomShopLayer:updateView(city_layer)
	self.city_layer = city_layer
	local data = cfg.countrywarrandomshop.countrywarrandomshop
	local shop_list = {}
	for k,v in pairs(data) do
		table.insert(shop_list,v)
	end
	local function sor(a,b)
		return a.idx < b.idx		
	end
	table.sort(shop_list,sor)
	
	local tmp_data = {}
	local idx = 1
	local count = 0
	for i,v in ipairs(shop_list) do
		if not tmp_data[idx] then tmp_data[idx] = {} end
		v.city_layer = city_layer
		v.buy_num = ctr.country_war.data:getBuyNum(v.idx)
		table.insert(tmp_data[idx],v)
		count = count + 1 
		if count % 3 == 0 then 
			idx = idx + 1
		end
	end
	self.data = tmp_data 

	self.tableView:initData(self.data)

	self:updateRes()
end

---------------------------------------------------CountryWarRandomShopCtr---------------------------

function CountryWarRandomShopCtr:onCreate()
	self:setCCBIPath("ccbi/CountryWarRandomShopLayer.ccbi")
	self:setIsSingle(false)
end

function CountryWarRandomShopCtr:getLayerClass()
	return CountryWarRandomShopLayer
end

function CountryWarRandomShopCtr:openWindow(city_layer)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(city_layer)
end

function CountryWarRandomShopCtr:initData(city_layer)
	local data = cfg.countrywarrandomshop.countrywarrandomshop
    local layer = self.layer
	layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	if not data or table.nums(data) <= 0 then 
		ex.MessageView:add(ex.Tools:getLang(47239))
		return 
	end

	layer:updateView(city_layer)
end

return CountryWarRandomShopCtr