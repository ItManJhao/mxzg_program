package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 女神技能精炼等级
 * @author meiyc
 *
 */
@Getter
public class CGoddessSkillRefineLevel implements BaseExcelModel {
	
	private int idx;	//主键id
	
	private int type;	//精灵类型
	
	private int skill_level;	// 技能等级

    private int skill_atk;		// 精炼攻击

	@Override
	public int getExcelId() {
		return idx;
	}
}