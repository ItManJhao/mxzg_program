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
public class CDragonRemains implements BaseExcelModel {
	private int idx;
	private int type;
	private int level;
	private ImmutableList<ImmutableThing> cost;
	private ImmutableList<ImmutableThing> buy;
	private int point;
	@Override
	public int getExcelId() {
		return idx;
	}
}
