/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 巅峰赛排名奖励
 */
@Getter
public class CTopMatchSecondReward implements BaseExcelModel {
	private int idx;
	private int rank_low;
	private int rank_up;
	private ImmutableList<ImmutableThing> rank_reward;
	private int title_id;
	@Override
	public int getExcelId() {
		return idx;
	}
}
