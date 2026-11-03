package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;

import lombok.Getter;

/**
 * 符文技能等级、权重
 * 
 */
@Getter
public class CRuneSkillType implements BaseExcelModel, IDrop {

	private int idx;
	/**
	 * 技能id
	 */
	private int skill_id;

	private int level;

	private int chance;
	
	private int score_count;

	@Override
	public int getExcelId() {
		return idx;
	}

	@Override
    public int getDropId() {
		return idx;
	}

	@Override
	public int getRate() {
		return chance;
	}

}
