package com.ayjs.mxzg.config.excel.entity.shop;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * 市场
 *
 */
@Getter
public class CShopmarket implements BaseExcelModel, IShop {
	/**
	 * 市场商店id
	 */
	private int idx;
	/**
	 * 权重
	 */
	private int chance;
	/**
	 * 商品道具
	 */
    private ImmutableList<ImmutableThing> item_type;
	/**
	 * 价格
	 */
    private ImmutableList<ImmutableThing> need_item;

	private int limit_type;

	private int buy_limit;


	/**
	 * 显示折扣
	 */
	private int discount;
	/**
	 * 玩家等级不低于该等级才出现该货物
	 */
	private int level_require_min;
	/**
	 * 玩家等级不高于该等级才出现该货物
	 */
	private int level_require_max;

	@Override
	public int getExcelId() {
		return idx;
	}
}
