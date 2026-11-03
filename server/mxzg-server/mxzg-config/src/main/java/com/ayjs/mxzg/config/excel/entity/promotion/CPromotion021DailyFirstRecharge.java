package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 每日首充奖励
 * 
 */
@Getter
public class CPromotion021DailyFirstRecharge implements BaseExcelModel {
	/**
	 * ID
	 */
	private int idx;
	private int turns;
	private int rmb;
    private ImmutableList<ImmutableThing> item;
    private int type;
    
    
	@Override
	public int getExcelId() {
		return idx;
	}
}
