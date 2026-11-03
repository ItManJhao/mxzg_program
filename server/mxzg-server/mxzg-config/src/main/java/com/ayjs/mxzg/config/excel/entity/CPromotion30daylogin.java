package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 签到
 * 
 * 
 */
@Getter
public class CPromotion30daylogin implements BaseExcelModel {

	/**
	 * 天数
	 */
	private int day;

	/**
	 * 奖励
	 */
    private ImmutableList<ImmutableThing> reward;

	@Override
	public int getExcelId() {
		return day;
	}
}
