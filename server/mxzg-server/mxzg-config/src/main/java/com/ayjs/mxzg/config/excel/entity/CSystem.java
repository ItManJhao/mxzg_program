package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.excel.ExcelDictionaryCache.IDictionaryStruct;

import lombok.Getter;

/**
 * 游戏系统的一些全局配置
 * 
 */
@Getter
public class CSystem implements BaseExcelModel, IDictionaryStruct {
	
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
