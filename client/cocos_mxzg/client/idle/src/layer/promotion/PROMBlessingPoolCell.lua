local PROMBlessingPoolCell = class("PROMBlessingPoolCell", require("src.comp.LuaLayerBase"))

local string_format = string.format
function PROMBlessingPoolCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.promotion_id = 37
    self.items = {}
    --self:createMenuWithItem()

    self.menu_item = cpp.UIMenu:create()
    :setPosition(cc.p(0, 0))
    self:addChild(self.menu_item)
end

function PROMBlessingPoolCell:setBtnString()
    local  strText = ""
    
    if ex.Player.promotion_data.blessing_pool_data.nvalue < self.data.count then
        strText = ex.Tools:getLang(2702)-- 前往
        self:setRedPoint(false)
	elseif ex.Player.promotion_data.blessing_pool_data.nvalue >= self.data.count and self.data.is_obtain == 0 then
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
    --self.btn_done:setScale(1)
end

function PROMBlessingPoolCell:onClickSubmit(tag,pSender)
    if not ex.Player.promotion_data:getTimeIsOpen(self.promotion_id) then
        ex.MessageView:add(ex.Tools:getLang(47324))
        return
    end

    if ex.Player.promotion_data.blessing_pool_data.nvalue >= self.data.count and self.data.is_obtain == 0  then 
        ex.Player.promotion_data:reqBlessingPoolGift(self.data.idx)
        ex.Player.promotion_data:setBlessingPoolData(self.data.idx, 1)
        
        ex.Player.promotion_data:checkBlessingPoolRedDot()

        ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS)

        ex.Player.promotion_data:checkIsNextRoundBlessingPool()
    else 
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_BLESSING_POOL)
    end 
end

function PROMBlessingPoolCell:createMenuWithItem()
    -- body

    local UIItemBackpack = require("src/comp/menu/UIMenuItemBackpack")
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
        self.menu_item:addChild(item)
        self.items[i] = item
    end
end


function PROMBlessingPoolCell:setTableView(table)
    self.tableView = table
    self.menu_item:setIsTouchInsideNode(self.tableView)
    self.menu_item:setSwallowsTouches(false)
end


function PROMBlessingPoolCell:onClick(tag,pSender)
	-- print(self.__cname,"onClick")
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMBlessingPoolCell:updateMenuItem(data)

    for k,v in pairs(self.items) do
        if data[k] ~= nil then 
            v:onInit(data[k].item_type, data[k].item_num)
            v:initDone()
        end
        v:setVisible(data[k] ~= nil)
    end
end

function PROMBlessingPoolCell:updateItem( award_list)
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
        self.menu_item:addChild(item)
    end

end

function PROMBlessingPoolCell:reset(data)

    if not data then print("not data") return end
    self.data = data
    
    self:updateItem(data.reward)

    local str = string_format("(%d/%d)",ex.Player.promotion_data.blessing_pool_data.nvalue, data.count)
    self.lbl_completed:setString(str)
    
    self.lbl_msg:setString(string_format(ex.Tools:getLang(41081), data.count))

    if data.is_obtain == 1   then 
        self.btn_done:setVisible(false)
        self.spr_get:setVisible(true)

    else
        self.spr_get:setVisible(false)
        self.btn_done:setVisible(true)
    end
    
    self:setBtnString()
end

function PROMBlessingPoolCell:setRedPoint(bool)
	ex.Tools:addRedPoint(self.btn_done,bool)
end

return PROMBlessingPoolCell