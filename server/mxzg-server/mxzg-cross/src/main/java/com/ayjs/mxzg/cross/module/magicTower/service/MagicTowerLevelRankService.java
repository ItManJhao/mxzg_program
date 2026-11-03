package com.ayjs.mxzg.cross.module.magicTower.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.top.TopN;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.crossservice.service.CrossServerGroupService;
import com.ayjs.mxzg.cross.module.magicTower.domain.MagicTower;
import com.ayjs.mxzg.cross.module.magicTower.event.MagicTowerPassLevelEvent;
import com.ayjs.mxzg.cross.module.rank.service.AbstractCrossRankService;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.protocol.MagicTowerGMsg;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2021/6/19
 **/
@Service
@Slf4j
@Observer
public class MagicTowerLevelRankService extends AbstractCrossRankService<MagicTowerGMsg.PSMagicTowerRank> {

    @Autowired
    private MagicTowerService magicTowerService;
    @Autowired
    private CrossRoleService crossRoleService;
    @Autowired
    private CrossServerGroupService crossServerGroupService;

    @Override
    public CrossRankType getRankType() {
        return CrossRankType.MAGIC_TOWER_LEVEL;
    }

    @Override
    protected Map<Integer, List<RankData>> startLoadRank() {
        List<MagicTower> magicTowers = magicTowerService.getAllMagicTower();
        Map<Integer, List<RankData>> result = new HashMap<>();
        for (MagicTower magicTower : magicTowers) {
            CrossRole role = crossRoleService.getNotThrow(magicTower.getRid());
            if (role == null) {
                log.error("角色数据不存在：{}", magicTower.getRid());
                continue;
            }
            Integer groupId = crossServerGroupService.getGroupId(role.getServerId());
            result.computeIfAbsent(groupId, key -> new ArrayList<>()).add(builderRankData(magicTower));
        }

        return result;
    }

    protected TopN<Long, RankData> getGroupTopN(int groupId) {
        TopN<Long, RankData> topN = groupTopN.get(groupId);
        if (topN == null) {
            RankData threshold = new RankData();
            threshold.setRankValue(1);
            threshold.setFighting(Integer.MAX_VALUE);
            topN = TopN.orderedBy(comparator).threshold(threshold).maximumSize(getRankType().getRankCount()).build();
            groupTopN.putIfAbsent(groupId, topN);
            topN = groupTopN.get(groupId);
        }
        topHadChange.put(groupId, true);
        return topN;
    }

    private RankData builderRankData(MagicTower magicTower) {
        RankData rankData = new RankData();
        rankData.setRankId(magicTower.getRid());
        rankData.setRankValue(magicTower.getPassLevel());
        rankData.setFighting(magicTower.getPassTime());
        rankData.setRankTime(LocalDateTimeUtil.toEpochSecond(magicTower.getRankTime()));
        return rankData;
    }

    @Override
    public List<MagicTowerGMsg.PSMagicTowerRank> getAll(int serverGroup) {
        List<RankData> rankDataList = getGroupTopN(serverGroup).top(getRankType().getRankCount());
        List<MagicTowerGMsg.PSMagicTowerRank> list = new ArrayList<>();
        int rank = 1;
        for (RankData rankData : rankDataList) {
            CrossRole role = crossRoleService.getNotThrow(rankData.getRankId());
            if (role == null) {
                log.error("角色数据不存在：{}", rankData.getRankId());
                continue;
            }
            MagicTowerGMsg.PSMagicTowerRank.Builder builder = MagicTowerGMsg.PSMagicTowerRank.newBuilder();
            builder.setName(role.getNick());
            builder.setBorderId(role.getBorderId());
            builder.setHeadId(role.getHeadId());
            builder.setPassLevel((int) rankData.getRankValue());
            builder.setPassTime((int) rankData.getFighting());
            builder.setRid(rankData.getRankId());
            builder.setServerId(role.getServerId());
            builder.setRank(rank++);
            list.add(builder.build());
        }
        return list;
    }

    public MagicTowerGMsg.PSMagicTowerRank getOne(long rid) {
        CrossRole role = crossRoleService.getNotThrow(rid);
        if (role == null) {
            log.error("角色数据不存在：{}", rid);
            return MagicTowerGMsg.PSMagicTowerRank.getDefaultInstance();
        }
        Integer groupId = crossServerGroupService.getGroupId(role.getServerId());

        MagicTowerGMsg.PSMagicTowerRank.Builder builder = MagicTowerGMsg.PSMagicTowerRank.newBuilder();
        builder.setName(role.getNick());
        builder.setBorderId(role.getBorderId());
        builder.setHeadId(role.getHeadId());

        builder.setServerId(role.getServerId());
        RankData rankData = getGroupTopN(groupId).get(rid);
        if (rankData != null) {
            builder.setPassLevel((int) rankData.getRankValue());
            builder.setPassTime((int) rankData.getFighting());
            builder.setRid(rankData.getRankId());
            builder.setRank(getEntityRank(role.getServerId(), role.getId()));

        } else {
            MagicTower magicTower = magicTowerService.load(rid);
            builder.setPassLevel(magicTower.getPassLevel());
            builder.setPassTime(magicTower.getPassTime());
            builder.setRid(magicTower.getRid());
            builder.setRank(-1);
        }
        return builder.build();

    }

    @Subscribe
    public void listen(MagicTowerPassLevelEvent event) {
        CrossRole role = crossRoleService.getNotThrow(event.getRid());
        if (role == null) {
            log.error("角色数据不存在：{}", event.getRid());
            return;
        }
        Integer groupId = crossServerGroupService.getGroupId(role.getServerId());
        getGroupTopN(groupId).add(builderRankData(magicTowerService.load(event.getRid())));
    }

    @Override
    public void pullToAllGame() {

    }

    @Override
    public void pullToGame(int serverId, Connection connection) {

    }
}
