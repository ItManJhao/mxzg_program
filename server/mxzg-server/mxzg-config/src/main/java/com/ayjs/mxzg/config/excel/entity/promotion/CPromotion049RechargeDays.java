package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 
 * 
 */
@Getter
public class CPromotion049RechargeDays implements BaseExcelModel {
	/**
	 * ID
	 */
	private int day;
    private ImmutableList<ImmutableThing> item;

	@Override
	public int getExcelId() {
		return day;
	}
}
