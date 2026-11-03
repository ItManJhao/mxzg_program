package com.ayjs.mxzg.gameserver.module.rainbow.receiver;

import java.util.List;
import java.util.Objects;

import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.config.excel.cache.RainbowSysCache;
import com.ayjs.mxzg.config.excel.entity.CRainbow;
import com.ayjs.mxzg.gameserver.module.hero.command.CreateBattlerCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.rainbow.domain.RainbowSlot;
import com.ayjs.mxzg.gameserver.module.rainbow.service.RainbowService;
import com.google.common.collect.Lists;

@Component
public class RainbowReceiver implements Receivers {

    @Autowired
    private RainbowService rainbowService;
    @Autowired
    private RainbowSysCache rainbowSysCache;

    @Invoker
    public void onQueryBattleHeroCommand(QueryBattleCommand command) {
        setAttribute(command.getPlayerId(), command.getHeros());
    }

    @Invoker
    public void onCreateBattlerCommand(CreateBattlerCommand command) {
        setAttribute(command.getPlayerId(), command.getHeroDos());
    }

    @Invoker
    public void onQueryHeroCommand(QueryHeroCommand command) {
        Hero hero = command.getHero();
        if(Objects.nonNull(hero)) {
            setAttribute(hero.getRid(), Lists.newArrayList(command.getHeroDo()));
        }
    }

    /**
     * 设置属性
     * @param rid
     * @param heros
     */
    public void setAttribute(long rid, List<HeroDo> heros) {
        RainbowSlot rainbowSlot = rainbowService.getRoleSlot(rid);
        if(rainbowSlot != null) {
            CRainbow rainbow = rainbowSysCache.getOrThrow(rainbowSlot.getType());
            for (HeroDo hero : heros) {
                hero.getAttributeInfo().addAllAttribute(rainbow.getAttr());
            }
        }
    }

}
