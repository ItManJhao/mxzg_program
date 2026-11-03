local MissionLayer = class("MissionLayer", require("src.comp.EventLayer"))
local MissionCell = class("MissionCell", require("src.comp.LuaLayerBase"))
local ATOM = "main_mission"

function MissionCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	self.menu:setSwallowsTouches(false)
end

--------------------------------------------------------------------
function MissionLayer:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	
	-- 铺展到全屏
	ex.Tools:AdjustFullScreenExtend(self.spr_bg)
	
	local notch_height = require("src.model.Game"):instance():getNotchHeight()
    -- self.btn_close:setPosition(ex.p.width - 80, ex.p.height - 140 * ex.s.global_scale - notch_height)
	self.btn_close:registerScriptTapHandler(handler(self, self.onBack))
	
	-- self.node_title:setPositionY(ex.p.height - 80 * ex.s.global_scale - notch_height)
	-- self.btn_info:setPositionY(ex.p.height - 160 * ex.s.global_scale - notch_height)
	
    -- local last_content_size = self:getContentSize()
    -- local cur_content_size = cc.size(ex.p.width - 20, ex.p.height - 220)
    -- local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)
	
    -- self:setContentSize(cur_content_size)
    -- self:setPosition(ex.p.width / 2 - self:getContentSize().width / 2, ex.p.height / 2 - self:getContentSize().height / 2 + 20)
	
	-- local scale_x = ex.p.width / self.spr_bg:getContentSize().width
	-- local scale_y = ex.p.height / self.spr_bg:getContentSize().height
	-- if scale_x > scale_y then
	-- 	self.spr_bg:setScale(scale_x)
	-- else 
	-- 	self.spr_bg:setScale(scale_y)
	-- end
    -- self.spr_bg:setScale(ex.p.width / self.spr_bg:getContentSize().width, ex.p.height / self.spr_bg:getContentSize().height)
    -- self.spr_bg:setPosition(cur_content_size.width / 2, cur_content_size.height / 2)
    -- self.btn_close:setPosition(cur_content_size.width - 80, cur_content_size.height - 32)

	self.spr_bar_bg:setPositionX(ex.p.width / 2)
	
	-- 矫正按钮位置以及效果
	local relocal_btn_bar = function(btn, pos_y)
		local btn_size = btn:getContentSize()
		
		local normal_img = btn:getNormalImage()
		
		normal_img:setAnchorPoint(ex.a.center)
		
		normal_img:setPosition(cc.p(btn_size.width / 2, btn_size.height / 2))

		btn:setPositionY(pos_y)

		-- 添加选中特效
		local effect = cc.Sprite:createWithSpriteFrameName("mission-cell-bg/icon-select.png")
		effect:setAnchorPoint(ex.a.center)
		effect:setPosition(cc.p(btn_size.width / 2, btn_size.height / 2 - 6))
		--  effect:setScale(0.85)
		normal_img:add(effect, -1, 33)
		effect:setVisible(false)

		local spr_unlock = cc.Sprite:createWithSpriteFrameName("mission-cell-bg-lang/spr_lock.png")
		spr_unlock:setAnchorPoint(ex.a.center)
		spr_unlock:setPosition(cc.p(btn_size.width / 2, btn_size.height / 2))
		normal_img:add(spr_unlock, 1, 44)
		spr_unlock:setVisible(false)
	end
	
	local btn_bar_pos_y = self.spr_bar_bg:getPositionY()
	relocal_btn_bar(self.btn_gold, btn_bar_pos_y)
	relocal_btn_bar(self.btn_exp, btn_bar_pos_y)
	relocal_btn_bar(self.btn_hero, btn_bar_pos_y)
	relocal_btn_bar(self.btn_fetter, btn_bar_pos_y)
	relocal_btn_bar(self.btn_runes, btn_bar_pos_y)

    self.btn_gold:setTag(1)
    self.btn_exp:setTag(2)
    self.btn_hero:setTag(3)
    self.btn_fetter:setTag(4)
    self.btn_runes:setTag(5)

	-- local content_height = ex.p.height - 331 * ex.s.global_scale - notch_height - ex.MainSceneCtr:getBottomHeight()
	-- self.node_content:setPositionY(btn_bar_pos_y - 20)
	local content_size = cc.size(ex.p.width, self.node_content:getPositionY() - ex.MainSceneCtr:getBottomHeight())
	self.node_content:setContentSize(content_size)
	self.content_bg:setPreferredSize(content_size)
    -- self.spr_tip_bg:setPosition(self.spr_tip_bg:getPositionX() + offset.x / 2, self.spr_tip_bg:getPositionY() + offset.y)
    -- self.lbl_num_tip:setPosition(self.lbl_num_tip:getPositionX() + offset.x / 2, self.lbl_num_tip:getPositionY() + offset.y)
    -- self.lbl_num:setPosition(self.lbl_num:getPositionX() + offset.x / 2, self.lbl_num:getPositionY() + offset.y)
	
	-- self.spr_banner:setPosition(self.spr_banner:getPositionX() + offset.x / 2, self.spr_banner:getPositionY() + offset.y)
	local temp_height = content_size.height - 35
	self.spr_banner:setPosition(ex.p.width / 2, temp_height)
	self.spr_banner:setScale(ex.s.global_scale)

	temp_height = temp_height - self.spr_banner:getContentSize().height * self.spr_banner:getScaleY() - 26
	local temp_pos = cc.p(self.lbl_num:getPositionX(), temp_height)
	self.lbl_num:setPosition(temp_pos)

	local btn_info_pos = self:convertToNodeSpace(self.node_content:convertToWorldSpace(cc.p(temp_pos.x + 28, temp_pos.y)))
	self.btn_info:setPosition(btn_info_pos)

    -- self.spr_scrollview_bg:setPosition(30 + offset.x / 2, 60)
    -- self.spr_scrollview_bg:setContentSize(cc.size(self.spr_scrollview_bg:getContentSize().width, cur_content_size.height - 240))

	-- self.scroll_view:setPosition(35 + offset.x / 2, 65)
	temp_height = temp_height - 23
	self.scroll_view_bg:setPreferredSize(cc.size(self.scroll_view_bg:getPreferredSize().width, temp_height - self.scroll_view_bg:getPositionY()))
	temp_height = temp_height - 5
    self.scroll_view:setViewSize(cc.size(self.scroll_view:getViewSize().width, temp_height - self.scroll_view:getPositionY()))

	-- self.lbl_num_tip:enableShadow(FONT_BLACK_C4B, cc.size(1, -1))
	-- self.lbl_num:enableShadow(FONT_BLACK_C4B, cc.size(1, -1))

	
    self:addRedDotNode(RedDotType.ZCJ_DHFB_RCFBRK_FBJBFB, self.btn_gold)
    self:addRedDotNode(RedDotType.ZCJ_DHFB_RCFBRK_FBJYFB, self.btn_exp)
	self:addRedDotNode(RedDotType.ZCJ_DHFB_RCFBRK_FBSPFB, self.btn_hero)
	self:addRedDotNode(RedDotType.ZCJ_DHFB_RCFBRK_FBJBAFB, self.btn_fetter)
	self:addRedDotNode(RedDotType.ZCJ_DHFB_RCFBRK_FBJLFB, self.btn_runes)
	
	self.btn_gold:setChecked(true)
	self.select_idx = 1
	self:onChangeLayer()
	self.btn_info:registerScriptTapHandler(handler(self,self.onClickInfo))
	self:registerBtnWithCondition()

	self:addEvent(EVENT.DAILY_DUNGEON_EVENT.UPDATE, handler(self, self.updateLayer))
