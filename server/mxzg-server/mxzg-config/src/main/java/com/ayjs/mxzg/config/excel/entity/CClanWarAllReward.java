/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CClanWarAllReward implements BaseExcelModel {
	private int idx;
	private ImmutableList<ImmutableThing> reward;
	@Override
	public int getExcelId() {
		return idx;
	}
}
