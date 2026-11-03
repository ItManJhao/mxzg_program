package com.ayjs.mxzg.gameserver.module.promotionNew.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.TavernSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion029AdventureNotes;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion030MysteryBox;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.adven.event.AdvenPassEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.MakeEquipEvent;
import com.ayjs.mxzg.gameserver.module.battle.event.ChapterPassEvent;
import com.ayjs.mxzg.gameserver.module.blessingPool.event.BlessingPoolDoneEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDonateEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDungeonChallengeEvent;
import com.ayjs.mxzg.gameserver.module.dailydungeon.event.JoinDailyDungeonEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessLevelUpEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessLevelUpOperatorEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessUnlockEvent;
import com.ayjs.mxzg.gameserver.module.friend.event.FriendGiveEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroSummonEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion030MysteryBox;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.SpeedFightEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion030MysteryBoxService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.prophetSummon.event.ProphetSummonEvent;
import com.ayjs.mxzg.gameserver.module.pvp.event.PvpEndEvent;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.event.RoleLvUpEvent;
import com.ayjs.mxzg.gameserver.module.role.event.ZeroTimeEvent;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneCombineEvent;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneWashEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskRefreshEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskRewardEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskStartEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerChallengeEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerPassEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerSweepEvent;
import com.ayjs.mxzg.protocol.Task4GMsg;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2019/10/26
 **/
@Observer
public class Promotion030MysteryBoxObserver {

    @Autowired
    private Promotion030MysteryBoxService promotion030MysteryBoxService;
    @Autowired
    private TavernSysCache tavernSysCache;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private PromotionControlService promotionControlService;

