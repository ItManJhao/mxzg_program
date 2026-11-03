package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 公会技能升级配置表
 * 
 * 
 */
@Getter
public class CClanSkillAbility implements BaseExcelModel {

	private int idx;

	private int occupation;
	
	private int type;
	
	private int ability;

	private int num;

	@Override
	public int getExcelId() {
		return idx;
	}
}
