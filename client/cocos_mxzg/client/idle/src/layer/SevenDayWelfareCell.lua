local SevenDayWelfareCell = class("SevenDayWelfareCell", require("src.comp.LuaLayerBase"))

function SevenDayWelfareCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.progressTimer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("other/spr-bg-2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    -- self.spr_progress_bg:addChild(self.progressTimer)
    -- self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2 )
    self.items = {}
    self:createMenuWithItem()
    self:initFont()
    self:setBtnString()

    self.lbl_title = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_title:setFontSize(44)
	self.lbl_title:setScale(0.5)
	self.lbl_title:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_title:setFontColor("#7A472D")
	self.lbl_title:setAnchorTextShadow(false)
	self.lbl_title:setAnchorPoint(ex.a.left_center)
    self.lbl_title:setPosition(cc.p(25, 125))
    self.lbl_title:setLocalZOrder(10)
    self:addChild(self.lbl_title)
end

function SevenDayWelfareCell:setTableView(table)
    self.tableView = table
    self.menu:setIsTouchInsideNode(self.tableView)
    self.menu_item:setIsTouchInsideNode(self.tableView)
end

function SevenDayWelfareCell:initFont()
    local color = self.lbl_old_price:getColor()
    self.lbl_old_price_title:enableOutline(color, 1)
    local offset = self.lbl_old_price_title:getPositionX() + self.lbl_old_price_title:getContentSize().width + 5
    local scale = self.spr_old_icon:getScale()
    offset = offset + self.spr_old_icon:getContentSize().width * scale / 2
    self.spr_old_icon:setPositionX(offset)
    offset = offset + self.spr_old_icon:getContentSize().width * scale / 2
    self.lbl_old_price:setPositionX(offset)
    self.spr_cur_icon:retain()
    self.lbl_cur_price:retain()
    self.spr_cur_icon:removeFromParent()
    self.lbl_cur_price:removeFromParent()
    self.btn_submit:addChild(self.spr_cur_icon)
    self.btn_submit:addChild(self.lbl_cur_price)
    local posY = self.btn_submit:getContentSize().height / 2
    self.spr_cur_icon:setPosition(30,posY + 2)
    self.lbl_cur_price:setPosition(45,posY)
    self.spr_cur_icon:release()
    self.lbl_cur_price:release()

end

function SevenDayWelfareCell:setBtnString()

    -- self.lbl_btn_submit = cc.Label:createWithTTF(ex.Tools:getLang(47172), FONT_DEFAULT_NAME_BOLD, 24)
    -- self.btn_submit:addChild(self.lbl_btn_submit)
    -- self.lbl_btn_submit:setPosition(self.btn_submit:getContentSize().width * 0.5, self.btn_submit:getContentSize().height * 0.5 + 2)
    -- self.lbl_btn_submit:enableOutline(FONT_BROWN, 1)
    self.btn_submit:registerScriptTapHandler(handler(self, self.onClickSubmit))

    self.lbl_btn_goto = cc.Label:createWithTTF(ex.Tools:getLang(47627), FONT_DEFAULT_NAME_BOLD, 24)
    self.btn_goto:addChild(self.lbl_btn_goto)
    self.lbl_btn_goto:setPosition(self.btn_goto:getContentSize().width * 0.5, self.btn_goto:getContentSize().height * 0.5 - 2)
    self.lbl_btn_goto:enableOutline(FONT_DARK_BLUE, 1)
    self.btn_goto:registerScriptTapHandler(handler(self, self.onClickGoto))
end

function SevenDayWelfareCell:onClickGoto(tag,pSender)
    -- if self.jump_type == nil then return end
    ex.JumpManager:jumpByActType(1201)--,3)
end

function SevenDayWelfareCell:onClickSubmit(tag,pSender)
    local num --= 1
    if self.data.kind == SEVENT_DAY_TARGET_TYPE.TASK then 
        num = 1
    elseif self.data.kind == SEVENT_DAY_TARGET_TYPE.BUY then 
        num = ex.Player:getItemNum(self.data.cost[1].item_type)
    end

    if self.data.cost[1].item_type > 900000 and num < self.data.cost[1].item_num then
        -- add 熊梦 self.data.type 值为nil 修改一下
        if self.data.kind == SEVENT_DAY_TARGET_TYPE.BUY then
            ex.MessageView:add(ex.Tools:getLang(1109)) -- 钻石不足
        else
            ex.Tools:showEnoughTip(self.data.type)
        end
        return
    end

    ex.Player.seventdaytarget_data:gReqSevenDayTargetGetReward(self.data.idx)

