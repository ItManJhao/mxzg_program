package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 英雄抽奖
 * 
 */
@Getter
public class CShopseniorticket implements BaseExcelModel {
	
	private int item_num;
	
	private int need_gem;

	@Override
	public int getExcelId() {
		return item_num;
	}
}