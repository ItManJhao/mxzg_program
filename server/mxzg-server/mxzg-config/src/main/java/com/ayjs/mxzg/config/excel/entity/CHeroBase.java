package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.BattleAttr;

import lombok.Getter;

/**
 * 英雄基础
 * 
 * 
 */
@Getter
public class CHeroBase implements BaseExcelModel {
	
	private int idx;
	
	private int type;
	
	private int star;
	
	private long hp;
	
	private int atk;
	
	private int def;
	
	private int spd;
	
	private BattleAttr battleAttr;

	@Override
	public int getExcelId() {
		return idx;
	}

	public BattleAttr getBattleAttr() {
		return battleAttr;
	}

	public void setBattleAttr(BattleAttr battleAttr) {
		this.battleAttr = battleAttr;
	}
}
