/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

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
public class CRainbowMission implements BaseExcelModel, HeroConfig {
	private int idx;
	private int rainbow_type;
	private int level;
	private int pos;
	private int hero_type;
	private int hero_level;
	private int hero_star;
    private ImmutableList<AttributeKind> attr;
    private ImmutableList<EquipInfo> equipment;
    private ImmutableList<RunesVo> runes;
    private String skill_show;
    private String passive_skill_show;
    
	@Override
	public int getExcelId() {
		return idx;
	}
}
