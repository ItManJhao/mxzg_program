package com.ayjs.mxzg.cross.module.magicTower.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.config.excel.cache.magicTower.MagicTowerSysCache;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.crossservice.event.CrossRegroupEvent;
import com.ayjs.mxzg.cross.module.crossservice.service.CrossServerGroupService;
import com.ayjs.mxzg.cross.module.magicTower.dao.MagicTowerDao;
import com.ayjs.mxzg.cross.module.magicTower.dao.MagicTowerGroupLevelDao;
import com.ayjs.mxzg.cross.module.magicTower.dao.MagicTowerServerDao;
import com.ayjs.mxzg.cross.module.magicTower.domain.MagicTower;
import com.ayjs.mxzg.cross.module.magicTower.domain.MagicTowerGroupLevel;
import com.ayjs.mxzg.cross.module.magicTower.domain.MagicTowerServer;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerArenaChangeBroReq;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerLevelPassBroReq;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.protocol.MagicTowerGMsg;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/6/19
 **/
@Service
@Slf4j
@Observer
public class MagicTowerService  {

    @Autowired
    private MagicTowerServerDao magicTowerServerDao;
    @Autowired
    private MagicTowerDao magicTowerDao;
    @Autowired
    private MagicTowerGroupLevelDao magicTowerGroupLevelDao;
    @Autowired
    private MagicTowerSysCache magicTowerSysCache;
    @Autowired
    private MagicTowerLevelRankService magicTowerLevelRankService;
    @Autowired
    private CrossServerGroupService crossServerGroupService;
    @Autowired
    private MessageHelper messageHelper;
    @Autowired
    private CrossRoleService crossRoleService;
    public static String LOCK_PRE = "magicTower";

    public MagicTower load(long rid) {
        if (rid == 0) {
            return null;
        }
        MagicTower role = magicTowerDao.get(rid);
        if (role == null) {
            role = new MagicTower();
            role.setRid(rid);
            magicTowerDao.add(role);
        }
        return role;
    }

    public List<MagicTower> getAllMagicTower() {
        return magicTowerDao.listAll();
    }

    public List<MagicTowerServer> getAllByServerId(int serverId) {
        return magicTowerServerDao.list("serverId", serverId);
    }

    public MagicTowerServer loadMagicTowerServer(int serverId, int level) {
        if (serverId == 0) {
            return null;
        }

        List<MagicTowerServer> servers = getAllByServerId(serverId);
        MagicTowerServer server = servers.stream().filter(temp -> temp.getLevel() == level).findAny().orElse(null);
        if (server == null) {
            server = new MagicTowerServer();
            server.setServerId(serverId);
            server.setLevel(level);
            server.setSpendTime(Integer.MAX_VALUE);
            server.setMinFighting(Long.MAX_VALUE);
            magicTowerServerDao.add(server);
        }
        return server;
    }

    public MagicTowerGroupLevel getGroupLevel(int groupId, int level) {
        List<MagicTowerGroupLevel> list = getAllGroupLevel(groupId);
        return list.stream().filter(groupRank -> groupRank.getLevel() == level).findFirst().orElse(null);
    }

    public List<MagicTowerGroupLevel> getAllGroupLevel(int groupId) {
        return magicTowerGroupLevelDao.list("groupId", groupId);
    }

    public void update(MagicTowerServer magicTowerServer) {
        magicTowerServerDao.update(magicTowerServer);
    }

    public void update(MagicTower magicTower) {
        magicTowerDao.update(magicTower);
    }

    public String getGroupLock(int groupId, int level) {
        return InternerPool.intern(LOCK_PRE, groupId, level);
    }

    public MagicTowerGroupLevel safeCreateGroupLevel(int groupId, int level, long rid) {
        MagicTowerGroupLevel groupLevel = getGroupLevel(groupId, level);
        if (groupLevel == null) {
            synchronized (getGroupLock(groupId, level)) {
                groupLevel = getGroupLevel(groupId, level);
                if (groupLevel == null) {
                    groupLevel = new MagicTowerGroupLevel();
                    groupLevel.setGroupId(groupId);
                    groupLevel.setLevel(level);
                    groupLevel.setArenaRid(rid);
                    groupLevel.setMinFightingRid(rid);
                    groupLevel.setMinFighting(Long.MAX_VALUE);
                    groupLevel.setMinTimeRid(rid);
                    groupLevel.setSpendTime(Integer.MAX_VALUE);
                    magicTowerGroupLevelDao.add(groupLevel);

                    if (magicTowerSysCache.getOrThrow(level).getRank() == 1) {
                        messageHelper.pushToGroupMessage(groupId, MagicTowerArenaChangeBroReq.of(builderArenaRole(groupLevel)
                                .toByteArray(), null, level));
                    }
                }

            }
        }
        return groupLevel;
    }

