package com.ayjs.mxzg.gameserver.module.countryWar.observer;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarConst;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarFlagMissionSysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarMissionSysCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarFlagMission;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarMission;
import com.ayjs.mxzg.config.excel.entity.countrywar.CountryWarMissionType;
import com.ayjs.mxzg.config.excel.entity.countrywar.CountryWarStage;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.event.ItemAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.ItemCostEvent;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.countryWar.domain.CountryWar;
import com.ayjs.mxzg.gameserver.module.countryWar.domain.CountryWarScoreMission;
import com.ayjs.mxzg.gameserver.module.countryWar.domain.CountryWarSystem;
import com.ayjs.mxzg.gameserver.module.countryWar.event.CountryWarAttackEvent;
import com.ayjs.mxzg.gameserver.module.countryWar.event.CountryWarDefendEvent;
import com.ayjs.mxzg.gameserver.module.countryWar.event.CountryWarMoveEvent;
import com.ayjs.mxzg.gameserver.module.countryWar.event.CountryWarRandomShopBuyEvent;
import com.ayjs.mxzg.gameserver.module.countryWar.pb.CountryWarPb;
import com.ayjs.mxzg.gameserver.module.countryWar.service.CountryWarService;
import com.ayjs.mxzg.gameserver.module.hero.event.LineUpChangeEvent;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.event.LogoutEvent;
import com.ayjs.mxzg.gameserver.module.role.event.RoleLvUpEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.module.targetCounter.event.RoleTriggerTargetEvent;
import com.ayjs.mxzg.gameserver.remote.large.event.StageCrossConnectEvent;
import com.ayjs.mxzg.message.module.countryWar.CountryWarRoleUpdateReqMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarSettleRecordReqMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarStageReqMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarUploadServerInfoReqMessage;
import com.ayjs.mxzg.message.module.countryWar.dto.CountryWarRoleInfo;
import com.ayjs.mxzg.message.module.countryWar.dto.CountryWarStageTimeInfo;
import com.ayjs.mxzg.protocol.CountryWarGMsg;
import com.ayjs.mxzg.template.scheduler.service.SchedulerService;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/4/21
 **/
@Observer
@Slf4j
public class CountryWarObserver implements Lifecycle {

    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private RoleService roleService;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private SchedulerService schedulerService;
    @Autowired
    private CountryWarConst countryWarConst;
    @Autowired
    private CountryWarMissionSysCache countryWarMissionSysCache;
    @Autowired
    private CountryWarFlagMissionSysCache countryWarFlagMissionSysCache;
    @Autowired
    private CountryWarService countryWarService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private CountryWarPb countryWarPb;
    @Autowired
    private ServerParamService serverParamService;

    private static int UPDATE_INTERVAL = 30;