    @Subscribe
    public void passMainLevel(ChapterPassEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.PASS_MAIN_LEVEL);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
        });
    }

    @Subscribe
    public void clanDonate(ClanDonateEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.CLAN_DONATE);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
        });
    }

    @Subscribe
    public void summon(HeroSummonEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.SUMMON);
        configs.forEach(config -> {
            if (TargetType.checkStruct(config.getTargetStruct(), event.getType().getType(), 0))
                promotion030MysteryBoxService.addCount(event.getRid(), config, event.getSummonCount());
        });
    }

    @Subscribe
    public void passTower(TowerPassEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.TOWER_LEVEL);
        configs.forEach(config -> {
            if (TargetType.checkStruct(config.getTargetStruct(), event.getNewStage(), 0))
                promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
        });
    }

    @Subscribe
    public void arenaChallenge(PvpEndEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.ARENA_CHALLENGE);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
        });
    }

    @Subscribe
    public void combineHero(HeroStarUpEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.COMBINE_HERO);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getHero().getRid(), config, 1);
        });

        configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.GET_HERO);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getHero().getRid(), config, 1);
        });
    }

    @Subscribe
    public void getHero(HeroGetEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.GET_HERO);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, event.getHeros().size());
        });

        configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.HAD_HIGH_LEVEL_HERO);
        configs.forEach(config -> {
            int count = (int) event.getHeros().stream().filter(hero -> TargetType.checkStruct(config.getTargetStruct(), hero.getLevel(), 0)).count();
            if (count > 0)
                promotion030MysteryBoxService.setCount(event.getRid(), config, count);
        });

        configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.HAD_HIGH_STAR_HERO);
        configs.forEach(config -> {
            int count = (int) event.getHeros().stream().filter(hero -> TargetType.checkStruct(config.getTargetStruct(), hero.getStar(), 0)).count();
            if (count > 0)
                promotion030MysteryBoxService.setCount(event.getRid(), config, count);
        });
    }

    @Subscribe
    public void completeTavernTask(TavernTaskRewardEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.COMPLETE_TAVERN_TASK);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
        });

        configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.COMPLETE_TAVERN_TASK_STAR_HIGH);
        configs.forEach(config -> {
            event.getTaskIds().forEach(idx -> {
                if (TargetType.checkStruct(config.getTargetStruct(), tavernSysCache.getOrThrow(idx).getStar(), 0))
                    promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
            });
        });
    }

    @Subscribe
    public void acceptTavernTask(TavernTaskStartEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.ACCEPT_TAVERN_TASK);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
        });

        configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.ACCEPT_TAVERN_TASK_STAR_HIGH);
        configs.forEach(config -> {
            if (TargetType.checkStruct(config.getTargetStruct(), tavernSysCache.getOrThrow(event.getTaskId()).getStar(), 0))
                promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
        });
    }

    @Subscribe
    public void refreshTavernTask(TavernTaskRefreshEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.REFRESH_TAVERN_TASK);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, event.getCount());
        });
    }

    @Subscribe
    public void unlockGoddess(GoddessUnlockEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.UNLOCK_GODDESS).stream()
                .filter(config -> TargetType.checkStruct(config.getTargetStruct(), event.getConfigId(), 0))
                .collect(Collectors.toList());
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
        });
    }

    @Subscribe
    public void goddessLvUp(GoddessLevelUpEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.GODDESS_LEVEL);
        configs.forEach(config -> {
            if (TargetType.checkStruct(config.getTargetStruct(), event.getNewLevel(), 0))
                promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
        });

    }

    @Subscribe
    public void goddessLvUp(GoddessLevelUpOperatorEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.GODDESS_LEVEL_UP)
                .stream().filter(config -> TargetType.checkStruct(config.getTargetStruct(), event.getConfigId(), 0))
                .collect(Collectors.toList());
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
        });
    }

    @Subscribe
    public void roleLevelUp(RoleLvUpEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.ADVENTURE_LEVEL);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, event.getNewLv() - event.getOldLv());
        });
    }

    @Subscribe
    public void makeEquip(MakeEquipEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.COMBINE_EQUIP);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, event.getTimes());
        });
    }

    @Subscribe
    public void wish(BlessingPoolDoneEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.WISH);
        configs.forEach(config -> {
            if (TargetType.checkStruct(config.getTargetStruct(), event.getType().getValue(), 0))
                promotion030MysteryBoxService.addCount(event.getRid(), config, event.getCount());
        });
    }

    @Subscribe
    public void passAdven(AdvenPassEvent event) {
        if (event.isWin()) {
            List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.PASS_ADVEN);
            configs.forEach(config -> {
                promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
            });
        }
    }

    @Subscribe
    public void quickBattle(SpeedFightEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.QUICK_BATTLE);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
        });
    }

    @Subscribe
    public void combineRune(RuneCombineEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.COMBINE_RUNE);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
        });
    }

    @Subscribe
    public void washRune(RuneWashEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.WASH_RUNE);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
        });
    }

    @Subscribe
    public void prophecy(ProphetSummonEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.PROPHECY);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, event.getNum());
        });
    }

    @Subscribe
    public void friendGift(FriendGiveEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.FRIEND_GIFT);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, event.getGiveCount());
        });
    }

    @Subscribe
    public void towerChallenge(TowerSweepEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.TOWER_CHALLENGE);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
        });
    }

    @Subscribe
    public void towerSweep(TowerChallengeEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.TOWER_CHALLENGE);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
        });
    }

    @Subscribe
    public void joinDailyDungeon(JoinDailyDungeonEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.DAILY_DUNGEON_CHALLENGE);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
        });
    }

    @Subscribe
    public void login(LoginEvent event) {
        Promotion030MysteryBox promotion = promotion030MysteryBoxService.getPromotionInfo(event.getRid());
        if (!TimeDateUtil.isToday(promotion.getLastLoginTime())) {
            promotion.setLastLoginTime(TimeDateUtil.getCurrentTimeInt());
            promotion030MysteryBoxService.updatePromotion(promotion);
            List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.LOGIN);
            configs.forEach(config -> {
                promotion030MysteryBoxService.loginAdd(event.getRid(), config, 1);
            });
        }
    }

    @Subscribe
    public void zero(ZeroTimeEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.LOGIN);
        Promotion030MysteryBox promotion = promotion030MysteryBoxService.getPromotionInfo(event.getRid());
        promotion.setLastLoginTime(TimeDateUtil.getCurrentTimeInt());
        promotion030MysteryBoxService.updatePromotion(promotion);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
        });
    }

    @Subscribe
    public void challengeClanDungeon(ClanDungeonChallengeEvent event) {
        List<CPromotion030MysteryBox> configs = promotion030MysteryBoxService.getConfigsByTypeAndDays(TargetType.CHALLENGE_CLAN_DUNGEON);
        configs.forEach(config -> {
            promotion030MysteryBoxService.addCount(event.getRid(), config, 1);
        });
    }

    @Subscribe
    public void recharge(RechargeEvent event) {
        if (!promotionControlService.isPromotionRecording(PromotionType.SHEN_MI_MO_HE)) {
            return;
        }

        Promotion030MysteryBox promotionInfo = promotion030MysteryBoxService.getPromotionInfo(event.getRid());
        promotionInfo.setRecharge(promotionInfo.getRecharge() + event.getMoney());
        promotion030MysteryBoxService.updatePromotion(promotionInfo);
        Task4GMsg.GResMysteryBoxRechargeUpdate.Builder builder = Task4GMsg.GResMysteryBoxRechargeUpdate.newBuilder();
        builder.setTotalRecharge(promotionInfo.getRecharge());
        contextManager.write(event.getRid(), CmdCode._13141, builder.build());
    }
}
