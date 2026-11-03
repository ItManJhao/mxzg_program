package com.ayjs.mxzg.config.struct;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
@AllArgsConstructor
public class HeroInfo {

	/** 数据库主键id*/
	private long id;
	
	/** 英雄id */
	private int heroId;
	
	/** 星际 */
	private int star;
	
	/** 等级 */
	private int level;
	
	/** 阶 */
	private int stage;
	
	/** 位置 */
	private int position;
	
	/** 属性 */
	private List<AttributeKind> attr;

	/** 装备 */
	private List<EquipInfo> equipment;
	
	/** 符文 */
	private List<RunesVo> runes;
	
	public static HeroInfo createOf(HeroConfig config){
		return new HeroInfo(0L, config.getHero_type(), config.getHero_star(), config.getHero_level(), config.getStage(),
				config.getPos(), config.getAttr(), config.getEquipment(), config.getRunes());
	}
	
	public static HeroInfo valueOf(long id, int heroType, int star, int level, int stage, int pos){
		return new HeroInfo(id, heroType, star, level, stage,
				pos, null, null, null);
	}
	
}
