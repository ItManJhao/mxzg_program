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
public class CChampionRound implements BaseExcelModel {
	private int idx;
	private int is_cross_server;
	private int type;
	private int round;
	private int prepare_time;
	private int guess_time;
	private int battle_time;
	private int win_point;
	@Override
	public int getExcelId() {
		return idx;
	}
}
