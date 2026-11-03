package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion018SevenDayTargetSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion018SevenDayTarget;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion018SevenDayTargetDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion018SevenDayTarget;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.recharge.domain.Recharge;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.service.RechargeService;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.targetCounter.service.TargetCounterService;
import com.ayjs.mxzg.protocol.AchievementGMsg;
import com.ayjs.mxzg.protocol.SevenDayTargetGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author hyx
 */
@Service
public class Promotion018SevenDayTargetService extends BasePromotionService<Promotion018SevenDayTarget> {

    @Autowired
    private Promotion018SevenDayTargetDao promotion018SevenDayTargetDao;
    @Autowired
    private Promotion018SevenDayTargetSysCache promotion018SevenDayTargetSysCache;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private TargetCounterService targetCounterService;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.QI_RI_MU_BIAO;
    }

    @Override
    public IRepository<Promotion018SevenDayTarget> getRepository() {
        return promotion018SevenDayTargetDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion018SevenDayTarget promotion, PromotionControl control) {
        promotion.getBoxRewards().clear();
        promotion.getTask_list().clear();
        promotion.getTaskReward().clear();
    }

    /**
     * 获取玩家活动数据
     *
     * @param rid
     */
    public Promotion018SevenDayTarget getOrRefresh(long rid) {

        Promotion018SevenDayTarget promotion018SevenDayTarget = this.getPromotionInfo(rid);

        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.QI_RI_MU_BIAO);

        if (promotion018SevenDayTarget.getTask_list().size() == 0) {
            //初识化任务数据
            List<CPromotion018SevenDayTarget> taskList = promotion018SevenDayTargetSysCache.getList(promotionControl.getTurns());
            taskList.forEach(task -> {
                if (task.getTask().getType() == TargetType.TOTAL_RECHARGE) {
                    promotion018SevenDayTarget.getTask_list().put(task.getIdx(), 0);
                } else {
                    promotion018SevenDayTarget.getTask_list().put(task.getIdx(), targetCounterService.calcCount(rid, task.getTask()));
                }
            });
        }

        return promotion018SevenDayTarget;
    }

    public List<AchievementGMsg.PSTaskData> builderTask(Promotion018SevenDayTarget promotion018SevenDayTarget) {

        try {
            //1591200000 小于6月4号
            if (DateTimeUtil.currentSecond() < 1591200000) {
                ServerConfig serverConfig = SpringProxy.getBean(ServerConfig.class);
                if (serverConfig.getServerLang() > 1){
                    RoleRechargeService roleRechargeService = SpringProxy.getBean(RoleRechargeService.class);
                    RoleRecharge recharge = roleRechargeService.getRoleRecharge(promotion018SevenDayTarget.getRid());

                    for (Integer idx : promotion018SevenDayTarget.getTask_list().keySet()) {
                        CPromotion018SevenDayTarget sysCache = promotion018SevenDayTargetSysCache.getOrThrow(idx);
                        if (sysCache.getTask().getType() == TargetType.TOTAL_RECHARGE) {
                            promotion018SevenDayTarget.getTask_list().put(idx, (int) recharge.getTotalRecharge());
                        }
                    }

                    updatePromotion(promotion018SevenDayTarget);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        List<AchievementGMsg.PSTaskData> taskList = new ArrayList<>();
        promotion018SevenDayTarget.getTask_list().forEach((k, v) -> {
            AchievementGMsg.PSTaskData.Builder data = this.builderTask(k, promotion018SevenDayTarget);
            taskList.add(data.build());
        });
        return taskList;
    }

    public AchievementGMsg.PSTaskData.Builder builderTask(int idx, Promotion018SevenDayTarget promotion018SevenDayTarget) {
        AchievementGMsg.PSTaskData.Builder builder = AchievementGMsg.PSTaskData.newBuilder();
        builder.setIdx(idx);
        CPromotion018SevenDayTarget cPromotion018SevenDayTarget = promotion018SevenDayTargetSysCache.getById(idx);
        int count = Math.min(cPromotion018SevenDayTarget.getTask().getTarget() , promotion018SevenDayTarget.getTask_list().get(idx));
        builder.setProcess(count);
        builder.setState(promotion018SevenDayTarget.getTaskReward().contains(idx) ? 1 : 0);
        return builder;
    }

    /**
     * 增加进度值
     *
     * @param rid
     * @param targetType
     * @param addProgress
     */
    public void addProgress(long rid, TargetType targetType, int addProgress, List<CPromotion018SevenDayTarget> configList) {
        if (promotionControlService.isPromotionRunning(PromotionType.QI_RI_MU_BIAO)) {

            Promotion018SevenDayTarget promotion018SevenDayTarget = this.getOrRefresh(rid);

            if (configList == null) {
                configList = this.getConfig(targetType);
            }

            List<AchievementGMsg.PSTaskData> builderList = new ArrayList<>();
            configList.stream().filter(config -> !promotion018SevenDayTarget.getTaskReward().contains(config.getIdx())).forEach(config -> {

                int count = promotion018SevenDayTarget.getTask_list().getOrDefault(config.getIdx(), 0);
                promotion018SevenDayTarget.getTask_list().put(config.getIdx(), count + addProgress);

                builderList.add(builderTask(config.getIdx(), promotion018SevenDayTarget).build());
            });

            if (!builderList.isEmpty()) {
                this.updatePromotion(promotion018SevenDayTarget);
                //发送更新的任务数据
                this.sendUpdateTaskProgress(rid, builderList);
            }
        }
    }


    /**
     * 替换进度值
     *
     * @param rid
     * @param targetType
     * @param newProgress
     */
    public void setProgress(long rid, TargetType targetType, int newProgress, List<CPromotion018SevenDayTarget> configList) {
        if (promotionControlService.isPromotionRunning(PromotionType.QI_RI_MU_BIAO)) {

            Promotion018SevenDayTarget promotion018SevenDayTarget = this.getOrRefresh(rid);

            if (configList == null) {
                configList = this.getConfig(targetType);
            }

            List<AchievementGMsg.PSTaskData> builderList = new ArrayList<>();
            configList.stream().filter(config -> !promotion018SevenDayTarget.getTaskReward().contains(config.getIdx()) &&
                    promotion018SevenDayTarget.getTask_list().getOrDefault(config.getIdx(),0) < newProgress).forEach(config -> {

                promotion018SevenDayTarget.getTask_list().put(config.getIdx(), newProgress);

                builderList.add(builderTask(config.getIdx(), promotion018SevenDayTarget).build());
            });

            if (!builderList.isEmpty()) {
                this.updatePromotion(promotion018SevenDayTarget);
                //发送更新的任务数据
                this.sendUpdateTaskProgress(rid, builderList);
            }
        }
    }

    /**
     * 发送更新进度
     *
     * @param rid
     * @param builderList
     */
    private void sendUpdateTaskProgress(long rid, List<AchievementGMsg.PSTaskData> builderList) {
        if (!builderList.isEmpty()) {
            SevenDayTargetGMsg.GResUpdateSevenDayTarget.Builder builder = SevenDayTargetGMsg.GResUpdateSevenDayTarget.newBuilder();
            builder.addAllUpdateTasks(builderList);
            contextManager.write(rid, CmdCode._21013, builder.build());
        }
    }


    public List<CPromotion018SevenDayTarget> getConfig(TargetType targetType) {
        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.QI_RI_MU_BIAO);

        return promotion018SevenDayTargetSysCache.getList(promotionControl.getTurns()).stream().
                filter(config -> config.getTask().getType() == targetType).collect(Collectors.toList());
    }


}
