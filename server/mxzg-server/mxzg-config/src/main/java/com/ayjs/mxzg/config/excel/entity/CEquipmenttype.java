package com.ayjs.mxzg.config.excel.entity;


import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.IHeroPlacingPartConfig;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;

import lombok.Getter;

/**
 * 装备
 * 
 * 
 */
@Getter
public class CEquipmenttype implements BaseExcelModel, IHeroPlacingPartConfig {

	private int equipment_type;

	private int place;

	private int rare; // 1为绿色，2为蓝色，3为紫色，4为橙色，5为红色

	private int star;

    private ImmutableList<ImmutableThing> need_equipment;

	private long need_gold;

	private ImmutableMap<AttributeType, Long> ability;

	private int set_type;
	
	private int combine_target;

	@Override
	public int getExcelId() {
		return equipment_type;
	}

	@Override
	public int getPartItemType() {
		return equipment_type;
	}
}
