package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 *  公会技能升级配置表
 * 
 * 
 */
@Getter
public class CClanSkillBase implements BaseExcelModel {

	private int idx;

	private int level;

	private int attr_type;

    private ImmutableList<ImmutableThing> cost_res;

	@Override
	public int getExcelId() {
		return idx;
	}

}
