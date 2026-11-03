package com.ayjs.mxzg.gameserver.module.promotionNew.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.cache.AdventurerewardSysCache;
import com.ayjs.mxzg.config.excel.cache.TavernSysCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionTrafficPermit;
import com.ayjs.mxzg.config.excel.entity.CTavern;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion030MysteryBox;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.achievement.event.DailyTaskRewardEvent;
import com.ayjs.mxzg.gameserver.module.adven.event.AdvenBoxEvent;
import com.ayjs.mxzg.gameserver.module.adven.event.AdvenPassEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.*;
import com.ayjs.mxzg.gameserver.module.blessingPool.constant.BlessingPoolType;
import com.ayjs.mxzg.gameserver.module.blessingPool.event.BlessingPoolDoneEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDonateEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDungeonChallengeEvent;
import com.ayjs.mxzg.gameserver.module.dailydungeon.event.JoinDailyDungeonEvent;
import com.ayjs.mxzg.gameserver.module.dungeon.event.DungeonBattleEndEvent;
import com.ayjs.mxzg.gameserver.module.dungeon.event.DungeonUseAgenitaEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessLevelUpOperatorEvent;
import com.ayjs.mxzg.gameserver.module.friend.event.FriendGiveEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroSummonEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.SummonType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion053TrafficPermit;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.SpeedFightEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion053TrafficPermitService;
import com.ayjs.mxzg.gameserver.module.prophetSummon.event.ProphetSummonEvent;
import com.ayjs.mxzg.gameserver.module.pvp.event.PvpEndEvent;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.event.ZeroTimeEvent;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneCombineEvent;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneWashEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskRewardEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskStartEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerChallengeEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerPassEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerSweepEvent;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

/**
 * 活动通行证任务监听
 *
 * @author hyx
 */
@Observer
@Slf4j
public class Promotion053TrafficPermitObserver {

    @Autowired
    private Promotion053TrafficPermitService promotion053TrafficPermitService;
    @Autowired
    private TavernSysCache tavernSysCache;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private AdventurerewardSysCache adventurerewardSysCache;

