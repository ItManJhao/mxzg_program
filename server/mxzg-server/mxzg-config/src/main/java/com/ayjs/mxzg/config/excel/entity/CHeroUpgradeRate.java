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
public class CHeroUpgradeRate implements BaseExcelModel {
	private int idx;
	private int grade;
	private int hero_id;
	private int hp_rate;
	private int atk_rate;
	private int def_rate;
	private int spd_rate;
	private int hp_grow;
	private int atk_grow;
	private int def_grow;
	private int spd_grow;
	@Override
	public int getExcelId() {
		return idx;
	}
}
