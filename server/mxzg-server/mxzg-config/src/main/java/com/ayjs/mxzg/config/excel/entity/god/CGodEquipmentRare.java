/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity.god;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CGodEquipmentRare implements BaseExcelModel {
	private int equipment_rare;
	private int random_ability_num;
	private int random_ability_start_level;
	private ImmutableList<ImmutableThing> wash_cost;
	@Override
	public int getExcelId() {
		return equipment_rare;
	}
}
