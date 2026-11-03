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
public class CClanWorldBoss implements BaseExcelModel {
	private int round;
	private int boss_type;
	private int reward_rank_type_clan;
	private int reward_rank_type_player;
	@Override
	public int getExcelId() {
		return round;
	}
}
