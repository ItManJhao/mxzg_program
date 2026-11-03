package com.ayjs.mxzg.config.struct;

import java.util.List;

/**
 * 英雄信息接口
 * @author meiyc
 *
 */
public interface HeroConfig {

	
	/**
	 * 获取位置
	 * @return
	 */
	int getPos();

	/**
	 * 获取英雄id
	 * @return
	 */
	int getHero_type();

	/**
	 * 获取等级
	 * @return
	 */
	int getHero_level();
	
	/**
	 * 获取英雄品阶
	 * @return
	 */
	default int getStage(){ return 0;}

	/**
	 * 获取星际
	 * @return
	 */
	int getHero_star();

	/**
	 * 英雄属性
	 * @return
	 */
	List<AttributeKind> getAttr();

	/**
	 * 装备
	 * @return
	 */
	List<EquipInfo> getEquipment();

	/**
	 * 精灵
	 * @return
	 */
	List<RunesVo> getRunes();
	
}
