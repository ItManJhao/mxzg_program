local JumpManager = class("JumpManager")

function JumpManager:ctor()
	self.jump_data = {}
	self.system_data = {}

	self:initJumpData()
	self:editSystemChildData()

end

function JumpManager:initJumpData()

	self:addJumpData(cfg.achievementjump.jump)
	self:addJumpData(cfg.dailyjump.jump)
	self:addJumpData(cfg.sevendaytargetjump.jump)
	self:addJumpData(cfg.heroarrivejump.jump)
	self:addJumpData(cfg.fettersjump.jump)

end

function JumpManager:editSystemChildData()
	local config = cfg.opencondition.condition
	for k,v in pairs(config) do
		if not self.system_data[k] and v.parent == "" then self.system_data[k] = {} end
		if v.parent ~= "" and v.parent ~= nil then 
			-- print("v.parent", v.parent)
			if not self.system_data[v.parent] then self.system_data[v.parent] = {} end
			table.insert(self.system_data[v.parent],v)
		end
	end

	local function sor(a,b)
		return a.condition_value < b.condition_value
	end

	for k,v in pairs(self.system_data) do
		local num = table.nums(v)
		if num > 1 then 
			table.sort(v,sor)
		end
	end
end

function JumpManager:checkChildSystemIsOpen(parent,child)
	local isOpen = false
	local data = self.system_data[parent]
	for k,v in pairs(data) do
		if v.atom == child then 
			-- if v.condition_type == 1 then
			-- 	isOpen = ex.Player.level >= v.condition_value
			-- 	break
			-- elseif v.condition_type == 4 then
			-- 	isOpen = ex.Player.fetter_data.vip.vip_level < v.condition_value
			-- 	break
			-- end
			isOpen = self:checkOpenConditionByAtomNoMsg(v.atom)
			break
		end
	end

	return isOpen
end

function JumpManager:checkAtomChildIsOpen(atom)
	-- 检查自身是否开启
	local isOpen = self:checkOpenConditionByAtomNoMsg(atom)
	local atom_config = cfg.opencondition.condition[atom]

	if isOpen then
		-- 检查openfunc是否显示
		if cfg.funcopen[atom] and cfg.funcopen[atom].isVisible then
			isOpen = cfg.funcopen[atom].isVisible()
		end
	end

	if isOpen and atom_config.parent ~= "" then
		-- 检查子节点是否开启
		isOpen = isOpen and self:checkOpenConditionByAtomNoMsg(atom_config.parent)
		-- 检查自己是否显示
		if isOpen and cfg.funcopen[atom_config.parent] and cfg.funcopen[atom_config.parent].isVisible then
			isOpen = cfg.funcopen[atom_config.parent].isVisible()
		end
	end

	return isOpen
end

function JumpManager:getSystemData()
	return self.system_data
end

function JumpManager:getSystemDataByAtom(atom)
	return self.system_data[atom]
end

function JumpManager:checkOpenConditionByAtom(atom)
	local config = cfg.opencondition.condition
	local atom_config = config[atom]
	if not atom_config then 
		print("not condition config by atom : " , atom)
		return false
	end

	if atom_config.open == FUNCTION_OPEN_TYPE.DEFAULT_OPEN then return true end
	if atom_config.open == FUNCTION_OPEN_TYPE.NOT_OPEN then 
		ex.MessageView:add(ex.Tools:getLang(47100))
		return false 
	end
	if atom_config.condition_type == "" then return true end
	if atom_config.condition_value == "" then return true end

	local isOpen = false
	if atom_config.condition_type == 1 then
		-- ex.MessageView:add("ex.Player.level")
		isOpen = ex.Player.level >= atom_config.condition_value
	elseif atom_config.condition_type == 4 then
		isOpen = ex.Player.fetter_data.vip.vip_level < atom_config.condition_value
	end

	if atom_config.world_level > 1 then
		isOpen = isOpen and ex.Player.world_level >= atom_config.world_level
	end

	if not isOpen then 
		if atom_config.world_level > 1 and atom_config.condition_type == 1 then
			ex.MessageView:add(string.format(ex.Tools:getLang(54514), atom_config.condition_value, atom_config.world_level))
		elseif atom_config.condition_type == 1 then
			ex.MessageView:add(string.format(ex.Tools:getLang(47214), atom_config.condition_value))
		end
	end
	return isOpen
