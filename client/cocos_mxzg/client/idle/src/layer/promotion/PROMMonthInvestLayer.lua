local PROMMonthInvestLayer = class("PROMMonthInvestLayer", require("src.comp.EventLayer"))
local PromotionCell = require("src.layer.promotion.PromotionCell")

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

-- 类型Tag对应购买idx 红点
local InvestList = {
	{idx = 21, reddot = 1004100},
	{idx = 22, reddot = 1004200}
}
local InvestType = {}
InvestType.null = 20
InvestType.invest128 = 21
InvestType.invest328 = 22

function PROMMonthInvestLayer:onCreate()
    self:setAutoClose(false)
	self:setSwallowTouches(false)

	self:reorderChild(self.spr_bg, -10)
	
	ex.Tools:AdjustFullScreenExtend(self.spr_bg)

	-- self:setLabelDesc(100, 98, ex.Tools:getLang(41020))

	self.menu = require("src.comp.menu.UIMenuGeneral"):create()
	self.menu:setPosition(cc.p(0, 0))
	self.menu:setSwallowsTouches(false)
	self.menu:setTouchCallback(handler(self, self.onSelect))
	self:addChild(self.menu, 100)

	self.cur_invest_type = 0

	bg_size = self:getContentSize()

	self.award_node = cc.Node:create()
	:setPosition(bg_size.width / 8, bg_size.height * 26 / 100)
	self:addChild(self.award_node)
	self.award_node:setContentSize(cc.size(bg_size.width * 3 / 4, bg_size.height * 20 / 100))

	self.award_node.menu = require("src.comp.menu.UIMenu"):create()--cpp.UIMenu:create()
	:setPosition(cc.p(0, 0))
	self.award_node:addChild(self.award_node.menu)

	self.btn_back:setPositionY(self.btn_back:getPositionY() - require("src.model.Game"):instance():getNotchHeight() - 18)
	self:initDone()
end

function PROMMonthInvestLayer:setLabelDesc(tag, diff, text)
	local lbl_desc = self:getChildByTag(tag)
	if lbl_desc then
		lbl_desc:removeFromParent()
		lbl_desc = nil
	end

	lbl_desc = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(40)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FFFFFF")
	:setScale(0.5)
	:setAnchorTextShadow(true)
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	:setContentSize(ex.p.width * 2, 40)
	:setPosition(180 * self.spr_bg:getScaleX(), self.spr_bg:getPositionY() + diff * self.spr_bg:getScaleY())
	:setAnchorPoint(ex.a.left_center)
	self:addChild(lbl_desc, tag, tag)

	lbl_desc:setXmlTextLua(text)
end

function PROMMonthInvestLayer:initDone()
	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/promotion.plist")
	sfc:addSpriteFrames("ccbi-res/promotion-tab-icon-1.plist")

	-- 红点
	self.reddot_list = {}

	local cell_size = PromotionCell:createWithCCBIFile("ccbi/PromotionCell.ccbi"):getContentSize()

	local start = cc.p(10, self.spr_bg_title:getPositionY())

	local select_cell = nil

	for i,v in ipairs(InvestList) do
		local cell = PromotionCell:createWithCCBIFile("ccbi/PromotionCell.ccbi")
		cell:setPosition(start.x + (i - 1) * cell_size.width, start.y)
		cell.idx = v.idx
		cell.reddot = v.reddot
		self.menu:addChild(cell)
		
		-- local frame = sfc:getSpriteFrame(string.format("promotion/icon-30%d-1.png", i))
		-- cell.spr_icon1:setSpriteFrame(frame)
		-- frame = sfc:getSpriteFrame(string.format("promotion/icon-30%d-2.png", i))
		-- cell.spr_icon2:setSpriteFrame(frame)

		ex.Tools:setSpriteFrame(cell.spr_icon1, string.format("promotion/icon-30%d-1.png", i))
		ex.Tools:setSpriteFrame(cell.spr_icon2, string.format("promotion/icon-30%d-2.png", i))


		cell.spr_icon1:setPositionX(cell_size.width * 0.5)
		cell.spr_icon2:setPositionX(cell_size.width * 0.5)

		-- 红点
		ex.Player.promotion_data:checkMonthInvesRedDot(v.idx )
		table.insert(self.reddot_list, cell)
		ex.RedDotManager:setStickNode(v.reddot, cell)

		if i == 1 then
			select_cell = cell
		end
	end

	self:onSelect(select_cell:getTag(), select_cell)
