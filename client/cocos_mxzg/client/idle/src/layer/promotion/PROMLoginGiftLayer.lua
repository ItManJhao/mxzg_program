local PROMLoginGiftLayer = class("PROMLoginGiftLayer", require("src.layer.promotion.PromotionBaseLayer"))
local PROMLoginGiftCell = class("PROMLoginGiftCell", require("src.comp.LuaLayerBase"))

function PROMLoginGiftCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.lbl_desc = cpp.RichTextEx:createWithXMLLua("")
    self.lbl_desc:setFontSize(44)
    self.lbl_desc:setFontFace(FONT_DEFAULT_NAME_BOLD)
    self.lbl_desc:setFontColor("#613C19")
    self.lbl_desc:setScale(0.5)
    self.lbl_desc:setAnchorTextShadow(true)
    self.lbl_desc:ignoreContentAdaptWithSize(false)
    self.lbl_desc:setWrapMode(1)
    self.lbl_desc:setContentSize(self:getContentSize().width / 0.5, 36)
    self.lbl_desc:setPosition(16, self.num_lab:getPositionY())
    self.lbl_desc:setAnchorPoint(ex.a.left_center)
    self:addChild(self.lbl_desc)
end

function PROMLoginGiftCell:initDone(data)
    self.data = data

    self.lbl_desc:setXmlTextLua(string.format(ex.Tools:getLang(52701), self.data.need_login_day))

	self.num_lab:setString(string.format("(%d/%d)", ex.Player.promotion_data:currLoginGiftDays(), self.data.need_login_day))

    local is_got = ex.Player.promotion_data:isGotLoginGiftForIdx(self.data.idx)

    ex.Tools:addRedPoint(self.btn_submit, false)
    self.btn_submit:setVisible(not is_got)
    self.spr_got:setVisible(is_got)
    if not is_got then
        self.btn_submit:setLabelText(ex.Tools:getLang(52702))
        if ex.Player.promotion_data:currLoginGiftDays() >= self.data.need_login_day then
            ex.Tools:addRedPoint(self.btn_submit, true)
        end
    end
    
	self.btn_submit:setTag(self.data.idx)
    self.btn_submit:setScale(1.2)
end


-----------------------------------------------------------------------
function PROMLoginGiftLayer:onCreateDone()
	self:setAutoClose(false)
    self:setSwallowTouches(false)

    -- 数据
    self.promotion_id = 45
    self.data = {}

    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(424))

    local spr_bg = cc.Sprite:create("ccbi-res/promtion-login-gift-bg.png")
    spr_bg:setAnchorPoint(cc.p(0.5, 1))
    spr_bg:setPosition(self:getContentSize().width / 2, self.spr_banner:getPositionY() )
    spr_bg:setPositionY(spr_bg:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    spr_bg:setScale(ex.p.width / spr_bg:getContentSize().width)
    self:add(spr_bg, -1)

    self:resetScrollView(nil, nil)

    self.lbl_time = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_time:setFontSize(36)
	self.lbl_time:setScale(0.5)
	self.lbl_time:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_time:setFontColor("#ffffff")
	self.lbl_time:setAnchorTextShadow(false)
	-- self.lbl_time:ignoreContentAdaptWithSize(false)
	-- self.lbl_time:setWrapMode(1)
	self.lbl_time:setAnchorPoint(ex.a.right_center)
    self.lbl_time:setPosition(ex.Tools:getAbsolutePosition(cc.p(5, 0), CommonUIDefine.UIDefine.ComponentOriginType.RIGHT_TOP, self.time_node))
    self.lbl_time:setLocalZOrder(10)
	self.time_node:addChild(self.lbl_time)

    local banner_pos_x, banner_pos_y = self.spr_banner:getPosition()
    local banner_size = self.spr_banner:getContentSize()
    self.time_node:setPosition(cc.p(banner_pos_x + banner_size.width * self.spr_banner:getScaleX() / 2, banner_pos_y + banner_size.height * self.spr_banner:getScaleY() / 2 - self.time_bg:getContentSize().height * self.time_bg:getScaleY() / 2 - 2))
    self.time_node:setLocalZOrder(100)

    self:updateView()

    -- 活动刷新时间
    self:addTimer("login_gift_timer", 1000, handler(self, self.updateCDTime), true)
    self:updateCDTime()

    self:addEvent(EVENT.MAIN_CITY_PROMOTION.LOGINGIFT, handler(self, self.onEvent))
end

function PROMLoginGiftLayer:updateCDTime()
    local remain_time = self.data.time_info.end_time - ex.Game:getServerTime()

	if ex.Game:getServerTime()  <  self.data.time_info.start_time then 
		self.lbl_time:setXmlTextLua(ex.Tools:getLang(41052));
		return 
	end 

	if remain_time < 0 then 
        self.lbl_time:setXmlTextLua(ex.Tools:getLang(41053));
        
        self:removeTimerByName("login_gift_timer")
		return
	end

    if remain_time > 86400 then
    	-- 大于1天
    	-- 剩余时间：%d天
    	self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(41130),
    		math.floor(remain_time / 86400)))
    else
        remain_time = math.max(0, remain_time)
    	-- 剩余时间：%d小时%d分%d秒
    	self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(41129), 
        	math.floor(remain_time / 3600),
        	math.floor(remain_time / 60 % 60),
        	math.floor(remain_time % 60)))
    end
