local HeroCreatCtr = class("HeroCreatCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroCreatLayer = class("HeroCreatLayer", require("src.comp.EventLayerAdaptiveWidth"))
local HeroCreatCell = class("HeroCreatCell", require("src.comp.EventLayer"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")


function HeroCreatCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	self.menu = cpp.UIMenu:create()
	self.menu:setSwallowsTouches(false)
	self:addChild(self.menu)
	self.menu:setPosition(cc.p(0,0))
	-- self.btn_compose:setScaleX(0.7)

	self.lbl_btn_compose = cc.Label:createWithTTF(ex.Tools:getLang(47438), FONT_DEFAULT_NAME_BOLD, 24)
	self.lbl_btn_compose:enableOutline(cc.c3b(13,91,45),2)
    self.btn_compose:addChild(self.lbl_btn_compose)
    self.lbl_btn_compose:setPosition(self.btn_compose:getContentSize().width / 2,self.btn_compose:getContentSize().height / 2 + 3)
    -- self.lbl_btn_compose:enableOutline(ex.c3b.BLUE, 1)
    self.btn_compose:registerScriptTapHandler(handler(self, self.onClickCompose))

	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_STAR_SELECT_EXIT,handler(self,self.updateSelectNum))
	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_STAR,handler(self,self.onSuccess))
end

function HeroCreatCell:onSuccess(event,data)
	-- dump(data, "HeroCreatCell:onSuccess")
	self:reset(self.data)
end

function HeroCreatCell:onClickCompose(tag,pSender)
	local config = cfg.herotype.star[self.data.type]["to_".. self.data.star + 1 .."_star"]
	local bool = true
	local count = 0
	for i,v in ipairs(config) do
		local num = #ex.Player.hero_data.promote:getComsumeHeroList(i)
		bool = num >= v.num 
		count = count + v.num
		if bool == false then break end
	end


	local cost = cfg.herostar.star[self.data.star].upstar_cost  --[1]
	if cost ~= "" and table.nums(cost) > 0 then 
		cost = cost[1]
		local item_num = ex.Player:getItemNum(cost.item_type)
		if item_num < cost.item_num then
			ex.MessageView:add(ex.Tools:getLang(47186)) 
			return
		end
	end

	if bool == false then 
		ex.MessageView:add(ex.Tools:getLang(47186)) 
		return 
	end

	local main_list = ex.Player.hero_data.promote:getComsumeHeroList(0)

	if table.nums(main_list) <= 0 then 
		ex.MessageView:add(ex.Tools:getLang(47186)) 
			return
	end

	-- local req_up_star = cpp.ByteArray:create()
    -- req_up_star:writeInt(ProtocolID.GReqHeroUpStar)
    -- req_up_star:writeInt64(main_list[1].hero_id)
    -- req_up_star:writeByte(count)
    -- for i = 1, #config do
    -- 	local data = ex.Player.hero_data.promote:getComsumeHeroList(i)
    -- 	for k,v in ipairs(data) do
    -- 		req_up_star:writeInt64(v.hero_id)
 	-- 	end
    -- end

	-- cpp.NetManager:instance():sendByteArray(req_up_star)
	
	local req_up_star = Hero_pb.GReqHeroUpStar()
	req_up_star.hero_id = main_list[1].hero_id
    for i = 1, #config do
    	local data = ex.Player.hero_data.promote:getComsumeHeroList(i)
    	for k,v in ipairs(data) do
    		table.insert(req_up_star.list_hero_id,v.hero_id)
 		end
    end
	NetManager:sendMessage(ProtocolID.GReqHeroUpStar,req_up_star)

end

function HeroCreatCell:updateSelectNum(event,data)
	local upData = clone(self.data["to_" .. self.data.star + 1 .. "_star"])
	local mian_hero = {}
	mian_hero.elem = self.data.elem
	mian_hero.type = self.data.type
	mian_hero.star = self.data.star
	mian_hero.num = 1
	table.insert(upData,1,mian_hero)
	for i,v in ipairs(upData) do
		local count = #ex.Player.hero_data.promote:getComsumeHeroList(i-1)
		local str = string.format("%s/%s",count,v.num)
		local node = self.menu:getChildByTag(i-1)
		node:setLevel(str)
		node:setGray(not (count < v.num and v.type > 0))
		local canData = ex.Player.hero_data.promote:getCanSelectList(v,i-1)
		node:setRedPoint(#canData >= v.num and count < v.num)
	end
end

function HeroCreatCell:reset(data)
	self.menu:removeAllChildren()
	self.items = {}
	self.data = data
	local upData = clone(data["to_" .. data.star + 1 .. "_star"])
	local mian_hero = {}
	mian_hero.elem = data.elem
	mian_hero.type = data.type
	mian_hero.star = data.star
	mian_hero.num = 1
	table.insert(upData,1,mian_hero)

	for i,v in ipairs(upData) do
	-- for i=1,4 do
		local idx = i -1
		v.hero_type = v.type == -1 and data.hero_type or v.type
		v.elem = v.elem == -1 and data.elem or v.elem

		local scale =i == 1 and 1 or 0.7
		-- local scale = i == 1 and 0.8 or 0.6
		--local margin = i == 1 and 30 or 10
		local margin = 8
		local item = UIMenuItemHero:createWithData()
		item:initSelectItem(v)
		local str = string.format("%s/%s",0,v.num)
		item:setLevel(str)
		-- item:setAnchorPoint(cc.p(0,0))
		local size = item:getContentSize()
		-- local posX = 30 + ((size.width * scale) + margin) * (i - 1)
		--if i > 1 then posX = posX + 30 end
		item:setScale(scale)
		item:setTag(i - 1)

		if v.type == 0 then 
			item:setPieceIcon()
        end 
        local name = ""
        if v.type == 0 then 
            name = string.format(ex.Tools:getLang(47700),v.star)
        elseif v.type == -1 then 
            name = ex.Tools:getLang(data.hero_type)
        else
            name = ex.Tools:getLang(v.type)
        end
        item.spr_bg = cc.Sprite:createWithSpriteFrameName("hero-creat/hongdi.png")
        item:addChild(item.spr_bg)
        item.spr_bg:setPosition(item:getContentSize().width / 2, - 20)
        item.lbl_name = cc.Label:createWithTTF(name, FONT_DEFAULT_NAME_BOLD,20)
        item.lbl_name:setColor(cc.c3b(255,227,183))
        item:addChild(item.lbl_name)
        item.lbl_name:setPosition(item:getContentSize().width / 2, - 20)
		-- item:setLevel(str)
		self.items[i] = item
        self.menu:add(item)
        item:setPosition(cc.p(self["spr_" .. i]:getPosition()))
		-- item:setPosition(cc.p(posX,22))
		item:registerScriptTapHandler(handler(self, self.onClickUpStar))

		local canData = ex.Player.hero_data.promote:getCanSelectList(v,idx)
		local select_count = #ex.Player.hero_data.promote:getComsumeHeroList(idx)
		local red = #canData >= v.num and select_count < v.num
		item:setRedPoint(red)
		item:setGray(not (select_count < v.num and v.type > 0))
	end

	local cost = cfg.herostar.star[self.data.star].upstar_cost--[1]
	self.node_need:setVisible(cost ~= "" and table.nums(cost) > 0)
	if cost ~= "" and table.nums(cost) > 0 then 
		cost = cost[1]
		self.lbl_gold_need:setString(cost.item_num)
		self.spr_gold_need:setSpriteFrame(string.format("backpack/%s.png",cost.item_type))
		self.spr_gold_need:setScale(0.5)

		local item_num = ex.Player:getItemNum(cost.item_type)
		self.lbl_gold_need:setTextColor(item_num < cost.item_num and cc.c3b(233, 91, 72) or cc.WHITE)
	end
end

function HeroCreatCell:initSelectNum()
	local upData = self.data["to_" .. self.data.star + 1 .. "_star"]

	for i,v in ipairs(upData) do
		local item = self.items[i]
		local str = string.format("%s/%s", 0 , v.num)
		item:setLevel(str)
		item:setGray(false)
	end
end

function HeroCreatCell:onClickUpStar(tag , pSender)
	local index = pSender:getTag()

 	require("src.layer.HeroUpStarSelectCtr"):instance():openWindow(index, true, index == 2 and self.data.star == 5)
end

--------------------------------------------

function HeroCreatLayer:onCreate()
	self:addBlackBackground()
	
	-- self:setSwallowTouches(false)
	self:setExitCallback(handler(self,self.exitCallback))
	self.cell = HeroCreatCell:createWithCCBIFile("ccbi/HeroCreatCell.ccbi")
    self.node:addChild(self.cell)
	self.cell:setPosition(cc.p(0,0))
	-- self.menu_elem:retain()
	-- self.menu_elem:removeFromParent()
	-- self.spr_bg:addChild(self.menu_elem)
	-- self.menu_elem:setLocalZOrder(100)
	self.menu_elem:setPosition(self.spr_bg:getPosition())
	-- self.menu_elem:release()
    self:onClickByBtnEvent()
	self.lbl_tips:setString(ex.Tools:getLang(41244))
	self.node:setLocalZOrder(100)
	self.node_title:setLocalZOrder(999)

	-- self:setContentSize(ex.p)
	self.spr_bg_all:setScaleX(ex.p.width / self.spr_bg_all:getContentSize().width / self:getScaleX())
	self.spr_bg_all:setScaleY(ex.p.height / self.spr_bg_all:getContentSize().height / self:getScaleX())

	-- self.spr_name_bg:setLocalZOrder(999)
	-- self.lbl_hero_name:setLocalZOrder(999)
	-- self.spr_elem:setLocalZOrder(999)
	-- self.node_star:setLocalZOrder(999)
	ex.Tools:setLimitWidth(self.lbl_hero_name, 110)

	local notch_height = require("src.model.Game"):instance():getNotchHeight()
    self.menu_back:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60,
                              self:getContentSize().height / 2 + ex.p.height / 2 / self:getScaleY() - 100 / self:getScaleY() - 42 - notch_height)
	self.btn_back:registerScriptTapHandler(handler(self, self.onBack))
	
	local last_content_size = self:getContentSize()
	local cur_content_size = cc.size(ex.p.width - 20, ex.p.height - 220)
    local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)
    local bg_size = self.spr_bg_all:getContentSize()
    -- self.spr_bg_all:setScaleX(last_content_size.width / bg_size.width)
    -- self.spr_bg_all:setScaleY(last_content_size.height / bg_size.height)

    -- self:setContentSize(cur_content_size)
    -- dump(cur_content_size)
    -- self.spr_bg_all:setScaleX(bg_size.width / cur_content_size.width)
    -- self.spr_bg_all:setScaleY(bg_size.height / cur_content_size.height)
	-- self:setPosition(ex.p.width / 2 - self:getContentSize().width / 2, ex.p.height / 2 - self:getContentSize().height / 2 + 20)

	-- self.spr_bg:setContentSize(cc.size(cur_content_size.width + 20, cur_content_size.height + 20))
	-- self.spr_bg:setPosition(-10, -10)
	-- self.btn_close:setPosition(cur_content_size.width - 35, cur_content_size.height - 30)
	-- self.spr_bg:setContentSize(self.spr_bg:getContentSize().width + offset.x, self.spr_bg:getContentSize().height + offset.y)
	-- self.btn_close:setPosition(self.btn_close:getPositionX() + offset.x, self.btn_close:getPositionY() + offset.y)

	-- self.spr_name_bg:setPosition(self.spr_name_bg:getPositionX() + offset.x / 2, self.spr_name_bg:getPositionY() + offset.y)
	-- self.lbl_hero_name:setPosition(self.lbl_hero_name:getPositionX() + offset.x / 2, self.lbl_hero_name:getPositionY() + offset.y)
	-- self.btn_info:setPosition(self.btn_info:getPositionX() + offset.x / 2, self.btn_info:getPositionY() + offset.y)
	-- self.btn_hero_info:setPosition(self.btn_hero_info:getPositionX() + offset.x / 2, self.btn_info:getPositionY() + self.btn_info:getContentSize().height * 0.5 - self.btn_hero_info:getContentSize().height * 0.5 - 6 )
	-- self.spr_circle:setPosition(self.spr_circle:getPositionX() + offset.x / 2, self.spr_circle:getPositionY() + offset.y)

	-- self.btn_elem0:setPosition(self.btn_elem0:getPositionX() + offset.x / 2, self.btn_elem0:getPositionY() + offset.y)
	-- self.btn_elem1:setPosition(self.btn_elem1:getPositionX() + offset.x / 2, self.btn_elem1:getPositionY() + offset.y)
	-- self.btn_elem2:setPosition(self.btn_elem2:getPositionX() + offset.x / 2, self.btn_elem2:getPositionY() + offset.y)
	-- self.btn_elem3:setPosition(self.btn_elem3:getPositionX() + offset.x / 2, self.btn_elem3:getPositionY() + offset.y)
	-- self.btn_elem4:setPosition(self.btn_elem4:getPositionX() + offset.x / 2, self.btn_elem4:getPositionY() + offset.y)
	-- self.btn_elem5:setPosition(self.btn_elem5:getPositionX() + offset.x / 2, self.btn_elem5:getPositionY() + offset.y)
	local margin = 10
	local total_width = 0
	for i=0,5 do
		local btn = self["btn_elem"..i]
		local scale = btn:getScale()
		total_width = total_width + (btn:getContentSize().width * scale + margin) 
		-- btn:setPosition((btn:getContentSize().width + margin) * i,70)
		-- print(self.__cname,(btn:getContentSize().width + margin) * i,i)
	end
	total_width = total_width - margin
	local start_x = (self.spr_bg:getContentSize().width - total_width) / 2

	for i=0,5 do
		local btn = self["btn_elem"..i]
		local scale = btn:getScale()
		local x = (btn:getContentSize().width * scale + margin) * i + start_x + (btn:getContentSize().width * scale / 2)
		btn:setPosition(x,70)
	end

	self:checkElemRed()

	-- self.cell:setPosition(self.cell:getPositionX() + offset.x / 2, self.cell:getPositionY() + offset.y)
    -- self.node_star:setPosition(self.node_star:getPositionX() + offset.x / 2, self.node_star:getPositionY() + offset.y)
    -- self.menu_elem:setPosition(cc.p(-285,-392))
    self.hero_menu = cpp.UIMenu:create()
    self.spr_circle:addChild(self.hero_menu)
	self.hero_menu:setPosition(cc.p(0,0))
	
    
	-- self.spr_scroll_view_bg:setPosition(self.spr_scroll_view_bg:getPositionX() + offset.x / 2, self.spr_scroll_view_bg:getPositionY())
	-- self.scrollView:setPosition(self.scrollView:getPositionX() + offset.x / 2, self.scrollView:getPositionY())

	-- self.spr_scroll_view_bg:setContentSize(self.spr_scroll_view_bg:getContentSize().width, self.spr_scroll_view_bg:getContentSize().height + offset.y)
	-- self.scrollView:setViewSize(cc.size(self.scrollView:getViewSize().width, self.scrollView:getViewSize().height + offset.y))

	-- self.allData = self:initElemData()
	self.allData = ex.Player.hero_data.promote:getCreatHeroData()
	self:changeHeroElem(ElemType.ALL)
	self:registerEvent()

	ex.Player.hero_data.promote:setSelectHero(0)
