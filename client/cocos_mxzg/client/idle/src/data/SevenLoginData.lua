local SevenLoginData = class("SevenLoginData")
 
function SevenLoginData:ctor()
	self.seven_day_cfg = {}			-- 七天显示的配置
	-- self.seven_day_point_cfg = {}	-- 七天进度条的配置
	self.cur_target_day = 0			-- 七天目标结束事件
	self.cur_day = 0				-- 七天登录结束事件
	self.end_time = 0				-- 七天目标结束时间
	self.login_end_time = 0			-- 七天登录结束时间
	self.task_num = 0					-- 活跃度
	self.seven_day_data = {}		-- 七天数据
	self.seven_day_geted = {}		-- 七天领取记录
	self.seven_day_box_geted = {}   -- 七天盒子领取记录
	self.seven_day_box_red = {}		-- 七天盒子红点
	self.seven_day_red = {}			-- 七天目标红点


	self.seven_login_geted = {}   	-- 七天登录领取记录
	self.seven_login_red = false    -- 七天登录红点
	self.login_cur_day = 0

end


-------------------七天登录__stard-----------------

function SevenLoginData:stardLoginTimer()
	-- self.login_id = ex.Timer:addTimer(1000, handler(self,self.changLoginTime), true)
end

function SevenLoginData:changLoginTime()
	-- local serverTime = ex.Game:getServerTime()
	-- if not self.login_end_time then self.login_end_time = 0 end
	-- local time = self.login_end_time - serverTime
	-- if time <= 0 then 
	-- 	self.login_cur_day = 0
	-- 	ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END,"act_sevent_day_gift")
	-- 	self:removeTargetTimer()
	-- 	return 
	-- end
end

function SevenLoginData:loginGiftIsOpen()
	local open = false
	for k,v in pairs(self.seven_login_geted) do
		if v == 0 then 
			open = true
			break
		end
	end
	return open
end

function SevenLoginData:removeLoginTimer()
	if self.login_id then 
		ex.Timer:removeTimerById(self.login_id)
		self.login_id = nil
	end
end

function SevenLoginData:setLoginCurDay(day)
	if day > 7 then day = 7 end
	self.login_cur_day = day
end

function SevenLoginData:getLoginCurDay()
	return self.login_cur_day
end

function SevenLoginData:setSevenDayLoginStatus(day,status)
	self.seven_login_geted[day] = status
end

function SevenLoginData:getSevenDayLoginStatus(day)
	return self.seven_login_geted[day]
end

function SevenLoginData:setLoginEndTime(time)
	self.login_end_time = time or 0
end

function SevenLoginData:getLoginEndTime()
	return self.login_end_time
end

function SevenLoginData:checkLoginRedPoint()
	for k,v in pairs(self.seven_login_geted) do
		if k <= self.login_cur_day then 
			if v == 0 then return true end
		end
	end
	return false 
end

function SevenLoginData:reqSevenDayLogin()
    -- local req_seven_day = cpp.ByteArray:create()
    -- req_seven_day:writeInt(ProtocolID.GReqSevenDayLoginData)
	-- cpp.NetManager:instance():sendByteArray(req_seven_day)
	NetManager:sendMessage(ProtocolID.GReqSevenDayLoginData)
end

-------------------七天登录__end-----------------

-- function SevenLoginData:getDayRedPoint(day)

-- 	local data = self.seven_day_cfg[day]
-- 	local red_points = {}
-- 	for _,val in pairs(data) do
-- 		for k,v in pairs(val) do
-- 			local isRed = self.seven_day_red[v.idx]
-- 			if isRed then 
-- 				if not red_points[v.tag] then red_points[v.tag] = isRed end
-- 				break
-- 			end
-- 		end
-- 	end
-- 	return red_points
-- end

function SevenLoginData:setBoxRedPoint(idx,bool)
	self.seven_day_box_red[idx] = bool
end

function SevenLoginData:getBoxRedPointByIdx(idx)
	return self.seven_day_box_red[idx]
end


-- 清除
function SevenLoginData:clear()
	self:removeTargetTimer()
	self:removeLoginTimer()
	self.seven_day_cfg = nil
	-- self.seven_day_point_cfg = nil
	self.end_time = nil
	self.login_end_time = nil
	self.task_num = nil
	self.seven_day_data = nil
	self.seven_day_geted = nil
	self.seven_day_box_geted = nil
	self.seven_day_box_red = nil
	self.seven_day_red = nil
	self.seven_login_geted = nil
	self.cur_target_day = nil
	self.cur_day = nil

end

function SevenLoginData:refreshDayRed(  )

	local red = self:checkLoginRedPoint()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCQTDL,red)
end 


return SevenLoginData
