package com.ayjs.mxzg.gameserver.module.promotionNew.service;


import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion061ThreeDayTaskSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion061ThreeDayTask;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion061ThreeDayTaskDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion061ThreeDayTask;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.targetCounter.service.TargetCounterService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion057EveryDayLoginConfig;
import com.ayjs.mxzg.protocol.AchievementGMsg;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion057GMsg;
import com.ayjs.mxzg.protocol.Promotion061GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * 三日任务
 *
 * @author hyx
 */
@Service
public class Promotion061ThreeDayTaskService extends BasePromotionService<Promotion061ThreeDayTask> {

    @Autowired
    private Promotion061ThreeDayTaskDao promotion061ThreeDayTaskDao;
    @Autowired
    private Promotion061ThreeDayTaskSysCache promotion061ThreeDayTaskSysCache;
    @Autowired
    private TargetCounterService targetCounterService;
    @Autowired
    private ContextManager contextManager;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.SAN_RI_REN_WU;
    }

    @Override
    public IRepository<Promotion061ThreeDayTask> getRepository() {
        return promotion061ThreeDayTaskDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion061ThreeDayTask promotion, PromotionControl control) {
        promotion.getTaskList().clear();
        promotion.getTaskReward().clear();
        promotion.getUltimateReward().clear();
    }

    @Override
    public Promotion061ThreeDayTask getPromotionInfo(long rid) {
        Promotion061ThreeDayTask promotionInfo = super.getPromotionInfo(rid);
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            return promotionInfo;
        }
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        //初始化任务数据
        if (promotionInfo.getTaskList().isEmpty()) {
            List<CPromotion061ThreeDayTask> configList = promotion061ThreeDayTaskSysCache.getTurnsTask(promotionControl.getTurns());

            configList.forEach(config -> {
                TargetStruct targetStruct = config.getTask();
                if (targetStruct.getType() == TargetType.LOGIN) {
                    promotionInfo.getTaskList().put(config.getIdx(), 1L);
                } else if (targetStruct.getType() == TargetType.PASS_MAIN_LEVEL) {
                    promotionInfo.getTaskList().put(config.getIdx(), targetCounterService.calcTaskCount(rid, config.getTask()));
                } else {
                    promotionInfo.getTaskList().put(config.getIdx(), (long) targetCounterService.calcCount(rid, config.getTask()));
                }
            });
            this.updatePromotion(promotionInfo);

        }
        return promotionInfo;
    }

    /**
     * 获取当前活动天数
     *
     * @return
     */
    public Integer getPromotionDay() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        int dayTurns = DateTimeUtil.apartDay(DateTimeUtil.theDayBreak(promotionControl.getStartTime()), DateTimeUtil.dayBreak()) + 1;
        return dayTurns;
    }

    /**
     * 更新进度
     *
     * @param rid
     * @param configList
     * @param newProgress
     */
    public void setProgress(long rid, List<CPromotion061ThreeDayTask> configList, long newProgress) {
        Promotion061ThreeDayTask promotion061ThreeDayTask = this.getPromotionInfo(rid);

        List<ObjectGMsg.PSTaskProgress> builderList = new ArrayList<>();
        configList.stream().filter(config -> !promotion061ThreeDayTask.getTaskReward().contains(config.getIdx())
                && promotion061ThreeDayTask.getTaskList().getOrDefault(config.getIdx(), 0L) < newProgress).forEach(config -> {

            promotion061ThreeDayTask.getTaskList().put(config.getIdx(), newProgress);

            builderList.add(builderTask(config.getIdx(), promotion061ThreeDayTask.getTaskList().get(config.getIdx())).build());
        });

        if (!builderList.isEmpty()) {
            this.updatePromotion(promotion061ThreeDayTask);
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
    public void addProgress(long rid, List<CPromotion061ThreeDayTask> configList, long addProgress) {
        Promotion061ThreeDayTask promotion061ThreeDayTask = this.getPromotionInfo(rid);

        List<ObjectGMsg.PSTaskProgress> builderList = new ArrayList<>();
        configList.stream().filter(config -> !promotion061ThreeDayTask.getTaskReward().contains(config.getIdx())).forEach(config -> {

            long count = promotion061ThreeDayTask.getTaskList().getOrDefault(config.getIdx(), 0L);
            promotion061ThreeDayTask.getTaskList().put(config.getIdx(), count + addProgress);

            builderList.add(builderTask(config.getIdx(), promotion061ThreeDayTask.getTaskList().get(config.getIdx())).build());
        });

        if (!builderList.isEmpty()) {
            this.updatePromotion(promotion061ThreeDayTask);
            //发送更新的任务数据
            this.sendUpdateTaskProgress(rid, builderList);
        }
    }

    public ObjectGMsg.PSTaskProgress.Builder builderTask(int idx, long progress) {
        ObjectGMsg.PSTaskProgress.Builder builder = ObjectGMsg.PSTaskProgress.newBuilder();
        builder.setIdx(idx);

        CPromotion061ThreeDayTask config = promotion061ThreeDayTaskSysCache.getOrThrow(idx);
        long count = Math.min(config.getTask().getTarget(), progress);
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
            Promotion061GMsg.GResUpdateThreeDayTask.Builder builder = Promotion061GMsg.GResUpdateThreeDayTask.newBuilder();
            builder.addAllUpdateTasks(builderList);
            contextManager.write(rid, CmdCode._13233, builder.build());
        }
    }

}
