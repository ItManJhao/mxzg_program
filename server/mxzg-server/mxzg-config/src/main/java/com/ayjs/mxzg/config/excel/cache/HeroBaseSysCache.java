package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CHeroBase;
import com.ayjs.mxzg.config.struct.BattleAttr;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class HeroBaseSysCache extends BaseExcelCache<CHeroBase> {
	
	
	private Map<Integer, Map<Integer, CHeroBase>> typeStarMap;

	@Override
	public String getFileName() {
		return "herobase";
	}

	@Override
	protected void loadAfterReady() {
		this.typeStarMap = this.fillTwoLayerMap(CHeroBase::getType, CHeroBase::getStar);
		
		for(CHeroBase cHeroBase : this.getAll()) {
			BattleAttr attr = new BattleAttr();
			attr.setAttack(cHeroBase.getAtk());
			attr.setDefend(cHeroBase.getDef());
			attr.setSpeed(cHeroBase.getSpd());
			attr.setHp(cHeroBase.getHp());
			cHeroBase.setBattleAttr(attr);
		}
	}
	
	/**
	 * 根据英雄类型和星际获取英雄配置，如果没有则抛出异常
	 * @param type
	 * @param star
	 * @return
	 */
	public CHeroBase getTypeStarOrThrow(int type, int star) {
		Map<Integer, CHeroBase> map = typeStarMap.get(type);
		ConfigAsserts.notNull(map, String.format("CHeroBase没有找到英雄基础配置英雄id:%s", type));
		CHeroBase cHeroBase = map.get(star);
		ConfigAsserts.notNull(cHeroBase, String.format("CHeroBase没有找到英雄%s基础配置英雄星级:%s", type, star));
		return cHeroBase;
	}
}