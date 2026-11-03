package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 关卡限时礼包
 * 
 */
@Getter
public class CPromotionLimitedSetChapter implements BaseExcelModel {
	/**
	 * ID前段排序
	 */
	private int idx;
	/**
	 * 关卡ID
	 */
	private int chapter;
	/**
	 * 
	 */
	private int last_time;

	@Override
	public int getExcelId() {
		return idx;
	}
}
