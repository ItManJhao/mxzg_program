--[[
* @Description: 黑色星期五 - 英雄排行 排名奖励和达标奖励
* @Author: 熊梦
* @Date: 2021-3-2 1:26:00
* ]]

local PROMBlackFridayHeroRankRewardCtr = class("PROMBlackFridayHeroRankRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMBlackFridayHeroRankRewardLayer = class("PROMBlackFridayHeroRankRewardLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIItemHero = require("src.comp.menu.UIMenuItemHero")

local PROMBlackFridayHeroRankRewardShowCell = class("PROMBlackFridayHeroRankRewardShowCell", require("src.comp.LuaLayerBase"))
local PROMBlackFridayHeroRankStandardRewardCell = class("PROMBlackFridayHeroRankStandardRewardCell", require("src.comp.LuaLayerBase"))
---------------------------------------------------------------------------------
function PROMBlackFridayHeroRankRewardShowCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

end

function PROMBlackFridayHeroRankRewardShowCell:initData(data)
    if data == nil then
        return
    end
	dump(data)

	local rank_num = data.rank_up == data.rank_down and tostring(data.rank_up) or string.format( "%s-%s",data.rank_up,data.rank_down)
	self.lbl_rank_num:setString(string.format(ex.Tools:getLang(91863),rank_num))


	self.scroll_view:setItemSize(cc.size(120, 140))
	self.scroll_view:setAlignmentCenter(true)
	self.scroll_view:setBounceable(true)

    self.scroll_view.createItemFunction = function(data)
		local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
		item:setScale(0.9)
		item:registerScriptTapHandler(handler(self, self.onItemInfo))
        return item
    end

    self.scroll_view:reloadData(data.reward)

end

function PROMBlackFridayHeroRankRewardShowCell:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

---------------------------------------------------------------------------------
function PROMBlackFridayHeroRankStandardRewardCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

end

function PROMBlackFridayHeroRankStandardRewardCell:initData(data)
    if data == nil then
        return
    end

	self.data = data
	dump(data)

	
	self.scroll_view:setItemSize(cc.size(120, 140))
	self.scroll_view:setAlignmentCenter(true)
	self.scroll_view:setBounceable(true)

    self.scroll_view.createItemFunction = function(data)
		local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
		item:setScale(0.9)
		item:registerScriptTapHandler(handler(self, self.onItemInfo))
        return item
    end

    self.scroll_view:reloadData(data.reward)

	self.lbl_flower:setString(string.format(ex.Tools:getLang(91861),data.count) )


	self.btn_receive:setLabelText(ex.Tools:getLang(5631))
	self.btn_received:setLabelText(ex.Tools:getLang(41347))
	self.btn_not_standard:setLabelText(ex.Tools:getLang(47081))

	-- ex.Tools:setLimitWidth(self.btn_receive:getLabel(), 90)
	-- ex.Tools:setLimitWidth(self.btn_received:getLabel(), 90)
	-- ex.Tools:setLimitWidth(self.btn_not_standard:getLabel(),90)

	if ex.Player.promotion_data.promotion92_data.deliver_count >= data.count then
		for k,v in pairs(ex.Player.promotion_data.promotion92_data.count_reward_idx) do
			if v == data.idx then
				self.btn_received:setVisible(true)
				self.btn_receive:setVisible(false)
				self.btn_not_standard:setVisible(false)
				return
			end
		end
		self.btn_received:setVisible(false)
		self.btn_receive:setVisible(true)
		self.btn_not_standard:setVisible(false)
	else
		self.btn_received:setVisible(false)
		self.btn_receive:setVisible(false)
		self.btn_not_standard:setVisible(true)
	end

end

function PROMBlackFridayHeroRankStandardRewardCell:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMBlackFridayHeroRankStandardRewardCell:onGet(tag, pSender)
	local req = Promotion092_pb.GReqDeliverFlowerCountReward()
	req.idx = self.data.idx
	NetManager:sendMessage(ProtocolID.GReqDeliverFlowerCountReward, req)
end
---------------------------------------------------------------------------------

function PROMBlackFridayHeroRankRewardLayer:onCreate()
    self:addBlackBackground()
	self:registerBtnEvent()
end

-- 关闭按钮
function PROMBlackFridayHeroRankRewardLayer:registerBtnEvent( )
	local ctr = PROMBlackFridayHeroRankRewardCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))
end


function PROMBlackFridayHeroRankRewardLayer:initData(tag)
    self.choice_type = tag

	self.scroll_view:setItemSize(cc.size(560, 170))
    self.scroll_view:setItemType(1)

	self.btn_tab_1:setLabelText(ex.Tools:getLang(91858))
	self.btn_tab_2:setLabelText(ex.Tools:getLang(91859))
	for i=1,2 do
		self["btn_tab_"..i]:setChecked(self.choice_type==i)
		-- ex.Tools:setLimitWidth(self["btn_tab_"..i]:getLabel(), 120)
	end

	self:updateScrollView()

	self:addEvent(EVENT.BLACKFRIDAY.EVENT_FLOWER_COUNT_REWARD, handler(self, self.updateScrollView))
end


function PROMBlackFridayHeroRankRewardLayer:updateScrollView()
	
	local list ={}
	local ccbi_cell = nil
	local ccbi_str = ""
	if self.choice_type == 1 then
		list = cfg.promotion092countrankreward.promotion092countrankreward
		ccbi_cell = PROMBlackFridayHeroRankRewardShowCell
		ccbi_str = "PROMBlackFridayHeroRankRewardShowCell"
	elseif self.choice_type == 2 then
		list = cfg.promotion092countreward.promotion092countreward
		ccbi_cell = PROMBlackFridayHeroRankStandardRewardCell
		ccbi_str = "PROMBlackFridayHeroRankStandardRewardCell"
	end


    self.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = ccbi_cell:createWithCCBIFile(string.format("ccbi/%s.ccbi",ccbi_str ))
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data)
        -- cell.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerInfo))
        return cell
    end

    self.scroll_view:reloadData(list)

end


function PROMBlackFridayHeroRankRewardLayer:onTab(tag,pSender)
	if tag == self.choice_type then return end

	self.choice_type = tag
	self:updateScrollView(self.choice_type)
end

---------------------------------------------------------------------------------

function PROMBlackFridayHeroRankRewardCtr:onCreate()
	self:setCCBIPath("ccbi/PROMBlackFridayHeroRankRewardLayer.ccbi")
	self:setIsSingle(false)
end

function PROMBlackFridayHeroRankRewardCtr:getLayerClass()
	return PROMBlackFridayHeroRankRewardLayer
end

function PROMBlackFridayHeroRankRewardCtr:openWindow(tag)
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
	self.layer:initData(tag)
end

return PROMBlackFridayHeroRankRewardCtr
