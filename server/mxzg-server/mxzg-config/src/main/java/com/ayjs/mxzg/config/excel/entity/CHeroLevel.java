package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 英雄属性
 * 
 */
@Getter
public class CHeroLevel implements BaseExcelModel {
	
	private int level;
	
	private int gold_need;
	
	private int exp_need;

	@Override
	public int getExcelId() {
		return level;
	}
}