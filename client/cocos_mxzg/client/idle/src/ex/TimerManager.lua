local TimerManager = class("TimerManager")

local director = cc.Director:getInstance()

local DRIVE_TYPE = {
	TIME = 0,
	FRAME = 1
}

function TimerManager:ctor()
    self._timerList = {}
    self._needClean = false

    self._timeId = 0
    --当前时间
    self._nowTime = 0
    --时间增量
    self._deltaTime = 0
    self:start()
end

-- 启动
function TimerManager:start()
    if self._funcHandle then
        return
    end

    self._funcHandle = cc.Director:getInstance():getScheduler():scheduleScriptFunc(
                                      function(dt)
                                          self:loop(dt)
                                      end, 0, false)
    print(self.__cname,"start")
end

-- 关闭
function TimerManager:stop()
    print(self.__cname,"stop")
    if not self._funcHandle then
        return
    end

    cc.Director:getInstance():getScheduler():
      unscheduleScriptEntry(self._funcHandle)

    self._funcHandle = nil
end

function TimerManager:removeAllTimer()
    while table.nums(self._timerList) > 0 do
        local timer = table.remove(self._timerList)
        timer = nil
    end
end

-- 帧回调
function TimerManager:loop(dt)
    -- 清理
    if self._needClean then
        self:_clean()
        self._needClean = false
    end
    self:_execute(dt)

    self._deltaTime = director:getDeltaTime()
    self._nowTime = self._nowTime + self._deltaTime
end

function TimerManager:_execute(dt)
    for i, v in ipairs(self._timerList) do
        -- local tmpTime1 = os.clock()
        if v and v._isDirty == false and v._isPause == false then
            local trigger = false
            if v._type == DRIVE_TYPE.FRAME then
                v._currentFrame = (v._currentFrame or 0) + 1
                if v._currentFrame >= v._totalFrame then
                    trigger = true
                    if v._loop then
                        v._currentFrame = 0
                    else
                        v._isDirty = true
                        self._needClean = true
                    end
                end
            else
                v._countTime = v._countTime + dt
                if v._countTime >= v._totalTime then
                    trigger = true
                    if v._loop then
                        v._countTime = 0
                    else
                        v._isDirty = true
                        self._needClean = true
                    end
                end
            end

            --清理空函数
            if v._callFunc == nil then
                v._isDirty = true
                self._needClean = true
            else
                if trigger then
                    if v._data then
                        v._callFunc(v._data)
                    else
                        v._callFunc()
                    end
                end
            end
        end
    end
end

function TimerManager:_clean()
    local i = 1
    local timerData = nil
    while i <= #self._timerList do
        timerData = self._timerList[i]
        if timerData._isDirty == true then
            timerData._callFunc = nil
            table.remove(self._timerList, i)
        else
            i = i + 1
        end
    end
end

--[[
	暂停定时器
]]
function TimerManager:pauseTimer(callFunc)

	local timer = self:_getTimer(callFunc)
	if timer == nil then
		return
	end

	timer._isPause = true
end

--[[
    恢复定时器
]]
function TimerManager:resumeTimer(callFunc)

	local timer = self._getTimer(callFunc)
	if timer == nil then
		return
	end

	timer._isPause = false

end

--[[
    添加时间驱动定时器
    @param time 时间(ms)
    @param callFunc 回调函数 callFunc(data)
    @param loop 是否循环
    @param data 附带数据
]]
function TimerManager:addTimer(time, callFunc, loop, data, token)
	if type(callFunc) ~= "function" then
		return
	end
	for i, v in ipairs(self._timerList) do
		if v._callFunc == callFunc then
			self:_initTimer(v, time, loop, data, token)
			return v._id
		end
	end

    self._timeId = self._timeId + 1
	local timer = { _id = self._timeId , traceBack = debug.traceback()}
	timer._callFunc = callFunc  --回调函数
	self:_initTimer(timer, time, loop, data, token)
	self._timerList[#self._timerList + 1] = timer

    return self._timeId
end

--[[
    添加帧驱动定时器
    @param frames 帧数
    @param callFunc 回调函数 callFunc(data)
    @param loop 是否循环
    @param data 附带数据
]]
function TimerManager:addFrame(frames, callFunc, loop, data, token)
	if type(callFunc) ~= "function" then
		return
	end

	for i, v in ipairs(self._timerList) do
		if v._callFunc == callFunc then
			self:_initFrame(v, frames, loop, data, token)
			return v._id
		end
	end

    self._timeId = self._timeId + 1
	local timer = { _id = self._timeId , traceBack = debug.traceback()}
	timer._callFunc = callFunc  --回调函数
	self:_initFrame(timer, frames, loop, data, token)
	self._timerList[#self._timerList + 1] = timer

    return self._timeId
end

--[[
    根据回调清除定时器
]]
function TimerManager:removeTimer(callFunc)

	if type(callFunc) ~= "function" then
		return
	end

    for i, v in ipairs(self._timerList) do
        if v and v._isDirty == false then
            if v._callFunc == callFunc then
                v._isDirty = true
                self._needClean = true
                break
            end
        end
    end
end

--清理自动销毁定时器
function TimerManager:cleanAutoReleaseTimer()
    for i, timer in ipairs(self._timerList) do
        if timer and timer._isDirty == false then
            if not timer._loop then --不循环
                timer._isDirty = true 
                
            end
        end
    end
end 

function TimerManager:_initTimer(timer, time, loop, data, token)
	timer._type = DRIVE_TYPE.TIME --时间驱动
	timer._totalTime = time * 0.001  --触发间隔时间(这里改成s)
	timer._countTime = 0 --统计时间
	timer._loop = loop  --是否循环
	timer._data = data --附带数据
	timer._token = token --
	timer._isDirty = false --
	timer._isPause = false --是否暂停
end

function TimerManager:_initFrame(timer, frames, loop, data, token)
	timer._type = DRIVE_TYPE.FRAME --帧驱动
	if frames <= 0 then
		frames = 1
	end
	timer._totalFrame = frames
	timer._currentFrame = 0 --统计时间
	timer._loop = loop  --是否循环
	timer._data = data --附带数据
	timer._token = token --
	timer._isDirty = false --
	timer._isPause = false --是否暂停
end

function TimerManager:_getTimer(callFunc)
	for i, v in ipairs(self._timerList) do
		if v and v._isDirty == false then
			if v._callFunc == callFunc then
				return v
			end
		end
	end
	return nil
end

--[[
    暂停定时器
]]
function TimerManager:pauseTimerById(id)
    if id == nil then return end

    local timer = self:_getTimerById(id)
    if timer == nil then
        return
    end

    timer._isPause = true
end

--[[
    恢复定时器
]]
function TimerManager:resumeTimerById(id)
    if id == nil then return end

    local timer = self:_getTimerById(id)
    if timer == nil then
        return
    end

    timer._isPause = false
end

--[[
    根据ID清除定时器
]]
function TimerManager:removeTimerById(id)
    if id == nil then return end
    local timer = self:_getTimerById(id)
    if timer == nil then
        return
    end

    timer._isDirty = true
    self._needClean = true
end

function TimerManager:removeTimerByToken(token)
	if not token then return end

	for i , v in ipairs(self._timerList) do
		if v and v._isDirty == false then 
			if v._token == token then 
				v._isDirty = true
				self._needClean = true
			end
		end
	end
end

function TimerManager:_getTimerById(id)
    for i, v in ipairs(self._timerList) do
        if v and v._isDirty == false then
            if v._id == id then
                return v
            end
        end
    end

    return nil
end

return TimerManager

