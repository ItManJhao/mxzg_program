package com.ayjs.mxzg.gameserver.module.fetter.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.excel.cache.GoddessFashionMissionSysCache;
import com.ayjs.mxzg.config.excel.entity.CGoddessFashionMission;
import com.ayjs.mxzg.config.excel.entity.CGoddessFashionType;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.fetter.dao.GoddessFashionDao;
import com.ayjs.mxzg.gameserver.module.fetter.domain.GoddessFashion;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessFashionActiveEvent;
import com.ayjs.mxzg.gameserver.module.targetCounter.service.TargetCounterService;
import com.ayjs.mxzg.protocol.FetterGMsg;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/7/20
 **/
@Service
public class GoddessFashionService {

    @Autowired
    private GoddessFashionDao goddessFashionDao;
    @Autowired
    private TargetCounterService targetCounterService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private GoddessFashionMissionSysCache goddessFashionMissionSysCache;
    @Autowired
    private EventBus eventBus;

    public GoddessFashion get(long rid) {
        GoddessFashion goddessFashion = goddessFashionDao.get(rid);
        if (Objects.isNull(goddessFashion)) {
            goddessFashion = new GoddessFashion();
            goddessFashion.setRid(rid);
            goddessFashionDao.add(goddessFashion);
        }
        return goddessFashion;
    }

    public void update(GoddessFashion goddessFashion) {
        goddessFashionDao.update(goddessFashion);
    }

    @NotNull
    public FetterGMsg.PSFashionTask.Builder builderTask(long rid, GoddessFashion goddessFashion, CGoddessFashionMission config) {
        FetterGMsg.PSFashionTask.Builder taskBuilder = FetterGMsg.PSFashionTask.newBuilder();
        long count = targetCounterService.calcTaskCount(rid, config.getTask());
        if (goddessFashion.getTask_reward().contains(config.getIdx())) {
            taskBuilder.setHadReward(true);
            taskBuilder.setProcess(config.getTask().getTarget());
        } else {
            taskBuilder.setProcess(count > config.getTask().getTarget() ? config.getTask().getTarget() : count);
            taskBuilder.setHadReward(false);
        }
        taskBuilder.setTaskId(config.getIdx());

        return taskBuilder;
    }

    public void updateTaskToClient(long rid, TargetStruct targetStruct) {
        GoddessFashion goddessFashion = get(rid);
        List<CGoddessFashionMission> missionConfigs = goddessFashionMissionSysCache.getMissionBy(targetStruct.getType());
        if (CollectionUtil.isEmpty(missionConfigs)) {
            return;
        }
        FetterGMsg.GResFashionUpdateTask.Builder builder = FetterGMsg.GResFashionUpdateTask.newBuilder();
        missionConfigs = missionConfigs.stream().filter(config ->
                TargetType.checkStruct(config.getTask(), targetStruct.getCondition(), targetStruct.getSubCondition()) &&
                        !goddessFashion.getTask_reward().contains(config.getIdx())).collect(Collectors.toList());
        if (missionConfigs.isEmpty()) {
            return;
        }
        missionConfigs.stream().forEach(config -> {
            builder.addTask(builderTask(rid, goddessFashion, config));
        });
        contextManager.write(rid, CmdCode._28206, builder.build());
    }

    public void doActiveType(GoddessFashion goddessFashion, CGoddessFashionType config) {
        goddessFashion.getActiveType().add(config.getType());
        update(goddessFashion);
        eventBus.post(GoddessFashionActiveEvent.of(goddessFashion.getRid()));
    }
}
