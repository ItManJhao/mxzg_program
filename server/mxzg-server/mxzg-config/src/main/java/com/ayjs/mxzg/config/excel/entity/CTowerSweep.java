package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 英雄类型表
 * 
 * 
 */
@Getter
public class CTowerSweep implements BaseExcelModel {
	
	private int times;
	
	private int cost_gem;

	@Override
	public int getExcelId() {
		return times;
	}
}
