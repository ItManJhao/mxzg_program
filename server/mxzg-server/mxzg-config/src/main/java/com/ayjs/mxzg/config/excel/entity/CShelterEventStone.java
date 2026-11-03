package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 *  庇护所石堆事件收益
 *
 */
@Getter
public class CShelterEventStone implements BaseExcelModel {
	
	private int idx;

    private ImmutableList<ImmutableThing> reward;

	@Override
	public int getExcelId() {
		return idx;
	}
}
