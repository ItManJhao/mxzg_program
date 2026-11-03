local BlackMarketShopCtr = class("BlackMarketShopCtr", require("src.comp.EventLayer"))
-- local SHOP_TYPE = {}
-- SHOP_TYPE.STALL = 1
-- SHOP_TYPE.HERO = 2
-- SHOP_TYPE.PROPHECY = 3
-- SHOP_TYPE.SUPERSTAGE = 4
-- SHOP_TYPE.PVPNORMAL = 5
-- SHOP_TYPE.FASHION = 6

local btn_tab_list = {
	{idx = 1, name = "btn_tab_1", label = 41220, tag = SHOP_TYPE.STALL},
	{idx = 2, name = "btn_tab_2", label = 41221, tag = SHOP_TYPE.HERO},
	{idx = 3, name = "btn_tab_3", label = 41222, tag = SHOP_TYPE.PROPHECY},
	{idx = 4, name = "btn_tab_4", label = 41359, tag = SHOP_TYPE.SUPERSTAGE},
	{idx = 5, name = "btn_tab_5", label = 41223, tag = SHOP_TYPE.PVPNORMAL},
    {idx = 6, name = "btn_tab_6", label = 75609, tag = SHOP_TYPE.SPACE_TIME_MAGIC_TOWER},
    {idx = 7, name = "btn_tab_7", label = 41224, tag = SHOP_TYPE.FASHION},
    {idx = 8, name = "btn_tab_8", label = 41360, tag = SHOP_TYPE.FLOATING_ISLANDS},
    {idx = 9, name = "btn_tab_9", label = 76570, tag = SHOP_TYPE.EXOTIC_ADVENTURE},
    {idx = 10, name = "btn_tab_10", label = 55520, tag = SHOP_TYPE.COUNTRY_WAR_SHOP},
    {idx = 11, name = "btn_tab_11", label = 71109, tag = SHOP_TYPE.CHAMPION},
}

function BlackMarketShopCtr:getAsynImage()
    local vec_image = {
    }
    return vec_image
end

function BlackMarketShopCtr:updateCanShowConfig()
    if not cfg.blackshopconfig or not(cfg.blackshopconfig.blackshopconfig) then
        return
    end
    btn_tab_list = {}
    for i,v in ipairs(cfg.blackshopconfig.blackshopconfig) do
        if ex.Player.level >= v.level then
            table.insert(btn_tab_list, v)
        end
    end
end

function BlackMarketShopCtr:onCreate()

    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self:updateCanShowConfig()
    
    self.cur_tag = btn_tab_list[1].tag

    local last_content_size = self:getContentSize()
    local cur_content_size = cc.size(ex.p.width - 20, ex.p.height - 350)
    local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

    self:setContentSize(cur_content_size)
    -- self:setPosition(ex.p.width / 2 - self:getContentSize().width / 2, ex.p.height / 2 - self:getContentSize().height / 2 + 50)

    local notch_height = require("src.model.Game"):instance():getNotchHeight()
    self.btn_close:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60,
                              self:getContentSize().height / 2 + ex.p.height / 2 / self:getScaleY() - 100 / self:getScaleY() - 42 - notch_height)

    self.btn_close:registerScriptTapHandler(handler(self, self.onBack))

    self.spr_image_bg = cc.Sprite:create("ccbi-res/shop_bg_2.jpg")
    self.spr_image_bg:setScale(ex.p.width / self.spr_image_bg:getContentSize().width, ex.p.height / self.spr_image_bg:getContentSize().height)
    self.spr_image_bg:setPosition(self:getContentSize().width * 0.5, self:getContentSize().height * 0.5)
    
    self:addChild(self.spr_image_bg, -1)
    -- dump(self.elem_node:getContentSize())
    self.bg:setPositionX(self.bg:getPositionX() + offset.x / 2)--, self.bg:getPositionY() + offset.y )
    -- self.list_bg:setPosition(self.list_bg:getPositionX() + offset.x / 2, self.list_bg:getPositionY() + offset.y )
    self.lbl_name:setPosition(self.lbl_name:getPositionX() + offset.x / 2, self.lbl_name:getPositionY())
    self.spr_bg:setPositionX(self.spr_bg:getPositionX() + offset.x / 2)
    self.tims_bg:setPosition(self.tims_bg:getPositionX() + offset.x / 2, self.tims_bg:getPositionY() + offset.y)
    self.effect:setPosition(self.effect:getPositionX() + offset.x / 2, self.effect:getPositionY() + offset.y)

    self.lbl_name:enableOutline(cc.c4b(37,54,84,255), 2)

    self:initDone()

    local heishi = sp.SkeletonAnimation:create("spine/heishi.json","spine/heishi.atlas", 1)
    heishi:setAnimation(0, "act", true);
    heishi:setPosition(0,0)
    self.effect:addChild(heishi)

    self.lbl_content = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(22)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#5A3509")
	:setAnchorTextShadow(true)
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	:setContentSize(cc.size(210, 0))
	:setPosition(cc.p(self.spr_bubble_bg:getPositionX() - 30, self.spr_bubble_bg:getPositionY() + 65))
	:setAnchorPoint(cc.p(1, 0))
    self.spr_bubble_bg:getParent():addChild(self.lbl_content)

    self.btn_go:setContentSize(cc.size(100, 50))
    self.btn_go:registerScriptTapHandler(handler(self, self.onGo))

	local size = self.spr_bg:getContentSize()
	size.width = size.width 
	size.height = size.height 
    self.tableView = ex.Tools:initTableView(self.spr_bg,{}, {require("src.layer.shop.ShopItemCell"),"ccbi/ShopItemCell.ccbi"}, size, 20 , cc.p(10,-30))
    self:addEvent(EVENT.SHOP_EVENT.UPDATE,handler(self,self.onChangeView))
    size.height = size.height - 70

    self.elem_node:setPositionX(self:getContentSize().width * 0.5)
    self.tableView2 = ex.Tools:initTableView(self.elem_node,{}, {require("src.layer.shop.ShopItemCell"),"ccbi/ShopItemCell.ccbi"}, size, 20 , cc.p(-size.width / 2, -(size.height + self.elem_bg:getContentSize().height / 2 + 5)))
    self.elem_node:setVisible(false)
    self.elem_node:setPositionX(self:getContentSize().width * 0.5)
    self.scroll_view_tab:setPositionX(self:getContentSize().width * 0.5)

    self:updateShop()
    
    self:updateBubble()
    self.node_bubble:setVisible(self.cur_tag == SHOP_TYPE.HERO)
