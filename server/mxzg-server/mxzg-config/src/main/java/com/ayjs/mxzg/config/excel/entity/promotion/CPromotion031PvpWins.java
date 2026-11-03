package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 好战者活动
 */
@Getter
public class CPromotion031PvpWins implements BaseExcelModel {
	private int idx;
	private int turns;
	private int pvp_win_times;
    private ImmutableList<ImmutableThing> reward;
	@Override
	public int getExcelId() {
		return idx;
	}

}
