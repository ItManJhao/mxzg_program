package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * BuyTime
 * 
 */
@Getter
public class CBuyTime implements BaseExcelModel {

	private int idx;

	private int second;

	private int gem;

	@Override
	public int getExcelId() {
		return idx;
	}
}
