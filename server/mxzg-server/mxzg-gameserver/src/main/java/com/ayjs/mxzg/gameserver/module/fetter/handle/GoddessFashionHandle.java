package com.ayjs.mxzg.gameserver.module.fetter.handle;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.excel.cache.GoddessFashionMissionSysCache;
import com.ayjs.mxzg.config.excel.cache.GoddessFashionSmeltSysCache;
import com.ayjs.mxzg.config.excel.cache.GoddessFashionTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.GoddessUnlockSysCache;
import com.ayjs.mxzg.config.excel.entity.CGoddessFashionMission;
import com.ayjs.mxzg.config.excel.entity.CGoddessFashionSmelt;
import com.ayjs.mxzg.config.excel.entity.CGoddessFashionType;
import com.ayjs.mxzg.config.excel.entity.CGoddessUnlock;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.GoddessFashionUnlockType;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.fetter.domain.FetterGoddess2;
import com.ayjs.mxzg.gameserver.module.fetter.domain.GoddessFashion;
import com.ayjs.mxzg.gameserver.module.fetter.service.FetterService;
import com.ayjs.mxzg.gameserver.module.fetter.service.GoddessFashionService;
import com.ayjs.mxzg.gameserver.module.targetCounter.service.TargetCounterService;
import com.ayjs.mxzg.protocol.FetterGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;

@Controller
public class GoddessFashionHandle extends ProtocolHandler {

    @Autowired
    private FetterService fetterService;
    @Autowired
    private GoddessFashionService goddessFashionService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private TargetCounterService targetCounterService;

    @Autowired
    private GoddessFashionMissionSysCache goddessFashionMissionSysCache;
    @Autowired
    private GoddessFashionTypeSysCache goddessFashionTypeSysCache;
    @Autowired
    private GoddessFashionSmeltSysCache goddessFashionSmeltSysCache;
    @Autowired
    private GoddessUnlockSysCache goddessUnlockSysCache;

    @CMD(id = CmdCode._28200)
    public void getFashionData(PlayerContext playerContext, FetterGMsg.GReqFashionData req) {
        GoddessFashion goddessFashion = goddessFashionService.get(playerContext.getId());
        playerContext.write(CmdCode._28200, builderFashionData(goddessFashion));
    }

    @NotNull
    private FetterGMsg.GResFashionData builderFashionData(GoddessFashion goddessFashion) {
        FetterGMsg.GResFashionData.Builder builder = FetterGMsg.GResFashionData.newBuilder();
        builder.addAllActiveType(goddessFashion.getActiveType());
        builder.setUseType(goddessFashion.getCurrUse());
        return builder.build();
    }

