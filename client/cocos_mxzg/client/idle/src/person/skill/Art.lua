local Art = class("Art")

function Art:ctor()
	self.skill_id = 0
    self.skill_type = 0
    self.skill_level = 0
    self.art_id = 0
    self.art_type = 0
    self.target_num = 0

    self.skill_system = nil
    self.caster = nil
    self.art_config = nil

    self.is_removing = false
    self.vec_buff = {}
end

function Art:create(skill_system,
					skill_id,
					art_type,
					hero,
					skill_config,
					skill_level)
	local art = Art:new()
	if art:init(skill_system, skill_id, art_type, hero, skill_config, skill_level) then
		local vec_target = art:getTarget(art:getTargetNum())
		art:initBuff(hero, skill_config, vec_target)
		return art
	end

	return nil
end


function Art:createWithTarget(skill_system,
							 skill_id,
							 art_type,
							 hero,
							 skill_config,
							 skill_level,
							 vec_target)

	local art = Art:new()
	if art:init(skill_system, skill_id, art_type, hero, skill_config, skill_level) then
		art:initBuff(hero, skill_config, vec_target)
		return art
	end
	return nil
end


function Art:createAutoTarget(skill_system,
							  skill_id,
							  art_type,
							  hero,
							  skill_config,
							  skill_level,
							  vec_target)
	local art = Art:new()
	if art:init(skill_system, skill_id, art_type, hero, skill_config, skill_level) then
		if table.nums(art.art_config.vec_target) > 0 then
			vec_target = art:getTarget(art:getTargetNum())
		end

		art:initBuff(hero, skill_config, vec_target)
		return art
	end
	return nil
end



function Art:addBuff(buff_id,
					 hero,
					 skill_config,
					 vec_target,
					 creater)

	local buff = self:createBuff(buff_id, hero, skill_config, vec_target)
	if buff == nil then
		print("buff is null", skill_config.type)
	end

	if buff then
		table.insert(self.vec_buff, buff)
	end

	return buff
end

function Art:init(skill_system,
				  skill_id,
				  art_type,
				  hero,
				  skill_config,
				  skill_level)
	if not skill_config then
		return false
	end

	self.art_config = cfg.buffart.buffart[art_type]

	




end


function Art:initBuff(hero,
				  skill_config,
				  vec_target)

end


function Art:finish()
	
end

function Art:removeArt()
end

function Art:getTargetNum()

end


function Art:getTarget(target_num)

end

function Art:createBuff(buff_id,
						hero,
						skill_config,
						vec_target)

end







return Art
