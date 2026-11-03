package com.ayjs.mxzg.cross.module.magicTower.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.magicTower.MagicTowerSysCache;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.crossservice.service.CrossServerGroupService;
import com.ayjs.mxzg.cross.module.magicTower.domain.MagicTower;
import com.ayjs.mxzg.cross.module.magicTower.domain.MagicTowerGroupLevel;
import com.ayjs.mxzg.cross.module.magicTower.domain.MagicTowerServer;
import com.ayjs.mxzg.cross.module.magicTower.event.MagicTowerPassLevelEvent;
import com.ayjs.mxzg.cross.module.magicTower.service.MagicTowerLevelRankService;
import com.ayjs.mxzg.cross.module.magicTower.service.MagicTowerService;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerArenaChangeBroReq;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerLevelArenaChangeReq;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerLevelArenaChangeRes;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerLevelArenaRoleReq;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerLevelArenaRoleRes;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerLevelPassBroReq;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerLevelPassDetailReq;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerLevelPassDetailRes;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerLevelRankReq;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerLevelRankRes;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerListAllLevelReq;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerListAllLevelRes;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerPassLevelReq;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.protocol.MagicTowerGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.annotation.Remote;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/6/21
 **/
@Remote
public class MagicTowerHandler implements MessageHandler {

    @Autowired
    private MagicTowerService magicTowerService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private MagicTowerSysCache magicTowerSysCache;
    @Autowired
    private CrossRoleService crossRoleService;
    @Autowired
    private CrossServerGroupService crossServerGroupService;
    @Autowired
    private MagicTowerLevelRankService levelRankService;
    @Autowired
    private MessageHelper messageHelper;

    @RemoteMethod
    public void passLevel(MagicTowerPassLevelReq req) {
        CrossRole role = crossRoleService.getOrThrow(req.getRid());
        magicTowerSysCache.getOrThrow(req.getLevel());

        tryUpdateRoleMaxPassLevel(req);

        int groupId = crossServerGroupService.getGroupId(role.getServerId());
        MagicTowerGroupLevel magicTowerGroupLevel = magicTowerService.safeCreateGroupLevel(groupId, req.getLevel(), role.getId());
        boolean broadcast = false;
        synchronized (magicTowerService.getGroupLock(groupId, req.getLevel())) {
            MagicTowerServer magicTowerServer = magicTowerService.loadMagicTowerServer(role.getServerId(), req.getLevel());

            if (magicTowerServer.getSpendTime() >= req.getPassTime()) {
                magicTowerServer.setMinTimeRid(req.getRid());
                magicTowerServer.setSpendTime(req.getPassTime());
                magicTowerServer.setTimeBattleId(req.getBattleId());
                magicTowerService.update(magicTowerServer);
                if (magicTowerGroupLevel.getSpendTime() > magicTowerServer.getSpendTime()) {
                    magicTowerGroupLevel.setMinTimeRid(req.getRid());
                    magicTowerGroupLevel.setSpendTime(req.getPassTime());
                    magicTowerGroupLevel.setTimeBattleId(req.getBattleId());
                    magicTowerService.update(magicTowerGroupLevel);
                    broadcast = true;
                }
            }

            if (magicTowerServer.getMinFighting() >= req.getFighting()) {
                magicTowerServer.setMinFightingRid(req.getRid());
                magicTowerServer.setMinFighting(req.getFighting());
                magicTowerServer.setFightBattleId(req.getBattleId());
                magicTowerService.update(magicTowerServer);
                if (magicTowerGroupLevel.getMinFighting() > magicTowerServer.getMinFighting()) {
                    magicTowerGroupLevel.setMinFightingRid(magicTowerServer.getMinFightingRid());
                    magicTowerGroupLevel.setMinFighting(magicTowerServer.getMinFighting());
                    magicTowerGroupLevel.setFightBattleId(req.getBattleId());
                    magicTowerService.update(magicTowerGroupLevel);
                    broadcast = true;
                }
            }
        }

        if (broadcast) {
            messageHelper.pushToGroupMessage(groupId, MagicTowerLevelPassBroReq.of(
                    magicTowerService.builderSimplePassData(magicTowerGroupLevel).toByteArray()));
        }
    }


