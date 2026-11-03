package com.ayjs.mxzg.gameserver.module.achievement.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.DailyTaskMainTestSysCache;
import com.ayjs.mxzg.config.excel.cache.TavernSysCache;
import com.ayjs.mxzg.config.excel.entity.CDailyTaskMainTest;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.achievement.domain.RoleDailyTask;
import com.ayjs.mxzg.gameserver.module.achievement.service.DailyTaskService;
import com.ayjs.mxzg.gameserver.module.adven.event.AdvenPassEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDonateEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDungeonChallengeEvent;
import com.ayjs.mxzg.gameserver.module.dailydungeon.event.JoinDailyDungeonEvent;
import com.ayjs.mxzg.gameserver.module.dreamland.event.DreamlandBattleEvent;
import com.ayjs.mxzg.gameserver.module.friend.event.FriendGiveEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroSummonEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.SpeedFightEvent;
import com.ayjs.mxzg.gameserver.module.pvp.event.PvpEndEvent;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.event.ZeroTimeEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.shop.event.ShopBuyEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskStartEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerChallengeEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerSweepEvent;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.stream.Collectors;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/13 22:07
 */
@Observer
@Slf4j
public class DailyTaskObserver {

    @Autowired
    private RoleService roleService;
    @Autowired
    DailyTaskService dailyTaskService;
    @Autowired
    DailyTaskMainTestSysCache dailyTaskMainTestSysCache;
    @Autowired
    private TavernSysCache tavernSysCache;

    @Subscribe
    public void login(LoginEvent event) {
        long rid = event.getRid();
        RoleDailyTask roleDailyTask = dailyTaskService.loadRoleDailyTask(rid);
        if (TimeDateUtil.isToday(roleDailyTask.getLastLoginTime())) {
            return;
        }
        roleDailyTask.setLastLoginTime(TimeDateUtil.getCurrentTimeInt());
        dailyTaskService.updateRoleDailyTask(roleDailyTask);
        dailyTaskService.addProcess(rid, getConfigsByType(TargetType.LOGIN), 1);
    }

    private List<CDailyTaskMainTest> getConfigsByType(TargetType type) {
        return dailyTaskMainTestSysCache.getConfigsByType(type);
    }

    @Subscribe
    public void zeroTime(ZeroTimeEvent event) {
        long rid = event.getRid();
        RoleDailyTask roleDailyTask = dailyTaskService.loadRoleDailyTask(rid);
        roleDailyTask.setLastLoginTime(TimeDateUtil.getCurrentTimeInt());
        dailyTaskService.updateRoleDailyTask(roleDailyTask);
        dailyTaskService.addProcess(rid, getConfigsByType(TargetType.LOGIN), 1);
    }

    @Subscribe
    public void friendGift(FriendGiveEvent event) {
        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.FRIEND_GIFT);
        dailyTaskService.addProcess(event.getRid(), configs, event.getGiveCount());
    }

    @Subscribe
    public void summon(HeroSummonEvent event) {
        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.SUMMON);
        configs = configs.stream().filter(config -> config.getTask().getCondition() == 0 || config.getTask().getCondition() == event.getType().getType()).collect(Collectors.toList());
        dailyTaskService.addProcess(event.getRid(), configs, event.getSummonCount());
    }

    @Subscribe
    public void arenaChallenge(PvpEndEvent event) {
        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.ARENA_CHALLENGE);
        dailyTaskService.addProcess(event.getRid(), configs, 1);
    }

    @Subscribe
    public void quickBattle(SpeedFightEvent event) {
        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.QUICK_BATTLE);
        dailyTaskService.addProcess(event.getRid(), configs, 1);
    }

    @Subscribe
    public void towerChallenge(TowerChallengeEvent event) {
        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.TOWER_CHALLENGE);
        dailyTaskService.addProcess(event.getRid(), configs, 1);
    }

    @Subscribe
    public void towerSweep(TowerSweepEvent event) {
        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.TOWER_CHALLENGE);
        dailyTaskService.addProcess(event.getRid(), configs, 1);
    }

    @Subscribe
    public void clanDonate(ClanDonateEvent event) {
        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.CLAN_DONATE);
        dailyTaskService.addProcess(event.getRid(), configs, 1);
    }

    @Subscribe
    public void acceptTavernTask(TavernTaskStartEvent event) {
        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.ACCEPT_TAVERN_TASK);
        dailyTaskService.addProcess(event.getRid(), configs, 1);

//        configs = getConfigsByType(TargetType.ACCEPT_TAVERN_TASK_STAR_HIGH);
//        configs = configs.stream().filter(config ->
//                tavernSysCache.getOrThrow(event.getTaskId()).getStar() >= config.getTargetStruct().getCondition()
//        ).collect(Collectors.toList());
//
//        dailyTaskService.addProcess(event.getRid(), configs, 1);
    }

    @Subscribe
    public void joinDailyDungeon(JoinDailyDungeonEvent event) {
        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.DAILY_DUNGEON_CHALLENGE);
        dailyTaskService.addProcess(event.getRid(), configs, 1);
    }

    @Subscribe
    public void passAdven(AdvenPassEvent event) {
        if (event.isWin()) {
            List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.PASS_ADVEN);
            dailyTaskService.addProcess(event.getRid(), configs, 1);
        }
    }

    @Subscribe
    public void shopBuy(ShopBuyEvent event) {
        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.SHOP_BUY);
        configs = configs.stream().filter(config -> config.getTask().getCondition() ==
                event.getShopType().getValue()).collect(Collectors.toList());
        dailyTaskService.addProcess(event.getRid(), configs, event.getBuyTimes());
    }

    @Subscribe
    public void challengeClanDungeon(ClanDungeonChallengeEvent event) {
        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.CHALLENGE_CLAN_DUNGEON);
        dailyTaskService.addProcess(event.getRid(), configs, 1);
    }

    @Subscribe
    public void dreamlandBattle(DreamlandBattleEvent event){
        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.INFINITE_CHALLENGE);
        dailyTaskService.addProcess(event.getRid(),configs,1);
    }

    //------------------------------------------------------

