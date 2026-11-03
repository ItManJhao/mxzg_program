/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.service.base;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.IHeroPlacingPartConfig;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.base.HeroPlacingPart;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @author YY
 *
 */
public abstract class HeroPlacingPartService<T extends HeroPlacingPart> {
	
	@Autowired
	private ThingService thingService;
	
	protected abstract IRepository<T> getRepository();
	
	public List<T> getRoleParts(long rid) {
		return getRepository().list("rid", rid);
	}
	/**
	 * 获取英雄身上所有槽位的信息，包括有装备跟没有装备的槽位
	 * @param rid
	 * @param heroId
	 * @return
	 */
	public List<T> getHeroParts(long rid, long heroId) {
		List<T> list = getRoleParts(rid);
		List<T> result = new ArrayList<>();
		for(T part : list) {
			if(part.getHeroId() == heroId) {
				result.add(part);
			}
		}
		return result;
	}
	
	public T getPlacePart(long rid, long heroId, long partId) {
		List<T> list = getRoleParts(rid);
		for(T part : list) {
            if (part.getHeroId() == heroId && part.getId() == partId) {
				return part;
			}
		}
		return null;
	}
	
	
	public void updateHeroPart(T part) {
		getRepository().update(part);
	}
	public void updateHeroParts(List<T> parts) {
		getRepository().update(parts);
	}
	public void deleteHeroPart(T part) {
		getRepository().remove(part);
	}
	public void deleteHeroParts(List<T> parts) {
		getRepository().remove(parts);
	}
	public void addHeroPart(T part) {
		getRepository().add(part);
	}
	public void addHeroParts(List<T> parts) {
		getRepository().add(parts);
	}
	
	protected abstract T newPart();
	
	protected abstract IHeroPlacingPartConfig getPartConfig(int sysId);
	
	/**
     * 清理英雄身上的装备
     * @param rid
     * @param heroList
     * @param gameEvent
     */
    public List<T> clearHeroPlaingParts(long rid, List<Hero> heroList, GameEvent gameEvent) {
    	//退还的物品列表
    	List<ImmutableThing> partItemList = new ArrayList<>();
    	//需要更新的数据列表
    	List<T> updatePartList = new ArrayList<>();
    	
    	for(Hero hero : heroList) {
    		List<T> partList = this.getHeroParts(hero.getRid(), hero.getId());
            if (partList.isEmpty()) {
            	continue;
            }
            for (T part : partList) {
            	if(part.getSysId() == 0) {
            		continue;
            	}
            	partItemList.add(ImmutableThing.of(part.getSysId(), 1));
            	part.setSysId(0);
            	updatePartList.add(part);
            }
    	}
    	if(!updatePartList.isEmpty()) {
    		this.updateHeroParts(updatePartList);
    	}
    	if(!partItemList.isEmpty()) {
    		//将装备变回道具
    		partItemList = ImmutableThingUtil.mergeThing(partItemList);
            thingService.add(rid, partItemList, gameEvent, NoticeType.SLIENT);
    	}
    	return updatePartList;
    }
    
    /**
     * 替换部位上的装备、宝石等等
     * @param rid
     * @param heroId
     * @param partItemType
     * @param partItemPlace
     * @param gameEvent
     */
    public T partChange(long rid, long heroId, IHeroPlacingPartConfig partConfig, GameEvent gameEvent) {
    	// 从背包中扣减一个装备道具
		ImmutableThing cost = ImmutableThing.of(partConfig.getPartItemType(), 1);
        thingService.cost(rid, cost, gameEvent);

		List<T> partList = this.getHeroParts(rid, heroId);

		T currPart = null;
		for (T part : partList) {
			if (part.getPlace() == partConfig.getPlace()) {
				currPart = part;
				break;
			}
		}
		if (currPart == null) {
			currPart = newPart();
			currPart.setRid(rid);
			currPart.setHeroId(heroId);
			currPart.setPlace(partConfig.getPlace());
			this.addHeroPart(currPart);
		}
		if (currPart.getSysId() != 0) {
			// 将脱下的装备转换回道具
			ImmutableThing partItem = ImmutableThing.of(currPart.getSysId(), 1);
            thingService.add(rid, partItem, GameEvent.EQUIP_CHANGE, NoticeType.SLIENT);
		}
		currPart.setSysId(partConfig.getPartItemType());
		this.updateHeroPart(currPart);
		return currPart;
    }
    
    /**
     * 一键穿戴
     * @param rid
     * @param heroId
     * @param sysIdSet
     * @param gameEvent
     * @return
     */
    public List<T> oneKeyPartChange(long rid, long heroId, Set<Integer> sysIdSet, GameEvent gameEvent) {
    	// 装备部分索引
		Map<Integer, IHeroPlacingPartConfig> partConfigMap = new HashMap<>();
		for (Integer sysId : sysIdSet) {
			IHeroPlacingPartConfig partConfig = getPartConfig(sysId);
			partConfigMap.put(partConfig.getPlace(), partConfig);
		}
		List<ImmutableThing> costList = new ArrayList<>();
		for (IHeroPlacingPartConfig partConfig : partConfigMap.values()) {
			costList.add(ImmutableThing.of(partConfig.getPartItemType(), 1));
		}
		// 先扣道具
        thingService.cost(rid, costList, gameEvent);

		List<T> currParts = this.getHeroParts(rid, heroId);
		Map<Integer, T> currPlaceMap = ListMapUtil.listToMap(currParts, HeroPlacingPart::getPlace);

		List<ImmutableThing> partItems = new ArrayList<>();
		List<T> updateParts = new ArrayList<>();

		for (IHeroPlacingPartConfig partConfig : partConfigMap.values()) {
			T currPart = currPlaceMap.get(partConfig.getPlace());
			if (currPart == null) {
				currPart = newPart();
				currPart.setRid(rid);
				currPart.setHeroId(heroId);
				currPart.setPlace(partConfig.getPlace());
				this.addHeroPart(currPart);
			}
			if (currPart.getSysId() != 0) {
				// 将装备变回道具
				partItems.add(ImmutableThing.of(currPart.getSysId(), 1));
			}
			// 换上新装备
			currPart.setSysId(partConfig.getPartItemType());
			updateParts.add(currPart);
		}
		// 换上新装备
		this.updateHeroParts(updateParts);
		if (ImmutableThingUtil.getAllItemNums(partItems) > 0) {
			// 将原装备变回道具
			thingService.add(rid, partItems, gameEvent, NoticeType.SLIENT);
		}
        // 返回的列表是英雄身上所有槽位的数据
        return updateParts;
    }
}
