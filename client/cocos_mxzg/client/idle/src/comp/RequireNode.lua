
local RequireNode = class("RequireNode", function ( ... )
								   		return cc.Node:create()
								   end)

function RequireNode:ctor()
   	self.vec_file = {}
   	self.callback = nil
   	self.load_index = 0
	self.is_finish = false
	self.is_start = false

   	if self.onCreate then self:onCreate() end

   	if self.onNodeEvent then self:onNodeEvent() end
end

function RequireNode:onNodeEvent()
    self:registerScriptHandler(handler(self, self.eventHandler))
end


function RequireNode:eventHandler(eventType)
    if eventType == "exit" then
        self:onEventExit()
    end
end

function RequireNode:onEventExit()
	self:stopScheduler()
end

function RequireNode:startScheduler()
	local scheduler = cc.Director:getInstance():getScheduler()
	self.scheduler_id = scheduler:scheduleScriptFunc(handler(self, self.loadFile), 0.02, false)
end

function RequireNode:stopScheduler()
	if self.scheduler_id ~= nil then 
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler_id)
		self.scheduler_id = nil
	end
end


function RequireNode:setFileList(list)
	self.vec_file = list
	self.vec_num = 0
	if list and type(list) == "table" then
		self.vec_num = table.nums(list)
	end

	self.load_index = 0
end

function RequireNode:startRequire()
	self.is_start = true
	self:startScheduler()
end

function RequireNode:loadFile()

	local self_p = self
    if self_p.vec_num <= 0 then
    	return
    end
    
    -- print(self_p.vec_file[self_p.load_index + 1])
    require(self_p.vec_file[self_p.load_index + 1])
    self_p.load_index = self_p.load_index + 1

	-- dump(cfg)
	if self.load_index >= self.vec_num then
		self:stopScheduler()
		self.is_finish = true
		if self.callback ~= nil then
			self.callback()
		end
	end
end


return RequireNode
