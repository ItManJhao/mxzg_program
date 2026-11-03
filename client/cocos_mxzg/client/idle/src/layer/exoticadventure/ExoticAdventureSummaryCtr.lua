--[[
* @Description: 异界冒险-航行结束页面
* @Author: 熊梦
* @Date: 2020-07-30 20:00:00
* ]]
local ExoticAdventureSummaryCtr = class("ExoticAdventureSummaryCtr",require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ExoticAdventureSummaryLayer = class("ExoticAdventureSummaryLayer",require("src.comp.EventLayerAdaptiveWidth"))

function ExoticAdventureSummaryLayer:onCreate()
	self:addBlackBackground()
	self:inidata()
end

function ExoticAdventureSummaryLayer:inidata()


	local top = self.spr_title:getPositionY() - self.spr_title:getContentSize().height / 2 - 5
	local bottom = 550

	self.scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self.scroll_view:setItemSize(cc.size(120, 134))
	self.scroll_view:setItemOffset(cc.p(0, 5))

	local level_data = cfg.spacetimefleet.spacetimefleet[ex.Player.exotic_adventure_data.level]
	self.max_level_progress = level_data.need_exp

	self.lbl_level:setString(ex.Tools:getLang(76508)..ex.Player.exotic_adventure_data.level)

	self:createLevelProgress()
	self:updateReward()
end

function ExoticAdventureSummaryLayer:createLevelProgress()
    self.progressTimer_level = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("exotic-adventure/exotic-adventure-spr-jdt2-2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setScaleX(1)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.spr_progress_bg1:addChild(self.progressTimer_level)
    self.progressTimer_level:setPosition(self.spr_progress_bg1:getContentSize().width / 2 ,self.spr_progress_bg1:getContentSize().height / 2 )
    self:updateLevelProgress()
end

function ExoticAdventureSummaryLayer:updateLevelProgress()
    local percent = ex.Player.exotic_adventure_data.exp / self.max_level_progress * 100
    if percent > 100 then percent = 100 end
	self.progressTimer_level:setPercentage(percent)
	self.lbl_lv:setString(ex.Player.exotic_adventure_data.exp.."/"..self.max_level_progress)
end

function ExoticAdventureSummaryLayer:updateReward()
	self.scroll_view:setLoaded(false)
    -- 播放彩带爆炸
    -- self.spr_effect_bomb = ex.EffectFactory:createEffectWithNodeByName("eff_reward_bomb")
    -- self.spr_effect_bomb:setPosition(self.layer:getContentSize().width / 2, self.layer:getContentSize().height + 100)
	-- self:addChild(self.layer.spr_effect_bomb, 100)
	local cur_data = {}
	for k,v in pairs(ex.Player.exotic_adventure_data.end_item_list) do
		local data = {}
		data.item_type = v.type
		data.item_num = v.num
		table.insert( cur_data, data)
	end

	self.scroll_view.createItemFunction = function(item_data, scale)
		local item = ex.Tools:createBackpackItem(item_data.item_type, item_data.item_num)
		item.item_id = item_data.item_id
		item:registerScriptTapHandler(handler(self, self.onItem))
		ex.Tools:itemEnterAction(item)
		return item
	end

	self.scroll_view:reloadData(cur_data)
	
end

function ExoticAdventureSummaryLayer:onItem(tag ,pSender)
	-- 精灵不显示详细信息，只显示简介
	ex.Tools:onClickItemInfo(pSender.item_type or pSender.hero_type, pSender.item_id)
end

-- 关闭按钮
function ExoticAdventureSummaryLayer:closeWindow( )
	local ctr = ExoticAdventureSummaryCtr:instance()
	ctr:closeWindow()
	ex.MainSceneCtr:changeLayer(MainSceneType.EXOTIC_ADVENTURE)
end

-----------------------------------------------------------------------------
function ExoticAdventureSummaryCtr:onCreate()
	self:setCCBIPath("ccbi/ExoticAdventureSummaryLayer.ccbi")
	self:setIsSingle(false)
end

function ExoticAdventureSummaryCtr:getLayerClass()
	return ExoticAdventureSummaryLayer
end

function ExoticAdventureSummaryCtr:getAchievementLayer()
	return self.layer
end

function ExoticAdventureSummaryCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
end


return ExoticAdventureSummaryCtr
