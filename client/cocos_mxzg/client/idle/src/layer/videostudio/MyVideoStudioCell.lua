local MyVideoStudioCell = class("MyVideoStudioCell", require("src.layer.videostudio.VideoStudioCell"))

function MyVideoStudioCell:setTableView(table)
    self.tableView = table
    self.btn_menu:setIsTouchInsideNode(self.tableView)
    self.btn_menu:setSwallowsTouches(false)
end

function MyVideoStudioCell:onPlayBack( tag,pSender )
    local data = {}
    data.battle_id = self.data.battle_log.battleId
    data.type = EVENT.VIDEO_STUDIO_EVENT.VIDEO_PLAY_BACK_MY
    ex.EventManager:fire(EVENT.VIDEO_STUDIO_EVENT.VIDEO_PLAY_BACK_REQ_MY,data)
end

function MyVideoStudioCell:onSaved( tag,pSender )
    local req = Video_pb.GReqKeepFavorite()
    -- local video_data = ex.Player.video_studio_data:getMyVideos()
    -- req.keep_type = video_data.kind == 1 and 2 or 1 --self.data.type
    req.keep_type = 2

    req.id = self.data.id
    -- print(self.__cname,"type",req.keep_type,"id",req.id)
    -- req.id = self.data.hall_id ~= 0 and self.data.hall_id or self.data.vid
	NetManager:sendMessage(ProtocolID.GReqKeepFavorite,req)
    
end

return MyVideoStudioCell