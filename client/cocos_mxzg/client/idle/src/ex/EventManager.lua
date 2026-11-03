local EventManager = class("EventManager")

function EventManager:ctor()
	self.eventList = {}
	self.id = 0
end

function EventManager:addEvent(event, listener, id)
	-- body
	local eventData = {}
	eventData.event = event
	eventData.listener = listener
	eventData.id = id
	return eventData
end  

function EventManager:add(event, listener)
	-- body
	if not event then
		return
	end
	if not listener then
		return
	end
	if not self.eventList[event] then self.eventList[event] = {} end

	for i,v in ipairs(self.eventList[event]) do
		if v.listener == listener then return end
	end

	local eventData = self:addEvent(event, listener, self.id)
	table.insert(self.eventList[event], eventData)
	self.id = self.id + 1
	return eventData
end

function EventManager:fire(event, ...)
	if not event then
		return
	end

	if not self.eventList[event] then
		return
	end

	for k, v in pairs(self.eventList[event]) do
		v.listener(event, ...)
	end
end

function EventManager:remove(eventData)
	-- body
	local eventName = eventData.event
	local list = self.eventList[eventName]
	for k, v in pairs(list) do
		if v == eventData then
			table.remove(list, k)
			break
		end
	end
end

function EventManager:removeById(eventData)
	-- body
	local eventName = eventData.evnet
	local list = self.eventList[eventName]

	for k, v in pairs(list) do
		if v.id == eventData.id then
			table.remove(list, k)
			break
		end
	end
end

return EventManager
