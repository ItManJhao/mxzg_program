/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.struct;

import java.util.Map;

import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;

/**
 * @author YY
 * 布阵断言
 */
public interface LineUpPredicate {

	/**
	 * 布阵类型
	 * @return
	 */
	public LineUpType lineUpType();
	/**
	 * 获取英雄快照
	 * @param rid
	 * @param heroId
	 * @return
	 */
	public HeroSnapshot pickHero(long rid, long heroId);
	
	default public void checkLineUp(Map<Long, HeroPosition> heroPos) {};
	
	default public void handleAfterLineUpSaved(HeroLineUp heroLineUp) {}
}