    @CMD(id = CmdCode._28201)
    public void smelt(PlayerContext playerContext, FetterGMsg.GReqFashionSmelt req) {
        CGoddessFashionSmelt config = goddessFashionSmeltSysCache.getById(req.getIdx());
        long count = req.getNum();
        Asserts.isTrue(count > 0, ErrorCode.SYSTEM_ERROR.getValue(), String.format("参数错误{%s}", count));

        List<ImmutableThing> cost = ImmutableThingUtil.multiplyThing(config.getOrigin_item(), count);
        Asserts.isTrue(thingService.enough(playerContext.getId(), cost), ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具数量不足{%s}", GJsonUtils.toJson(config.getOrigin_item())));

        thingService.cost(playerContext.getId(), cost, GameEvent.GODDESS_FASHION_SMELT);
        thingService.add(playerContext.getId(), ImmutableThingUtil.multiplyThing(config.getTarget_item(), count), GameEvent.GODDESS_FASHION_SMELT);

        playerContext.write(CmdCode._28201, FetterGMsg.GResFashionSmelt.getDefaultInstance());
    }

    @CMD(id = CmdCode._28202)
    public void activeFashion(PlayerContext playerContext, FetterGMsg.GReqFashionActive req) {
        GoddessFashion goddessFashion = goddessFashionService.get(playerContext.getId());

        CGoddessFashionType config = goddessFashionTypeSysCache.getOrThrow(req.getType());

        Asserts.isTrue(!goddessFashion.getActiveType().contains(config.getType()), ErrorCode.GODDESS_FASHION_NOT_ACTIVE.getValue(),
                String.format("皮肤已激活{%s}", config.getType()));

        ArrayList<Integer> allGoddess = goddessUnlockSysCache.getAll().stream().mapToInt(CGoddessUnlock::getType)
                .collect(ArrayList::new, ArrayList::add, ArrayList::addAll);
        FetterGoddess2 fetterGoddess2 = fetterService.load(playerContext.getId());

        Asserts.isTrue(fetterGoddess2.getActiveType().containsAll(allGoddess), ErrorCode.GODDESS_NOT_UNLOCK.getValue(),
                String.format("女神未解锁{%s}", GJsonUtils.toJson(fetterGoddess2.getActiveType())));

        if (config.getUnlock_type() == GoddessFashionUnlockType.ITEM.getCode()) {
            Asserts.isTrue(thingService.enough(playerContext.getId(), config.getNeed_item()), ErrorCode.GODDESS_FASHION_EXP_LOW.getValue(),
                    String.format("道具不足{%s}", config.getNeed_item()));

            thingService.cost(playerContext.getId(), config.getNeed_item(), GameEvent.GODDESS_FASHION_ACTIVE);
        } else {
            List<Integer> fashionTypeTasks = goddessFashionMissionSysCache.getByFashionType(config.getType());
            Asserts.isTrue(goddessFashion.getTask_reward().containsAll(fashionTypeTasks), ErrorCode.GODDESS_FASHION_TASK_NOT_COMPLETE.getValue(),
                    String.format("未完成任务{%s}-{%s}", GJsonUtils.toJson(fashionTypeTasks), GJsonUtils.toJson(goddessFashion.getTask_reward())));
        }

        goddessFashionService.doActiveType(goddessFashion, config);

        FetterGMsg.GResFashionActive.Builder builder = FetterGMsg.GResFashionActive.newBuilder();
        builder.setType(config.getType());
        playerContext.write(CmdCode._28202, builder.build());

    }


    @CMD(id = CmdCode._28203)
    public void getTasks(PlayerContext playerContext, FetterGMsg.GReqFashionTasks req) {
        FetterGMsg.GResFashionTasks.Builder builder = FetterGMsg.GResFashionTasks.newBuilder();
        GoddessFashion goddessFashion = goddessFashionService.get(playerContext.getId());
        goddessFashionMissionSysCache.getAll().forEach(config -> {
            if (config.getTask().getType() != null) {
                builder.addTask(goddessFashionService.builderTask(playerContext.getId(), goddessFashion, config));
            }
        });
        playerContext.write(CmdCode._28203, builder.build());
    }

    @CMD(id = CmdCode._28204)
    public void getTaskReward(PlayerContext playerContext, FetterGMsg.GReqFashionTaskGet req) {
        GoddessFashion goddessFashion = goddessFashionService.get(playerContext.getId());

        CGoddessFashionMission config = goddessFashionMissionSysCache.getById(req.getTaskId());

        CGoddessFashionType fashionConfig = goddessFashionTypeSysCache.getOrThrow(config.getFashion_type());

        Asserts.isTrue(!goddessFashion.getTask_reward().contains(req.getTaskId()), ErrorCode.GODDESS_FASHION_TASK_HAD_GET.getValue(),
                String.format("任务已经领取{%s}", req.getTaskId(), JsonUtil.toJson(goddessFashion.getTask_reward())));

        FetterGoddess2 fetterGoddess2 = fetterService.load(playerContext.getId());
        ArrayList<Integer> allGoddess = goddessUnlockSysCache.getAll().stream().mapToInt(CGoddessUnlock::getType)
                .collect(ArrayList::new, ArrayList::add, ArrayList::addAll);
        Asserts.isTrue(fetterGoddess2.getActiveType().containsAll(allGoddess), ErrorCode.GODDESS_NOT_UNLOCK.getValue(),
                String.format("女神未解锁{%s}", GJsonUtils.toJson(fetterGoddess2.getActiveType())));

        long count = targetCounterService.calcTaskCount(playerContext.getId(), config.getTask());
        Asserts.isTrue(config.getTask().getTarget() <= count, ErrorCode.GODDESS_FASHION_PROCESS_LOW.getValue(),
                String.format("进度不足{%s}", count));

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.GODDESS_FASHION_TASK_REWARD);

        goddessFashion.getTask_reward().add(config.getIdx());
        goddessFashionService.update(goddessFashion);

        FetterGMsg.GResFashionTaskGet.Builder builder = FetterGMsg.GResFashionTaskGet.newBuilder();
        builder.setTask(goddessFashionService.builderTask(playerContext.getId(), goddessFashion, config));
        playerContext.write(CmdCode._28204, builder.build());

    }

    @CMD(id = CmdCode._28205)
    public void useFashion(PlayerContext playerContext, FetterGMsg.GReqFashionUse req) {
        GoddessFashion goddessFashion = goddessFashionService.get(playerContext.getId());

        if (req.getFashionType() == 0) {
            Asserts.isTrue(goddessFashion.getCurrUse() > 0, ErrorCode.GODDESS_FASHION_NOT_USE.getValue(),
                    String.format("未使用皮肤{%s}-{%s}", req.getFashionType(), goddessFashion.getCurrUse()));
        } else {
            CGoddessFashionType config = goddessFashionTypeSysCache.getById(req.getFashionType());
            Asserts.isTrue(goddessFashion.getActiveType().contains(config.getType()), ErrorCode.GODDESS_FASHION_NOT_ACTIVE.getValue(),
                    String.format("未激活皮肤{%s}", req.getFashionType()));
        }

        goddessFashion.setCurrUse(req.getFashionType());
        goddessFashionService.update(goddessFashion);

        FetterGMsg.GResFashionUse.Builder builder = FetterGMsg.GResFashionUse.newBuilder();
        builder.setUseType(req.getFashionType());
        playerContext.write(CmdCode._28205, builder.build());

    }

}
