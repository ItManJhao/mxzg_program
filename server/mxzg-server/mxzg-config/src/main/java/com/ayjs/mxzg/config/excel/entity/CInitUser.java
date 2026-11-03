package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 创号配置
 * 
 */
@Getter
public class CInitUser implements BaseExcelModel {
	
	private int idx;
	/**
	 * 键
	 */
	private String key;
	/**
	 * 值
	 */
	private String value;

	@Override
	public int getExcelId() {
		return idx;
	}
}