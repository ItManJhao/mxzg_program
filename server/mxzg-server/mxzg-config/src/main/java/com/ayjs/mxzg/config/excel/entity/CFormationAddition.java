/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;

/**
 * 阵法加成
 */
@Getter
public class CFormationAddition implements BaseExcelModel {
	private int idx;

	private int type;

	private int position;

	private ImmutableMap<AttributeType, Long> ability;

	@Override
	public int getExcelId() {
		return idx;
	}
}
