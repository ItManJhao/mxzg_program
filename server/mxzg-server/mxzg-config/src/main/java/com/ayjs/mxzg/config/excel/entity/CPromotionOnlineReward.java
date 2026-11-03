package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 在线奖励
 * 
 * 
 */
@Getter
public class CPromotionOnlineReward implements BaseExcelModel {
	
	private int idx;
	
	private int time;

    private ImmutableList<ImmutableThing> reward;

    private int once_again;
	

	@Override
	public int getExcelId() {
		return idx;
	}

}
