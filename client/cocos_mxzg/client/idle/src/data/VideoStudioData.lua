local VideoStudioData = class("VideoStudioData")

function VideoStudioData:ctor()
    self.video_list = {}
    self.my_video_list = {}
    self.can_share = true
    self.delay_time = 0
end

function VideoStudioData:removeTimer( )
    if self.timer_id then 
        ex.Timer:removeTimerById(self.timer_id)
    end
    self.timer_id = nil
end

function VideoStudioData:addTimer( )
    self:removeTimer()
    self.delay_time = 10 
    self.can_share = false
    self.timer_id = ex.Timer:addTimer(1000, function()
        self.delay_time = self.delay_time - 1
        print(self.__cname,self.delay_time)
        if self.delay_time <= 0 then 
            self.can_share = true
            self:removeTimer()
        end
    end, true)

end

function VideoStudioData:canShare( )
    return self.can_share
end

function VideoStudioData:getDelayTime( )
    return self.delay_time
end

function VideoStudioData:setVideosByType(data)
    self.video_list = data
end

function VideoStudioData:favoriteCancel(data)
    for k,v in pairs(self.video_list.videos) do
        if v.keep_id == data.keep_id then 
            v.keep_id = 0
            break
        end
    end
end

function VideoStudioData:favoriteVideo(data)
    for k,v in pairs(self.video_list.videos) do
        if v.hall_id == data.video.hall_id then 
            v.vid = data.video.vid
            v.keep_id = data.video.keep_id
            break
        end
    end
end

function VideoStudioData:favoriteVideoWithMyVideo(data)
    if self.my_video_list.videos == nil then return end
    -- if self.my_video_list.kind == 2 then return end 
    for k,v in pairs(self.my_video_list.videos) do
        if v.hall_id == data.video.hall_id then 
            v.vid = data.video.vid
            v.keep_id = data.video.keep_id
            -- v.vid = 0
            -- if self.my_video_list.kind == 2 then 
            --     table.remove(self.my_video_list.videos,k)
            -- else
            --     v.keep_id = 0
            -- end
            break
        end
    end
end

function VideoStudioData:getVideosByType(type)
    return self.video_list--[type] or {}
end

function VideoStudioData:setMyVideos(data)
    self.my_video_list = data
end

function VideoStudioData:getMyVideos()
    return self.my_video_list
end

function VideoStudioData:favoriteCancelWithMyVideo(keep_id)
    if self.my_video_list.videos == nil then return end
    -- if self.my_video_list.kind == 2 then return end 
    for k,v in pairs(self.my_video_list.videos) do
        if v.keep_id == keep_id then 
            -- v.vid = 0
            if self.my_video_list.kind == 2 then 
                table.remove(self.my_video_list.videos,k)
            else
                v.keep_id = 0
            end
            break
        end
    end
end

function VideoStudioData:clean( )
    self:removeTimer()
end

return VideoStudioData