end

function HeroCreatLayer:onBack(tag,pSender)
	ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
	-- ex.MainSceneCtr:changeLayer(MainSceneType.HERO_LAYER)
end

function HeroCreatLayer:checkElemRed( )
	local red_list = ex.Player.hero_data.promote:getCreateHeroRedList()

	local elem_list = {}
	for k,v in pairs(red_list) do
		if v == true then 
			local hero = cfg.herotype.star[k]
			local elem = hero.elem
			elem_list[0] = true 
			elem_list[elem] = true
		end
	end

	for i = 0 , 5 do 
		local btn = self["btn_elem" .. i]
		local red = elem_list[i] == true and elem_list[i] or false
		ex.Tools:addRedPoint(btn,red,cc.p(0.8,0.8))
	end
end

function HeroCreatLayer:onClickByBtnEvent()
    self.btn_elem0:setTag(ElemType.ALL)
    self.btn_elem1:setTag(ElemType.FIRE)
    self.btn_elem2:setTag(ElemType.WATER)
    self.btn_elem3:setTag(ElemType.FOREST)
    self.btn_elem4:setTag(ElemType.LIGHT)
    self.btn_elem5:setTag(ElemType.SHADOW)

    self.btn_elem0:registerScriptTapHandler(handler(self, self.onElem))
    self.btn_elem1:registerScriptTapHandler(handler(self, self.onElem))
    self.btn_elem2:registerScriptTapHandler(handler(self, self.onElem))
    self.btn_elem3:registerScriptTapHandler(handler(self, self.onElem))
    self.btn_elem4:registerScriptTapHandler(handler(self, self.onElem))
    self.btn_elem5:registerScriptTapHandler(handler(self, self.onElem))
    self.btn_info:registerScriptTapHandler(handler(self, self.onClickInfo))
    self.btn_hero_info:registerScriptTapHandler(handler(self, self.onClickHeroInfo))

    self.btn_elem_select = require("src.layer.HeroElemSelect"):new()
    self.btn_elem_select:bindSelect(self.btn_elem0)
    self.btn_elem_select:bindSelect(self.btn_elem1)
    self.btn_elem_select:bindSelect(self.btn_elem2)
    self.btn_elem_select:bindSelect(self.btn_elem3)
    self.btn_elem_select:bindSelect(self.btn_elem4)
    self.btn_elem_select:bindSelect(self.btn_elem5)
    self.btn_elem_select:setSelected(ElemType.ALL)
    
