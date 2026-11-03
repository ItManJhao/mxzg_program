package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import lombok.Getter;

/**
 * 英雄抽奖
 *
 */
@Getter
public class CLotteryType implements BaseExcelModel, IDrop {

	private int idx;

	/**
	 * 抽奖类型
	 */
	private int lottery_type;

	/**
	 * 星级
	 */
	private int star;

	/**
	 * 抽奖概率
	 */
	private int chance;
	/**
	 * 最少多少次才出
	 */
	private int happen_lower_times;
	/**
	 * 最大多少次必出
	 */
	private int happen_upper_times;

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
