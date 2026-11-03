package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 *  庇护所怪物击杀奖励
 */
@Getter
public class CShelterKillReward implements BaseExcelModel {
	
	private int idx;
	
	private int win_times;

    private ImmutableList<ImmutableThing> reward;

	@Override
	public int getExcelId() {
		return idx;
	}
}
