package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * 许愿池消耗
 * 
 * 
 */
@Getter
public class CWishPoolNeed implements BaseExcelModel {

	/**
	 * idx
	 */
	private int idx;
	/**
	 * 许愿池类型（1低级2高级）
	 */
	private int wishpool_type;
	/**
	 * 单次和十次
	 */
	private int play_time;
	/**
	 * 消耗
	 */
	private ImmutableList<ImmutableThing> need_item;

	/***
	 * 增加幸运值
	 */
	private int add_lucky_value;

	@Override
	public int getExcelId() {
		return idx;
	}
}