end

function PROMMonthInvestLayer:onExit()
	-- 移除红点节点
	local reddot_manager = ex.RedDotManager
	for _,v in pairs(self.reddot_list) do
		 reddot_manager:removeStickNode(v.reddot, v)
	end
end

function PROMMonthInvestLayer:clickHideRedDot(idx)
	-- 移除红点节点
	local reddot_manager = ex.RedDotManager
	for _,v in pairs(self.reddot_list) do
		reddot_manager:setSpecialVisible(v.reddot, v.idx ~= idx)
	end
end

function PROMMonthInvestLayer:onSelect(tag, pSender)
	if self.cur_invest_type == pSender.idx then
		return
	end
	ex.AudioManager:playEffect("music/button-click.mp3")
	self.cur_invest_type = pSender.idx

	self.menu:unselectAll()
	pSender:setSelected(true)

	--self:clickHideRedDot(pSender.idx)

	self:setCurrentType()
end

function PROMMonthInvestLayer:setCurrentType()
	local config = cfg.buygem.buygem[self.cur_invest_type]
	if not config then
		return
	end


	local buyReward = function(type)
		for i,v in ipairs(cfg.promotioninvest.invest) do
			if type == v.production_id and v.day == 0 then
				return v.reward
			end
		end
		return {{item_type = 0,item_num = 0}}
	end

	local cost = 0
	-- local value = 0
	if self.cur_invest_type == InvestType.invest128 then
		self.spr_bg2:removeFromParent()
		self.spr_bg2 = cc.Sprite:create("ccbi-res/promotion-bg-17.png")
		self.spr_bg2:setAnchorPoint(0, 0)
		self.spr_bg2:setPosition(0, 20)
		self:addChild(self.spr_bg2, -5)

		self.spr_bg2:setScaleX(self:getContentSize().width / self.spr_bg2:getContentSize().width)
		self.spr_bg2:setScaleY(self:getContentSize().height * 78 / 100 / self.spr_bg2:getContentSize().height)
	elseif self.cur_invest_type == InvestType.invest328 then
		self.spr_bg2:removeFromParent()
		self.spr_bg2 = cc.Sprite:create("ccbi-res/promotion-bg-18.png")
		self.spr_bg2:setAnchorPoint(0, 0)
		self.spr_bg2:setPosition(0, 20)
		self:addChild(self.spr_bg2, -5)

		self.spr_bg2:setScaleX(self:getContentSize().width / self.spr_bg2:getContentSize().width)
		self.spr_bg2:setScaleY(self:getContentSize().height * 78 / 100 / self.spr_bg2:getContentSize().height)
	end

	local reward = buyReward(self.cur_invest_type)
	-- self.lbl_cost:setString(tostring(cost))
	-- self.lbl_num:setString(reward[1].item_num)
	
		-- -- 立即获得多少钻石
		-- self.lbl_num:setString()

	-- 描述
	-- self:setLabelDesc(200, 130, string.format(ex.Tools:getLang(41019), config.rmb / 100))

	-- 礼包预览
	self:updateAwardShow()

	self:updateCompleted()
end

function PROMMonthInvestLayer:updateAwardShow()
	self.award_node.menu:removeAllChildren()


	local ver_num = {}
	for k,v in pairs(cfg.promotioninvest.invest) do
		if self.cur_invest_type == v.production_id then
			local num = v.reward[1].item_num
			for k1,v1 in pairs(ver_num) do
				if k1 == v.reward[1].item_type then
					num = num + v1
				end
			end
			table.insert( ver_num, v.reward[1].item_type, num)	
		end
	end

	local vec_reward = {}
	for i,v in ipairs(cfg.promotioninvestshow.show) do
		for k2,v2 in pairs(cfg.promotioninvest.invest) do
			if self.cur_invest_type == v2.production_id and v.day == v2.day then 
				local is_have = false
				local item_type = v2.reward[1].item_type
				for i3,v3 in ipairs(vec_reward) do
					if v3.item_type == item_type then
						is_have = true
						break
					end
				end
				if not is_have then
					local tableTemp = {}
					tableTemp.item_type = item_type
					tableTemp.item_num = ver_num[tableTemp.item_type]
					table.insert(vec_reward, tableTemp)
				end
				break
			end
		end
	end

	table.sort(vec_reward, function(a, b)
		return a.item_type < b.item_type
	end)

	local showLen = table.nums(vec_reward)
	local col = 3
	local row = showLen / col
	local view_size = self.award_node:getContentSize()
	local item_size = cc.size(view_size.width / col, view_size.height / row)

	local start = cc.p(view_size.width * 0.5 - item_size.width * (col - 1) * 0.5, view_size.height - 80)

	local index = 0
	for i,v in ipairs(vec_reward) do
		local index = i - 1
		local x = index % col
        local y = math.floor(index / col)

		local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
		item:registerScriptTapHandler(handler(self, self.onItemInfo))
		if item then
			item:setPosition(start.x + x * item_size.width, start.y - y * item_size.height)
			self.award_node.menu:addChild(item)
		end
	end
