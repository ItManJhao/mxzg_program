local PROMMonthInvestAwardCtr = class("PROMMonthInvestAwardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMMonthInvestAwardLayer = class("PROMMonthInvestAwardLayer", require("src.comp.EventLayer"))


local InvestType = {}
InvestType.invest128 = 21
InvestType.invest328 = 22

function PROMMonthInvestAwardLayer:onCreate()
	self:addBlackBackground()

end

function PROMMonthInvestAwardLayer:initDone(title, cur_type)
	self.lbl_title:setString(title)

	-- 奖励列表scroll_view
	local viewSize = self.spr_bg:getContentSize()
    viewSize.height = viewSize.height - 10

    local scroll_view = cc.ScrollView:create(viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(self.spr_bg:getPositionX(), self.spr_bg:getPositionY() + 5)
    self:addChild(scroll_view)

    local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    scroll_view:addChild(menu)

    local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    item_size = cc.size(item_size.width + 16, item_size.height + 12)
    local diffY = item_size.height + 40

	local show_list = {}
	for k,v in pairs(cfg.promotioninvest.invest) do
		if cur_type == v.production_id then 
			
			show_list[v.day] = v
		end 
	end

    local awardLen = table.nums(show_list) - 1
    local col = math.floor(viewSize.width / item_size.width) -- 列数
    local row = math.ceil(1.0 * awardLen / col) -- 行数
    local cont_height = diffY * row
    cont_height = math.max(cont_height , viewSize.height)

    scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))

    cont_height = cont_height - item_size.height * 0.5

    local start = cc.p(viewSize.width * 0.5 - (item_size.width * col * 0.5), cont_height)
    start.x = start.x + item_size.width * 0.5

    for i=1,awardLen do
    	local item = nil
    	-- local config = cfg.promotioninvest.invest[i]
    	-- if config then
    	-- 	if cur_type == InvestType.invest128 then
		-- 		item = config.normal[1]
		-- 	elseif cur_type == InvestType.invest328 then
		-- 		item = config.advance[1]
		-- 	end
		-- end
		local config = show_list[i]
		item = show_list[i].reward[1]

		if item then
			local index = i - 1
			local x = index % col
        	local y = math.floor(index / col)

        	local pos = cc.p(start.x + x * item_size.width, start.y - y * diffY)

			local node = ex.Player.backpack_data:createWithData(item.item_type, item.item_num)
			node:setPosition(pos)
        	node:registerScriptTapHandler(handler(self, self.onShowInfo))
        	menu:addChild(node)

        	pos = cc.p((item_size.width - 16) / 2, -24)

        	local spr_txt_bg = cc.Sprite:createWithSpriteFrameName("win-bg/block-bg-12.png")
        	:setScale(0.8)
        	:setPosition(pos)
        	node:addChild(spr_txt_bg)

        	local lbl_day = cc.Label:createWithTTF(string.format(ex.Tools:getLang(41021), config.day), FONT_DEFAULT_NAME_BOLD, 18)
			:setPosition(pos)
			node:addChild(lbl_day)
		end
    end
end

function PROMMonthInvestAwardLayer:onShowInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


function PROMMonthInvestAwardCtr:onCreate()
	self:setCCBIPath("ccbi/PROMMonthInvestAwardLayer.ccbi")
	self:setIsSingle(false)
end

function PROMMonthInvestAwardCtr:getLayerClass()
	return PROMMonthInvestAwardLayer
end

function PROMMonthInvestAwardCtr:openWindow(title, cur_type)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self.layer:initDone(title, cur_type)
	self.layer.btn_close:registerScriptTapHandler(handler(self,self.closeWindow))
end

return PROMMonthInvestAwardCtr