/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CTalent implements BaseExcelModel {
	private int idx;
	private int skill_type;
	private int level;
	private ImmutableList<ImmutableThing> upgrade_need;
	private ImmutableList<ImmutableThing> forget_reward;
	private ImmutableList<ImmutableThing> forget_need;
	private ImmutableMap<AttributeType, Long> add_combat;
	@Override
	public int getExcelId() {
		return idx;
	}
}
