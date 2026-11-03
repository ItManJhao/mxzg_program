package com.ayjs.mxzg.gameserver.module.fetter.handle;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.*;
import com.ayjs.mxzg.config.excel.entity.*;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.gm.GMCommand;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.GMCmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.fetter.constant.GoddessResetResult;
import com.ayjs.mxzg.gameserver.module.fetter.domain.FetterGoddess2;
import com.ayjs.mxzg.gameserver.module.fetter.domain.FetterTaskReward;
import com.ayjs.mxzg.gameserver.module.fetter.event.*;
import com.ayjs.mxzg.gameserver.module.fetter.service.FetterService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.targetCounter.service.TargetCounterService;
import com.ayjs.mxzg.protocol.FetterGMsg;
import com.ayjs.mxzg.protocol.FetterGMsg.*;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;

@Controller
public class FetterHandle extends ProtocolHandler {

    @Autowired
    private FetterService fetterService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private GoddessLevelSysCache goddessLevelSysCache;
    @Autowired
    private GoddessSkillCostSysCache goddessSkillcostSysCache;
    @Autowired
    private GoddessSkillRefineSysCache goddessSkillRefineSysCache;
    @Autowired
    private GoddessBreakSysCache goddessBreakSysCache;
    @Autowired
    private GoddessUnlockSysCache goddessUnlockSysCache;
    @Autowired
    private GoddessMissionSysCache goddessMissionSysCache;
    @Autowired
    private GoddessVipSysCache goddessVipSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private TargetCounterService targetCounterService;
    @Autowired
    private GoddessMakeSoulSysCache goddessMakeSoulSysCache;
    @Autowired
    private GoddessWashAttrSysCache goddessWashAttrSysCache;

