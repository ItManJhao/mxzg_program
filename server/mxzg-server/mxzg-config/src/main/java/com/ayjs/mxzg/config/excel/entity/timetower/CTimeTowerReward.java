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
public class CTimeTowerReward implements BaseExcelModel {
	private int idx;
	private int rank_max;
	private int rank_min;
	private ImmutableList<ImmutableThing> reward;
	@Override
	public int getExcelId() {
		return idx;
	}
}
