/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;


@Getter
public class CTopMatchSecondPoint implements BaseExcelModel {
	private int idx;
	private int initial_point;
	@Override
	public int getExcelId() {
		return idx;
	}
}
