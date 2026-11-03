local PROMPubArriveLayer = class("PROMPubArriveLayer", require("src.layer.promotion.PromotionBaseLayer"))
local PROMPubArriveCell = class("PROMPubArriveCell", require("src.comp.LuaLayerBase"))

function PROMPubArriveCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
end

function PROMPubArriveCell:initDone(data)
    self.data = data

    local lbl_desc = cpp.RichTextEx:createWithXMLLua("")
	lbl_desc:setFontSize(44)
	lbl_desc:setFontFace(FONT_DEFAULT_NAME_BOLD)
	lbl_desc:setFontColor("#613C19")
	lbl_desc:setScale(0.5)
	lbl_desc:setAnchorTextShadow(true)
	lbl_desc:ignoreContentAdaptWithSize(false)
	lbl_desc:setWrapMode(1)
	lbl_desc:setContentSize(self:getContentSize().width / 0.5, 36)
	lbl_desc:setPosition(16, self.num_lab:getPositionY())
    lbl_desc:setAnchorPoint(ex.a.left_center)
    if self.data.config.star == 0 then
        lbl_desc:setXmlTextLua(ex.Tools:getLang(41102))
    else
        lbl_desc:setXmlTextLua(string.format(ex.Tools:getLang(41101), ex.Tools:getTarvernRareName(self.data.config.star), self.data.config.num))
    end
	self:addChild(lbl_desc)

	self.num_lab:setString(string.format("(%d/%d)", self.data.progress, self.data.config.num))

    local str_label = ex.Tools:getLang(2702)    -- 前往
    ex.Tools:addRedPoint(self.btn_submit, false)
    self.btn_submit:setVisible(true)
    self.spr_got:setVisible(false)
    if self.data.progress >= self.data.config.num then
        if self.data.is_bought then
            str_label = ex.Tools:getLang(2703)      -- 已领取

            self.spr_got:setVisible(true)
            self.btn_submit:setVisible(false)
        else
            str_label = ex.Tools:getLang(2214)      -- 领取
            ex.Tools:addRedPoint(self.btn_submit, true)
            -- self.btn_submit:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-3.png"))
        end
    end
    self.btn_submit:setLabelText(str_label)
    
    -- local lbl_btn_txt = cc.Label:createWithTTF(str_label, FONT_DEFAULT_NAME_BOLD, 36)
    -- lbl_btn_txt:setTextColor(color)
    -- :setName("btn_txt")
    -- :setScale(0.5)
    -- :setPosition(self.btn_submit:getContentSize().width / 2, self.btn_submit:getContentSize().height / 2)
    -- self.btn_submit:addChild(lbl_btn_txt, 10)

	self.btn_submit:setTag(self.data.config.idx)
    self.btn_submit:setScale(1.2)
end

-- 设置已领取
function PROMPubArriveCell:setBought()
    self.btn_submit:setVisible(false)
    self.spr_got:setVisible(true)

    ex.Tools:addRedPoint(self.btn_submit, false)
end


-----------------------------------------------------------------------
function PROMPubArriveLayer:onCreateDone()
	self:setAutoClose(false)
    self:setSwallowTouches(false)

    -- 数据
    self.promotion_id = 32
    self.list = {}

    self:addTimeProgress()
    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(503))

	-- local sub_size = cc.size(20, 60)
    self:resetScrollView(nil, nil)

    -- self.lbl_time:setPositionY(self.scroll_view:getPositionY() - sub_size.height * 0.5 - 30)
    local banner_pos_x, banner_pos_y = self.spr_banner:getPosition()
    local banner_size = self.spr_banner:getContentSize()
    self.time_node:setPosition(cc.p(banner_pos_x + banner_size.width * self.spr_banner:getScaleX() / 2, banner_pos_y + banner_size.height * self.spr_banner:getScaleY() / 2 - self.time_bg:getContentSize().height * self.time_bg:getScaleY() / 2 - 2))
    self.time_node:setLocalZOrder(100)

    -- 活动刷新时间
    self:addTimer("act_pub_arrive_timer", 1000, handler(self, self.updateCDTime), true)
    self:updateCDTime()

    self:updateView()

    self:addEvent(EVENT.MAIN_CITY_PROMOTION, handler(self, self.updateView))
end

