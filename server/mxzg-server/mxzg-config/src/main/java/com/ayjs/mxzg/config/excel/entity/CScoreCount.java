package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 *  英雄抽奖消耗和积分奖励
 *
 */
@Getter
public class CScoreCount implements BaseExcelModel {
	
	private int idx;
	private String type;
	private int ratio;
	private int mapping;

	@Override
	public int getExcelId() {
		return idx;
	}
}
