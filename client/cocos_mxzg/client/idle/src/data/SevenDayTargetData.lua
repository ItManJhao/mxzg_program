local SevenDayTargetData = class("SevenDayTargetData")

function SevenDayTargetData:ctor()
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

	self:initSevenDayCfg()


	self.save_select_day = 0
	self.save_select_item = 0

	self:clearSevenDayTargetList( )


	self.save_day_targetData = {}

end


-------------------七天登录__stard-----------------

function SevenDayTargetData:setSaveSelectDay(num)
	self.save_select_day = num
end

function SevenDayTargetData:setSaveSelectItem(num)
	self.save_select_item = num
end


function SevenDayTargetData:stardLoginTimer()
	-- self.login_id = ex.Timer:addTimer(1000, handler(self,self.changLoginTime), true)
end

function SevenDayTargetData:loginGiftIsOpen()
	local open = false
	for k,v in pairs(self.seven_login_geted) do
		if v == 0 then 
			open = true
			break
		end
	end
	return open
end

function SevenDayTargetData:changLoginTime()
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

function SevenDayTargetData:removeLoginTimer()
	if self.login_id then 
		ex.Timer:removeTimerById(self.login_id)
		self.login_id = nil
	end
end

function SevenDayTargetData:setLoginCurDay(day)
	if day > 7 then day = 7 end
	self.login_cur_day = day
end

function SevenDayTargetData:getLoginCurDay()
	return self.login_cur_day
end

function SevenDayTargetData:setSevenDayLoginStatus(day,status)
	self.seven_login_geted[day] = status
end

function SevenDayTargetData:getSevenDayLoginStatus(day)
	return self.seven_login_geted[day]
end

function SevenDayTargetData:setLoginEndTime(time)
	self.login_end_time = time or 0
end

function SevenDayTargetData:getLoginEndTime()
	return self.login_end_time
end

-- function SevenDayTargetData:checkLoginRedPoint()
-- 	for k,v in pairs(self.seven_login_geted) do
-- 		if k <= self.login_cur_day then 
-- 			if v == 0 then return true end
-- 		end
-- 	end
-- 	return false 
-- end

function SevenDayTargetData:reqSevenDayLogin()
    -- local req_seven_day = cpp.ByteArray:create()
    -- req_seven_day:writeInt(ProtocolID.GReqSevenDayLoginData)
	-- cpp.NetManager:instance():sendByteArray(req_seven_day)
	NetManager:sendMessage(ProtocolID.GReqSevenDayLoginData)
end

-------------------七天登录__end-----------------

-- function SevenDayTargetData:getDayRedPoint(day)

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

function SevenDayTargetData:stardTargetTimer()
	self.target_id = ex.Timer:addTimer(1000, handler(self,self.changTargetTime), true)
end

function SevenDayTargetData:changTargetTime()
	local serverTime = ex.Game:getServerTime()
	if not self.end_time then self.end_time = 0 end
	local time = self.end_time - serverTime
	if time <= 0 then 
		self.cur_target_day = 0
		ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END,"act_sevent_day_target")
		self:removeTargetTimer()
		return 
	end
end

function SevenDayTargetData:removeTargetTimer()
	if self.target_id then 
		ex.Timer:removeTimerById(self.target_id)
		self.target_id = nil
	end
end


function SevenDayTargetData:initBoxRedPoint()
	local config = ex.Player.promotion_data.promotion7daytargetpoint_value
	for k,v in pairs(config) do
		-- self.seven_day_box_red[v.idx] = self.seven_day_box_geted[v.idx] < 1 and self.task_num >= v.task_num
		local get_status = self.seven_day_box_geted[v.idx] or 1
		local num = self.task_num or 0
		self:setBoxRedPoint(v.idx,get_status < 1 and num >= v.task_num)
	end
end

