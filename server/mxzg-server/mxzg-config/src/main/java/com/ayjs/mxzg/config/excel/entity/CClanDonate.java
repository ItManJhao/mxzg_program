package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 公会捐献配置表
 * 
 * 
 */
@Getter
public class CClanDonate implements BaseExcelModel {

	private int type;

    private ImmutableList<ImmutableThing> cost_res;

    private ImmutableList<ImmutableThing> clan_exp_gain;

    private ImmutableList<ImmutableThing> reward;

	private int donate_exp_gain;

	@Override
	public int getExcelId() {
		return type;
	}

}
