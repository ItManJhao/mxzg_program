local PROMExchangeShopLayer = class("PROMExchangeShopLayer", require("src.layer.promotion.PromotionBaseLayer"))
local PROMExchangeShopCell = class("PROMExchangeShopCell", require("src.comp.LuaLayerBase"))

function PROMExchangeShopCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.nodes = {
        {
            root = self.exchange_mode_1,
            items = {
                {
                    node = self.item_1_1,
                    lbl_num = self.lbl_num_1_1,
                    item = nil
                },
                {
                    node = self.item_1_2,
                    lbl_num = self.lbl_num_1_2,
                    item = nil
                },
                {
                    node = self.item_1_3,
                    item = nil
                }
            }
        },
        {
            root = self.exchange_mode_2,
            items = {
                {
                    node = self.item_2_1,
                    lbl_num = self.lbl_num_2_1,
                    item = nil
                },
                {
                    node = self.item_2_2,
                    item = nil
                }
            }
        }
    }

    self.btn_submit:setLabelText(ex.Tools:getLang(52753))
end

function PROMExchangeShopCell:initDone(data)
    self.data = data

	self.num_lab:setString(string.format(ex.Tools:getLang(52752), self.data.bought_num.."/"..self.data.config.limit))


    local item_show = true
    local temp = 0
    for i,v in ipairs(self.data.config.need_item) do
        temp = ex.Player:getItemNum(v.item_type)
        if temp < v.item_num then
            item_show = false
            break
        end
    end
    local is_got = self.data.bought_num >= self.data.config.limit
    local show_red = false
    if not is_got and self.data.config.show_red_dot == 1 and item_show then
        show_red = true
    end
   
    ex.Tools:addRedPoint(self.btn_submit, show_red,cc.p(0.95, 0.85))

    self.btn_submit:setVisible(not is_got)
    self.spr_got:setVisible(is_got)
    
	self.btn_submit:setTag(self.data.config.idx)
    self.btn_submit:setScale(1.2)

    self:refreshItems()
end

function PROMExchangeShopCell:refreshItems()
    local mode = #self.data.config.need_item == 1 and 2 or 1

    self.nodes[1].root:setVisible(mode == 1)
    self.nodes[2].root:setVisible(mode == 2)

    local parent = self.nodes[mode]

    local index = 1
    for i,v in ipairs(self.data.config.need_item) do
        local current_num = ex.Player:getItemNum(v.item_type)

        if current_num >= v.item_num then
            parent.items[index].lbl_num:setColor(cc.c3b(0, 140, 0))
        else
            parent.items[index].lbl_num:setColor(cc.c3b(202, 10, 10))
        end

        if v.item_type == ItemType.IT_GEM then  -- 钻石数量只显示需求的数量
            parent.items[index].lbl_num:setString(tostring(v.item_num))
        else
            parent.items[index].lbl_num:setString(ex.StringUtil.getScientificNumber(current_num).."/"..ex.StringUtil.getScientificNumber(v.item_num))
        end

        parent.items[index].item = ex.Player.backpack_data:createWithData(v.item_type, 0)
        parent.items[index].item:setPosition(parent.items[index].node:getPosition())
        parent.items[index].item:setScale(0.75)
        parent.items[index].item:registerScriptTapHandler(handler(self, self.onBtnInfo))
        self.menu:addChild(parent.items[index].item)

        index  = index + 1
    end
    for i,v in ipairs(self.data.config.reward) do
        parent.items[index].item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        parent.items[index].item:setPosition(parent.items[index].node:getPosition())
        parent.items[index].item:setScale(0.75)
        parent.items[index].item:registerScriptTapHandler(handler(self, self.onBtnInfo))
        self.menu:addChild(parent.items[index].item)
    end
end

-- 设置已领取
function PROMExchangeShopCell:onBtnInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


-----------------------------------------------------------------------
function PROMExchangeShopLayer:onCreateDone()
	self:setAutoClose(false)
    self:setSwallowTouches(false)

    -- 数据
    self.promotion_id = 46
    self.time_info = {}
    self.data = {}

    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(710))

    self:resetScrollView(nil, nil)

    self.lbl_time = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_time:setFontSize(36)
	self.lbl_time:setScale(0.5)
	self.lbl_time:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_time:setFontColor("#ffffff")
	self.lbl_time:setAnchorTextShadow(false)
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
    self:addTimer("exchange_shop_timer", 1000, handler(self, self.updateCDTime), true)
    self:updateCDTime()

    self:addEvent(EVENT.MAIN_CITY_PROMOTION.EXCHANGE_SHOP, handler(self, self.onEvent))