    private ConcurrentMap<Long, Boolean> validRoles = new ConcurrentHashMap<>();

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf("country war update role");
    }

    @Override
    public void start() throws Exception {
        validRoles.putAll(roleService.getAllRole().stream().filter(this::canJoin).collect(Collectors.toConcurrentMap(Role::getId, key -> true)));
    }

    private boolean canJoin(Role role) {
        return System.currentTimeMillis() - role.getLastLoginTime() <= TimeUnit.DAYS.toMillis(countryWarConst.getOfflineDay()) &&
                role.getLevel() >= countryWarConst.getMinLv();
    }

    @Subscribe
    public void listen(StageCrossConnectEvent event) {
        messageDispatcher.dispatch(CountryWarStageReqMessage.of(serverConfig.getServerId()));
        CountryWarSystem countryWarSystem = countryWarService.getCountryWarSystem();
        messageDispatcher.dispatch(CountryWarSettleRecordReqMessage.of(serverConfig.getServerId(), countryWarSystem.getRewardRound()));
        reportServerToCross();
    }

    public void reportServerToCross() {
        Set<Long> updates = new HashSet<>(validRoles.keySet());
        long fightingSum = 0;
        if (serverParamService.getOpenDays() >= countryWarConst.getOpenDays()) {
            for (Long rid : updates) {
                Role role = roleService.getOrThrow(rid);
                if (canJoin(role)) {
                    fightingSum += role.getFighting();
                } else {
                    validRoles.remove(rid);
                }
            }
            messageDispatcher.dispatch(CountryWarUploadServerInfoReqMessage.of(serverConfig.getServerId(), fightingSum));
        }

        schedulerService.schedule("country war update role scheduler", () -> reportServerToCross(), UPDATE_INTERVAL, TimeUnit.MINUTES);

        log.info("更新服务器战力：{}", LocalDateTime.now());

    }

    @Subscribe
    public void listen(LineUpChangeEvent event) {
        if (event.getHeroLineUp().getType() == LineUpType.COUNTRY_WAR.getValue()) {
            Role role = roleService.getOrThrow(event.getHeroLineUp().getRid());
            report(role);
        }
    }

    @Subscribe
    public void listen(LogoutEvent event) {
        Role role = roleService.getOrThrow(event.getRid());
        if (canJoin(role)) {
            report(role);
        }
    }

    /***
     * 上报玩家信息到跨服
     * @param role
     */
    private void report(Role role) {
        CountryWarRoleUpdateReqMessage req = new CountryWarRoleUpdateReqMessage();
        req.setRid(role.getId());
        req.setMainServerId(serverConfig.getServerId());
        req.setOnline(role.getLastLoginTime() > role.getLastOfflineTime());
        CountryWarRoleInfo info = new CountryWarRoleInfo();
        info.setRid(role.getId());
        info.setName(role.getNick());
        info.setServerId(role.getServerId());
        req.setCountryWarRoleInfo(info);

        BattlerDo battlerDo = battleHelper.queryBattlerOrMain(BattleType.COUNTRY_WAR, role.getId(), Faction.ATTACKER);
        req.setBattleVo(GsonUtils.toJson(battlerDo.toBattlerVo()));
        messageDispatcher.dispatch(req);
    }

    @Subscribe
    public void listen(LoginEvent event) {
        Role role = roleService.getOrThrow(event.getRid());
        if (canJoin(role)) {
            validRoles.put(role.getId(), true);
            report(role);
        }
    }

    @Subscribe
    public void listen(RoleLvUpEvent event) {
        Role role = roleService.getOrThrow(event.getRid());
        if (canJoin(role)) {
            validRoles.put(role.getId(), true);
            report(role);
        }
    }

    @Subscribe
    public void listen(RoleTriggerTargetEvent event) {
        updateScoreMission(event);
        updateFlagMission(event);
    }

    @Subscribe
    private void listen(CountryWarMoveEvent event) {
        if (event.isCost()) {
            RoleTriggerTargetEvent temp = RoleTriggerTargetEvent.of(event.getRid(), TargetStruct.of(TargetType.COUNTRY_WAR_MOVE), 1,
                    RoleTriggerTargetEvent.MethodName.ADD);
            updateScoreMission(temp);
            updateFlagMission(temp);
        }
    }

    @Subscribe
    private void listen(CountryWarAttackEvent event) {
        long rid = event.getRid();
        if (event.isAttackSuccess()) {
            RoleTriggerTargetEvent temp = RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.COUNTRY_WAR_ATTACK_SUCC), 1,
                    RoleTriggerTargetEvent.MethodName.ADD);
            updateScoreMission(temp);
            updateFlagMission(temp);
        }
        if (event.isOccupy()) {
            RoleTriggerTargetEvent temp = RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.COUNTRY_WAR_OCCUPY), 1,
                    RoleTriggerTargetEvent.MethodName.ADD);
            updateScoreMission(temp);
            updateFlagMission(temp);
        }

        RoleTriggerTargetEvent temp = RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.COUNTRY_WAR_ATTACK), 1,
                RoleTriggerTargetEvent.MethodName.ADD);
        updateScoreMission(temp);
        updateFlagMission(temp);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ItemAddEvent event) {
        Map<Integer, Long> map = new HashMap<>();
        event.getAddValue().forEach(thing -> map.put(thing.getItem_type(), map.getOrDefault(thing.getItem_type(), 0l)
                + thing.getItem_num()));
        map.forEach((item, value) -> {
            RoleTriggerTargetEvent temp = RoleTriggerTargetEvent.of(event.getRid(), TargetStruct.of(TargetType.ADD_ITEM, item), value,
                    RoleTriggerTargetEvent.MethodName.ADD);
            updateScoreMission(temp);
            updateFlagMission(temp);
        });
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ItemCostEvent event) {
        Map<Integer, Long> map = new HashMap<>();
        event.getCostList().forEach(thing -> map.put(thing.getItem_type(), map.getOrDefault(thing.getItem_type(), 0l)
                + thing.getItem_num()));
        map.forEach((item, value) -> {
            RoleTriggerTargetEvent temp = RoleTriggerTargetEvent.of(event.getRid(), TargetStruct.of(TargetType.CONSUME_ITEM, item), value,
                    RoleTriggerTargetEvent.MethodName.ADD);
            updateScoreMission(temp);
            updateFlagMission(temp);
        });
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    private void listen(CountryWarDefendEvent event) {
        long rid = event.getRid();
        if (event.isDefendSuccess()) {
            RoleTriggerTargetEvent temp = RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.COUNTRY_WAR_DEFEND_SUCC), 1,
                    RoleTriggerTargetEvent.MethodName.ADD);
            updateScoreMission(temp);
            updateFlagMission(temp);
        }
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    private void listen(CountryWarRandomShopBuyEvent event) {
        long rid = event.getRid();
        RoleTriggerTargetEvent temp = RoleTriggerTargetEvent.of(rid, TargetStruct.of(TargetType.COUNTRY_WAR_RANDOM_BUY), event.getCount(),
                RoleTriggerTargetEvent.MethodName.ADD);
        updateScoreMission(temp);
        updateFlagMission(temp);
    }

    private void updateScoreMission(RoleTriggerTargetEvent event) {
        try {
            CountryWarStageTimeInfo time = countryWarService.getCountryWarStageTimeInfo();
            if (time == null || time.getStage() != CountryWarStage.WAR.getValue()) {
                return;
            }

            List<CCountryWarMission> update = new ArrayList<>();
            CountryWar countryWar = countryWarService.get(event.getRid());
            for (CountryWarMissionType missionType : CountryWarMissionType.values()) {
                int round = countryWar.getScoreMission().get(missionType.getType()).getRound();
                List<CCountryWarMission> list = countryWarMissionSysCache.getByRoundAndType(missionType.getType(), round);
                list = list.stream().filter(config -> TargetType.checkTrigger(config.getTarget(), event.getTargetStruct()))
                        .collect(Collectors.toList());
                if (list.size() <= 0) {
                    continue;
                }
                CountryWarScoreMission scoreMission = countryWar.getScoreMission().get(missionType.getType());
                for (CCountryWarMission config : list) {
                    if (scoreMission.getMissionReward().getOrDefault(config.getIdx(), false)) {
                        continue;
                    }
                    if (event.getAddOrSet() == RoleTriggerTargetEvent.MethodName.ADD) {
                        scoreMission.addCount(config.getIdx(), event.getTriggerCount());
                    } else {
                        scoreMission.setCount(config.getIdx(), event.getTriggerCount());
                    }
                    update.add(config);
                }
                countryWarService.update(countryWar);

            }
            if (CollectionUtil.isEmpty(update)) {
                return;
            }
            CountryWarGMsg.GResCountryWarScoreMissionUpdate.Builder builder = CountryWarGMsg.GResCountryWarScoreMissionUpdate.newBuilder();
            for (CCountryWarMission config : update) {
                CountryWarScoreMission mission = countryWar.getScoreMission().get(config.getType());
                builder.addTask(countryWarPb.builder(mission, config));
            }

            contextManager.write(event.getRid(), CmdCode._76357, builder.build());
        } catch (Exception e) {
            log.error("更新任务进度异常", e);
        }

    }

    private void updateFlagMission(RoleTriggerTargetEvent event) {
        try {
            CountryWarStageTimeInfo time = countryWarService.getCountryWarStageTimeInfo();
            if (time == null || time.getStage() != CountryWarStage.WAR.getValue()) {
                return;
            }
            List<CCountryWarFlagMission> update = new ArrayList<>();
            CountryWar countryWar = countryWarService.get(event.getRid());

            if (countryWar.getFlagRound() >= countryWarFlagMissionSysCache.getMaxRound()) {
                return;
            }

            List<CCountryWarFlagMission> list = countryWarFlagMissionSysCache.getByRound(countryWar.getFlagRound() + 1);
            list = list.stream().filter(config -> TargetType.checkTrigger(config.getTarget(), event.getTargetStruct()))
                    .collect(Collectors.toList());
            if (list.size() <= 0) {
                return;
            }
            for (CCountryWarFlagMission config : list) {
                if (countryWar.getFlagMissionReward().getOrDefault(config.getIdx(), false)) {
                    continue;
                }
                if (event.getAddOrSet() == RoleTriggerTargetEvent.MethodName.ADD) {
                    countryWar.addFlagCount(config.getIdx(), event.getTriggerCount());
                } else {
                    countryWar.setFlagCount(config.getIdx(), event.getTriggerCount());
                }
                update.add(config);
            }
            countryWarService.update(countryWar);

            if (CollectionUtil.isEmpty(update)) {
                return;
            }
            CountryWarGMsg.GResCountryWarFlagMissionUpdate.Builder builder = CountryWarGMsg.GResCountryWarFlagMissionUpdate.newBuilder();
            for (CCountryWarFlagMission config : update) {
                builder.addTask(countryWarPb.builderFlag(countryWar, config));
            }
            contextManager.write(event.getRid(), CmdCode._76377, builder.build());
        } catch (Exception e) {
            log.error("更新任务进度异常", e);
        }
    }

}
