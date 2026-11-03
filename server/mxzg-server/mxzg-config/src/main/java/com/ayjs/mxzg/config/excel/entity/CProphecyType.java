package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 先知抽奖
 */
@Getter
public class CProphecyType implements BaseExcelModel, IDrop {
	/**
	 * 先知召唤id
	 */
	private int idx;
	/**
	 * 抽奖类型（1正常抽奖2三十次保底3首抽保底）
	 */
	private int type;
	/**
	 * 元素类型
	 */
	private int prophecy_type;
	/**
	 * 召唤奖励
	 */
    private ImmutableList<ImmutableThing> item;
	/**
	 * 出现权重
	 */
	private int chance;
	/**
	 * 类别（1=T1,2=T2,3=T3,4=1~4星英雄）
	 */
	private int kind;
	/**
	 * 出奖是否公告
	 */
	private int notice;

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
