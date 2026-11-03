/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.JewelSetTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.JewelTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CJewelSetType;
import com.ayjs.mxzg.config.excel.entity.CJewelType;
import com.ayjs.mxzg.config.struct.IHeroPlacingPartConfig;
import com.ayjs.mxzg.gameserver.module.hero.dao.HeroJewelDao;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroJewel;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroJewelChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.base.HeroPlacingPartService;

/**
 * @author YY
 *
 */
@Observer
@Service
public class HeroJewelService extends HeroPlacingPartService<HeroJewel> {

	@Autowired
	private HeroJewelDao heroJewelDao;
	@Autowired
	private HeroService heroService;
	@Autowired
	private JewelTypeSysCache jewelTypeSysCache;
	@Autowired
	private JewelSetTypeSysCache jewelSetTypeSysCache;
	
	@Override
	protected IRepository<HeroJewel> getRepository() {
		return heroJewelDao;
	}
    
    @Subscribe
    private void listen(HeroJewelChangeEvent event) {
    	heroService.computeStrength(event.getHero(), event.getGameEvent());
    }

	@Override
	protected HeroJewel newPart() {
		return new HeroJewel();
	}

	@Override
	protected IHeroPlacingPartConfig getPartConfig(int sysId) {
		return jewelTypeSysCache.getOrThrow(sysId);
	}
	
	/**
	 * 获取宝石套装属性，返回null则没有套装数据
	 * @param rid
	 * @param heroId
	 * @return
	 */
	@Deprecated
	public CJewelSetType getHeroJewelSet(long rid, long heroId) {
		List<HeroJewel> jewelList = this.getHeroParts(rid, heroId);
		return getHeroJewelSet(rid, jewelList);
	}
	
	public CJewelSetType getHeroJewelSet(long rid, List<HeroJewel> jewelList) {
		int maxStar = Integer.MAX_VALUE;
		for(HeroJewel jewel : jewelList) {
			if(jewel.getSysId() <= 0) {
				return null;
			}
			CJewelType cJewelType = jewelTypeSysCache.getOrThrow(jewel.getSysId());
			if(cJewelType.getStar() < maxStar) {
				maxStar = cJewelType.getStar();
			}
		}
		return jewelSetTypeSysCache.getJewelSetType(maxStar);
	}
}
