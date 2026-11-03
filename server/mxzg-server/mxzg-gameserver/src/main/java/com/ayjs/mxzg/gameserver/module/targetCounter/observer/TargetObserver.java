package com.ayjs.mxzg.gameserver.module.targetCounter.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.ItemSysCache;
import com.ayjs.mxzg.config.excel.cache.TavernSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.excel.entity.CItem;
import com.ayjs.mxzg.config.excel.entity.CTavern;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.module.achievement.event.DailyTaskRewardEvent;
import com.ayjs.mxzg.gameserver.module.adven.event.AdvenBoxEvent;
import com.ayjs.mxzg.gameserver.module.adven.event.AdvenPassEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.GemAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.GemCostEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.GoldCostEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.HeroExpCostEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.ItemAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.MakeEquipEvent;
import com.ayjs.mxzg.gameserver.module.battle.event.ChapterPassEvent;
import com.ayjs.mxzg.gameserver.module.blessingPool.event.BlessingPoolDoneEvent;
import com.ayjs.mxzg.gameserver.module.buygold.event.BuyGoldEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanChangeEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDonateEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDungeonChallengeEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDungeonKillEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanSkillUpEvent;
import com.ayjs.mxzg.gameserver.module.clanworldboss.event.ClanWorldBossBattleEvent;
import com.ayjs.mxzg.gameserver.module.clergy.event.ClergyLevelEvent;
import com.ayjs.mxzg.gameserver.module.dailydungeon.event.JoinDailyDungeonEvent;
import com.ayjs.mxzg.gameserver.module.dreamland.event.DreamlandBattleEvent;
import com.ayjs.mxzg.gameserver.module.dreamland.event.DreamlandMaxLvEvent;
import com.ayjs.mxzg.gameserver.module.dungeon.event.DungeonBattleEndEvent;
import com.ayjs.mxzg.gameserver.module.dungeon.event.DungeonUseAgenitaEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessLevelUpEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessLevelUpOperatorEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessUnlockEvent;
import com.ayjs.mxzg.gameserver.module.friend.event.FriendAddEvent;
import com.ayjs.mxzg.gameserver.module.friend.event.FriendGiveEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroSummonEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroUpLevelEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.SpeedFightEvent;
import com.ayjs.mxzg.gameserver.module.prophetSummon.event.ProphetSummonEvent;
import com.ayjs.mxzg.gameserver.module.pvp.event.PvpEndEvent;
import com.ayjs.mxzg.gameserver.module.rank.event.ArenaRankChangeEvent;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.event.MaxFightingEvent;
import com.ayjs.mxzg.gameserver.module.role.event.RoleLvUpEvent;
import com.ayjs.mxzg.gameserver.module.role.event.ZeroTimeEvent;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneCombineEvent;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneWashEvent;
import com.ayjs.mxzg.gameserver.module.shop.event.ShopBuyEvent;
import com.ayjs.mxzg.gameserver.module.stagematch.rim.event.StageTokenSettleEvent;
import com.ayjs.mxzg.gameserver.module.targetCounter.event.RoleTriggerTargetEvent;
import com.ayjs.mxzg.gameserver.module.targetCounter.service.TargetCounterService;
import com.ayjs.mxzg.gameserver.module.task.event.AlterHeroEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskRefreshEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskRewardEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskStartEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerPassEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerSweepEvent;
import com.google.common.collect.Maps;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.HashMap;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2019/11/13
 **/
@Observer
@Controller
public class TargetObserver {

