package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.EquipInfo;
import com.ayjs.mxzg.config.struct.HeroConfig;
import com.ayjs.mxzg.config.struct.RunesVo;
import com.google.common.collect.ImmutableList;

import lombok.Getter;
import lombok.Setter;

/**
 * 关卡怪物表
 * @author meiyc
 *
 */
@Getter
@Setter
public class CChapter  implements BaseExcelModel, HeroConfig {

	/** id */
	private int idx;
	
	/** 难度id */
	private int mode_id;
	
	/** 章节 */
	private int chapter_id;
	
	/** 关卡id */
	private int mission_id;
	
	/** 站位 */
	private int pos;
	
	/** 怪物id */
	private int hero_type;
	
	/** 怪物等级 */
	private int hero_level;
	
	/** 怪物星际 */
	private int hero_star;
	
	/** 属性 */
	private ImmutableList<AttributeKind> attr;
	
	/** 装备 */
	private ImmutableList<EquipInfo> equipment;
	
	/** 精灵 */
	private ImmutableList<RunesVo> runes;
	
	@Override
	public int getExcelId() {
		return idx;
	}

}
