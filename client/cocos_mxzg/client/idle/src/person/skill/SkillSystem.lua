local SkillSystem = class("SkillSystem")

local Art = require("src.person.skill.Art")


-- 限制使用次数
SkillLimitData = {
	hero_id = 0,
	buff_id = 0,
	use_count = 0,
}


-- 技能队列数据
SkillQueueData = {
	skill_id = 0,
	hero = 0,
	skill_type = 0,
	skill_level = 0,
}


function SkillSystem:ctor()
	self.scene_base = nil
	self.system_scale = 0.77 		-- 动画统一缩放
	self.is_run_action = true
	self.vec_art = {}				-- 所有buff列表
	self.vec_skill_limit = {}		-- 限制释放的技能
	self.vec_skill = {}				-- 限制释放的技能
end


function SkillSystem:addSkillQueue(skill_id, hero, skill_type, skill_level)
	table.insert(self.vec_skill, {skill_id=skill_id, hero = hero, skill_type = skill_type, skill_level = skill_level})
end


function SkillSystem:getSkillQueue()
	if table.nums(self.vec_skill) >= 0 then
		return self.vec_skill[1]
	end

	return nil
end


function SkillSystem:removeSkillQueue(skill_id)
	TableEx.removeTableData(self.vec_skill, function(v)

		if v.skill_id == skill_id then
			return true
		end

	end)
end


function SkillSystem:clearSkillQueue()
	self.vec_skill = {}
end


function SkillSystem:useSkillLua(skill_id, hero, skill_type, skill_level)
	local skill_config = cfg.heroskill.heroskill[skill_type]
	self:useSkill(skill_id, hero, skill_config, skill_level)
end


function SkillSystem:useSkill(skill_id, hero, skill_config, skill_level)
	if not skill_config then
		return
	end

	-- 加载资源和播放声音
	self:skill(hero, hero.attack_skill_type == skill_config.type and 2 or skill_config.active_type)
	self:addArt(skill_id, skill_config.art_list, hero, skill_config, skill_level)
end


function SkillSystem:addArt(skill_id, vec_art, caster, skill_config, skill_level)
	for i,v in ipairs(vec_art) do
		local art = Art:create(self, skill_id, v, caster, skill_config, skill_level)
		if not art then
			print("art is null", skill_config.type)
		else
			table.insert(self.vec_art, art)
		end
	end
	self:effectArt()
end


function SkillSystem:addArtForTarget(skill_id, vec_art, caster, skill_config, skill_level, vec_target)
	if not skill_config then
		return
	end

	for i,v in ipairs(vec_art) do
		local art = Art:createWithTarget(self, skill_id, v, caster, skill_config, skill_level, vec_target)
		if not art then
			print("art is null", skill_config.type)
		else
			table.insert(self.vec_art, art)
		end
	end
	self:effectArt()
end


function SkillSystem:addArtAuto(skill_id, vec_art, caster, skill_config, skill_level, vec_target)

	if not skill_config then
		return
	end

	for i,v in ipairs(vec_art) do
		local art = Art:createWithAutoTarget(self, skill_id, v, caster, skill_config, skill_level, vec_target)
		if not art then
			print("art is null", skill_config.type)
		else
			table.insert(self.vec_art, art)
		end
	end
	self:effectArt()
end


function SkillSystem:clear()
	self:clearSkillQueue()
	self:removeAllSkill()
end


function SkillSystem:removeAllSkill()
	for i,v in ipairs(self.vec_art) do
		local art = v
		art:removeArt()
	end

	self.vec_art = {}
end

function SkillSystem:setSceneBase(scene_base)
	self.scene_base = scene_base
end

function SkillSystem:setRunAction(run)
	self.is_run_action = run
end


function SkillSystem:isRunAction()
	return self.is_run_action
end

function SkillSystem:removeSkillByType(hero, skill_type)
	for i,v in ipairs(self.vec_art) do
		local art = v
		repeat
			if art.caster ~= hero then
				break
			end

			if art.skill_type == skill_type then
				art:removeArt()
			end
		until true
	end
end


function SkillSystem:removeArtByID(art_id)
	for i,v in ipairs(self.vec_art) do
		local art = v
		if art.art_id == art_id then
			art:removeArt()
		end
	end
end


function SkillSystem:removeConflictBuff(exclude_id, target, conflict_type)
	for i,art in ipairs(self.vec_art) do
		for k,buff in ipairs(art.vec_buff) do
			repeat
				if buff.buff_config.conflict_type ~= conflict_type or buff.buff_id == exclude_id then
					break
				end

				for j,tmp_target in ipairs(buff.vec_target) do
					if tmp_target == target then
						if buff.is_cast_end ~= true then
							buff:removeEffect(tmp_target)
							break
						end
					end
				end
			until true
		end
	end
end


function SkillSystem:isSkilling()

	local result = false
	local is_break = false

	local art_num = table.nums(self.vec_art)

	for i=art_num, 1, -1 do
		local art = self.vec_art[i]

		for _, buff in ipairs(art.vec_buff) do
			if buff.buff_config.type < 100 and (not buff.is_finish) then
				result = true
				is_break = true
			end
		end

		if is_break then
			break
		end
	end

	return result
end


function SkillSystem:effectArt()
	for _,art in ipairs(self.vec_art) do

		for _,buff in ipairs(art.vec_buff) do
			repeat
				if buff.is_cast_end then
					break
				end

				if buff.is_casted ~= true then
					buff:cast()
				end
			until true
		end
	end


	for _,art in ipairs(self.vec_art) do

		for _,buff in ipairs(art.vec_buff) do
			repeat
				if buff.is_cast_end then
					break
				end

				if buff.is_effect ~= true then
					buff:effectUpdate(0)
				end
			until true
		end
	end
