package com.ayjs.mxzg.config.excel.entity;

import java.util.HashMap;
import java.util.Map;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * 神器升级
 * 
 */
@Getter
public class CGoddessLevel implements BaseExcelModel {
	
	private int lv;
	
	private int hp_base;
	
	private int atk_base;
	
	private int hp_progress;
	
	private int atk_progress;
	
	private int need_point;

    private ImmutableList<ImmutableThing> cost_res;

	private int point_add;

	@Override
	public int getExcelId() {
		return lv;
	}
	
	public Map<AttributeType, Long> getAttribute(int point){
		Map<AttributeType, Long> attributes = new HashMap<>();
		long hp = hp_base + point * hp_progress;
		long attack = atk_base + point * atk_progress;
		attributes.put(AttributeType.HP, hp);
		attributes.put(AttributeType.ATTACK, attack);
		return attributes;
	}
	
}