end

function HeroCreatLayer:registerEvent()
	self:addEvent(EVENT.BACK_PACK_EVENT.BACK_PACK_REFUND,handler(self,self.openRefundView))
	self:addEvent(EVENT.HERO_INFO_EVENT.HERO_UP_STAR,handler(self,self.openCreatHeroView))
end

function HeroCreatLayer:openRefundView(event,data)
	-- dump(data)
	if table.nums(data.reward) <= 0 then 
		ex.EventManager:fire(data.eventData.event,data.eventData.data)
	else
		require("src.layer.ItemRewardCtr"):instance():openWindow(data)
	end
	self:checkElemRed()
	-- for i = 0 , 5 do 
	-- 	local btn = self["btn_elem" .. i]
	-- 	-- btn:setPosition(btn:getPositionX() + offset.x / 2, btn:getPositionY() + offset.y)
	-- 	local red = ex.Player.hero_data.promote:getHeroElemRedPoint(i)
	-- 	ex.Tools:addRedPoint(btn,red)
	-- end
end

function HeroCreatLayer:openCreatHeroView(event,data)
	require("src.layer.UpStarSuccessCtr"):instance():openWindow(data)

	self:checkElemRed()
	
	self.cell:initSelectNum()

	local menu = self.scrollView:getContainer():getChildByName("menu")
	local items = menu:getChildren()
	local isRed = false
	for k,item in pairs(items) do
		local data = item:getData()
		local bool = ex.Player.hero_data.promote:getCreatHeroRedPoint( data.type )
		local count = ex.Player.hero_data.promote:getCreatHeroHasNum(data.type)
		local need = self:getHeroNeedNum(data)

		item:setCompleted(count,need)
		item:setRedPoint(bool)
		if bool == true then isRed = bool end
	end
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCCZFZ, isRed)


	-- 刷新列表
    self.btn_elem_select:setSelected(self.cur_hero_elem)
    local data = self:getElemData(self.cur_hero_elem)
    self:updateScrollView(data)