function SevenDayTargetData:initSevenDayRedPoint()
	local config = ex.Player.promotion_data.promotion7daytarget_value
	self.seven_day_tag_red = {}
	for k,v in pairs(config) do
		-- self.seven_day_red[v.idx] = self.seven_day_geted[v.idx] < 1 and self.seven_day_data[v.idx] >= v.task_num
		local can_get = self:checkSevenDayRedPoint(v.idx)
		local not_get = (self.seven_day_geted[v.idx] or 1) < 1
		-- print(self.__cname,"______________",can_get,not_get)
		local isRed = can_get and not_get
		-- if isRed then print("isRed = " ,v.idx) end
		self:setSevenDayRedPoint(v.idx,isRed)
	end
end

function SevenDayTargetData:getBoxRedPoint()
	for k,v in pairs(self.seven_day_box_red) do
		if v == true then return v end
	end
	return false
end

function SevenDayTargetData:getSevenDayRedPoint()
	for k,v in pairs(self.seven_day_red) do
		if v == true then return v end
	end
	return false
end

function SevenDayTargetData:checkSevenDayRedPoint(idx)
	local bool = false
	-- add 熊梦 修改
	local config =self:getSevenDaytarget(idx)
	--local config = cfg.promotion7daytarget.target[idx]
	local cur_day = self.cur_target_day

	if config.day > cur_day then 
		return bool 
	elseif (self.seven_day_geted[idx] or 1) > 0 then --领取过的
		return bool 
	elseif config.kind == 2 then --购买任务	
		return bool
	elseif config.recharge_require > ex.Player.total_charge then --	VIP等级不够
		return bool
	end
	bool = self.seven_day_data[idx].num >= config.num
	return bool
end

function SevenDayTargetData:setBoxRedPoint(idx,bool)
	self.seven_day_box_red[idx] = bool
end

function SevenDayTargetData:getBoxRedPointByIdx(idx)
	return self.seven_day_box_red[idx]
end

function SevenDayTargetData:setSevenDayRedPoint(idx,bool)
	self.seven_day_red[idx] = bool
end

function SevenDayTargetData:getSevenDayRedPointByIdx(idx)
	return self.seven_day_red[idx]
end

function SevenDayTargetData:setSevenDayStatus(idx,status)
	self.seven_day_geted[idx] = status
end

-- function SevenDayTargetData:getSevenDayStatus(idx)
-- 	return self.seven_day_geted[idx]
-- end

function SevenDayTargetData:setSevenDayBox(idx,status)
	self.seven_day_box_geted[idx] = status
end

-- function SevenDayTargetData:getSevenDayBox(idx)
-- 	return self.seven_day_box_geted[idx] or 1
-- end

function SevenDayTargetData:setSevenDayData(data)
	self.seven_day_data[data.idx] = data
end

function SevenDayTargetData:getSevenDayData(idx)
	return self.seven_day_data[idx]
end

function SevenDayTargetData:setPoint(task_num)
	self.task_num = task_num 
end

-- function SevenDayTargetData:getPoint()
-- 	return self.task_num
-- end

function SevenDayTargetData:setEndTime(time)
	self.end_time = time or 0
end



function SevenDayTargetData:setCurDay(day)
	if day > 7 then day = 7 end
	self.cur_target_day = day
end


function SevenDayTargetData:getDayCfg()
	return self.seven_day_cfg
end

function SevenDayTargetData:getTaskTypeHasNum(type)
	
end

function SevenDayTargetData:reqSevenDayTarget()

	-- NetManager:sendMessage(ProtocolID.GReqSevenDayTargetData)
end

function SevenDayTargetData:initSevenDayCfg()
	-- print(self.__cname,"initSevenDayCfg")
	local config = cfg.promotion7daytarget.target

	for k,v in pairs(config) do
		if self.seven_day_cfg[v.day] == nil then self.seven_day_cfg[v.day] = {} end
		if self.seven_day_cfg[v.day][v.tag] == nil then self.seven_day_cfg[v.day][v.tag] = {} end
		table.insert(self.seven_day_cfg[v.day][v.tag],v)
	end

	local function sor(a,b)
		return a.idx < b.idx
	end

	for k,v in pairs(self.seven_day_cfg) do
		for i,val in pairs(v) do
			table.sort(val,sor)
		end
	end

end

-- 清除
function SevenDayTargetData:clear()
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





---------------------------------------------------新版--------------------------------------------------------------------
function SevenDayTargetData:getEndTime()
	return self.seven_day_target_list.end_time
