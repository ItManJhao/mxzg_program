package com.ayjs.mxzg.largecross.module.floatingIslands.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.constant.FloatingIslandsConst;
import com.ayjs.mxzg.config.struct.FloatingIslandsStage;
import com.ayjs.mxzg.largecross.module.floatingIslands.domain.RoleFloatingIslands;
import com.ayjs.mxzg.largecross.module.floatingIslands.event.FloatingIslandsChallengeBossEvent;
import com.ayjs.mxzg.largecross.module.rank.service.AbstractCrossRankService;
import com.ayjs.mxzg.largecross.servergroup.MessageHelper;
import com.ayjs.mxzg.largecross.servergroup.domain.CrossServerGroup;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsUpdateRankMessage;
import com.ayjs.mxzg.message.module.floatingIslands.struct.FloatingIslandsRoleData;
import com.ayjs.mxzg.message.module.floatingIslands.struct.FloatingIslandsTime;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.mxzg.message.module.role.dao.CrossRoleRedisDao;
import com.ayjs.mxzg.message.module.teamArena.domain.RoleSimpleMessage;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/7/1
 **/
@Slf4j
@Component
@Observer
public class FloatingIslandsRankService extends AbstractCrossRankService {

    @Autowired
    private FloatingIslandsService floatingIslandsService;
    @Autowired
    private FloatingIslandsConst floatingIslandsConst;
    @Autowired
    private MessageHelper messageHelper;
    @Autowired
    private CrossRoleRedisDao crossRoleRedisDao;


    @Override
    public CrossRankType getRankType() {
        return CrossRankType.FLOATING_ISLANDS;
    }

    @Override
    protected Map<Integer, List<RankData>> startLoadRank() {
        Map<Integer, List<RankData>> groupRankMap = new HashMap<>();
        Map<Integer, List<RoleFloatingIslands>> listAll = floatingIslandsService.listAll().stream()
                .filter(entity -> entity.getTotalDmg() > 0).collect(Collectors.groupingBy(RoleFloatingIslands::getServerId));
        listAll.forEach((serverId, list) -> {
            CrossGroup group = crossServerGroupDao.get().getGroupByServerId(serverId);
            if (group != null) {
                List<RankData> crossRanks = groupRankMap.computeIfAbsent(group.getGroupId(), key -> new ArrayList<>());
                list.forEach(roleFloatingIslands -> {
                    RankData crossRank = new RankData();
                    crossRank.setRankId(roleFloatingIslands.getRid());
                    crossRank.setRankTime(roleFloatingIslands.getRankTime());
                    crossRank.setRankValue(roleFloatingIslands.getTotalDmg());
                    crossRanks.add(crossRank);
                });
            }
        });
        return groupRankMap;
    }

    @Override
    public List<RankData> getAll(int serverGroup) {
        return getGroupTopN(serverGroup).top(getRankType().getRankCount());
    }

    @Override
    public void pullToAllGame() {

        FloatingIslandsTime time = floatingIslandsService.getTime();
        if (time.getStage() != FloatingIslandsStage.CHALLENGE_BOSS.getCode()) {
            return;
        }
        if (resetIng)
            return;
        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        Set<Integer> set = new HashSet<>(crossServerGroup.getGroups().keySet());
        set.forEach(groupId -> {
            Boolean change = (Boolean) topHadChange.getOrDefault(groupId, Boolean.valueOf(true));
            if (change) {
                topHadChange.put(groupId, false);
                List<RankData> ranks = getAll(groupId);
                log.info(String.format("推送浮空岛排行榜,数量{%s}到跨服组{%s}", ranks.size(), groupId));
                messageHelper.pushToGroupMessage(groupId, builderRankUpdateMessage(ranks));
            }
        });
    }

    private FloatingIslandsUpdateRankMessage builderRankUpdateMessage(List<RankData> ranks) {
        Map<Long, FloatingIslandsRoleData> simpleMessageMap = new HashMap<>(floatingIslandsConst.getShowCount());
        int maxSize = Math.min(floatingIslandsConst.getShowCount(), ranks.size());
        for (int i = 0; i < maxSize; i++) {
            RankData rankData = ranks.get(i);
            RoleFloatingIslands roleFloatingIslands = floatingIslandsService.getRoleFloatingIslands(rankData.getRankId());
            RoleSimpleMessage roleSimpleMessage = roleFloatingIslands.getRoleSimpleMessage();
            if (roleSimpleMessage.getRid() != 0) {
                FloatingIslandsRoleData data = new FloatingIslandsRoleData();
                data.setMaxDmg(roleFloatingIslands.getMaxDmg());
                data.setTotalDmg(roleFloatingIslands.getTotalDmg());
                data.setRoleSimpleMessage(roleSimpleMessage);

                simpleMessageMap.put(roleSimpleMessage.getRid(), data);
            }
        }
        return FloatingIslandsUpdateRankMessage.of(ranks, simpleMessageMap);
    }

    @Override
    public void pullToGame(int serverId, Connection connection) {
        CrossGroup group = crossServerGroupDao.get().getGroupByServerId(serverId);
        if (group != null) {
            connection.send(builderRankUpdateMessage(getAll(group.getGroupId())));
        }
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(FloatingIslandsChallengeBossEvent event) {
        RoleFloatingIslands roleFloatingIslands = floatingIslandsService.getRoleFloatingIslands(event.getRid());
        CrossGroup group = crossServerGroupDao.get().getGroupByServerId(roleFloatingIslands.getServerId());
        try {
            floatingIslandsService.setRoleInfo(crossRoleRedisDao.get(event.getRid()), roleFloatingIslands);
            floatingIslandsService.update(roleFloatingIslands);
        } catch (Exception e) {
            log.error("更新玩家数据失败", e);
        }

        if (group != null) {
            RankData crossRank = new RankData();
            crossRank.setRankId(roleFloatingIslands.getRid());
            crossRank.setRankTime(roleFloatingIslands.getRankTime());
            crossRank.setRankValue(roleFloatingIslands.getTotalDmg());
            addRank(crossRank, group.getGroupId());
            messageHelper.pushToGroupMessage(group.getGroupId(), builderRankUpdateMessage(getAll(group.getGroupId())));
        }

    }

}
