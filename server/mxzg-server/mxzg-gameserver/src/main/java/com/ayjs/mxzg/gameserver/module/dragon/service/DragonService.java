/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.dragon.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.DragonIdentifySysCache;
import com.ayjs.mxzg.config.excel.cache.DragonLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.DragonRelicSysCache;
import com.ayjs.mxzg.config.excel.cache.DragonRemainsSysCache;
import com.ayjs.mxzg.config.excel.entity.CDragonIdentify;
import com.ayjs.mxzg.config.excel.entity.CDragonLevel;
import com.ayjs.mxzg.config.excel.entity.CDragonRelic;
import com.ayjs.mxzg.config.excel.entity.CDragonRemains;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.dragon.dao.DragonDao;
import com.ayjs.mxzg.gameserver.module.dragon.domain.Dragon;
import com.ayjs.mxzg.gameserver.module.dragon.event.DragonChangeEvent;
import com.ayjs.mxzg.gameserver.module.dragon.event.DragonUpStarEvent;
import com.ayjs.mxzg.gameserver.module.dragon.struct.DragonIdentity;
import com.ayjs.mxzg.gameserver.module.dragon.struct.DragonSlot;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.protocol.DragonGMsg.GResDragonFinishNotice;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

/**
 * @author YY
 *
 */
@Observer
@Service
public class DragonService {
	@Autowired
	private DragonDao dragonDao;
	@Autowired
	private HeroService heroService;
	@Autowired
	private DragonLevelSysCache dragonLevelSysCache;
	@Autowired
	private DragonRelicSysCache dragonRelicSysCache;
	@Autowired
	private ContextManager contextManager;
	@Autowired
	private DragonRemainsSysCache dragonRemainsSysCache;
	@Autowired
	private DragonIdentifySysCache dragonIdentifySysCache;
	
	public Dragon getDragon(long rid) {
		Dragon dragon = dragonDao.get(rid);
		if(dragon == null) {
			dragon = new Dragon();
			dragon.setRid(rid);
			dragon.setIdentifyLevel(1);
			dragon.setAttrLevel(1);
			dragon.setIdentitys(new HashMap<>());
			//添加鉴定槽位
			for(int i = 1; i <= 2; i++) {
				DragonIdentity identity = new DragonIdentity();
				identity.setType(i);
				dragon.getIdentitys().put(identity.getType(), identity);
			}
			dragon.setManuals(new HashSet<>());
			dragon.setSlots(new HashMap<>());
			dragon.setIdentityNum(new HashMap<>());
			DragonSlot slot = new DragonSlot();
			slot.setId(1);
			dragon.getSlots().put(slot.getId(), slot);
			dragonDao.add(dragon);
		}
		return dragon;
	}
	
	public void update(Dragon dragon) {
		dragonDao.update(dragon);
	}
	
	@Subscribe
	private void listen(DragonUpStarEvent event) {
		heroService.computeStrengthBiggerThenFiveStar(event.getRid(), event.getGameEvent());
	}
	
	@Subscribe
	private void listen(DragonChangeEvent event) {
		heroService.computeStrengthBiggerThenFiveStar(event.getRid(), event.getGameEvent());
	}
	
	public void addAttr(long rid, List<Hero> heros) {
		Dragon dragon = getDragon(rid);
		
		CDragonLevel cDragonLevel = dragonLevelSysCache.getOrThrow(dragon.getAttrLevel());
		cDragonLevel.getAbility();//添加属性
		
		//
		Map<AttributeType, Long> dragonAttrMap = new HashMap<>();
		for(DragonSlot slot : dragon.getSlots().values()) {
			if(slot.getSysId() == 0) {
				continue;
			}
			CDragonRelic cDragonRelic = dragonRelicSysCache.getOrThrow(slot.getSysId());
			for(Entry<AttributeType, Long> entry : cDragonRelic.getAbility().entrySet()) {
				long attr = dragonAttrMap.getOrDefault(entry.getKey(), 0L);
				dragonAttrMap.put(entry.getKey(), attr + entry.getValue());
			}
			cDragonRelic.getSkill();//添加技能
		}
		for(Hero hero : heros) {
			//给每个英雄添加属性
//			dragonAttrMap
		}
	}
	
	public void runForCheck() {
		for(PlayerContext playerContext : contextManager.getAllOnline()) {
			if(playerContext.getId() > 0 && hasIdentityFinish(playerContext.getId())) {
				//通知玩家鉴定完成
				playerContext.write(CmdCode._59014, GResDragonFinishNotice.getDefaultInstance());
			}
		}
	}
	
	public boolean hasIdentityFinish(long rid) {
		Dragon dragon = getDragon(rid);
		boolean hasFinish = false;
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		for(DragonIdentity identity : dragon.getIdentitys().values()) {
			if(identity.getLevel() <= 0) {
				continue;
			}
			CDragonRemains cDragonRemains = dragonRemainsSysCache.getIdentityRemains(identity.getLevel());
			if(cDragonRemains == null) {
				continue;
			}
			CDragonIdentify cDragonIdentify = dragonIdentifySysCache.getOrThrow(dragon.getIdentifyLevel());
			int currentPoint = (nowTime - identity.getStartTime()) * cDragonIdentify.getSpeed();
			//最终进度=当前进度+加速进度
			int finalPoint = currentPoint + identity.getSpeedAdd();
			if(cDragonRemains.getPoint() > finalPoint) {
				continue;
			}
			hasFinish = true;
			break;
		}
		return hasFinish;
	}
	
}
