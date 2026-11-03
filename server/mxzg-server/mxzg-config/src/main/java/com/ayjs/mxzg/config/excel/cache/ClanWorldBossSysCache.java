/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CClanWorldBoss;

/**
 * @author YY
 *
 */
@Component
public class ClanWorldBossSysCache extends BaseExcelCache<CClanWorldBoss> {
	
	private int maxRound;
	
	@Override
	public String getFileName() {
		return "clanworldboss";
	}
	
	public int getNextBoss(int bossId) {
		if(bossId + 1 > maxRound) {
			return this.getAll().get(0).getRound();
		}
		return this.getOrThrow(bossId + 1).getRound();
	}

	@Override
	protected void loadAfterReady() {
		for(CClanWorldBoss boss : this.getAll()) {
			if(boss.getRound() > maxRound) {
				maxRound = boss.getRound();
			}
		}
	}
}