end


function SevenDayTargetData:clearSevenDayTargetList( )
	self.seven_day_target_list = {}
	self.seven_day_target_list.list = {}
	self.seven_day_target_list.reward_box_idx = {}
	self.seven_day_target_list.end_time = 0
	self.seven_day_target_list.curr_day = 0
	self.seven_day_target_list.seven_day_value = 0

	-- 轮数
	self.seven_day_target_list.turns = 1
	-- 清除时间
	self.seven_day_target_list.clear_time = 0
	-- 活动id
	self.seven_day_target_list.id = 18
	-- 活动开始时间
	self.seven_day_target_list.start_time = 0

	self.save_day_targetData = {}
	
end

-- add 熊梦
-- 剔除非本轮的值，并排序
function SevenDayTargetData:removebyvalue(array, value, removeadll)
	local deleteNum,i,max=0,1,#array
    while i<=max do
        if array[i].turns ~= value then
            --    通过索引操作表的删除元素
            table.remove(array,i)
            --    标记删除次数
            deleteNum = deleteNum+1 
            i = i-1
            --    控制while循环操作
            max = max-1
            --    判断是否删除所有相同的value值
            if not removeadll then break end
        end
        i= i+1
	end
    return array
end


-- table深拷贝接口
function SevenDayTargetData:DeepCopy(t)
    if nil == t then return nil end
    local table = {}
    for k,v in pairs(t) do
        if 'table' == type(v) then
            table[k] = self:DeepCopy(v)
        else
            table[k] = v
		end
	end
    return table
end

