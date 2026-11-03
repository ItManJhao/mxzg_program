package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 英雄图鉴星级配
 */
@Getter
public class CSkin implements BaseExcelModel {
	
	private int type;
	
	private String star_limit;
	
	private String handbook;
	
	private String skin;

	@Override
	public int getExcelId() {
		return type;
	}
}
