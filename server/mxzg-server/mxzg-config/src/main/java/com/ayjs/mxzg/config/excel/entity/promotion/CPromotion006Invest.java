package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * 月卡基金
 * 
 */
@Getter
public class CPromotion006Invest implements BaseExcelModel {
	
	private int idx;
	private int production_id;
	/**
	 * 天，0为立刻就送，其他的需要领取
	 */
	private int day;
    private ImmutableList<ImmutableThing> reward;

	@Override
	public int getExcelId() {
		return idx;
	}
}
