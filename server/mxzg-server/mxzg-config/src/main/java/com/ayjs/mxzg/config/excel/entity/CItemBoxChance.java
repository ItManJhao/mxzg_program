package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * 英雄升星
 * 
 * 
 */
@Getter
public class CItemBoxChance implements BaseExcelModel {

	private int type;
	private int kind;
    private ImmutableList<ImmutableThing> item;

	@Override
	public int getExcelId() {
		return type;
	}
}
