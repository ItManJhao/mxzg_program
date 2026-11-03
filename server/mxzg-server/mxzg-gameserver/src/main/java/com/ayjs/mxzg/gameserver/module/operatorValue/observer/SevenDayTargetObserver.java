package com.ayjs.mxzg.gameserver.module.operatorValue.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.module.adven.event.AdvenPassEvent;
import com.ayjs.mxzg.gameserver.module.battle.event.ChapterPassEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDonateEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroSummonEvent;
import com.ayjs.mxzg.gameserver.module.monthCard.constant.MonthCardType;
import com.ayjs.mxzg.gameserver.module.monthCard.event.MonthCardActiveEvent;
import com.ayjs.mxzg.gameserver.module.operatorValue.constant.OperatorType;
import com.ayjs.mxzg.gameserver.module.operatorValue.event.SevenDayTargetValueEvent;
import com.ayjs.mxzg.gameserver.module.operatorValue.service.OperatorValueService;
import com.ayjs.mxzg.gameserver.module.pvp.event.PvpEndEvent;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;
import com.ayjs.mxzg.gameserver.module.role.constant.RoleParamType;
import com.ayjs.mxzg.gameserver.module.role.domain.RoleParam;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.event.ZeroTimeEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleParamService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskRewardEvent;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/14 10:14
 */
@Observer
@Slf4j
public class SevenDayTargetObserver {
    @Autowired
    private RoleService roleService;
    @Autowired
    OperatorValueService operatorValueService;
    @Autowired
    EventBus eventBus;
    @Autowired
    RoleParamService roleParamService;

    @Subscribe
    public void login(LoginEvent event) {
        long rid = event.getRid();

        RoleParam roleParam = roleParamService.getOrCreate(rid, RoleParamType.SEVEN_DAY_COUNT_TIME, () ->
                (int) (roleService.getOrThrow(rid).getLastOfflineTime() / TimeDateUtil.ONESECOND));

        Long lastTime = Long.valueOf(roleParam.getRpValue());
        if (lastTime > Integer.MAX_VALUE) {
            if (TimeDateUtil.isToday(lastTime)) {
                return;
            }
        } else {
            if (TimeDateUtil.isToday(Integer.valueOf(roleParam.getRpValue()))) {
                return;
            }
        }
        roleParam.setRpValue(TimeDateUtil.getCurrentTimeInt() + "");
        roleParamService.update(roleParam);

        int newValue2 = operatorValueService.addProcess(rid, OperatorType.SEVEN_LOGIN_DAY, 1);
        eventBus.post(SevenDayTargetValueEvent.of(rid, OperatorType.SEVEN_LOGIN_DAY, newValue2, 1));
    }

    @Subscribe
    public void zeroTime(ZeroTimeEvent event) {
        long rid = event.getRid();

        RoleParam roleParam = roleParamService.getOrCreate(rid, RoleParamType.SEVEN_DAY_COUNT_TIME, () ->
                (int) (roleService.getOrThrow(rid).getLastOfflineTime() / TimeDateUtil.ONESECOND));
        roleParam.setRpValue(TimeDateUtil.getCurrentTimeInt() + "");
        roleParamService.update(roleParam);

        int newValue2 = operatorValueService.addProcess(rid, OperatorType.SEVEN_LOGIN_DAY, 1);
        eventBus.post(SevenDayTargetValueEvent.of(rid, OperatorType.SEVEN_LOGIN_DAY, newValue2, 1));
    }

    /***
     * 累计充值
     * @param event
     */
    @Subscribe
    public void recharge(RechargeEvent event) {
        long rid = event.getRid();
        int newValue = operatorValueService.addProcess(rid, OperatorType.SEVEN_RECHARGE, event.getMoney());
        eventBus.post(SevenDayTargetValueEvent.of(rid, OperatorType.SEVEN_RECHARGE, newValue, 1));
    }

    /***
     * 关卡通关
     * @param event
     */
    @Subscribe
    public void passChapter(ChapterPassEvent event) {
        long rid = event.getRid();
        int addValue = operatorValueService.setProcess(rid, OperatorType.SEVEN_CHAPTER_NUM, event.getMissionId());
        eventBus.post(SevenDayTargetValueEvent.of(rid, OperatorType.SEVEN_CHAPTER_NUM, event.getMissionId(), addValue));
    }

    @Subscribe
    public void clanDonate(ClanDonateEvent event) {
        long rid = event.getRid();
        int newValue = operatorValueService.addProcess(rid, OperatorType.SEVEN_CLAN_DONATE, 1);
        eventBus.post(SevenDayTargetValueEvent.of(rid, OperatorType.SEVEN_CLAN_DONATE, newValue, 1));
    }

    @Subscribe
    public void heroSummon(HeroSummonEvent event) {
        long rid = event.getRid();
        int newValue = operatorValueService.addProcess(rid, OperatorType.SEVEN_HERO_SUMMON, event.getSummonCount());
        eventBus.post(SevenDayTargetValueEvent.of(rid, OperatorType.SEVEN_HERO_SUMMON, newValue, event.getSummonCount()));
    }