function PROMPubArriveLayer:updateCDTime()
    local remain_time = ex.Player.promotion_data.pub_arrive_info.end_time - ex.Game:getServerTime()

    if ex.Game:getServerTime()  <  ex.Player.promotion_data.pub_arrive_info.begin_time then 
		self.time_text:setXmlTextLua(ex.Tools:getLang(41052));
		return 
	end 

	if remain_time < 0 then 
        self.time_text:setXmlTextLua(ex.Tools:getLang(41053));
        
        self:removeTimerByName("act_pub_arrive_timer")
		return
    end

    if remain_time > 86400 then
    	-- 大于1天
    	-- 剩余时间：%d天
    	self.time_text:setXmlTextLua(string.format(ex.Tools:getLang(41130),
    		math.floor(remain_time / 86400)))
    else
        remain_time = math.max(0, remain_time)
    	-- 剩余时间：%d小时%d分%d秒
    	self.time_text:setXmlTextLua(string.format(ex.Tools:getLang(41129), 
        	math.floor(remain_time / 3600),
        	math.floor(remain_time / 60 % 60),
        	math.floor(remain_time % 60)))
    end
end

function PROMPubArriveLayer:generateData()
    -- 生成数据并排序
    self.list = {}
    for k, v in pairs(cfg.promotiontavern.promotiontavern) do

        local time_data = ex.Player.promotion_data:getPubArriveTimesInfo()

        if time_data.turns == v.turns then 
            local data = {}
            data.config = v
            data.progress = 0
            data.is_bought = false

            local info = ex.Player.promotion_data:getPubArriveDataForIdx(v.idx)
            if info ~= nil then
                data.progress = info.progress
                data.is_bought = info.is_bought == 1 and true or false
            end

            table.insert(self.list, data)
        end 
    end

    -- 领取过了的排后面,没领过的，完成度高的排在前，完成度相同的idx小的排在前
    table.sort(self.list, function(a, b)
        local score_a = 1000000 - a.config.idx
        if a.is_bought ~= true then
            if a.progress >= a.config.num then
                score_a = score_a + 10000000
            else
                score_a = score_a + 1000000
            end
        end
        local score_b = 1000000 - b.config.idx
        if b.is_bought ~= true then
            if b.progress >= b.config.num then
                score_b = score_b + 10000000
            else
                score_b = score_b + 1000000
            end
        end
        return score_a > score_b
	end)
end

function PROMPubArriveLayer:updateView()
    -- 生成数据
    self:generateData()
    -- dump(self.list, "list=======")
	self.scroll_view:getContainer():removeAllChildren()

	local viewSize = self.scroll_view:getViewSize()

	local cell_size = cc.size(620, 150)
	cell_size.height = cell_size.height + 4

	local cellLen = table.nums(self.list)
    local cont_height = math.max(cell_size.height * cellLen, viewSize.height)

    self.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))

    local start = cc.p(viewSize.width * 0.5, cont_height - cell_size.height * 0.5)
    for i,v in ipairs(self.list) do
    	local cell = self:createDailyCell(v)
    	:setPosition(start.x, start.y - (i - 1) * cell_size.height)
    	self.scroll_view:addChild(cell)
    end
end

function PROMPubArriveLayer:createDailyCell(data)
	local cell = PROMPubArriveCell:createWithCCBIFile("ccbi/PROMPubArriveCell.ccbi")
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
	for i,v in ipairs(data.config.reward) do
		local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        item:setPosition(start.x + goods_size.width * i, start.y)
        item:setScale(0.75)
        item:registerScriptTapHandler(handler(self, self.onBtnInfo))
        menu:addChild(item)
	end

    return cell
end

function PROMPubArriveLayer:onBtnInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMPubArriveLayer:onBtnGot(tag, pSender)
    local cell = pSender:getParent():getParent()

    if cell.data.progress < cell.data.config.num then
        self:onExit()
        -- 前往召唤
        ex.JumpManager:jumpByAtom("main_pub_task")
    else    -- 发送领取数据
        if not ex.Player.promotion_data:getTimeIsOpen(self.promotion_id) then
            ex.MessageView:add(ex.Tools:getLang(47324))
            return
        end

        if cell.data.is_bought then
            print("!!!已经领取过，界面异常")
            return
        end

        -- 发送消息给后端
        -- local req_get = cpp.ByteArray:create()
        -- req_get:writeInt(ProtocolID.GReqPubArriveGot)
        -- req_get:writeInt(cell.data.config.idx)
        -- cpp.NetManager:instance():sendByteArray(req_get)

        local req = Promotion032_pb.GReqPubArriveGot()
        req.idx = cell.data.config.idx
        NetManager:sendMessage(ProtocolID.GReqPubArriveGot, req)

        cell:setBought()

        local data = ex.Player.promotion_data:getPubArriveDataForIdx(cell.data.config.idx)
        if data ~= nil then
            data.is_bought = 1
            cell.data.is_bought = true
        end

        ex.Player.promotion_data:checkPubArriveRedDot()
    end
end


return PROMPubArriveLayer
