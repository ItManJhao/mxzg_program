package com.ayjs.mxzg.gameserver.module.promotionNew.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion064DragonBoatTaskSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion064DragonBoatTask;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.achievement.event.DailyTaskRewardEvent;
import com.ayjs.mxzg.gameserver.module.adven.event.AdvenPassEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.GemCostEvent;
import com.ayjs.mxzg.gameserver.module.buygold.event.BuyGoldEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDonateEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDungeonChallengeEvent;
import com.ayjs.mxzg.gameserver.module.clanworldboss.event.ClanWorldBossBattleEvent;
import com.ayjs.mxzg.gameserver.module.clergy.event.ClergyLevelEvent;
import com.ayjs.mxzg.gameserver.module.dailydungeon.event.JoinDailyDungeonEvent;
import com.ayjs.mxzg.gameserver.module.dungeon.event.DungeonBattleEndEvent;
import com.ayjs.mxzg.gameserver.module.friend.event.FriendGiveEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroSummonEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.SpeedFightEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion064DragonBoatService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.prophetSummon.event.ProphetSummonEvent;
import com.ayjs.mxzg.gameserver.module.pvp.event.PvpEndEvent;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneCombineEvent;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneWashEvent;
import com.ayjs.mxzg.gameserver.module.shop.event.ShopBuyEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerChallengeEvent;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerSweepEvent;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 龙舟活动
 *
 * @author hyx
 */
@Observer
public class Promotion064DragonBoatObserver {

    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private Promotion064DragonBoatService promotion064DragonBoatService;
    @Autowired
    private Promotion064DragonBoatTaskSysCache promotion064DragonBoatTaskSysCache;

    /**
     * 获取配置列表
     *
     * @param targetType
     * @param condition
     * @return
     */
    private List<CPromotion064DragonBoatTask> getConfigList(TargetType targetType, int condition) {
        List<CPromotion064DragonBoatTask> configList = promotion064DragonBoatTaskSysCache.getDayTask(promotion064DragonBoatService.getPromotionDay());
        return configList.stream().filter(config -> config.getTask_target().getType() == targetType &&
                (condition == 0 || TargetType.checkStruct(config.getTask_target(), condition, 0))).collect(Collectors.toList());
    }

    /**
     * 替换进度
     *
     * @param rid
     * @param targetType
     * @param newProgress
     */
    private void setProgress(long rid, TargetType targetType, long newProgress, int condition) {
        if (promotionControlService.isPromotionRunning(PromotionType.LONG_ZHOU_HOU_DONG)) {
            List<CPromotion064DragonBoatTask> configList = getConfigList(targetType, condition);
            if (!configList.isEmpty()) {
                promotion064DragonBoatService.setProgress(rid, configList, newProgress);
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
        if (promotionControlService.isPromotionRunning(PromotionType.LONG_ZHOU_HOU_DONG)) {
            List<CPromotion064DragonBoatTask> configList = getConfigList(targetType, condition);
            if (!configList.isEmpty()) {
                promotion064DragonBoatService.addProgress(rid, configList, addProgress);
            }
        }
    }

    @Subscribe
    public void listen(DailyTaskRewardEvent event) {
        this.addProgress(event.getRid(), TargetType.DAY_ACTIVE, event.getPoint(), 0);

    }

    @Subscribe
    public void listen(RechargeEvent event) {
        this.addProgress(event.getRid(), TargetType.TOTAL_RECHARGE, event.getMoney(), 0);
        this.addProgress(event.getRid(), TargetType.RECHARGE, event.getMoney(), 0);

    }

    //世界BOSS挑战
    @Subscribe
    public void listen(ClanWorldBossBattleEvent event) {
        this.addProgress(event.getRid(), TargetType.CHALLENGE_WORLD_BOSS, 1, 0);

    }

    @Subscribe
    public void listen(DungeonBattleEndEvent event) {
        this.addProgress(event.getRid(), TargetType.SHELTER_KILL, 1, 0);

    }

    @Subscribe
    public void listen(ClergyLevelEvent event) {
        this.setProgress(event.getRid(), TargetType.CLERGY_LEVEL, event.getNewLevel(), 0);

    }

    @Subscribe
    public void listen(ProphetSummonEvent event) {
        this.addProgress(event.getRid(), TargetType.PROPHECY, 1, 0);

    }

    @Subscribe
    public void listen(RuneCombineEvent event) {
        this.addProgress(event.getRid(), TargetType.COMBINE_RUNE, 1, 0);

    }

    @Subscribe
    public void listen(RuneWashEvent event) {
        this.addProgress(event.getRid(), TargetType.WASH_RUNE, 1, 0);

    }

    @Subscribe
    public void listen(GemCostEvent event) {
        this.addProgress(event.getRid(), TargetType.GEM_CONSUME, event.getCostCount(), 0);
    }

    @Subscribe
    public void listen(AdvenPassEvent event) {
        if (event.isWin()) {
            this.addProgress(event.getRid(), TargetType.PASS_ADVEN, 1, 0);
        }
    }

    @Subscribe
    public void listen(FriendGiveEvent event) {
        this.addProgress(event.getRid(), TargetType.FRIEND_GIFT, event.getGiveCount(), 0);
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
    public void listen(SpeedFightEvent event) {
        this.addProgress(event.getRid(), TargetType.QUICK_BATTLE, 1, 0);
    }

    @Subscribe
    public void listen(TowerChallengeEvent event) {
        this.addProgress(event.getRid(), TargetType.TOWER_CHALLENGE, 1, 0);
    }

    @Subscribe
    public void listen(TowerSweepEvent event) {
        this.addProgress(event.getRid(), TargetType.TOWER_CHALLENGE, 1, 0);
    }

    @Subscribe
    public void listen(ClanDungeonChallengeEvent event) {
        this.addProgress(event.getRid(), TargetType.CHALLENGE_CLAN_DUNGEON, 1, 0);
    }

    @Subscribe
    public void listen(ClanDonateEvent event) {
        this.addProgress(event.getRid(), TargetType.CLAN_DONATE, 1, 0);
    }

    @Subscribe
    public void listen(ShopBuyEvent event) {
        this.addProgress(event.getRid(), TargetType.SHOP_BUY, event.getBuyTimes(), event.getShopType().getValue());
    }

    @Subscribe
    public void listen(JoinDailyDungeonEvent event) {
        this.addProgress(event.getRid(), TargetType.DAILY_DUNGEON_CHALLENGE, 1, 0);
    }

    @Subscribe
    public void listen(HeroStarUpEvent event) {
        this.addProgress(event.getHero().getRid(), TargetType.COMBINE_HERO, 1, event.getHero().getStar());
    }

    @Subscribe
    public void listen(BuyGoldEvent event) {
        this.addProgress(event.getRid(), TargetType.BUY_GOLD, 1, event.getType().getValue());
    }


}





















