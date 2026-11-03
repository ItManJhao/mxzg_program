package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 英雄类型表
 * 
 * 
 */
@Getter
public class CPromotion003NewSevenDayLogin implements BaseExcelModel {
	
	private int day;

    private ImmutableList<ImmutableThing> item;
	
	private int lan;

	@Override
	public int getExcelId() {
		return day;
	}

}
