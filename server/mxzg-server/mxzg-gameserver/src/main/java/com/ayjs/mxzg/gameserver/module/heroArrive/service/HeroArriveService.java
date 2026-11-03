package com.ayjs.mxzg.gameserver.module.heroArrive.service;

import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion011befallSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion011befall;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.event.ChapterRewardEvent;
import com.ayjs.mxzg.gameserver.module.heroArrive.dao.TaskHeroArriveDao;
import com.ayjs.mxzg.gameserver.module.heroArrive.domain.TaskHeroArrive;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.operatorValue.constant.OperatorType;
import com.ayjs.mxzg.gameserver.module.operatorValue.event.SevenDayTargetValueEvent;
import com.ayjs.mxzg.gameserver.module.operatorValue.service.OperatorValueService;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.SevenDayLoginRewardEvent;
import com.ayjs.mxzg.gameserver.module.role.constant.RoleParamType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.domain.RoleParam;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleParamService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.HeroArriveGMsg;
import com.ayjs.mxzg.protocol.HeroArriveGMsg.GResHeroArriveReward;
import com.ayjs.mxzg.protocol.HeroArriveGMsg.PSHeroArriveStatus;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/14 12:02
 */
@Service
@Observer
public class HeroArriveService {

    @Autowired
    TaskHeroArriveDao taskHeroArriveDao;
    @Autowired
    Promotion011befallSysCache promotion011befallSysCache;
    @Autowired
    RoleService roleService;
    @Autowired
    ThingService thingService;
    @Autowired
    ContextManager contextManager;
    @Autowired
    OperatorValueService operatorValueService;
    @Autowired
    ServerParamService serverParamService;
    @Autowired
    MailService mailService;
    @Autowired
    RoleParamService roleParamService;

    /**
     * 家立说不改，改了请服务器吃饭
     */
    private static final int END_DAYS = 3;

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void sendData(LoginEvent event) {
        long rid = event.getRid();
        sendData(rid);
    }

    private void sendData(long rid) {
        HeroArriveGMsg.GResHeroArriveData.Builder builder = HeroArriveGMsg.GResHeroArriveData.newBuilder();
        //发送英雄降临
        List<CPromotion011befall> allConfig = promotion011befallSysCache.getAll();
        for (CPromotion011befall config : allConfig) {
            TaskHeroArrive taskHeroArrive = loadTask(rid, config.getIdx());

            builder.addList(builderStatus(config, taskHeroArrive));

            builder.addDataList(builderProcess(rid, config, taskHeroArrive).build());
        }

        builder.setEndTime(getEndTime(rid));
        contextManager.write(rid, CmdCode._23000, builder.build());
    }

    public TaskHeroArrive loadTask(long rid, int idx) {
        TaskHeroArrive task = getTasksByIdx(rid, idx);
        if (task == null) {
            task = new TaskHeroArrive();
            task.setRid(rid);
            task.setIdx(idx);
            taskHeroArriveDao.add(task);
        }
        return task;
    }

    private int getEndTime(long rid) {
        return ConvertUtils.toInt(roleParamService.getOrCreate(rid, RoleParamType.HERO_ARRIVE_ACTIVE_TIME, () -> Integer.MAX_VALUE).getRpValue())
                + END_DAYS * TimeConstants.ONE_DAY_SECOND;
    }

    public List<TaskHeroArrive> getAllTask(long rid) {
        return taskHeroArriveDao.list("rid", rid);
    }

