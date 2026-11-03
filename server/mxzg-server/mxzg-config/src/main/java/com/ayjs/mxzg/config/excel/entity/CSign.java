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
public class CSign implements BaseExcelModel {
	private int idx;
	private int month;
	private int day;
    private ImmutableList<ImmutableThing> reward;
    private ImmutableList<ImmutableThing> new_server_reward;
	@Override
	public int getExcelId() {
		return idx;
	}
}
