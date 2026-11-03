local NoticeData = class("NoticeData")

function NoticeData:ctor()
	self.notice_list = {}		-- {type, interval_time, title, notice, sta_time, end_time, last_show_time}
	self.last_refresh_time = 0

	self.timer_id = nil

	self.channel_id = cpp.SocialPlatform:instance():getChannelId()
	self.pf_id = cpp.SocialPlatform:instance():getPfId()
	self.platform_str = tonumber(cpp.SocialPlatform:instance():getPlatformStr())
	
end

function NoticeData:clean()
	if self.timer_id ~= nil then
		ex.Timer:removeTimerById(self.timer_id)
	end
end

function NoticeData:onRefresh()
	local now = ex.Game:getServerTime()
	if now - self.last_refresh_time > 10 then
		self.last_refresh_time = now
		local req_notice = Role_pb.GReqNotice()
		req_notice.channel_id = tonumber(self.channel_id) 
		req_notice.pf_id = tonumber(self.pf_id )
		req_notice.platform = tonumber(self.platform_str)
		NetManager:sendMessage(ProtocolID.GReqNotice, req_notice)
	end
end

function NoticeData:isHaveNoticeForShow(show_type)
	for k, v in pairs(self.notice_list) do
		if v.show_type == show_type then
			return true
		end
	end
	return false
end

function NoticeData:addTimer()
	-- if self.timer_id ~= nil then
	-- 	-- 移除已有的timer
	-- 	ex.Timer:removeTimerById(self.timer_id)
	-- 	self.timer_id = nil
	-- end

	-- self.timer_id = ex.Timer:addTimer(1000, handler(self, self.updateTimer), true)
end

function NoticeData:updateTimer()
	local now = ex.Game:getServerTime()

	self:onRefresh()

	-- 公告跑马灯刷新显示
	for k, v in pairs(self.notice_list) do
		if v.show_type == 2 and v.start_time <= now and v.end_time >= now then
			if now - v.last_show_time > v.delay_time then
				ex.MessageView:addNotice(v.notice)
				v.last_show_time = now
			end
		end
	end
end

return NoticeData