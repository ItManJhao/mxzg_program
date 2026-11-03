/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity.shop;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CShopDay implements BaseExcelModel, IShop {
	private int idx;

    private int chance;

    private ImmutableList<ImmutableThing> item_type;

    private ImmutableList<ImmutableThing> need_item;

    private int buy_limit;
    
	@Override
	public int getExcelId() {
		return idx;
	}

	@Override
	public int getLimit_type() {
		return 0;
	}
}
