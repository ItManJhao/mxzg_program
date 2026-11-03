package com.ayjs.mxzg.gameserver.module.targetCounter.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.ItemSysCache;
import com.ayjs.mxzg.config.excel.cache.TavernSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.excel.entity.CItem;
import com.ayjs.mxzg.config.excel.entity.CTavern;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.module.adven.event.AdvenPassEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.ItemAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.MakeEquipEvent;
import com.ayjs.mxzg.gameserver.module.battle.event.ChapterPassEvent;
import com.ayjs.mxzg.gameserver.module.blessingPool.event.BlessingPoolDoneEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanChangeEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDonateEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDungeonChallengeEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDungeonKillEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanSkillUpEvent;
import com.ayjs.mxzg.gameserver.module.clanworldboss.event.ClanWorldBossBattleEvent;
import com.ayjs.mxzg.gameserver.module.clergy.event.ClergyLevelEvent;
import com.ayjs.mxzg.gameserver.module.dailydungeon.event.JoinDailyDungeonEvent;
import com.ayjs.mxzg.gameserver.module.dreamland.event.DreamlandMaxLvEvent;
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
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.event.MaxFightingEvent;
import com.ayjs.mxzg.gameserver.module.role.event.RoleLvUpEvent;
import com.ayjs.mxzg.gameserver.module.role.event.ZeroTimeEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneCombineEvent;
import com.ayjs.mxzg.gameserver.module.shop.event.ShopBuyEvent;
import com.ayjs.mxzg.gameserver.module.stagematch.rim.event.StageTokenSettleEvent;
import com.ayjs.mxzg.gameserver.module.targetCounter.event.TaskCountChangeEvent;
import com.ayjs.mxzg.gameserver.module.targetCounter.service.TargetCounterService;
import com.ayjs.mxzg.gameserver.module.task.event.AlterHeroEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskRefreshEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskRewardEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskStartEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerPassEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerSweepEvent;
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
public class TaskCountObserver {