end

function MissionLayer:onBack(tag , pSender)
    if not ex.MainSceneCtr:backLastLayer() then
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
    end
end

function MissionLayer:setBtnSelectEffect(btn, select)
	local normal_img = btn:getNormalImage()
	btn:setScale(select and 1 or 0.8)

	local effect = normal_img:getChildByTag(33)
	effect:setVisible(select)

	local system_data = ex.JumpManager:getSystemDataByAtom(ATOM)
	local child_data = system_data[btn:getTag()]
	local isOpen = ex.JumpManager:checkOpenConditionByAtomNoMsg(child_data.atom)
	local spr_unlock = normal_img:getChildByTag(44)
	spr_unlock:setVisible(not isOpen)
end

function MissionLayer:registerBtnWithCondition()
    local system_data = ex.JumpManager:getSystemDataByAtom(ATOM)
    for i,v in pairs(system_data) do
        local btn = self.menu:getChildByTag(i)
        if btn ~= nil then 
            local child_data = system_data[v]
            if child_data ~= nil then 
                btn:setName(child_data.atom)
            end
        end
    end
end

function MissionLayer:onClickInfo(tag,pSender)
	-- print(self.__cname,"onClickInfo")
	ex.InfoCtr:openWindow(ex.Tools:getLang(42028), ex.Tools:getLang(42029))
