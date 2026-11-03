local PROMTavernWeeklyLayer = class("PROMTavernWeeklyLayer", require("src.layer.promotion.PromotionBaseLayer"))

local ExTimer = require("src.ex.ExTimer")
local string_format = string.format

function PROMTavernWeeklyLayer:onCreateDone()
    self:setSwallowTouches(false)
    self:setAutoClose(false)
    
    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(420))

    local sub_size = cc.size(60, 60)
    self:resetScrollView(self.tableView, sub_size)

    self:addBtns()
    self:addTimeProgress()
    self:initdDone()

    self.node_banner:setPosition(self.spr_banner:getContentSize().width * 0.5 - 70,  self.spr_banner:getContentSize().height * 0.5 - 3)

    self:addEvent(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS,handler(self,self.updateList))
    
end


function PROMTavernWeeklyLayer:addBtns()
    local top_y = self.layer_promotion:getTopY()
    top_y = top_y - 20 - 106 - 30

    local win_size = cc.Director:getInstance():getWinSize()

    local menu_scene = cpp.UIMenu:create()
    menu_scene:setPosition(win_size.width * 0.5 + self.spr_banner:getContentSize().width * 0.3 - 10, top_y + self.spr_banner:getContentSize().height * 0.5 + 10)
    self:addChild(menu_scene)

    local rank_btn = cpp.UIMenuItemImage:createWithSpriteFrameName("promotion/spr-gift-rank.png", "promotion/spr-gift-rank.png", nil)
    rank_btn:registerScriptTapHandler(handler(self, self.showRankView))
    rank_btn:setPosition(-45,0)
    menu_scene:addChild(rank_btn)

    local gift_rank_tab = cpp.UIMenuItemImage:createWithSpriteFrameName("promotion/spr-gift-show.png", "promotion/spr-gift-show.png", nil)
    gift_rank_tab:registerScriptTapHandler(handler(self, self.showRankGiftView))
    gift_rank_tab:setPosition(55,0)
    menu_scene:addChild(gift_rank_tab)

end


function PROMTavernWeeklyLayer:showRankView( tag, pSender)
    -- require("src.layer.promotion.PROMTavernWeeklyCtr"):instance():openWindow()
    require("src.layer.RankTopThreeCtr"):instance():openWindow(RankTopThreeLayerType.PUB_TASK)
end

function PROMTavernWeeklyLayer:showRankGiftView( tag, pSender)
    --require("src.layer.promotion.PROMAdventureGiftCtr"):instance():openWindow()
    require("src.layer.promotion.PROMTavernWeeklyGiftCtr"):instance():openWindow()
end


function PROMTavernWeeklyLayer:updateCDTime()
    self.reset_time = self.reset_time - 1

    local show_msg = ""
        --表示倒计是结束，进入清算时间
    if self.reset_time > 86400 then
        show_msg = string_format(ex.Tools:getLang(41130),math.floor(self.reset_time / 86400))
    elseif self.reset_time > 0 and self.reset_time < 86400 then 
        show_msg = string_format(ex.Tools:getLang(41129), 
            math.floor(self.reset_time / 3600),
            math.floor(self.reset_time / 60 % 60),
            math.floor(self.reset_time % 60))
    else 
        show_msg = ex.Tools:getLang(41053)
    end
    self.time_text:setXmlTextLua(show_msg)
end

function PROMTavernWeeklyLayer:onExit()
    -- 停止计时器
    self.timer:stop()
end

function PROMTavernWeeklyLayer:initdDone()

    local bg_size = self.gift_list:getContentSize()

    self.cell_data =  self:sor(ex.Player.promotion_data.tavern_weekly_data.list)

    local sub_size = cc.size(60, 60)

    local viewSize = sub_size
    local posx = self.gift_list:getPositionX()
    local posy = self.gift_list:getPositionY()

    local win_size = cc.Director:getInstance():getWinSize()

	if  self.layer_promotion then
		local top_y = self.layer_promotion:getTopY()
		top_y = top_y - 20 - 95	-- banner高106
    	
        viewSize = cc.size(win_size.width  - sub_size.width, top_y - self.layer_promotion:getBottomY() - sub_size.height)
        posx = win_size.width * 0.5 - viewSize.width * 0.5
        posy = self.layer_promotion:getBottomY() + sub_size.height * 0.5
	end


    if viewSize.width > bg_size.width then 
        viewSize.width = bg_size.width
        posx = win_size.width * 0.5 - viewSize.width * 0.5
    end     

    self.tableView = ex.Tools:initTableView(self,self.cell_data, {require("src.layer.promotion.PROMTavernWeeklyCell"),"ccbi/PROMCompleteAwardCell.ccbi"} , viewSize, 7 , cc.p(posx, posy))

    self.reset_time = ex.Player.promotion_data.tavern_weekly_data.etime - ex.Game:getServerTime()
    self.timer = ExTimer:new():bind(self):run(handler(self, self.updateCDTime), 1.0)
    self:updateCDTime()

end


function PROMTavernWeeklyLayer:updateList(event,data)
    if not self.tableView then return end
    local offsetY = self.tableView:getContainer():getPositionY()
    self.cell_data =  self:sor(ex.Player.promotion_data.tavern_weekly_data.list)
    self.tableView:initData(self.cell_data)
    self.tableView:reloadData()
    self.tableView:setContentOffset(cc.p(0,offsetY))
end



function  PROMTavernWeeklyLayer:sor( data )
   if #data < 1 then return {} end

   local function sort_table (a,b)

        if a.is_obtain == 0 and b.is_obtain == 1 then 
            return true
        elseif a.is_obtain == 1 and b.is_obtain == 0 then 
            return false
        else     
            return a.idx < b.idx
        end
   end 
    table.sort( data, sort_table )
    return data
end


return PROMTavernWeeklyLayer

