/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.IHeroPlacingPartConfig;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CJewelType implements BaseExcelModel, IHeroPlacingPartConfig {
	private int jewel_type;
	private int place;
	private int rare;
	private int star;
	private ImmutableList<ImmutableThing> need_equipment;
	private ImmutableMap<AttributeType, Long> ability;
	private int combine_target;
	private ImmutableMap<AttributeType, Long> get_fighting;
	@Override
	public int getExcelId() {
		return jewel_type;
	}
	@Override
	public int getPartItemType() {
		return jewel_type;
	}
}