    /***
     * 领取每日奖励
     * @param rid
     * @param idx
     * @return
     */
    public ErrorCode rewardHeroArrive(long rid, int idx) {
        CPromotion011befall config = promotion011befallSysCache.getOrThrow(idx);

        Asserts.isTrue(config.getCan_reward() == 1, ErrorCode.HERO_ARRIVE_CANT_REWARD.getValue(),
                String.format("配置不可领取！can_reward:{%s}", config.getCan_reward()));

        Role role = roleService.getOrThrow(rid);

        TaskHeroArrive taskHeroArrive = loadTask(rid, idx);
        int count = 0;
        if (config.getType() == 0) {
//            List<TaskHeroArrive> tasks = getAllTask(rid);
            count = (int) getAllTask(rid).stream().filter(task -> task.isHadReward()).count();
        } else {
            count = operatorValueService.getCount(rid, config.getType());
        }

        Asserts.isTrue(count >= config.getNum(), ErrorCode.OPERATOR_COUNT_LOW.getValue(),
                String.format("进度值不够，要求{%s}，当前{%s}", config.getNum(), count));

        Asserts.isTrue(getEndTime(rid) >= DateTimeUtil.currentSecond(), ErrorCode.OPERATOR_COUNT_LOW.getValue(),
                String.format("活动已结束，结束时间:{%s},当前:{%s}", getEndTime(rid), DateTimeUtil.currentSecond()));

        Asserts.isTrue(!taskHeroArrive.isHadReward(), ErrorCode.HERO_ARRIVE_HAD_REWARD.getValue(),
                String.format("奖励已经领取{%s}", taskHeroArrive.isHadReward()));

        taskHeroArrive.setHadReward(true);
        taskHeroArriveDao.update(taskHeroArrive);
        //奖励
        Rewards list = thingService.add(role.getId(), config.getReward(), GameEvent.HERO_ARRIVE_REWARD);

        GResHeroArriveReward.Builder builder = GResHeroArriveReward.newBuilder();
        builder.setStatus(builderStatus(config, taskHeroArrive));
        builder.addAllList(PbUtil.buildReward(list.getThingSet().asList()));
        contextManager.write(rid, CmdCode._23001, builder.build());
        return ErrorCode.NO_ERROR;
    }

    /***
     * 获取任务
     * @param rid
     * @param type
     * @return
     */
    public List<TaskHeroArrive> getTasksByType(long rid, int type) {
        List<TaskHeroArrive> temps = taskHeroArriveDao.getAllByRid(rid);
        return temps.stream().filter(task -> {
            CPromotion011befall config = promotion011befallSysCache.getOrThrow(task.getIdx());
            return config.getType() == type;
        }).collect(Collectors.toList());
    }

    public List<TaskHeroArrive> getAllByRid(long rid) {
        List<TaskHeroArrive> temps = taskHeroArriveDao.list("rid", rid);
        if (getEndTime(rid) <= DateTimeUtil.currentSecond()) {
            //活动结束，邮件发放所有奖励
            List<TaskHeroArrive> list = temps.stream().filter(temp -> !temp.isHadReward()).collect(Collectors.toList());
            if (!list.isEmpty()) {
                List<Mail> mails = new ArrayList<>();
                list.forEach(task -> {
                    CPromotion011befall config = promotion011befallSysCache.getOrThrow(task.getIdx());
                    if (config != null) {
                        //领取未完成，邮件补发
                        if (!task.isHadReward() && operatorValueService.getCount(rid, config.getType()) > config.getNum()) {
                            task.setHadReward(true);
                            mails.add(mailService.newMailNoTitle(rid, MailScene.YING_XIONG_JIANG_LIN
                                    , null, config.getReward(), GameEvent.HERO_ARRIVE_REWARD));
                        }
                    }
                });
                if (!mails.isEmpty())
                    mailService.insertMails(mails);
            }
        }
        return temps;
    }

    /***
     * 获取任务
     * @param rid
     * @param idx
     * @return
     */
    public TaskHeroArrive getTasksByIdx(long rid, int idx) {
        List<TaskHeroArrive> temps = taskHeroArriveDao.getAllByRid(rid);
        return temps.stream().filter(task -> task.getIdx() == idx).findFirst().orElse(null);
    }

    @Subscribe
    public void chapterReward(ChapterRewardEvent event) {
        List<CPromotion011befall> configs = promotion011befallSysCache.getAll().stream().filter(config ->
                config.getType() == OperatorType.SEVEN_CHAPTER_NUM.getType() && config.getNum() == event.getChapterId()).collect(Collectors.toList());
        if (configs.isEmpty())
            return;
        long rid = event.getRid();
        activeHeroArrive(rid);
        updateTaskRewardState(rid, configs);
    }

