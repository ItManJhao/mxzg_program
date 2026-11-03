package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 成长基金
 * 
 */
@Getter
public class CPromotion008Card implements BaseExcelModel {
	/**
	 * ID
	 */
	private int idx;
	private int type;
	private int total_charge;
    private ImmutableList<ImmutableThing> item;
	private int day;

	@Override
	public int getExcelId() {
		return idx;
	}
}
