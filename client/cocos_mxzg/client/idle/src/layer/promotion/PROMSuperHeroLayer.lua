--[[
* @Description: 超级英雄商城界面 秘境商城
* @Author: 熊梦
* @Date: 2020-06-1 10:08:32
* ]]
local PROMSuperHeroLayer = class("PROMSuperHeroLayer", require("src.layer.promotion.PromotionCardBaseLayer"))
local PROMSuperHeroCell = require("src.layer.promotion.PROMSuperHeroCell")

function PROMSuperHeroLayer:onCreateDone()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
		
	self.spr_bg:setPositionY(self.layer_promotion:getTopY())

	self.node_item:setPositionY(self.layer_promotion:getTopY() - 50)
	

	-- 添加小女孩动画
	local heishi = sp.SkeletonAnimation:create("spine/shangcheng.json","spine/shangcheng.atlas", 1)
    heishi:setAnimation(0, "act", true);
	heishi:setPosition(0,0)
	heishi:setScaleX(-1)
	self.effect:addChild(heishi)
	-- 处理数据
	--SUPERHERO 
	--MARKET
	local data = ex.Player.market_data:getMarketDataByType(SHOP_TYPE.SUPERHERO)
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
	self.shop_list = shop_list
	self.data = data
	self.conf = ex.Player.market_data.cfg[self.shop_type]



	-- 设置道具和道具数量
	local need_item = self.conf[1].need_item[1]
	self.spr_icon:setSpriteFrame(string.format("%s.png", cfg.item.item[need_item.item_type].icon))
	self.lbl_num:setString(ex.Player:getItemNum(need_item.item_type))

	self:updateStarView()

	self:addEvent(EVENT.SHOP_EVENT.UPDATE,handler(self,self.updateNum))

	self.btn_get:registerScriptTapHandler(handler(self,self.onConfirm))
end

function PROMSuperHeroLayer:onConfirm()
	local need_item = self.conf[1].need_item[1]
	ex.Tools:onClickItemSrc(need_item.item_type)	
end

function PROMSuperHeroLayer:updateNum()
	local need_item = self.conf[1].need_item[1]
	self.lbl_num:setString(ex.Player:getItemNum(need_item.item_type))
end

function PROMSuperHeroLayer:updateStarView()
	self.scroll_view:getContainer():removeAllChildren()
	local viewSize = self.scroll_view:getViewSize()
	
	 -- 处理数据
	--  local data = ex.Player.market_data:getMarketDataByType(SHOP_TYPE.SHOP_TYPE)
	--  local shop_list = {}
	--  for k,v in pairs(data) do
	-- 	 table.insert(shop_list,v)
	--  end
	--  local function sor(a,b)
	-- 	 return a.idx < b.idx		
	--  end
	--  table.sort(shop_list,sor)
	--  if not self.shop_type then 
	-- 	 self.shop_type = shop_list[1].type
	--  end
	-- self.conf = ex.Player.market_data:getMarketItemCfg(shop_list[1].type,shop_list[1].idx)

	local tmp_data = {}
	local idx = 1
	local count = 0
	for i,v in ipairs(self.shop_list) do
		if not tmp_data[idx] then tmp_data[idx] = {} end
		table.insert(tmp_data[idx],v)
		count = count + 1 
		if count % 3 == 0 then 
			idx = idx + 1
		end
	end
	self.list_data = tmp_data 

	local cell_size = cc.size(590, 242)
	cell_size.height = cell_size.height + 6

	local giftLen = math.ceil(count / 3) 
    local cont_height = math.max(cell_size.height * giftLen, viewSize.height)

    self.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
	self.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))
	
	self.scroll_view:setPosition(self.spr_kuang:getPositionX(),(self.spr_kuang:getPositionY() - 18))

	cont_height = cont_height - cell_size.height * 0.45

	local start = cc.p(viewSize.width * 0.5, cont_height)

	if not self.cellList then 
		self.cellList ={}
		local index = 0 + self.spr_bg:getContentSize().width * 0.5
		for i,v in pairs(self.list_data) do
			local task_node = self:addShopCell(v)
			task_node:setName("shop_cell" .. index)
			local scale = self.scroll_view:getViewSize().width / task_node:getContentSize().width
			task_node:setScale(scale)
			task_node:setPosition(start.x, start.y - (i - 1) * cell_size.height)
			self.scroll_view:addChild(task_node)
			table.insert(self.cellList, task_node)
			index = index + 1
		end
	else 
		for i,v in ipairs(self.list_data) do
			self.cellList[i]:reset(v)
		end
	end 

end

function PROMSuperHeroLayer:addShopCell(shop_data)
    local cell = PROMSuperHeroCell:createWithCCBIFile("ccbi/PROMSuperHeroCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
	cell:setAnchorPoint(ex.a.center)
	cell:setTableView(self.scroll_view)
	cell:reset(shop_data)
	return cell
end

return PROMSuperHeroLayer