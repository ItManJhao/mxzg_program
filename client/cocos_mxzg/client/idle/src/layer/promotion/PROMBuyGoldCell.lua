local PROMBuyGoldCell = class("PROMBuyGoldCell", require("src.comp.LuaLayerBase"))

local string_format = string.format
function PROMBuyGoldCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.items = {}
    --self:createMenuWithItem()
end

function PROMBuyGoldCell:setBtnString()
    
    local strText = ""
    if ex.Player.promotion_data.buy_gold_data.num < self.data.count then
        strText = ex.Tools:getLang(2702)-- 前往
        self:setRedPoint(false)
	elseif ex.Player.promotion_data.buy_gold_data.num >= self.data.count and self.data.is_obtain == 0 then
		strText = ex.Tools:getLang(2214) -- 领取
		self:setRedPoint(true)
	elseif self.data.is_obtain == 1 then
        strText = ex.Tools:getLang(2703) -- 已领取
        self:setRedPoint(false)
	end

    self.lbl_btn_submit = cc.Label:createWithTTF(strText, FONT_DEFAULT_NAME_BOLD, 36)

    self.lbl_btn_submit:setScale(0.6)
    self.btn_submit:addChild(self.lbl_btn_submit)
    self.lbl_btn_submit:setPosition(self.btn_submit:getContentSize().width * 0.5, self.btn_submit:getContentSize().height * 0.5 )
    self.lbl_btn_submit:setTextColor(FONT_WHITE_C4B)
    self.lbl_btn_submit:enableOutline(FONT_RED, 3)

    self.btn_submit:registerScriptTapHandler(handler(self, self.onClickSubmit))
    --self.btn_submit:setScale(1)
end

function PROMBuyGoldCell:setRedPoint(bool)
	ex.Tools:addRedPoint(self.btn_submit,bool)
end


function PROMBuyGoldCell:onClickSubmit(tag,pSender)

    if  ex.Player.promotion_data.buy_gold_data.num >= self.data.count then 
        ex.Player.promotion_data:reqBuyGoldGift(self.data.idx)        
        ex.Player.promotion_data:setBuyGoldData(self.data.idx, 1)
        
        ex.Player.promotion_data:checkBuyGoldRedDot()

        ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS)

    else 
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
        require("src.layer.BuyGoldCtr"):instance():openWindow()

    end 
end



function PROMBuyGoldCell:createMenuWithItem()
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

function PROMBuyGoldCell:onClick(tag,pSender)
	-- print(self.__cname,"onClick")
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMBuyGoldCell:updateMenuItem(data)

    for k,v in pairs(self.items) do
        if data[k] ~= nil then 
            v:onInit(data[k].item_type, data[k].item_num)
            v:initDone()
        end
        v:setVisible(data[k] ~= nil)
    end
end

function PROMBuyGoldCell:updateItem( award_list)
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


function PROMBuyGoldCell:reset(data)

    if not data then print("not data") return end
    self.data = data
    
    --self:updateMenuItem(data.reward)
    self:updateItem(data.reward)
    local str = string_format("(%d/%d)", ex.Player.promotion_data.buy_gold_data.num, data.count)
    self.num_lab:setString(str)
    
    self.top_lab:setString(string_format(ex.Tools:getLang(41054), data.count))

    if data.is_obtain == 1   then 
        self.spr_geted:setVisible(true)
        self.btn_submit:setVisible(false)
    else 
        self.spr_geted:setVisible(false)
        self.btn_submit:setVisible(true)
    end
    self:setBtnString()
    
end



return PROMBuyGoldCell