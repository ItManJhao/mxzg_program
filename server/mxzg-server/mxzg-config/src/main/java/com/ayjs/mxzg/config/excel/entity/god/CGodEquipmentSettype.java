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
public class CGodEquipmentSettype implements BaseExcelModel {
	private int idx;
	private int settype;
	private int star;
	private int num;
	private ImmutableMap<AttributeType, Long> ability;
	private int skill;
	@Override
	public int getExcelId() {
		return idx;
	}
}
