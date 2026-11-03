package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 符文类型、重铸技能
 * 
 */
@Getter
public class CRunesType implements BaseExcelModel {

	private int idx;

    /**
     * 符文type_id
     */
	private int type;

    /**
     * 品质
     */
	private int rare;
	private int skill_max;
	private String skill_num_chance;
	private String skill1_level;
	private String skill2_level;
    private ImmutableList<ImmutableThing> value;
    private ImmutableList<ImmutableThing> random_cost;
	private int point;
	private int score;

	@Override
	public int getExcelId() {
		return idx;
	}
}
