local SevenDayTargetCell = class("SevenDayTargetCell", require("src.comp.LuaLayerBase"))

function SevenDayTargetCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.progressTimer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("achievement/item-progress.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_progress_bg:addChild(self.progressTimer)
    self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2 ,self.spr_progress_bg:getContentSize().height / 2 )
    self.items = {}
    self:createMenuWithItem()

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

function SevenDayTargetCell:setTableView(table)
    self.tableView = table
    self.menu:setIsTouchInsideNode(self.tableView)
    self.menu_item:setIsTouchInsideNode(self.tableView)
end

function SevenDayTargetCell:setBtnString()
    self.lbl_btn_submit = cc.Label:createWithTTF(ex.Tools:getLang(47037), FONT_DEFAULT_NAME_BOLD, 24)
    self.btn_submit:addChild(self.lbl_btn_submit)
    self.lbl_btn_submit:setPosition(self.btn_submit:getContentSize().width * 0.5, self.btn_submit:getContentSize().height * 0.5)
    self.lbl_btn_submit:enableOutline(FONT_BROWN, 1)
    self.btn_submit:registerScriptTapHandler(handler(self, self.onClickSubmit))

    self.lbl_btn_goto = cc.Label:createWithTTF(ex.Tools:getLang(47627), FONT_DEFAULT_NAME_BOLD, 24)
    self.btn_goto:addChild(self.lbl_btn_goto)
    self.lbl_btn_goto:setPosition(self.btn_goto:getContentSize().width * 0.5, self.btn_goto:getContentSize().height * 0.5)
    self.lbl_btn_goto:enableOutline(FONT_BROWN, 1)
    self.btn_goto:registerScriptTapHandler(handler(self, self.onClickGoto))
end

function SevenDayTargetCell:onClickGoto(tag,pSender)
    -- ex.JumpManager:jumpByActType(self.data.type)--,self.jump_type)
    if self.data.jump_info.event_type == 1 then 
        local save_select_day = ex.Player.seventdaytarget_data.save_select_day
        local save_select_item = ex.Player.seventdaytarget_data.save_select_item
        local backToLayer =  function ( layer )
            if layer == nil then
                ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
            else
                layer:onClickItem(save_select_day)
                layer:onClickTab(save_select_item)
            end
        end
        local params = {}
        params.backToLayer = backToLayer

        ex.JumpManager:jumpByAtom(self.data.jump_info.event_arg, params)
    else
        ex.MessageView:add(ex.Tools:getLang(self.data.jump_info.no_jump_hint))
    end

end

function SevenDayTargetCell:onClickSubmit(tag,pSender)

	-- local req_reward = SevenDayTarget_pb.GReqSevenDayTargetReward()
    -- req_reward.idx = self.data.idx
    -- NetManager:sendMessage(ProtocolID.GReqSevenDayTargetReward,req_reward)
    
    ex.Player.seventdaytarget_data:gReqSevenDayTargetGetReward(self.data.idx)

end

function SevenDayTargetCell:createMenuWithItem()
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

function SevenDayTargetCell:updateMenuItem(data)
    local begin = 24
    local margin = 5
    local posY = 60
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
        local posX = (begin + (item:getContentSize().width + 10) * scale / 2) + (k - 1) * (((item:getContentSize().width + 10) * scale) + margin)
        item:setPosition(posX, posY)
        item:registerScriptTapHandler(handler(self, self.onClick))
        item:setScale(scale)
        self.menu_item:addChild(item)
    end

	-- for k,v in pairs(self.items) do
	-- 	if data[k] ~= nil then 
	-- 		v:onInit(data[k].item_type, data[k].item_num)
	-- 		v:initDone()
	-- 	end
	-- 	v:setVisible(data[k] ~= nil)
	-- end
end

function SevenDayTargetCell:onClick(tag,pSender)
	-- print(self.__cname,"onClick",pSender.item_type)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function SevenDayTargetCell:reset(data)
    -- dump(data)
	if not data then print("not data") return end
    self.data = data
    -- dump(data)

    -- data.vip_require
    -- local jump_type , layer_type = ex.JumpManager:getTaskTypeByJumpType(self.data.type)
    -- self.jump_type = jump_type
    local num --= 1
    if data.kind == SEVENT_DAY_TARGET_TYPE.TASK then 
        num = data.process
    elseif data.kind == SEVENT_DAY_TARGET_TYPE.BUY then 
        num = ex.Player:getItemNum(data.type)
    end
	self:setCompleted(num,data.task.targetNum)
	self:updateMenuItem(data.reward)
    local status = ex.Player.seventdaytarget_data:getSevenDayStatus(data.idx)
    
    local can_get = num >= data.task.targetNum and status < 1 
    self.btn_submit:setVisible(can_get)
	self.btn_goto:setVisible(not can_get and status < 1)
    self.btn_goto:setEnabled(layer_type ~= "")
    local color = layer_type ~= "" and FONT_DARK_BLUE or FONT_GRAY
    self.lbl_btn_goto:enableOutline(color, 1)

    -- print(language[data.type],data.num)
    self.progressTimer:setVisible(status < 1)
    self.lbl_progress:setVisible(status < 1)
    self.spr_progress_bg:setVisible(status < 1)
    self.lbl_title:setXmlTextLua(ex.Tools:taskString(data.lang,data.task.targetNum,data.task.condition))

    local geted = status == 1
    self.spr_geted:setVisible(geted)


end

function SevenDayTargetCell:setCompleted(count, need_num)
	if need_num < 1 then
		count = 0
		need_num = 1
	end

	if count >= need_num then
        self.progressTimer:setPercentage(100.0)
    else
        self.progressTimer:setPercentage(100.0 * count / need_num)
    end
    self.lbl_progress:setString(string.format("%d/%d", count, need_num))
end

return SevenDayTargetCell