    /**
     * 羁绊女神数据
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._28100)
    public void fetterDataList(PlayerContext playerContext, GReqFetterList msg) {
        this.goddessData(playerContext.getId());
    }

    private void goddessData(long rid) {
        GResFetterList.Builder builder = GResFetterList.newBuilder();
        builder.setResetCount(fetterService.getFetterTask(rid).getGoddessReset());
        //获取所有类型
        FetterGoddess2 fetterGoddess2 = fetterService.load(rid);
        fetterGoddess2.getActiveType().forEach(type -> {
            PSFetterData goddess = fetterService.transformGoddess(fetterGoddess2, type);
            builder.addGoddess(goddess);
        });

        contextManager.write(rid, CmdCode._28100, builder.build());
    }

    /**
     * 羁绊女神等级升级
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._28101)
    public void fetterUpLevel(PlayerContext playerContext, GReqFetterUpLevel msg) {

        FetterGoddess2 goddess = isExistGoddess(playerContext.getId(), msg.getIdx());

        int maxLv = goddessLevelSysCache.getAll().stream().mapToInt(CGoddessLevel::getLv).summaryStatistics().getMax();
        Asserts.isTrue(maxLv > goddess.getLevel(), ErrorCode.CONFIG_NOT_EXISTS.getValue(), "当前女神等级已达最大级， lv: " + goddess.getLevel());

        CGoddessLevel cModel = goddessLevelSysCache.getOrThrow(goddess.getLevel());
        // 扣道具并发送减道具协议
        thingService.cost(playerContext.getId(), cModel.getCost_res(), GameEvent.GODDESS);
        // 验证升级
        if (goddess.getExp() + cModel.getPoint_add() >= cModel.getNeed_point()) {
            // 升级
            goddess.setLevel(goddess.getLevel() + 1);
            goddess.setExp(goddess.getExp() + cModel.getPoint_add() - cModel.getNeed_point());
            eventBus.post(GoddessLevelUpEvent.of(playerContext.getId(), msg.getIdx(), goddess.getLevel(), 1));
        } else {
            // 加经验
            goddess.setExp(goddess.getExp() + cModel.getPoint_add());
        }

        fetterService.update(goddess);
        // 发送数据
        goddess.getActiveType().forEach(idx -> {
            GResFetterUpLevel.Builder builder = GResFetterUpLevel.newBuilder();
            builder.setIdx(idx);
            builder.setLevel(goddess.getLevel());
            builder.setExp(goddess.getExp());
            playerContext.write(CmdCode._28101, builder.build());
        });

        eventBus.post(GoddessLevelUpOperatorEvent.of(playerContext.getId(), msg.getIdx()));

    }

    /**
     * 羁绊女神技能升级
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._28102)
    public void fetterUpSkill(PlayerContext playerContext, GReqFetterUpSkill msg) {

        FetterGoddess2 goddess = isExistGoddess(playerContext.getId(), msg.getIdx());

        int maxSkillLevel = goddessSkillcostSysCache.getAll().stream().mapToInt(CGoddessSkillCost::getLevel).summaryStatistics().getMax();

        Asserts.isTrue(maxSkillLevel > goddess.getSkillLevel(), ErrorCode.GODDESS_SKILL_LEVEL.getValue(),
                "当前女神技能等级已达最大级， lv: " + goddess.getSkillLevel());

        CGoddessSkillCost cModel = goddessSkillcostSysCache.getGoddessSkillCost(goddess.getSkillLevel());

        Asserts.isTrue(cModel != null, ErrorCode.CONFIG_NOT_EXISTS.getValue(), "不存在当前羁绊技能等级的配置，SkillLevel:"
                + goddess.getSkillLevel() + "rid:" + playerContext.getId());

        Asserts.isTrue(goddess.getLevel() >= cModel.getNeed_base_level(), ErrorCode.GODDESS_UP.getValue(),
                "当前女神等级不足升级技能要求，lv: " + goddess.getLevel() + " need lv: " + cModel.getNeed_base_level());

        thingService.cost(playerContext.getId(), cModel.getCost_res(), GameEvent.GODDESS);

        // 修改数据
        goddess.setSkillLevel(goddess.getSkillLevel() + 1);
        fetterService.update(goddess);
        // 发送数据
        goddess.getActiveType().forEach(idx -> {
            GResFetterUpSkill.Builder builder = GResFetterUpSkill.newBuilder();
            builder.setIdx(msg.getIdx());
            builder.setLevel(goddess.getSkillLevel());
            playerContext.write(CmdCode._28102, builder.build());
        });

    }

    /**
     * 羈絆數據
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._28000)
    public void fetterInitTask(PlayerContext playerContext, GReqFetterInitTask msg) {
        FetterGMsg.GResFetterInitTask.Builder builder = FetterGMsg.GResFetterInitTask.newBuilder();

        long rid = playerContext.getId();
        List<CGoddessMission> missionList = goddessMissionSysCache.getAll();//任务进度
        FetterTaskReward fetterTaskReward = fetterService.getFetterTask(rid);
        List<Integer> taskList = fetterTaskReward.getTaskId();//任务领取
        for (CGoddessMission cModel : missionList) {
            FetterGMsg.PSFetterProgress.Builder progress = FetterGMsg.PSFetterProgress.newBuilder();
            progress.setIdx(cModel.getIdx());
            progress.setNum((int) targetCounterService.calcTaskCount(rid, cModel.getTask()));
            builder.addProgressList(progress.build());
            FetterGMsg.PSFetterStatus.Builder statusTask = FetterGMsg.PSFetterStatus.newBuilder();
            statusTask.setIdx(cModel.getIdx());
            if (taskList.contains(cModel.getIdx())) {
                statusTask.setStatus(1);
            } else {
                statusTask.setStatus(0);
            }
            builder.addStatusList(statusTask.build());
        }
        playerContext.write(CmdCode._28000, builder.build());
    }


    /**
     * 羁绊女神精炼升级
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._28003)
    public void fetterUpRefine(PlayerContext playerContext, GReqFetterUpRefine msg) {

        FetterGoddess2 goddess = isExistGoddess(playerContext.getId(), msg.getIdx());

        int maxRefineLevel = goddessSkillRefineSysCache.getAll().stream().mapToInt(CGoddessSkillRefine::getLevel).summaryStatistics().getMax();
        Asserts.isTrue(maxRefineLevel > goddess.getRefineLevel(), ErrorCode.GODDESS_REFINE_LEVEL.getValue(),
                "当前女神精炼等级已达最大级， lv: " + goddess.getRefineLevel());

        CGoddessSkillRefine cModel = goddessSkillRefineSysCache.getGoddessSkillRefine(goddess.getRefineLevel());

        Asserts.isTrue(cModel != null, ErrorCode.CONFIG_NOT_EXISTS.getValue(), "不存在当前羁绊精炼等级的配置，SkillRefine:"
                + goddess.getRefineLevel() + "rid:" + playerContext.getId());

        // 扣道具并发送减道具协议
        thingService.cost(playerContext.getId(), cModel.getCost_res(), GameEvent.GODDESS);

        // 修改数据
        goddess.setRefineLevel(goddess.getRefineLevel() + 1);
        fetterService.update(goddess);
        // 发送数据

        goddess.getActiveType().forEach(idx -> {
            GResFetterUpRefine.Builder builder = GResFetterUpRefine.newBuilder();
            builder.setIdx(msg.getIdx());
            builder.setLevel(goddess.getRefineLevel());
            playerContext.write(CmdCode._28003, builder.build());
        });

        eventBus.post(GoddessRefineEvent.of(playerContext.getId(), goddess.getRefineLevel()));

    }

    /**
     * 羁绊女神突破
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._28104)
    public void fetterUpLimit(PlayerContext playerContext, GReqFetterUplimit msg) {

        FetterGoddess2 goddess = isExistGoddess(playerContext.getId(), msg.getIdx());

        int maxUpLimitLevel = goddessBreakSysCache.getAll().stream().mapToInt(CGoddessBreak::getLv).summaryStatistics().getMax();

        Asserts.isTrue(maxUpLimitLevel > goddess.getUplimitLevel(), ErrorCode.GODDESS_BREAK_LEVEL.getValue(),
                "当前女神突破等级已达最大级， lv: " + goddess.getUplimitLevel());

        CGoddessBreak cModel = goddessBreakSysCache.getOrThrow(goddess.getUplimitLevel());
        // 扣道具并发送减道具协议
        thingService.cost(playerContext.getId(), cModel.getCost_res(), GameEvent.GODDESS);
        // 修改数据
        goddess.setUplimitLevel(goddess.getUplimitLevel() + 1);
        fetterService.update(goddess);
        // 发送数据
        goddess.getActiveType().forEach(idx -> {
            GResFetterUplimit.Builder builder = GResFetterUplimit.newBuilder();
            builder.setIdx(msg.getIdx());
            builder.setLevel(goddess.getUplimitLevel());
            playerContext.write(CmdCode._28104, builder.build());
        });

        eventBus.post(GoddessBreakEvent.of(playerContext.getId(), goddess.getUplimitLevel()));

    }

    private FetterGoddess2 isExistGoddess(long rid, int goddessId) {

        Asserts.isTrue(!checkGoddessLevel(rid), ErrorCode.GODDESS_VIP.getValue(), "VIP等级未满级，无法升级女神。");

        FetterGoddess2 goddess = fetterService.load(rid);

        Asserts.isTrue(goddess.getActiveType().contains(goddessId), ErrorCode.GODDESS_NOT_UNLOCK.getValue(),
                "未获取该女神, goddessType: " + goddessId);

        return goddess;
    }

    /**
     * 验证角色VIP等级
     *
     * @param rid
     * @return
     */
    private boolean checkGoddessLevel(long rid) {
        Role role = roleService.getOrThrow(rid);
        int maxVip = goddessVipSysCache.getAll().stream().mapToInt(CGoddessVip::getVip_level).summaryStatistics().getMax();
        return role.getGoddessVip() < maxVip;
    }


