package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion057EveryDayLoginDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion057EveryDayLogin;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.module.targetCounter.service.TargetCounterService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion057EveryDayLoginConfig;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion057GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
public class Promotion057EveryDayLoginService extends BasePromotionService<Promotion057EveryDayLogin> {

    @Autowired
    private Promotion057EveryDayLoginDao promotion057EveryDayLoginDao;
    @Autowired
    private ServerParamService serverParamService;
    @Autowired
    private TargetCounterService targetCounterService;
    @Autowired
    private ContextManager contextManager;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.MEI_RI_DENG_LU;
    }

    @Override
    public IRepository<Promotion057EveryDayLogin> getRepository() {
        return promotion057EveryDayLoginDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion057EveryDayLogin promotion, PromotionControl control) {
        promotion.setDailyTime(0);
        promotion.getTaskList().clear();
        promotion.getTaskReward().clear();
    }

    /**
     * 获取当前开启的所有任务配置
     *
     * @return
     */
    private List<Promotion057EveryDayLoginConfig> getConfigList() {
        PromotionControl control = promotionControlService.getControl(thisPromotionType());

        Collection<Promotion057EveryDayLoginConfig> configs = control.getAllConfig(Promotion057EveryDayLoginConfig.class);

        /*if (configList.isEmpty()) {
            int openDay = serverParamService.getOpenDays();
            configList = configs.stream().filter(config -> openDay >= config.getStar_server_day() && openDay <= config.getEnd_server_day()).collect(Collectors.toList());
        }*/

        return new ArrayList<>(configs);
    }

    /**
     * 获取当天轮次任务配置
     *
     * @return
     */
    public List<Promotion057EveryDayLoginConfig> getDayTurnsTaskConfigs() {
        int dayTurns = getDayTurns();
        return this.getConfigList().stream().filter(config -> config.getTurns() == dayTurns).collect(Collectors.toList());
    }

    /**
     * 获取指定类型的任务集
     *
     * @param targetType
     * @return
     */
    public List<Promotion057EveryDayLoginConfig> getTaskTypeConfigs(TargetType targetType) {
        List<Promotion057EveryDayLoginConfig> configList = new ArrayList<>();
        this.getDayTurnsTaskConfigs().forEach(config -> {
            if (config.getTargetStruct().getType() == targetType) {
                configList.add(config);
            }
        });
        return configList;
    }

    public Promotion057EveryDayLoginConfig getConfig(int idx) {
        Promotion057EveryDayLoginConfig promotion057EveryDayLoginConfig = null;

        for (Promotion057EveryDayLoginConfig config : this.getDayTurnsTaskConfigs()) {
            if (config.getIdx() == idx) {
                promotion057EveryDayLoginConfig = config;
            }
        }
        Asserts.notNull(promotion057EveryDayLoginConfig, ErrorCode.CONFIG_NOT_EXISTS.getValue(),
                String.format("不存在promotion057everydaylogin配置轮次｛%s｝,idx:{%s}", this.getDayTurns(), idx));

        return promotion057EveryDayLoginConfig;
    }


    /**
     * 获取当前轮任务的最高轮次
     *
     * @return
     */
    private int maxTurns() {
        List<Promotion057EveryDayLoginConfig> configList = this.getConfigList();
        int maxTurns = 0;
        for (Promotion057EveryDayLoginConfig config : configList) {
            if (config.getTurns() > maxTurns) {
                maxTurns = config.getTurns();
            }
        }
        return maxTurns;
    }

    /**
     * 获取当前任务轮次
     *
     * @return
     */
    public int getDayTurns() {
        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.MEI_RI_DENG_LU);
        int dayTurns = DateTimeUtil.apartDay(DateTimeUtil.theDayBreak(promotionControl.getStartTime()), DateTimeUtil.dayBreak()) + 1;
        dayTurns = dayTurns % maxTurns();
        return dayTurns == 0 ? maxTurns() : dayTurns;

    }


    public Promotion057EveryDayLogin getOrRefresh(long rid) {
        Promotion057EveryDayLogin promotion057EveryDayLogin = this.getPromotionInfo(rid);
        if (promotion057EveryDayLogin.getDailyTime() < DateTimeUtil.dayBreak()) {
            promotion057EveryDayLogin.getTaskReward().clear();
            promotion057EveryDayLogin.getTaskList().clear();
            promotion057EveryDayLogin.setDailyTime(DateTimeUtil.dayBreak());

            //初识化任务数据
            getDayTurnsTaskConfigs().forEach(task -> {

                TargetStruct targetStruct = task.getTargetStruct();
                if (targetStruct.getType() == TargetType.LOGIN) {
                    promotion057EveryDayLogin.getTaskList().put(task.getIdx(), 1);
                } else {
                    promotion057EveryDayLogin.getTaskList().put(task.getIdx(),
                            Math.min(targetCounterService.calcCount(rid, task.getTargetStruct()), targetStruct.getTarget()));
                }
            });

            this.updatePromotion(promotion057EveryDayLogin);

        }
        return promotion057EveryDayLogin;
    }

    /**
     * 增加进度值
     *
     * @param rid
     * @param addProgress
     */
    public void addProgress(long rid, int addProgress, List<Promotion057EveryDayLoginConfig> configList) {

        Promotion057EveryDayLogin promotion057EveryDayLogin = this.getOrRefresh(rid);

        List<ObjectGMsg.PSMapData> builderList = new ArrayList<>();
        configList.stream().filter(config -> !promotion057EveryDayLogin.getTaskReward().contains(config.getIdx())).forEach(config -> {

            int count = promotion057EveryDayLogin.getTaskList().getOrDefault(config.getIdx(), 0);
            promotion057EveryDayLogin.getTaskList().put(config.getIdx(), count + addProgress);

            builderList.add(builderTask(config.getIdx(), promotion057EveryDayLogin.getTaskList().get(config.getIdx())).build());
        });

        if (!builderList.isEmpty()) {
            this.updatePromotion(promotion057EveryDayLogin);
            //发送更新的任务数据
            this.sendUpdateTaskProgress(rid, builderList);
        }

    }


    /**
     * 替换进度值
     *
     * @param rid
     * @param newProgress
     */
    public void setProgress(long rid, int newProgress, List<Promotion057EveryDayLoginConfig> configList) {
        Promotion057EveryDayLogin promotion057EveryDayLogin = this.getOrRefresh(rid);

        List<ObjectGMsg.PSMapData> builderList = new ArrayList<>();
        configList.stream().filter(config -> !promotion057EveryDayLogin.getTaskReward().contains(config.getIdx())
                && promotion057EveryDayLogin.getTaskList().getOrDefault(config.getIdx(),0) < newProgress).forEach(config -> {

            promotion057EveryDayLogin.getTaskList().put(config.getIdx(), newProgress);

            builderList.add(builderTask(config.getIdx(), promotion057EveryDayLogin.getTaskList().get(config.getIdx())).build());
        });

        if (!builderList.isEmpty()) {
            this.updatePromotion(promotion057EveryDayLogin);
            //发送更新的任务数据
            this.sendUpdateTaskProgress(rid, builderList);
        }

    }


    public ObjectGMsg.PSMapData.Builder builderTask(int idx, int progress) {
        ObjectGMsg.PSMapData.Builder builder = ObjectGMsg.PSMapData.newBuilder();
        builder.setKey(idx);

        Promotion057EveryDayLoginConfig config = this.getConfig(idx);
        int count = Math.min(config.getTargetStruct().getTarget(), progress);
        builder.setValue(count);

        return builder;
    }

    /**
     * 发送更新进度
     *
     * @param rid
     * @param builderList
     */
    private void sendUpdateTaskProgress(long rid, List<ObjectGMsg.PSMapData> builderList) {
        if (!builderList.isEmpty()) {
            Promotion057GMsg.GResUpdateEveryDayLoginTarget.Builder builder = Promotion057GMsg.GResUpdateEveryDayLoginTarget.newBuilder();
            builder.addAllUpdateTasks(builderList);
            contextManager.write(rid, CmdCode._13202, builder.build());
        }
    }


}
