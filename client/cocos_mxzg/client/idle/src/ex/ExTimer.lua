local ExTimer = class("ExTimer")

function ExTimer:ctor()
	self.node = nil
	self.sId = nil
end

function ExTimer:bind(node)
	self:stop()	
	self.node = node
	return self
end  

function ExTimer:runOnce(func, delay)
	self:stop()
	self.sId = self.node:getScheduler():scheduleScriptFunc(function ()
		local sId = self.sId
		self.sId = nil
		self.node:getScheduler():unscheduleScriptEntry(sId)
		func()
	end, delay or 0, false)
	return self
end

function ExTimer:run(func, delay)
	self:stop()
	self.sId = self.node:getScheduler():scheduleScriptFunc(function ()
		func()
	end, delay or 0, false)
	return self
end

function ExTimer:stop()
	if self.sId then
		print("stop schedule")
		self.node:getScheduler():unscheduleScriptEntry(self.sId)
		self.sId = nil
	end
	return self;
end


return ExTimer