end

function BlackMarketShopCtr:initScrollViewTab()
    local menu_tab = cpp.UIMenu:create()
    menu_tab:setIsTouchInsideNode(self.layer.scroll_view_tab)
    menu_tab:setSwallowsTouches(false)
    menu_tab:setPosition(cc.p(0, 0))
    self.layer.scroll_view_tab:addChild(menu_tab)

    -- 添加导航条
    local margin_x, space_x, item_size, scale = 4, 10, nil, 1
    for i, tab_data in ipairs(btn_tab_list) do
        self.layer[tab_data.name] = cpp.UIMenuItemTab:create("button/btn-tab-15.png", "button/btn-tab-16.png", "", 1, 1)

        local btn_tab = self.layer[tab_data.name]
        menu_tab:addChild(btn_tab)
        
        btn_tab:setChecked(tab_data.tag == self.cur_tag)

        if not item_size then 
            item_size = btn_tab:getContentSize()
            item_size.width = item_size.width * scale - 8
            item_size.height = item_size.height * scale
        end

        local is_select = tab_data.tag == self.cur_tag

        btn_tab:setScale(scale)
        btn_tab:setTag(tab_data.tag)
        btn_tab:registerScriptTapHandler(handler(self, self.onChange))
        btn_tab:setAnchorPoint(ex.a.bottom_center)
        btn_tab:setPosition(margin_x + (i - 0.5) * item_size.width + (i - 1) * space_x, 0)
        btn_tab:setLabelText(ex.Tools:getLang(tab_data.label))
        btn_tab:setLabelColor(is_select and cc.c4b(255, 255, 255, 255) or cc.c4b(37, 54, 84, 255))
        btn_tab:setLabelOffset(cc.p(0, -3))
    end
    self.layer.scroll_view_tab:setContentSize(cc.size(2 * margin_x + #btn_tab_list * item_size.width + (#btn_tab_list - 1) * space_x, self.layer.scroll_view_tab:getViewSize().height))
    self.layer.scroll_view_tab:setContentOffset(self.layer.scroll_view_tab:maxContainerOffset())
    
    self.btn_elem_select = require("src.layer.HeroElemSelect"):new()
    for i=0,5 do
        local btn = self["btn_elem" .. i]
        btn:setTag(i)
        self.btn_elem_select:bindSelect(btn)
        btn:registerScriptTapHandler(handler(self, self.onElem))
    end
    self.btn_elem_select:setSelected(ElemType.ALL)
end

-- 更新气泡文本
function BlackMarketShopCtr:updateBubble()
    -- 更新显示
    self.lbl_content:setXmlTextLua(ex.Tools:getLang(3652))
    self.lbl_content:formatText()
    self.spr_bubble_bg:setContentSize(cc.size(self.spr_bubble_bg:getContentSize().width, self.lbl_content:getContentSize().height + 80))
    -- self.lbl_go_under
    self.lbl_go:setString(ex.Tools:getLang(3651))
    self.lbl_go_under:setScaleX(self.lbl_go:getContentSize().width / self.lbl_go_under:getContentSize().width)
end

function BlackMarketShopCtr:onGo(tag, pSender)
    ex.JumpManager:jumpByAtom("act_daily_gift")
end

function BlackMarketShopCtr:onElem(tag, pSender)
    if self.cur_tag == tag then return end
    self.cur_elem = tag
    self.btn_elem_select:setSelected(tag)
    self.elem_data = ex.Player.market_data:filterHeroItemByElem(self.data,self.cur_elem)
    self.tableView2:initData(self.elem_data)
end

function BlackMarketShopCtr:onChange(tag,pSender)
    if self.cur_tag == tag then return end 
    self.cur_tag = tag 

    if self.cur_tag == SHOP_TYPE.PROPHECY then 
        self.cur_elem = 0 
        self.btn_elem_select:setSelected(0)
    end
    self:setTabLabelVisible()
    self:updateShop()

    self.node_bubble:setVisible(self.cur_tag == SHOP_TYPE.HERO)
end

function BlackMarketShopCtr:onShowCostInfo(tag,pSender)
    require("src.layer.BackpackInfoCtr"):instance():openWindow(pSender.item_type)
end

function BlackMarketShopCtr:setTabLabelVisible()
    for i, tab_data in ipairs(btn_tab_list) do
        local btn_tab = self[tab_data.name]
        local is_select = btn_tab:getTag() == self.cur_tag

        btn_tab:setLabelColor(is_select and cc.c4b(255, 255, 255, 255) or cc.c4b(37, 54, 84, 255))
        if is_select then
            local offset_x = self.layer.scroll_view_tab:getContentOffset().x
            local pos_x = btn_tab:getPositionX() + btn_tab:getContentSize().width / 2
            local view_width = self.layer.scroll_view_tab:getViewSize().width

            if pos_x + offset_x > view_width then
                self.layer.scroll_view_tab:setContentOffset(cc.p(view_width - pos_x,0))
            end
        end
    end
end

function BlackMarketShopCtr:onChangeView(event,data)
    local tableView = SHOP_TYPE.PROPHECY == self.cur_tag and self.tableView2 or self.tableView
    local offsetY = tableView:getContainer():getPositionY()
    self:updateShop(self.cur_tag)

    tableView:setContentOffset(cc.p(0,offsetY))

end

function BlackMarketShopCtr:updateRes( )
    local shop_type = self.cur_tag

    local charge_item = ex.Player.market_data:ChargeItemCostyType(shop_type)
    local conf = cfg.shopcontrol.shop[shop_type]

    self.res_node:setVisible(conf.cost_item ~= "")
    if not conf or conf.cost_item == "" then return end

    self.btn_cost:setNormalImage(cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", conf.cost_item)))
    self.btn_cost.item_type = conf.cost_item
    local num = ex.Player:getItemNum(conf.cost_item)
    self.lbl_num:setString(num)
end

function BlackMarketShopCtr:updateShop()

    -- 处理数据
    local data = ex.Player.market_data:getMarketDataByType(self.cur_tag)
    if not data then 
        ex.MessageView:add(self.cur_tag .. " shop type data is nil")
        return 
    end 
    
	if not self.shop_type then 
		for _,v in pairs(data) do
			self.shop_type = v.type
			break
		end
	end
	self.conf = ex.Player.market_data.cfg[self.shop_type]
	
	local shop_list = {}
	local cur_player_level = ex.Player.level
	for k,v in pairs(data) do
		local config = self.conf[v.idx]
		if config == nil or config.appear_level == nil or cur_player_level >= config.appear_level then
            table.insert(shop_list,v)
        end
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
		table.insert(tmp_data[idx],v)
		count = count + 1 
		if count % 3 == 0 then 
			idx = idx + 1
		end
	end

	self.data = tmp_data 
    if self.cur_tag ~= SHOP_TYPE.PROPHECY then 
        self.tableView:initData(self.data)
    else
        self.elem_data = ex.Player.market_data:filterHeroItemByElem(self.data,self.cur_elem)
        self.tableView2:initData(self.elem_data)
    end
    self.tableView:setVisible(self.cur_tag ~= SHOP_TYPE.PROPHECY)
    self.elem_node:setVisible(self.cur_tag == SHOP_TYPE.PROPHECY)
    self:updateRes()
    self.tims_bg:setVisible(false)

    local str = ""
    local conf = cfg.shopcontrol.shop[self.cur_tag]
    if conf.auto_refresh_mode == 2 then 
        str = ex.Tools:getLang(41233)
    elseif conf.auto_refresh_mode == 1 then 
        str = ex.Tools:getLang(41075)
    end
    self.lbl_tip:setString(str)
    self.tims_bg:setVisible(conf.auto_refresh_mode ~= 0)
end 


function BlackMarketShopCtr:onBack(tag , pSender)
    if not ex.MainSceneCtr:backLastLayer() then
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
    end
end


function BlackMarketShopCtr:initDone()
    self:initScrollViewTab()

    local data = ex.Player.market_data:getMarketDataByType(SHOP_TYPE.STALL)
    if not data then 
        ex.MessageView:add(ex.Tools:getLang(47239))
        return 
    end
end

return BlackMarketShopCtr