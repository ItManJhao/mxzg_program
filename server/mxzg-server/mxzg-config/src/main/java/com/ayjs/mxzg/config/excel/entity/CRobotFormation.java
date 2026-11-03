package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;
import lombok.Setter;

/**
 * 机器人阵容
 */
@Getter
@Setter
public class CRobotFormation implements BaseExcelModel {
	
	public int idx;	
	private int fighting;	// 战力下限
	private int level;		//等级
	private String formation;	//阵容

	@Override
	public int getExcelId() {
		return idx;
	}

}