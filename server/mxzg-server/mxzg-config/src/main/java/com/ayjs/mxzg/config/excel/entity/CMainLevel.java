package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 角色升级
 * 
 * 
 */
@Getter
public class CMainLevel implements BaseExcelModel {
	/**
	 * 等级
	 */
	private int level;
	/**
	 * 所需经验
	 */
	private int exp;
	/**
	 * 升级奖励
	 * @return
	 */
    private ImmutableList<ImmutableThing> reward;

	@Override
	public int getExcelId() {
		return level;
	}
}
