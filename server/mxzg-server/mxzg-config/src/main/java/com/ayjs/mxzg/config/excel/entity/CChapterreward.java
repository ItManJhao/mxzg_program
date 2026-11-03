package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.RollReward;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 奖励配置
 * 
 */
@Getter
public class CChapterreward implements BaseExcelModel {

	private int idx;

	private int mode_id;

	/**
	 * 章节ID
	 */
	private int chapter_id;

	private int chapter_total;
	/**
	 * 关卡ID
	 */
	private int mission_id;

	/**
	 * 关卡战力要求
	 */
	private int combat_effectiveness;
	/**
	 * 关卡等级要求
	 */
	private int level;
	/**
	 * 关卡挂机金币，英魂，经验奖励
	 */
    private ImmutableList<ImmutableThing> reward_base;
	/**
	 * 挂机道具奖励
	 */
    private ImmutableList<RollReward> reward_unique;
	/**
	 * 掉落组id
	 */
	private int drop_group;
	/**
	 * 关卡首通奖励
	 */
    private ImmutableList<ImmutableThing> first_reward;

	private String map;

	private int tavern_point_max;

	@Override
	public int getExcelId() {
		return idx;
	}
}
