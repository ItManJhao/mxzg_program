package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 关卡首通
 * 
 * 
 */
@Getter
public class CChapterExtraReward implements BaseExcelModel {
	
	private int idx;
	
	private int chapter;

    private ImmutableList<ImmutableThing> reward;
	
	@Override
	public int getExcelId() {
		return idx;
	}

}
