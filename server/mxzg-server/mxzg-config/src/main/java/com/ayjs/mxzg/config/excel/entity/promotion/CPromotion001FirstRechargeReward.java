package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 
 * 
 */
@Getter
public class CPromotion001FirstRechargeReward implements BaseExcelModel {

	/**
	 * ID
	 */
	private int idx;
	/**
	 *
	 */
	private int rmb;
	/**
	 *
	 */
	private int worth;

	@Override
	public int getExcelId() {
		return idx;
	}


}
