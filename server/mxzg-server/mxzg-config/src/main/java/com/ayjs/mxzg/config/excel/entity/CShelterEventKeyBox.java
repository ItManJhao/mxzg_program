package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * 庇护所钥匙宝箱物品获取概率
 *
 */
@Getter
public class CShelterEventKeyBox implements BaseExcelModel, IDrop {
	
	private int idx;

    private ImmutableList<ImmutableThing> reward;
	
	private int chance;

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
		return chance;
	}
}
