local PvpHistoryCtr = class("PvpHistoryCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PvpHistoryLayer = class("PvpHistoryLayer", require("src.comp.EventLayerAdaptiveWidth"))
local PvpHistoryCell = class("PvpHistoryCell", require("src.comp.LuaLayerBase"))

function PvpHistoryCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
end


function PvpHistoryLayer:onCreate()
	local history_ctr = PvpHistoryCtr:instance()
	local win_size = cc.Director:getInstance():getWinSize();
	local height = Maths.min(self:getContentSize().height, win_size.height);
	self:setScale(height / self:getContentSize().height);
	self.btn_close:registerScriptTapHandler(handler(history_ctr, history_ctr.closeWindow))

end

-----------------------------------------------------------------------------
function PvpHistoryCtr:onCreate()
	self:setCCBIPath("ccbi/PvpHistoryLayer.ccbi")
	self:setIsSingle(false)
end

function PvpHistoryCtr:getLayerClass()
	return PvpHistoryLayer
end

function PvpHistoryCtr:getPvpHistoryLayer()
	return self.layer
end

function PvpHistoryCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData()
end

function PvpHistoryCtr:initData()
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	
	self:updateLayer()
end

function PvpHistoryCtr:updateLayer()
	if not self:getLayer() then
		return 
	end

	local layer = self.layer
	local history_list = ex.Player.pvp_data.history_id_list
    local sfc = cc.SpriteFrameCache:getInstance()
    local cell_size = PvpHistoryCell:createWithCCBIFile("ccbi/PvpHistoryCell.ccbi"):getContentSize()
    cell_size.height = cell_size.height + 5
    local scale = layer.scroll_view:getViewSize().width / cell_size.width
    cell_size.height = cell_size.height * scale + 5

    local height = table.nums(history_list) * cell_size.height
    height = math.max(height , layer.scroll_view:getViewSize().height)
    layer.scroll_view:getContainer():removeAllChildren()
    layer.scroll_view:setContentSize(cc.size(layer.scroll_view:getViewSize().width, height))
    layer.scroll_view:setContentOffset(cc.p(0, layer.scroll_view:getViewSize().height - height))

    for i,v in ipairs(history_list) do
    	local data = ex.Player.pvp_data.history_list[v]

    	if data then
    		local cell = PvpHistoryCell:createWithCCBIFile("ccbi/PvpHistoryCell.ccbi")
        	cell.data = data
        	cell:setScale(scale)
        	cell:setPosition(0, height - i * cell_size.height)
        	layer.scroll_view:getContainer():addChild(cell)
		
			-- 自身数据
        	cell.lbl_level_self:setString(tostring(data.atk_lv))
			cell.lbl_name_self:setString(data.atk_name)
			local frame = sfc:getSpriteFrame(string.format("head-icon/%d.png", data.atk_head))
			if not frame then
				frame = sfc:getSpriteFrame(string.format("head-icon/%d.png", 0))
			end
			cell.spr_head_self:setSpriteFrame(frame)

			local frame1 = sfc:getSpriteFrame(ex.Tools:getBorderIconByIdx(data.atk_border))
			if not frame1 then
				frame1 = sfc:getSpriteFrame(ex.Tools:getBorderIconByIdx(0))
			end
			cell.spr_clan_photo:setSpriteFrame(frame1)

			-- 敌人数据
        	cell.lbl_level_enemy:setString(tostring(data.def_lv))
			cell.lbl_name_enemy:setString(data.def_name)
			frame = sfc:getSpriteFrame(string.format("head-icon/%d.png", data.def_head))
			if not frame then
				frame = sfc:getSpriteFrame(ex.Tools:getBorderIconByIdx(0))
			end
			cell.spr_head_enemy:setSpriteFrame(frame)

			frame = sfc:getSpriteFrame(ex.Tools:getBorderIconByIdx(data.def_border))
			if not frame then
				frame = sfc:getSpriteFrame(ex.Tools:getBorderIconByIdx(0))
			end
			cell.spr_border_enemy:setSpriteFrame(frame)

			-- 其他数据
			local attack_text = data.type == 2 and ex.Tools:getLang(47138) or ex.Tools:getLang(47212)
			local win_text = data.result == 0 and ex.Tools:getLang(47668) or ex.Tools:getLang(47259)
			cell.lbl_score:setString(tostring(data.cup_delta))
			cell.btn_battle:registerScriptTapHandler(handler(self, self.onBattle))
			cell.lbl_battle_status:setString(attack_text..win_text)
    	end
    end
end

function PvpHistoryCtr:onBattle(tag, pSender)
	require("src.layer.PvpCtr"):instance():closeWindow(tag, pSender)
	local cell = pSender:getParent():getParent()
	local req_report = Battle_pb.GReqBattleReport()
	req_report.battle_id = cell.data.battle_id
	req_report.type = EVENT.PVP_EVENT.BATTLE_HISTORY
	NetManager:sendMessage(ProtocolID.GReqBattleReport, req_report)

	local layer_main_city = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MAINCITY_LAYER)
	local battle_layer = layer_main_city:addBattleLayerAuto(BattleType.PVP_DEFENSE,
															MainSceneType.MAINCITY_LAYER,
															MainSceneType.MAINCITY_PVP_BATTLE,
	 														"",
															 EVENT.PVP_EVENT.BATTLE_HISTORY,
															function()
																if ex.MainSceneCtr:getCurLayerType() == MainSceneType.MAINCITY_PVP_BATTLE then
																	require("src.layer.PvpCtr"):instance():openWindow()
																	PvpHistoryCtr:instance():openWindow()
																end
																return true, false
															end)
	battle_layer:setRemoveParentKeepType(false)
	battle_layer:setConflict(false)
	battle_layer:showCloseBtn(true)
	ex.Tools:autoPlaySceneMusic()
	self:closeWindow(tag, pSender)

	-- local cell = pSender:getParent():getParent()
	-- local battle_data = {}
	-- battle_data.clan_skill = {}
	-- battle_data.artifact_list = {}

	-- battle_data.battle_id = cell.data.battle_id

	-- local team1 = {}
	-- team1.team = 1
	-- team1.role_id = ex.Player.role_id
	-- team1.hero_list = cell.data.self_list
	-- table.insert(battle_data, team1)

	-- local artifact = cell.data.self_fetter
    -- if artifact and artifact.type > 0 then
    --     artifact.role_id = ex.Player.role_id
    --     table.insert(battle_data.artifact_list, clone(artifact))
    -- end


	-- local team2 = {}
	-- team2.team = 2
	-- team2.role_id = cpp.Game:makeLuaId()
	-- team2.hero_list = cell.data.enemy_list
	-- table.insert(battle_data, team2)

	-- artifact = cell.data.enemy_fetter
    -- if artifact and artifact.type > 0 then
    --     artifact.role_id = team2.role_id
    --     table.insert(battle_data.artifact_list, clone(artifact))
    -- end

    
	-- battle_data.equip_list = cell.data.equip_list
	-- battle_data.clan_skill[ex.Player.role_id] = cell.data.self_clan
	-- battle_data.clan_skill[team2.role_id] = cell.data.enemy_clan
	-- battle_data.runes_list = cell.data.runes_list
	
	-- self:battleStart(battle_data)
	-- self:closeWindow(tag, pSender)
end


function PvpHistoryCtr:battleStart(data)
	-- dump(data)
	local layer_main_city = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MAINCITY_LAYER)
	local battle_layer = require("src.layer.PvpBattleLayer"):create()
	battle_layer:setBattleIdLua(data.battle_id)
	battle_layer:initHeroData(data)
	battle_layer:setBattleEndCallback(handler(self, self.onBattleEnd))
	layer_main_city:addKeepLayer(MainCityType.PVP_BATTLE, battle_layer)
	layer_main_city:addChild(battle_layer, 999)
end


function PvpHistoryCtr:onBattleEnd(is_win, layer)
	local battle_id = layer:getBattleIdLua()
	local layer_main_city = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MAINCITY_LAYER)
	layer:remove()
	layer_main_city:removeKeepLayer(MainCityType.PVP_BATTLE)

	-- 判断当前主城界面是否显示
	layer_main_city = ex.MainSceneCtr:getMainSceneLayer(MainSceneType.MAINCITY_LAYER)
	if layer_main_city then
		require("src.layer.PvpCtr"):instance():openWindow()
	end
end

return PvpHistoryCtr
