package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ThingBonus;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

import java.util.List;

/**
 * 特权礼包
 * 
 */
@Getter
public class CPromotion010PrivilegeGift implements BaseExcelModel {
	private int idx;
	private int buy_type;
	private int cost_gem;
	private int production_id;
    private ImmutableList<ImmutableThing> item;
	private int limit_day;
	private int limit_num;
	private List<ThingBonus> bonus;
	private int show_level;
	private int time_mode;

	@Override
	public int getExcelId() {
		return idx;
	}
}
