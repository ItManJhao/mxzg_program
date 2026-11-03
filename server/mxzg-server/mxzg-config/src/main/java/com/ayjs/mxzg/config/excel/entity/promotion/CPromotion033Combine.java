package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 合成觉醒
 * 
 * 
 */
@Getter
public class CPromotion033Combine implements BaseExcelModel {
	private int idx;
	private int turns;
	private int star;
    private ImmutableList<ImmutableThing> reward;
	private int reward_limit;
	@Override
	public int getExcelId() {
		return idx;
	}

}
