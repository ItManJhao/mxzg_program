/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.google.common.collect.ImmutableMap;

import lombok.Getter;

/**
 * @author YY
 * 
 */
@Getter
public class CJewelSetType implements BaseExcelModel {
	private int idx;
	private int star;
	private ImmutableMap<AttributeType, Long> attr;
	@Override
	public int getExcelId() {
		return idx;
	}
}
