package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 *  
 * 快速之王配置表
 * 
 */
@Getter
public class CPromotion026SpeedFight implements BaseExcelModel {
	private int idx;
	private int turns;
	private int speed_fight_times;
    private ImmutableList<ImmutableThing> reward;
	@Override
	public int getExcelId() {
		return idx;
	}
}