end

function HeroCreatLayer:onClickInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42018), ex.Tools:getLang(42019))
end

function HeroCreatLayer:onClickHeroInfo(tag,pSender)
	local heroData = ex.Player.hero_data.promote:getSelectHeroTypeByData()
	require("src.layer.HeroInfoTipsCtr"):instance():openWindow(heroData)
end

function HeroCreatLayer:getElemData(elem)
	if elem == ElemType.ALL then return self.allData end

	local data = {}
	for k,v in pairs(self.allData) do
		if v.elem == elem then 
			table.insert(data,v)
		end
	end
	local sor = function (a,b)
		return a.star < b.star
	end
	table.sort(data,sor)
	return data
end

function HeroCreatLayer:onElem(tag,pSender)
    if self.onClickBtn == true then 
        self:changeHeroElem(tag)
    end
end

function HeroCreatLayer:changeHeroElem( elem )

    if self.cur_hero_elem == elem then
        return
    end

    self.cur_hero_elem = elem
    self.btn_elem_select:setSelected(elem)
    -- local data = ex.Player.hero_data:getHeroByElem(elem)
    local data = clone(self:getElemData(elem))
    self:updateScrollView(data)
end

function HeroCreatLayer:updateScrollView(data)
	self.onClickBtn = false
	
    for i=1,#data do
		data[i].count = ex.Player.hero_data.promote:getCreatHeroHasNum(data[i].type)
		data[i].need = self:getHeroNeedNum(data[i])
	end

	-- 对数据做排序
	table.sort(data, function(a, b)
		local score_a, score_b = 0, 0
		if a.count >= a.need then score_a = 1000000 end
		if b.count >= b.need then score_b = 1000000 end
		if a.count ~= b.count then 
			if a.count > b.count then score_a = score_a + 100000 else score_b = score_b + 100000 end
		else
			score_a = score_a - a.star * 10000
			score_b = score_b - b.star * 10000

			if a.type > b.type then score_a = score_a + 100 else score_b = score_b + 100 end
		end
		return score_a > score_b
	end)

    -- local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
	local scroll_view = self.scrollView
	local height 
	scroll_view:getContainer():removeAllChildren()
	local menu = cpp.UIMenu:create()
	menu:setName("menu")
    :setIsTouchInsideNode(scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    scroll_view:getContainer():addChild(menu)

    self.viewSize = self.scrollView:getViewSize()
    local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
    self.item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
    self.item_size = cc.size(self.item_size.width, self.item_size.height + 25)

    local margin = 0
    local margin_x = 3
    local len = table.nums(data)
    local col = math.floor((self.viewSize.width - margin * 2) / (margin_x + self.item_size.width)) -- 列数
    local row = math.ceil(1.0 * len / col) -- 行数
    local cont_height = self.item_size.height * row + margin * 2
    cont_height = math.max(cont_height , self.viewSize.height)
    row = math.ceil((cont_height - margin * 2) / self.item_size.height) -- 总行数
    

    self.scrollView:setContentSize(cc.size(self.viewSize.width, cont_height))
    self.scrollView:setContentOffset(cc.p(0, self.viewSize.height - cont_height))

    cont_height = cont_height - (self.item_size.height * 0.5 + margin * 0.5)

    self.item_size.width = self.viewSize.width / (col == 0 and 1 or col)
    self.item_size.width = self.item_size.width - 4
    local start = cc.p(self.viewSize.width * 0.5 - (self.item_size.width * col * 0.5 +(margin_x * (col -1))), cont_height)
    start.x = start.x + self.item_size.width * 0.5 + (margin_x)
    -- dump(self.viewSize.width * 0.5 - (self.item_size.width * col * 0.5 +(margin_x * (col -1))))
    local index = 0
    for i=1,#data do
        local x = index % col
        local y = math.floor(index / col)

		local cell_props = UIMenuItemHero:createWithData()
		data[i].hero_type = data[i].type
		cell_props:reset(data[i])
		cell_props:setStar(data[i].star + 1)
		cell_props:setIcon(data[i].hero_type)
		cell_props:setShopCountVisible(false)
		-- cell_props:setScale(0.9)

		cell_props.lbl_level:setVisible(false)
			
		cell_props:setCompleted(data[i].count, data[i].need)
		menu:add(cell_props)
		cell_props:registerScriptTapHandler(handler(self,self.onClickHero))

        cell_props:setPosition(start.x + x * (self.item_size.width + margin_x), start.y - y * self.item_size.height)
		local bool = ex.Player.hero_data.promote:getCreatHeroRedPoint( data[i].type )
		cell_props:setRedPoint(bool)
        index = index + 1
	end

	ex.Player.hero_data.promote:setSelectHeroType(data[1].hero_type)
	self.cell:reset(data[1])
	self:createSpine(data[1].type)
	self:createStar(data[1])
	self.select_data = data[1]

	self.spr_name_bg:setLocalZOrder(2)
    self.lbl_hero_name:setLocalZOrder(2)
    self.spr_elem:setLocalZOrder(2)
    self.node_star:setLocalZOrder(2)
	self.menu:setLocalZOrder(3)
	self.lbl_hero_name:setString(ex.Tools:getLang(data[1].type))
	local conf = cfg.herotype.star[data[1].type]
	self.spr_elem:setSpriteFrame("hero-icon/elem-" .. conf.elem .. ".png")
    self.onClickBtn = true
end

function HeroCreatLayer:getHeroNeedNum(data)
	local config = cfg.herotype.star[data.type]
	local upgrade_item = config["to_" .. data.star+1 .."_star"]
	local count = 0
	for k,v in pairs(upgrade_item) do
		count = count + v.num
	end
	return count + 1
end

function HeroCreatLayer:setLabelText(data)

end

function HeroCreatLayer:onClickHero(tag,pSender)
	local data = pSender:getData()
	self:onHeroSelect(data.hero_type)
end

function HeroCreatLayer:onHeroSelect(hero_type)
	local data = nil
	for i,v in ipairs(self.allData) do
		if v.type == hero_type then
			data = v
		end
	end
	if data == nil then
		return
	end

	if data == self.select_data then return end
	self.select_data = data
	-- self.spr_name_bg:setLocalZOrder(2)
	-- self.lbl_hero_name:setLocalZOrder(2)
	self.lbl_hero_name:setString(ex.Tools:getLang(data.type))
	local conf = cfg.herotype.star[data.type]
	self.spr_elem:setSpriteFrame("hero-icon/elem-" .. conf.elem .. ".png")

	ex.Player.hero_data.promote:setSelectHeroType(data.type)
	ex.Player.hero_data.promote:resetComsumeHeroList()
	self.cell:reset(data)
	self:createSpine(data.type)
	self:createStar(self.select_data)
end

function HeroCreatLayer:onTouchHero(tag,pSender)
	pSender:attack()
end

function HeroCreatLayer:createSpine(type)
	-- body
	if self.hero ~= nil then 
		self.hero_menu:removeChildByTag(100)
		self.hero = nil 
	end
	local star = cfg.herotype.star[type].star + 1
	local skin = ex.Tools:getHeroSkinByStar(type,star)
    self.hero = require("src.person.Hero"):create("12323", "123213",type, 1, star,skin)
    self.hero:setScale(1.5 * 1.42)
    self.hero:setPosition(0,0)
	self.hero:registerScriptTapHandler(handler(self, self.onTouchHero))
	self.hero:setTag(100)
    self.hero_menu:addChild(self.hero)
end

function HeroCreatLayer:createStar(data)
	local curStar = data.star + 1
    self.node_star:removeAllChildren()
    local level = cfg.herostar.star[curStar].level_limit
    self.lbl_level:setString(string.format(ex.Tools:getLang(47344),level))
    local stage = 0
    for i=0,6 do
        local stage_cfg = cfg.heroupgrade.grade[i]
        if stage_cfg.level <= level then 
            stage = i 
        else
            break
        end
    end
    local attr = ex.Player.hero_data:getHeroAttribute(data.hero_type or data.type, stage, curStar, level)
    -- dump(attr)
    for k,v in pairs(attr) do
        local key = "lbl_attr_" .. k
        local lbl = self[key]
        if lbl ~= nil then 
            lbl:enableOutline(cc.c3b())
            lbl:setString(math.floor(v))
        end
    end
	-- dump(ex.Player.hero_data:getCanSelectList(self.hero_data.hero_type,self.hero_data.star,self.hero_data.hero_id))

	local star_type = math.floor(curStar / 5)
	local star_count --= -- ( self.star % 5 == 0 and self.star == 5 ) and 5 or (self.star  % 5 == 0 and self.star > 5 or 1)

	if curStar % 5 == 0 then 
		if curStar > 5 then
			star_count = 1
		else 
			star_count = 5
			star_type = 0
		end
	else
		star_count = curStar % 5
	end

	local path = string.format("other/star-%d.png",star_type)
	if curStar > 10 then star_count = star_count + 1 end
	for i=1,star_count do
        local sp = cc.Sprite:createWithSpriteFrameName(path)
        sp:setScale(0.8)
		self.node_star:addChild(sp,star_count-i)
		local margin = 12
		local width = (sp:getContentSize().width * 0.8) + margin
		local posX = -(width / 2 * star_count)/2 + width / 2 * (i - 1) 
		sp:setPosition(posX,0)
	end
end

function HeroCreatLayer:exitCallback()
	-- self:removeEvent()
	ex.Player.hero_data.promote:setSelectHeroType(nil)
	ex.Player.hero_data.promote:resetComsumeHeroList()
end

return HeroCreatLayer
