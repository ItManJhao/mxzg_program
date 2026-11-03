package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 *  庇护所商店商品刷新概率
 *
 */
@Getter
public class CShelterShopPrize implements BaseExcelModel, IDrop {
	
	private int idx;

    private ImmutableList<ImmutableThing> item;

    private ImmutableList<ImmutableThing> cost;
	
	private int chance;
	
	private int discount;

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