//    @Subscribe
//    public void passMainLevel(ChapterPassEvent event) {
//        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.PASS_MAIN_LEVEL);
//        dailyTaskService.addProcess(event.getRid(), configs, 1);
//    }

//
//    @Subscribe
//    public void passTower(TowerPassEvent event) {
//        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.TOWER_LEVEL);
//        configs = configs.stream().filter(config -> config.getTargetStruct().getCondition() < event.getNewStage()).collect(Collectors.toList());
//        dailyTaskService.addProcess(event.getRid(), configs, 1);
//    }
//
//
//    @Subscribe
//    public void combineHero(HeroStarUpEvent event) {
//        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.COMBINE_HERO);
//        dailyTaskService.addProcess(event.getHero().getRid(), configs, 1);
//
//        configs = getConfigsByType(TargetType.GET_HERO);
//        dailyTaskService.addProcess(event.getHero().getRid(), configs, 1);
//    }
//
//    @Subscribe
//    public void getHero(HeroGetEvent event) {
//        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.GET_HERO);
//
//        dailyTaskService.addProcess(event.getRid(), configs, event.getHeros().size());
//
//        configs = getConfigsByType(TargetType.HAD_HIGH_LEVEL_HERO);
//        configs.forEach(config -> {
//            int count = (int) event.getHeros().stream().filter(hero -> hero.getLevel() >= config.getTargetStruct().getCondition()).count();
//            if (count > 0)
//                dailyTaskService.addProcess(event.getRid(), Arrays.asList(config), count);
//        });
//
//        configs = getConfigsByType(TargetType.HAD_HIGH_STAR_HERO);
//        configs.forEach(config -> {
//            int count = (int) event.getHeros().stream().filter(hero -> hero.getStar() >= config.getTargetStruct().getCondition()).count();
//            if (count > 0)
//                dailyTaskService.addProcess(event.getRid(), Arrays.asList(config), count);
//        });
//    }
//
//
//    @Subscribe
//    public void completeTavernTask(TavernTaskRewardEvent event) {
//        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.COMPLETE_TAVERN_TASK);
//
//        dailyTaskService.addProcess(event.getRid(), configs, 1);
//
//        configs = getConfigsByType(TargetType.COMPLETE_TAVERN_TASK_STAR_HIGH);
//        configs = configs.stream().filter(config -> tavernSysCache.getOrThrow(event.getTaskId()).getStar() >= config.getTargetStruct().getCondition())
//                .collect(Collectors.toList());
//        dailyTaskService.addProcess(event.getRid(), configs, 1);
//    }
//
//
//    @Subscribe
//    public void refreshTavernTask(TavernTaskRefreshEvent event) {
//        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.REFRESH_TAVERN_TASK);
//        dailyTaskService.addProcess(event.getRid(), configs, event.getCount());
//    }
//
//    @Subscribe
//    public void unlockGoddess(GoddessUnlockEvent event) {
//        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.UNLOCK_GODDESS);
//        dailyTaskService.addProcess(event.getRid(), configs, 1);
//    }
//
//    @Subscribe
//    public void goddessLvUp(GoddessLevelUpEvent event) {
//        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.GODDESS_LEVEL_UP);
//        dailyTaskService.addProcess(event.getRid(), configs, 1);
//        configs = getConfigsByType(TargetType.GODDESS_LEVEL);
//        configs = configs.stream().filter(config -> event.getNewLevel() > config.getTargetStruct().getCondition())
//                .collect(Collectors.toList());
//        dailyTaskService.addProcess(event.getRid(), configs, 1);
//    }
//
//    @Subscribe
//    public void roleLevelUp(RoleLvUpEvent event) {
//        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.ROLE_LEVEL);
//        dailyTaskService.addProcess(event.getRid(), configs, event.getNewLv() - event.getOldLv());
//    }
//
//    @Subscribe
//    public void makeEquip(MakeEquipEvent event) {
//        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.COMBINE_EQUIP);
//        dailyTaskService.addProcess(event.getRid(), configs, event.getTimes());
//    }
//
//    @Subscribe
//    public void wish(BlessingPoolDoneEvent event) {
//        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.WISH);
//        configs = configs.stream().filter(config -> config.getTargetStruct().getCondition() == event.getType().getValue()).collect(Collectors.toList());
//        dailyTaskService.addProcess(event.getRid(), configs, event.getCount());
//    }
//
////    @Subscribe
////    public void passAdven(AdvenPassEvent event) {
////        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.ADVEN_LEVEL);
////        configs = configs.stream().filter(config -> config.getTargetStruct().getCondition() <= event.getMissionId()).collect(Collectors.toList());
////        dailyTaskService.addProcess(event.getRid(), configs, 1);
////    }
//
//
//    @Subscribe
//    public void combineRune(RuneCombineEvent event) {
//        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.COMBINE_RUNE);
//        dailyTaskService.addProcess(event.getRid(), configs, 1);
//    }
//
//    @Subscribe
//    public void washRune(RuneWashEvent event) {
//        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.WASH_RUNE);
//        dailyTaskService.addProcess(event.getRid(), configs, 1);
//    }
//
//    @Subscribe
//    public void prophecy(ProphetSummonEvent event) {
//        List<CDailyTaskMainTest> configs = getConfigsByType(TargetType.PROPHECY);
//        dailyTaskService.addProcess(event.getRid(), configs, event.getNum());
//    }


}
