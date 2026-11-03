package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.PromotionTrafficPermitGiftSysCache;
import com.ayjs.mxzg.config.excel.cache.PromotionTrafficPermitRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.PromotionTrafficPermitSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.PromotionItemRetrieveSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.CPromotionTrafficPermit;
import com.ayjs.mxzg.config.excel.entity.CPromotionTrafficPermitGift;
import com.ayjs.mxzg.config.excel.entity.CPromotionTrafficPermitReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.domain.BackPack;
import com.ayjs.mxzg.gameserver.module.backpack.service.BackPackService;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion053TrafficPermitDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion053TrafficPermit;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.TrafficPermitTaskProgress;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.TrafficPermitTaskType;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion053GMsg;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 通行证(运营活动)
 *
 * @author hyx
 */
@Service
@Slf4j
public class Promotion053TrafficPermitService extends BasePromotionService<Promotion053TrafficPermit> implements IRechargeBuyingService {

    @Autowired
    private Promotion053TrafficPermitDao promotion053TrafficPermitDao;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private PromotionTrafficPermitSysCache promotionTrafficPermitSysCache;
    @Autowired
    private PromotionTrafficPermitGiftSysCache promotionTrafficPermitGiftSysCache;
    @Autowired
    private PromotionTrafficPermitRewardSysCache promotionTrafficPermitRewardSysCache;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private ThingService thingService;
    @Autowired
    private BackPackService backPackService;
    @Autowired
    private PromotionItemRetrieveSysCache promotionItemRetrieveSysCache;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.TONG_XING_XHENG;
    }

    @Override
    public IRepository<Promotion053TrafficPermit> getRepository() {
        return promotion053TrafficPermitDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion053TrafficPermit promotion, PromotionControl control) {
        promotion.setResetTime(0);
        promotion.setDayTurns(0);
        promotion.setWeekTurns(0);
        promotion.setBuyPrivilege(0);
        promotion.setExp(0);
        promotion.setLevel(0);
        promotion.getFinishList().clear();
        promotion.getPrivilegeList().clear();
        promotion.getDayTask().clear();
        promotion.getWeekTask().clear();
        promotion.getUltimateTask().clear();
    }

    @Override
    public void handleOnPromotionClear(PromotionControl control) {
        //回收的道具id
        int itemType = promotionItemRetrieveSysCache.getOrThrow(control.getType()).getRetrieve_item();

        List<Promotion053TrafficPermit> promotionList = getAllPromotionInfo();
        promotionList.stream().filter(promotion -> promotion.getTurnsTime() == control.getTurnsTime()).forEach(promotion -> {
            BackPack backPack = backPackService.getBackPack(promotion.getRid(), itemType);
            if (backPack != null) {
                ImmutableThing immutableThing = ImmutableThing.of(backPack.getItemId(), backPack.getNum());
                if (immutableThing.getNum() > 0) {
                    thingService.cost(promotion.getRid(), immutableThing, GameEvent.TRAFFIC_PERMIT_EXP);
                }
            }
        });
    }

    /**
     * 获取当前每日任务的轮次
     *
     * @param promotionControl
     * @return
     */
    private int dayTurns(PromotionControl promotionControl) {
        //活动已开始天数
        int notDayTime = (DateTimeUtil.apartDay(promotionControl.getStartTime(), DateTimeUtil.currentSecond()));
        //当前执行的每日任务轮次
        return notDayTime % promotionTrafficPermitSysCache.getTaskTypeTurns(promotionControl.getTurns(), TrafficPermitTaskType.DAY_TASK.getValue()) + 1;
    }

    /**
     * 获取当前每周任务的轮次
     *
     * @param promotionControl
     * @return
     */
    private int weekTurns(PromotionControl promotionControl) {
        //活动已开始天数
        int notDayTime = (DateTimeUtil.apartDay(promotionControl.getStartTime(), DateTimeUtil.currentSecond()));
        //当前执行的每周任务轮次
        return (notDayTime / 7 %
                promotionTrafficPermitSysCache.getTaskTypeTurns(promotionControl.getTurns(), TrafficPermitTaskType.WEEK_TASK.getValue())) + 1;
    }


    public Promotion053TrafficPermit getPromotionOrRefresh(long rid) {
        Promotion053TrafficPermit promotion053TrafficPermit = this.getPromotionInfo(rid);
        if (!promotionControlService.isPromotionRunning(PromotionType.TONG_XING_XHENG)) {
            return promotion053TrafficPermit;
        }
        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.TONG_XING_XHENG);
        int dayTurns = dayTurns(promotionControl);
        int weekTurns = weekTurns(promotionControl);
        if (weekTurns != promotion053TrafficPermit.getWeekTurns()) {
            //周任务的重制必然会重制每日任务
            resetWeekTask(promotion053TrafficPermit, promotionControl.getTurns(), dayTurns, weekTurns);
        } else {
            //上一次相同轮次的任务
            if (DateTimeUtil.apartDay(promotion053TrafficPermit.getResetTime(), DateTimeUtil.currentSecond()) > 7) {
                resetWeekTask(promotion053TrafficPermit, promotionControl.getTurns(), dayTurns, weekTurns);
            } else {
                //重制每日任务
                if (dayTurns != promotion053TrafficPermit.getDayTurns()) {
                    resetDayTask(promotion053TrafficPermit, promotionControl.getTurns(), dayTurns);
                } else {
                    //上一次相同轮次的任务
                    if (DateTimeUtil.apartDay(promotion053TrafficPermit.getResetTime(), DateTimeUtil.currentSecond()) > 1) {
                        resetDayTask(promotion053TrafficPermit, promotionControl.getTurns(), dayTurns);
                    }
                }
            }
        }
        if (promotion053TrafficPermit.getUltimateTask().size() == 0) {
            promotion053TrafficPermit.setUltimateTask(resetTask(promotionControl.getTurns(), TrafficPermitTaskType.Month_TASK, 1));
        }
        return promotion053TrafficPermit;
    }

    /**
     * 重制每周任务
     *
     * @param promotion053TrafficPermit
     * @param dayTurns
     * @param weekTurns
     */
    private void resetWeekTask(Promotion053TrafficPermit promotion053TrafficPermit, int configTurns, int dayTurns, int weekTurns) {
        promotion053TrafficPermit.setWeekTurns(weekTurns);
        promotion053TrafficPermit.setResetTime(DateTimeUtil.currentSecond());
        //重制任务
        promotion053TrafficPermit.setWeekTask(resetTask(configTurns, TrafficPermitTaskType.WEEK_TASK, weekTurns));
        //重制每日任务
        this.resetDayTask(promotion053TrafficPermit, configTurns, dayTurns);
        updatePromotion(promotion053TrafficPermit);
    }

    /**
     * 重制每日任务
     *
     * @param promotion053TrafficPermit
     * @param dayTurns
     */
    private void resetDayTask(Promotion053TrafficPermit promotion053TrafficPermit, int configTurns, int dayTurns) {
        promotion053TrafficPermit.setDayTurns(dayTurns);
        promotion053TrafficPermit.setResetTime(DateTimeUtil.currentSecond());
        //重制任务
        promotion053TrafficPermit.setDayTask(resetTask(configTurns, TrafficPermitTaskType.DAY_TASK, dayTurns));
        //查看是否开通特权，领取每日赠送经验
        if (promotion053TrafficPermit.getBuyPrivilege() == 1) {
            CPromotionTrafficPermitGift giftConfig = promotionTrafficPermitGiftSysCache.getOrThrow(1);
            addExp(promotion053TrafficPermit, giftConfig.getDay_point());
        }
        updatePromotion(promotion053TrafficPermit);
    }

    /**
     * 重制任务
     *
     * @param taskType
     * @param turns
     * @return
     */
    private Map<Integer, TrafficPermitTaskProgress> resetTask(int configTurns, TrafficPermitTaskType taskType, int turns) {
        List<CPromotionTrafficPermit> taskList = promotionTrafficPermitSysCache.getTaskList(configTurns, taskType.getValue(), turns);
        Map<Integer, TrafficPermitTaskProgress> taskMap = new HashMap<>();
        for (CPromotionTrafficPermit config : taskList) {
            TrafficPermitTaskProgress progress = new TrafficPermitTaskProgress();
            taskMap.put(config.getIdx(), progress);
        }
        return taskMap;
    }

    /**
     * 获取指定类型的任务
     *
     * @param targetType
     * @return
     */
    public List<CPromotionTrafficPermit> getTargetTaskList(TargetType targetType) {
        List<CPromotionTrafficPermit> list = new ArrayList<>();
        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.TONG_XING_XHENG);
        if (promotionControlService.isPromotionRecording(thisPromotionType())) {
            //找出当前轮每日任务相同类型的任务
            promotionTrafficPermitSysCache.getTaskList(promotionControl.getTurns(), TrafficPermitTaskType.DAY_TASK.getValue(), dayTurns(promotionControl))
                    .stream().filter(config -> config.getMission().getType() == targetType).forEach(list::add);
            //找出当前轮每周任务相同类型的任务
            promotionTrafficPermitSysCache.getTaskList(promotionControl.getTurns(), TrafficPermitTaskType.WEEK_TASK.getValue(), weekTurns(promotionControl))
                    .stream().filter(config -> config.getMission().getType() == targetType).forEach(list::add);
            //找出相同类型的终极任务
            promotionTrafficPermitSysCache.getTaskList(promotionControl.getTurns(), TrafficPermitTaskType.Month_TASK.getValue(), 1)
                    .stream().filter(config -> config.getMission().getType() == targetType).forEach(list::add);
        }
        return list;
    }

    /**
     * 更新任务
     *
     * @param rid
     * @param config
     * @param addCount
     * @param type     1:替换,0:增加
     */
    public void updatePromotionTask(long rid, CPromotionTrafficPermit config, int addCount, int type) {
        Promotion053TrafficPermit promotion053TrafficPermit = this.getPromotionOrRefresh(rid);
        TrafficPermitTaskProgress progress = null;
        boolean f = true;
        if (config.getTask_type() == TrafficPermitTaskType.DAY_TASK.getValue()) {

            progress = promotion053TrafficPermit.getDayTask().get(config.getIdx());
            f = updateProgress(progress, config, addCount, type);
            promotion053TrafficPermit.getDayTask().put(config.getIdx(), progress);

        } else if (config.getTask_type() == TrafficPermitTaskType.WEEK_TASK.getValue()) {

            progress = promotion053TrafficPermit.getWeekTask().get(config.getIdx());
            f = updateProgress(progress, config, addCount, type);
            promotion053TrafficPermit.getWeekTask().put(config.getIdx(), progress);

        } else if (config.getTask_type() == TrafficPermitTaskType.Month_TASK.getValue()) {

            progress = promotion053TrafficPermit.getUltimateTask().get(config.getIdx());
            f = updateProgress(progress, config, addCount, type);
            promotion053TrafficPermit.getUltimateTask().put(config.getIdx(), progress);
        }
        updatePromotion(promotion053TrafficPermit);

        if (progress != null && f) {//当进度变动有效时才更新数据
            this.sendTaskProgress(rid, config.getIdx(), progress.getProgress());
        }

    }

    private boolean updateProgress(TrafficPermitTaskProgress progress, CPromotionTrafficPermit config, int addCount, int type) {
        boolean f = config.getMission().getTarget() > progress.getProgress();//目标进度大于当前进度为有效进度，需要同步前端更新任务
        if (type == 0) {
            progress.setProgress(addCount + progress.getProgress());
        } else {
            if (addCount > progress.getProgress()) {
                progress.setProgress(addCount);
            }
        }
        return f;
    }

    /**
     * 发送任务进度
     *
     * @param rid
     * @param idx
     * @param progress
     */
    private void sendTaskProgress(long rid, int idx, int progress) {
        Promotion053GMsg.GResDayTaskProgress.Builder builder = Promotion053GMsg.GResDayTaskProgress.newBuilder();
        builder.addTaskProgress(builder(idx, progress));
        contextManager.write(rid, CmdCode._13195, builder.build());
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.TRAFFIC_PERMIT_PRIVILEGE_GIFT;
    }

    /**
     * 礼包是否还可以购买
     *
     * @param rid
     * @param productId
     * @return
     */
    @Override
    public boolean canBuy(long rid, int productId) {

        if (!promotionControlService.isPromotionRecording(thisPromotionType())) {
            return false;
        }

        CPromotionTrafficPermitGift cPromotionTrafficPermitGift = getProductionGift(productId);
        if (cPromotionTrafficPermitGift == null) {
            return false;
        }

        Promotion053TrafficPermit promotion053TrafficPermit = this.getPromotionOrRefresh(rid);
        //未购买
        return promotion053TrafficPermit.getBuyPrivilege() == 0;

    }

    /**
     * 购买成功回调
     *
     * @param rid
     * @param cBuyGem
     * @param isGm
     */
    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        CPromotionTrafficPermitGift cPromotionTrafficPermitGift = getProductionGift(cBuyGem.getIdx());
        if (cPromotionTrafficPermitGift == null) {
            return;
        }

        Promotion053TrafficPermit promotion053TrafficPermit = this.getPromotionOrRefresh(rid);
        promotion053TrafficPermit.setBuyPrivilege(1);
        this.addExp(promotion053TrafficPermit, cPromotionTrafficPermitGift.getPoint());
        //updatePromotion(promotion053TrafficPermit);

        Promotion053GMsg.GResTrafficPermitPrivilege.Builder builder = Promotion053GMsg.GResTrafficPermitPrivilege.newBuilder();
        builder.setLevel(promotion053TrafficPermit.getLevel());
        builder.setExp(promotion053TrafficPermit.getExp());
        builder.addAllPrivilegeReward(promotion053TrafficPermit.getPrivilegeList());
        builder.setBuyPrivilege(promotion053TrafficPermit.getBuyPrivilege());
        contextManager.write(rid, CmdCode._13196, builder.build());

        if (isGm) {
            thingService.add(rid, cPromotionTrafficPermitGift.getReward(), GameEvent.GM_RECHARGE);
        } else {
            thingService.add(rid, cPromotionTrafficPermitGift.getReward(), GameEvent.BUY_PRIVILEGE_REWARD);
        }

    }

    /**
     * 根据商品id获取配置
     *
     * @param productionId
     * @return
     */
    private CPromotionTrafficPermitGift getProductionGift(int productionId) {
        CPromotionTrafficPermitGift cPromotionTrafficPermitGift = null;
        for (CPromotionTrafficPermitGift config : promotionTrafficPermitGiftSysCache.getAll()) {
            if (config.getProduction_id() == productionId) {
                cPromotionTrafficPermitGift = config;
            }
        }
        return cPromotionTrafficPermitGift;
    }


    /**
     * 增加通行证经验
     *
     * @param trafficPermit
     * @param exp
     */
    public void addExp(Promotion053TrafficPermit trafficPermit, int exp) {

        int maxLevel = promotionTrafficPermitRewardSysCache.getMaxLevel();
        CPromotionTrafficPermitReward config = promotionTrafficPermitRewardSysCache.getOrThrow(maxLevel);
        if (trafficPermit.getLevel() == maxLevel) {//若是满级
            if (trafficPermit.getExp() == config.getExp()) {
                return;
            } else {
                trafficPermit.setExp(Math.min(trafficPermit.getExp() + exp, config.getExp()));
                updatePromotion(trafficPermit);
                return;
            }
        }

        trafficPermit.setExp(trafficPermit.getExp() + exp);
        config = promotionTrafficPermitRewardSysCache.getOrThrow(trafficPermit.getLevel() + 1);
        while (trafficPermit.getExp() >= config.getExp()) {
            trafficPermit.setLevel(config.getLevel());
            if (trafficPermit.getLevel() == maxLevel) {//若是满级
                trafficPermit.setExp(Math.min(trafficPermit.getExp() + exp, config.getExp()));
                updatePromotion(trafficPermit);
                return;
            }
            config = promotionTrafficPermitRewardSysCache.getOrThrow(trafficPermit.getLevel() + 1);
        }
        updatePromotion(trafficPermit);
    }

    /**
     * 推送活动数据
     *
     * @param promotion053TrafficPermit
     */
    public void sendPromotionInfo(Promotion053TrafficPermit promotion053TrafficPermit) {
        Promotion053GMsg.GResTrafficPermitList.Builder builder = Promotion053GMsg.GResTrafficPermitList.newBuilder();
        builder.setLevel(promotion053TrafficPermit.getLevel());
        builder.setExp(promotion053TrafficPermit.getExp());
        builder.setBuyPrivilege(promotion053TrafficPermit.getBuyPrivilege());
        builder.addAllFinishReward(promotion053TrafficPermit.getFinishList());
        builder.addAllPrivilegeReward(promotion053TrafficPermit.getPrivilegeList());
        builder.setStatus(promotion053TrafficPermit.getRemind());

        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.TONG_XING_XHENG);
        builder.setRound(promotionControl.getTurns());

        List<Integer> taskIdx = new ArrayList<>();
        List<ObjectGMsg.PSMapData> taskList = new ArrayList<>();
        this.taskBuilder(promotion053TrafficPermit.getDayTask(), taskIdx, taskList);
        this.taskBuilder(promotion053TrafficPermit.getWeekTask(), taskIdx, taskList);
        this.taskBuilder(promotion053TrafficPermit.getUltimateTask(), taskIdx, taskList);

        builder.addAllTaskIdx(taskIdx);
        builder.addAllTaskList(taskList);
        builder.setDayEndTime(DateTimeUtil.tomorrowBreak() - 1);

        long days = LocalDateTimeUtil.daysUntil(LocalDateTimeUtil.ofEpochSecond(promotionControl.getStartTime()).toLocalDate(), LocalDate.now());
        long weekStartDate = days % 7;
        long weekEndDate = 7 - weekStartDate;
        LocalDate endDate = LocalDate.now().plusDays(weekEndDate);
        LocalTime endTime = LocalTime.of(0, 0, 0);
        LocalDateTime endDateTime = LocalDateTime.of(endDate, endTime);

        builder.setWeekEndTime(Math.min(LocalDateTimeUtil.toEpochSecond(endDateTime), promotionControl.getEndTime()));
        contextManager.write(promotion053TrafficPermit.getRid(), CmdCode._13190, builder.build());
    }

    private void taskBuilder(Map<Integer, TrafficPermitTaskProgress> taskMap, List<Integer> taskIdx, List<ObjectGMsg.PSMapData> taskList) {
        taskMap.forEach((k, v) -> {
            if (v.getStatus() == 1) {
                taskIdx.add(k);
            }
            ObjectGMsg.PSMapData.Builder data = builder(k, v.getProgress());
            taskList.add(data.build());
        });
    }

    private ObjectGMsg.PSMapData.Builder builder(int idx, int progress) {
        ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
        data.setKey(idx);

        CPromotionTrafficPermit cPromotionTrafficPermit = promotionTrafficPermitSysCache.getOrThrow(idx);
        int count = Math.min(progress, cPromotionTrafficPermit.getMission().getTarget());

        data.setValue(count);
        return data;
    }

}
