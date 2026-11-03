package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion064DragonBoatCardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion064DragonBoatTaskSysCache;
import com.ayjs.mxzg.config.excel.constant.DragonBoatConst;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion061ThreeDayTask;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion061ThreeDayTaskReward;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion064DragonBoatTask;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.domain.BackPack;
import com.ayjs.mxzg.gameserver.module.backpack.service.BackPackService;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion064DragonBoatDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion061ThreeDayTask;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion064DragonBoat;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.DragonBoatEvent;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.module.targetCounter.service.TargetCounterService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion058HighWeeksCardConfig;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion064DragonBoatConfig;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion061GMsg;
import com.ayjs.mxzg.protocol.Promotion064GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * 龙舟
 *
 * @author hyx
 */
@Service
@Observer
public class Promotion064DragonBoatService extends BasePromotionService<Promotion064DragonBoat> implements IRechargeBuyingService {

    @Autowired
    private Promotion064DragonBoatDao promotion064DragonBoatDao;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private Promotion064DragonBoatTaskSysCache promotion064DragonBoatTaskSysCache;
    @Autowired
    private TargetCounterService targetCounterService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private Promotion064DragonBoatCardSysCache promotion064DragonBoatCardSysCache;
    @Autowired
    private BackPackService backPackService;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.LONG_ZHOU_HOU_DONG;
    }

    @Override
    public IRepository<Promotion064DragonBoat> getRepository() {
        return promotion064DragonBoatDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion064DragonBoat promotion, PromotionControl control) {
        promotion.setDailyTime(0);
        promotion.getTaskList().clear();
        promotion.getTaskRewards().clear();
        promotion.getBoxRewards().clear();
        promotion.setCardTurns(1);
        promotion.setNum(0);
        promotion.setTargetIdx(0);
        promotion.setTargetStatus(0);
        promotion.getGrids().clear();
        promotion.getBuyList().clear();
        promotion.getCardNum().clear();
    }

    @Override
    public void handleOnPromotionClear(PromotionControl control) {
        int itemType = DragonBoatConst.PROMOTION_DRAGON_BOAT_COST.get(0).getItem_type();
        getAllPromotionInfo().forEach(promotion064DragonBoat -> {
            BackPack backPack = backPackService.getBackPack(promotion064DragonBoat.getRid(), itemType);
            if (backPack != null && backPack.getNum() > 0) {
                thingService.cost(promotion064DragonBoat.getRid(), ImmutableThing.of(backPack.getItemId(), backPack.getNum()),
                        GameEvent.PROMOTION_CLEAN_BACKPACK);
            }
        });
    }

    @Override
    public Promotion064DragonBoat getPromotionInfo(long rid) {
        Promotion064DragonBoat promotion064DragonBoat = super.getPromotionInfo(rid);
        if (promotionControlService.isPromotionRunning(thisPromotionType())) {
            if (promotion064DragonBoat.getDailyTime() < DateTimeUtil.dayBreak() &&
                    promotion064DragonBoatTaskSysCache.getMaxTurns() >= getPromotionDay()) {
                //重制时间，清楚宝箱和任务领取记录
                promotion064DragonBoat.setDailyTime(DateTimeUtil.currentSecond());
                promotion064DragonBoat.getTaskList().clear();
                promotion064DragonBoat.getTaskRewards().clear();
                promotion064DragonBoat.getBoxRewards().clear();
                //重新生成任务
                List<CPromotion064DragonBoatTask> taskList = promotion064DragonBoatTaskSysCache.getDayTask(getPromotionDay());
                taskList.forEach(config -> {
                    TargetStruct targetStruct = config.getTask_target();
                    if (targetStruct.getType() == TargetType.LOGIN) {
                        promotion064DragonBoat.getTaskList().put(config.getIdx(), 1L);
                    } else if (targetStruct.getType() == TargetType.PASS_MAIN_LEVEL) {
                        promotion064DragonBoat.getTaskList().put(config.getIdx(), targetCounterService.calcTaskCount(rid, targetStruct));
                    } else {
                        promotion064DragonBoat.getTaskList().put(config.getIdx(), (long) targetCounterService.calcCount(rid, targetStruct));
                    }
                });
                this.updatePromotion(promotion064DragonBoat);
            }
            //如果以翻完当前轮所有卡牌
            if (promotion064DragonBoat.getNum() == DragonBoatConst.PROMOTION_DRAGON_BOAT_CARD_COUNT &&
                    promotion064DragonBoat.getCardTurns() < promotion064DragonBoatCardSysCache.getMaxTurns()) {
                //当轮次小最大轮时，重制卡牌
                promotion064DragonBoat.setCardTurns(promotion064DragonBoat.getCardTurns() + 1);
                promotion064DragonBoat.setTargetIdx(0);
                promotion064DragonBoat.setTargetStatus(0);
                promotion064DragonBoat.setNum(0);
                promotion064DragonBoat.getGrids().clear();
                promotion064DragonBoat.getCardNum().clear();
                this.updatePromotion(promotion064DragonBoat);
            }
        }
        return promotion064DragonBoat;
    }

    public int getPromotionDay() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        return DateTimeUtil.apartDay(DateTimeUtil.currentSecond(), promotionControl.getStartTime()) + 1;
    }

    /**
     * 获取活动商品配置
     *
     * @return
     */
    public Collection<Promotion064DragonBoatConfig> getProductConfig() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        return promotionControl.getAllConfig(Promotion064DragonBoatConfig.class);
    }

    /**
     * 获取龙舟礼包数据
     *
     * @param productId
     * @return
     */
    private Promotion064DragonBoatConfig getProduct(int productId) {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        Promotion064DragonBoatConfig promotion064DragonBoatConfig = null;
        for (Promotion064DragonBoatConfig config : promotionControl.getAllConfig(Promotion064DragonBoatConfig.class)) {
            if (config.getProduct_id() == productId) {
                promotion064DragonBoatConfig = config;
            }
        }
        Asserts.notNull(promotion064DragonBoatConfig, ErrorCode.CONFIG_NOT_EXISTS.getValue(), String.format("龙舟活动不存在该商品:{%s}", productId));
        return promotion064DragonBoatConfig;
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.LONG_ZHOU;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            return false;
        }

        Promotion064DragonBoatConfig config = this.getProduct(productId);
        Promotion064DragonBoat promotion064DragonBoat = this.getPromotionInfo(rid);
        return promotion064DragonBoat.getBuyList().getOrDefault(config.getIdx(), 0) < config.getBuy_limit();
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        Promotion064DragonBoatConfig config = this.getProduct(cBuyGem.getIdx());

        Promotion064DragonBoat promotion064DragonBoat = this.getPromotionInfo(rid);
        promotion064DragonBoat.getBuyList().put(config.getIdx(), promotion064DragonBoat.getBuyList().getOrDefault(config.getIdx(), 0) + 1);

        updatePromotion(promotion064DragonBoat);

        thingService.add(rid, ImmutableThingUtil.fromJson(config.getReward()), GameEvent.PROMOTION_DRAGON_BOAT_PRODUCT);

        //发送直购商品数据
        Promotion064GMsg.GResDragonBoatBuyInfo.Builder builder = this.sendProductInfo(promotion064DragonBoat);
        contextManager.write(rid, CmdCode._13252, builder.build());
    }

    private Promotion064GMsg.GResDragonBoatBuyInfo.Builder sendProductInfo(Promotion064DragonBoat promotion064DragonBoat) {
        Promotion064GMsg.GResDragonBoatBuyInfo.Builder builder = Promotion064GMsg.GResDragonBoatBuyInfo.newBuilder();
        getProductConfig().forEach(config -> {
            ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
            data.setKey(config.getIdx());
            data.setValue(promotion064DragonBoat.getBuyList().getOrDefault(config.getIdx(), 0));
            builder.addBuy(data);
        });
        return builder;
    }

    /**
     * 更新进度
     *
     * @param rid
     * @param configList
     * @param newProgress
     */
    public void setProgress(long rid, List<CPromotion064DragonBoatTask> configList, long newProgress) {
        Promotion064DragonBoat promotion064DragonBoat = this.getPromotionInfo(rid);

        List<ObjectGMsg.PSTaskProgress> builderList = new ArrayList<>();
        configList.stream().filter(config -> !promotion064DragonBoat.getTaskRewards().contains(config.getIdx())
                && promotion064DragonBoat.getTaskList().getOrDefault(config.getIdx(), 0L) < newProgress).forEach(config -> {

            promotion064DragonBoat.getTaskList().put(config.getIdx(), newProgress);
            builderList.add(builderTask(config.getIdx(), promotion064DragonBoat.getTaskList().get(config.getIdx())).build());
        });
        if (!builderList.isEmpty()) {
            this.updatePromotion(promotion064DragonBoat);
            //发送更新的任务数据
            this.sendUpdateTaskProgress(rid, builderList);
        }
    }

    /**
     * 更新进度
     *
     * @param rid
     * @param configList
     * @param addProgress
     */
    public void addProgress(long rid, List<CPromotion064DragonBoatTask> configList, long addProgress) {
        Promotion064DragonBoat promotion064DragonBoat = this.getPromotionInfo(rid);

        List<ObjectGMsg.PSTaskProgress> builderList = new ArrayList<>();
        configList.stream().filter(config -> !promotion064DragonBoat.getTaskRewards().contains(config.getIdx())).forEach(config -> {

            long count = promotion064DragonBoat.getTaskList().getOrDefault(config.getIdx(), 0L);
            promotion064DragonBoat.getTaskList().put(config.getIdx(), count + addProgress);

            builderList.add(builderTask(config.getIdx(), promotion064DragonBoat.getTaskList().get(config.getIdx())).build());
        });

        if (!builderList.isEmpty()) {
            this.updatePromotion(promotion064DragonBoat);
            //发送更新的任务数据
            this.sendUpdateTaskProgress(rid, builderList);
        }
    }

    public ObjectGMsg.PSTaskProgress.Builder builderTask(int idx, long progress) {
        ObjectGMsg.PSTaskProgress.Builder builder = ObjectGMsg.PSTaskProgress.newBuilder();
        builder.setIdx(idx);
        CPromotion064DragonBoatTask config = promotion064DragonBoatTaskSysCache.getOrThrow(idx);
        long count = Math.min(config.getTask_target().getTarget(), progress);
        builder.setProgress(count);
        return builder;
    }

    /**
     * 发送更新进度
     *
     * @param rid
     * @param builderList
     */
    private void sendUpdateTaskProgress(long rid, List<ObjectGMsg.PSTaskProgress> builderList) {
        if (!builderList.isEmpty()) {
            Promotion064GMsg.GResTaskProgress.Builder builder = Promotion064GMsg.GResTaskProgress.newBuilder();
            builder.addAllTask(builderList);
            contextManager.write(rid, CmdCode._13257, builder.build());
        }
    }

}
