package com.ayjs.mxzg.config.excel.entity.shop;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * 勇者试炼商店
 * 
 * 
 */
@Getter
public class CShopadventure implements BaseExcelModel, IShop {

	private int idx;
	
	private int chance;

    private ImmutableList<ImmutableThing> item_type;

    private ImmutableList<ImmutableThing> need_item;

	private int limit_type;

	private int buy_limit;

	@Override
	public int getExcelId() {
		return idx;
	}
}