end

function SevenDayWelfareCell:createMenuWithItem()
	-- body
    local menu = cpp.UIMenu:create()
    self:addChild(menu)
    menu:setPosition(0,0)
    -- local UIItemBackpack = require("src.comp/menu/UIMenuItemBackpack")
    -- local begin = 24
    -- local margin = 5
    -- local posY = 46
    -- local scale = 0.6
    -- for i=1,5 do
    -- 	local item = UIItemBackpack:createWithData()
    -- 	local posX = (begin + item:getContentSize().width * scale / 2) + (i - 1) * ((item:getContentSize().width * scale) + margin)
    --     item:setPosition(posX, posY)
    --     item:registerScriptTapHandler(handler(self, self.onClick))
    --     item:setScale(scale)
    --     item:setVisible(false)
    --     menu:addChild(item)
    --     self.items[i] = item
    -- end
    self.menu_item = menu
end

function SevenDayWelfareCell:updateMenuItem(data)

	-- for k,v in pairs(self.items) do
	-- 	if data[k] ~= nil then 
	-- 		v:onInit(data[k].item_type, data[k].item_num)
	-- 		v:initDone()
	-- 	end
	-- 	v:setVisible(data[k] ~= nil)
	-- end

    local begin = 24
    local margin = 5
    local posY = 55
    local scale = 0.75

    self.menu_item:removeAllChildren()
    for k,v in pairs(data) do
        local item_tag = ex.Player.backpack_data:getPropType(v.item_type)
        local is_piece = ex.Player.backpack_data:isPiece(v.item_type)
        local item --= obj:createWithData(v.item_type,v.item_num)
        if item_tag == ItemData.IT_HERO_MATERIAL then
            local config_item = cfg.item.item[v.item_type]
            item = require("src.comp.menu.UIMenuItemHero"):createWithData("1", config_item.use_value, nil, 1, config_item.star)
            item.item_type = config_item.use_value
            -- item:setNum(v.item_num)
        elseif is_piece then 
            item = require("src.comp.menu.UIMenuItemHeroPiece"):createWithData(v.item_type)
            item:setNum(v.item_num)
        else
            item = require("src.comp.menu.UIMenuItemBackpack"):createWithData(v.item_type,v.item_num)
        end
        local posX = (begin + item:getContentSize().width * scale / 2) + (k - 1) * ((item:getContentSize().width * scale) + margin)
        item:setPosition(posX, posY)
        item:registerScriptTapHandler(handler(self, self.onClick))
        item:setScale(scale)
        self.menu_item:addChild(item)
    end
end

function SevenDayWelfareCell:onClick(tag,pSender)
	-- print(self.__cname,"onClick")
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function SevenDayWelfareCell:reset(data)
	if not data then print("not data") return end
    self.data = data

    self:updateMenuItem(data.reward)

    self.lbl_title:setXmlTextLua(ex.Tools:taskString(data.lang,data.task.targetNum,data.task.condition))


    -- local jump_type , layer_type = ex.JumpManager:getTaskTypeByJumpType(self.data.type)
    -- self.jump_type = jump_type

    local num --= 1
    if data.kind == SEVENT_DAY_TARGET_TYPE.TASK then 
        num = 1
    elseif data.kind == SEVENT_DAY_TARGET_TYPE.BUY then 
        num = ex.Player:getItemNum(data.type)
    end

    local status = ex.Player.seventdaytarget_data:getSevenDayStatus(data.idx)
    -- local can_get = num >= data.num and status < 1 and ex.Player.vip_level >= data.vip_require

    local can_get = status < 1 

    if self.data.cost[1].item_type < 900000 and num < self.data.cost[1].item_num then
        can_get = false
    end

    if self.data.cost[1].item_num == 0 and   self.data.state == 0 then 

        self:setRedPoint(can_get)

    end 



    self.btn_submit:setVisible(can_get)
    self.btn_goto:setVisible(not can_get and status < 1)

    local color = FONT_GRAY
    self.lbl_btn_goto:enableOutline(color, 1)
    local geted = status == 1
    self.spr_geted:setVisible(geted)
    self.lbl_cur_price:setString(data.cost[1].item_num)
end

function SevenDayWelfareCell:setRedPoint(bool)
	ex.Tools:addRedPoint(self.btn_submit,bool)
end



return SevenDayWelfareCell
