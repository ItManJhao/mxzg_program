package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 
 * 
 * 
 */
@Getter
public class CPromotion019MainLevelReward implements BaseExcelModel {

	private int idx;
	private int turns;
	private int main_level;
    private ImmutableList<ImmutableThing> reward;
	private int total_num;

	@Override
	public int getExcelId() {
		return idx;
	}
}
