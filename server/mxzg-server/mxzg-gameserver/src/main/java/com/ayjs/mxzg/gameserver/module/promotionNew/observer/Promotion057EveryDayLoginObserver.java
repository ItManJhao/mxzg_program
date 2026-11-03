package com.ayjs.mxzg.gameserver.module.promotionNew.observer;


import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.achievement.event.DailyTaskRewardEvent;
import com.ayjs.mxzg.gameserver.module.clanworldboss.event.ClanWorldBossBattleEvent;
import com.ayjs.mxzg.gameserver.module.clergy.event.ClergyLevelEvent;
import com.ayjs.mxzg.gameserver.module.dungeon.event.DungeonBattleEndEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion057EveryDayLoginService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.prophetSummon.event.ProphetSummonEvent;
import com.ayjs.mxzg.gameserver.module.pvp.event.PvpEndEvent;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneCombineEvent;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneWashEvent;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion057EveryDayLoginConfig;
import org.springframework.beans.factory.annotation.Autowired;
import java.util.List;

/**
 * 每日登陆
 *
 * @author hyx
 */
@Observer
public class Promotion057EveryDayLoginObserver {

    @Autowired
    private Promotion057EveryDayLoginService promotion057EveryDayLoginService;
    @Autowired
    private PromotionControlService promotionControlService;

    /**
     * 增加进度
     *
     * @param rid
     * @param targetType
     * @param addProgress
     */
    private void addProgress(long rid, TargetType targetType, int addProgress) {
        List<Promotion057EveryDayLoginConfig> configList = promotion057EveryDayLoginService.getTaskTypeConfigs(targetType);
        if (!configList.isEmpty()) {
            promotion057EveryDayLoginService.addProgress(rid, addProgress, configList);
        }
    }

    /**
     * 替换进度
     *
     * @param rid
     * @param targetType
     * @param newProgress
     */
    private void setProgress(long rid, TargetType targetType, int newProgress) {
        List<Promotion057EveryDayLoginConfig> configList = promotion057EveryDayLoginService.getTaskTypeConfigs(targetType);
        if (!configList.isEmpty()) {
            promotion057EveryDayLoginService.setProgress(rid, newProgress, configList);
        }
    }

    @Subscribe
    public void listen(LoginEvent event) {
        if (promotionControlService.isPromotionRunning(PromotionType.MEI_RI_DENG_LU)) {
            this.addProgress(event.getRid(), TargetType.LOGIN, 1);
        }
    }

    @Subscribe
    public void listen(DailyTaskRewardEvent event) {
        if (promotionControlService.isPromotionRunning(PromotionType.MEI_RI_DENG_LU)) {
            this.addProgress(event.getRid(), TargetType.DAY_ACTIVE, event.getPoint());
        }
    }

    @Subscribe
    public void listen(RechargeEvent event) {
        if (promotionControlService.isPromotionRunning(PromotionType.MEI_RI_DENG_LU)) {
            this.addProgress(event.getRid(), TargetType.TOTAL_RECHARGE, event.getMoney());
            this.addProgress(event.getRid(), TargetType.RECHARGE, event.getMoney());
        }
    }

    @Subscribe
    public void listen(PvpEndEvent event) {
        if (promotionControlService.isPromotionRunning(PromotionType.MEI_RI_DENG_LU)) {
            this.addProgress(event.getRid(), TargetType.ARENA_CHALLENGE, 1);
        }
    }

    //世界BOSS挑战
    @Subscribe
    public void listen(ClanWorldBossBattleEvent event) {
        if (promotionControlService.isPromotionRunning(PromotionType.MEI_RI_DENG_LU)) {
            this.addProgress(event.getRid(), TargetType.CHALLENGE_WORLD_BOSS, 1);
        }
    }

    @Subscribe
    public void listen(DungeonBattleEndEvent event) {
        if (promotionControlService.isPromotionRunning(PromotionType.MEI_RI_DENG_LU)) {
            this.addProgress(event.getRid(), TargetType.SHELTER_KILL, 1);
        }
    }

    @Subscribe
    public void listen(ClergyLevelEvent event) {
        if (promotionControlService.isPromotionRunning(PromotionType.MEI_RI_DENG_LU)) {
            this.setProgress(event.getRid(), TargetType.CLERGY_LEVEL, event.getNewLevel());
        }
    }

    @Subscribe
    public void listen(ProphetSummonEvent event) {
        if (promotionControlService.isPromotionRunning(PromotionType.MEI_RI_DENG_LU)) {
            this.addProgress(event.getRid(), TargetType.PROPHECY, 1);
        }
    }

    @Subscribe
    public void listen(RuneCombineEvent event) {
        if (promotionControlService.isPromotionRunning(PromotionType.MEI_RI_DENG_LU)) {
            this.addProgress(event.getRid(), TargetType.COMBINE_RUNE, 1);
        }
    }

    @Subscribe
    public void listen(RuneWashEvent event) {
        if (promotionControlService.isPromotionRunning(PromotionType.MEI_RI_DENG_LU)) {
            this.addProgress(event.getRid(), TargetType.WASH_RUNE, 1);
        }
    }


    /*@Subscribe
    public void listen(TowerChallengeEvent event) {
        if (promotionControlService.isPromotionRunning(PromotionType.MEI_RI_DENG_LU)) {
            this.addProgress(event.getRid(), TargetType.TOWER_CHALLENGE, 1);
        }
    }

    @Subscribe
    public void listen(MakeEquipEvent event) {
        if (promotionControlService.isPromotionRunning(PromotionType.MEI_RI_DENG_LU)) {
            this.addProgress(event.getRid(), TargetType.COMBINE_EQUIP, event.getTimes());
        }
    }

    @Subscribe
    public void listen(HeroGetEvent event) {
        if (promotionControlService.isPromotionRunning(PromotionType.MEI_RI_DENG_LU)) {
            this.getHero(event.getRid(), event.getHeros());
        }
    }

    @Subscribe
    public void listen(HeroStarUpEvent event) {
        if (promotionControlService.isPromotionRunning(PromotionType.MEI_RI_DENG_LU)) {
            List<Hero> list = new ArrayList<>();
            list.add(event.getHero());
            this.getHero(event.getHero().getRid(), list);
        }
    }

    private void getHero(long rid, List<Hero> heroList) {
        promotion057EveryDayLoginService.getTaskTypeConfigs(TargetType.GET_HERO).forEach(config -> {

            List<Promotion057EveryDayLoginConfig> configList = new ArrayList<>();
            configList.add(config);

            int addProgress = 0;
            if (config.getTargetStruct().getCondition() == 0) {
                addProgress = heroList.size();
            } else {
                addProgress = (int) heroList.stream().filter(hero -> hero.getStar() == config.getTargetStruct().getCondition()).count();
            }

            promotion057EveryDayLoginService.addProgress(rid, addProgress, configList);
        });
    }

    @Subscribe
    public void listen(DailyTaskRewardEvent event) {
        if (promotionControlService.isPromotionRunning(PromotionType.MEI_RI_DENG_LU)) {
            this.addProgress(event.getRid(), TargetType.DAY_ACTIVE, event.getPoint());
        }
    }*/

}