    private boolean tryUpdateRoleMaxPassLevel(MagicTowerPassLevelReq req) {
        MagicTower magicTower = magicTowerService.load(req.getRid());
        if (req.getLevel() < magicTower.getPassLevel() ||
                req.getLevel() == magicTower.getPassLevel() && req.getPassTime() >= magicTower.getPassTime()) {
            return true;
        }

        magicTower.setPassLevel(req.getLevel());
        magicTower.setPassTime(req.getPassTime());
        magicTower.setRankTime(LocalDateTime.now());
        magicTowerService.update(magicTower);
        eventBus.post(MagicTowerPassLevelEvent.of(req.getRid()));
        return false;
    }

    @RemoteMethod
    public MagicTowerLevelArenaRoleRes reqArenaRole(MagicTowerLevelArenaRoleReq req) {
        CrossRole challenge = crossRoleService.getOrThrow(req.getRid());
        int groupId = crossServerGroupService.getGroupId(challenge.getServerId());
        MagicTowerGroupLevel groupLevel = magicTowerService.getGroupLevel(groupId, req.getLevel());
        Asserts.isTrue(groupLevel != null || groupLevel.getArenaRid() != 0,
                ErrorCode.MAGIC_TOWER_ARENA_CHANGE.getValue(),
                String.format("服务器：{%s},组：{%s},关卡：{%s}，不存在擂主：", challenge.getServerId(), groupLevel.getArenaRid(), req.getLevel()));
        MagicTowerGMsg.PSMagicTowerArena builder = magicTowerService.builderArenaRole(groupLevel);
        return MagicTowerLevelArenaRoleRes.of(builder.toByteArray());
    }


    @RemoteMethod
    public MagicTowerLevelArenaChangeRes changeArena(MagicTowerLevelArenaChangeReq req) {
        CrossRole role = crossRoleService.getOrThrow(req.getRid());
        int groupId = crossServerGroupService.getGroupId(role.getServerId());
        MagicTowerGroupLevel groupLevel = magicTowerService.getGroupLevel(groupId, req.getLevel());
        MagicTowerGMsg.PSMagicTowerArena old = magicTowerService.builderArenaRole(groupLevel);
        synchronized (magicTowerService.getGroupLock(groupId, req.getLevel())) {
            Asserts.isTrue(groupLevel.getArenaRid() == req.getDefendId(),
                    ErrorCode.MAGIC_TOWER_ARENA_CHANGE.getValue(),
                    String.format("当前：{%s},防守：{%s}", groupLevel.getArenaRid(), req.getDefendId()));

            groupLevel.setArenaRid(req.getRid());
            magicTowerService.update(groupLevel);
        }
        MagicTowerGMsg.PSMagicTowerArena newArena = magicTowerService.builderArenaRole(groupLevel);

        messageHelper.pushToGroupMessage(groupId, MagicTowerArenaChangeBroReq.of(newArena.toByteArray(),
                old.toByteArray(), groupLevel.getLevel()));

        return MagicTowerLevelArenaChangeRes.of(newArena.toByteArray());
    }

    @RemoteMethod
    public MagicTowerListAllLevelRes listAllLevel(MagicTowerListAllLevelReq req) {
        int groupId = crossServerGroupService.getGroupId(req.getServerId());
        List<MagicTowerGroupLevel> groupLevels = magicTowerService.getAllGroupLevel(groupId).stream().
                sorted(Comparator.comparingInt(MagicTowerGroupLevel::getLevel))
                .collect(Collectors.toList());
        List<byte[]> list = new ArrayList<>();
        List<byte[]> passDataList = new ArrayList<>();
        groupLevels.forEach(arena -> {
            list.add(magicTowerService.builderArenaRole(arena).toByteArray());
            passDataList.add(magicTowerService.builderSimplePassData(arena).toByteArray());
        });
        return MagicTowerListAllLevelRes.of(list, passDataList);

    }


