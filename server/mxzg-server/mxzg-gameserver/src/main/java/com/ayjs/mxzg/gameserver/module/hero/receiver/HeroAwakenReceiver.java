package com.ayjs.mxzg.gameserver.module.hero.receiver;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.config.excel.cache.HeroAwakenSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroSkillSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroStarSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroAwaken;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.gameserver.module.hero.command.CreateBattlerCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHerosCommand;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * 移动到HeroReceiver里面去了
 *
 * @Author: CWJ
 * @Date: 2020/7/15
 **/
@Slf4j
@Deprecated
public class HeroAwakenReceiver implements Receivers {

    @Autowired
    private HeroAwakenSysCache heroAwakenSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private HeroSkillSysCache heroSkillSysCache;
    @Autowired
    private HeroStarSysCache heroStarSysCache;
    @Autowired
    private HeroService heroService;

    @Invoker(value = Invoker.Priority.LOWEST)
    public void onBattleCommand(QueryHerosCommand command) {
        if (CollectionUtil.isEmpty(command.getHeros())) {
            return;
        }
        long rid = command.getHeros().get(0).getRid();
        addAwakenAttr(rid, command.getHeroDos());
    }

    @Invoker(value = Invoker.Priority.LOWEST)
    public void onBattleCommand(QueryBattleCommand command) {
        addAwakenAttr(command.getPlayerId(), command.getHeros());
    }

    @Invoker(value = Invoker.Priority.LOWEST)
    public void onBattleCommand(CreateBattlerCommand command) {
        addAwakenAttr(command.getPlayerId(), command.getHeroDos());
    }

    @Invoker(value = Invoker.Priority.LOWEST)
    public void onBattleCommand(QueryHeroCommand command) {
        addAwakenAttr(command.getHero().getRid(), command.getHeroDo());
    }

    private void addAwakenAttr(long rid, List<HeroDo> heroes) {
        if (CollectionUtil.isEmpty(heroes)) {
            return;
        }
        heroes.forEach(hero -> addAwakenAttr(rid, hero));
    }

    private void addAwakenAttr(long rid, HeroDo heroDo) {
        if (!roleService.isRole(rid)) {
            return;
        }
        Hero hero = heroService.getHero(rid, heroDo.getId());

        if (hero.getAwaken().getBaseIndex().size() == 0) {
            return;
        }
        CHeroAwaken config = heroAwakenSysCache.getOrThrow(heroDo.getHeroId());
        if (Objects.isNull(config)) {
            return;
        }
        Map<AttributeType, Long> attributes = new HashMap<>();
        hero.getAwaken().getBaseIndex().forEach(index -> {
            AttributeKind attr = config.getBase_attr().get(index);
            attributes.put(AttributeType.valueOf(attr.getType()), attr.getValue());
        });
        hero.getAwaken().getSpecialIndex().forEach(index -> {
            AttributeKind attr = config.getSpecial_attr().get(index);
            attributes.put(AttributeType.valueOf(attr.getType()), attr.getValue());
        });
        heroDo.getAttributeInfo().addAllAttribute(attributes);
    }
}
