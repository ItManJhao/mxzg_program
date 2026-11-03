package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.google.common.collect.ImmutableMap;

import lombok.Getter;

/**
 * 女神被动
 * @author meiyc
 *
 */
@Getter
public class CGoddessPassive implements BaseExcelModel {
	
	private int idx;
	
	private int type;
	
	private int skill_level;

    private int skin;
	
	private ImmutableMap<AttributeType, Long> ability;

	@Override
	public int getExcelId() {
		return idx;
	}
}