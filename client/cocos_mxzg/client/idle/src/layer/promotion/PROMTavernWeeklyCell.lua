local PROMTavernWeeklyCell = class("PROMTavernWeeklyCell", require("src.comp.LuaLayerBase"))

local string_format = string.format
function PROMTavernWeeklyCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.items = {}
    --self:createMenuWithItem()

end

function PROMTavernWeeklyCell:setBtnString()

    local  strText = ""
    
    if ex.Player.promotion_data.tavern_weekly_data.nvalue < self.data.count then
        strText = ex.Tools:getLang(2702)-- 前往
        self:setRedPoint(false)
	elseif ex.Player.promotion_data.tavern_weekly_data.nvalue >= self.data.count and self.data.is_obtain == 0 then
		strText = ex.Tools:getLang(2214) -- 领取
		self:setRedPoint(true)
	elseif self.data.is_obtain == 1 then
        strText = ex.Tools:getLang(2703) -- 已领取
        self:setRedPoint(false)
	end

    self.lbl_btn_submit = cc.Label:createWithTTF(strText, FONT_DEFAULT_NAME_BOLD, 36)

    self.lbl_btn_submit:setScale(0.6)
    self.btn_done:addChild(self.lbl_btn_submit)
    self.lbl_btn_submit:setPosition(self.btn_done:getContentSize().width * 0.5, self.btn_done:getContentSize().height * 0.5 )
    self.lbl_btn_submit:setTextColor(FONT_WHITE_C4B)
    self.lbl_btn_submit:enableOutline(FONT_RED, 3)

    self.btn_done:registerScriptTapHandler(handler(self, self.onClickSubmit))

end

function PROMTavernWeeklyCell:onClickSubmit(tag,pSender)

    if ex.Player.promotion_data.tavern_weekly_data.nvalue >= self.data.count and self.data.is_obtain == 0  then 

        ex.Player.promotion_data:reqTavernWeeklyGift(self.data.idx)
        ex.Player.promotion_data:setTavernWeeklyData(self.data.idx, 1)

        ex.Player.promotion_data:checkTavernWeeklyRedDot()

        ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS)
    else 
        -- 前往事件
        -- ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_PUB_TASK)
        if self.data.jump_info.event_type == 1 then 
            ex.JumpManager:jumpByAtom(self.data.jump_info.event_arg)
        else
            ex.MessageView:add(ex.Tools:taskString(self.data.jump_info.no_jump_hint))
        end

    end 
end

function PROMTavernWeeklyCell:createMenuWithItem()
    -- body
    local menu = cpp.UIMenu:create()
    self:addChild(menu)
    menu:setPosition(0,0)
    local UIItemBackpack = require("src.comp/menu/UIMenuItemBackpack")
    local begin = 24
    local margin = 5
    local posY = 55
    local scale = 0.75
    for i=1,5 do
        local item = UIItemBackpack:createWithData()
        local posX = (begin + item:getContentSize().width * scale / 2) + (i - 1) * ((item:getContentSize().width * scale) + margin)
        item:setPosition(posX, posY)
        item:setScale(scale)
        item:registerScriptTapHandler(handler(self, self.onClick))
        item:setVisible(false)
        menu:addChild(item)
        self.items[i] = item
    end
end

function PROMTavernWeeklyCell:onClick(tag,pSender)
	-- print(self.__cname,"onClick")
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMTavernWeeklyCell:updateMenuItem(data)

    for k,v in pairs(self.items) do
        if data[k] ~= nil then 
            v:onInit(data[k].item_type, data[k].item_num)
            v:initDone()
        end
        v:setVisible(data[k] ~= nil)
    end
end


function PROMTavernWeeklyCell:updateItem( award_list)
    local menu = cpp.UIMenu:create()
    :setPosition(cc.p(0, 0))
    self:addChild(menu)

    local goods_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
    goods_size.width = goods_size.width * 0.75 + 10

    local begin = 24
    local margin = 5
    local posY = 55
    local scale = 0.75
    for i,v in ipairs(award_list) do
        local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        local posX = (begin + item:getContentSize().width * scale / 2) + (i - 1) * ((item:getContentSize().width * scale) + margin)
    	
        item:setPosition(posX, posY)
        item:setScale(scale)
        item:registerScriptTapHandler(handler(self, self.onClick))
        menu:addChild(item)
    end

end


function PROMTavernWeeklyCell:reset(data)

    if not data then print("not data") return end
    self.data = data
    
    self:updateItem(data.reward)

    local str = string_format("(%d/%d)",ex.Player.promotion_data.tavern_weekly_data.nvalue, data.count)
    self.lbl_completed:setString(str)
    
    self.lbl_msg:setString(string_format(ex.Tools:getLang(41111), data.count))
    --self.lbl_msg:setString(string_format(ex.Tools:getLang(47084), data.count))

    if data.is_obtain == 1   then 
        self.btn_done:setVisible(false)
        self.spr_get:setVisible(true)

    else
        self.spr_get:setVisible(false)
        self.btn_done:setVisible(true)
    end
    
    self:setBtnString()
end

function PROMTavernWeeklyCell:setRedPoint(bool)
	ex.Tools:addRedPoint(self.btn_done,bool)
end

return PROMTavernWeeklyCell