end

function PROMMonthInvestLayer:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMMonthInvestLayer:getShowAwardNode(day)
	local item = nil
	-- if self.cur_invest_type == InvestType.invest128 then
	-- 	item = cfg.promotioninvest.invest[day].normal[1]
	-- elseif self.cur_invest_type == InvestType.invest328 then
	-- 	item = cfg.promotioninvest.invest[day].advance[1]
	-- end

	for k,v in pairs(cfg.promotioninvest.invest) do
		if self.cur_invest_type == v.production_id and day == v.day then 
			item = v.reward[1]
		end 
	end

	if not item then
		return nil
	end

	local node = cc.Node:create()

	local lbl_num = cc.Label:createWithTTF(tostring(item.item_num), FONT_DEFAULT_NAME_BOLD, 18)
	:enableOutline(ex.c3b.BLACK, 1)
	node:addChild(lbl_num, 2)

	local scale = 0.7
	local spr_icon = nil
	local icon_size = nil

	if item.item_type > 20000000 and item.item_type < 30000000 then
		local star = 1
		local config = cfg.item.item[item.item_type]
		if config then
			star = config.star
		end

		-- 碎片
		spr_icon = cc.Sprite:createWithSpriteFrameName(config.icon..".png")

		icon_size = spr_icon:getContentSize()
		icon_size.width = icon_size.width * scale
		icon_size.height = icon_size.height * scale

		lbl_num:setAnchorPoint(ex.a.right_center)
		lbl_num:setPosition(icon_size.width / 2 - 5, -icon_size.height / 2 + 14)

		-- 星级
		local node_star = cc.Node:create():move(0, -icon_size.height / 2)
		node:addChild(node_star, 1)

		local star_type = math.floor(star / 5)
		local star_count

		if star % 5 == 0 then 
			if star > 5 then
				star_count = 1
			else 
				star_count = 5
				star_type = 0
			end
		else
			star_count = star % 5
		end
		if star > 10 then star_count = star_count + 1 end

		local diff = 9.0
		local start_pos = cc.p(-(star_count - 1) * diff * 0.5, 14)

		for i=1,star_count do
			local spr_star = cc.Sprite:createWithSpriteFrameName(string.format("other/star-%d.png", star_type))
			:setScale(0.5)
			:setPosition(cc.p(start_pos.x + (i - 1) * diff, start_pos.y))
			node_star:addChild(spr_star)
		end

		-- 右上角小碎片
    	local spr_ps = cc.Sprite:createWithSpriteFrameName("hero-icon/shop-sp.png")
    	:setScale(0.8 * scale)
    	spr_ps:setPosition(icon_size.width / 2 - spr_ps:getContentSize().width / 2,
    		icon_size.height / 2 - spr_ps:getContentSize().height / 2)
    	node:addChild(spr_ps, 1)
	else
		-- 物品
		spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", item.item_type))

		icon_size = spr_icon:getContentSize()
		icon_size.width = icon_size.width * scale
		icon_size.height = icon_size.height * scale

		lbl_num:setAnchorPoint(ex.a.left_center)
		lbl_num:setPosition(10, -icon_size.height / 2 + 10)
	end

	spr_icon:setScale(scale)
	spr_icon:setPosition(0, 0)
	node:addChild(spr_icon)

	local spr_txt_bg = cc.Sprite:createWithSpriteFrameName("promotion/spr-txt-bg-2.png")
	:setPosition(0, -56)
	node:addChild(spr_txt_bg)

	--累计%d天
	local lbl_day = cc.Label:createWithTTF(string.format(ex.Tools:getLang(41021), day), FONT_DEFAULT_NAME_BOLD, 18)
	:setPosition(0, -56)
	node:addChild(lbl_day)

	return node
