local PROMProphecytimesLayer = class("PROMProphecytimesLayer", require("src.layer.promotion.PromotionBaseLayer"))

local ExTimer = require("src.ex.ExTimer")
local string_format = string.format

------------------------------------------------------------------------------------------

function PROMProphecytimesLayer:onCreateDone()
    self:setSwallowTouches(false)
    self:setAutoClose(false)

    self.time_info = {}
    self.promotion_id = 41

    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(411), true)
    
    self:addTimeProgress()
    self:initDone()

    self:addEvent(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS,handler(self,self.updateList))
end

function PROMProphecytimesLayer:updateCDTime()
    local remain_time = self.time_info.end_time - ex.Game:getServerTime()

    if ex.Game:getServerTime()  <  self.time_info.start_time then 
		self.time_text:setXmlTextLua(ex.Tools:getLang(41052));
		return 
	end 

	if remain_time < 0 then 
        self.time_text:setXmlTextLua(ex.Tools:getLang(41053));
        
        self:removeTimerByName("act_prophecy_times_timer")
		return
    end

    local show_msg = ""
        --表示倒计是结束，进入清算时间
    if remain_time > 86400 then
        show_msg = string_format(ex.Tools:getLang(41130),math.floor(remain_time / 86400))
    else
        show_msg = string_format(ex.Tools:getLang(41129), 
            math.floor(remain_time / 3600),
            math.floor(remain_time / 60 % 60),
            math.floor(remain_time % 60))
    end
    self.time_text:setXmlTextLua(show_msg)
end

function PROMProphecytimesLayer:initDone()
    self:refreshTime()

    local bg_size = self.gift_list:getContentSize()

    self.cell_data =  self:sor(ex.Player.promotion_data.prophecy_data.list)

    local sub_size = cc.size(60, 60)

    local viewSize = sub_size
    local posx = self.gift_list:getPositionX()
    local posy = self.gift_list:getPositionY()

    local win_size = cc.Director:getInstance():getWinSize()
    
	if  self.layer_promotion then
		local top_y = self.layer_promotion:getTopY()
		top_y = top_y - 20 - 127	-- banner高106
    	

        viewSize = cc.size(win_size.width  - sub_size.width, top_y - self.layer_promotion:getBottomY() - sub_size.height)
        posx = win_size.width * 0.5 - viewSize.width * 0.5
        posy = self.layer_promotion:getBottomY() + sub_size.height * 0.5
	end


    if viewSize.width > bg_size.width then 
        viewSize.width = bg_size.width
        posx = win_size.width * 0.5 - viewSize.width * 0.5
    end

    self.tableView = ex.Tools:initTableView(self,self.cell_data, {require("src.layer.promotion/ProphecytimesCell"),"ccbi/PROMCompleteAwardCell.ccbi"} , viewSize, 7 , cc.p(posx, posy))
    
    --self.end_times:setPosition(posx, posy) 
    self:addTimer("act_prophecy_times_timer", 1000, handler(self, self.updateCDTime), true)
    self:updateCDTime()

    self.end_times:setString(string_format(ex.Tools:getLang(41234),ex.Player.promotion_data.prophecy_data.round) )

end

function PROMProphecytimesLayer:refreshTime()
    self.time_info = ex.Player.promotion_data:getPromotionDatas(self.promotion_id)
    if self.time_info == nil then
        self.time_info = {start_time = 0, end_time = 0, clear_time = 0}
    end
end

function PROMProphecytimesLayer:updateList(event,data)
    self:refreshTime()

    if not self.tableView then return end
    local offsetY = self.tableView:getContainer():getPositionY()
    self.cell_data =  self:sor(ex.Player.promotion_data.prophecy_data.list)
    self.tableView:initData(self.cell_data)
    self.tableView:reloadData()
    self.tableView:setContentOffset(cc.p(0,offsetY))

    self.end_times:setString(string_format(ex.Tools:getLang(41234),ex.Player.promotion_data.prophecy_data.round) )

end

function  PROMProphecytimesLayer:sor( data )
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


return PROMProphecytimesLayer
