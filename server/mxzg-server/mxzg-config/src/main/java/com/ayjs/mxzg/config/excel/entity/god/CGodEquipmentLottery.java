/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity.god;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CGodEquipmentLottery implements BaseExcelModel , IDrop {
	private int idx;
	private String description;
	private ImmutableList<ImmutableThing> reward;
	private int reward_type;
	private int weight;
	private int show_min;
	private int show_max;
	private int guarantee;
	private int notice_show;

	@Override
	public int getDropId() {
		return idx;
	}

	@Override
	public int getRate() {
		return weight;
	}

	@Override
	public int getExcelId() {
		return idx;
	}
}