    /**
     * 领取羁绊任务
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._28002)
    public void fetterTaskReward(PlayerContext playerContext, GReqFetterReward msg) {

        CGoddessMission cModel = goddessMissionSysCache.getOrThrow(msg.getIdx());

        FetterTaskReward fetterTaskReward = fetterService.getFetterTask(playerContext.getId());
        List<Integer> rewardList = fetterTaskReward.getTaskId();

        Asserts.isTrue(!rewardList.contains(msg.getIdx()), ErrorCode.GODDESS_TASK_REWARD.getValue(), "该奖励已领取， idx: " + msg.getIdx());

        Asserts.isTrue(targetCounterService.calcTaskCount(playerContext.getId(), cModel.getTask()) >= cModel.getTask().getTarget()
                , ErrorCode.GODDESS_TASK_PROCESS.getValue(), "任务进度不足以领取， idx: " + msg.getIdx());

        // 更新羁绊任务数据
        rewardList.add(msg.getIdx());
        fetterTaskReward.setTaskId(rewardList);
        fetterService.updateFetterTaskReward(fetterTaskReward);

        thingService.add(playerContext.getId(), cModel.getReward(), GameEvent.GODDESS_REWARD, NoticeType.NORMAL);

        // 发送奖励领取成功协议
        PSFetterStatus.Builder statusModel = PSFetterStatus.newBuilder();
        statusModel.setIdx(msg.getIdx());
        statusModel.setStatus(1);
        GResFetterReward.Builder builder = GResFetterReward.newBuilder();
        builder.setFetterStatus(statusModel);
        playerContext.write(CmdCode._28002, builder.build());
        // 判断是否可以升羁绊神器VIP等级
        for (CGoddessMission cGoddessMission : goddessMissionSysCache.getAll()) {
            if (cGoddessMission.getVip_level() == cModel.getVip_level() && !rewardList.contains(cGoddessMission.getIdx())) {
                return;//此处只为中断执行。无需返回协议
            }
        }
        // 更新数据
        this.upGoddessVip(playerContext.getId());

    }

    /**
     * 重置羁绊女神
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._28105)
    public void removeGoddess(PlayerContext playerContext, FetterGMsg.GReqFetterReset msg) {
        FetterGMsg.GResFetterReset.Builder builder = FetterGMsg.GResFetterReset.newBuilder();
        builder.setIdx(msg.getIdx());
        FetterGoddess2 fetterGoddess = fetterService.load(playerContext.getId());

        int resultCode = fetterService.checkRemoveGoddess(playerContext.getId(), fetterGoddess);
        builder.setStatus(resultCode);
        if (resultCode != GoddessResetResult.ACHIEVE.getType()) {
            playerContext.write(CmdCode._28105, builder.build());
            return;
        }

        builder.setResetCount(fetterService.getFetterTask(playerContext.getId()).getGoddessReset());
        //返回资源
        List<ImmutableThing> rewardList = new ArrayList<>();
        //等级
        for (int lv = 1; lv <= fetterGoddess.getLevel(); lv++) {
            CGoddessLevel cGoddessLevel = goddessLevelSysCache.getOrThrow(lv);
            if (cGoddessLevel.getLv() == fetterGoddess.getLevel()) {
                if (fetterGoddess.getExp() > 0) {
                    rewardList.addAll(ImmutableThingUtil.multiplyThing(cGoddessLevel.getCost_res(),
                            fetterGoddess.getExp() / cGoddessLevel.getPoint_add()));
                }
            } else {
                rewardList.addAll(ImmutableThingUtil.multiplyThing(cGoddessLevel.getCost_res(),
                        cGoddessLevel.getNeed_point() / cGoddessLevel.getPoint_add()));
            }
        }
        //突破
        for (CGoddessBreak cGoddessBreak : goddessBreakSysCache.getAll()) {
            if (cGoddessBreak.getLv() < fetterGoddess.getUplimitLevel()) {
                rewardList.addAll(cGoddessBreak.getCost_res());
            }
        }
        //技能
        for (CGoddessSkillCost cGoddessSkillcost : goddessSkillcostSysCache.getAll()) {
            if (cGoddessSkillcost.getLevel() < fetterGoddess.getSkillLevel()) {
                rewardList.addAll(cGoddessSkillcost.getCost_res());
            }
        }
        //精炼
        for (CGoddessSkillRefine cGoddessSkillRefine : goddessSkillRefineSysCache.getAll()) {
            if (cGoddessSkillRefine.getLevel() < fetterGoddess.getRefineLevel()) {
                rewardList.addAll(cGoddessSkillRefine.getCost_res());
            }
        }
        List<ImmutableThing> immutableThingList = ImmutableThingUtil.mergeThing(rewardList);
        thingService.add(playerContext.getId(), immutableThingList, GameEvent.GODDESS_RESET_REWARD);

        fetterGoddess.setExp(0);
        fetterGoddess.setLevel(1);
        fetterGoddess.setSkillLevel(1);
        fetterGoddess.setUplimitLevel(0);
        fetterGoddess.setRefineLevel(0);
        fetterGoddess.setSoulLevel(0);
        fetterService.update(fetterGoddess);
        playerContext.write(CmdCode._28105, builder.build());

        goddessData(playerContext.getId());


    }


    /**
     * 解锁所有羁绊女神
     *
     * @param role
     * @param param
     */
    @GMCommand(command = GMCmdCode.ADD_GODDESS)
    public void gmAddGoddess(Role role, List<String> param) {

        FetterGoddess2 load = fetterService.load(role.getId());
        goddessUnlockSysCache.getAll().forEach(config -> {
            load.getActiveType().add(config.getType());
        });
        fetterService.update(load);

        FetterTaskReward fetterTaskReward = fetterService.getFetterTask(role.getId());
        List<Integer> taskList = fetterService.getFetterTask(role.getId()).getTaskId();
        goddessMissionSysCache.getAll().forEach(config -> {
            if (!taskList.contains(config.getIdx())) {
                taskList.add(config.getIdx());
            }
        });

        fetterTaskReward.setTaskId(taskList);
        fetterService.updateFetterTaskReward(fetterTaskReward);

        role.setGoddessVip(13);
        roleService.updateRole(role);
        eventBus.post(GoddessVipLevelUpEvent.of(role.getId(), role.getGoddessVip()));

        GResFetterUpdateVip.Builder builder2 = GResFetterUpdateVip.newBuilder();
        builder2.setVipLevel(role.getGoddessVip());
        contextManager.write(role.getId(), CmdCode._28004, builder2.build());

        this.goddessData(role.getId());
    }

