package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 皮肤任务
 *
 */
@Getter
public class CGoddessFashionMission implements BaseExcelModel {

	private int idx;

	private int fashion_type;

	//任务目标
	private TargetStruct task;

	private ImmutableList<ImmutableThing> reward;

	@Override
	public int getExcelId() {
		return idx;
	}
}