end

function MissionLayer:onChangeLayer()

	local tmp_layer_type = 1
	if self.btn_gold:isChecked() then
		tmp_layer_type = 1
	elseif self.btn_exp:isChecked() then
		tmp_layer_type = 2
	elseif self.btn_hero:isChecked() then
		tmp_layer_type = 3
	elseif self.btn_fetter:isChecked() then
		tmp_layer_type = 4
	elseif self.btn_runes:isChecked() then
		tmp_layer_type = 5
	end
	
	local system_data = ex.JumpManager:getSystemDataByAtom(ATOM)
	
	local child_data = system_data[tmp_layer_type]
	
	local isOpen = ex.JumpManager:checkOpenConditionByAtom(child_data.atom)
	if not isOpen then 
		local num = table.nums(system_data)
		for i=1,num do
			local btn = self.menu:getChildByTag(i)
			btn:setChecked(i == self.select_idx)
		end
		return 
	end
	self.layer_type = tmp_layer_type
	self:setBtnSelectEffect(self.btn_gold, self.layer_type == 1)
	self:setBtnSelectEffect(self.btn_exp, self.layer_type == 2)
	self:setBtnSelectEffect(self.btn_hero, self.layer_type == 3)
	self:setBtnSelectEffect(self.btn_fetter, self.layer_type == 4)
	self:setBtnSelectEffect(self.btn_runes, self.layer_type == 5)

	self.select_idx = self.layer_type
	self.reset_offset = true
	self:updateLayer()
end

