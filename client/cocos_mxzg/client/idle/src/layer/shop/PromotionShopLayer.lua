-- PromotionShopLayer

local PromotionShopLayer = class("PromotionShopLayer", require("src.comp.EventLayer"))

function PromotionShopLayer:onCreate()
    -- 奖品刷新时间

    local size = self.spr_bg:getContentSize()
	size.width = size.width - 20
    size.height = size.height - 20
    self:resetScaleAtWidth()
    self:addBlackBackground()
    
    self.tableView = ex.Tools:initTableView(self,{}, {require("src.layer.shop.PromotionShopItem"),"ccbi/ShopItemCell.ccbi"}, size, 5 , cc.p(self.spr_bg:getPositionX() + 10,self.spr_bg:getPositionY()))


    self:addEvent(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_REFRESH_DATA,handler(self,self.updateList))

end

function PromotionShopLayer:updateList(event,data)
	self:refresData()
	self:setItemNum()
end

function PromotionShopLayer:initDone(shop_name, shop_type, buy_protocol, buy_callback, time_callback)
	self.lbl_name:setString(shop_name)

	self.shop_type = shop_type
	self.buy_protocol = buy_protocol
	self.buy_callback = buy_callback
	self.time_callback = time_callback

    self.lbl_time:setVisible(false)
    self.btn_refresh:setVisible(false)

    if self.shop_type > 0 then
        self.spr_icon:setSpriteFrame(string.format("backpack/%d.png", self.shop_type))
        self:setItemNum()
    else
        self.res_node:setVisible(false)
    end
end


function PromotionShopLayer:updateShop(data, discount_list)

        local sor = function (a,b)
            return a.index < b.index		
        end
        table.sort(data,sor)

        local tmp_data = {}
        local idx = 1
        local count = 0
        for i,v in ipairs(data) do
            if not tmp_data[idx] then tmp_data[idx] = {} end

            if not  v.buy_callback then 
                v.buy_callback = self.buy_callback
            end 

            table.insert(tmp_data[idx],v)
            count = count + 1 
            if count % 3 == 0 then 
                idx = idx + 1
            end
        end
        
        self.data = tmp_data 

        self.tableView:initData(self.data)

end


function PromotionShopLayer:refresData( )

    local offsetY = self.tableView:getContainer():getPositionY()
    self.tableView:initData(self.data)
	self.tableView:setContentOffset(cc.p(0,offsetY))

    
end


function PromotionShopLayer:setRefreshNode(refresh_cost, cur_refresh, refresh_count, cur_free, free_count)
	self.refresh_node:removeAllChildren()

	local lbl_btn_txt = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 18)
    :enableOutline(FONT_DARK_BLUE, 1)
    self.refresh_node:addChild(lbl_btn_txt)

    local scale = 1.0

	if free_count == 0 or cur_free == 0 then
        lbl_btn_txt:setAnchorPoint(cc.p(0, 0.5))

        local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", refresh_cost.item_type))
        :setScale(0.4)
        self.refresh_node:addChild(spr_icon)
        
        if refresh_count > 0 then
            spr_icon:setPosition(-62, 0)

            lbl_btn_txt:setPosition(-45, 0)
            lbl_btn_txt:setString(string.format("%d %s(%d/%d)",
                refresh_cost.item_num,
                ex.Tools:getLang(2203), -- 刷新
                cur_refresh,
                refresh_count))

            --self.refresh_node:setScale(0.88)
            scale = 1.1
        else
            spr_icon:setPosition(-40, 0)

            lbl_btn_txt:setPosition(-20, 0)
            lbl_btn_txt:setString(string.format("%d %s",
                refresh_cost.item_num,
                ex.Tools:getLang(2203)))
        end
	else
		lbl_btn_txt:setPosition(0, 0)
        :setString(string.format(ex.Tools:getLang(2606),--ex.Tools:getLang(47135),
            cur_free, free_count))
	end

    self.refresh_node:setScale(1 / scale)
    self.btn_refresh:getNormalImage():setScaleX(scale)
    self.btn_refresh:getSelectedImage():setScaleX(scale)
end

function PromotionShopLayer:setItemNum()
    if self.shop_type == 0 then
       return
    end

	self.hasItemNum = ex.Player:getItemNum(self.shop_type)
    self.lbl_num:setString(tostring(self.hasItemNum))
end

function PromotionShopLayer:onExit()
    ex.Tools:autoPlaySceneMusic()
end

return PromotionShopLayer
