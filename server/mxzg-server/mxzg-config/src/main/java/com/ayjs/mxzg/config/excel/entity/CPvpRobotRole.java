/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CPvpRobotRole implements BaseExcelModel, IDrop {
	private int team;
	private String name_lang;
	private int head;
	private int cup;
	private int level;
	@Override
	public int getExcelId() {
		return team;
	}
	@Override
	public int getDropId() {
		return team;
	}
	@Override
	public int getRate() {
		return 1;
	}
}
