package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 女神技能
 * @author meiyc
 *
 */
@Getter
public class CGoddessSkillLevel implements BaseExcelModel {
	
	private int idx;
	
	private int type;
	
	private int level;

    private int skill_atk;
	
	@Override
	public int getExcelId() {
		return idx;
	}
}