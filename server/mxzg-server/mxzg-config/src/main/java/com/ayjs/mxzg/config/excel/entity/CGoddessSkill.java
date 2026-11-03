package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 女神技能
 * @author meiyc
 *
 */
@Getter
public class CGoddessSkill implements BaseExcelModel {
	
	private int idx;
	
	private int skill;

	@Override
	public int getExcelId() {
		return idx;
	}
}