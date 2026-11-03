package com.ayjs.mxzg.gameserver.module.hero.receiver;

import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.HeroSkillSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroSkill;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.config.struct.SkillScript;
import com.ayjs.mxzg.gameserver.module.countryWar.service.CountryWarService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroHexagram;
import com.ayjs.mxzg.config.excel.cache.HeroHexagramSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroHexagram;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Objects;

/**
 * 英雄六芒星接收者
 *
 * @Author CJX
 * @Date 2021/5/22
 */

@Component
@Slf4j
public class HeroHexagramReceivers implements Receivers {
    @Autowired
    private HeroHexagramSysCache heroHexagramSysCache;
    @Autowired
    private CountryWarService countryWarService;
    @Autowired
    private HeroSkillSysCache heroSkillSysCache;
    @Autowired
    private HeroService heroService;

    @Invoker
    public void onQueryHeroCommand(QueryHeroCommand command) {
        setAttribute(command.getHero(), command.getHeroDo());
    }

    /**
     * 计算英雄六芒星属性
     *
     * @param hero
     * @param heroDo
     */
    private void setAttribute(Hero hero, HeroDo heroDo) {
        try {
            List<HeroHexagram> hexagram = hero.getHexagram();
            for (HeroHexagram heroHexagram : hexagram) {
                int type = heroHexagram.getType();
                int level = heroHexagram.getLevel();
                CHeroHexagram config = heroHexagramSysCache.getHeroHexagram(type, level);
                ImmutableMap<AttributeType, Long> attr = config.getAttr();
                heroDo.getAttributeInfo().addAllAttribute(attr);
            }
        } catch (Exception e) {
            log.error(String.format("计算六芒星异常;英雄ID{%s}; {%s}", hero.getId(), e));
        }
    }

    @Invoker
    public void onQueryBattleHeroCommand(QueryBattleCommand command) {
        List<HeroDo> heroDos = command.getHeros();
        for (HeroDo heroDo : heroDos) {
            Hero hero = heroService.getHero(command.getPlayerId(), heroDo.getId());
            if (Objects.nonNull(hero)) {
                setAttribute(hero, heroDo);
            }
        }
//
//        if (command.getLineUpType() != LineUpType.COUNTRY_WAR) {
//            return;
//        }
        //判断开启的国战类型
        int openType = countryWarService.getOpenType();
        if (openType == 0) {
            return;
        }

        for (HeroDo heroDo : heroDos) {
            Hero hero = heroService.getHero(command.getPlayerId(), heroDo.getId());
            if (Objects.nonNull(hero)) {
                addHexagramSkill(hero, heroDo);
            }
        }
    }

    /**
     * 添加六芒星技能
     *
     * @param hero
     * @param heroDo
     */
    private void addHexagramSkill(Hero hero, HeroDo heroDo) {
        try {
            int openType = countryWarService.getOpenType();
            List<HeroHexagram> hexagram = hero.getHexagram();
            for (HeroHexagram heroHexagram : hexagram) {
                int type = heroHexagram.getType();
                //判断当前开启的国战
                if (type != openType) {
                    continue;
                }
                int level = heroHexagram.getLevel();
                CHeroHexagram config = heroHexagramSysCache.getHeroHexagram(type, level);
                ImmutableList<SkillScript> skill = config.getSkill();
                for (SkillScript skillScript : skill) {
                    if (skillScript.getLv() == 0) {
                        continue;
                    }
                    CHeroSkill cHeroSkill = heroSkillSysCache.getHeroSkillByOrThrow(skillScript.getId(), skillScript.getLv());
                    SkillDo skillDo = SkillDo.createOf(cHeroSkill);
                    heroDo.getSkillInfo().addSkill(skillDo);
                }
                ImmutableMap<AttributeType, Long> attr = config.getSkill_attr();
                heroDo.getAttributeInfo().addAllAttribute(attr);
                break;
            }

        } catch (Exception e) {
            log.error("添加六芒星技能异常;英雄ID{%s}; {%s}", hero.getId(), e);
        }
    }
}
