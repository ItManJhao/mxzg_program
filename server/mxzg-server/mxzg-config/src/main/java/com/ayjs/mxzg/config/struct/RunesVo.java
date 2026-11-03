package com.ayjs.mxzg.config.struct;

import java.util.List;

import com.google.common.collect.ImmutableMap;

import lombok.Getter;
import lombok.Setter;

/**
 * 精灵信息
 * @author meiyc
 *
 */
@Getter
@Setter
public class RunesVo {

	/** 位置 */
	private int pos;
	
	/** 精灵id */
	private int runesId;
	
	/** 属性类型 */
	private int abilityType;
	
	/** 添加属性 */
	private ImmutableMap<AttributeType, Long> ability;
	
	/** 技能信息 */
	private List<Integer[]> skill;
}