function MissionLayer:updateLayer()
	-- self.spr_banner:setSpriteFrame("mission-cell-bg-lang/banner-"..self.layer_type..".png")
	ex.Tools:setSpriteFrame(self.spr_banner, "mission-cell-bg-lang/banner-"..self.layer_type..".png")

	local mission_table = ex.Player.daily_dungeon_data:getMissionTable(self.layer_type)

	local cell_margin = 4
	self.scroll_view:getContainer():removeAllChildren()
	local cell_size = MissionCell:createWithCCBIFile("ccbi/MissionCell.ccbi"):getContentSize()
    local scale = (self.scroll_view:getViewSize().width - 2 * cell_margin) / cell_size.width
	cell_size.height = cell_size.height * scale + cell_margin
	local height = table.nums(mission_table) * cell_size.height + cell_margin
	height = math.max(height , self.scroll_view:getViewSize().height)

    self.scroll_view:setContentSize(cc.size(self.scroll_view:getViewSize().width, height))

	local count_status = ex.Player.daily_dungeon_data:getMissionCountStatus(self.layer_type)
	local mission_id = ex.Player.daily_dungeon_data:getMissionId(self.layer_type)
	local mission_max = ex.Player.daily_dungeon_data:getMissionIdMax(self.layer_type)
	local need_gem = ex.Player.daily_dungeon_data:getNowTypeCost(self.layer_type)

	local recommend_index = nil
    local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
	for i,v in ipairs(mission_table) do
		local cell = MissionCell:createWithCCBIFile("ccbi/MissionCell.ccbi")
		cell:setIgnoreAnchorPointForPosition(false)
		cell:setAnchorPoint(ex.a.center)
		cell.type = self.layer_type
        cell.data = v
		cell:setScale(scale)
        cell:setPosition(self.scroll_view:getViewSize().width / 2, height - (i - 0.5) * cell_size.height)
        self.scroll_view:addChild(cell)
		cell.menu:setIsTouchInsideNode(self.scroll_view)
		
        -- 显示奖励
        for i,v in ipairs(v.reward) do
			local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
			item:setPosition(160 + 88 * (i - 1), 56)
			item:setScale(0.75)
			item:registerScriptTapHandler(handler(self, self.onItemInfo))
			cell.menu:addChild(item)
        end

        -- 
		cell.lbl_title:setString(ex.Tools:getLang(v.lan))
        cell.btn_battle:registerScriptTapHandler(handler(self, self.onBattleStart))

		cell.lbl_num:setString(tostring(need_gem))

        -- 所有次数都用完了
		-- if count_status == 3 then
		-- elseif count_status == 2 then
		-- elseif v.mission <= mission_max then
		-- 	cell.btn_battle:setPositionY(50)
		-- 	if count_status == 0 then
		-- 		cell.spr_gem:setVisible(false)
        -- 		cell.lbl_num:setVisible(false)
		-- 	end
		-- end
		
		if v.mission <= mission_max then
			if need_gem == 0 then 
				cell.btn_battle:setPositionY(50) 
				cell.spr_gem:setVisible(false)
				cell.lbl_num:setVisible(false)	
			end
		end

		if v.mission > mission_max then
        	cell.btn_battle:setLabelText(ex.Tools:getLang(47681))
			cell.btn_battle:setEnabled(false)
			-- add 熊梦
			-- 优先显示等级条件
			if not ex.Player.daily_dungeon_data:bLevelreach(v.open_level) then
				cell.lbl_battle:setString(string.format(ex.Tools:getLang(74551), v.open_level))
			else
				cell.lbl_battle:setString(string.format(ex.Tools:getLang(41245), v.power_require))
			end 
        	cell.lbl_battle:setVisible(true)
			cell.spr_gem:setVisible(false)
        	cell.lbl_num:setVisible(false)
			cell.btn_battle:setLabelOutLine(cc.c4b(69, 69, 69, 255))
		elseif mission_id < v.mission then
			cell.btn_battle:setLabelText(ex.Tools:getLang(47412))
			cell.lbl_battle:setVisible(false)
			cell.btn_battle:setEnabled(true)
			recommend_index = recommend_index or i
			cell.btn_battle:setLabelOutLine(cc.c4b(109, 51, 37, 255))

			cell.btn_battle:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-1.png"))
        	cell.btn_battle:setDisabledImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-3.png"))
		else
			cell.btn_battle:setLabelText(ex.Tools:getLang(47413))
			cell.lbl_battle:setVisible(false)
			cell.btn_battle:setEnabled(true)
			cell.btn_battle:setLabelOutLine(cc.c4b(11, 90, 42, 255))

			cell.btn_battle:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-green-1.png"))
        	cell.btn_battle:setDisabledImage(cc.Sprite:createWithSpriteFrameName("button/btn-green-3.png"))
        end
    	-- cell.btn_battle:setLabelColor(FONT_BLACK)
        cell.btn_battle:setLabelColor(cc.WHITE)

		ex.Tools:setSpriteFrame(cell.spr_ribbon, string.format("mission-cell-bg/bg%d.png", v.level_png))
		cell.spr_ribbon2:setVisible(recommend_index == nil and (v.mission == mission_max) or (v.mission == recommend_index))
	end

	recommend_index = recommend_index == nil and mission_max or recommend_index
	local recommend_y = math.min(0, -(height - cell_size.height * recommend_index - self.scroll_view:getViewSize().height * 0.5))
	recommend_y = math.max(self.scroll_view:getViewSize().height - height, recommend_y)
	local y = self.reset_offset and recommend_y or self.scroll_view:getContentOffset().y
	-- self.scroll_view:setContentOffset(cc.p(0, self.scroll_view:getViewSize().height - height))
	self.scroll_view:setContentOffset(cc.p(0, y), true)
    self.reset_offset = false

-- 更新次数
	local num = ex.Player.daily_dungeon_data:getMissionCount(self.layer_type)

	local limit_num = ex.Tools:getSysCfg("daily_mission_free_tickets") + cfg.goddessvip.goddessvip[ex.Player.fetter_data.vip.vip_level].extra_resource_times
	self.lbl_num:setString(string.format(ex.Tools:getLang(41246), math.max(0, limit_num - num)))
end

