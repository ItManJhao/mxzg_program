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
public class CRainbow implements BaseExcelModel {
	private int rainbow_type;
	private ImmutableMap<AttributeType, Long> attr;
	private int need_rank;
	private int time;
	private int num;
	private String name_lang;
	@Override
	public int getExcelId() {
		return rainbow_type;
	}
}
