package com.ayjs.mxzg.config.excel.cache;


import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.alibaba.fastjson.JSONArray;
import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.config.excel.entity.CRuneSkillType;
import com.ayjs.mxzg.config.excel.entity.CRunesType;
import com.ayjs.mxzg.config.struct.RuneSkill;

@Component
public class RunesTypeSysCache extends BaseExcelCache<CRunesType> {

	@Autowired
	private RunesAbilitySysCache runesAbilitySysCache;
	@Autowired
	private RuneSkillTypeSysCache runeSkillTypeSysCache;
	
	private Map<Integer, CRunesType> typeMap;
	
	@Override
	public String getFileName() {
		return "runestype";
	}

	@Override
	protected void loadAfterReady() {
		this.typeMap = ListMapUtil.listToMap(this.getAll(), CRunesType::getType);
	}
	
	public CRunesType getByType(int type) {
		return typeMap.get(type);
	}

	public RuneDataTemplate randomRune(int type) {
		CRunesType cRunesType = typeMap.get(type);
		if(cRunesType == null) {
			return null;
		}
		
		RuneDataTemplate runeData = new RuneDataTemplate();
		runeData.setType_id(type);
		//先随机能力ID
		runeData.setAbility_id(runesAbilitySysCache.randomType());
		
		//先随机技能个数
		List<RuneNumChance> numList = JSONArray.parseArray(cRunesType.getSkill_num_chance(), RuneNumChance.class);
		RuneNumChance runeNumChance = DropUtil.randomDrop(numList);
		if(runeNumChance != null) {
			//首位的空字符用于补位，for循环中不用减一处理
			String[] skillLevel = new String[] {"", cRunesType.getSkill1_level(), cRunesType.getSkill2_level()};
			Set<Integer> skillIds = new HashSet<>();
			
			int sort = 1;
			while(sort <= runeNumChance.getNum()) {
				List<RuneSkillChance> skillList = JSONArray.parseArray(skillLevel[sort], RuneSkillChance.class);
				if(skillList.isEmpty()) {
					break;
				}
				RuneSkillChance skill = DropUtil.randomDrop(skillList);
				CRuneSkillType cRuneSkillType = runeSkillTypeSysCache.randomOne(skill.getLevel());
				if(cRuneSkillType != null && !skillIds.contains(cRuneSkillType.getSkill_id())) {
					RuneSkill runeSkill = new RuneSkill();
					runeSkill.setSort(sort);
					runeSkill.setLevel(skill.getLevel());
					runeSkill.setSkillId(cRuneSkillType.getSkill_id());
					runeData.getSkillMap().put(runeSkill.getSort(), runeSkill);
					skillIds.add(cRuneSkillType.getSkill_id());
					sort++;
				}
			}
		}
		return runeData;
	}
	
	public static class RuneDataTemplate {
		private long id;
		private int type_id;
		private int ability_id; //属性id
		private Map<Integer, RuneSkill> skillMap = new HashMap<>();
		private int exp; //经验值
		public long getId() {
			return id;
		}
		public void setId(long id) {
			this.id = id;
		}
		public int getType_id() {
			return type_id;
		}
		public void setType_id(int type_id) {
			this.type_id = type_id;
		}
		public int getAbility_id() {
			return ability_id;
		}
		public void setAbility_id(int ability_id) {
			this.ability_id = ability_id;
		}
		public int getExp() {
			return exp;
		}
		public void setExp(int exp) {
			this.exp = exp;
		}
		public Map<Integer, RuneSkill> getSkillMap() {
			return skillMap;
		}
		public void setSkillMap(Map<Integer, RuneSkill> skillMap) {
			this.skillMap = skillMap;
		}
	}
	
	public static class RuneNumChance implements IDrop {
		private int num;
		private int chance;
		public int getNum() {
			return num;
		}
		public void setNum(int num) {
			this.num = num;
		}
		public int getChance() {
			return chance;
		}
		public void setChance(int chance) {
			this.chance = chance;
		}
		@Override
		public int getDropId() {
			return num;
		}
		@Override
		public int getRate() {
			return chance;
		}
	}
	
	
	public static class RuneSkillChance implements IDrop {
		private int level;
		private int chance;
		public int getChance() {
			return chance;
		}
		public void setChance(int chance) {
			this.chance = chance;
		}
		public int getLevel() {
			return level;
		}
		public void setLevel(int level) {
			this.level = level;
		}
		@Override
		public int getDropId() {
			return level;
		}
		@Override
		public int getRate() {
			return chance;
		}
	}
	
	
}