end

function PROMExchangeShopLayer:updateCDTime()
    if self.time_info == nil or self.time_info.end_time == nil or self.time_info.end_time <= 0 then
        return
    end

    local remain_time = self.time_info.end_time - ex.Game:getServerTime()

    if ex.Game:getServerTime()  <  self.time_info.start_time then 
		self.lbl_time:setXmlTextLua(ex.Tools:getLang(41052));
		return 
	end 

	if remain_time < 0 then 
        self.lbl_time:setXmlTextLua(ex.Tools:getLang(41053));
        
        self:removeTimerByName("exchange_shop_timer")
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

function PROMExchangeShopLayer:generateData()
    -- 生成数据并排序
    self.time_info = ex.Player.promotion_data:getPromotionDatas(self.promotion_id)
    self.data = {}
    local config_table = ex.Player.promotion_data:getExchangeShopConfig()
    for k, v in pairs(config_table) do
        table.insert(self.data, {
            bought_num = ex.Player.promotion_data:getExchangeShopBoughtTimes(v.idx),
            config = v
        })
    end

    -- 领取过了的排后面,没领过的，完成度高的排在前，完成度相同的idx小的排在前
    table.sort(self.data, function(a, b)
        local a_is_over = a.bought_num >= a.config.limit
        local b_is_over = b.bought_num >= b.config.limit

        if a_is_over and b_is_over then return a.config.idx < b.config.idx end

        if a_is_over then return false end
        if b_is_over then return true end

        return a.config.idx < b.config.idx
	end)
end

function PROMExchangeShopLayer:updateView()
    -- 生成数据
    self:generateData()
    -- dump(self.data, "list=======")
	self.scroll_view:getContainer():removeAllChildren()

	local viewSize = self.scroll_view:getViewSize()

    local cell_size = cc.size(620, 130)
    local cell_scale = viewSize.width / (cell_size.width + 2)
	cell_size.height = (cell_size.height + 4) * cell_scale

	local cellLen = table.nums(self.data)
    local cont_height = math.max(cell_size.height * cellLen, viewSize.height)

    self.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))

    local start = cc.p(viewSize.width * 0.5, cont_height - cell_size.height * 0.5)
    for i,v in ipairs(self.data) do
    	local cell = self:createCell(v, cell_scale)
    	:setPosition(start.x, start.y - (i - 1) * cell_size.height)
    	self.scroll_view:addChild(cell)
    end
end

function PROMExchangeShopLayer:createCell(data, scale)
	local cell = PROMExchangeShopCell:createWithCCBIFile("ccbi/PROMExchangeShopCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
	cell:setAnchorPoint(ex.a.center)
	cell:setScale(scale)
   
    cell:initDone(data)

	cell.btn_submit:registerScriptTapHandler(handler(self, self.onBtnGot))
	cell.menu:setIsTouchInsideNode(self.scroll_view)
    cell.menu:setSwallowsTouches(false)

    return cell
end

function PROMExchangeShopLayer:onEvent(event, ui_event)
    self:updateCDTime()

    self:updateView()
end

function PROMExchangeShopLayer:onBtnInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMExchangeShopLayer:isEnoughNeedItem(tab)
    local temp = 0
    for i,v in ipairs(tab) do
        temp = ex.Player:getItemNum(v.item_type)
        if temp < v.item_num then
            return false
        end
    end

    return true
end

function PROMExchangeShopLayer:onBtnGot(tag, pSender)
    local cell = pSender:getParent():getParent()

    if cell.data.bought_num < cell.data.config.limit then
        if not ex.Player.promotion_data:getTimeIsOpen(self.promotion_id) then
            ex.MessageView:add(ex.Tools:getLang(47324))
            return
        end

        if not self:isEnoughNeedItem(cell.data.config.need_item) then
            ex.MessageView:add(ex.Tools:getLang(52754))
            return
        end

        local req = Promotion046_pb.GReqExchangeShopReward()
        req.idx = cell.data.config.idx
        NetManager:sendMessage(ProtocolID.GReqExchangeShopReward, req)
    else
        print(">>>>>PROMExchangeShopLayer:onBtnGot 兑换次数不够!")

        self:updateCDTime()

        self:updateView()
    end
end


return PROMExchangeShopLayer
