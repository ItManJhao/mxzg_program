package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 神器类型
 * 
 */
@Getter
public class CGoddessUnlock implements BaseExcelModel {
	
	private int type;

	private int vip_level;

	private int x;

	private int y;

	private int skill;

	@Override
	public int getExcelId() {
		return type;
	}
}