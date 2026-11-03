
local PROMMakeHeroLayer = class("PROMMakeHeroLayer", require("src.layer.promotion.PromotionBaseLayer"))

local ExTimer = require("src.ex.ExTimer")
local string_format = string.format

function PROMMakeHeroLayer:onCreateDone()
    self:setSwallowTouches(false)
    self:setAutoClose(false)
    
    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(504))
    
    self:addTimeProgress()
    self:initdDone()


    self:addEvent(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS,handler(self,self.updateList))
    
end




function PROMMakeHeroLayer:updateCDTime()
    self.reset_time = self.reset_time - 1

    if ex.Game:getServerTime()  <  ex.Player.promotion_data.mark_hero_data.stime then 
		self.time_text:setXmlTextLua(ex.Tools:getLang(41052));
		return 
	end 

	if self.reset_time < 0 then 
        self.time_text:setXmlTextLua(ex.Tools:getLang(41053));
        
        self:removeTimerByName("act_make_hero_timer")
		return
    end

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

function PROMMakeHeroLayer:initdDone()

    local bg_size = self.gift_list:getContentSize()

    self.cell_data =  self:sor(ex.Player.promotion_data.mark_hero_data.list)


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

    self.tableView = ex.Tools:initTableView(self,self.cell_data, {require("src.layer.promotion.PROMMakeHeroCell"),"ccbi/PROMCompleteAwardCell.ccbi"} , viewSize, 7 , cc.p(posx, posy))

    self.reset_time = ex.Player.promotion_data.mark_hero_data.etime - ex.Game:getServerTime()
    self:addTimer("act_make_hero_timer", 1000, handler(self, self.updateCDTime), true)
    self:updateCDTime()
end


function PROMMakeHeroLayer:updateList(event,data)
    if not self.tableView then return end
    local offsetY = self.tableView:getContainer():getPositionY()
    self.cell_data =  self:sor(ex.Player.promotion_data.mark_hero_data.list)
    self.tableView:initData(self.cell_data)
    self.tableView:reloadData()
    self.tableView:setContentOffset(cc.p(0,offsetY))
end



function  PROMMakeHeroLayer:sor( data )
   if #data < 1 then return {} end

   local function sort_table (a,b)
        local ais_obtain = a.cnt >= a.count and 1 or 0
        local bis_obtain = b.cnt >= b.count and 1 or 0

        if ais_obtain == 0 and bis_obtain == 1 then 
            return true
        elseif ais_obtain == 1 and bis_obtain == 0 then 
            return false
        else     
            return a.idx < b.idx
        end
   end 
    table.sort( data, sort_table )
    return data
end


return PROMMakeHeroLayer
