package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 点金数据
 * 
 */
@Getter
public class CBuyGold implements BaseExcelModel {
	
	private int chapter;
	
	private int gold_1;
	
	private int gold_2;
	
	private int gold_3;
	
	@Override
	public int getExcelId() {
		return chapter;
	}
}
