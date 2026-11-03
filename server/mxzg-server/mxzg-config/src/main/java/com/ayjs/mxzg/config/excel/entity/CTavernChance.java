package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;

import lombok.Getter;

/**
 *  洒馆
 *
 */
@Getter
public class CTavernChance implements BaseExcelModel, IDrop {
	/**
	 * 
	 */
	private int type;
	/**
	 * 
	 */
	private int star;
	/**
	 *  出现机率
	 */
	private int chance;
	/**
	 * 每次刷新任务最多出现的星级数量（0时不限制）
	 */
	private int flash_max;
	/**
	 * 每刷新N次必出（0时不限制）
	 */
	private int flash_show;

	@Override
	public int getExcelId() {
		return type;
	}

	@Override
    public int getDropId() {
		return type;
	}

	@Override
	public int getRate() {
		return chance;
	}
}