end


function SkillSystem:battleUpdate(dt)

	for _,art in ipairs(self.vec_art) do
		for _,buff in ipairs(art.vec_buff) do
			repeat
				if buff.is_cast_end then
					break
				end

				if buff.is_effect ~= true then
					buff:effectUpdate(0)
				end
			until true
		end
	end



	for _,art in ipairs(self.vec_art) do
		for _,buff in ipairs(art.vec_buff) do
			repeat
				if buff.is_cast_end then
					break
				end

				if (buff.is_casted ~= true) and (buff.is_effect == true) and (buff.is_finish ~= true)  then
					buff:battleUpdate(0)
				end
			until true
		end
	end


	for _,art in ipairs(self.vec_art) do

		local casted = 0
		local art_id = art.art_id
		local cast_num = table.nums(art.vec_buff)

		for i=1, cast_num do
			local buff = art.vec_buff[i]
			repeat
				if buff.is_cast_end then
					casted = casted + 1
					break
				end

				if buff.is_finish and (buff.is_cast_end ~= true) then
					buff:castEnd(0)
				end
			until true
		end

		if casted == cast_num then
			self:removeArtByID(art_id)
		end
	end
end



function SkillSystem:skill(battle_hero, active_type)
	if battle_hero:isArtifact() then
		return
	end

	if active_type == 2 then
		-- 这里之前是反向遍历
		for i,art in ipairs(self.vec_art) do
			for i,buff in ipairs(art.vec_buff) do
				buff:heroNormalAttack(battle_hero)
			end
		end
	elseif active_type == 1 then
		-- 这里之前是反向遍历
		for i,art in ipairs(self.vec_art) do
			for i,buff in ipairs(art.vec_buff) do
				buff:heroSkill(battle_hero)
			end
		end
	end
end


function SkillSystem:attack(attacker, beattacker, damage_type, active_type)

end


function SkillSystem:beattack(attacker, beattacker, damage_type, active_type)
	if attacker:isArtifact() then
		return
	end

	-- 这里之前是反向遍历
	for i,art in ipairs(self.vec_art) do
		for i,buff in ipairs(art.vec_buff) do
			if buff.is_casted and buff.is_effect and (not buff.is_finish) then
				buff:heroBeattack(attacker, beattacker, damage_type, active_type)
			end
		end
	end
end


function SkillSystem:heroDeath(battle_hero)
	-- 这里之前是反向遍历
	for i,art in ipairs(self.vec_art) do
		for i,buff in ipairs(art.vec_buff) do
			if buff.is_casted and buff.is_effect and (not buff.is_finish) then
				buff:heroDeath(battle_hero)
			end
		end
	end

	self.scene_base:heroDeath(battle_hero)
end

function SkillSystem:heroCritical(attacker, beattacker, damage_type, active_type)
	if attacker:isArtifact() then
		return
	end

	-- 这里之前是反向遍历
	for i,art in ipairs(self.vec_art) do
		for i,buff in ipairs(art.vec_buff) do
			if buff.is_casted and buff.is_effect and (not buff.is_finish) then
				buff:heroCritical(attacker, damage_type, active_type)
				buff:heroBecritical(attacker, beattacker, damage_type, active_type);
			end
		end
	end
end

function SkillSystem:roundStart(battle_hero)
	-- 这里之前是反向遍历
	for i,art in ipairs(self.vec_art) do
		for i,buff in ipairs(art.vec_buff) do
			buff:roundStart(battle_hero)
		end
	end
end

function SkillSystem:roundEnd(battle_hero)
	-- 这里之前是反向遍历
	for i,art in ipairs(self.vec_art) do
		for i,buff in ipairs(art.vec_buff) do
			buff:roundEnd(battle_hero)
		end
	end
end

function SkillSystem:addSkillLimit(hero_id, buff_id)
	local limit_data = TableEx.findValueFunction(self.vec_skill_limit, function(v)
		return (v.hero_id == hero_id) and (v.buff_id == buff_id)
	end)

	if not limit_data then
		table.insert(self.vec_skill_limit, {hero_id = hero_id, buff_id = buff_id, use_count = 1})
	else
		limit_data.use_count = limit_data.use_count + 1
	end
end

function SkillSystem:getSkillLimitCount(hero_id, buff_id)
	local limit_data = TableEx.findValueFunction(self.vec_skill_limit, function(v)
		return (v.hero_id == hero_id) and (v.buff_id == buff_id)
	end)

	return limit_data and limit_data.use_count or 0
end

function SkillSystem:removeSkillLimit(hero_id, buff_id)
	TableEx.removeTableData(self.vec_skill_limit, function(v)
		return (v.hero_id == hero_id) and (v.buff_id == buff_id)
	end)
end


function SkillSystem:removeControl(battle_hero)
	for i,art in ipairs(self.vec_art) do
		for i,buff in ipairs(art.vec_buff) do
			if buff:effectExemption() then
				buff:removeEffect(battle_hero)
			end
		end
	end
end


function SkillSystem:removeAllEffect(battle_hero, art_id)
	for i,art in ipairs(self.vec_art) do
		if art.art_id == art_id then
			for i,buff in ipairs(art.vec_buff) do
				buff:removeEffect(battle_hero)
			end
		end
	end
end

function SkillSystem:removeDebuff(caster, target, debuff_type)
	for i,art in ipairs(self.vec_art) do
		for i,buff in ipairs(art.vec_buff) do
			repeat
				if (buff.caster ~= caster) or (debuff_type ~= buff.buff_config.debuff_type) then
					break
				end
				
				buff:removeEffect(target)
			until true
		end
	end
end

return SkillSystem
