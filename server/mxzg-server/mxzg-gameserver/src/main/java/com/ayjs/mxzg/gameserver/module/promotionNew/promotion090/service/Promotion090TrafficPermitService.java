package com.ayjs.mxzg.gameserver.module.promotionNew.promotion090.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.PromotionItemRetrieveSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion090.Promotion090TrafficPermitRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion090.Promotion090TrafficPermitSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.promotion090.CPromotion090TrafficPermit;
import com.ayjs.mxzg.config.excel.entity.promotion090.CPromotion090TrafficPermitReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.domain.BackPack;
import com.ayjs.mxzg.gameserver.module.backpack.service.BackPackService;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion090.dao.Promotion090TrafficPermitDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion090.domain.Promotion090TrafficPermit;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.TrafficPermitTaskProgress;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.TrafficPermitTaskType;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion090TrafficPermitGiftConfig;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion090GMsg;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/10/21
 **/
@Service
@Slf4j
public class Promotion090TrafficPermitService extends BasePromotionService<Promotion090TrafficPermit> implements IRechargeBuyingService {
    @Autowired
    private Promotion090TrafficPermitDao promotion090TrafficPermitDao;
    @Autowired
    private PromotionItemRetrieveSysCache promotionItemRetrieveSysCache;
    @Autowired
    private BackPackService backPackService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private Promotion090TrafficPermitSysCache promotion090TrafficPermitSysCache;
    @Autowired
    private Promotion090TrafficPermitRewardSysCache promotion090TrafficPermitRewardSysCache;
    @Autowired
    private ContextManager contextManager;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.TONG_XING_XHENG_2;
    }

    @Override
    public IRepository<Promotion090TrafficPermit> getRepository() {
        return promotion090TrafficPermitDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion090TrafficPermit promotion, PromotionControl control) {
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
        promotion.setLoginRecord(LocalDate.of(2021, 1, 11));
    }

    @Override
    public void handleOnPromotionClear(PromotionControl control) {
        //回收的道具id
        int itemType = promotionItemRetrieveSysCache.getOrThrow(control.getType()).getRetrieve_item();

        List<Promotion090TrafficPermit> promotionList = getAllPromotionInfo();
        promotionList.stream().filter(promotion -> promotion.getTurnsTime() == control.getTurnsTime()).forEach(promotion -> {
            BackPack backPack = backPackService.getBackPack(promotion.getRid(), itemType);
            if (backPack != null) {
                ImmutableThing immutableThing = ImmutableThing.of(backPack.getItemId(), backPack.getNum());
                if (immutableThing.getNum() > 0) {
                    thingService.cost(promotion.getRid(), immutableThing, GameEvent.T_PERMIT_EXP);
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
        return notDayTime % promotion090TrafficPermitSysCache.getTaskTypeTurns(promotionControl.getTurns(), TrafficPermitTaskType.DAY_TASK.getValue()) + 1;
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
                promotion090TrafficPermitSysCache.getTaskTypeTurns(promotionControl.getTurns(), TrafficPermitTaskType.WEEK_TASK.getValue())) + 1;
    }


    public Promotion090TrafficPermit getPromotionOrRefresh(long rid) {
        Promotion090TrafficPermit promotion090TrafficPermit = this.getPromotionInfo(rid);
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            return promotion090TrafficPermit;
        }
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        int dayTurns = dayTurns(promotionControl);
        int weekTurns = weekTurns(promotionControl);
        if (weekTurns != promotion090TrafficPermit.getWeekTurns()) {
            //周任务的重制必然会重制每日任务
            resetWeekTask(promotion090TrafficPermit, promotionControl.getTurns(), dayTurns, weekTurns);
        } else {
            //上一次相同轮次的任务
            if (DateTimeUtil.apartDay(promotion090TrafficPermit.getResetTime(), DateTimeUtil.currentSecond()) > 7) {
                resetWeekTask(promotion090TrafficPermit, promotionControl.getTurns(), dayTurns, weekTurns);
            } else {
                //重制每日任务
                if (dayTurns != promotion090TrafficPermit.getDayTurns()) {
                    resetDayTask(promotion090TrafficPermit, promotionControl.getTurns(), dayTurns);
                } else {
                    //上一次相同轮次的任务
                    if (DateTimeUtil.apartDay(promotion090TrafficPermit.getResetTime(), DateTimeUtil.currentSecond()) > 1) {
                        resetDayTask(promotion090TrafficPermit, promotionControl.getTurns(), dayTurns);
                    }
                }
            }
        }
        if (promotion090TrafficPermit.getUltimateTask().size() == 0) {
            promotion090TrafficPermit.setUltimateTask(resetTask(promotionControl.getTurns(), TrafficPermitTaskType.Month_TASK, 1));
        }
        return promotion090TrafficPermit;
    }

    /**
     * 重制每周任务
     *
     * @param promotion090TrafficPermit
     * @param dayTurns
     * @param weekTurns
     */
    private void resetWeekTask(Promotion090TrafficPermit promotion090TrafficPermit, int configTurns, int dayTurns, int weekTurns) {
        promotion090TrafficPermit.setWeekTurns(weekTurns);
        promotion090TrafficPermit.setResetTime(DateTimeUtil.currentSecond());
        //重制任务
        promotion090TrafficPermit.setWeekTask(resetTask(configTurns, TrafficPermitTaskType.WEEK_TASK, weekTurns));
        //重制每日任务
        this.resetDayTask(promotion090TrafficPermit, configTurns, dayTurns);

        updatePromotion(promotion090TrafficPermit);
    }

    public Promotion090TrafficPermitGiftConfig getGiftConfig(int idx) {
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        return control.getConfig(idx, Promotion090TrafficPermitGiftConfig.class);
    }

    /**
     * 重制每日任务
     *
     * @param promotion090TrafficPermit
     * @param dayTurns
     */
    private void resetDayTask(Promotion090TrafficPermit promotion090TrafficPermit, int configTurns, int dayTurns) {
        promotion090TrafficPermit.setDayTurns(dayTurns);
        promotion090TrafficPermit.setResetTime(DateTimeUtil.currentSecond());
        //重制任务
        promotion090TrafficPermit.setDayTask(resetTask(configTurns, TrafficPermitTaskType.DAY_TASK, dayTurns));
        //查看是否开通特权，领取每日赠送经验
        if (promotion090TrafficPermit.getBuyPrivilege() == 1) {
            Promotion090TrafficPermitGiftConfig giftConfig = getGiftConfig(1);
            addExp(promotion090TrafficPermit, giftConfig.getDay_point());
        }
        updatePromotion(promotion090TrafficPermit);
    }

    /**
     * 重制任务
     *
     * @param taskType
     * @param turns
     * @return
     */
    private Map<Integer, TrafficPermitTaskProgress> resetTask(int configTurns, TrafficPermitTaskType taskType, int turns) {
        List<CPromotion090TrafficPermit> taskList = promotion090TrafficPermitSysCache.getTaskList(configTurns, taskType.getValue(), turns);
        Map<Integer, TrafficPermitTaskProgress> taskMap = new HashMap<>();
        for (CPromotion090TrafficPermit config : taskList) {
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
    public List<CPromotion090TrafficPermit> getTargetTaskList(TargetType targetType) {
        List<CPromotion090TrafficPermit> list = new ArrayList<>();
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        if (promotionControlService.isPromotionRecording(thisPromotionType())) {
            //找出当前轮每日任务相同类型的任务
            promotion090TrafficPermitSysCache.getTaskList(promotionControl.getTurns(), TrafficPermitTaskType.DAY_TASK.getValue(), dayTurns(promotionControl))
                    .stream().filter(config -> config.getMission().getType() == targetType).forEach(list::add);
            //找出当前轮每周任务相同类型的任务
            promotion090TrafficPermitSysCache.getTaskList(promotionControl.getTurns(), TrafficPermitTaskType.WEEK_TASK.getValue(), weekTurns(promotionControl))
                    .stream().filter(config -> config.getMission().getType() == targetType).forEach(list::add);
            //找出相同类型的终极任务
            promotion090TrafficPermitSysCache.getTaskList(promotionControl.getTurns(), TrafficPermitTaskType.Month_TASK.getValue(), 1)
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
    public void updatePromotionTask(long rid, CPromotion090TrafficPermit config, int addCount, int type) {
        Promotion090TrafficPermit promotion090TrafficPermit = this.getPromotionOrRefresh(rid);
        TrafficPermitTaskProgress progress = null;
        boolean f = true;
        if (config.getTask_type() == TrafficPermitTaskType.DAY_TASK.getValue()) {

            progress = promotion090TrafficPermit.getDayTask().get(config.getIdx());
            f = updateProgress(progress, config, addCount, type);
            promotion090TrafficPermit.getDayTask().put(config.getIdx(), progress);

        } else if (config.getTask_type() == TrafficPermitTaskType.WEEK_TASK.getValue()) {

            progress = promotion090TrafficPermit.getWeekTask().get(config.getIdx());
            f = updateProgress(progress, config, addCount, type);
            promotion090TrafficPermit.getWeekTask().put(config.getIdx(), progress);

        } else if (config.getTask_type() == TrafficPermitTaskType.Month_TASK.getValue()) {

            progress = promotion090TrafficPermit.getUltimateTask().get(config.getIdx());
            f = updateProgress(progress, config, addCount, type);
            promotion090TrafficPermit.getUltimateTask().put(config.getIdx(), progress);
        }
        updatePromotion(promotion090TrafficPermit);

        if (progress != null && f) {//当进度变动有效时才更新数据
            this.sendTaskProgress(rid, config.getIdx(), progress.getProgress());
        }

    }

    private boolean updateProgress(TrafficPermitTaskProgress progress, CPromotion090TrafficPermit config, int addCount, int type) {
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
        Promotion090GMsg.GResTPermitDayTaskProgress.Builder builder = Promotion090GMsg.GResTPermitDayTaskProgress.newBuilder();
        builder.addTaskProgress(builder(idx, progress));
        contextManager.write(rid, CmdCode._76195, builder.build());
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.PROMOTION_090;
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

        Promotion090TrafficPermitGiftConfig config = getProductionGift(productId);
        if (config == null) {
            return false;
        }

        Promotion090TrafficPermit promotion090TrafficPermit = this.getPromotionOrRefresh(rid);
        //未购买
        return promotion090TrafficPermit.getBuyPrivilege() == 0;

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
        Promotion090TrafficPermitGiftConfig config = getProductionGift(cBuyGem.getIdx());
        if (config == null) {
            return;
        }

        Promotion090TrafficPermit promotion090TrafficPermit = this.getPromotionOrRefresh(rid);
        promotion090TrafficPermit.setBuyPrivilege(1);
        this.addExp(promotion090TrafficPermit, config.getPoint());
        //updatePromotion(promotion090TrafficPermit);

        Promotion090GMsg.GResTPermitPrivilege.Builder builder = Promotion090GMsg.GResTPermitPrivilege.newBuilder();
        builder.setLevel(promotion090TrafficPermit.getLevel());
        builder.setExp(promotion090TrafficPermit.getExp());
        builder.addAllPrivilegeReward(promotion090TrafficPermit.getPrivilegeList());
        builder.setBuyPrivilege(promotion090TrafficPermit.getBuyPrivilege());
        contextManager.write(rid, CmdCode._76196, builder.build());

        if (isGm) {
            thingService.add(rid, config.getRewardThings(), GameEvent.GM_RECHARGE);
        } else {
            thingService.add(rid, config.getRewardThings(), GameEvent.T_PERMIT_BUY_PRIVILEGE_REWARD);
        }

    }

    /**
     * 根据商品id获取配置
     *
     * @param productionId
     * @return
     */
    private Promotion090TrafficPermitGiftConfig getProductionGift(int productionId) {
        Promotion090TrafficPermitGiftConfig config = null;
        Collection<Promotion090TrafficPermitGiftConfig> allConfig = promotionControlService.getControl(thisPromotionType()).getAllConfig(Promotion090TrafficPermitGiftConfig.class);
        if (allConfig != null) {
            for (Promotion090TrafficPermitGiftConfig config_ : allConfig) {
                if (config_.getProduction_id() == productionId) {
                    config = config_;
                }
            }
        }
        return config;
    }


    /**
     * 增加通行证经验
     *
     * @param trafficPermit
     * @param exp
     */
    public void addExp(Promotion090TrafficPermit trafficPermit, int exp) {

        int maxLevel = promotion090TrafficPermitRewardSysCache.getMaxLevel();
        CPromotion090TrafficPermitReward config = promotion090TrafficPermitRewardSysCache.getOrThrow(maxLevel);
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
        config = promotion090TrafficPermitRewardSysCache.getOrThrow(trafficPermit.getLevel() + 1);
        while (trafficPermit.getExp() >= config.getExp()) {
            trafficPermit.setLevel(config.getLevel());
            if (trafficPermit.getLevel() == maxLevel) {//若是满级
                trafficPermit.setExp(Math.min(trafficPermit.getExp() + exp, config.getExp()));
                updatePromotion(trafficPermit);
                return;
            }
            config = promotion090TrafficPermitRewardSysCache.getOrThrow(trafficPermit.getLevel() + 1);
        }
        updatePromotion(trafficPermit);
    }

    /**
     * 推送活动数据
     *
     * @param promotion090TrafficPermit
     */
    public void sendPromotionInfo(Promotion090TrafficPermit promotion090TrafficPermit) {
        Promotion090GMsg.GResTPermitList.Builder builder = Promotion090GMsg.GResTPermitList.newBuilder();
        builder.setLevel(promotion090TrafficPermit.getLevel());
        builder.setExp(promotion090TrafficPermit.getExp());
        builder.setBuyPrivilege(promotion090TrafficPermit.getBuyPrivilege());
        builder.addAllFinishReward(promotion090TrafficPermit.getFinishList());
        builder.addAllPrivilegeReward(promotion090TrafficPermit.getPrivilegeList());
        builder.setStatus(promotion090TrafficPermit.getRemind());

        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());

        List<Integer> taskIdx = new ArrayList<>();
        List<ObjectGMsg.PSMapData> taskList = new ArrayList<>();
        this.taskBuilder(promotion090TrafficPermit.getDayTask(), taskIdx, taskList);
        this.taskBuilder(promotion090TrafficPermit.getWeekTask(), taskIdx, taskList);
        this.taskBuilder(promotion090TrafficPermit.getUltimateTask(), taskIdx, taskList);

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
        contextManager.write(promotion090TrafficPermit.getRid(), CmdCode._76190, builder.build());
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

        CPromotion090TrafficPermit CPromotion090TrafficPermit = promotion090TrafficPermitSysCache.getOrThrow(idx);
        int count = Math.min(progress, CPromotion090TrafficPermit.getMission().getTarget());

        data.setValue(count);
        return data;
    }

    public List<CPromotion090TrafficPermit> getMissionConfigByTarget(TargetStruct targetStruct) {
        List<CPromotion090TrafficPermit> list = new ArrayList<>();
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());

        //找出当前轮每日任务相同类型的任务
        promotion090TrafficPermitSysCache.getTaskList(promotionControl.getTurns(), TrafficPermitTaskType.DAY_TASK.getValue(), dayTurns(promotionControl))
                .stream().filter(config -> TargetType.checkTrigger(config.getMission(), targetStruct)).forEach(list::add);
        //找出当前轮每周任务相同类型的任务
        promotion090TrafficPermitSysCache.getTaskList(promotionControl.getTurns(), TrafficPermitTaskType.WEEK_TASK.getValue(), weekTurns(promotionControl))
                .stream().filter(config -> TargetType.checkTrigger(config.getMission(), targetStruct)).forEach(list::add);
        //找出相同类型的终极任务
        promotion090TrafficPermitSysCache.getTaskList(promotionControl.getTurns(), TrafficPermitTaskType.Month_TASK.getValue(), 1)
                .stream().filter(config -> TargetType.checkTrigger(config.getMission(), targetStruct)).forEach(list::add);

        return list;
    }

    public boolean isOpen() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }


}
