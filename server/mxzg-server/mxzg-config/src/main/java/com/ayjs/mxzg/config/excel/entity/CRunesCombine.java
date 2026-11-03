package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 符文合成
 * 
 */
@Getter
public class CRunesCombine implements BaseExcelModel {

	private int idx;
	/**
	 * 符文type_id
	 */
	private int type;
	/**
	 * 需要的经验
	 */
	private int need_point;
	/**
	 * 目标符文type_id
	 */
	private int combine_target;

	private int cost_gold;

	@Override
	public int getExcelId() {
		return idx;
	}
}
