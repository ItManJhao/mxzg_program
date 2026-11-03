package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * PVP每日奖励
 * 
 */
@Getter
public class CPvpDaiLyReward implements BaseExcelModel {
	private int idx;
	private int rank;
    private ImmutableList<ImmutableThing> reward;

	@Override
	public int getExcelId() {
		return idx;
	}
}
