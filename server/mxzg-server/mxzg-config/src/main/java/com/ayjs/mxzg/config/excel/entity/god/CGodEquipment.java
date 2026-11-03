/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity.god;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CGodEquipment implements BaseExcelModel {
	private int equipment_type;
	private String description;
	private int place;
	private int rare;
	private int star;
	private ImmutableMap<AttributeType, Long> ability;
	private int settype;
	private ImmutableList<ImmutableThing> up_star_cost;
	private int combine_target;
	private ImmutableList<ImmutableThing> recover_reward;
	@Override
	public int getExcelId() {
		return equipment_type;
	}
}
