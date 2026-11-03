package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 
 * 
 */
@Getter
public class CPromotionNewGift implements BaseExcelModel {
	/**
	 * ID
	 */
	private int idx;
	/**
	 * 
	 */
    private ImmutableList<ImmutableThing> reward;

	@Override
	public int getExcelId() {
		return idx;
	}
}
