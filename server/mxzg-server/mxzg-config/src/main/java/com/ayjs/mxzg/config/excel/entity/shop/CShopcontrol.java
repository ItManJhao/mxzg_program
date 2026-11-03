package com.ayjs.mxzg.config.excel.entity.shop;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 商城配置表
 * 
 * 
 */
@Getter
public class CShopcontrol implements BaseExcelModel {
	
	private int idx;

	private String shop_type;
	
	private int goods_limit;
	
	private int auto_refresh_mode;
	
	private int auto_goods_refresh;
	
	private int auto_limits_refresh;
	
	private int manual_refresh_mode;
	
	private int manual_goods_refresh;
	
	private int manual_limit_refresh;
	
	private int daily_free_refresh;
	
	private int daily_charge_refresh;

	private int zero_free_refresh;

	private ImmutableList<ImmutableThing> charge_item_cost;
	
	private String cost_item;

	private int max_refresh_count;

	private int free_refresh_time;

	@Override
	public int getExcelId() {
		return idx;
	}
}