    @Autowired
    private RoleService roleService;
    @Autowired
    TargetCounterService targetCounterService;
    @Autowired
    EventBus eventBus;
    @Autowired
    TavernSysCache tavernSysCache;
    @Autowired
    ItemSysCache itemSysCache;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private ContextManager contextManager;

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void roleLvUp(RoleLvUpEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.ADVENTURE_LEVEL, 1);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void friendGift(FriendGiveEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.FRIEND_GIFT, event.getGiveCount());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void friendAdd(FriendAddEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.FRIEND_NUM, 1);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void joinClan(ClanChangeEvent event) {
        long rid = event.getRid();
        if (event.getNewClanId() > 0) {
            targetCounterService.addProcess(rid, TargetType.JOIN_CLAN, 1);
        }
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void passAdven(AdvenPassEvent event) {
        if (event.isWin()) {
            long rid = event.getRid();
            targetCounterService.setProcess(rid, TargetType.ADVEN_LEVEL, event.getBattleMissionId());
        }
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void combineHero(HeroStarUpEvent event) {
        long rid = event.getHero().getRid();
        CHeroType cHeroType = heroTypeSysCache.getOrThrow(event.getHero().getType());
        targetCounterService.addProcess(rid, TargetType.COMBINE_HERO, event.getHero().getStar(), 0, 1);
        targetCounterService.addProcess(rid, TargetType.GET_HERO, event.getHero().getStar(), cHeroType.getElem(), 1);
        targetCounterService.addProcess(rid, TargetType.HAD_HIGH_LEVEL_HERO, event.getHero().getLevel(), 0, 1);
        targetCounterService.addProcess(rid, TargetType.HAD_HIGH_STAR_HERO, event.getHero().getStar(), 0, 1);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void heroGet(HeroGetEvent event) {
        long rid = event.getRid();
        //英雄置换不算
        if (event.getGameEvent() == GameEvent.PROPHECY_HERO_EXCHANGE) {
            return;
        }
        event.getHeros().forEach(hero -> {
            CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());
            targetCounterService.addProcess(rid, TargetType.GET_HERO, hero.getStar(), cHeroType.getElem(), 1);
            targetCounterService.addProcess(rid, TargetType.HAD_HIGH_LEVEL_HERO, hero.getLevel(), 0, 1);
            targetCounterService.addProcess(rid, TargetType.HAD_HIGH_STAR_HERO, hero.getStar(), 0, 1);
        });
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(HeroUpLevelEvent event) {
        long rid = event.getHero().getRid();
        targetCounterService.addProcess(rid, TargetType.HAD_HIGH_LEVEL_HERO, event.getHero().getLevel(), 0, 1);
    }


    @Subscribe(async = Subscribe.AsyncType.Async)
    public void combineRune(RuneCombineEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.COMBINE_RUNE, 1);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void joinDailyDungeon(JoinDailyDungeonEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.DAILY_DUNGEON_CHALLENGE, 1);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void prophecy(ProphetSummonEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.PROPHECY, event.getNum());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void acceptTavernTask(TavernTaskStartEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.ACCEPT_TAVERN_TASK, tavernSysCache.getOrThrow(event.getTaskId()).getStar(), 0, 1);
        CTavern cTavern = tavernSysCache.getOrThrow(event.getTaskId());
        targetCounterService.addProcess(rid, TargetType.ACCEPT_TAVERN_TASK_STAR_HIGH, cTavern.getStar(), 0, 1);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void deleteHero(AlterHeroEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.SACRIFICE, event.getCount());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void clanDungeonChallenge(ClanDungeonChallengeEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.CHALLENGE_CLAN_DUNGEON, 1);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void clanDungeonChallenge(ClanDungeonKillEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.BEAT_CLAN_DUNGEON, 1);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void changePower(MaxFightingEvent event) {
        long rid = event.getRid();
        targetCounterService.setProcess(rid, TargetType.ROLE_MAX_FIGHTING, event.getMaxFighting());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void pvpBattle(PvpEndEvent event) {
        long rid = event.getRid();
        targetCounterService.setProcess(rid, TargetType.ARENA_SCORE, event.getScore());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void pvpRankChange(ArenaRankChangeEvent event) {
        long rid = event.getRid();
        targetCounterService.setMinProcess(rid, TargetType.ARENA_MAX_RANK, 0, 0, event.getRank().getNewRank());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void passAdvent(AdvenPassEvent event) {
        if (event.isWin()) {
            long rid = event.getRid();
            targetCounterService.addProcess(rid, TargetType.PASS_ADVEN, 1);
        }
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void shopBuy(ShopBuyEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.SHOP_BUY, event.getShopType().getValue(), 0, event.getBuyTimes());
    }

    /***
     * 添加道具
     * @param event
     */
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void addItem(ItemAddEvent event) {
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
            long newValue = targetCounterService.addProcessNotPost(rid, TargetType.GET_EQUIP_QUALITY, key, 0, value);
            eventBus.post(TaskCountChangeEvent.of(rid, TargetType.GET_EQUIP_QUALITY, key, 0, value, newValue));
        });

    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void recharge(RechargeEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.TOTAL_RECHARGE, 0, 0, event.getMoney());
        targetCounterService.addProcess(rid, TargetType.RECHARGE, 0, 0, event.getMoney());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void clanDetonate(ClanDonateEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.CLAN_DONATE, 1);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void arenaChallenge(PvpEndEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.ARENA_CHALLENGE, 1);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void passTower(TowerPassEvent event) {
        long rid = event.getRid();
        targetCounterService.setProcess(rid, TargetType.TOWER_LEVEL, event.getNewStage());
        targetCounterService.setProcess(rid, TargetType.TOWER_CHALLENGE, 1);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void completeTavernTask(TavernTaskRewardEvent event) {
        long rid = event.getRid();
        event.getTaskIds().forEach(idx -> {
            targetCounterService.addProcess(rid, TargetType.COMPLETE_TAVERN_TASK, tavernSysCache.getOrThrow(idx).getStar(), 0, 1);
            targetCounterService.addProcess(rid, TargetType.COMPLETE_TAVERN_TASK_STAR_HIGH, 1);
        });
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void refreshTavernTask(TavernTaskRefreshEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.REFRESH_TAVERN_TASK, event.getCount());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void unlockGoddess(GoddessUnlockEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.UNLOCK_GODDESS, event.getConfigId(), 0, 1);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void goddessLvUp(GoddessLevelUpEvent event) {
        long rid = event.getRid();
        targetCounterService.setProcess(rid, TargetType.GODDESS_LEVEL, event.getConfigId(), 0, event.getNewLevel());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void goddessLvUp(GoddessLevelUpOperatorEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.GODDESS_LEVEL_UP, event.getConfigId(), 0, 1);
    }

    /**
     * 装备合成
     *
     * @param event
     */
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void makeEquip(MakeEquipEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.COMBINE_EQUIP, event.getTimes());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void wish(BlessingPoolDoneEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.WISH, event.getType().getValue(), 0, event.getCount());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void login(LoginEvent event) {
        long rid = event.getRid();
        Role role = roleService.getOrThrow(rid);
        int lastTime = role.getTaskCountTime() == 0 ? (int) (role.getLastOfflineTime() / TimeDateUtil.ONESECOND) :
                role.getTaskCountTime();
        if (TimeDateUtil.isToday(lastTime)) {
            return;
        }
        role.setTaskCountTime(TimeDateUtil.getCurrentTimeInt());
        roleService.updateRole(role);

        targetCounterService.addProcess(rid, TargetType.LOGIN, 0, 0, 1);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void zeroTime(ZeroTimeEvent event) {
        long rid = event.getRid();

        Role role = roleService.getOrThrow(rid);
        role.setTaskCountTime(TimeDateUtil.getCurrentTimeInt());
        roleService.updateRole(role);

        targetCounterService.addProcess(rid, TargetType.LOGIN, 0, 0, 1);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void heroSummon(HeroSummonEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.SUMMON, event.getType().getType(), 0, event.getSummonCount());
//        eventBus.post(TaskCountChangeEvent.of(rid, TargetType.HERO_SUMMON));

    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void clanSkillLevelUp(ClanSkillUpEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.CLAN_SKILL_LEVEL_UP, 1);
//        eventBus.post(TaskCountChangeEvent.of(rid, TargetType.HERO_SUMMON));

    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void passMainLevel(ChapterPassEvent event) {
        long rid = event.getRid();
        targetCounterService.setProcess(rid, TargetType.PASS_MAIN_LEVEL, event.getMissionId());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void speedFight(SpeedFightEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.QUICK_BATTLE, 1);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void towerSweep(TowerSweepEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.TOWER_CHALLENGE, 1);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void towerSweep(DreamlandMaxLvEvent event) {
        long rid = event.getRid();
        targetCounterService.setProcess(rid, TargetType.INFINITE_LEVEL, event.getMaxLv());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void towerSweep(ClergyLevelEvent event) {
        long rid = event.getRid();
        targetCounterService.setProcess(rid, TargetType.CLERGY_LEVEL, event.getNewLevel());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void towerSweep(ClanWorldBossBattleEvent event) {
        long rid = event.getRid();
        targetCounterService.addProcess(rid, TargetType.CHALLENGE_WORLD_BOSS, 1);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(StageTokenSettleEvent event) {
        contextManager.getOnlineRids().forEach(rid -> targetCounterService.addProcess(rid, TargetType.STAGE_MATCH_LAST, 1));
    }


    //---------------*********************-----------------

    /**
     * 装备合成
     *
     * @param event
     */
//    @Subscribe
//    public void makeEquip(MakeEquipEvent event) {
//        long rid = event.getRid();
//        targetCounterService.addProcess(rid, TargetType.GET_EQUIP_QUALITY, 1);
////        eventBus.post(TaskCountChangeEvent.of(rid, TargetType.COMPOSE_EQUIP));
//    }
//    @Subscribe
//    public void login(LoginEvent event) {
//        long rid = event.getRid();
//        Role role = roleService.getOrThrow(rid);
//        if (TimeDateUtil.isToday(role.getLastOfflineTime())) {
//            return;
//        }
//        targetCounterService.addProcess(rid, TargetType.LOGIN, 0, 0, 1);
////        eventBus.post(TaskCountChangeEvent.of(rid, TargetType.LOGIN));
//    }
//
//    @Subscribe
//    public void zeroTime(ZeroTimeEvent event) {
//        long rid = event.getRid();
//        targetCounterService.addProcess(rid, TargetType.LOGIN, 0, 0, 1);
////        eventBus.post(TaskCountChangeEvent.of(rid, TargetType.LOGIN));
//    }
//
//
//    @Subscribe
//    public void heroSummon(HeroSummonEvent event) {
//        long rid = event.getRid();
//        Role role = roleService.getOrThrow(rid);
//        targetCounterService.addProcess(rid, TargetType.SUMMON, event.getType().getType(), 0, event.getSummonCount());
////        eventBus.post(TaskCountChangeEvent.of(rid, TargetType.HERO_SUMMON));
//
//    }
//
//
//    @Subscribe
//    public void passTower(TowerPassEvent event) {
//        long rid = event.getRid();
//        targetCounterService.setProcess(rid, TargetType.TOWER_LEVEL, event.getNewStage());
////        eventBus.post(TaskCountChangeEvent.of(rid, TargetType.TOWER_LEVEL));
//    }
//
//    @Subscribe
//    public void heroChange(HeroChangeEvent event) {
//        long rid = event.getRid();
//        targetCounterService.addProcess(rid, TargetType.HERO_SWAP, 1);
////        eventBus.post(TaskCountChangeEvent.of(rid, TargetType.HERO_SWAP));
//    }
//

//
//
//    @Subscribe
//    public void clanDetonate(ClanDonateEvent event) {
//        long rid = event.getRid();
//        targetCounterService.addProcess(rid, TargetType.CLAN_DONATE, 1);
////        eventBus.post(TaskCountChangeEvent.of(rid, TargetType.CLAN_DONATE));
//    }
//

//
//    /**
//     * 快速战斗
//     *
//     * @param event
//     */
//    @Subscribe
//    public void speedFight(SpeedFightEvent event) {
//        long rid = event.getRid();
//        targetCounterService.addProcess(rid, TargetType.QUICK_BATTLE, 1);
////        eventBus.post(TaskCountChangeEvent.of(rid, TargetType.QUICK_BATTLE));
//    }
//
//
//    //-----------------------------------------
//    @Subscribe
//    public void passMainLevel(ChapterPassEvent event) {
//        long rid = event.getRid();
//        targetCounterService.addProcess(rid, TargetType.PASS_MAIN_LEVEL, 1);
//    }
//
//
//    @Subscribe
//    public void arenaChallenge(PvpEndEvent event) {
//        long rid = event.getRid();
//        targetCounterService.addProcess(rid, TargetType.ARENA_CHALLENGE, 1);
//    }
//
//
//    @Subscribe
//    public void completeTavernTask(TavernTaskRewardEvent event) {
//        long rid = event.getRid();
//        targetCounterService.addProcess(rid, TargetType.COMPLETE_TAVERN_TASK, tavernSysCache.getOrThrow(event.getTaskId()).getStar(), 0, 1);
//        targetCounterService.addProcess(rid, TargetType.COMPLETE_TAVERN_TASK_STAR_HIGH, 1);
//    }
//
//
//    @Subscribe
//    public void washRune(RuneWashEvent event) {
//        long rid = event.getRid();
//        targetCounterService.addProcess(rid, TargetType.WASH_RUNE, 1);
//    }
//
//
//    @Subscribe
//    public void towerSweep(TowerSweepEvent event) {
//        long rid = event.getRid();
//        targetCounterService.addProcess(rid, TargetType.TOWER_CHALLENGE, 1);
//    }


}
