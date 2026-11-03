/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.prophetSummon.service;

import com.ayjs.mxzg.gameserver.module.prophetSummon.dao.HeroChangeDao;
import com.ayjs.mxzg.gameserver.module.prophetSummon.domain.HeroChange;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author YY
 *
 */
@Service
public class HeroChangeService {
	@Autowired
	private HeroChangeDao heroChangeDao;
	
	public HeroChange getHeroChange(long rid) {
		HeroChange heroChange = heroChangeDao.get(rid);
		if(heroChange == null) {
			heroChange = new HeroChange();
			heroChange.setRid(rid);
			heroChangeDao.add(heroChange);
		}
		return heroChange;
	}
	
	public void updateHeroChange(HeroChange heroChange) {
		heroChangeDao.update(heroChange);
	}
}
