package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 等级限时礼包
 * 
 */
@Getter
public class CPromotionLimitedSetLevel implements BaseExcelModel {
	/**
	 * ID前段排序
	 */
	private int idx;
	/**
	 * 等级
	 */
	private int level;
	/**
	 * 
	 */
	private int last_time;

	@Override
	public int getExcelId() {
		return idx;
	}
}