    private void activeHeroArrive(long rid) {
        RoleParam param = roleParamService.getOrCreate(rid, RoleParamType.HERO_ARRIVE_ACTIVE_TIME, () -> Integer.MAX_VALUE);
        int now = DateTimeUtil.currentSecond();
        if (ConvertUtils.toInt(param.getRpValue()) > now) {
            param.setRpValue(now + "");
            roleParamService.update(param);
            sendData(rid);
        }
    }

    /**
     * 更新任务状态并推送给客户端
     *
     * @param rid
     * @param configs
     */
    private void updateTaskRewardState(long rid, List<CPromotion011befall> configs) {
        HeroArriveGMsg.GResHeroArriveStatusUpdate.Builder builder = HeroArriveGMsg.GResHeroArriveStatusUpdate.newBuilder();
        for (CPromotion011befall config : configs) {
            TaskHeroArrive task = loadTask(rid, config.getIdx());
            task.setHadReward(true);
            taskHeroArriveDao.update(task);
            builder.addStatus(builderStatus(config, task));
        }
        contextManager.write(rid, CmdCode._23003, builder.build());
    }

    private HeroArriveGMsg.PSHeroArriveStatus.Builder builderStatus(CPromotion011befall config, TaskHeroArrive taskHeroArrive) {
        PSHeroArriveStatus.Builder statusBuilder = PSHeroArriveStatus.newBuilder();
        statusBuilder.setIdx(config.getIdx());
        statusBuilder.setStatus(taskHeroArrive.isHadReward() ? 1 : 0);
        return statusBuilder;
    }

    /***
     * 操作值变化
     * @param event
     */
    @Subscribe
    public void listen(SevenDayTargetValueEvent event) {
        List<CPromotion011befall> configs = promotion011befallSysCache.getAll().stream().filter(config ->
                config.getType() == event.getOperatorType().getType()).collect(Collectors.toList());
        if (configs.isEmpty())
            return;
        long rid = event.getRid();
        configs.forEach(config -> {
            if (event.getOperatorType() == OperatorType.ACTIVE_BEST_MONTH_CARD) {
                activeHeroArrive(rid);
            }
            TaskHeroArrive task = loadTask(rid, config.getIdx());
            HeroArriveGMsg.GResHeroArriveUpdate.Builder builder = HeroArriveGMsg.GResHeroArriveUpdate.newBuilder();
            builder.setData(builderProcess(rid, config, task).build());
            contextManager.write(rid, CmdCode._23002, builder.build());
        });
    }

    @Subscribe
    public void rewardSevenDayLogin(SevenDayLoginRewardEvent event) {
        List<CPromotion011befall> configs = promotion011befallSysCache.getAll().stream().filter(config ->
                config.getType() == OperatorType.GET_SEVEN_DAYS_LOGIN.getType() && config.getNum() == event.getDay()).collect(Collectors.toList());
        if (configs.isEmpty())
            return;
        long rid = event.getRid();

        activeHeroArrive(rid);
        //推送状态改变
        updateTaskRewardState(rid, configs);
        //更新进度值
        configs.forEach(config -> {
            TaskHeroArrive task = loadTask(rid, config.getIdx());
            HeroArriveGMsg.GResHeroArriveUpdate.Builder builder = HeroArriveGMsg.GResHeroArriveUpdate.newBuilder();
            builder.setData(builderProcess(rid, config, task).build());
            contextManager.write(rid, CmdCode._23002, builder.build());
        });

    }

    private HeroArriveGMsg.PSHeroArriveData.Builder builderProcess(long rid, CPromotion011befall config, TaskHeroArrive taskHeroArrive) {
        HeroArriveGMsg.PSHeroArriveData.Builder builder = HeroArriveGMsg.PSHeroArriveData.newBuilder();
        builder.setId(config.getIdx());
        if (config.getType() == 0) {
            builder.setNum((int) getAllTask(rid).stream().filter(task -> task.isHadReward()).count());
        } else {
            if (taskHeroArrive.isHadReward()) {
                builder.setNum(config.getNum());
            } else {
                builder.setNum(operatorValueService.getCount(rid, config.getType()));
            }
        }
        builder.setType(config.getType());
        return builder;
    }
}
