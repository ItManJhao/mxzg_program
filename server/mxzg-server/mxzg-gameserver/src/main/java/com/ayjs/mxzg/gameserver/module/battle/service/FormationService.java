/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.battle.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.cache.BattleMatrixSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CBattleMatrix;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.gameserver.module.battle.dao.FormationDao;
import com.ayjs.mxzg.gameserver.module.battle.domain.Formation;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;

/**
 * @author YY
 *
 */
@Observer
@Service
public class FormationService {
	
	@Autowired
	private FormationDao formationDao;
	@Autowired
	private BattleMatrixSysCache battleMatrixSysCache;
	@Autowired
	private HeroService heroService;
	@Autowired
	private HeroTypeSysCache heroTypeSysCache;
	
	public Formation getFormation(long rid) {
        Formation heroFormation = formationDao.get(rid);
        if(heroFormation == null){
            heroFormation = new Formation();
            heroFormation.setRid(rid);
            formationDao.add(heroFormation);
        }
        boolean needUpdate = false;
        if(!heroFormation.isUnlock(1)) {
        	heroFormation.unlock(1);
        	needUpdate = true;
        }
    	if(needUpdate) {
    		formationDao.update(heroFormation);
    	}
        return heroFormation;
    }
	
	@Subscribe
	private void listen(LoginEvent event) {
		checkUnLockFormation(event.getRid());
	}
	
	@Subscribe
	private void listen(HeroStarUpEvent event) {
		checkUnLockFormation(event.getHero().getRid());
	}
	
	private void checkUnLockFormation(long rid) {
		Formation formation = getFormation(rid);
		List<Hero> heroList = heroService.getHeros(rid);
		boolean needUpdate = false;
		for(CBattleMatrix battleMatrix : battleMatrixSysCache.getAll()) {
			if(formation.isUnlock(battleMatrix.getIdx())) {
    			continue;
    		}
			int targetNum = 0;
			boolean unlock = false;
			for(Hero hero : heroList) {
				CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType()); 
				if(battleMatrix.getUnlockCondition().check(hero.getStar(), cHeroType.getElem())) {
					targetNum++;
				}
				if(battleMatrix.getUnlockCondition().isFinish(targetNum)) {
					unlock = true;
					break;
				}
			}
			if(unlock) {
				formation.unlock(battleMatrix.getIdx());
				needUpdate = true;
			}
		}
		if(needUpdate) {
			formationDao.update(formation);
		}
	}
}
