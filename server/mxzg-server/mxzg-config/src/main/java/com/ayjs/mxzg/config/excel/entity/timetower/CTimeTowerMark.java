/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity.timetower;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CTimeTowerMark implements BaseExcelModel {
	private int mark;
	private int round_max;
	private int round_min;
	@Override
	public int getExcelId() {
		return mark;
	}
}
