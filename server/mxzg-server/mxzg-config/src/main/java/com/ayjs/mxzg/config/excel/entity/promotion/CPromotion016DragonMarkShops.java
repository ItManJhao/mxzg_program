package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 限时兑换
 * 
 * 
 */
@Getter
public class CPromotion016DragonMarkShops implements BaseExcelModel {
	private int idx;
	private int turns;
    private ImmutableList<ImmutableThing> item;
    private ImmutableList<ImmutableThing> cost;
	private int limit;
	private String mark_icon;
	private String show_mark;
	@Override
	public int getExcelId() {
		return idx;
	}
}