    public MagicTowerGMsg.PSMagicTowerArena builderArenaRole(MagicTowerGroupLevel groupLevel) {
        MagicTowerGMsg.PSMagicTowerArena.Builder builder = MagicTowerGMsg.PSMagicTowerArena.newBuilder();
        CrossRole defender = crossRoleService.getNotThrow(groupLevel.getArenaRid());
        if (defender == null) {
            log.error("role is not exist !" + groupLevel.getArenaRid());
            return builder.build();
        }
        builder.setRid(defender.getId());
        builder.setServerId(defender.getServerId());
        builder.setHeadId(defender.getHeadId());
        builder.setLevel(groupLevel.getLevel());
        builder.setName(defender.getNick());
        builder.setBroadId(defender.getBorderId());
        return builder.build();
    }

    public void update(MagicTowerGroupLevel groupLevel) {
        magicTowerGroupLevelDao.update(groupLevel);
    }

    @Subscribe
    public void listen(CrossRegroupEvent event) {
        log.info("跨服重组，重置排行榜数据");
        magicTowerLevelRankService.clear();
        try {
            magicTowerLevelRankService.start();
        } catch (Exception e) {
            log.error("跨服重组时，排行榜异常！", e);
        }

        magicTowerGroupLevelDao.truncateAll();

        Map<Integer, List<MagicTowerServer>> levelMap = magicTowerServerDao.listAll().stream().collect(Collectors.groupingBy(MagicTowerServer::getLevel));
        Map<Integer, Map<Integer, MagicTowerServer>> levelServerMap = new HashMap<>();
        levelMap.forEach((key, value) -> levelServerMap.put(key, value.stream().collect(Collectors.toMap(MagicTowerServer::getServerId, Function.identity()))));

        crossServerGroupService.getCrossServerGroup().getGroups().forEach((groupId, group) -> {
            magicTowerSysCache.getAll().forEach(config -> {
                synchronized (getGroupLock(groupId, config.getLevel())) {
                    Map<Integer, MagicTowerServer> serverMap = levelServerMap.get(config.getLevel());
                    if (serverMap == null) {
                        return;
                    }
                    MagicTowerServer bestServer = null;
                    MagicTowerServer minFightServer = null;
                    for (Integer serverId : group.getServerIds()) {
                        MagicTowerServer serverTemp = serverMap.get(serverId);
                        if (serverTemp != null) {
                            if (bestServer == null || bestServer.getSpendTime() > serverTemp.getSpendTime()) {
                                bestServer = serverTemp;
                            }
                            if (minFightServer == null || minFightServer.getMinFighting() > serverTemp.getMinFighting()) {
                                minFightServer = serverTemp;
                            }
                        }
                    }
                    if (bestServer != null) {
                        MagicTowerGroupLevel groupLevel = safeCreateGroupLevel(groupId, config.getLevel(), bestServer.getMinTimeRid());
                        groupLevel.setMinTimeRid(bestServer.getMinTimeRid());
                        groupLevel.setSpendTime(bestServer.getSpendTime());
                        groupLevel.setMinFighting(minFightServer.getMinFighting());
                        groupLevel.setMinFightingRid(minFightServer.getMinFightingRid());
                        groupLevel.setFightBattleId(minFightServer.getFightBattleId());
                        groupLevel.setTimeBattleId(bestServer.getTimeBattleId());
                        update(groupLevel);
                    }
                }
            });

        });
        log.info("幻魔塔跨服重置完成！");
        crossServerGroupService.getCrossServerGroup().getGroups().forEach((groupId, group) -> {
            getAllGroupLevel(groupId).forEach(groupLevel -> {
                messageHelper.pushToGroupMessage(groupId, MagicTowerLevelPassBroReq.of(builderSimplePassData(groupLevel).toByteArray()));
                messageHelper.pushToGroupMessage(groupId, MagicTowerArenaChangeBroReq.of(builderArenaRole(groupLevel)
                        .toByteArray(), null, groupLevel.getLevel()));
            });
        });

    }

    /***
     * 组件简单通关信息
     * @param groupLevel
     * @return
     */
    public MagicTowerGMsg.PSMagicLevelPassData builderSimplePassData(MagicTowerGroupLevel groupLevel) {
        MagicTowerGMsg.PSMagicLevelPassData.Builder builder = MagicTowerGMsg.PSMagicLevelPassData.newBuilder();
        builder.setLevel(groupLevel.getLevel());
        if (groupLevel.getMinTimeRid() > 0) {
            CrossRole minRole = crossRoleService.getOrThrow(groupLevel.getMinTimeRid());
            MagicTowerGMsg.PSMagicTowerPassRole.Builder fast = MagicTowerGMsg.PSMagicTowerPassRole.newBuilder();
            fast.setName(minRole.getNick());
            fast.setServerId(minRole.getServerId());
//            fast.setLowestTime(groupLevel.getSpendTime());
            builder.setFastPass(fast);
        }
        if (groupLevel.getMinFightingRid() > 0) {
            CrossRole minRole = crossRoleService.getOrThrow(groupLevel.getMinFightingRid());
            MagicTowerGMsg.PSMagicTowerPassRole.Builder minFighting = MagicTowerGMsg.PSMagicTowerPassRole.newBuilder();
            minFighting.setName(minRole.getNick());
            minFighting.setServerId(minRole.getServerId());
//            minFighting.setLowestPower(groupLevel.getMinFighting());
            builder.setMinFightingPass(minFighting);
        }
        return builder.build();
    }
}
