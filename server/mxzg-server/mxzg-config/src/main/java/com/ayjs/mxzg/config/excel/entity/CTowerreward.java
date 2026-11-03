package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * 幻境之塔关卡奖励
 * 
 */
@Getter
public class CTowerreward implements BaseExcelModel {

	private int mission_id;

    private ImmutableList<ImmutableThing> reward;

    private ImmutableList<ImmutableThing> first_reward_tower;
	
	private int battle_advice;

	@Override
	public int getExcelId() {
		return mission_id;
	}
}
