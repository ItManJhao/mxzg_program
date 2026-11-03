package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.google.common.collect.ImmutableMap;

import lombok.Getter;

/**
 * 套装
 */
@Getter
public class CEquipmentSetType implements BaseExcelModel {

	private int idx;
	
	private int type;
	
	private int num;
	
	private ImmutableMap<AttributeType, Long> attr;
	
	@Override
	public int getExcelId() {
		return idx;
	}

}
