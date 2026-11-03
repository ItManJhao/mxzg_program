local FetterVIPData = class("FetterVIPData")

function FetterVIPData:ctor()
	self.vip_max = 0
	self.vip_level = 0
	self.progress = {}
	self.status = {}
	self:initMaxVip()
end

function FetterVIPData:getNextVIPSpine() -- 废弃

	if ex.Player.fetter_data:isUnlockAll() == true then return end

	local cur_cfg = cfg.goddessvip.goddessvip[self.vip_level]
	local cur_type = 0

	local next_spine = 0
	local next_level = 999

	for i = 1 , 5 do
		if cur_cfg["unlock_goddess_" .. (10001 + i*100)] == 1 then 
			cur_type = 10001 + i*100
		end
	end

	for i,v in ipairs(cfg.goddessvip.goddessvip) do
		if self.vip_level < v.vip_level then 
			local bool = false
			for i=1,5 do
				local spine_type = (10001 + i*100)
				local key = "unlock_goddess_" .. spine_type
				if v[key] ~= nil and v[key] == 1 then 
					if cur_type < spine_type then 
						next_spine = spine_type
						next_level = v.vip_level
						bool = true
						break
					end
				end
			end
			if bool == true then break end 
		end
	end

	return {type = next_spine,vip_level = next_level}
	-- local data = {}
	-- for k ,v in pairs(cfg.goddessunlock.goddessunlock) do 
	-- 	table.insert(data,v)
	-- end

	-- local function sor(a,b)
	-- 	return a.type < b.type
	-- end

	-- table.sort(data,sor)

	-- local d 
	-- local level = ex.Player.fetter_data.vip:getVIP()
	-- for i,v in ipairs(data) do
	-- 	if level < v.vip_level then 
	-- 		d = v
	-- 		break
	-- 	end
	-- end

	-- return d
end

function FetterVIPData:initMaxVip()
	for k,v in ipairs(cfg.goddessvip.goddessvip) do
		if v.vip_level > self.vip_max then 
			self.vip_max = v.vip_level
		end
	end
end

function FetterVIPData:getMaxVip()
	return self.vip_max
end

function FetterVIPData:setVIP(level)
	self.vip_level = level
	self:initVIPCfg()
end

function FetterVIPData:getVIP()
	return self.vip_level
end

function FetterVIPData:initServerData(data)
	for k,v in ipairs(data.progress_list) do
		self.progress[v.idx] = v.num
	end

	for k,v in ipairs(data.status_list) do
		self.status[v.idx] = v.status
	end
end

function FetterVIPData:setStatus(idx,status)
	self.status[idx] = status
end

function FetterVIPData:setProgress(idx,num)
	self.progress[idx] = num
end

function FetterVIPData:getStatus(idx)
	return self.status[idx]
end

function FetterVIPData:getProgress(idx)
	return self.progress[idx]
end

function FetterVIPData:checkRedPoint()
	local isRed = false
	if not self.vip_cfg then return isRed end
	for k,v in pairs(self.vip_cfg) do
		local progress = self:getProgress(v.idx) or 0
		local status = self:getStatus(v.idx) or 1
		if progress >= v.task.target and status == 0 then 
			isRed = true
			break
		end
	end
	return isRed
end

function FetterVIPData:initVIPCfg()
	self.vip_cfg = {}
	for k,v in pairs(cfg.goddessmission.goddessmission) do
		if v.vip_level == self.vip_level then 
			table.insert(self.vip_cfg,v)
		end
	end
end

function FetterVIPData:getVIPCfg()
	return self.vip_cfg
end


return FetterVIPData
