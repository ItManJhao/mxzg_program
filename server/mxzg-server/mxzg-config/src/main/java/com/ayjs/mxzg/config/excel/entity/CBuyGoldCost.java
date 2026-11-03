package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 商城
 * 
 */
@Getter
public class CBuyGoldCost implements BaseExcelModel {
	private int type;
	private int prize;
	private int limit;

	/**
	 * 点石成金活动期间内的点金次数限制
	 */
	private int promotion_limit;

	@Override
	public int getExcelId() {
		return type;
	}
}
