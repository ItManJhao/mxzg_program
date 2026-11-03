package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;

import lombok.Getter;

/**
 * 神器突破等级
 * 
 */
@Getter
public class CGoddessBreak implements BaseExcelModel {

	private int lv;

	private ImmutableMap<AttributeType, Long> ability;

    private ImmutableList<ImmutableThing> cost_res;

	private int skin;

	@Override
	public int getExcelId() {
		return lv;
	}
}