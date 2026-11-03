package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 七日目标
 * 
 * 
 */
@Getter
public class CPromotion018SevenDayTargetPoint implements BaseExcelModel {

	private int idx;
	private int turns;
	private int task_num;
    private ImmutableList<ImmutableThing> reward;
	@Override
	public int getExcelId() {
		return idx;
	}

}