end

function PROMLoginGiftLayer:generateData()
    -- 生成数据并排序
    self.data.data = {}
    self.data.time_info = ex.Player.promotion_data:getPromotionDatas(self.promotion_id)
    self.data.days = ex.Player.promotion_data:currLoginGiftDays()
    self.data.config = ex.Player.promotion_data:getLoginGiftConfig()

    -- 领取过了的排后面,没领过的，完成度高的排在前，完成度相同的idx小的排在前
    table.sort(self.data.config, function(a, b)
        local a_is_got = ex.Player.promotion_data:isGotLoginGiftForIdx(a.idx)
        local b_is_got = ex.Player.promotion_data:isGotLoginGiftForIdx(b.idx)

        if a_is_got and b_is_got then return a.idx < b.idx end

        if a_is_got then return false end
        if b_is_got then return true end

        local a_can_get = self.data.days >= a.need_login_day
        local b_can_get = self.data.days >= b.need_login_day

        if a_can_get and b_can_get then return a.idx < b.idx end

        if a_can_get then return true end
        if b_can_get then return false end

        return a.idx < b.idx
	end)
end

function PROMLoginGiftLayer:updateView()
    -- 生成数据
    self:generateData()
    -- dump(self.data, "list=======")
	self.scroll_view:getContainer():removeAllChildren()

	local viewSize = self.scroll_view:getViewSize()

	local cell_size = cc.size(620, 150)
	cell_size.height = cell_size.height + 4

	local cellLen = table.nums(self.data.config)
    local count_height = math.max(cell_size.height * cellLen, viewSize.height)

    self.scroll_view:setContentSize(cc.size(viewSize.width, count_height))
    self.scroll_view:setContentOffset(cc.p(0, viewSize.height - count_height))

    local start = cc.p(viewSize.width * 0.5, count_height - cell_size.height * 0.5)
    for i,v in ipairs(self.data.config) do
    	local cell = self:createCell(v)
    	cell:setPosition(start.x, start.y - (i - 1) * cell_size.height)
    	self.scroll_view:addChild(cell)
    end
end

function PROMLoginGiftLayer:createCell(data)
	local cell = PROMLoginGiftCell:createWithCCBIFile("ccbi/PROMLoginGiftCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
	cell:setAnchorPoint(ex.a.center)
	cell:setScale(self.scroll_view:getViewSize().width / (cell:getContentSize().width + 2))
   
    cell:initDone(data)

	cell.btn_submit:registerScriptTapHandler(handler(self, self.onBtnGot))
	cell.menu:setIsTouchInsideNode(self.scroll_view)
    cell.menu:setSwallowsTouches(false)

    -- 商品
    local menu = cpp.UIMenu:create()
    menu:setIsTouchInsideNode(self.scroll_view)
    menu:setSwallowsTouches(false)
    menu:setPosition(cc.p(0, 0))
    cell:addChild(menu)

	local goods_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
    goods_size.width = goods_size.width * 0.75 + 10

    local start = cc.p(-20, 55)
	for i,v in ipairs(data.reward) do
		local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        item:setPosition(start.x + goods_size.width * i, start.y)
        item:setScale(0.75)
        item:registerScriptTapHandler(handler(self, self.onBtnInfo))
        menu:addChild(item)
	end

    return cell
end

function PROMLoginGiftLayer:onEvent(event, ui_event)
    self:updateCDTime()

    self:updateView()
end

function PROMLoginGiftLayer:onBtnInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMLoginGiftLayer:onBtnGot(tag, pSender)
    local cell = pSender:getParent():getParent()

    if cell.data.need_login_day > self.data.days then
        ex.MessageView:add(string.format(ex.Tools:getLang(52703), cell.data.need_login_day))
    else    -- 发送领取数据
        if not ex.Player.promotion_data:getTimeIsOpen(self.promotion_id) then
            ex.MessageView:add(ex.Tools:getLang(47324))
            return
        end

        if ex.Player.promotion_data:isGotLoginGiftForIdx(cell.data.idx) then
            print("!!!已经领取过，界面异常")
            self:updateView()
            return
        end

        local req = Promotion045_pb.GReqLoginGiftReward()
        req.idx = cell.data.idx
        NetManager:sendMessage(ProtocolID.GReqLoginGiftReward, req)

        -- ex.Player.promotion_data:checkPubArriveRedDot()
    end
end


return PROMLoginGiftLayer
