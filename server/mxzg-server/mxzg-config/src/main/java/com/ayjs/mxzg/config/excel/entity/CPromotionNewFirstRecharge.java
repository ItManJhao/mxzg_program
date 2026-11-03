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
public class CPromotionNewFirstRecharge implements BaseExcelModel {
	/**
	 * ID
	 */
	private int idx;
	/**
	 * 
	 */
	private int rmb;
	/**
	 * 第一天奖励
	 */
    private ImmutableList<ImmutableThing> day_one;
	/**
	 * 第二天奖励
	 */
    private ImmutableList<ImmutableThing> day_two;
	/**
	 * 第三天奖励
	 */
    private ImmutableList<ImmutableThing> day_three;
	/**
	 * 
	 */
	private int worth;

	@Override
	public int getExcelId() {
		return idx;
	}
}