end

function PROMMonthInvestLayer:updateCompleted()

	local config = cfg.buygem.buygem[self.cur_invest_type]
	if not config then
		return
	end

	local invest = ex.Player.promotion_data:getMonthInvest(self.cur_invest_type )
-- dump(invest)
	if invest then
		if invest.is_today_got then
			-- 已领取
			self.btn_done:setLabelText(ex.Tools:getLang(2703))
			self.btn_done:setTag(2)
		else
			-- 领取
			self.btn_done:setLabelText(ex.Tools:getLang(2214))
			self.btn_done:setTag(1)
		end

		if self.btn_done.spr_overflow ~= nil then
			self.btn_done.spr_overflow:setVisible(false)
		end
	else
		-- 购买
		self.btn_done:setLabelText(string.format(ex.Tools:getLang(2705), config.rmb / 100))
		self.btn_done:setTag(0)

		if self.btn_done.spr_overflow == nil then
			self.btn_done.spr_overflow = cc.Sprite:createWithSpriteFrameName("promotion/spr-overflow.png")
			self.btn_done.spr_overflow:setPosition(self.btn_done:getContentSize().width - 25, self.btn_done:getContentSize().height - 18)
			self.btn_done:addChild(self.btn_done.spr_overflow, 10)
		end
		self.btn_done.spr_overflow:setVisible(true)
	end
	
	if invest then 
		self.end_day:setString(ex.Tools:getLang(2703) .. string.format(ex.Tools:getLang(2713), invest.receive_day))

	else
		self.end_day:setString("")
	end 


	-- 刷新显示
	local glp_normal = cpp.ShaderFactory:instance():getGLProgram(ShaderType.ST_POSITION_TEXTURE_DEFAULT)
	local glp_gray = cpp.ShaderFactory:instance():getGLProgram(ShaderType.ST_POSITION_TEXTURE_GRAY)
	if not invest or invest.receive_day < invest.reach_day then	-- 可领取天数没玩
		self.node_got_over:setVisible(false)
		self.btn_done:setVisible(true)
		self.btn_done:setEnabled(not invest or not invest.is_today_got)

		-- 领取红点
		ex.Tools:addRedPoint(self.btn_done, invest and not invest.is_today_got, ex.r.p92)
		self.btn_done:getNormalImage():setGLProgram((not invest or not invest.is_today_got) and glp_normal or glp_gray)
	else

		if invest.is_today_got then
			self.node_got_over:setVisible(true)
			self.btn_done:setVisible(false)
		else
			self.node_got_over:setVisible(false)
			self.btn_done:setVisible(true)
			self.btn_done:setEnabled(true)

			-- 领取红点
			ex.Tools:addRedPoint(self.btn_done, true, ex.r.p92)
			self.btn_done:getNormalImage():setGLProgram(glp_normal)
		end
	end
end

function PROMMonthInvestLayer:onBtnDone(tag, pSender)
	if tag == 0 then
		if ex.Player.promotion_data:hasSuperCard() == false then
			ex.MessageView:add(ex.Tools:getLang(41022))
			return
		end

		local config = cfg.buygem.buygem[self.cur_invest_type]
		if config then
			ex.Player:pay(config.idx)
		end
	elseif tag == 1 then
		pSender:setEnabled(false)

		-- 发送领取协议
		local req = Promotion006_pb.GReqInvestGain()
		req.type = self.cur_invest_type 
		NetManager:sendMessage(ProtocolID.GReqInvestGain, req)

		-- 更新数据
		NetManager:sendMessage(ProtocolID.GReqInvestList)
	end
end

function PROMMonthInvestLayer:onBtnAward(tag, pSender)
	require("src.layer.promotion.PROMMonthInvestAwardCtr"):instance():openWindow(ex.Tools:getLang(41023), self.cur_invest_type)
end

function PROMMonthInvestLayer:onBtnBack(tag, pSender)
	ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
end


return PROMMonthInvestLayer
