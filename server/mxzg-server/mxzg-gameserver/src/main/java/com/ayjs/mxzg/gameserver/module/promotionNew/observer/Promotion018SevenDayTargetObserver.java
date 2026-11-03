package com.ayjs.mxzg.gameserver.module.promotionNew.observer;

import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.cache.AdventurerewardSysCache;
import com.ayjs.mxzg.config.excel.cache.TavernSysCache;
import com.ayjs.mxzg.config.excel.entity.CTavern;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion018SevenDayTarget;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.adven.domain.AdvenMission;
import com.ayjs.mxzg.gameserver.module.adven.event.AdvenPassEvent;
import com.ayjs.mxzg.gameserver.module.adven.service.AdvenMissionService;
import com.ayjs.mxzg.gameserver.module.backpack.event.MakeEquipEvent;
import com.ayjs.mxzg.gameserver.module.battle.event.ChapterPassEvent;
import com.ayjs.mxzg.gameserver.module.blessingPool.event.BlessingPoolDoneEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDonateEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDungeonChallengeEvent;
import com.ayjs.mxzg.gameserver.module.dailydungeon.event.JoinDailyDungeonEvent;
import com.ayjs.mxzg.gameserver.module.dreamland.event.DreamlandBattleEvent;
import com.ayjs.mxzg.gameserver.module.dreamland.event.DreamlandMaxLvEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessLevelUpEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessLevelUpOperatorEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessUnlockEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroSummonEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroUpLevelEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.SpeedFightEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion018SevenDayTargetService;
import com.ayjs.mxzg.gameserver.module.prophetSummon.event.ProphetSummonEvent;
import com.ayjs.mxzg.gameserver.module.pvp.event.PvpEndEvent;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.event.RoleLvUpEvent;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneCombineEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskRefreshEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskRewardEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskStartEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerChallengeEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerPassEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerSweepEvent;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 七日目标
 *
 * @author hyx
 */
@Observer
public class Promotion018SevenDayTargetObserver {

    @Autowired
    private Promotion018SevenDayTargetService promotion018SevenDayTargetService;
    @Autowired
    private TavernSysCache tavernSysCache;
    @Autowired
    private AdventurerewardSysCache adventurerewardSysCache;

