package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 *  洒馆
 *
 */
@Getter
public class CTavern implements BaseExcelModel, IDrop {
	
	private int idx;
	
	/**
	 * 星级
	 */
	private int star;
	
	/**
	 * 时间
	 */
	private int time;
	
	/**
	 *  
	 */
    private ImmutableList<ImmutableThing> item;
	
	/**
	 * 所需英雄数
	 */
	private int hero_num;
	
	/**
	 * 英雄身份
	 */
	private String hero_condition;
	/**
	 * 出现权重
	 */
	private int chance;

	/**
	 * 接取任务所需的冒险点数
	 */
	private ImmutableList<ImmutableThing> need_points;
	
	/**
	 * 至少多少次出
	 */
	private int show_min;
	/**
	 * 多少次必出(0不限制)
	 */
	private int show_max;
	/**
	 * 每天最多次数(0不限制)
	 */
	private int max_day;

	
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
