/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity.god;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.google.common.collect.ImmutableMap;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CGodEquipmentRandomAbility implements BaseExcelModel {
	private int idx;
	private int place;
	private int star;
	private int ability_type;
	private int level;
	private int rare;
	private ImmutableMap<AttributeType, Long> ability;
	@Override
	public int getExcelId() {
		return idx;
	}
}
