/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CBattleFormation implements BaseExcelModel {
	private int idx;
	private String note;
	private int hero_need_level;
	private int lock_hero;
	private int del_hero;
	@Override
	public int getExcelId() {
		return idx;
	}
}