    @Subscribe
    public void listen(LoginEvent event) {
        promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.LOGIN, 1, null);
        /*//TODO 修复勇者试炼数据
        AdvenMissionService advenMissionService = SpringProxy.getBean(AdvenMissionService.class);
        AdvenMission advenMission = advenMissionService.getAdvenMission(event.getRid());
        if(advenMission.getMissionId() == 19){
            if(advenMission.getMissionData().get(19) !=null && advenMission.getMissionData().get(19).getState() == 1){
                promotion018SevenDayTargetService.setProgress(event.getRid(), TargetType.ADVEN_LEVEL, 15, null);
            }
        }
        if(advenMission.getLv() > 1){
            promotion018SevenDayTargetService.setProgress(event.getRid(), TargetType.ADVEN_LEVEL, 15, null);
        }*/
    }

    @Subscribe
    public void listen(RechargeEvent event) {
        promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.TOTAL_RECHARGE, event.getMoney(), null);
    }

    @Subscribe
    public void listen(ChapterPassEvent event) {
        promotion018SevenDayTargetService.setProgress(event.getRid(), TargetType.PASS_MAIN_LEVEL, event.getMissionId(), null);
    }

    @Subscribe
    public void listen(ClanDonateEvent event) {
        promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.CLAN_DONATE, 1, null);
    }

    @Subscribe
    public void listen(ClanDungeonChallengeEvent event) {
        promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.CHALLENGE_CLAN_DUNGEON, 1, null);
    }

    @Subscribe
    public void listen(TowerPassEvent event) {
        promotion018SevenDayTargetService.setProgress(event.getRid(), TargetType.TOWER_LEVEL, event.getNewStage(), null);
    }

    @Subscribe
    public void listen(HeroSummonEvent event) {

        List<CPromotion018SevenDayTarget> configList = promotion018SevenDayTargetService.getConfig(TargetType.SUMMON).stream()
                .filter(config -> config.getTask().getCondition() == 0 || config.getTask().getCondition() == event.getType().getType()).collect(Collectors.toList());

        if (!configList.isEmpty()) {
            promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.SUMMON, event.getSummonCount(), configList);
        }
    }

    @Subscribe
    public void listen(PvpEndEvent event) {
        promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.ARENA_CHALLENGE, 1, null);
    }

    @Subscribe
    public void listen(HeroStarUpEvent event) {

        List<CPromotion018SevenDayTarget> configList = promotion018SevenDayTargetService.getConfig(TargetType.COMBINE_HERO).stream()
                .filter(config -> config.getTask().getCondition() == 0 || config.getTask().getCondition() == event.getHero().getStar()).collect(Collectors.toList());

        if (!configList.isEmpty()) {
            promotion018SevenDayTargetService.addProgress(event.getHero().getRid(), TargetType.COMBINE_HERO, 1, configList);
        }

        List<Hero> heroList = new ArrayList<>();
        heroList.add(event.getHero());
        this.getHero(event.getHero().getRid(), heroList, TargetType.GET_HERO);
        this.getHero(event.getHero().getRid(), heroList, TargetType.HAD_HIGH_STAR_HERO);
    }

    @Subscribe
    public void listen(TavernTaskRewardEvent event) {
        List<CTavern> tavernList = tavernSysCache.getAll().stream().filter(config -> event.getTaskIds().contains(config.getIdx())).collect(Collectors.toList());

        promotion018SevenDayTargetService.getConfig(TargetType.COMPLETE_TAVERN_TASK).forEach(config -> {

            List<CPromotion018SevenDayTarget> configList = new ArrayList<>();
            configList.add(config);

            int addProgress = 0;
            if (config.getTask().getCondition() == 0) {
                addProgress = tavernList.size();
            } else {
                addProgress = (int) tavernList.stream().filter(cTavern -> cTavern.getStar() == config.getTask().getCondition()).count();
            }

            promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.COMPLETE_TAVERN_TASK, addProgress, configList);
        });

    }

    @Subscribe
    public void listen(TavernTaskStartEvent event) {
        promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.ACCEPT_TAVERN_TASK, 1, null);

        promotion018SevenDayTargetService.getConfig(TargetType.ACCEPT_TAVERN_TASK_STAR_HIGH).forEach(config -> {

            List<CPromotion018SevenDayTarget> configList = new ArrayList<>();
            configList.add(config);

            if (TargetType.checkStruct(config.getTask(), tavernSysCache.getOrThrow(event.getTaskId()).getStar(), 0))
                promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.ACCEPT_TAVERN_TASK_STAR_HIGH, 1, configList);

        });

    }

    @Subscribe
    public void listen(TavernTaskRefreshEvent event) {
        promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.REFRESH_TAVERN_TASK, event.getCount(), null);
    }

    @Subscribe
    public void listen(GoddessUnlockEvent event) {
        promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.UNLOCK_GODDESS, 1, null);
    }

    @Subscribe
    public void listen(GoddessLevelUpEvent event) {
        promotion018SevenDayTargetService.setProgress(event.getRid(), TargetType.GODDESS_LEVEL, event.getNewLevel(), null);
    }

    @Subscribe
    public void listen(RoleLvUpEvent event) {
        promotion018SevenDayTargetService.setProgress(event.getRid(), TargetType.ADVENTURE_LEVEL, event.getNewLv(), null);
    }

    @Subscribe
    public void listen(MakeEquipEvent event) {
        promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.COMBINE_EQUIP, event.getTimes(), null);
    }

    @Subscribe
    public void listen(BlessingPoolDoneEvent event) {
        promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.WISH, event.getCount(), null);
    }

    @Subscribe
    public void listen(AdvenPassEvent event) {
        if (event.isWin()) {
            promotion018SevenDayTargetService.setProgress(event.getRid(), TargetType.ADVEN_LEVEL, event.getBattleMissionId(), null);
        }
        //TODO 勇者试炼
        /*if(event.getMissionId() == 19){
            AdvenMissionService advenMissionService = SpringProxy.getBean(AdvenMissionService.class);
            AdvenMission advenMission = advenMissionService.getAdvenMission(event.getRid());
            if(advenMission.getMissionData().get(19) !=null){
                if(advenMission.getMissionData().get(19).getState() == 1){
                    promotion018SevenDayTargetService.setProgress(event.getRid(), TargetType.ADVEN_LEVEL, 15, null);
                }else {
                    promotion018SevenDayTargetService.setProgress(event.getRid(), TargetType.ADVEN_LEVEL, 14, null);
                }
            }
        }else {
            promotion018SevenDayTargetService.setProgress(event.getRid(), TargetType.ADVEN_LEVEL,
                    adventurerewardSysCache.getNotBoxMission(event.getMissionId()), null);
        }*/
    }

    @Subscribe
    public void listen(HeroUpLevelEvent event) {
        List<CPromotion018SevenDayTarget> configList = promotion018SevenDayTargetService.getConfig(TargetType.HAD_HIGH_LEVEL_HERO).stream()
                .filter(config -> config.getTask().getCondition() > event.getOriLevel() && config.getTask().getCondition() <= event
                        .getHero().getLevel()).collect(Collectors.toList());

        promotion018SevenDayTargetService.addProgress(event.getHero().getRid(), TargetType.HAD_HIGH_LEVEL_HERO, 1, configList);

    }

    @Subscribe
    public void listen(HeroGetEvent event) {
        this.getHero(event.getRid(), event.getHeros(), TargetType.GET_HERO);
        this.getHero(event.getRid(), event.getHeros(), TargetType.HAD_HIGH_STAR_HERO);
    }

    private void getHero(long rid, List<Hero> heroList, TargetType targetType) {

        promotion018SevenDayTargetService.getConfig(targetType).forEach(config -> {

            List<CPromotion018SevenDayTarget> configList = new ArrayList<>();
            configList.add(config);

            int addProgress = 0;
            if (config.getTask().getCondition() == 0) {
                addProgress = heroList.size();
            } else {
                addProgress = (int) heroList.stream().filter(hero -> hero.getStar() == config.getTask().getCondition()).count();
            }

            promotion018SevenDayTargetService.addProgress(rid, targetType, addProgress, configList);
        });
    }

    @Subscribe
    public void listen(DreamlandMaxLvEvent event) {
        promotion018SevenDayTargetService.setProgress(event.getRid(), TargetType.INFINITE_LEVEL, event.getMaxLv(), null);
    }

    @Subscribe
    public void listen(SpeedFightEvent event) {
        promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.QUICK_BATTLE, 1, null);
    }

    @Subscribe
    public void listen(TowerSweepEvent event) {
        promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.TOWER_CHALLENGE, 1, null);
    }

    @Subscribe
    public void listen(TowerChallengeEvent event) {
        promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.TOWER_CHALLENGE, 1, null);
    }

    @Subscribe
    public void listen(GoddessLevelUpOperatorEvent event) {
        promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.GODDESS_LEVEL_UP, 1, null);
    }

    @Subscribe
    public void listen(RuneCombineEvent event) {
        promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.COMBINE_RUNE, 1, null);
    }

    @Subscribe
    public void listen(JoinDailyDungeonEvent event) {
        promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.DAILY_DUNGEON_CHALLENGE, 1, null);
    }

    @Subscribe
    public void listen(ProphetSummonEvent event) {
        promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.PROPHECY, 1, null);
    }

    @Subscribe
    public void listen(DreamlandBattleEvent event) {
        promotion018SevenDayTargetService.addProgress(event.getRid(), TargetType.INFINITE_CHALLENGE, 1, null);
    }


}
