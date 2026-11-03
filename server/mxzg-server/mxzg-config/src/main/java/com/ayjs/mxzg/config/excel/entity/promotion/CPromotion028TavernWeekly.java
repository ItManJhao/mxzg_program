package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 *  试炼之路配置表
 * 
 * 
 */
@Getter
public class CPromotion028TavernWeekly implements BaseExcelModel {
	
	private int idx;
	private int turns;
	private int tavern_finish_times;
    private ImmutableList<ImmutableThing> reward;

	@Override
	public int getExcelId() {
		return idx;
	}

}
