package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/***
 * 自选礼包
 */
@Getter
public class CSelfSelectGift implements BaseExcelModel {

	private int idx;
	private int type;
	private ImmutableList<ImmutableThing> reward;


	@Override
	public int getExcelId() {
		return idx;
	}
}
