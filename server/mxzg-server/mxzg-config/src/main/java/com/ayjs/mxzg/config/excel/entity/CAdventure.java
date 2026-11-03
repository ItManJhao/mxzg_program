package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 试炼关卡数据
 *
 */
@Getter
public class CAdventure implements BaseExcelModel {

	private int idx;// 唯一标识键

	private int mission_id;// 关卡ID

	private int pos;// 怪物英雄数量

	private int atk_multiple;//

	private int hp_multiple;

	private int hero_type;// 怪物英雄类型ID

	private int hero_level;// 怪物英雄等级

	private int hero_star;// 星级

	@Override
	public int getExcelId() {
		return idx;
	}
}
