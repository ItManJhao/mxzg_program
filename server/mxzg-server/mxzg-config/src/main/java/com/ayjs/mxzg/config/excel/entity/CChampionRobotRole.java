/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CChampionRobotRole implements BaseExcelModel {
	private int team;
	private int level;
	private String name_lang;
	private int head;
	private int cup;
	@Override
	public int getExcelId() {
		return team;
	}
}