    @Subscribe
    private void listen(ZeroTimeEvent event) {

        Promotion053TrafficPermit promotion053TrafficPermit = promotion053TrafficPermitService.getPromotionOrRefresh(event.getRid());
        promotion053TrafficPermitService.sendPromotionInfo(promotion053TrafficPermit);

        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.LOGIN);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);
        });
    }

    @Subscribe
    private void listen(LoginEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.LOGIN);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);
        });
    }

    @Subscribe
    private void listen(MakeEquipEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.COMBINE_EQUIP);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, event.getTimes(), 0);
        });
    }

    @Subscribe
    private void listen(TowerChallengeEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.TOWER_CHALLENGE);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);
        });
    }

    @Subscribe
    private void listen(TowerSweepEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.TOWER_CHALLENGE);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);
        });
    }

    @Subscribe
    private void listen(RuneCombineEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.COMBINE_RUNE);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);
        });
    }

    @Subscribe
    private void listen(BlessingPoolDoneEvent event) {
        if (event.getType() == BlessingPoolType.Normal) {
            List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.WISH);
            list.forEach(config -> {
                promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, event.getCount(), 0);
            });
        }
    }

    @Subscribe
    private void listen(DailyTaskRewardEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.DAY_ACTIVE);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, event.getPoint(), 0);
        });
    }

    @Subscribe
    private void listen(TavernTaskStartEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.ACCEPT_TAVERN_TASK);
        list.forEach(config -> {
            if (TargetType.checkStruct(config.getMission(), tavernSysCache.getOrThrow(event.getTaskId()).getStar(), 0))
                promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);
        });
    }

    @Subscribe
    private void listen(HeroStarUpEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.COMBINE_HERO);
        list.forEach(config -> {
            if (TargetType.checkStruct(config.getMission(), event.getHero().getStar(), 0))
                promotion053TrafficPermitService.updatePromotionTask(event.getHero().getRid(), config, 1, 0);
        });

    }

    @Subscribe
    private void listen(HeroGetEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.GET_HERO);
        list.forEach(config -> {
            event.getHeros().forEach(hero -> {
                if (TargetType.checkStruct(config.getMission(), hero.getStar(), 0))
                    promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);
            });
        });
    }

    @Subscribe
    private void listen(GemAddEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.GEM_GAIN);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, (int) event.getAddCount(), 0);
        });
    }

    @Subscribe
    private void listen(GoldCostEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.GOLD_CONSUME);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, (int) event.getCostCount(), 0);
        });
    }

    @Subscribe
    private void listen(HeroSummonEvent event) {
        if (event.getType() == SummonType.HIGH) {
            List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.SUMMON);
            list.forEach(config -> {
                promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, event.getSummonCount(), 0);
            });
        }
    }

    @Subscribe
    private void listen(SpeedFightEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.QUICK_BATTLE);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);
        });
    }

    @Subscribe
    private void listen(GoddessLevelUpOperatorEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.GODDESS_LEVEL_UP);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);
        });
    }

    @Subscribe
    private void listen(ClanDungeonChallengeEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.CHALLENGE_CLAN_DUNGEON);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);
        });
    }

    @Subscribe
    private void listen(RuneWashEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.WASH_RUNE);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);
        });
    }

    @Subscribe
    private void listen(AdvenPassEvent event) {
        if (event.isWin()) {
            List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.ADVEN_LEVEL);
            list.forEach(config -> {
                promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, event.getBattleMissionId(), 1);
            });
        }
    }

    @Subscribe
    private void listen(PvpEndEvent event) {
        if (event.isWin()) {
            List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.ARENA_CHALLENGE_WIN);
            list.forEach(config -> {
                promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);

                if (config.getMission().getCondition() > 0) {
                    HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(event.getRid(), LineUpType.MAIN);
                    heroLineUp.getFormationMap().forEach((k, v) -> {
                        Hero hero = heroService.getHero(event.getRid(), k);
                        if (TargetType.checkStruct(config.getMission(), hero.getType(), 0))
                            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);
                    });
                }

            });


        }
    }

    @Subscribe
    private void listen(GemCostEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.GEM_CONSUME);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, (int) event.getCostCount(), 0);
        });
    }

    @Subscribe
    private void listen(ClanDonateEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.CLAN_DONATE);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);
        });
    }

    @Subscribe
    private void listen(FriendGiveEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.FRIEND_GIFT);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, event.getGiveCount(), 0);
        });
    }

    @Subscribe
    private void listen(ProphetSummonEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.PROPHECY);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, event.getNum(), 0);
        });
    }

    @Subscribe
    private void listen(HeroExpCostEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.HERO_EXP_CONSUME);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, (int) event.getCostCount(), 0);
        });
    }

    @Subscribe
    private void listen(JoinDailyDungeonEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.DAILY_DUNGEON_CHALLENGE);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);
        });

        list = promotion053TrafficPermitService.getTargetTaskList(TargetType.DUNGEON_CHALLENGE);
        list.forEach(config -> {
            if (TargetType.checkStruct(config.getMission(), event.getDailyDungeonType().getType(), 0))
                promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);
        });
    }

    @Subscribe
    private void listen(DungeonBattleEndEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.SHELTER_KILL);
        list.forEach(config -> {
            if (TargetType.checkStruct(config.getMission(), event.getHeroType(), 0))
                promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);
        });
    }

    @Subscribe
    private void listen(DungeonUseAgenitaEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.SHELTER_MEDICINE);
        list.forEach(config -> {
            if (TargetType.checkStruct(config.getMission(), event.getType(), 0))
                promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);
        });

        list = promotion053TrafficPermitService.getTargetTaskList(TargetType.SHELTER_KILL);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);
        });
    }

    @Subscribe
    private void listen(TavernTaskRewardEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.COMPLETE_TAVERN_TASK);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, event.getTaskIds().size(), 0);
        });
    }

    @Subscribe
    private void listen(AdvenBoxEvent event) {
        List<CPromotionTrafficPermit> list = promotion053TrafficPermitService.getTargetTaskList(TargetType.ADVEN_GEM_BOX);
        list.forEach(config -> {
            promotion053TrafficPermitService.updatePromotionTask(event.getRid(), config, 1, 0);
        });
    }

}
