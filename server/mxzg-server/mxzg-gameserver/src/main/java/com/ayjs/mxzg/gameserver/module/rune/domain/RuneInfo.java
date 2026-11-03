/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.rune.domain;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.util.CollectionUtils;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.config.struct.RuneSkill;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "rune_info", comment = "符文表", indexes = { @Index(name = "rid", columnList = { "rid" }) }, cache = {
		@Cache(columns = "rid") })
@Getter
@Setter
public class RuneInfo extends AbstractEntity {
	@Id
	@LongIdGenerate
	@Column(name = "id")
	private long id;
	@Column(name = "rid", readOnly = true)
	private long rid;
	@Column(name = "type_id")
	private int typeId;
	@Column(name = "hero_id")
	private long heroId;
	@Column(name = "ability_id", comment = "能力ID")
	private int abilityId;
	@Column(name = "skill", comment = "技能信息，位置信息+技能信息")
	private Map<Integer, RuneSkill> skillMap;
	
	@Column(name = "place")
	private int place;
	@Column(name = "exp")
	private int exp;

	@Column(name = "wash_ability_id")
	private int washAbilityId;
	@Column(name = "wash_skill", comment = "重铸中的技能信息")
	private Map<Integer, RuneSkill> washSkillMap;
	
	
	/**
	 * 获取技能信息
	 * @return
	 */
	public List<Integer[]> getSkills(){
		if(CollectionUtils.isEmpty(skillMap)){
			return Collections.emptyList();
		}
		List<Integer[]> skillArray = new ArrayList<>();
		for(RuneSkill skill : this.skillMap.values()){
			Integer[] skillInfo = new Integer[]{skill.getSkillId(), skill.getLevel()};
			skillArray.add(skillInfo);
		}
		return skillArray;
	}
}
