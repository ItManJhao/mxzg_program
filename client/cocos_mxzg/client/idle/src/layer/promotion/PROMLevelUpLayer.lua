local PROMLevelUpLayer = class("PROMLevelUpLayer", require("src.layer.promotion.PromotionBaseLayer"))

local ExTimer = require("src.ex.ExTimer")
local string_format = string.format

function PROMLevelUpLayer:onCreateDone()
    self:setSwallowTouches(false)
    self:setAutoClose(false)

    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(403))

    self:addTimeProgress()
    self:initdDone()

    self:addEvent(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS,handler(self,self.updateList))

    ex.Player.promotion_data:gReqLevelUpGiftList()
end


-- function PROMLevelUpLayer:addTimeProgress()
--     local top_y = self.layer_promotion:getTopY()
--     top_y = top_y - 20 - 106 - 30

--     local win_size = cc.Director:getInstance():getWinSize()
--     self.time_bg = cc.Sprite:createWithSpriteFrameName("promotion/spr-text-bg.png")

--     self.time_bg:setPosition(win_size.width * 0.5 + self.spr_banner:getContentSize().width * 0.3, top_y + self.spr_banner:getContentSize().height * 0.5)
--     self.time_bg:setScaleX(win_size.width / self.spr_banner:getContentSize().width)
--     self:addChild(self.time_bg)

--     self.time_text = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 24)
--     self.time_text:setPosition(self.time_bg:getContentSize().width ,self.time_bg:getContentSize().height * 0.5)
--     self.time_text:setTextColor(FONT_GREEN)
--     self.time_text:setAnchorPoint(1, 0.5)
--     self.time_bg:addChild(self.time_text)

-- end





function PROMLevelUpLayer:updateCDTime()
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

function PROMLevelUpLayer:onExit()
    -- 停止计时器
    self.timer:stop()
end

function PROMLevelUpLayer:initdDone()

    local bg_size = self.gift_list:getContentSize()

    self.cell_data =  self:sor(ex.Player.promotion_data.level_up_data.list)

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


    self.tableView = ex.Tools:initTableView(self,self.cell_data, {require("src.layer.promotion/PROMLevelUpCell"),"ccbi/PROMLevelUpCell.ccbi"} , viewSize, 7 , cc.p(posx, posy))


    self.reset_time = ex.Player.promotion_data.level_up_data.etime - ex.Game:getServerTime()
    self.timer = ExTimer:new():bind(self):run(handler(self, self.updateCDTime), 1.0)
    self:updateCDTime()

end


function PROMLevelUpLayer:updateList(event,data)
    if not self.tableView then return end
    local offsetY = self.tableView:getContainer():getPositionY()
    self.cell_data =  self:sor(ex.Player.promotion_data.level_up_data.list)
    self.tableView:initData(self.cell_data)
    self.tableView:reloadData()
    self.tableView:setContentOffset(cc.p(0,offsetY))
end



function  PROMLevelUpLayer:sor( data )
   if #data < 1 then return {} end

   local function sort_table (a,b)

        local sora = a.hasNum > 0 and 1 or 0
        local sorb = b.hasNum > 0 and 1 or 0

        if a.is_obtain == 0 and b.is_obtain == 1 then 
            return true
        elseif a.is_obtain == 1 and b.is_obtain == 0 then 
            return false
        else     
            return a.main_level < b.main_level
        end
        

   end 
    table.sort( data, sort_table )
    return data
end


return PROMLevelUpLayer
