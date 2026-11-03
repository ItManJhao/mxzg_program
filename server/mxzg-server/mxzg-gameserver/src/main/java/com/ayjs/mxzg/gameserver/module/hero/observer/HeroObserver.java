/**
 *
 */
package com.ayjs.mxzg.gameserver.module.hero.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.annotation.Subscribe.AsyncType;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.astrolabe.event.AstrolabeChangeEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.MagicWandAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.MagicWandCostEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanSkillUpEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessFashionActiveEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessVipLevelUpEvent;
import com.ayjs.mxzg.gameserver.module.godequip.event.GodEquipImproveEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.FashionActiveEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.FashionExpiresEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.FashionUpLevelEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroAwakenSelectEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroComebackEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroDeleteEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroEvolveEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroFightChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroHexagramEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroLevelReset;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroSwitchEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroTalentChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroUpGradeEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroUpLevelEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.MagicWandChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.RoleFightChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroFashionService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroMagicWandService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.event.RolePeerageChangeEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleVipService;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneChangeEvent;
import com.ayjs.mxzg.protocol.HeroGMsg;
import com.ayjs.mxzg.protocol.HeroGMsg.GResHeroAdd;
import com.ayjs.mxzg.protocol.HeroGMsg.GResHeroDelete;
import com.ayjs.mxzg.protocol.HeroGMsg.GResHeroFighting;
import com.ayjs.mxzg.protocol.HeroGMsg.GResRoleFighting;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * @author YY
 *
 */
@Slf4j
@Observer
public class HeroObserver {


    @Autowired
    private ContextManager contextManager;
    @Autowired
    private HeroService heroService;
    @Autowired
    private RoleVipService roleVipService;
    @Autowired
    private HeroFashionService heroFashionService;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private HeroMagicWandService heroMagicWandService;

