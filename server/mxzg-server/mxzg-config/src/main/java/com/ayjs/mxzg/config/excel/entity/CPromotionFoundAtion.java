package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 成长基金
 * 
 */
@Getter
public class CPromotionFoundAtion implements BaseExcelModel {
	/**
	 * ID
	 */
	private int idx;
	private int level;
	private int item_one;
	private int item_two;

	@Override
	public int getExcelId() {
		return idx;
	}
}
