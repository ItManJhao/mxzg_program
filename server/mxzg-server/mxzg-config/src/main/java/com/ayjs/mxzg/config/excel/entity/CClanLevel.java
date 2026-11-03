package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 公会等级
 * 
 */
@Getter
public class CClanLevel implements BaseExcelModel {

	private int level;

	private int need_clan_exp;

	private int member;

	private int leader_num;

	@Override
	public int getExcelId() {
		return level;
	}
}