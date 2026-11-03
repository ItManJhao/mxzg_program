package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 公会副本排行奖励
 * 
 * 
 */
@Getter
public class CClanBossRankReward implements BaseExcelModel {

	private int idx;

	private int boss_id;

	private int rank_low;

	private int rank_up;

    private ImmutableList<ImmutableThing> rank_reward;

	@Override
	public int getExcelId() {
		return idx;
	}
}
