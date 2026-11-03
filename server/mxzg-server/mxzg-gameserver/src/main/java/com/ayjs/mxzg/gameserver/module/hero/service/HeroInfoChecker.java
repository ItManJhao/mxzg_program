package com.ayjs.mxzg.gameserver.module.hero.service;

import com.ayjs.mxzg.battle.command.HeroBaseCommand;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.struct.HeroInfo;
import com.google.common.collect.Multimap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Collection;

@Component
public class HeroInfoChecker implements Lifecycle {

	@Autowired
	private CommandBus commandBus;
	@Autowired
	private HeroTypeSysCache heroTypeSysCache;
	
	@Override
	public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.MEDIUM, Ordinal._8, "HERO_CHECKER");
	}
	
	@Override
	public void start() throws Exception {
		Multimap<Integer, HeroInfo> heroInfos = heroTypeSysCache.getHeroInfos();
		for(Integer heroId : heroInfos.keySet()){
			Collection<HeroInfo> heros = heroInfos.get(heroId);
			HeroBaseCommand command = HeroBaseCommand.createOf(UnitType.MOSTER, heros);
			commandBus.invoke(command);
		}
	}

}
