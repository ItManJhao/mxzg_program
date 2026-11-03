local PROMSummonCrystalLayer = class("PROMSummonCrystalLayer", require("src.layer.promotion.PromotionBaseLayer"))
local PROMSummonCrystalCell = class("PROMSummonCrystalCell", require("src.comp.LuaLayerBase"))

local ExTimer = require("src.ex.ExTimer")

function PROMSummonCrystalCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
end

function PROMSummonCrystalCell:initDone(data)
    self.data = data

    local lbl_desc = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(44)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#613C19")
	:setScale(0.5)
	:setAnchorTextShadow(true)
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	:setContentSize(self:getContentSize().width / 0.5, 36)
	:setPosition(16, self.num_lab:getPositionY())
	:setAnchorPoint(ex.a.left_center)
    :setXmlTextLua(string.format(ex.Tools:getLang(41082), self.data.config.num, ex.Tools:getLang(data.config.elem + 51000), self.data.config.star))
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
function PROMSummonCrystalCell:setBought()
    self.btn_submit:setVisible(false)
    self.spr_got:setVisible(true)

    ex.Tools:addRedPoint(self.btn_submit, false)
end


-----------------------------------------------------------------------
function PROMSummonCrystalLayer:onCreateDone()
	self:setAutoClose(false)
    self:setSwallowTouches(false)

    -- 数据
    self.time_info = {}
    self.promotion_id = 43
    self.list = {}
    
    self:addTimeProgress()

    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(412))

    -- local sub_size = cc.size(20, 60)
    self:resetScrollView(nil, nil)

    local banner_pos_x, banner_pos_y = self.spr_banner:getPosition()
    local banner_size = self.spr_banner:getContentSize()
    self.time_node:setPosition(cc.p(banner_pos_x + banner_size.width * self.spr_banner:getScaleX() / 2, banner_pos_y + banner_size.height * self.spr_banner:getScaleY() / 2 - self.time_bg:getContentSize().height * self.time_bg:getScaleY() / 2 - 2))
    self.time_node:setLocalZOrder(100)

    self:updateStarView()
end

function PROMSummonCrystalLayer:updateCDTime()
    local remain_time = self.time_info.end_time - ex.Game:getServerTime()

    if ex.Game:getServerTime()  <  self.time_info.start_time then 
		self.time_text:setXmlTextLua(ex.Tools:getLang(41052));
		return 
	end 

	if remain_time < 0 then 
        self.time_text:setXmlTextLua(ex.Tools:getLang(41053));
        
        self:removeTimerByName("act_summon_crystal_timer")
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

function PROMSummonCrystalLayer:generateData()
    self.time_info = ex.Player.promotion_data:getPromotionDatas(self.promotion_id)
    if self.time_info == nil then
        self.time_info = {start_time = 0, end_time = 0, clear_time = 0}
    end

    -- 生成数据并排序
    self.list = {}
    for k, v in pairs(cfg.promotionsummontarget.promotionsummontarget) do
        local data = {}
        data.config = v
        data.progress = 0
        data.is_bought = false

        local info = ex.Player.promotion_data:getSummonCrystalDataForIdx(v.idx)
        if info ~= nil then
            data.progress = info.progress
            data.is_bought = info.is_bought
        end

        table.insert(self.list, data)
    end

    -- 领取过了的排后面,没领过的，完成度高的排在前，完成度相同的idx小的排在前
	table.sort(self.list, function(a, b)
		if a.is_bought then
      		if b.is_bought then
        		return a.config.idx < b.config.idx
      		end
      		return false
    	else
      		if b.is_bought then
        		return true
            end
            
            -- local rate = (a.progress / a.config.num) / (b.progress / b.config.num)
            -- if rate == 1 then
            --     return a.config.idx < b.config.idx
            -- else
            --     return (a.progress / a.config.num) > (b.progress / b.config.num)
            -- end
            return a.config.idx < b.config.idx
    	end
	end)
end

function PROMSummonCrystalLayer:updateStarView()
    -- 生成数据
    self:generateData()

    -- 活动刷新时间
    self:addTimer("act_summon_crystal_timer", 1000, handler(self, self.updateCDTime), true)
    self:updateCDTime()
    
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

function PROMSummonCrystalLayer:createDailyCell(data)
	local cell = PROMSummonCrystalCell:createWithCCBIFile("ccbi/PROMSummonCrystalCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
	cell:setAnchorPoint(ex.a.center)
	cell:setScale(self.scroll_view:getViewSize().width / (cell:getContentSize().width + 2))
   
    cell:initDone(data)

	cell.btn_submit:registerScriptTapHandler(handler(self, self.onBtnSubmit))
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

function PROMSummonCrystalLayer:onBtnInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMSummonCrystalLayer:onBtnSubmit(tag, pSender)
    local cell = pSender:getParent():getParent()

    if cell.data.progress < cell.data.config.num then
        self:onExit()
        -- 前往召唤
        ex.JumpManager:jumpByAtom("main_summon")
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
        local req = Promotion043_pb.GReqSummonCrystalGet()
        req.idx = cell.data.config.idx
        NetManager:sendMessage(ProtocolID.GReqSummonCrystalGet, req)

        cell:setBought()

        local data = ex.Player.promotion_data:getSummonCrystalDataForIdx(cell.data.config.idx)
        if data ~= nil then
            data.is_bought = true
            cell.data.is_bought = true
        end

        ex.Player.promotion_data:checkSummonCrystalRedDot()
    end
end


return PROMSummonCrystalLayer
