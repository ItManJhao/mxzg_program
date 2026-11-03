local PvpCtr = class("PvpCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PvpLayer = class("PvpLayer", require("src.comp.EventLayerAdaptiveWidth"))
local PvpPlayerCell = class("PvpPlayerCell", require("src.comp.LuaLayerBase"))
local PvpRewardCell = class("PvpRewardCell", require("src.comp.LuaLayerBase"))
local PvpRankCell = class("PvpRankCell", require("src.comp.LuaLayerBase"))
local UIMenuItenBackpack = require("src.comp.menu.UIMenuItemBackpack")

local ExTimer = require("src.ex.ExTimer")

function PvpPlayerCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	
    self.menu:setSwallowsTouches(false)
    self.btn_photo:setContentSize(self.spr_head:getContentSize())
end

function PvpPlayerCell:initData(data)

end

function PvpRankCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	
    self.menu:setSwallowsTouches(false)
	self.btn_photo:setContentSize(self.spr_head:getContentSize())

	self.btn_like:setLabelOffset(cc.p(20, 0))

	self.btn_like.spr_like = cc.Sprite:createWithSpriteFrameName("rank/spr-like-1.png")
	self.btn_like.spr_like:setPosition(40, self.btn_like:getContentSize().height / 2 + 2)
	self.btn_like:addChild(self.btn_like.spr_like, 10)
end

function PvpRankCell:initData(data)
	if not data or not data.rank then 
		self:setVisible(false)
		return 
	end
	self:setVisible(data.rank ~= nil)
	self.spr_cell_bg:setVisible(data.player_id ~= ex.Player.role_id)
	self.spr_rank:setVisible(false)
	self.lbl_rank:setVisible(true)
	if data.rank > 0 and data.rank < 4 then 
		self.spr_rank:setVisible(true)
		self.lbl_rank:setVisible(false)
		self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png",data.rank))
	end
	self.spr_frame:setSpriteFrame(ex.Tools:getBorderIconByIdx(data.border_id))
	self.spr_head:setSpriteFrame(string.format("head-icon/%d.png", data.head_id))
	self.lbl_rank:setString(data.rank <= 0 and ex.Tools:getLang(47749) or data.rank)
	self.lbl_rank:setScale(data.rank <= 0 and 0.3 or 0.5)
	self.lbl_name:setString(data.name)
	self.lbl_level:setString(data.level)
	self.lbl_combat_num:setString(data.combat_num)
	self.lbl_num:setString(data.score)

	self.btn_photo.role_id = data.player_id
	self.btn_photo:registerScriptTapHandler(handler(PvpCtr:instance(), PvpCtr.onPlayerInfo))

	if data.belike > 999 then
		data.belike = 999
	end
	self.btn_like.role_id = data.player_id
	self.btn_like:setLabelText(data.belike)
	self.btn_like:registerScriptTapHandler(handler(PvpCtr:instance(), PvpCtr.onLike))

	if data.player_id == ex.Player.role_id then
		self.btn_like.spr_like:setSpriteFrame("rank/spr-like-2.png")
		self.btn_like:setEnabled(false)
	else
		for k,v in pairs(ex.Player.pvp_data.like_list) do
			if v == data.player_id then
				self.btn_like.spr_like:setSpriteFrame("rank/spr-like-2.png")
				self.btn_like:setEnabled(false)
			end
		end
	end
end

function PvpRewardCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.lbl_my_rank:setVisible(false)
	self.lbl_my_rank_tip:setVisible(false)
end

function PvpRewardCell:initData(data)
	local config = data
	local str_rank = tostring(config.rank)
	if config.idx ~= config.rank then
		local pre_config = cfg.pvpdailyreward.pvpdailyreward[config.idx - 1]
		str_rank = tostring(pre_config.rank + 1) .. "-" .. tostring(config.rank)
	end

	self.spr_cell_bg:setVisible(data.is_my == false)
	self.spr_rank:setVisible(false)
	self.lbl_rank:setVisible(true)
	if config.rank > 0 and config.rank < 4 then 
		self.spr_rank:setVisible(true)
		self.lbl_rank:setVisible(false)
		self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png",config.rank))
	end

	self.lbl_rank:setString(str_rank)

	for i,v in ipairs(config.reward) do
		local pvp_ctr = PvpCtr:instance()
		local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
		item:registerScriptTapHandler(handler(pvp_ctr, pvp_ctr.onTouchItemInfo))
		item:setPosition(450 - 90 * (i - 1), 50)
		item:setScale(0.75)
		self.menu:addChild(item)
	end
end

function PvpRewardCell:setMyRank(rank)
	self.spr_rank:setVisible(false)
	self.lbl_rank:setVisible(false)

	self.lbl_my_rank:setVisible(true)
	self.lbl_my_rank_tip:setVisible(true)

	self.spr_cell_bg:setVisible(false)

	if rank > 0 then
		self.lbl_my_rank:setString(ex.Tools:getLang(47055)..rank)
	else
		self.lbl_my_rank:setString(ex.Tools:getLang(47055)..ex.Tools:getLang(47749))

		self.menu:setVisible(false)
		self.lbl_unrank_tip:setVisible(true)
		self.lbl_unrank_tip:setString(ex.Tools:getLang(52106))
	end
end

function PvpLayer:onCreate()
	-- local last_content_size = self:getContentSize()
	-- local cur_content_size = cc.size(ex.p.width - 20, last_content_size.height)
	-- local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

	-- self:setContentSize(cur_content_size)
	-- self:setPosition(ex.p.width / 2 - self:getContentSize().width / 2, ex.p.height / 2 - self:getContentSize().height / 2 + 20)

	-- self.spr_bg:setContentSize(cc.size(cur_content_size.width + 20, cur_content_size.height + 20))
	-- self.btn_close:setPosition(cur_content_size.width - 40, cur_content_size.height - 25)
	-- self.spr_champions_bg:setPositionX(cur_content_size.width * 0.5)
	self.spr_champions_bg:setScaleX(ex.p.width / self.spr_champions_bg:getContentSize().width / self:getScaleX())

	-- self.spr_title_bg:setPosition(self.spr_title_bg:getPositionX() + offset.x / 2, self.spr_title_bg:getPositionY() + offset.y)
	-- self.lbl_title:setPosition(self.lbl_title:getPositionX() + offset.x / 2, self.lbl_title:getPositionY() + offset.y)
	-- self.btn_shop:setPosition(self.btn_shop:getPositionX() + offset.x / 2, self.btn_shop:getPositionY() + offset.y)
	-- self.btn_champion:setPosition(self.btn_champion:getPositionX() + offset.x / 2, self.btn_champion:getPositionY() + offset.y)
    ex.EffectCtr:playNormalEff(25, self.btn_champion:getContentSize().width / 2, self.btn_champion:getContentSize().height * 0.83, nil, self.btn_champion, 0)

	-- self.spr_res_icon:setPosition(self.spr_res_icon:getPositionX() + offset.x / 2, self.spr_res_icon:getPositionY() + offset.y)
	-- self.spr_res_bg:setPosition(self.spr_res_bg:getPositionX() + offset.x / 2, self.spr_res_bg:getPositionY() + offset.y)
	-- self.lbl_num:setPosition(self.lbl_num:getPositionX() + offset.x / 2, self.lbl_num:getPositionY() + offset.y)
	-- self.btn_add:setPosition(self.btn_add:getPositionX() + offset.x / 2, self.btn_add:getPositionY() + offset.y)

	-- self.btn_battle_list:setPosition(self.btn_battle_list:getPositionX() + offset.x / 2, self.btn_battle_list:getPositionY() + offset.y)
	self.btn_battle_list:setLabelOffset(cc.p(0, -3))
	-- self.btn_rank:setPosition(self.btn_rank:getPositionX() + offset.x / 2, self.btn_rank:getPositionY() + offset.y)
	self.btn_rank:setLabelOffset(cc.p(0, -3))
	-- self.btn_daily_reward:setPosition(self.btn_daily_reward:getPositionX() + offset.x / 2, self.btn_daily_reward:getPositionY() + offset.y)
	self.btn_daily_reward:setLabelOffset(cc.p(0, -3))
	-- self.btn_season_reward:setPosition(self.btn_season_reward:getPositionX() + offset.x / 2, self.btn_season_reward:getPositionY() + offset.y)
	self.btn_season_reward:setLabelOffset(cc.p(0, -3))

	-- self.lbl_cd_day:setPosition(self.lbl_cd_day:getPositionX() + offset.x / 2, self.lbl_cd_day:getPositionY() + offset.y)
	-- self.lbl_cd_week:setPosition(self.lbl_cd_week:getPositionX() + offset.x / 2, self.lbl_cd_week:getPositionY() + offset.y)

	-- self.layer_battle_list:setPosition(self.layer_battle_list:getPositionX() + offset.x / 2, self.layer_battle_list:getPositionY())

	-- self.btn_request:setPosition(self.btn_request:getPositionX() + offset.x / 2, self.btn_request:getPositionY())
	-- self.btn_history:setPosition(self.btn_history:getPositionX() + offset.x / 2, self.btn_history:getPositionY())
	-- self.btn_refresh:setPosition(self.btn_refresh:getPositionX() + offset.x / 2, self.btn_refresh:getPositionY())
	-- self.lbl_time:setPosition(self.lbl_time:getPositionX() + offset.x / 2, self.lbl_time:getPositionY())

	-- self.spr_ribbon:setPosition(self.spr_ribbon:getPositionX() + offset.x / 2, self.spr_ribbon:getPositionY())
	-- self.spr_my_bg:setPosition(self.spr_my_bg:getPositionX() + offset.x / 2, self.spr_my_bg:getPositionY())
	
	-- self.spr_rank_bg:setPosition(self.spr_rank_bg:getPositionX() + offset.x / 2, self.spr_rank_bg:getPositionY())
	-- self.spr_area_bg:setPosition(self.spr_area_bg:getPositionX() + offset.x / 2, self.spr_area_bg:getPositionY())

	-- self.spr_area_bg:setContentSize(self.spr_area_bg:getContentSize().width, self.spr_area_bg:getContentSize().height + offset.y)

	self.btn_battle_list:setLabelText(ex.Tools:getLang(5566))
	self.btn_rank:setLabelText(ex.Tools:getLang(5055))
	self.btn_daily_reward:setLabelText(ex.Tools:getLang(5398))
    self.btn_season_reward:setLabelText(ex.Tools:getLang(5677))


	self.btn_battle_list:setChecked(true)

	self.table_view = cc.TableView:create(cc.size(self.spr_rank_bg:getContentSize().width - 10, self.spr_rank_bg:getContentSize().height - 10))
	self.table_view:setAnchorPoint(cc.p(0,0))
    self.table_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.table_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	self.table_view:setBounceable(false)
    self.table_view:setDelegate()
    self.table_view:setDataSource()

    self.layer_rank:addChild(self.table_view)
    self.table_view:setPosition(cc.p(self.spr_rank_bg:getPositionX() + 5, self.spr_rank_bg:getPositionY() + 5))
	-- self.layer_rank:addChild(self.cell_self)

	-- 进度条
    self.progress_point = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("pvp/progress-point.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 0.5))
	:setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
	:setScale(self.progress_point_bg:getScale())
	:setPosition(self.progress_point_bg:getPosition())
	self.layer_battle_list:addChild(self.progress_point, 10)
	
	self.progress_point:setPercentage(0)

	self:reorderChild(self.menu_point, 20)

	-- 刷新时间
	self.reset_time_day = GetSystemResetTime()
    self.reset_time_week = ex.Player.pvp_data.season_end_time or GetWeekResetTime()
    self.timer = ExTimer:new():bind(self):run(handler(self, self.updateCDTime), 1.0)
    self:updateCDTime()

	self.spr_ribbon:setLocalZOrder(1)

    local pvp_ctr = PvpCtr:instance()
	self.table_view:registerScriptHandler(handler(pvp_ctr, pvp_ctr.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL) --滚动时的回掉函数
    self.table_view:registerScriptHandler(handler(pvp_ctr, pvp_ctr.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX) --列表项的尺寸
    self.table_view:registerScriptHandler(handler(pvp_ctr, pvp_ctr.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX) --创建列表项
    self.table_view:registerScriptHandler(handler(pvp_ctr, pvp_ctr.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW) --列表项的数量
	self.table_view:registerScriptHandler(handler(pvp_ctr, pvp_ctr.tableCellTouched), cc.TABLECELL_TOUCHED) --列表项被点击

	local scheduler = cc.Director:getInstance():getScheduler()
	self.scheduler_id = scheduler:scheduleScriptFunc(handler(self, self.updateLayer), 1, false)
	self:updateLayer()

	self:addBlackBackground()

	self:addEvent(EVENT.BACK_PACK_EVENT.BACKPACK_UPDATA_LIST, handler(self, self.setItemNum))

	-- 刷新排行榜
	NetManager:sendMessage(ProtocolID.GReqPvpRankList)
end

function PvpLayer:updateCDTime()
    self.reset_time_day = self.reset_time_day - 1
    if self.reset_time_day <= 0 then
        self.reset_time_day = self.reset_time_day + 86400

        -- 时间到
	end
	
    -- 下次结算: %d:%02d:%02d
    self.lbl_cd_day:setString(ex.Tools:getLang(41039)..string.format("%d:%02d:%02d", 
        math.floor(self.reset_time_day / 3600),
        math.floor(self.reset_time_day / 60 % 60),
        math.floor(self.reset_time_day % 60)))


	local now = ex.Game:getServerTime()
    if self.reset_time_week - now <= 0 then
        self.reset_time_week = self.reset_time_week + 86400 * 7

        -- 时间到
    end

    if self.reset_time_week - now > 86400 then
    	-- 大于1天
    	-- 下次结算: %d天
    	self.lbl_cd_week:setString(ex.Tools:getLang(41039)..string.format(ex.Tools:getLang(2713),
    		math.floor((self.reset_time_week - now) / 86400)))
    else
    	-- 下次结算: %d:%02d:%02d
    	self.lbl_cd_week:setString(ex.Tools:getLang(41039)..string.format("%d:%02d:%02d",
        	math.floor((self.reset_time_week - now) / 3600),
        	math.floor((self.reset_time_week - now) / 60 % 60),
        	math.floor((self.reset_time_week - now) % 60)))
	end
	
    if self.reset_time_week - now > 86400 then
		self.lbl_season_end_time:setString(string.format(ex.Tools:getLang(2713),
			math.floor((self.reset_time_week - now) / 86400))..
			string.format("%02d:%02d:%02d",
        	math.floor((self.reset_time_week - now) % 86400 / 3600),
        	math.floor((self.reset_time_week - now) / 60 % 60),
        	math.floor((self.reset_time_week - now) % 60)))
	else
		self.lbl_season_end_time:setString(string.format("%02d:%02d:%02d",
			math.floor((self.reset_time_week - now) / 3600),
			math.floor((self.reset_time_week - now) / 60 % 60),
			math.floor((self.reset_time_week - now) % 60)))
	end
end

function PvpLayer:onExit()
	-- 停止计时器
    self.timer:stop()

	if self.scheduler_id then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler_id)
		self.scheduler_id = nil
	end
end

function PvpLayer:updateLayer()
	local pvp_ctr = PvpCtr:instance()
	local refresh_time = pvp_ctr.refresh_time or 0
	local now_time = ex.Game:getServerTime()
	local time_diff = ex.Tools:getSysCfg("pvp_refresh_time")
	if now_time - refresh_time > time_diff then
		self.btn_refresh:setVisible(true)
		self.lbl_time:setVisible(false)
	else
		self.btn_refresh:setVisible(false)
		self.lbl_time:setVisible(true)
		self.lbl_time:setString(ex.StringUtil.convertToTimeFormat(math.max(refresh_time + time_diff - now_time, 0)))
	end
end

function PvpLayer:setItemNum()
	self.lbl_num:setString(tostring(ex.Player:getItemNum(ItemType.IT_RANK_TICKET)))
end

function PvpLayer:onChampion()
	local isopen = ex.JumpManager:jumpByAtom("main_champion_like")
	if isopen then
		PvpCtr:instance():closeWindow()
	end
end


-----------------------------------------------------------------------------

function PvpCtr:onCreate()
	self:setCCBIPath("ccbi/PvpLayer.ccbi")
	self:setIsSingle(false)

	self.match_time = 0
end

function PvpCtr:getLayerClass()
	return PvpLayer
end

function PvpCtr:getPvpLayer()
	return self.layer
end

function PvpCtr:openWindow()
	if self:isOpened() then
		return
	end
	
	self:loadLayer()
	self:open()
	self:initData()
end

function PvpCtr:initData()
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self.layer.btn_battle_list:registerScriptTapHandler(handler(self, self.onChangeLayer))
	self.layer.btn_rank:registerScriptTapHandler(handler(self, self.onChangeLayer))
	self.layer.btn_daily_reward:registerScriptTapHandler(handler(self, self.onChangeLayer))
	self.layer.btn_season_reward:registerScriptTapHandler(handler(self, self.onChangeLayer))

	self.layer.btn_shop:registerScriptTapHandler(handler(self, self.onShop))

	self.layer.btn_request:registerScriptTapHandler(handler(self, self.onDefense))
	self.layer.btn_history:registerScriptTapHandler(handler(self, self.onHistory))
	self.layer.btn_refresh:registerScriptTapHandler(handler(self, self.onRefresh))
	self.layer.btn_add:registerScriptTapHandler(handler(self, self.onBuyItem))
	self.layer.btn_cross_battle:registerScriptTapHandler(handler(self, self.onCrossBattle))

	NetManager:sendMessage(ProtocolID.GReqPvpData)
	
	self:updateLayer()
end

function PvpCtr:updateLayer()
	if not self:getLayer() then
		return
	end

	local layer = self.layer
	layer.layer_type = 0
	layer.layer_battle_list:setVisible(false)
	layer.layer_rank:setVisible(false)

	if layer.btn_battle_list:isChecked() then
		layer.layer_type = 1
		layer.layer_battle_list:setVisible(true)
		self:updateBattleList()
	elseif layer.btn_rank:isChecked() then
		layer.layer_type = 2
		layer.layer_rank:setVisible(true)
		layer.spr_ribbon:setVisible(true)
		self:updateRankList()
	elseif layer.btn_daily_reward:isChecked() then
		layer.layer_type = 3
		layer.layer_rank:setVisible(true)
		layer.spr_ribbon:setVisible(false)
		self:updateDailyList()
	elseif layer.btn_season_reward:isChecked() then
		layer.layer_type = 4
		layer.layer_rank:setVisible(true)
		layer.spr_ribbon:setVisible(false)
		self:updateSeasonList()
	end

	-- 显示刷新时间
	layer.lbl_cd_day:setVisible(layer.btn_daily_reward:isChecked())
	layer.lbl_cd_week:setVisible(layer.btn_season_reward:isChecked())
end

function PvpCtr:onChangeLayer(tag, pSender)
	self:updateLayer()
end

-- 对手列表
function PvpCtr:updateBattleList()
	if not self:getLayer() or self.layer.layer_type ~= 1 then
		return 
	end
	
	local layer = self.layer
	local enemy_list = ex.Player.pvp_data.enemy_list
    local sfc = cc.SpriteFrameCache:getInstance()
    local cell_size = PvpPlayerCell:createWithCCBIFile("ccbi/PvpPlayerCell.ccbi"):getContentSize()
    -- cell_size.height = cell_size.height + 3
    local scale = layer.scroll_view_battle:getViewSize().width / cell_size.width
    cell_size.height = cell_size.height * scale + 5

    local height = table.nums(enemy_list) * cell_size.height
    height = math.max(height , layer.scroll_view_battle:getViewSize().height)
    layer.scroll_view_battle:getContainer():removeAllChildren()
    layer.scroll_view_battle:setContentSize(cc.size(layer.scroll_view_battle:getViewSize().width, height))
	layer.scroll_view_battle:setContentOffset(cc.p(0, layer.scroll_view_battle:getViewSize().height - height))
	
	table.sort(enemy_list, function(a, b)
		return a.combat_num < b.combat_num	
	end )

	local combat_self = ex.Player.fighting
    for i,v in ipairs(enemy_list) do
        local cell = PvpPlayerCell:createWithCCBIFile("ccbi/PvpPlayerCell.ccbi")
        cell.data = v
        cell:setScale(scale)
        cell:setPosition(0, height - i * cell_size.height)
        layer.scroll_view_battle:getContainer():addChild(cell)

        cell.lbl_level:setString(tostring(v.level))
        cell.lbl_score:setString(ex.Tools:getLang(52205).." "..v.score)
		cell.lbl_combat_num:setString(ex.Tools:getLang(52204).." "..v.combat_num)
		if v.combat_num > combat_self then
			cell.lbl_combat_num:setColor(cc.c3b(183,0,0))
		end
		
		cell.lbl_name:setString(v.name)
		cell.btn_battle:registerScriptTapHandler(handler(self, self.onBattle))
		cell.btn_photo.role_id = v.player_id
        cell.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerInfo))

		local frame = sfc:getSpriteFrame(string.format("head-icon/%d.png", v.head_id))
		if not frame then
			frame = sfc:getSpriteFrame(string.format("head-icon/%d.png", 0))
		end

		if ex.Player.pvp_data.free_count > 0 then
			cell.btn_battle:setLabelText(ex.Tools:getLang(47196))
			cell.btn_battle:setLabelSize(36)
		end

		cell.spr_head:setSpriteFrame(frame)

		local frame1 = sfc:getSpriteFrame(ex.Tools:getBorderIconByIdx(v.border_id))
		if not frame1 then
			frame1 = sfc:getSpriteFrame(string.format("head-icon/%d.png", 0))
		end

		cell.spr_clan_photo:setSpriteFrame(frame1)
	end
	if ex.Player.pvp_data.rank_self.rank <= 0 then
		layer.lbl_my_rank_num:setString(ex.Tools:getLang(47124))
	else
		layer.lbl_my_rank_num:setString(ex.Tools:getLang(47055)..ex.Player.pvp_data.rank_self.rank)
	end
	layer.lbl_my_score_num:setString(ex.Tools:getLang(47272)..ex.Player.crown)
	layer.lbl_point_num:setString(ex.Tools:getLang(47023)..ex.Player.pvp_data.season_count..ex.Tools:getLang(47180))
    -- 更新物品显示
	layer:setItemNum()
	
	if ex.Player.pvp_data.season_count < tonumber(ex.Tools:getSysCfg("pvp_jump_times_season")) then
		cc.UserDefault:getInstance():setBoolForKey("pvp_cross_battle", false)
		layer.btn_cross_battle:setChecked(false)
	else
		local cross_battle = cc.UserDefault:getInstance():getBoolForKey("pvp_cross_battle")
		layer.btn_cross_battle:setChecked((cross_battle ~= nil) and cross_battle or false)
	end

	-- 刷新宝箱显示
	self.layer.menu_point:removeAllChildren()

	local point_max = 9999
	local point_min = 0
	local point_cur_idx = 0
	local point_count = table.nums(cfg.pvptimesreward.pvptimesreward)
	for i,v in ipairs(cfg.pvptimesreward.pvptimesreward) do
		if v.times < point_max and v.times > ex.Player.pvp_data.season_count then
			point_max = v.times
			point_cur_idx = v.idx
		end
		if v.times >= point_min and v.times <= ex.Player.pvp_data.season_count then
			point_min = v.times
		end
	end
	local progress_width = self.layer.progress_point_bg:getContentSize().width * self.layer.progress_point_bg:getScaleX()
	for i,v in ipairs(cfg.pvptimesreward.pvptimesreward) do
		local flag = ex.Player.pvp_data:pvpCanTimesReward(v.idx)
		
		local str_box_1 = string.format("other/spr-box-%d.png", v.box_pic or 1)
		if flag == -1 or flag > 0 then
			str_box_1 = string.format("other/spr-box-open-%d.png", v.box_pic or 1)
		end

        local btn_reward_box = cpp.UIMenuItemImage:createWithSpriteFrameName(str_box_1, str_box_1, str_box_1)
        btn_reward_box:registerScriptTapHandler(handler(self, self.onClickBox))
        btn_reward_box:setPosition(self.layer.progress_point_bg:getPositionX() + progress_width * (v.idx / point_count - 0.5), self.layer.progress_point_bg:getPositionY() + 2)
        self.layer.menu_point:addChild(btn_reward_box)

        btn_reward_box:setTag(v.idx)

		if flag <= -2 then
			-- 未领取并不可领取
			local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_box_unopen")
			spr_effect:setAnchorPoint(cc.p(0.5, 0))
			spr_effect:setPosition(btn_reward_box:getContentSize().width / 2, btn_reward_box:getContentSize().height / 2)
			-- spr_effect:setScale(0.75)
			btn_reward_box:addChild(spr_effect, 10, 10)
		elseif flag > 0 then
			-- 未领取并可领取
			local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_box_open")
			spr_effect:setAnchorPoint(cc.p(0.5, 0))
			spr_effect:setPosition(btn_reward_box:getContentSize().width / 2 - 3, btn_reward_box:getContentSize().height / 2 - 12)
			-- spr_effect:setScale(0.75)
			btn_reward_box:addChild(spr_effect, 10, 10)
		end

        local lbl_reward_point = cc.Label:createWithTTF(tostring(v.times), FONT_DEFAULT_NAME_BOLD, 36)
        -- lbl_reward_point:setColor(self.lbl_total_point:getColor())
        lbl_reward_point:setScale(0.5)
        lbl_reward_point:setPosition(btn_reward_box:getContentSize().width / 2, -15)
        btn_reward_box:addChild(lbl_reward_point)
	end

	local percentage = (point_cur_idx - 1 + ((ex.Player.pvp_data.season_count - point_min) / (point_max - point_min))) * 100 / point_count
	if point_max == 9999 and point_min > 0 then
		percentage = 100
	end
	if percentage > 100 then
		percentage = 100
	elseif percentage < 0 then
		percentage = 0
	end
	self.layer.progress_point:setPercentage(percentage)
end

function PvpCtr:updateRankList()
	-- self.layer.spr_ribbon:setPositionY(160)
	self.layer.spr_my_bg:setPositionY(35)
	self.layer.spr_my_bg:setContentSize(cc.size(self.layer.spr_my_bg:getContentSize().width, 140))
	-- self.layer.spr_rank_bg:setPositionY(181)
	-- self.layer.spr_rank_bg:setContentSize(cc.size(self.layer.spr_rank_bg:getContentSize().width, 546))
	-- self.layer.table_view:setPositionY(self.layer.spr_rank_bg:getPositionY() + 5)
	-- self.layer.table_view:setViewSize(cc.size(self.layer.spr_rank_bg:getContentSize().width - 20, self.layer.spr_rank_bg:getContentSize().height - 10))

	self.layer.list_count = table.nums(ex.Player.pvp_data.rank_list)

	local cell_data = {}
	cell_data = {}
	cell_data["cell_class"] = PvpRankCell
	cell_data["file"] = "ccbi/PvpRankCell.ccbi"
	cell_data["data"] = ex.Player.pvp_data.rank_list

	if self.layer.cell_self then
		self.layer.cell_self:removeFromParent()
		self.layer.cell_self = nil
	end

	self.layer.cell_self = PvpRankCell:createWithCCBIFile("ccbi/PvpRankCell.ccbi")
	self.layer.cell_self:setPosition(self.layer:getContentSize().width / 2 - self.layer.cell_self:getContentSize().width / 2,
		self.layer.spr_my_bg:getPositionY() + 5)
	self.layer.layer_rank:addChild(self.layer.cell_self)

	self.layer.cell_data = cell_data
	self.layer.table_view:reloadData()
	self.layer.cell_self:initData(ex.Player.pvp_data.rank_self)

	if self.layer.scroll_offset ~= nil then
		self.layer.table_view:setContentOffset(self.layer.scroll_offset)
		self.layer.scroll_offset = nil
	end
end

function PvpCtr:updateDailyList()
	-- self.layer.spr_ribbon:setPositionY(160)
	self.layer.spr_my_bg:setPositionY(55)
	self.layer.spr_my_bg:setContentSize(cc.size(self.layer.spr_my_bg:getContentSize().width, 120))
	-- self.layer.spr_rank_bg:setPositionY(181)
	-- self.layer.spr_rank_bg:setContentSize(cc.size(self.layer.spr_rank_bg:getContentSize().width, 546))
	-- self.layer.table_view:setPositionY(self.layer.spr_rank_bg:getPositionY() + 5)
	-- self.layer.table_view:setViewSize(cc.size(self.layer.spr_rank_bg:getContentSize().width - 20, self.layer.spr_rank_bg:getContentSize().height - 10))

	self.layer.list_count = table.nums(cfg.pvpdailyreward.pvpdailyreward)

	local cell_data = {}
	cell_data = {}
	cell_data["cell_class"] = PvpRewardCell
	cell_data["file"] = "ccbi/PvpRewardCell.ccbi"
	cell_data["data"] = clone(cfg.pvpdailyreward.pvpdailyreward)

	local rank = ex.Player.pvp_data.rank_self.rank
	local data = ex.Player.pvp_data:getDailyConfigByRank(rank)

	for i,v in ipairs(cell_data["data"]) do
		v.is_my = (v.idx == data.idx)
	end

	if self.layer.cell_self then
		self.layer.cell_self:removeFromParent()
		self.layer.cell_self = nil
	end

	self.layer.cell_self = PvpRewardCell:createWithCCBIFile("ccbi/PvpRewardCell.ccbi")
	self.layer.cell_self:setPosition(self.layer:getContentSize().width / 2 - self.layer.cell_self:getContentSize().width / 2,
		self.layer.spr_my_bg:getPositionY() + 5)
	self.layer.layer_rank:addChild(self.layer.cell_self)
	
	self.layer.cell_data = cell_data
	self.layer.table_view:reloadData()
	self.layer.cell_self:initData(data)
	self.layer.cell_self:setMyRank(rank)
end

function PvpCtr:updateSeasonList()
	-- self.layer.spr_ribbon:setPositionY(160)
	self.layer.spr_my_bg:setPositionY(55)
	self.layer.spr_my_bg:setContentSize(cc.size(self.layer.spr_my_bg:getContentSize().width, 120))
	-- self.layer.spr_rank_bg:setPositionY(181)
	-- self.layer.spr_rank_bg:setContentSize(cc.size(self.layer.spr_rank_bg:getContentSize().width, 546))
	-- self.layer.table_view:setPositionY(self.layer.spr_rank_bg:getPositionY() + 5)
	-- self.layer.table_view:setViewSize(cc.size(self.layer.spr_rank_bg:getContentSize().width - 20, self.layer.spr_rank_bg:getContentSize().height - 10))

	self.layer.list_count = table.nums(cfg.pvpweeklyreward.pvpweeklyreward)

	local cell_data = {}
	cell_data = {}
	cell_data["cell_class"] = PvpRewardCell
	cell_data["file"] = "ccbi/PvpRewardCell.ccbi"
	cell_data["data"] = cfg.pvpweeklyreward.pvpweeklyreward

	local rank = ex.Player.pvp_data.rank_self.rank
	local data = ex.Player.pvp_data:getWeeklyConfigByRank(rank)

	for i,v in ipairs(cell_data["data"]) do
		v.is_my = (v.idx == data.idx)
	end

	if self.layer.cell_self then
		self.layer.cell_self:removeFromParent()
		self.layer.cell_self = nil
	end

	self.layer.cell_self = PvpRewardCell:createWithCCBIFile("ccbi/PvpRewardCell.ccbi")
	self.layer.cell_self:setPosition(self.layer:getContentSize().width / 2 - self.layer.cell_self:getContentSize().width / 2,
		self.layer.spr_my_bg:getPositionY() + 5)
	self.layer.layer_rank:addChild(self.layer.cell_self)

	self.layer.cell_data = cell_data
	self.layer.table_view:reloadData()
	self.layer.cell_self:initData(data)
	self.layer.cell_self:setMyRank(rank)
end

function PvpCtr:onBattle(tag, pSender)

end

function PvpCtr:scrollViewDidScroll(view)

end

function PvpCtr:cellSizeForTable(view, idx)
	if self.layer.cell_data["cell_class"] == PvpRewardCell then
		return 480, 110
	elseif self.layer.cell_data["cell_class"] == PvpRankCell then
		return 480, 130
	end
	return 480, 110
end

function PvpCtr:numberOfCellsInTableView(view)
    return self.layer.list_count
end

function PvpCtr:tableCellAtIndex(view, idx)
	local cell = cc.TableViewCell:create()
	local layer = self.layer
	local cell_layer = layer.cell_data["cell_class"]:createWithCCBIFile(layer.cell_data["file"])
	if cell_layer then
		cell_layer:initData(layer.cell_data["data"][idx + 1])
		cell_layer:setPosition(view:getViewSize().width * 0.5 - cell_layer:getContentSize().width * 0.5, 0)
		if cell_layer.menu then
			cell_layer.menu:setIsTouchInsideNode(view)
		end
		cell:addChild(cell_layer)
	end
	return cell
end

function PvpCtr:tableCellTouched(view, cell)

end

function PvpCtr:onTouchItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

-- 查看角色信息
function PvpCtr:onPlayerInfo(tag, pSender)
    ex.Tools:showPlayerInfo(pSender.role_id, cc.UserDefault:getInstance():getIntegerForKey("server_id"))
end

function PvpCtr:onBattle(tag, pSender)
	-- 30秒匹配间隔，战斗结束时。这个时间会变成0
	local is_null = ex.Player.lineup_data:isNullBattleList(LineupType.CHAPTER)

	if not is_null then
		ex.MessageView:add(ex.Tools:getLang(47516))
		return
	end

	local can_battle = false
	if ex.Player.pvp_data.free_count > 0 then
		 ex.Player.pvp_data.free_count =  ex.Player.pvp_data.free_count - 1
		 can_battle = true
	end

	if (not can_battle) and ex.Player:getItemNum(ItemType.IT_RANK_TICKET) > 0 then
		can_battle = true
		-- ex.Player:addItem(ItemType.IT_RANK_TICKET, -1)
	end

	if not can_battle then
		ex.Tools:showEnoughTip(ItemType.IT_RANK_TICKET)
		-- ex.MessageView:add(string.format(ex.Tools:getLang(47098), ex.Tools:getLang(cfg.item.item[ItemType.IT_RANK_TICKET]).name))
		return
	end

	local now_time = ex.Game:getServerTime();
	if now_time - self.match_time < 2 then
		return
	end
	self.match_time = now_time

	local player_id = pSender:getParent():getParent().data.player_id

	require("src.layer.PvpEndCtr"):instance().data = pSender:getParent():getParent().data
	-- dump(require("src.layer.PvpEndCtr"):instance().data, "data")

	-- 发起战斗
    local req_pvp_battle = Pvp_pb.GReqPvpBattle()
    req_pvp_battle.player_id = player_id
	NetManager:sendMessage(ProtocolID.GReqPvpBattle, req_pvp_battle)

	local cross_battle = cc.UserDefault:getInstance():getBoolForKey("pvp_cross_battle")
	if cross_battle ~= true then
		self:closeWindow(tag, pSender)
	end
end

function PvpCtr:battleStart(data)
	-- local layer_main_city = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MAINCITY_LAYER)
	-- local battle_layer = require("src.layer.PvpBattleLayer"):create()
	-- battle_layer:setBattleIdLua(data.battle_id)
	-- battle_layer:initHeroData(data)
	-- battle_layer:setBattleEndCallback(handler(self, self.onBattleEnd))
	-- layer_main_city:addKeepLayer(MainCityType.PVP_BATTLE, battle_layer)
	-- layer_main_city:addChild(battle_layer, 999)
end

function PvpCtr:onBattleEnd(is_win, layer)
	self.match_time = 0

	local battle_id = layer:getBattleIdLua()
	local layer_main_city = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MAINCITY_LAYER)
	layer:remove()
	layer_main_city:removeKeepLayer(MainCityType.PVP_BATTLE)
	ex.Tools:autoPlaySceneMusic()
	
	-- 请求战斗结束
	-- local req_battle_end = ProtocolRequest.ReqPvpBattleEnd
	-- req_battle_end.battle_id.value = battle_id
	-- req_battle_end.is_win.value = is_win and 1 or 0
	-- NetManager:sendLuaData(req_battle_end)

	local req_battle_end = Pvp_pb.GReqPvpBattleEnd()
	req_battle_end.battle_id = battle_id
	req_battle_end.is_win = is_win and 1 or 0
    NetManager:sendMessage(ProtocolID.GReqPvpBattleEnd, req_battle_end)

	
	-- 判断当前主城界面是否显示
	layer_main_city = ex.MainSceneCtr:getMainSceneLayer(MainSceneType.MAINCITY_LAYER)
	if layer_main_city then
		self:openWindow()
	end
end

function PvpCtr:onDefense(tag, pSender)
	require('src.layer.HeroSelectCtr'):instance():openWindow(ex.Tools:getLang(70311),
															ex.Tools:getLang(47396),
	        												BattleType.PVP_DEFENSE,
	        												nil)
end

function PvpCtr:onClickBox(tag, pSender)
	local idx = pSender:getTag()

    local config = cfg.pvptimesreward.pvptimesreward[idx]
    if config == nil then
        return
    end
	local flag = ex.Player.pvp_data:pvpCanTimesReward(config.idx)
	-- local flag = ex.Player.pvp_data:pvpTimesReward(config.idx)
	-- if flag <= -2 then
	-- 	ex.MessageView:add(ex.Tools:getLang(41262))
	-- else
	if flag == -1 then
		ex.MessageView:add(ex.Tools:getLang(41263))
		return
	end

	if flag > 0 then
        require("src.layer.SevenTargetRewardInfoCtr"):instance():openWindow(config, flag > 0, handler(self, self.onClickBoxConfirm))
    else 
        require("src.layer.SevenTargetRewardInfoCtr"):instance():openWindow(config, flag > 0, nil)
    end
end

function PvpCtr:onClickBoxConfirm(idx)
	ex.Player.pvp_data:pvpTimesReward(idx)
end

function PvpCtr:onLike(tag, pSender)
	-- 查询是否超出当天点赞上限
	if #ex.Player.pvp_data.like_list >= ex.Tools:getSysCfg("pvp_like_times_daily") then
		ex.MessageView:add(ex.Tools:getLang(41264))
		return
	end

	for k,v in pairs(ex.Player.pvp_data.like_list) do
		if v == pSender.role_id then
			ex.MessageView:add(ex.Tools:getLang(41265))
			return
		end
	end

	self.layer.scroll_offset = self.layer.table_view:getContentOffset()

	local req_pvp_like = Pvp_pb.GReqPvpLike()
	req_pvp_like.rid = pSender.role_id
	NetManager:sendMessage(ProtocolID.GReqPvpLike, req_pvp_like)
end

function PvpCtr:onCrossBattle(tag, pSender)
	local season_times_need = ex.Tools:getSysCfg("pvp_jump_times_season")
	if ex.Player.pvp_data.season_count < tonumber(season_times_need) then
		ex.MessageView:add(string.format(ex.Tools:getLang(41266), season_times_need))
		pSender:setChecked(not pSender:isChecked())
		return
	end

	cc.UserDefault:getInstance():setBoolForKey("pvp_cross_battle", pSender:isChecked())
end

function PvpCtr:onShop(tag,pSender)
	cfg.funcopen.main_shop.open(SHOP_TYPE.PVPNORMAL)
end


function PvpCtr:onRefresh()
	-- local req_pvp_data = ProtocolRequest.ReqPvpData
	-- NetManager:sendLuaData(req_pvp_data)
	NetManager:sendMessage(ProtocolID.GReqPvpPlayerRefresh)

	self.refresh_time = ex.Game:getServerTime()
	self.layer:updateLayer()
end

function PvpCtr:onHistory(tag, pSender)
	require("src.layer.PvpHistoryCtr"):instance():openWindow()
end

function PvpCtr:onBuyItem(tag, pSender)
	require("src.layer.ItemBuyCtr"):instance():openWindow(ItemType.IT_RANK_TICKET,
		ex.Tools:getSysCfg("pvp_ticket_cost_gem"),
		function(item_num)
			if item_num == nil or  item_num <= 0 then
				return
			end

			local req_buy = Pvp_pb.GReqBuyPvpTicket()
			req_buy.item_num = item_num
			NetManager:sendMessage(ProtocolID.GReqBuyPvpTicket, req_buy)

			self.layer:setItemNum()
		end)
end

return PvpCtr
