package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import lombok.Getter;

/**
 * 英雄抽奖
 *
 */
@Getter
public class CLotteryWeight implements BaseExcelModel, IDrop {

	/**
	 * 英雄类型
	 */
	private int hero_type;
	/**
	 * 星级
	 */
	private int star;
	/**
	 * 普抽
	 */
	private int chance_normal;
	/**
	 * 友情点
	 */
	private int chance_friend;
	/**
	 * 高抽
	 */
	private int chance_advance;
	/**
	 * 积分
	 */
	private int chance_point;
	/**
	 * 新英雄抽卡
	 */
	private int chance_rolling;

	@Override
	public int getExcelId() {
		return hero_type;
	}

	@Override
    public int getDropId() {
		return hero_type;
	}

	@Override
	public int getRate() {
		return chance_point;
	}
}
