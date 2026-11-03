package com.ayjs.mxzg.gameserver.module.hero.receiver;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.config.excel.cache.HeroEvolveLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroSkillSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroStarSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroEvolveLevel;
import com.ayjs.mxzg.config.excel.entity.CHeroSkill;
import com.ayjs.mxzg.gameserver.module.hero.command.CreateBattlerCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHerosCommand;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2020/7/15
 **/
@Service
@Slf4j
public class HeroEvolveReceiver implements Receivers {

    @Autowired
    private HeroEvolveLevelSysCache heroEvolveLevelSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private HeroSkillSysCache heroSkillSysCache;
    @Autowired
    private HeroStarSysCache heroStarSysCache;

    @Invoker(value = Invoker.Priority.LOWEST)
    public void onBattleCommand(QueryHerosCommand command) {
        if (CollectionUtil.isEmpty(command.getHeros())) {
            return;
        }
        long rid = command.getHeros().get(0).getRid();
        doEvolveHeroDo(rid, command.getHeroDos());
    }

    @Invoker(value = Invoker.Priority.LOWEST)
    public void onBattleCommand(QueryBattleCommand command) {
        doEvolveHeroDo(command.getPlayerId(), command.getHeros());
    }

    @Invoker(value = Invoker.Priority.LOWEST)
    public void onBattleCommand(CreateBattlerCommand command) {
        doEvolveHeroDo(command.getPlayerId(), command.getHeroDos());
    }

    @Invoker(value = Invoker.Priority.LOWEST)
    public void onBattleCommand(QueryHeroCommand command) {
        doEvolveHeroDo(command.getHero().getRid(), command.getHeroDo());
    }

    private void doEvolveHeroDo(long rid, List<HeroDo> heroes) {
        if (CollectionUtil.isEmpty(heroes)) {
            return;
        }
        heroes.forEach(hero -> doEvolveHeroDo(rid, hero));
    }

    private void doEvolveHeroDo(long rid, HeroDo heroDo) {
        if (!roleService.isRole(rid)) {
            return;
        }

        if (heroDo.getEvolve().getType() <= 0) {
            return;
        }

        CHeroEvolveLevel config = heroEvolveLevelSysCache.getBy(heroDo.getHeroId(), heroDo.getEvolve().getType(), heroDo.getEvolve().getLevel());
        if (Objects.isNull(config)) {
            log.error("英雄不存在改进化{}-{}-{}", heroDo.getHeroId(), heroDo.getEvolve().getType(), heroDo.getEvolve().getLevel());
            return;
        }

        heroDo.getAttributeInfo().addAllAttribute(config.getAttr());

        if (config.getSkill_id() <= 0) {
            return;
        }
        CHeroSkill heroSkillConfig = heroSkillSysCache.getHeroSkillByOrThrow(config.getSkill_id(), config.getSkill_level());

        //替换技能
        heroDo.getSkillInfo().getActiveSkills().removeIf(skillDo -> skillDo.getSkill().getIdx() == config.getSkill_old_id());
        heroDo.getSkillInfo().getPassiveSkills().removeIf(skillDo -> skillDo.getSkill().getIdx() == config.getSkill_old_id());

        heroDo.getSkillInfo().addSkill(SkillDo.createOf(heroSkillConfig));
    }
}
