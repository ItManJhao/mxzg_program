package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * PVP赛季奖励
 * 
 */
@Getter
public class CPvpWeekLyReward implements BaseExcelModel {
	private int idx;
	private int rank;
    private ImmutableList<ImmutableThing> reward;

	@Override
	public int getExcelId() {
		return idx;
	}
}
