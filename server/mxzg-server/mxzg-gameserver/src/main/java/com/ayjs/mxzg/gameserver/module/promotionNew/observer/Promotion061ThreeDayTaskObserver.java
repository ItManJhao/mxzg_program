package com.ayjs.mxzg.gameserver.module.promotionNew.observer;


import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.cache.TavernSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion061ThreeDayTaskSysCache;
import com.ayjs.mxzg.config.excel.entity.CTavern;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion061ThreeDayTask;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.achievement.event.DailyTaskRewardEvent;
import com.ayjs.mxzg.gameserver.module.adven.event.AdvenPassEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.GemCostEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.MakeEquipEvent;
import com.ayjs.mxzg.gameserver.module.battle.event.ChapterPassEvent;
import com.ayjs.mxzg.gameserver.module.blessingPool.event.BlessingPoolDoneEvent;
import com.ayjs.mxzg.gameserver.module.buygold.event.BuyGoldEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDonateEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDungeonChallengeEvent;
import com.ayjs.mxzg.gameserver.module.clanworldboss.event.ClanWorldBossBattleEvent;
import com.ayjs.mxzg.gameserver.module.clergy.event.ClergyLevelEvent;
import com.ayjs.mxzg.gameserver.module.dailydungeon.event.JoinDailyDungeonEvent;
import com.ayjs.mxzg.gameserver.module.dreamland.event.DreamlandBattleEvent;
import com.ayjs.mxzg.gameserver.module.dreamland.event.DreamlandMaxLvEvent;
import com.ayjs.mxzg.gameserver.module.dungeon.event.DungeonBattleEndEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessLevelUpEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessLevelUpOperatorEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessUnlockEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroSummonEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroUpLevelEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.SpeedFightEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion061ThreeDayTaskService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.prophetSummon.event.ProphetSummonEvent;
import com.ayjs.mxzg.gameserver.module.pvp.event.PvpEndEvent;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.event.RoleLvUpEvent;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneCombineEvent;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneWashEvent;
import com.ayjs.mxzg.gameserver.module.shop.event.ShopBuyEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskRefreshEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskRewardEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskStartEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerChallengeEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerPassEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerSweepEvent;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 三日任务
 *
 * @author hyx
 */
@Observer
public class Promotion061ThreeDayTaskObserver {

    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private Promotion061ThreeDayTaskService promotion061ThreeDayTaskService;
    @Autowired
    private Promotion061ThreeDayTaskSysCache promotion061ThreeDayTaskSysCache;
    @Autowired
    private TavernSysCache tavernSysCache;

    /**
     * 获取当前活动天的某任务类型
     *
     * @param targetType
     * @return
     */
    private List<CPromotion061ThreeDayTask> getConfig(TargetType targetType) {
        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.SAN_RI_REN_WU);
        int day = promotion061ThreeDayTaskService.getPromotionDay();
        List<CPromotion061ThreeDayTask> configList = promotion061ThreeDayTaskSysCache.getTurnsTask(promotionControl.getTurns());
        configList = configList.stream().filter(config -> config.getTask().getType() == targetType && config.getDay() <= day).collect(Collectors.toList());
        return configList;
    }

    /**
     * 替换进度
     *
     * @param rid
     * @param targetType
     * @param newProgress
     */

    private void setProgress(long rid, TargetType targetType, long newProgress) {
        if (promotionControlService.isPromotionRunning(PromotionType.SAN_RI_REN_WU)) {
            List<CPromotion061ThreeDayTask> configList = this.getConfig(targetType);
            if (!configList.isEmpty()) {
                promotion061ThreeDayTaskService.setProgress(rid, configList, newProgress);
            }
        }
    }


    /**
     * 增加进度
     *
     * @param rid
     * @param targetType
     * @param addProgress
     * @param condition   子检查条件
     */
    private void addProgress(long rid, TargetType targetType, long addProgress, int condition) {
        if (promotionControlService.isPromotionRunning(PromotionType.SAN_RI_REN_WU)) {
            List<CPromotion061ThreeDayTask> configList = this.getConfig(targetType).stream().filter(task ->
                    TargetType.checkStruct(task.getTask(), condition, 0)).collect(Collectors.toList());
            if (!configList.isEmpty()) {
                promotion061ThreeDayTaskService.addProgress(rid, configList, addProgress);
            }
        }
    }

    @Subscribe
    public void listen(HeroSummonEvent event) {
        this.addProgress(event.getRid(), TargetType.SUMMON, event.getSummonCount(), event.getType().getType());
    }

    @Subscribe
    public void listen(PvpEndEvent event) {
        this.addProgress(event.getRid(), TargetType.ARENA_CHALLENGE, 1, 0);
    }

    @Subscribe
    public void listen(BuyGoldEvent event) {
        this.addProgress(event.getRid(), TargetType.BUY_GOLD, 1, event.getType().getValue());
    }

    @Subscribe
    public void listen(TowerSweepEvent event) {
        this.addProgress(event.getRid(), TargetType.TOWER_CHALLENGE, 1, 0);
    }

    @Subscribe
    public void listen(TowerChallengeEvent event) {
        this.addProgress(event.getRid(), TargetType.TOWER_CHALLENGE, 1, 0);
    }

    @Subscribe
    public void listen(GemCostEvent event) {
        this.addProgress(event.getRid(), TargetType.GEM_CONSUME, event.getCostCount(), 0);
    }

    @Subscribe
    public void listen(ShopBuyEvent event) {
        this.addProgress(event.getRid(), TargetType.SHOP_BUY, event.getBuyTimes(), event.getShopType().getValue());
    }

    @Subscribe
    public void listen(RechargeEvent event) {
        this.addProgress(event.getRid(), TargetType.RECHARGE, event.getMoney(), 0);
    }

    @Subscribe
    public void listen(SpeedFightEvent event) {
        this.addProgress(event.getRid(), TargetType.QUICK_BATTLE, 1, 0);
    }

}
