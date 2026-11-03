local MailData = class("MailData")

function MailData:ctor()
	self.data = {}
	self.last_refresh_time = 0
end

function MailData:clean()
	if self.timer_id ~= nil then
		ex.Timer:removeTimerById(self.timer_id)
	end
end

function MailData:addTimer()
	-- if self.timer_id ~= nil then
	-- 	-- 移除已有的timer
	-- 	ex.Timer:removeTimerById(self.timer_id)
	-- 	self.timer_id = nil
	-- end

	-- self.timer_id = ex.Timer:addTimer(1000, handler(self, self.updateTimer), true)
end

function MailData:updateTimer()
	local now = ex.Game:getServerTime()

	if now - self.last_refresh_time > 60 then
		self.last_refresh_time = now
	
		NetManager:sendMessage(ProtocolID.GReqMailList)
	end
end

function MailData:sortMailIsRead()

    -- 1、是否已读， 未读的在上面
    -- 2、是否有礼物， 未领取的在上面
    -- 3、按照邮件时间， 时间最新的在上面
	table.sort(self.data, function(a, b)
	-- local compA = 	((not a.is_read) 					and  120  or  0)
		local compA = 	((a.is_read >= b.is_read) 			and  120  or  0) 
		compA = compA + ((table.nums(a.vec_reward) == 0)	and  50   or  0)
		compA = compA + ((not a.is_receive)					and  20   or  0)
		compA = compA + ((a.time <= b.time)					and  10   or  0)

	-- local compB = 	((not b.is_read) 					and  120  or  0)
		local compB = 	((b.is_read >= a.is_read) 			and  120  or  0)
		compB = compB + ((table.nums(b.vec_reward) == 0)    and  50   or  0)
		compB = compB + ((not b.is_receive)					and  20   or  0)
		compB = compB + ((b.time <= a.time)					and  10   or  0)
		return compA < compB
	end)
end

function MailData:getMailData(mail_id)
	for k,v in pairs(self.data) do
		if v.mail_id == mail_id then
			return v
		end
	end
end

function MailData:delMailData(mail_id)
	-- 删除对应的邮件
	for i=#self.data,1,-1 do
    	if self.data[i].mail_id == mail_id then
        	table.remove(self.data, i)
    	end
	end
end

function MailData:hasUnreadMail()
	for k,v in pairs(self.data) do
		if v.is_read == 0 then
			return true
		end
	end
	return false
end

function MailData:checkRedDot()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_YJ, self:hasUnreadMail())
end

return MailData