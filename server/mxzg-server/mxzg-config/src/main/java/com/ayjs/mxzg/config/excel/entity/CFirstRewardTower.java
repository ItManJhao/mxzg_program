package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 幻境首通
 * 
 * 
 */
@Getter
public class CFirstRewardTower implements BaseExcelModel {
	
	private int idx;
	
	private int chapter;

    private ImmutableList<ImmutableThing> reward;

    private int is_notice;

	@Override
	public int getExcelId() {
		return idx;
	}

}
