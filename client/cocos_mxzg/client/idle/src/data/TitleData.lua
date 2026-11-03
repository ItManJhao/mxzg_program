local TitleData = class("TitleData")


-- 招募完成度
function TitleData:ctor()
	self.save_my_title_data = {}
end

function TitleData:clear()
	self.save_my_title_data = {}
end

function TitleData:setData(data )


    self.save_my_title_data = data
    --dump(self.save_my_title_data)
end


function TitleData:getSortTitleData( )
   
    local return_data = {}
    for i,v in ipairs(cfg.title.title) do
        
        local now_data = clone(v)
        now_data.sort_index = 0   -- 0 表示未获取
        if self:checkTitleEndTime(v.idx) == -999 then 

        elseif self:checkTitleEndTime(v.idx) == -1 then 
            now_data.sort_index = 2
        elseif self:checkTitleEndTime(v.idx) > 0 then 
            now_data.sort_index = 1
        end 

        table.insert( return_data, now_data )
    end
    return return_data
end


function TitleData:checkTitle( title_id)
    
    for i,v in ipairs(self.save_my_title_data) do
        if v.idx == title_id then 
            return true
        end 
    end

    return false
end

function TitleData:checkTitleEndTime( title_id)
    
    for i,v in ipairs(self.save_my_title_data) do
        if v.idx == title_id  then 
            return v.end_time
        end 
    end

    return -999
end

return TitleData
