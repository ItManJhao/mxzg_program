package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 英雄抽奖消耗和积分奖励
 *
 */
@Getter
public class CLotteryPoint implements BaseExcelModel {

	private int idx;

	/**
	 * 抽奖类型
	 */
	private int type;

	/**
	 * 次数
	 */
	private int summon_times;

	/**
	 * 积分
	 */
    private ImmutableList<ImmutableThing> point;

	/**
	 * 消耗资源
	 */
    private ImmutableList<ImmutableThing> need_item;

	/**
	 * 免费抽更新时间
	 */
	private int free_time;

	@Override
	public int getExcelId() {
		return idx;
	}
}
