local VideoStudioCtr = class("VideoStudioCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local VideoStudioLayer = class("VideoStudioLayer", require("src.comp.EventLayerAdaptiveWidth"))

local btn_tab_list = {
	{idx = 1, label = 73002, tag = 1, tips = 73015, system_key = "video_hall_pve_num", battle_type = BattleType.PVP_DEFENSE},
	{idx = 2, label = 73003, tag = 2, tips = 73016, system_key = "video_hall_pve_clan_world_num", battle_type = BattleType.CLAN_BOSS},
	{idx = 3, label = 73004, tag = 3, tips = 73017, system_key = "video_hall_champion_num", battle_type = BattleType.CHAMPIONSHIP},
	{idx = 4, label = 73005, tag = 4, tips = 73018, system_key = "video_hall_ladder_num", battle_type = BattleType.LADDER_REPORT},
	{idx = 5, label = 73030, tag = 5, tips = 73029, system_key = "video_hall_compare_num", battle_type = BattleType.PVP_DEFENSE},
}

function VideoStudioLayer:onCreate()
	self:addBlackBackground()

	self.cur_tag = 1

	self:initScrollViewTab()

	self:registerBtnEvent()
	self:createTableView()
	self:registerEvent()

	local req_done = Video_pb.GReqVideos()
	req_done.type = 1
	NetManager:sendMessage(ProtocolID.GReqVideos, req_done)
end

function VideoStudioLayer:initScrollViewTab()
    local menu_tab = cpp.UIMenu:create()
    menu_tab:setIsTouchInsideNode(self.layer.scroll_view_tab)
    menu_tab:setSwallowsTouches(false)
    menu_tab:setPosition(cc.p(0, 0))
    self.layer.scroll_view_tab:addChild(menu_tab)

    -- 添加导航条
	local margin_x, space_x, item_size, scale = 4, 10, nil, 1
	for i,v in ipairs(btn_tab_list) do
        self.layer["btn_tab_"..i] = cpp.UIMenuItemTab:create("button/btn-tab-3.png", "button/btn-tab-4.png", "", 1, 1)
        self.layer["btn_tab_"..i]:setScale(scale)
        if not item_size then 
            item_size = self.layer["btn_tab_"..i]:getContentSize()
            item_size.width = item_size.width * scale
            item_size.height = item_size.height * scale
        end
        self.layer["btn_tab_"..i]:setTag(v.tag)
		self.layer["btn_tab_"..i]:registerScriptTapHandler(handler(self, self.onChangeTag))
        self.layer["btn_tab_"..i]:setAnchorPoint(ex.a.bottom_center)
        self.layer["btn_tab_"..i]:setPosition(margin_x + (i - 0.5) * item_size.width + (i - 1) * space_x, 0)
        menu_tab:addChild(self.layer["btn_tab_"..i])
        self.layer["btn_tab_"..i]:setLabelText(ex.Tools:getLang(v.label))
        self.layer["btn_tab_"..i]:setLabelColor(cc.c4b(122,71,45,255))
        self.layer["btn_tab_"..i]:setLabelOffset(cc.p(0, -3))
    end
    self.layer.scroll_view_tab:setContentSize(cc.size(2 * margin_x + 5 * item_size.width + (5 - 1) * space_x, self.layer.scroll_view_tab:getViewSize().height))
    self.layer.scroll_view_tab:setContentOffset(self.layer.scroll_view_tab:maxContainerOffset())

    self.layer["btn_tab_"..self.cur_tag]:setChecked(true)
end

function VideoStudioLayer:getTipsStr(tag)
	local num = cfg.system[btn_tab_list[tag].system_key] or 0
	return string.format(ex.Tools:getLang(btn_tab_list[tag].tips), num)
end

function VideoStudioLayer:registerEvent( )
	self:addEvent(EVENT.VIDEO_STUDIO_EVENT.UPDATE_VIDEO_DATA_BY_TYPE,handler(self,self.onChangeLayer))
	self:addEvent(EVENT.VIDEO_STUDIO_EVENT.FAVORTE_BY_UPDATE,handler(self,self.onFavorite))
	self:addEvent(EVENT.VIDEO_STUDIO_EVENT.FAVORTE_CANNEL_BY_UPDATE,handler(self,self.onFavorite))
	-- self:addEvent(EVENT.VIDEO_STUDIO_EVENT.VIDEO_PLAY_BACK,handler(self,self.onBattle))
	self:addEvent(EVENT.VIDEO_STUDIO_EVENT.VIDEO_PLAY_BACK_REQ,handler(self,self.onBattleReq))
end

-- function VideoStudioLayer:onBattle(event,data)
	
-- end

function VideoStudioLayer:onBattleReq(event,data)
	local req_battle = Battle_pb.GReqBattleReport()
    req_battle.battle_id = data.battle_id
    req_battle.type = data.type
	NetManager:sendMessage(ProtocolID.GReqBattleReport, req_battle)

    local battle_layer = self:addBattleLayer(btn_tab_list[self.layer.cur_tag].battle_type,
                                            MainSceneType.MAINCITY_LAYER,
                                            "",
                                            data.type,
                                            function()
                                                return true, false
                                            end)
	battle_layer:showCloseBtn(true)
	battle_layer:showSpeedBtn(true,false)
    battle_layer:setScale(1.0 / self:getScaleX())
    battle_layer:setPosition(self:getContentSize().width * 0.5 - ex.p.width  * 0.5,
	                        self:getContentSize().height * 0.5 - ex.p.height * 0.5)
end

function VideoStudioLayer:onFavorite(event,data)
	local video_data = ex.Player.video_studio_data:getVideosByType(self.cur_tag)
	self.cell_data = video_data.videos
	local offsetY = self.tableView:getContainer():getPositionY()
    self.tableView:initData(self.cell_data)
    self.tableView:setContentOffset(cc.p(0,offsetY))
end

function VideoStudioLayer:onChangeLayer(event,data)
	-- self.cell_data = {}
	local video_data = ex.Player.video_studio_data:getVideosByType(self.cur_tag)
	self.cell_data = video_data.videos
	for i=1,5 do
		local btn = self["btn_tab_"..i]
		if btn ~= nil then
			btn:setChecked(i == self.cur_tag)
		end
	end

	if not self.tableView then 
		local size = self.spr_bg:getContentSize()
		self.tableView = ex.Tools:initTableView(self.spr_bg,self.cell_data, {require("src.layer.videostudio.VideoStudioCell"),"ccbi/VideoStudioCell.ccbi"} , cc.size(size.width,size.height - 15), 10,cc.p(0,5))
	end
	self.tableView:initData(self.cell_data)
	self.lbl_tips:setString(self:getTipsStr(self.cur_tag))
end

function VideoStudioLayer:registerBtnEvent( )
	self.btn_record:registerScriptTapHandler(handler(self, self.onRecord))
	self.btn_saved:registerScriptTapHandler(handler(self, self.onSaved))
	self.btn_close:registerScriptTapHandler(handler(self, self.onClose))
end

function VideoStudioLayer:onChangeTag(tag,pSender)
	print(self.__cname,tag)
	if tag == self.cur_tag then return end 
	-- if tag == 3 then 
	-- 	ex.MessageView:add(ex.Tools:getLang(73025))
	-- 	return 
	-- end
	local req_done = Video_pb.GReqVideos()
	req_done.type = tag
	NetManager:sendMessage(ProtocolID.GReqVideos, req_done)
	self.cur_tag = tag
	self.lbl_tips:setString(self:getTipsStr(self.cur_tag))
end

function VideoStudioLayer:createTableView( )
	self.cell_data = {}
    -- for i=1,10 do
    --     table.insert(self.cell_data,i)
    -- end

    local size = self.spr_bg:getContentSize()
    
    self.tableView = ex.Tools:initTableView(self.spr_bg,self.cell_data, {require("src.layer.videostudio.VideoStudioCell"),"ccbi/VideoStudioCell.ccbi"} , cc.size(size.width,size.height - 15), 10,cc.p(0,5))
	self.tableView:initData(self.cell_data)
end

function VideoStudioLayer:onSaved(tag,pSender)
	print(self.__cname,tag,">>>>>>????")
    require("src.layer.videostudio.VideoStudioSaveCtr"):instance():openWindow(tag)
end

function VideoStudioLayer:onRecord(tag,pSender)
	print(self.__cname,tag,">>>>>>????")
	-- require("src.layer.videostudio.VideoStudioRecordCtr"):instance():openWindow()
	require("src.layer.videostudio.VideoStudioSaveCtr"):instance():openWindow(tag)
end

function VideoStudioLayer:onClose(tag,pSender)
    VideoStudioCtr:instance():closeWindow()
end


-----------------------------------------------------------------------------
function VideoStudioCtr:onCreate()
	self:setCCBIPath("ccbi/VideoStudioLayer.ccbi")
	self:setIsSingle(false)
end

function VideoStudioCtr:getLayerClass()
	return VideoStudioLayer
end

function VideoStudioCtr:getPvpEndLayer()
	return self.layer
end

function VideoStudioCtr:openWindow()
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/summon-effect.plist")
	sfc:addSpriteFrames("ccbi-res/hero-select.plist")

	self:loadLayer()
	self:open()
	-- self:initData(is_win, enemy_id, vec_reward, ext, callback)
end

function VideoStudioCtr:initData(is_win, enemy_id, vec_reward, ext, callback)

	
end


return VideoStudioCtr
