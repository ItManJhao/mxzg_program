/**
 *
 */
package com.ayjs.mxzg.gameserver.log.hero.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.log.hero.domain.HeroFightingLog;
import com.ayjs.mxzg.gameserver.log.hero.domain.HeroLog;
import com.ayjs.mxzg.gameserver.log.hero.domain.HeroMagicWandLog;
import com.ayjs.mxzg.gameserver.log.hero.domain.HeroTrainLog;
import com.ayjs.mxzg.gameserver.module.backpack.event.MagicWandAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.MagicWandCostEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroMagicWand;
import com.ayjs.mxzg.gameserver.module.hero.event.AllHeroFightChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroComebackEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroDeleteEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroFightChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroSwitchEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroUpGradeEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroUpLevelEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * @author YY
 *
 */
@Observer
public class HeroLogObserver {

    @Autowired
    private LogService logService;
    @Autowired
    private LogEntityFactory logEntityFactory;

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(HeroGetEvent event) {
        for (Hero hero : event.getHeros()) {
            HeroLog heroLog = createHeroLog(hero, event.getGameEvent(), 1);
            logService.addLog(heroLog);
        }
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(HeroDeleteEvent event) {
        for (Hero hero : event.getHeros()) {
            HeroLog heroLog = createHeroLog(hero, event.getGameEvent(), -1);
            logService.addLog(heroLog);
        }
    }
    
    /**
     * 英雄日志
     * @param hero
     * @param gameEvent
     * @param num 变化的数量
     */
    private HeroLog createHeroLog(Hero hero, GameEvent gameEvent, int num) {
        HeroLog heroLog = logEntityFactory.create(HeroLog.class);
        heroLog.setRid(hero.getRid());
        heroLog.setHeroId(hero.getId());
        heroLog.setLevel(hero.getLevel());
        heroLog.setStar(hero.getStar());
        heroLog.setStage(hero.getStage());
        heroLog.setType(hero.getType());
        heroLog.setEvent(gameEvent.getValue());
        heroLog.setDelta(num);
        heroLog.setTime(TimeDateUtil.getCurrentTimeInt());
        heroLog.setEventDesc(gameEvent.getRemark());
        return heroLog;
    }
    
    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(HeroFightChangeEvent event) {
		Hero hero = event.getHero();
		if(hero.getLevel() <= 100) {
			return;
		}
		HeroFightingLog log = logEntityFactory.create(HeroFightingLog.class);
		log.setRid(hero.getRid());
		log.setHeroId(hero.getId());
		log.setDelta(event.getCurrFighting() - event.getOriFighting());
		log.setCurr(event.getCurrFighting());
		log.setTime(TimeDateUtil.getCurrentTimeInt());
		log.setEvent(event.getGameEvent().getValue());
		log.setEventDesc(event.getGameEvent().getRemark());
		logService.addLog(log);
    }
    
    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(AllHeroFightChangeEvent event) {
    	for(Hero hero : event.getHeros()) {
			if(hero.getLevel() <= 100) {
				continue;
			}
    		HeroFightingLog log = logEntityFactory.create(HeroFightingLog.class);
    		log.setRid(hero.getRid());
    		log.setHeroId(hero.getId());
    		int curr = event.getCurrFightings().get(hero.getId());
    		int ori = event.getOriFightings().get(hero.getId());
    		log.setDelta(curr - ori);
    		log.setCurr(curr);
    		log.setTime(TimeDateUtil.getCurrentTimeInt());
    		log.setEvent(event.getGameEvent().getValue());
    		log.setEventDesc(event.getGameEvent().getRemark());
    		logService.addLog(log);
    	}
    }
    
    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(HeroStarUpEvent event) {
    	HeroTrainLog log = createTrainLog(event.getHero(), event.getGameEvent());
    	log.setOriLevel(event.getHero().getLevel());
    	log.setOriStage(event.getHero().getStage());
    	log.setOriStar(event.getOriStar());
    	log.setRewards(GsonUtils.toJson(event.getRewardList()));
    	log.setCosts(GsonUtils.toJson(event.getCostList()));
    	List<Long> heroIds = new ArrayList<>();
    	for(Hero hero : event.getDeteleHeros()) {
    		heroIds.add(hero.getId());
    	}
    	log.setCostHeros(heroIds);
    	logService.addLog(log);
    }
    
    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(HeroUpLevelEvent event) {
    	HeroTrainLog log = createTrainLog(event.getHero(), event.getGameEvent());
    	log.setOriLevel(event.getOriLevel());
		log.setCurrLevel(event.getHero().getLevel());
    	log.setOriStage(event.getHero().getStage());
    	log.setOriStar(event.getHero().getStar());
    	log.setRewards("");
    	log.setCosts(GsonUtils.toJson(event.getCostList()));
    	log.setCostHeros(Collections.emptyList());
    	logService.addLog(log);
    }
    
    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(HeroUpGradeEvent event) {
    	HeroTrainLog log = createTrainLog(event.getHero(), event.getGameEvent());
    	log.setOriLevel(event.getHero().getLevel());
    	log.setOriStage(event.getOriStage());
    	log.setOriStar(event.getHero().getStar());
    	log.setRewards("");
    	log.setCosts(GsonUtils.toJson(event.getCostList()));
    	log.setCostHeros(Collections.emptyList());
    	logService.addLog(log);
    }

	@Subscribe(async = Subscribe.AsyncType.AsyncLog)
	private void listen(HeroSwitchEvent event) {
		HeroTrainLog log = createTrainLog(event.getHero(), event.getGameEvent());
		log.setCurrLevel(event.getHero().getLevel());
		log.setCurrStar(event.getHero().getStar());
		log.setCurrStage(event.getHero().getStage());
		log.setOriStage(event.getOriType());	// 用原阶数来记录原始的英雄类型，英雄置换阶数保持不变
		log.setRewards("");
		log.setCosts(GsonUtils.toJson(event.getCostList()));
		log.setCostHeros(event.getDeteleHeros());
		logService.addLog(log);
	}

	@Subscribe(async = Subscribe.AsyncType.AsyncLog)
	private void listen(HeroComebackEvent event) {
		HeroTrainLog log = createTrainLog(event.getHero(), event.getGameEvent());
		log.setCurrLevel(event.getHero().getLevel());
		log.setCurrStar(event.getHero().getStar());
		log.setCurrStage(event.getHero().getStage());
		log.setOriLevel(event.getOriLevel());
		log.setOriStar(event.getOriStar());
		log.setRewards(GsonUtils.toJson(event.getRewardList()));
		log.setCosts(GsonUtils.toJson(event.getCostList()));
		logService.addLog(log);
	}

    
    private HeroTrainLog createTrainLog(Hero hero, GameEvent gameEvent) {
    	HeroTrainLog log = logEntityFactory.create(HeroTrainLog.class);
    	log.setRid(hero.getRid());
		log.setHeroId(hero.getId());
		log.setDelta(0);
		log.setCurr(1);
		log.setTime(TimeDateUtil.getCurrentTimeInt());
		log.setEvent(gameEvent.getValue());
		log.setEventDesc(gameEvent.getRemark());
		log.setCurrLevel(hero.getLevel());
		log.setCurrStage(hero.getStage());
		log.setCurrStar(hero.getStar());
    	return log;
    }

	@Subscribe(async = Subscribe.AsyncType.AsyncLog)
	private void magicListen(MagicWandAddEvent event) {
		List<HeroMagicWand> heroMagicWands = event.getAddIds();
		addMagicWandLog(event.getRid(), heroMagicWands, event.getGameEvent().getValue(), event.getGameEvent().getRemark());
	}

	@Subscribe(async = Subscribe.AsyncType.AsyncLog)
	private void magicList(MagicWandCostEvent event) {
		List<HeroMagicWand> heroMagicWands = event.getAddIds();
		addMagicWandLog(event.getRid(), heroMagicWands, event.getGameEvent().getValue(), event.getGameEvent().getRemark());
	}


	private void addMagicWandLog(long rid, List<HeroMagicWand> list, int event, String eventDesc) {
		list.forEach(heroMagicWand -> {
			HeroMagicWandLog log = logEntityFactory.create(HeroMagicWandLog.class);
			log.setRid(rid);
			log.setMagicId(heroMagicWand.getId());
			log.setType(heroMagicWand.getType());
			log.setRare(heroMagicWand.getRare());
			log.setRandomAttr(GJsonUtils.toJson(heroMagicWand.getRandom_attrs()));
			log.setBaseAttr(GJsonUtils.toJson(heroMagicWand.getBase_attrs()));
			log.setTime(TimeDateUtil.getCurrentTimeInt());
			log.setEvent(event);
			log.setEventDesc(eventDesc);
			logService.addLog(log);
		});
	}

}
