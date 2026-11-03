package com.ayjs.mxzg.largecross.module.hades.service;

import com.ayjs.mxzg.common.top.TopN;
import com.ayjs.mxzg.largecross.module.hades.domain.CrossHades;
import com.ayjs.mxzg.largecross.module.rank.service.AbstractCrossRankService;
import com.ayjs.mxzg.largecross.servergroup.domain.CrossServerGroup;
import com.ayjs.mxzg.largecross.servergroup.service.ServerGroupService;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.hades.message.HadesUpdateRankMessage;
import com.ayjs.mxzg.message.module.hades.struct.HadesRoleData;
import com.ayjs.mxzg.message.module.role.dao.CrossRoleRedisDao;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.message.module.teamArena.domain.RoleSimpleMessage;
import com.ayjs.mxzg.protocol.HadesGMsg;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Slf4j
public abstract class AbstractCrossHadesRankService extends AbstractCrossRankService<HadesRoleData> {

    @Autowired
    protected CrossRoleRedisDao crossRoleRedisDao;
    @Autowired
    protected CrossHadesService crossHadesService;
    @Autowired
    private ServerGroupService serverGroupService;

    private HadesGMsg.HadesType hadesType;

    @Override
    public List<HadesRoleData> getAll(int serverGroup) {
        TopN<Long, RankData> groupTopN = getGroupTopN(serverGroup);
        List<RankData> top = groupTopN.top(getRankType().getRankCount());
        List<HadesRoleData> result = new ArrayList<>();
        int rank = 1;
        List<Long> collect = top.stream().mapToLong(RankData::getRankId).collect(ArrayList::new, ArrayList::add, ArrayList::addAll);
        Map<Long, CrossRole> crossRoles = crossRoleRedisDao.get(collect).stream().collect(Collectors.toMap(CrossRole::getId, Function.identity()));
        for (RankData rankData : top) {
            HadesRoleData hadesRoleData = new HadesRoleData();
            hadesRoleData.setRank(rank);
            hadesRoleData.setRid(rankData.getRankId());
            hadesRoleData.setFloor((int) rankData.getRankValue());
            hadesRoleData.setRank(rankData.getRankTime());

            RoleSimpleMessage simpleMessage = new RoleSimpleMessage();
            CrossRole crossRole = crossRoles.get(rankData.getRankId());
            CrossHades crossHades = crossHadesService.get(rankData.getRankId());
            if (crossRole != null) {
                simpleMessage.setLevel(crossRole.getLevel());
                simpleMessage.setHeadId(crossRole.getHeadId());
                simpleMessage.setBorderId(crossRole.getBorderId());
                simpleMessage.setImage(crossRole.getImageId());
                simpleMessage.setRoleName(crossRole.getNick());
                simpleMessage.setServerId(crossRole.getServerId());
                simpleMessage.setClanName(crossRole.getClanName());
                simpleMessage.setRid(crossRole.getId());
            }
            simpleMessage.setFighting(crossHades == null ? 0 : crossHades.getFighting());
            hadesRoleData.setRoleSimpleMessage(simpleMessage);

            result.add(hadesRoleData);
            rank++;

        }

        return result;
    }

    public HadesGMsg.HadesType getHadesType() {
        if (hadesType == null) {
            hadesType = crossHadesService.RankType2HadesType(getRankType());
        }
        return hadesType;
    }

    @Override
    public void pullToAllGame() {
        if (resetIng)
            return;
        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        Set<Integer> set = new HashSet<>(crossServerGroup.getGroups().keySet());
        set.forEach(groupId -> {
            Boolean change = topHadChange.getOrDefault(groupId, Boolean.valueOf(true));
            if (change) {
                topHadChange.put(groupId, false);
                List<HadesRoleData> ranks = getAll(groupId);
                log.info(String.format("推送冥域魔都排行榜{%s}排行榜,数量{%s}到跨服组{%s}", getRankType(), ranks.size(), groupId));
                messageHelper.pushToGroupMessage(groupId, HadesUpdateRankMessage.of(ranks, getHadesType().getNumber()));
            }
        });
    }

    @Override
    public void pullToGame(int serverId, Connection connection) {
        CrossGroup group = crossServerGroupDao.get().getGroupByServerId(serverId);
        if (group != null) {
            connection.send(HadesUpdateRankMessage.of(getAll(group.getGroupId()), getHadesType().getNumber()));
        }
    }

    @Override
    protected Map<Integer, List<RankData>> startLoadRank() {
        List<CrossHades> crossHadesList = crossHadesService.listAll();
        Map<Integer, List<RankData>> groupRankMap = new HashMap<>();
        CrossServerGroup crossServerGroup = serverGroupService.get();
        for (CrossHades crossHades : crossHadesList) {
            Integer floor = crossHades.getRankTime().get(getHadesType().getNumber());
            if (floor == null) {
                continue;
            }
            CrossRole crossRole = crossRoleRedisDao.get(crossHades.getRid());
            if (crossRole == null) {
                log.error("冥界魔域获取redis中role数据时未找到玩家：" + crossHades.getRid());
                continue;
            }
            CrossGroup crossGroup = crossServerGroup.getGroupByServerId(crossRole.getServerId());
            if (crossGroup == null) {
                continue;
            }
            int groupId = crossGroup.getGroupId();
            List<RankData> rankList = groupRankMap.get(groupId);
            if (rankList == null) {
                rankList = new ArrayList<>();
                groupRankMap.put(groupId, rankList);
            }

            RankData crossRank = new RankData();
            crossRank.setRankId(crossHades.getRid());
            crossRank.setRankTime(floor);
            crossRank.setRankValue(crossHades.getPassFloor().getOrDefault(getHadesType().getNumber(), 0));
            crossRank.setFighting(crossHades.getFighting());
            rankList.add(crossRank);
        }
        return groupRankMap;
    }
}
