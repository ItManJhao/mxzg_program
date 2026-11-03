package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 英雄升阶
 * 
 * 
 */
@Getter
public class CHeroUpGrade implements BaseExcelModel {

	private int grade;

	private int soul;

	private int gold;

	private int level;

	private int skill1;

	private int skill2;

	private int skill3;

	private int skill4;

	private int begin_level;
	
	private int score;

	@Override
	public int getExcelId() {
		return grade;
	}

}