    /***
     * pvp挑战
     * @param event
     */
    @Subscribe
    public void pvpChallenge(PvpEndEvent event) {
        long rid = event.getRid();
        int newValue = operatorValueService.addProcess(rid, OperatorType.SEVEN_JOIN_ARENA, 1);
        eventBus.post(SevenDayTargetValueEvent.of(rid, OperatorType.SEVEN_JOIN_ARENA, newValue, 1));
    }

    @Subscribe
    public void tavernTaskStart(TavernTaskRewardEvent event) {
        long rid = event.getRid();
        int newValue = operatorValueService.addProcess(rid, OperatorType.SEVEN_TAVERN_TASK, event.getTaskIds().size());
        eventBus.post(SevenDayTargetValueEvent.of(rid, OperatorType.SEVEN_TAVERN_TASK, newValue, event.getTaskIds().size()));
    }

    /*   @Subscribe
       public void addTavernTask(TavernTaskRewardEvent event) {
           long rid = event.getRid();
           int newValue = operatorValueService.addProcess(rid, OperatorType.SEVEN_ADD_TAVERN_TASK, 1);
           eventBus.post(SevenDayTargetValueEvent.of(rid, OperatorType.SEVEN_ADD_TAVERN_TASK, newValue, 1));
       }
   */
    @Subscribe
    public void passAdven(AdvenPassEvent event) {
        long rid = event.getRid();
        int newValue = operatorValueService.addProcess(rid, OperatorType.SEVEN_ADVEN_BATTLE_WIN, 1);
        eventBus.post(SevenDayTargetValueEvent.of(rid, OperatorType.SEVEN_ADVEN_BATTLE_WIN, newValue, 1));
    }


    @Subscribe
    public void heroGet(HeroGetEvent event) {
        long rid = event.getRid();
        event.getHeros().forEach(hero -> {
            OperatorType type = null;
            switch (hero.getStar()) {
                case 5:
                    type = OperatorType.SEVEN_UP_FIVE_HERO;
                    break;
                case 6:
                    type = OperatorType.SEVEN_UP_SIX_HERO;
                    break;
                case 7:
                    type = OperatorType.SEVEN_UP_SEVEN_HERO;
                    break;
                case 8:
                    type = OperatorType.SEVEN_UP_EIGHT_HERO;
                    break;
                case 9:
                    type = OperatorType.SEVEN_UP_NINE_HERO;
                    break;
                case 10:
                    type = OperatorType.SEVEN_UP_TEN_HERO;
                    break;
                case 11:
                    type = OperatorType.SEVEN_UP_ELEVEN_HERO;
                    break;
                case 12:
                    type = OperatorType.SEVEN_UP_TWELVE_HERO;
                    break;
                case 13:
                    type = OperatorType.SEVEN_UP_THIRTEEN_HERO;
                    break;
                default:
                    break;
            }
            if (type == null) {
                return;
            }
            int newValue = operatorValueService.addProcess(rid, type, 1);
            eventBus.post(SevenDayTargetValueEvent.of(rid, type, newValue, 1));
        });
    }

    /**
     * 升星事件
     *
     * @param event
     */
    @Subscribe
    public void heroGet(HeroStarUpEvent event) {
        long rid = event.getHero().getRid();
        OperatorType type = null;

        switch (event.getHero().getStar()) {
            case 5:
                type = OperatorType.SEVEN_UP_FIVE_HERO;
                break;
            case 6:
                type = OperatorType.SEVEN_UP_SIX_HERO;
                break;
            case 7:
                type = OperatorType.SEVEN_UP_SEVEN_HERO;
                break;
            case 8:
                type = OperatorType.SEVEN_UP_EIGHT_HERO;
                break;
            case 9:
                type = OperatorType.SEVEN_UP_NINE_HERO;
                break;
            case 10:
                type = OperatorType.SEVEN_UP_TEN_HERO;
                break;
            case 11:
                type = OperatorType.SEVEN_UP_ELEVEN_HERO;
                break;
            case 12:
                type = OperatorType.SEVEN_UP_TWELVE_HERO;
                break;
            case 13:
                type = OperatorType.SEVEN_UP_THIRTEEN_HERO;
                break;
            default:
                break;
        }
        if (type == null) {
            return;
        }
        int newValue = operatorValueService.addProcess(rid, type, 1);
        eventBus.post(SevenDayTargetValueEvent.of(rid, type, newValue, 1));

    }

    @Subscribe
    public void activeMonthCard(MonthCardActiveEvent event) {
        if (event.getType() == MonthCardType.BEST.getType()) {
            int newValue = operatorValueService.addProcess(event.getRid(), OperatorType.ACTIVE_BEST_MONTH_CARD, 1);
            eventBus.post(SevenDayTargetValueEvent.of(event.getRid(), OperatorType.ACTIVE_BEST_MONTH_CARD, newValue, 1));
        }
    }

}