function MissionLayer:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function MissionLayer:onBattleStart(tag, pSender)
	-- 提升你的vip等级。
	local cell = pSender:getParent():getParent()

	local count_status = ex.Player.daily_dungeon_data:getMissionCountStatus(cell.type)
	if count_status == 3 then
		-- if ex.Player.vip_level + 1 >= table.nums(cfg.vip.vip) then
		-- 	ex.MessageView:add(ex.Tools:getLang(2902))
		-- else
		-- 	ex.MessageView:add(ex.Tools:getLang(2901))
		-- end
		ex.MessageView:add(ex.Tools:getLang(2901))
		return
	elseif count_status == 2 then
		--local need_gem = ex.Tools:getSysCfg("daily_mission_tickets_cost_gem")
		local need_gem = ex.Player.daily_dungeon_data:getNowTypeCost(cell.type)
		if ex.Player.gem < need_gem then
			ex.MessageView:add(ex.Tools:getLang(47428))
			return
		end
		-- ex.Player:addRes(ItemType.IT_GEM, -need_gem)
	end

	-- 判断是否打过该关卡
	local mission_id = ex.Player.daily_dungeon_data:getMissionId(cell.type)
	if mission_id < cell.data.mission then
		if cell.data.mission - mission_id > 1 then
			ex.MessageView:add(ex.Tools:getLang(41150))
			return
		end
		
		local map_bg_idx = 4 + cell.type
		if cell.type == 4 then
			map_bg_idx = 9
		end
		local map_config = cfg.map.map[map_bg_idx]

		local battle_layer = self:addBattleLayer(BattleType.DAILY, 
												MainSceneType.MISSION, 
												map_config.play_mode, 
												EVENT.DAILY_DUNGEON_EVENT.BATTLE_START,
												function(layer, data, vec_reward, ext)
													require("src.layer.chapterend.ChapterEndCtr"):instance():openWindow({
														battle_type = BattleType.DAILY,
														is_win = data.isWin,
														vec_reward = vec_reward,
														detail = layer.report.log,
														data = ext,
													})

													if data.isWin then
														local clergy_type
														if self.layer_type == 1 then
															clergy_type = CLERGY_PRIVILEGE_TYPE.GOLD_MISSION
														elseif self.layer_type == 2 then
															clergy_type = CLERGY_PRIVILEGE_TYPE.EXP_MISSION
														elseif self.layer_type == 3 then
															clergy_type = CLERGY_PRIVILEGE_TYPE.HERO_MISSION
														elseif self.layer_type == 4 then
															clergy_type = CLERGY_PRIVILEGE_TYPE.FETTER_MISSION
														elseif self.layer_type == 5 then
															clergy_type = CLERGY_PRIVILEGE_TYPE.RUNE_MISSION
														end

														local is_clergy_privilege = cfg.clergyprivilege.isPrivilege(clergy_type, ex.Player.clergy_level)
														require("src.layer.chapterend.ChapterEndCtr"):instance():addBottomTip(ex.Tools:getLang(is_clergy_privilege and (ext.is_clergy_add ~= 0 and 49308 or 49309) or 49307))
													end

													return true, false
												end)
		battle_layer:setPosition(-(ex.p.width * 0.5 - self:getContentSize().width * 0.5), -(ex.p.height * 0.5 - self:getContentSize().height * 0.5))
		
		self:sendBattleMsg(cell.data.mission, cell.type, 0)

		ex.Tools:autoPlaySceneMusic()
	else
		-- 已经打过该关卡
		self:sendBattleMsg(cell.data.mission, cell.type, 1)
		self:updateLayer()
	end
end

function MissionLayer:sendBattleMsg(mission, type, sweep)
	-- 请求战斗结束
    local req_battle_end = DailyDungeon_pb.GReqDailyDungeonEnd()
	req_battle_end.mission_id = mission
	req_battle_end.mission_type = type
	req_battle_end.sweep = sweep
    NetManager:sendMessage(ProtocolID.GReqDailyDungeonEnd, req_battle_end)
end

-- 层切入时会被调用
function MissionLayer:changeLayerIn()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, true)
end

function MissionLayer:changeLayerOutEnd()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, false)
end

return MissionLayer
