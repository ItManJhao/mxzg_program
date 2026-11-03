local TitleResponse = class("TitleResponse")

function TitleResponse:scanTitleList(data)
    local title_data = {}
    for i,v in ipairs(data.titles) do
        local now_title_data = {}
        now_title_data.idx = v.idx 
        if v.end_time  > 0 and v.end_time  < ex.Game:getServerTime() then 
            now_title_data.end_time = 0
        else 
            now_title_data.end_time = v.end_time 
        end 
        table.insert( title_data, now_title_data )
    end

    ex.Player.title_data:setData(title_data)
    
	local nslc = require("src.layer.SettingChooseCtr"):instance()
	if nslc:isOpened() then
		-- 重新刷新界面
		nslc:changeLayer()
	end

end

return TitleResponse