    @Subscribe(async = Subscribe.AsyncType.Async)
    private void listen(HeroFightChangeEvent event) {
        GResHeroFighting.Builder builder = GResHeroFighting.newBuilder();
        builder.setHeroId(event.getHero().getId());
        builder.setOriFighting(event.getOriFighting());
        builder.setNewFighting(event.getCurrFighting());
        builder.setAtk(event.getHero().getAtk());
        builder.setDef(event.getHero().getDef());
        builder.setHp(event.getHero().getHp());
        builder.setSpd(event.getHero().getSpd());
        contextManager.write(event.getHero().getRid(), CmdCode._4028, builder.build());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    private void listen(RoleFightChangeEvent event) {
        GResRoleFighting.Builder builder = GResRoleFighting.newBuilder();
        builder.setOriFighting(event.getOriFighting());
        builder.setNewFighting(event.getCurrFighting());
        contextManager.write(event.getRid(), CmdCode._4029, builder.build());
    }

    @Subscribe
    private void listen(HeroStarUpEvent event) {
        heroService.computeStrength(event.getHero(), event.getGameEvent());

        // 检测是否解锁援助
        Role role = roleService.getOrThrow(event.getHero().getRid());
        if(role.isAssistanceUnlock()){
            return;
        }

        if(heroService.assistanceUnlock(role.getId())){
            role.setAssistanceUnlock(true);
            roleService.updateRole(role);
        }
    }

    @Subscribe
    private void listen(HeroUpGradeEvent event) {
        heroService.computeStrength(event.getHero(), event.getGameEvent());
    }

    @Subscribe
    private void listen(HeroUpLevelEvent event) {
        heroService.computeStrength(event.getHero(), event.getGameEvent());
    }

    @Subscribe
    private void listen(RuneChangeEvent event) {
        heroService.computeStrength(event.getHero(), event.getGameEvent());
    }

    @Subscribe
    private void listen(HeroComebackEvent event) {
        heroService.computeStrength(event.getHero(), event.getGameEvent());
    }

    @Subscribe
    private void listen(HeroSwitchEvent event) {
        heroService.computeStrength(event.getHero(), event.getGameEvent());
    }

    @Subscribe
    private void listen(ClanSkillUpEvent event) {
        List<Hero> heroList = new ArrayList<>();
        for (Hero hero : heroService.getHeros(event.getRid())) {
            CHeroType heroType = heroTypeSysCache.getOrThrow(hero.getType());
            if (heroType.getOccupation() == event.getOccupation()) {
                heroList.add(hero);
            }
        }
        heroService.computeStrength(event.getRid(), heroList, event.getGameEvent());
    }

    @Subscribe
    private void listen(FashionUpLevelEvent event) {
        List<Hero> heroList = heroFashionService.getHeroList(event.getRid(), event.getFashionId());
        for (Hero hero : heroList) {
            heroService.computeStrength(hero, event.getGameEvent());
        }
        heroService.computeStrength(event.getRid(), heroList, event.getGameEvent());
    }

    @Subscribe
    private void listen(FashionActiveEvent event) {

        List<Hero> heroList = heroFashionService.getHeroList(event.getRid(), event.getFashionId());

        for (Hero hero : heroList) {
            heroService.computeStrength(hero, event.getGameEvent());
        }

        heroService.computeStrength(event.getRid(), heroList, event.getGameEvent());
    }

    @Subscribe
    private void listen(FashionExpiresEvent event) {

        for (Integer fashionId : event.getFashionList()) {

            List<Hero> heroList = heroFashionService.getHeroList(event.getRid(), fashionId);

            heroService.computeStrength(event.getRid(), heroList, event.getGameEvent());
        }
    }

    @Subscribe
    private void listen(GodEquipImproveEvent event) {
        if (event.getHeroId() > 0) {

            Hero hero = heroService.getHero(event.getRid(), event.getHeroId());
            heroService.computeStrength(hero, event.getGameEvent());
        }
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(HeroGetEvent event) {
        GResHeroAdd.Builder builder = GResHeroAdd.newBuilder();
        for (Hero hero : event.getHeros()) {
            builder.addHeros(heroService.buildHero(hero));
        }
        contextManager.write(event.getRid(), CmdCode._4030, builder.build());
    }


    @Subscribe(async = AsyncType.Async)
    private void listen(HeroDeleteEvent event) {
        GResHeroDelete.Builder builder = GResHeroDelete.newBuilder();
        for (Hero hero : event.getHeros()) {
            builder.addHeros(hero.getId());
        }
        contextManager.write(event.getRid(), CmdCode._4031, builder.build());
    }

    @Subscribe
    private void listen(GoddessVipLevelUpEvent event) {
        HeroGMsg.GResHeroCapacity.Builder builder = HeroGMsg.GResHeroCapacity.newBuilder();
        builder.setHeroCapacity(roleVipService.getHeroCapacity(event.getRid()));
        contextManager.write(event.getRid(), CmdCode._4032, builder.build());
    }

    @Subscribe
    private void listen(HeroTalentChangeEvent event) {
        heroService.computeStrength(event.getHero(), event.getGameEvent());
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(AstrolabeChangeEvent event) {
        List<Hero> heroList = heroService.getHeros(event.getRid());
        heroService.computeStrength(event.getRid(), heroList, GameEvent.GODDESS_BREAK);
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(GoddessFashionActiveEvent event) {
        List<Hero> heroList = heroService.getHeros(event.getRid());
        heroService.computeStrength(event.getRid(), heroList, GameEvent.GODDESS_FASHION);
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(HeroEvolveEvent event) {
        heroService.computeStrength(event.getHero(), GameEvent.HERO_EVOLVE);
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(HeroAwakenSelectEvent event) {
        heroService.computeStrength(event.getHero(), GameEvent.HERO_AWAKEN_COST);
    }

    @Subscribe
    private void listen(RolePeerageChangeEvent event) {
        List<Hero> heroList = heroService.getHeros(event.getRid());
        heroService.computeStrength(event.getRid(), heroList, event.getGameEvent());
    }

    @Subscribe
    private void listen(HeroHexagramEvent event) {
        heroService.computeStrength(event.getHero(), GameEvent.HERO_HEXAGRAM_UPGRADE);
    }

    @Subscribe
    private void listen(MagicWandAddEvent event) {
        heroMagicWandService.sendUpdateBackPack(event.getRid(), event.getAddIds(), 1);
    }

    @Subscribe
    private void listen(MagicWandCostEvent event) {
    }

    @Subscribe
    private void listen(MagicWandChangeEvent event) {
        Hero hero = heroService.getHero(event.getRid(), event.getHeroId());
        if (Objects.isNull(hero)) {
            log.error("hero is null rid:{}, event.getHeroId():{}",
                    event.getRid(), event.getHeroId());
            return;
        }
        heroService.computeStrength(hero, event.getGameEvent());
    }

    @Subscribe
    private void listen(HeroLevelReset event) {
        heroService.computeStrength(event.getHero(), GameEvent.HERO_LEVEL_RESET);
    }
}
