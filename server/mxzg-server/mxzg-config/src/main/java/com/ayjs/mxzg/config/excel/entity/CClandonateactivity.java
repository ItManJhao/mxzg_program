package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 公会献总数奖励
 * 
 */
@Getter
public class CClandonateactivity implements BaseExcelModel {

	private int idx; // 奖励ID

	private int donate_times; // 奖励领取要求
    private ImmutableList<ImmutableThing> reward; // 奖励内容

	@Override
	public int getExcelId() {
		return idx;
	}
}