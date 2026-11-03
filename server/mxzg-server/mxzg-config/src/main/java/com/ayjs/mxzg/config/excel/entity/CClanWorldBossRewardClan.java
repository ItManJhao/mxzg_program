/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CClanWorldBossRewardClan implements BaseExcelModel {
	private int idx;
	private int reward_rank_type;
	private int rank_low;
	private int rank_up;
	private ImmutableList<ImmutableThing> rank_reward;
	@Override
	public int getExcelId() {
		return idx;
	}
}
