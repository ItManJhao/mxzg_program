package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 成就
 */
@Getter
public class CAchievementTest implements BaseExcelModel {

	//任务id
	private int idx;
	//任务目标
	private TargetStruct task;
	//前置任务
	private int prev_task;
	//奖励
	private ImmutableList<ImmutableThing> reward;

	@Override
	public int getExcelId() {
		return idx;
	}
}
