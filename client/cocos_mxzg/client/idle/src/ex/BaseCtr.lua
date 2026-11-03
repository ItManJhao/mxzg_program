local BaseCtr = class("BaseCtr")

-- 
function BaseCtr:ctor()
    self.layer = nil
    -- self.is_ctr_start_time = false
    self:onInit()
end

function BaseCtr:onInit()
    
end

-- 清理数据
function BaseCtr:_clear()
    self.layer = nil
    self:clearTimer()
    self:clearEvent()
    self:onClear()
end

function BaseCtr:onClear()

end

function BaseCtr:setLayer(layer)
    self.layer = layer
end

function BaseCtr:removeLayer(layer)
    if self.layer == layer then
        self.layer = nil
    end
end

function BaseCtr:addTimer(name,time,callFunc,loop,data)
    if not ex then return end
    if not self.timerList then self.timerList = {} end
    if self.timerList[name] ~= nil then print("has timer") return end
    self.timerList[name] = ex.Timer:addTimer(time, callFunc, loop, data)
end

function BaseCtr:getTimerByName(name)
    if self.timerList == nil then
        return nil
    end
    return self.timerList[name]
end

function BaseCtr:removeTimerByName(name)
    if not ex then return end
    if not self.timerList then return end
    if not self.timerList[name] then return end
    ex.Timer:removeTimerById(self.timerList[name])
    self.timerList[name] = nil
end

function BaseCtr:clearTimer()
    if not ex then return end
    if self.timerList then
        for k,v in pairs(self.timerList) do
            ex.Timer:removeTimerById(v)
        end
        self.timerList = nil
    end
end

function BaseCtr:addEvent(event,listener)
    if not ex then return end
    if not self.eventList then self.eventList = {} end
    table.insert(self.eventList,ex.EventManager:add(event,listener))
end

function BaseCtr:clearEvent()
    if not ex then return end
    if self.eventList then
        for k,v in pairs(self.eventList) do
            ex.EventManager:remove(v)
        end
        self.eventList = nil
    end
end


function BaseCtr:startTimer()
    
end

return BaseCtr