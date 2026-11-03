package com.ayjs.mxzg.config.excel.entity;

import java.util.List;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ThingBonus;

import lombok.Getter;

/**
 * 神器VIP权益
 * 
 */
@Getter
public class CGoddessVip implements BaseExcelModel {
	
	private int vip_level;
	
	private int unlock_goddess_10101;
	
	private int unlock_goddess_10201;
	
	private int unlock_goddess_10301;
	
	private int unlock_goddess_10401;
	
	private int unlock_goddess_10501;
	
	private int battle_speed_2x;
	
	private int battle_speed_3x;
	
	private int charater_exp_bonus;
	
	private int gold_bonus;
	
	private int heroes_exp_bonus;
	
	private int unlock_normal_wishpool_10;
	
	private int unlock_special_headpic;
	
	private int sacrifice_bonus;
	
	private int extra_market_times;

	private int extra_bag_space;

	private int extra_idle_time;

	private int extra_resource_times;

	private int buy_gold_bonus;

	private int battle_skip;
	/**
	 * 挂机加成
	 */
	private List<ThingBonus> hangBonusList;
	/**
	 * 点金加成
	 */
	private List<ThingBonus> buyGoldBonusList;

	@Override
	public int getExcelId() {
		return vip_level;
	}

	public void setHangBonusList(List<ThingBonus> hangBonusList) {
		this.hangBonusList = hangBonusList;
	}

	public void setBuyGoldBonusList(List<ThingBonus> buyGoldBonusList) {
		this.buyGoldBonusList = buyGoldBonusList;
	}
}