end


function JumpManager:checkOpenConditionByAtomNoMsg(atom)
	local config = cfg.opencondition.condition
	local atom_config = config[atom]
	if not atom_config then 
		print("not condition config by atom : " , atom)
		return false
	end

	if atom_config.open == FUNCTION_OPEN_TYPE.DEFAULT_OPEN then return true end
	if atom_config.open == FUNCTION_OPEN_TYPE.NOT_OPEN then 
		return false 
	end
	if atom_config.condition_type == "" then return true end
	if atom_config.condition_value == "" then return true end

	local isOpen = false
	if atom_config.condition_type == 1 then
		-- ex.MessageView:add("ex.Player.level")
		isOpen = ex.Player.level >= atom_config.condition_value
	elseif atom_config.condition_type == 4 then
		isOpen = ex.Player.fetter_data.vip.vip_level < atom_config.condition_value
	end

	if atom_config.world_level > 1 then
		isOpen = isOpen and ex.Player.world_level >= atom_config.world_level
	end

	-- if not isOpen then 
	-- 	if atom_config.condition_type == 1 then
	-- 	end
	-- end
	return isOpen
end


function JumpManager:jumpByAtomFireEvent(atom,param)
	if not atom then 
		return false
	end
	
	local isOpen = self:checkOpenConditionByAtom(atom)
	if isOpen then 
		local config = cfg.funcopen[atom]
    	if not config then 
    		print(self.__cname,atom .. " is nil") 
    		return false 
    	end

    	if config.isVisible then 
    		local open = config.isVisible()
    		if not open then return false end
    	end
    	config.open(param)
	end
	return isOpen
end

function JumpManager:isCanJumpByAtom(atom)
	if not atom then 
		return false
	end
	
	local isOpen = self:checkOpenConditionByAtom(atom)
	if isOpen then 
		local config = cfg.funcopen[atom]
    	if not config then 
    		print(self.__cname,atom .. " is nil") 
    		return false 
    	end

    	if config.isVisible then 
    		local open = config.isVisible()
    		if not open then return false end
    	end
	end
	return isOpen
end

function JumpManager:jumpByAtom(atom,param)
	if not atom then 
		return false
	end
	
	local isOpen = self:checkOpenConditionByAtom(atom)
	if isOpen then 
		local config = cfg.funcopen[atom]
    	if not config then 
    		print(self.__cname,atom .. " is nil") 
    		return false 
    	end

    	if config.isVisible then 
    		local open = config.isVisible()
    		if not open then return false end
    	end
    	config.open(param)
	end
	return isOpen
end

function JumpManager:addJumpData(data)
	for k,v in pairs(data) do
		self.jump_data[k] = v
	end
end

function JumpManager:jumpByActType(act_type)
	if not act_type then 
		print("jump type is nil")
		return false 
	end

	local jump_data = self.jump_data[act_type]
	if not jump_data then 
		print("jump_data is not by act_type :" ,act_type)
		return false 
	end

	local config = cfg.funcopen[jump_data.atom]
	if not config then 
		print("funcopen config by atom is nil :" , jump_data.atom)
		return false 
	end

	local isOpen = self:checkOpenConditionByAtom(jump_data.atom)
	if isOpen then 
		config.open(jump_data.param)
	end

	return isOpen
end

function JumpManager:jumpById(id)
	local config = cfg.openwindow.jump[id]
	if not config then 
		print("cfg.openwindow.jump["..id.."] is nil !") 
		return false 
	end 
	local isopen = self:jumpByAtom(config.atom,config.value)

	return isopen
end

return JumpManager
