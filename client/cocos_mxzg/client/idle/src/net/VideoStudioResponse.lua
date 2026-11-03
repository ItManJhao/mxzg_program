local VideoStudioResponse = class("VideoStudioResponse")

function VideoStudioResponse:setVideoList(data)
    -- print("VideoStudioResponse:setVideoList")
    -- dump_pbmsg(data)
    -- dump(data)
    ex.Player.video_studio_data:setVideosByType(data)
    ex.EventManager:fire(EVENT.VIDEO_STUDIO_EVENT.UPDATE_VIDEO_DATA_BY_TYPE)
end

--头像
function VideoStudioResponse:favoriteVideo(data)
    -- print("VideoStudioResponse:favoriteVideo")
    -- dump_pbmsg(data)
    -- dump(data)
    ex.Player.video_studio_data:favoriteVideo(data)
    ex.Player.video_studio_data:favoriteVideoWithMyVideo(data)
    ex.EventManager:fire(EVENT.VIDEO_STUDIO_EVENT.FAVORTE_BY_UPDATE)
end

function VideoStudioResponse:favoriteCancel(data)
    -- print("VideoStudioResponse:favoriteCancel")
    -- dump_pbmsg(data)
    -- dump(data)
    ex.Player.video_studio_data:favoriteCancel(data)
    ex.Player.video_studio_data:favoriteCancelWithMyVideo(data.keep_id)
    ex.EventManager:fire(EVENT.VIDEO_STUDIO_EVENT.FAVORTE_CANNEL_BY_UPDATE)
end

function VideoStudioResponse:onBattle(data)
    -- print("VideoStudioResponse:onBattle")
    -- dump_pbmsg(data)
    -- dump(data)
    ex.EventManager:fire(EVENT.VIDEO_STUDIO_EVENT.SHARE_BATTLE_PLAY_BACK,data)

end

function VideoStudioResponse:onMyVideos(data)
    -- dump(data)
    ex.Player.video_studio_data:setMyVideos(data)
    ex.EventManager:fire(EVENT.VIDEO_STUDIO_EVENT.MY_VIDEO_LIST)
end

function VideoStudioResponse:onCompare(data)
    -- dump(data)
    ex.EventManager:fire(EVENT.COMPARE_EVENT.COMPARE_BATTLE_LOG_RES,data)
end

return VideoStudioResponse