function SevenDayTargetData:setSevenDayTargetList( data )

	-- repeated PSTaskData task = 1; //任务列表
    -- repeated int32 reward_box_idx = 2; //宝箱领奖记录
    -- required int32 seven_day_value = 3; //七日目标值
    -- required int32 end_time = 4; //活动结束时间
	-- required int32 curr_day = 5; //当前天数

	self:clearSevenDayTargetList()

	--self.seven_day_target_list.end_time = data.end_time  
	self.seven_day_target_list.curr_day = data.curr_day   -- 当前天数
	self.seven_day_target_list.seven_day_value = data.seven_day_value   --  当前目标值
	self.seven_day_target_list.reward_box_idx = {}   --  积分奖励
	self.seven_day_target_list.task_list = {}    -- 当前任务列表


	-- add 熊梦
	local promotion_id = 18 
	local turns = ex.Player.promotion_data:getPromotionTurns(promotion_id)
	-- turns = 2
	-- ex.Player.promotion_data.running_promotion_data[promotion_id].turns = 2

	self.seven_day_target_list.turns = ex.Player.promotion_data.running_promotion_data[promotion_id].turns
    self.seven_day_target_list.id = ex.Player.promotion_data.running_promotion_data[promotion_id].id
    self.seven_day_target_list.end_time = ex.Player.promotion_data.running_promotion_data[promotion_id].end_time     -- 结束时间
    self.seven_day_target_list.start_time = ex.Player.promotion_data.running_promotion_data[promotion_id].start_time -- 开始时间
	self.seven_day_target_list.clear_time = ex.Player.promotion_data.running_promotion_data[promotion_id].clear_time -- 结束时间后的界面保留时间

	local now_box_point_list = {}
	for i,v in ipairs(data.reward_box_idx) do
		now_box_point_list[v] = v
	end
	

	-- add 熊梦 进行深拷贝
	ex.Player.promotion_data.promotion7daytargetpoint_value = {}
	ex.Player.promotion_data.promotion7daytarget_value = {}
	ex.Player.promotion_data.promotion7daytargeticon_value = {}

	ex.Player.promotion_data.promotion7daytargetpoint_value = self:DeepCopy(cfg.promotion7daytargetpoint.point)
	ex.Player.promotion_data.promotion7daytarget_value = self:DeepCopy(cfg.promotion7daytarget.target) 
	ex.Player.promotion_data.promotion7daytargeticon_value = self:DeepCopy(cfg.promotion7daytargeticon.icon)

	-- 删除不属于本轮的数据
	self:removebyvalue(ex.Player.promotion_data.promotion7daytargetpoint_value,turns,true)
	self:removebyvalue(ex.Player.promotion_data.promotion7daytarget_value,turns,true)
	self:removebyvalue(ex.Player.promotion_data.promotion7daytargeticon_value,turns,true)
	
	for k,v in pairs(ex.Player.promotion_data.promotion7daytargetpoint_value) do
		local ndata = {}
		ndata.idx = v.idx
		ndata.task_num = v.task_num
		ndata.reward = v.reward
		ndata.isget = 0
		-- 轮数
		ndata.turns = v.turns
		if now_box_point_list[ndata.idx] then 
			ndata.isget = 1
		end 

		self.seven_day_target_list.reward_box_idx[ndata.idx] = ndata
	end

	local task_list = {}
	for i,v in ipairs(data.task) do
		local ndata = {}
		ndata.idx = v.idx
		ndata.process = v.process
		ndata.state = v.state
		task_list[ndata.idx] = ndata
	end

	for k,v in pairs(ex.Player.promotion_data.promotion7daytarget_value) do
		local ndata = {}
		ndata.idx = v.idx
		ndata.day = v.day
		ndata.tag = v.tag
		ndata.tag_lan = v.tag_lan
		ndata.kind = v.kind
		ndata.task = v.task
		ndata.cost = v.cost
		ndata.reward = v.reward
		ndata.lang = v.lang
		ndata.jump_info = v.jump_info
		ndata.process = 0
		ndata.state = 0
		ndata.turns = v.turns --add 熊梦 轮数
		
		if task_list[ndata.idx]  then 
			ndata.process = task_list[ndata.idx].process 
			ndata.state = task_list[ndata.idx].state 
		end 
		
		ndata.task.targetNum = 0
		if ndata.task.type == 'TOTAL_RECHARGE' then 
			ndata.process =  ndata.process * 0.01
			ndata.task.targetNum = ndata.task.target * 0.01
		else 
			ndata.task.targetNum = ndata.task.target
		end 

		-- if ndata.task.type == 'TOTAL_RECHARGE' then 
		-- 	ndata.process =  ndata.process * 0.01
		-- 	ndata.task.targetNum = ndata.task.target * 0.01
		-- else 
			-- ndata.task.targetNum = ndata.task.target
		-- end 
  
		if not self.seven_day_target_list.list[ndata.day] then 
			self.seven_day_target_list.list[ndata.day] = {}
		end 

		if not self.seven_day_target_list.list[ndata.day][ndata.tag] then 
			self.seven_day_target_list.list[ndata.day][ndata.tag] = {}
		end 

		table.insert( self.seven_day_target_list.list[ndata.day][ndata.tag], ndata )
	end

	if next(self.save_day_targetData) ~= nil then
		self:setChangeSevenDayTarget(self.save_day_targetData)
	end
	--dump(self.seven_day_target_list.list)
end

function SevenDayTargetData:setChangeSevenDayTarget( data )
	-- 获取到IDX
	-- add 熊梦 修改
	local ndata =self:getSevenDaytarget(data.idx)
	--local ndata = cfg.promotion7daytarget.target[data.idx]
	self.save_day_targetData = {}
	self.save_day_targetData = data
	if  next(self.seven_day_target_list.list) ~= nil then
		for k,v in pairs(self.seven_day_target_list.list[ndata.day][ndata.tag]) do
			if v.idx == data.idx then 
				v.process = data.process
				v.state = data.state
	
				if v.task.type == 'TOTAL_RECHARGE' then 
					v.process =  v.process * 0.01
				end 
	
			end 
		end
	end
end

function SevenDayTargetData:setRewardBox(idx)
	for k,v in pairs(self.seven_day_target_list.reward_box_idx) do
		if v.idx == idx then 
			v.isget = 1
		end 
	end

end 

function SevenDayTargetData:getSevenDayGift(data)

	self.seven_day_target_list.seven_day_value = data.seven_day_value   --  当前目标值
	for i,v in ipairs(data.task) do
		local ndata = {}
		ndata.idx = v.idx
		ndata.process = v.process
		ndata.state = v.state
		self:setChangeSevenDayTarget(ndata)
	end

	--    更新东西