    @GMCommand(command = GMCmdCode.UP_GODDESS_VIP)
    public void upGoddessVip(Role role, List<String> param) {
        if (role.getGoddessVip() == 13) {
            return;
        }
        upGoddessVip(role.getId());
    }

    @GMCommand(command = GMCmdCode.GODDESS_LEVEL)
    public void upGoddessLevel(Role role, List<String> param) {
        FetterGoddess2 load = fetterService.load(role.getId());
        int addLv = param.size() == 0 ? 1 : Integer.valueOf(param.get(0));
        load.setLevel(Math.min(load.getLevel() + addLv, 50));
        fetterService.update(load);
    }

    private void upGoddessVip(long rid) {

        // 更新数据
        Role role = roleService.getOrThrow(rid);
        role.setGoddessVip(role.getGoddessVip() + 1);
        roleService.updateRole(role);
        // 返回升级后的羁绊等级
        GResFetterUpdateVip.Builder builder2 = GResFetterUpdateVip.newBuilder();
        builder2.setVipLevel(role.getGoddessVip());
        contextManager.write(rid, CmdCode._28004, builder2.build());
        // 若升级后的羁绊等级够解锁羁绊神器
        // 遍历是否解锁神器
        FetterGoddess2 fetterGoddess2 = fetterService.load(rid);
        List<CGoddessUnlock> GoddessUnlockList = goddessUnlockSysCache.getAll();
        for (CGoddessUnlock cGoddessUnlock : GoddessUnlockList) {
            if (cGoddessUnlock.getVip_level() == role.getGoddessVip()) {// 若神器VIP等级刚好达到等级，便解锁
                // 当有神器解锁时，便发送单个神器数据
                GResFetterData.Builder builder3 = GResFetterData.newBuilder();// 单个羁绊数据
                fetterGoddess2.getActiveType().add(cGoddessUnlock.getType());
                fetterService.update(fetterGoddess2);

                PSFetterData model = fetterService
                        .transformGoddess(fetterGoddess2, cGoddessUnlock.getType());
                builder3.setModel(model);
                contextManager.write(rid, CmdCode._28005, builder3.build());
                // 发送所有羁绊女神数据
                GResFetterList.Builder builder4 = GResFetterList.newBuilder();
                for (Integer type : fetterGoddess2.getActiveType()) {
                    PSFetterData goddess = fetterService.transformGoddess(fetterGoddess2, type);
                    builder4.addGoddess(goddess);
                }
                contextManager.write(rid, CmdCode._28100, builder4.build());

                eventBus.post(GoddessUnlockEvent.of(role.getId(), cGoddessUnlock.getType()));
                eventBus.post(GoddessLevelUpEvent.of(rid, cGoddessUnlock.getType(), 1, 1));
            }
        }
        eventBus.post(GoddessVipLevelUpEvent.of(role.getId(), role.getGoddessVip()));

    }

