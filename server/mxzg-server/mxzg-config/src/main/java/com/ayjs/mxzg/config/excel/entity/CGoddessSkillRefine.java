package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 神器精炼等级
 * 
 */
@Getter
public class CGoddessSkillRefine implements BaseExcelModel {
	
	private int idx;
	
	private int level;

    private ImmutableList<ImmutableThing> cost_res;

	@Override
	public int getExcelId() {
		return idx;
	}
}