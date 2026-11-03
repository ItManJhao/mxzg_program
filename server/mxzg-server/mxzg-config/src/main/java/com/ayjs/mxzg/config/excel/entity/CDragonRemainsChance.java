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
public class CDragonRemainsChance implements BaseExcelModel, IDrop {
	private int idx;
	private int level;
	private int reward_group;
	private int chance;
	private int min_num;
	private int max_num;
	
	@Override
	public int getExcelId() {
		return idx;
	}
	@Override
	public int getDropId() {
		return idx;
	}
	@Override
	public int getRate() {
		return chance;
	}
}