    /**
     * 羁绊铸魂
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._28106)
    public void goddessMakeSoul(PlayerContext playerContext, FetterGMsg.GReqFetterMakeSoul msg) {

        FetterGMsg.GResFetterMakeSoul.Builder builder = FetterGMsg.GResFetterMakeSoul.newBuilder();
        FetterGoddess2 goddess = isExistGoddess(playerContext.getId(), msg.getIdx());

        CGoddessMakeSoul cGoddessMakeSoul = goddessMakeSoulSysCache.getOrThrow(goddess.getLevel());

        Asserts.isTrue(goddess.getSoulLevel() + msg.getNum() <= cGoddessMakeSoul.getLimit(),
                ErrorCode.GODDESS_SOUL_LEVEL_LIMIT.getValue(), "铸魂等级超过限制");

        List<ImmutableThing> costList = ImmutableThingUtil.multiplyThing(cGoddessMakeSoul.getCost_item(), msg.getNum());

        thingService.cost(playerContext.getId(), costList, GameEvent.GODDESS);

        goddess.setSoulLevel(goddess.getSoulLevel() + msg.getNum());
        fetterService.update(goddess);

        builder.setIdx(msg.getIdx());
        builder.setSoulCount(goddess.getSoulLevel());
        playerContext.write(CmdCode._28106, builder.build());

        eventBus.post(GoddessSoulEvent.of(playerContext.getId(), goddess.getSoulLevel()));

    }

    /**
     * 查看契约
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._28107)
    public void scanFetterContract(PlayerContext playerContext, GReqFetterContractInfo msg) {
        FetterTaskReward fetterTask = fetterService.getFetterTask(playerContext.getId());

        GResFetterContractInfo.Builder builder = GResFetterContractInfo.newBuilder();
        builder.addAllContracts(fetterTask.getContracts());
        playerContext.write(CmdCode._28107, builder.build());
    }

    /**
     * 解锁契约
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._28108)
    public void activeFetterContract(PlayerContext playerContext, GReqFetterContractActive msg) {

        //TODO 暂时没有后续的契约定义，后续完善
        Asserts.isTrue(msg.getType() == 1, ErrorCode.ERROR_PARAM.getValue(), "参数错误" + msg.getType());

        FetterTaskReward fetterTask = fetterService.getFetterTask(playerContext.getId());
        Asserts.isTrue(!fetterTask.getContracts().contains(msg.getType()), ErrorCode.CONTRACT_ACTIVE.getValue(), "该契约已经解锁");

        if (msg.getType() == 1) {
            FetterGoddess2 fetterGoddess2 = fetterService.load(playerContext.getId());
            Asserts.isTrue(fetterGoddess2.getActiveType().size() == goddessUnlockSysCache.getAll().size(),
                    ErrorCode.CONTRACT_NOT_ACTIVE.getValue(), "该契约还没有达到解锁条件");

            fetterTask.getContracts().add(msg.getType());
            fetterService.updateFetterTaskReward(fetterTask);
        } else {
            //TODO 其它契约解锁的处理
        }

        GResFetterContractActive.Builder builder = GResFetterContractActive.newBuilder();
        builder.setType(msg.getType());
        playerContext.write(CmdCode._28108, builder.build());

    }

    /**
     * 羁绊洗炼
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._28109)
    public void goddessWash(PlayerContext playerContext, GReqFetterWash msg) {

        Asserts.isTrue(!checkGoddessLevel(playerContext.getId()), ErrorCode.GODDESS_VIP.getValue(), "VIP等级未满级，无法升级女神。");

        FetterGoddess2 goddess = fetterService.load(playerContext.getId());
        Asserts.isTrue(goddess.getWashLevel() < goddessWashAttrSysCache.getMaxLevel(), ErrorCode.GODDESS_WASH_LEVEL_MAX.getValue(), "洗炼已达最高级。");

        CGoddessWashAttr goddessWashAttr = goddessWashAttrSysCache.getWashLevel(goddess.getWashLevel());
        Asserts.isTrue(goddess.getLevel() >= goddessWashAttr.getLevel(), ErrorCode.GODDESS_WASH_NOT_LEVEL.getValue(),
                String.format("要求羁绊女神等级：{%s}，当前等级：{%s}", goddessWashAttr.getLevel(), goddess.getLevel()));

        thingService.cost(playerContext.getId(), goddessWashAttr.getCost_res(), GameEvent.GODDESS_WASH);

        goddess.setWashLevel(goddess.getWashLevel() + 1);
        fetterService.update(goddess);

        GResFetterWash.Builder builder = GResFetterWash.newBuilder();
        builder.setWashLevel(goddess.getWashLevel());
        playerContext.write(CmdCode._28109, builder.build());

        eventBus.post(GoddessWashLevelEvent.of(playerContext.getId(), goddess.getWashLevel()));
    }

}
