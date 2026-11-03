local VideoStudioSaveCtr = class("VideoStudioSaveCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local VideoStudioSaveLayer = class("VideoStudioSaveLayer", require("src.comp.EventLayerAdaptiveWidth"))

function VideoStudioSaveLayer:onCreate()
	self:addBlackBackground()
	self.lbl_title:setString(ex.Tools:getLang(73007))
	self.lbl_tips:setVisible(true)
	self:registerBtnEvent()
	self:createTableView()
	self:registerEvent()
end

function VideoStudioSaveLayer:registerEvent( )
	self:addEvent(EVENT.VIDEO_STUDIO_EVENT.MY_VIDEO_LIST,handler(self,self.onVideoList))
	self:addEvent(EVENT.VIDEO_STUDIO_EVENT.FAVORTE_BY_UPDATE,handler(self,self.onFavorite))
	self:addEvent(EVENT.VIDEO_STUDIO_EVENT.FAVORTE_CANNEL_BY_UPDATE,handler(self,self.onFavorite))
	-- self:addEvent(EVENT.VIDEO_STUDIO_EVENT.VIDEO_PLAY_BACK,handler(self,self.onBattle))
	self:addEvent(EVENT.VIDEO_STUDIO_EVENT.VIDEO_PLAY_BACK_REQ_MY,handler(self,self.onBattleReq))
end

function VideoStudioSaveLayer:onBattleReq(event,data)
	local req_battle = Battle_pb.GReqBattleReport()
    req_battle.battle_id = data.battle_id
    req_battle.type = data.type
	NetManager:sendMessage(ProtocolID.GReqBattleReport, req_battle)

	-- local scale_x = 

    local battle_layer = self:addBattleLayer(BattleType.PVP_DEFENSE,
                                            MainSceneType.MAINCITY_LAYER,
                                            "",
                                            data.type,
                                            function()
                                                return true, false
                                            end)
	battle_layer:showCloseBtn(true)
	battle_layer:showSpeedBtn(true,false)
	battle_layer:setScale(1.0 / math.max(self:getScaleX(), self:getScaleY()))
    battle_layer:setPosition(self:getContentSize().width * 0.5 - ex.p.width  * 0.5,
	                        self:getContentSize().height * 0.5 - ex.p.height * 0.5)
end

function VideoStudioSaveLayer:onFavorite(event,data)
	local video_data = ex.Player.video_studio_data:getMyVideos(self.cur_tag)
	self.cell_data = video_data.videos
	-- local offsetY = self.tableView:getContainer():getPositionY()
    self.tableView:initData(self.cell_data)
    -- self.tableView:setContentOffset(cc.p(0,offsetY))
end

function VideoStudioSaveLayer:registerBtnEvent( )
	self.btn_close:registerScriptTapHandler(handler(self, self.onClose))
end

function VideoStudioSaveLayer:onVideoList(tag,pSender)
	print(self.__cname,tag)
	
	local video_data = ex.Player.video_studio_data:getMyVideos(self.cur_tag)
	self.cell_data = video_data.videos

	if not self.tableView then 
		local size = self.spr_bg:getContentSize()
		self.tableView = ex.Tools:initTableView(self.spr_bg,self.cell_data, {require("src.layer.videostudio.VideoStudioCell"),"ccbi/VideoStudioCell.ccbi"} , cc.size(size.width,size.height - 15), 10,cc.p(0,5))
	end
	self.tableView:initData(self.cell_data)
end

function VideoStudioSaveLayer:createTableView( )
	self.cell_data = {}
    -- for i=1,10 do
    --     table.insert(self.cell_data,i)
    -- end

    local size = self.spr_bg:getContentSize()
    
    self.tableView = ex.Tools:initTableView(self.spr_bg,self.cell_data, {require("src.layer.videostudio.MyVideoStudioCell"),"ccbi/VideoStudioCell.ccbi"} , cc.size(size.width,size.height - 15), 10,cc.p(0,5))
	self.tableView:initData(self.cell_data)
end

function VideoStudioSaveLayer:onClose(tag,pSender)
    VideoStudioSaveCtr:instance():closeWindow()
end

function VideoStudioSaveLayer:onExit(tag,pSender)
    ex.Player.video_studio_data:setMyVideos({})
end


-----------------------------------------------------------------------------
function VideoStudioSaveCtr:onCreate()
	self:setCCBIPath("ccbi/VideoStudioSaveLayer.ccbi")
	self:setIsSingle(false)
end

function VideoStudioSaveCtr:getLayerClass()
	return VideoStudioSaveLayer
end

function VideoStudioSaveCtr:getPvpEndLayer()
	return self.layer
end

function VideoStudioSaveCtr:openWindow(tag)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/summon-effect.plist")
	sfc:addSpriteFrames("ccbi-res/hero-select.plist")

	self:loadLayer()
	self:open()
	self.tag = tag
	self:initData(tag)
end

function VideoStudioSaveCtr:initData(tag)
	local str_idx = tag == 2 and 73007 or 73008

	local tips_idx = tag == 1 and 73006 or 73028
	
	 self.layer.lbl_title:setString(ex.Tools:getLang(str_idx))
	 self.layer.lbl_tips:setString(ex.Tools:getLang(tips_idx))
	--  self.layer.lbl_tips:setVisible(tag==1)
	local req_done = Video_pb.GReqMyVideos()
	req_done.kind = tag
	NetManager:sendMessage(ProtocolID.GReqMyVideos, req_done)	
end


return VideoStudioSaveCtr