end 

function SevenDayTargetData:gReqSevenDayTargetList()
	NetManager:sendMessage(ProtocolID.GReqSevenDayTargetList)
end 

function SevenDayTargetData:gReqSevenDayTargetGetReward(task_id)
	local req = SevenDayTarget_pb.GReqSevenDayTargetGetReward()
	req.task_id = task_id
	NetManager:sendMessage(ProtocolID.GReqSevenDayTargetGetReward, req)
end

function SevenDayTargetData:gReqSevenDayTargetBoxGetReward(box_id)
	local req = SevenDayTarget_pb.GReqSevenDayTargetBoxGetReward()
	req.box_id = box_id
	NetManager:sendMessage(ProtocolID.GReqSevenDayTargetBoxGetReward, req)
end 

function SevenDayTargetData:getDayRedPoint(day)

	local data = self.seven_day_target_list.list[day]
	local red_points = {}

	for k,v in pairs(data) do
		red_points[k] = self:checkSevenDayTagsRed(day, k )
	end
	return red_points
end

function SevenDayTargetData:checkSevenDayTagsRed(day, tag )
	local flag = false 
	local data = self.seven_day_target_list.list[day][tag]
	if not data then  return flag end 
	
	if tag < 4 then 
		for k,v in pairs(data) do
			if v.kind == 1 and  v.process >= v.task.targetNum and  v.state == 0  then 
				flag = true 
				break;
			end 
		end
	else
		for k,v in pairs(data) do
		
			if   v.state == 0 and  v.process >= v.task.targetNum and  v.cost[1].item_num == 0  then 
				flag = true 
				break;
			end 
		end
	end
	print( day, tag,  flag)
	return flag
end

function SevenDayTargetData:getPoint()
	return self.seven_day_target_list.seven_day_value
end

function SevenDayTargetData:getSevenDayBox(idx)
	return self.seven_day_target_list.reward_box_idx[idx].isget
end

-- 根据idx 找到对应的数据
function SevenDayTargetData:getSevenDaytarget(idx)
	local ndata = {}
	for i,v in pairs(ex.Player.promotion_data.promotion7daytarget_value) do
		if v.idx == idx then
			ndata = v
			break
		end 
	end
	return ndata
end

function SevenDayTargetData:getSevenDayData(idx)

	local ndata =self:getSevenDaytarget(idx)
	
	--local ndata = cfg.promotion7daytarget.target[idx]
	local  data = nil
	for k,v in pairs(self.seven_day_target_list.list[ndata.day][ndata.tag]) do
		if v.idx == idx then 
			data = v;
			break
		end 
	end
	return data
end

function SevenDayTargetData:getBoxRedPoint()
	local flag = false
	for k,v in pairs(self.seven_day_target_list.reward_box_idx) do
		if v.isget == 0  and self.seven_day_target_list.seven_day_value >= v.task_num  then 
			flag = true
		end 
	end
	return flag
end

function SevenDayTargetData:getSevenDayRedPoint()
	
	return true 
end


function SevenDayTargetData:getSevenDayStatus(idx)

	local data = self:getSevenDayData(idx)
	-- if data.process >= data.task.targetNum then 
	-- 	return true 
	-- end 

	return data.state
end

function SevenDayTargetData:getDayCfg()
	return self.seven_day_target_list.list
end


function SevenDayTargetData:checkLoginRedPoint()
	for dk,day_data in pairs(self.seven_day_target_list.list) do
		if dk <= self.seven_day_target_list.curr_day then 
			for tk,tag_data in pairs(day_data) do
				for k,v in pairs(tag_data) do
					if v.kind == 1 and  v.state == 0 and v.process >= v.task.targetNum then 
						return true
					end 
				end
			end
		end
	end
	return false
end


function SevenDayTargetData:refreshDayRed(  )

	local red = self:checkLoginRedPoint()
	-- ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCQTDL,red)

	local box_red = self:getBoxRedPoint()
	red = red or box_red
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCQTMB, red)

end 


return SevenDayTargetData
