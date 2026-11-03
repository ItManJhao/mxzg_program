/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity.timetower;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CTimeTowerMisson implements BaseExcelModel {
	private int mission;
	private int lv;
	private int type;
	private int need_gem_lv;
	private ImmutableList<ImmutableThing> reward;
	private ImmutableList<TowerFailCondition> conditions;
	@Override
	public int getExcelId() {
		return mission;
	}
}
