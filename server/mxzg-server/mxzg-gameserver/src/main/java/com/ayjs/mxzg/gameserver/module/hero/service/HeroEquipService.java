/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.EquipmenttypeSysCache;
import com.ayjs.mxzg.config.struct.IHeroPlacingPartConfig;
import com.ayjs.mxzg.gameserver.module.hero.dao.HeroEquipDao;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroEquip;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroEquipChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroEquipSoulChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.base.HeroPlacingPartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * @author YY
 *
 */
@Observer
@Service
public class HeroEquipService extends HeroPlacingPartService<HeroEquip> {
	@Autowired
	private HeroEquipDao heroEquipDao;
	@Autowired
	private HeroService heroService;
	@Autowired
    private EquipmenttypeSysCache equipmenttypeSysCache;
	
	@Override
	protected IRepository<HeroEquip> getRepository() {
		return heroEquipDao;
	}
	
	/**
	 * 获取英雄身上所有槽位的信息，包括有装备跟没有装备的槽位
	 * @param rid
	 * @param heroId
	 * @return
	 */
	public List<HeroEquip> getHeroEquips(long rid, long heroId) {
		return super.getHeroParts(rid, heroId);
	}
	
	/**
	 * 获取英雄身上有装备的槽位信息
	 * @param rid
	 * @param heroId
	 * @return
	 */
	public List<HeroEquip> getHeroWearingEquips(long rid, long heroId) {
		List<HeroEquip> list = getRoleParts(rid);
		List<HeroEquip> result = new ArrayList<>();
		for(HeroEquip equip : list) {
			if(equip.getHeroId() == heroId && equip.getSysId() > 0) {
				result.add(equip);
			}
		}
		return result;
	}
    
    @Subscribe
    private void listen(HeroEquipChangeEvent event) {
    	heroService.computeStrength(event.getHero(), event.getGameEvent());
    }

	@Subscribe
	private void listen(HeroEquipSoulChangeEvent event) {
		heroService.computeStrength(event.getHero(), event.getGameEvent());
	}

	@Override
	protected HeroEquip newPart() {
		return new HeroEquip();
	}

	@Override
	protected IHeroPlacingPartConfig getPartConfig(int sysId) {
		return equipmenttypeSysCache.getOrThrow(sysId);
	}
}
