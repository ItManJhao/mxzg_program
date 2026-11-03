package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.google.common.collect.ImmutableMap;

import lombok.Getter;

/**
 * 符文基础属性
 * 
 */
@Getter
public class CRunesAbility implements BaseExcelModel, IDrop {
    /**
     * 随机属性的类型
     */
	public int idx;
	private int rare;
	private int type;
	private ImmutableMap<AttributeType, Long> ability;

	@Override
	public int getExcelId() {
		return idx;
	}

	@Override
    public int getDropId() {
		return idx;
	}

	@Override
	public int getRate() {
		return 1;
	}
}
