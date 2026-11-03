local PROMMakeHeroCell = class("PROMMakeHeroCell", require("src.comp.LuaLayerBase"))

local string_format = string.format
function PROMMakeHeroCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.items = {}

    self.menu_item = cpp.UIMenu:create()
    :setPosition(cc.p(0, 0))
    self:addChild(self.menu_item)

end

function PROMMakeHeroCell:setBtnString()
    
    local  strText = ""
    if self.data.cnt == self.data.hasNum and self.data.cnt <= self.data.count then
        strText = ex.Tools:getLang(2214) -- 领取

        self.btn_done:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-3.png"))
        self.btn_done:setEnabled(false)

	elseif self.data.cnt < self.data.hasNum and self.data.cnt < self.data.count then
		strText = ex.Tools:getLang(2214) -- 领取
		self:setRedPoint(true)
	else
        strText = ex.Tools:getLang(2703) -- 已领取
        self:setRedPoint(false)
	end

    self.lbl_btn_submit = cc.Label:createWithTTF(strText, FONT_DEFAULT_NAME_BOLD, 36)

    self.lbl_btn_submit:setScale(0.6)
    self.btn_done:addChild(self.lbl_btn_submit)
    self.lbl_btn_submit:setPosition(self.btn_done:getContentSize().width * 0.5, self.btn_done:getContentSize().height * 0.5)
    self.lbl_btn_submit:setTextColor(FONT_WHITE_C4B)
    self.lbl_btn_submit:enableOutline(FONT_RED, 3)

    self.btn_done:registerScriptTapHandler(handler(self, self.onClickSubmit))
    --self.btn_done:setScale(1)
end

function PROMMakeHeroCell:onClickSubmit(tag,pSender)
    if self.data.cnt < self.data.hasNum and self.data.cnt <= self.data.count  then 
        if not ex.Player.promotion_data:checkMakeHeroIsOpen() then
            ex.MessageView:add(ex.Tools:getLang(47324))
            return
        end

        local num = self.data.cnt + 1
        ex.Player.promotion_data:reqMarkHeroGift(self.data.idx)
        ex.Player.promotion_data:setMarkHeroData(self.data.idx, self.data.hasNum, num)
        ex.Player.promotion_data:checkMakeHeroRedDot()

        ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS)
    else 
        -- 前往事件

        --ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)

        local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
        require("src.layer.HeroCreatCtr"):instance():openWindow()

    end 
end


function PROMMakeHeroCell:setRedPoint(bool)
	ex.Tools:addRedPoint(self.btn_done,bool)
end


function PROMMakeHeroCell:createMenuWithItem()
    -- body
    local menu = cpp.UIMenu:create()
    self:addChild(menu)
    menu:setPosition(0,0)
    local UIItemBackpack = require("src/comp/menu/UIMenuItemBackpack")
    local begin = 24
    local margin = 5
    local posY = 55
    local scale = 0.75
    for i=1,5 do
        local item = UIItemBackpack:createWithData()
        local posX = (begin + item:getContentSize().width * scale / 2) + (i - 1) * ((item:getContentSize().width * scale) + margin)
        item:setPosition(posX, posY)
        item:registerScriptTapHandler(handler(self, self.onClick))
        item:setScale(scale)
        item:setVisible(false)
        menu:addChild(item)
        self.items[i] = item
    end
end

function PROMMakeHeroCell:onClick(tag,pSender)
	-- print(self.__cname,"onClick")
    ex.Tools:onClickItemInfo(pSender.item_type)
end


function PROMMakeHeroCell:updateMenuItem(data)

    for k,v in pairs(self.items) do
        if data[k] ~= nil then 
            v:onInit(data[k].item_type, data[k].item_num)
            v:initDone()
        end
        v:setVisible(data[k] ~= nil)
    end
end


function PROMMakeHeroCell:updateItem( award_list)


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


function PROMMakeHeroCell:setTableView(table)
    self.tableView = table
    self.menu_item:setIsTouchInsideNode(self.tableView)
    self.menu_item:setSwallowsTouches(false)
end


function PROMMakeHeroCell:reset(data)

    if not data then print("not data") return end
    self.data = data
    
    self:updateItem(data.reward)

    local str = string_format("(%d/%d)",data.cnt, data.count)
    self.lbl_completed:setString(str)
    
    self.lbl_msg:setString(string_format(ex.Tools:getLang(41080), data.star))


    if data.cnt >= data.count   then 
        self.btn_done:setVisible(false)
        self.spr_get:setVisible(true)
    else
        self.spr_get:setVisible(false)
        self.btn_done:setVisible(true)
    end
    
    self:setBtnString()
end



return PROMMakeHeroCell