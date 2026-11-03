/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity.timetower;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.EquipInfo;
import com.ayjs.mxzg.config.struct.HeroConfig;
import com.ayjs.mxzg.config.struct.RunesVo;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CTimeTowerMoster implements BaseExcelModel, HeroConfig {
	private int idx;
	private int mission;
	private int pos;
	private int hero_type;
	private int hero_level;
	private int hero_star;
	/**
     * 星际
     */
    private ImmutableList<AttributeKind> attr;

    /**
     * 装备
     */
    private ImmutableList<EquipInfo> equipment;

    /**
     * 铭文
     */
    private ImmutableList<RunesVo> runes;

	@Override
	public int getExcelId() {
		return idx;
	}
}