    /***
     * 组件完整通关信息
     * @param groupLevel
     * @return
     */
    public MagicTowerGMsg.PSMagicLevelPassData builderDetailPassData(MagicTowerGroupLevel groupLevel) {
        MagicTowerGMsg.PSMagicLevelPassData.Builder builder = MagicTowerGMsg.PSMagicLevelPassData.newBuilder();
        if (groupLevel.getMinTimeRid() > 0) {
            CrossRole minRole = crossRoleService.getOrThrow(groupLevel.getMinTimeRid());
            MagicTowerGMsg.PSMagicTowerPassRole.Builder fast = MagicTowerGMsg.PSMagicTowerPassRole.newBuilder();
            fast.setName(minRole.getNick());
            fast.setServerId(minRole.getServerId());
            fast.setBroadId(minRole.getBorderId());
            fast.setHeadId(minRole.getHeadId());
            fast.setRid(minRole.getId());
            fast.setBattleId(groupLevel.getTimeBattleId());
            fast.setLowestTime(groupLevel.getSpendTime());
            builder.setFastPass(fast);
        }
        if (groupLevel.getMinFightingRid() > 0) {
            CrossRole minRole = crossRoleService.getOrThrow(groupLevel.getMinFightingRid());
            MagicTowerGMsg.PSMagicTowerPassRole.Builder minFighting = MagicTowerGMsg.PSMagicTowerPassRole.newBuilder();
            minFighting.setName(minRole.getNick());
            minFighting.setServerId(minRole.getServerId());
            minFighting.setBroadId(minRole.getBorderId());
            minFighting.setHeadId(minRole.getHeadId());
            minFighting.setRid(minRole.getId());
            minFighting.setBattleId(groupLevel.getFightBattleId());
            minFighting.setLowestPower(groupLevel.getMinFighting());
            builder.setMinFightingPass(minFighting);
        }
        return builder.build();
    }

    @RemoteMethod
    public MagicTowerLevelRankRes rankList(MagicTowerLevelRankReq req) {
        int groupId = crossServerGroupService.getGroupId(req.getServerId());
        List<MagicTowerGMsg.PSMagicTowerRank> rankList = levelRankService.getAll(groupId);
        MagicTowerGMsg.PSMagicTowerRank self = levelRankService.getOne(req.getRid());
        MagicTowerGMsg.GResMagicTowerLevelRank.Builder builder = MagicTowerGMsg.GResMagicTowerLevelRank.newBuilder();
        builder.addAllList(rankList);
        builder.setSelf(self);
        return MagicTowerLevelRankRes.of(builder.build().toByteArray());
    }

    @RemoteMethod
    public MagicTowerLevelPassDetailRes levelPassDetail(MagicTowerLevelPassDetailReq req) {
        int groupId = crossServerGroupService.getGroupId(req.getServerId());
        MagicTowerGroupLevel level = magicTowerService.getGroupLevel(groupId, req.getLevel());
        if (level == null) {
            return MagicTowerLevelPassDetailRes.of(MagicTowerGMsg.GResMagicTowerLevelPassDetail.getDefaultInstance().toByteArray());
        }

        MagicTowerGMsg.GResMagicTowerLevelPassDetail.Builder builder = MagicTowerGMsg.GResMagicTowerLevelPassDetail.newBuilder();
        MagicTowerGMsg.PSMagicLevelPassData data = builderDetailPassData(level);
        builder.setFastPass(data.getFastPass());
        builder.setMinFightingPass(data.getMinFightingPass());
        return MagicTowerLevelPassDetailRes.of(builder.build().toByteArray());
    }
}
