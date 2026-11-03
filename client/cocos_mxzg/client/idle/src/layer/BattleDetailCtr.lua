local BattleDetailCtr = class("BattleDetailCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local BattleDetailLayer = class("BattleDetailLayer", require("src.comp.EventLayer"))
local BattleDetailCell = class("BattleDetailCell", require("src.comp.LuaLayerBase"))

function BattleDetailCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self:reorderChild(self.lbl_progress_1, 30)
	self:reorderChild(self.lbl_progress_2, 30)
	self:reorderChild(self.lbl_progress_3, 30)

	-- 创建进度条
	self.progress_1 = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("battle-detail/progress-red.png"))
	:setType(cc.PROGRESS_TIMER_TYPE_BAR)
	:setMidpoint(cc.p(0, 0.5))
	:setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
	:setPosition(self.spr_progress_bg_1:getPosition())
	self:addChild(self.progress_1, 20)

	self.progress_2 = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("battle-detail/progress-yellow.png"))
	:setType(cc.PROGRESS_TIMER_TYPE_BAR)
	:setMidpoint(cc.p(0, 0.5))
	:setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
	:setPosition(self.spr_progress_bg_2:getPosition())
	self:addChild(self.progress_2, 20)

	self.progress_3 = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("battle-detail/progress-green.png"))
	:setType(cc.PROGRESS_TIMER_TYPE_BAR)
	:setMidpoint(cc.p(0, 0.5))
	:setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
	:setPosition(self.spr_progress_bg_3:getPosition())
	self:addChild(self.progress_3, 20)
end

function BattleDetailCell:reset(data)
	-- 创建头像
	self.btn_photo = require("src.comp.menu.UIMenuItemHero"):createWithData()
	self.btn_photo:reset(data)
	if data.fashion_id ~= 0 and data.fashion_id ~= nil then   -- 有皮肤
		self.btn_photo:setFashionShowForce(data.fashion_id)
	end
	self.btn_photo:setScale(0.8)
	self.btn_photo:setPosition(45, 115)
	self:addChild(self.btn_photo)

	-- 设置数值
	self.lbl_progress_1:setString(tostring(data.total_damage))
	self.lbl_progress_2:setString(tostring(data.total_take_damage))
	self.lbl_progress_3:setString(tostring(data.total_recovery))

	-- 设置进度条
	self.progress_1:setPercentage((data.max_damage > 0) and (data.total_damage * 100.0 / data.max_damage) or 0)
	self.progress_2:setPercentage((data.total_take_damage > 0) and (data.total_take_damage * 100.0 / data.max_take_damage) or 0)
	self.progress_3:setPercentage((data.total_recovery > 0) and (data.total_recovery * 100.0 / data.max_recovery) or 0)
end

function BattleDetailLayer:onCreate()
	self:addBlackBackground()

    self.scroll_view_1:setItemSize(cc.size(100,160))
    self.scroll_view_1:setItemType(1)
    self.scroll_view_2:setItemSize(cc.size(100,160))
    self.scroll_view_2:setItemType(1)
end

function BattleDetailCtr:onCreate()
	self:setCCBIPath("ccbi/BattleDetailLayer.ccbi")
	self:setIsSingle(false)
end

function BattleDetailCtr:getLayerClass()
	return BattleDetailLayer
end

function BattleDetailCtr:openWindow(vec_detail)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/battle-detail.plist")
	self.vec_detail = vec_detail
	self:loadLayer()
	self:open()
	self:initData(vec_detail)
end

function BattleDetailCtr:initData(vec_detail)
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	if #vec_detail > 1 then
		for i=1,#vec_detail do
			self.layer["btn_report_"..i]:registerScriptTapHandler(handler(self, self.changeReport))
			self.layer["btn_report_"..i]:setVisible(true)
		end
	end
	print(#vec_detail)
	if #vec_detail ~= 0  then
		self:updateLayer(vec_detail[1])
	else
		self:updateLayer(vec_detail)
	end
	
    -- self:updateLayer(vec_detail)
end

function BattleDetailCtr:updateLayer(vec_detail)
	if not self:getLayer() then
		return
	end

	local max_damage = 0
	local max_recovery = 0
	local max_take_damage = 0
	for i,v in ipairs(vec_detail.attacker_log.hero_log) do
		if v.total_damage > max_damage then
			max_damage = v.total_damage
		end
		if v.total_recovery > max_recovery then
			max_recovery = v.total_recovery
		end
		if v.total_take_damage > max_take_damage then
			max_take_damage = v.total_take_damage
		end
	end
	for i,v in ipairs(vec_detail.defender_log.hero_log) do
		if v.total_damage > max_damage then
			max_damage = v.total_damage
		end
		if v.total_recovery > max_recovery then
			max_recovery = v.total_recovery
		end
		if v.total_take_damage > max_take_damage then
			max_take_damage = v.total_take_damage
		end
	end

	self.layer.lbl_name_1:setString(vec_detail.attacker_log.name)
	self.layer.spr_result_1:setVisible(vec_detail.win_id == vec_detail.attacker_log.rid)

    self.layer.scroll_view_1:getContainer():removeAllChildren()
    self.layer.scroll_view_1.createItemFunction = function(data)
		-- 创建ccbi cell
		data.max_damage = max_damage
		data.max_recovery = max_recovery
		data.max_take_damage = max_take_damage

		local cell = BattleDetailCell:createWithCCBIFile("ccbi/BattleDetailCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
		cell:reset(data)
    
        return cell
    end

	self.layer.scroll_view_1:reloadData(vec_detail.attacker_log.hero_log)
	
    self.layer.scroll_view_2:getContainer():removeAllChildren()
    self.layer.scroll_view_2.createItemFunction = function(data)
		-- 创建ccbi cell
		data.max_damage = max_damage
		data.max_recovery = max_recovery
		data.max_take_damage = max_take_damage

		local cell = BattleDetailCell:createWithCCBIFile("ccbi/BattleDetailCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
		cell:reset(data)
    
        return cell
    end

    self.layer.scroll_view_2:reloadData(vec_detail.defender_log.hero_log)

	self.layer.lbl_name_2:setString(vec_detail.defender_log.name)
	self.layer.spr_result_2:setVisible(vec_detail.win_id == vec_detail.defender_log.rid)
end

function BattleDetailCtr:changeReport(tag,pSender)
	self:updateLayer(self.vec_detail[tag])
end

return BattleDetailCtr