    @Autowired
    private EventBus eventBus;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private TargetCounterService targetCounterService;
    @Autowired
    private TavernSysCache tavernSysCache;
    @Autowired
    private ItemSysCache itemSysCache;
    @Autowired
    private ContextManager contextManager;


    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(RoleLvUpEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.ADVENTURE_LEVEL), event.getNewLv(), RoleTriggerTargetEvent.MethodName.SET));

    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(FriendGiveEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.FRIEND_GIFT), event.getGiveCount(),
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(FriendAddEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.FRIEND_NUM), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ClanChangeEvent event) {
        long rid = event.getRid();
        if (event.getNewClanId() > 0) {
            eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.JOIN_CLAN), 1,
                    RoleTriggerTargetEvent.MethodName.ADD));
        }
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(AdvenPassEvent event) {
        if (event.isWin()) {
            long rid = event.getRid();
            eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.ADVEN_LEVEL), event.getBattleMissionId(),
                    RoleTriggerTargetEvent.MethodName.SET));

            eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.PASS_ADVEN), 1,
                    RoleTriggerTargetEvent.MethodName.ADD));

        }
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(HeroStarUpEvent event) {
        long rid = event.getHero().getRid();
        CHeroType cHeroType = heroTypeSysCache.getOrThrow(event.getHero().getType());

        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.COMBINE_HERO, event.getHero().getStar()), 1,
                RoleTriggerTargetEvent.MethodName.ADD));

        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.GET_HERO, event.getHero().getStar(), cHeroType.getElem()), 1,
                RoleTriggerTargetEvent.MethodName.ADD));

        TargetStruct hadHighTarget = TargetStruct.of(TargetType.HAD_HIGH_LEVEL_HERO, event.getHero().getLevel());
        eventBus.post(RoleTriggerTargetEvent.of(rid, hadHighTarget, targetCounterService.calcCount(rid, hadHighTarget),
                RoleTriggerTargetEvent.MethodName.SET));

        TargetStruct hadStarTarget = TargetStruct.of(TargetType.HAD_HIGH_STAR_HERO, event.getHero().getStar());
        eventBus.post(RoleTriggerTargetEvent.of(rid, hadStarTarget, targetCounterService.calcCount(rid, hadStarTarget),
                RoleTriggerTargetEvent.MethodName.SET));


    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(HeroGetEvent event) {
        long rid = event.getRid();
        //英雄置换不算
        if (event.getGameEvent() == GameEvent.PROPHECY_HERO_EXCHANGE) {
            return;
        }
        event.getHeros().forEach(hero -> {
            CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());

            eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.GET_HERO, hero.getStar(), cHeroType.getElem()), 1,
                    RoleTriggerTargetEvent.MethodName.ADD));

            TargetStruct hadHighTarget = TargetStruct.of(TargetType.HAD_HIGH_LEVEL_HERO, hero.getLevel());
            eventBus.post(RoleTriggerTargetEvent.of(rid, hadHighTarget, targetCounterService.calcCount(rid, hadHighTarget),
                    RoleTriggerTargetEvent.MethodName.SET));

            TargetStruct hadStarTarget = TargetStruct.of(TargetType.HAD_HIGH_STAR_HERO, hero.getStar());
            eventBus.post(RoleTriggerTargetEvent.of(rid, hadStarTarget, targetCounterService.calcCount(rid, hadStarTarget),
                    RoleTriggerTargetEvent.MethodName.SET));
        });
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(HeroUpLevelEvent event) {
        long rid = event.getHero().getRid();
        TargetStruct hadHighTarget = TargetStruct.of(TargetType.HAD_HIGH_LEVEL_HERO, event.getHero().getLevel());
        eventBus.post(RoleTriggerTargetEvent.of(rid, hadHighTarget, targetCounterService.calcCount(rid, hadHighTarget),
                RoleTriggerTargetEvent.MethodName.SET));
    }


    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(RuneCombineEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.COMBINE_RUNE), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(RuneWashEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.WASH_RUNE), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(JoinDailyDungeonEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.DAILY_DUNGEON_CHALLENGE), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.DUNGEON_CHALLENGE, event.getDailyDungeonType().getType()), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ProphetSummonEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.PROPHECY), event.getNum(),
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(TavernTaskStartEvent event) {
        long rid = event.getRid();

        CTavern cTavern = tavernSysCache.getOrThrow(event.getTaskId());
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.ACCEPT_TAVERN_TASK, cTavern.getStar()), 1,
                RoleTriggerTargetEvent.MethodName.ADD));

        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.ACCEPT_TAVERN_TASK_STAR_HIGH, cTavern.getStar()), 1,
                RoleTriggerTargetEvent.MethodName.ADD));

    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(AlterHeroEvent event) {
        long rid = event.getRid();

        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.SACRIFICE), event.getCount(),
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ClanDungeonChallengeEvent event) {
        long rid = event.getRid();

        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.CHALLENGE_CLAN_DUNGEON), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ClanDungeonKillEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.BEAT_CLAN_DUNGEON), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(MaxFightingEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.ROLE_MAX_FIGHTING), event.getMaxFighting(),
                RoleTriggerTargetEvent.MethodName.SET));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ArenaRankChangeEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.ARENA_MAX_RANK), event.getRank().getNewRank(),
                RoleTriggerTargetEvent.MethodName.SET));
    }


    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ShopBuyEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.SHOP_BUY, event.getShopType().getValue()), event.getBuyTimes(),
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    /***
     * 添加道具
     * @param event
     */
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ItemAddEvent event) {
        if (event.getGameEvent() == GameEvent.EQUIP_ALL_OFF || event.getGameEvent() == GameEvent.EQUIP_OFF ||
                event.getGameEvent() == GameEvent.EQUIP_ALL_WEAR || event.getGameEvent() == GameEvent.EQUIP_CHANGE)
            return;

        long rid = event.getRid();
        Map<Integer, Long> map = new HashMap<>();
        event.getAddValue().forEach(thing -> {
            CItem config = itemSysCache.getOrThrow(thing.getItem_type());
            if (config.getPlace() == 1) {//装备
                map.put(config.getRare_mark(), map.getOrDefault(config.getRare_mark(), 0l) + thing.getItem_num());
            }
        });
        map.forEach((key, value) -> {
            eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.GET_EQUIP_QUALITY, key), value,
                    RoleTriggerTargetEvent.MethodName.ADD));
        });

    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(RechargeEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.TOTAL_RECHARGE), event.getMoney(),
                RoleTriggerTargetEvent.MethodName.ADD));

        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.RECHARGE), event.getMoney(),
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ClanDonateEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.CLAN_DONATE), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(PvpEndEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.ARENA_SCORE), event.getScore(),
                RoleTriggerTargetEvent.MethodName.SET));
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.ARENA_CHALLENGE), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
        if (event.isWin()) {
            eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.ARENA_CHALLENGE_WIN), 1,
                    RoleTriggerTargetEvent.MethodName.ADD));
        }
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(TowerPassEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.TOWER_LEVEL), event.getNewStage(),
                RoleTriggerTargetEvent.MethodName.SET));
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.TOWER_CHALLENGE), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(TavernTaskRewardEvent event) {
        long rid = event.getRid();
        Map<Integer, Integer> map = Maps.newHashMap();
        event.getTaskIds().forEach(idx -> {
            int star = tavernSysCache.getOrThrow(idx).getStar();
            map.put(star, map.getOrDefault(star, 0));
        });
        map.forEach((key, value) -> {
            eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.COMPLETE_TAVERN_TASK_STAR_HIGH, key), value,
                    RoleTriggerTargetEvent.MethodName.ADD));
        });
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.COMPLETE_TAVERN_TASK), event.getTaskIds().size(),
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(TavernTaskRefreshEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.REFRESH_TAVERN_TASK), event.getCount(),
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(GoddessUnlockEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.UNLOCK_GODDESS, event.getConfigId()), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(GoddessLevelUpEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.GODDESS_LEVEL, event.getConfigId()), event.getNewLevel(),
                RoleTriggerTargetEvent.MethodName.SET));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(GoddessLevelUpOperatorEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.GODDESS_LEVEL_UP, event.getConfigId()), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    /**
     * 装备合成
     *
     * @param event
     */
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(MakeEquipEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.COMBINE_EQUIP), event.getTimes(),
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(BlessingPoolDoneEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.WISH, event.getType().getValue()), event.getCount(),
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(LoginEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.LOGIN), 1,
                RoleTriggerTargetEvent.MethodName.SET));

    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ZeroTimeEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.LOGIN), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(HeroSummonEvent event) {
        long rid = event.getRid();

        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.SUMMON, event.getType().getType()), event.getSummonCount(),
                RoleTriggerTargetEvent.MethodName.ADD));

    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ClanSkillUpEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.CLAN_SKILL_LEVEL_UP), 1,
                RoleTriggerTargetEvent.MethodName.ADD));

    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ChapterPassEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.PASS_MAIN_LEVEL), event.getMissionId(),
                RoleTriggerTargetEvent.MethodName.SET));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(SpeedFightEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.QUICK_BATTLE), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(TowerSweepEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.TOWER_CHALLENGE), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(DreamlandMaxLvEvent event) {
        long rid = event.getRid();

        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.INFINITE_LEVEL), event.getMaxLv(),
                RoleTriggerTargetEvent.MethodName.SET));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ClergyLevelEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.CLERGY_LEVEL), event.getNewLevel(),
                RoleTriggerTargetEvent.MethodName.SET));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ClanWorldBossBattleEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.CHALLENGE_WORLD_BOSS), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(StageTokenSettleEvent event) {
        contextManager.getOnlineRids().forEach(rid -> {
            TargetStruct targetStruct = TargetStruct.of(TargetType.STAGE_MATCH_LAST);
            eventBus.post(RoleTriggerTargetEvent.of(rid, targetStruct, targetCounterService.calcCount(rid, targetStruct),
                    RoleTriggerTargetEvent.MethodName.SET));
        });
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(DailyTaskRewardEvent event) {
        long rid = event.getRid();
        TargetStruct targetStruct = TargetStruct.of(TargetType.DAY_ACTIVE);
        eventBus.post(RoleTriggerTargetEvent.of(rid, targetStruct, event.getPoint(), RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(BuyGoldEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.BUY_GOLD, event.getType().getValue()), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe
    public void listen(GemCostEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.GEM_CONSUME), event.getCostCount(),
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe
    public void listen(GemAddEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.GEM_GAIN), event.getAddCount(),
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe
    public void listen(DreamlandBattleEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.INFINITE_CHALLENGE), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe
    private void listen(DungeonUseAgenitaEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.SHELTER_MEDICINE, event.getType()), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe
    private void listen(GoldCostEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.GOLD_CONSUME), event.getCostCount(),
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe
    private void listen(DungeonBattleEndEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.SHELTER_KILL), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe
    private void listen(AdvenBoxEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.ADVEN_GEM_BOX), 1,
                RoleTriggerTargetEvent.MethodName.ADD));
    }

    @Subscribe
    private void listen(HeroExpCostEvent event) {
        long rid = event.getRid();
        eventBus.post(RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.HERO_EXP_CONSUME), event.getCostCount(),
                RoleTriggerTargetEvent.MethodName.ADD));
    }


}
