package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 快速战斗
 * 
 * 
 */
@Getter
public class CSpeedUpCost implements BaseExcelModel {
	
	private int times;
	
	/**
	 * 为负数时不能继续买
	 */
	private int cost_gem;
	
	/**
	 * 买了特权之后的价格
	 */
	private int cost_gem_adv;

	@Override
	public int getExcelId() {
		return times;
	}

}
