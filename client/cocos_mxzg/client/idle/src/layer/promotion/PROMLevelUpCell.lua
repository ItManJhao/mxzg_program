local PROMLevelUpCell = class("PROMLevelUpCell", require("src.comp.LuaLayerBase"))

local string_format = string.format
function PROMLevelUpCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.items = {}
    --self:createMenuWithItem()

    --self:setBtnString()

end

function PROMLevelUpCell:setBtnString()
    
    local strText = ""
    if ex.Player.level < self.data.main_level then
        strText = ex.Tools:getLang(2702)-- 前往
        self:setRedPoint(false)
	elseif ex.Player.level >= self.data.main_level and self.data.is_obtain == 0 then
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

function PROMLevelUpCell:setRedPoint(bool)
	ex.Tools:addRedPoint(self.btn_submit,bool)
end



function PROMLevelUpCell:onClickSubmit(tag,pSender)

    if ex.Player.level >= self.data.main_level and self.data.is_obtain == 0  then 
        -- local req = Promotion019_pb.GReqLevelUpGift()
        -- req.gift_id = self.data.idx
        -- NetManager:sendMessage(ProtocolID.GReqLevelUpGift, req)

        ex.Player.promotion_data:setSubLevelUpData(self.data.idx , 1)

        ex.Player.promotion_data:gReqLevelUpGift(self.data.idx)
        ex.Player.promotion_data:checkLevelUpAwardRedDot()

        ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS)
    else 
        --提示语句  41044
        --ex.MessageView:add(ex.Tools:getLang(41044))

        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
    end 
end

function PROMLevelUpCell:createMenuWithItem()
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

function PROMLevelUpCell:onClick(tag,pSender)
	-- print(self.__cname,"onClick")
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMLevelUpCell:updateMenuItem(data)

    for k,v in pairs(self.items) do
        if data[k] ~= nil then 
            v:onInit(data[k].item_type, data[k].item_num)
            v:initDone()
        end
        v:setVisible(data[k] ~= nil)
    end
end



function PROMLevelUpCell:updateItem( award_list)
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


function PROMLevelUpCell:reset(data)

    if not data then print("not data") return end
    self.data = data
    
    self:updateItem(data.reward)

    local str = string_format(ex.Tools:getLang(41043), data.hasNum)
    self.num_lab:setString(str)
    
    self.top_lab:setString(string_format(ex.Tools:getLang(41042), data.main_level, ex.Player.level, data.main_level))

    if data.is_obtain == 1   then 
        self.btn_submit:setEnabled(false)
        self.btn_submit:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-3.png"))
    end
    
    self:setBtnString()
end



return PROMLevelUpCell
