package com.ayjs.mxzg.gameserver.module.floatingIslands.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.gameserver.module.floatingIslands.domain.RoleFloatingIslands;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractRankService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsUpdateRankMessage;
import com.ayjs.mxzg.message.module.floatingIslands.struct.FloatingIslandsRoleData;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.protocol.FloatingIslandsGMsg;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Maps;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

/**
 * @Author: CWJ
 * @Date: 2020/7/2
 **/
@Slf4j
@Service
public class FloatingIslandsRankService extends AbstractRankService<FloatingIslandsGMsg.PSFloatingRankData> implements MessageHandler {

    private List<RankData> crossRankData = new ArrayList<>();
    private Map<Long, FloatingIslandsRoleData> roleDataMap = new ConcurrentHashMap<>();

    @Autowired
    private RoleService roleService;
    @Autowired
    private FloatingIslandsService floatingIslandsService;

    @Override
    protected List<Rank> startLoadRank() {
        List<Rank> list = new ArrayList<>();
        if (!CollectionUtil.isEmpty(crossRankData)) {
            ImmutableList.copyOf(crossRankData).forEach(crossFightingRank -> {
                Rank rank = new Rank();
                rank.setRankId(crossFightingRank.getRankId());
                rank.setRankTime(crossFightingRank.getRankTime());
                rank.setRankValue(crossFightingRank.getRankValue());
                list.add(rank);
            });
        }
        return list;
    }

    @Override
    public FloatingIslandsGMsg.PSFloatingRankData builder(Rank rank) {
        FloatingIslandsGMsg.PSFloatingRankData.Builder builder = FloatingIslandsGMsg.PSFloatingRankData.newBuilder();
        FloatingIslandsRoleData floatingIslandsRoleData = roleDataMap.get(rank.getRankId());

        builder.setRank(topN.getRank(rank.getRankId()));
        builder.setTotalDmg(rank.getRankValue());
        builder.setPlayerId(rank.getRankId());

        if (floatingIslandsRoleData != null) {
            builder.setSelfMaxDmg(floatingIslandsRoleData.getMaxDmg());
            builder.setName(floatingIslandsRoleData.getRoleSimpleMessage().getRoleName());
            builder.setLevel(floatingIslandsRoleData.getRoleSimpleMessage().getLevel());
            builder.setHeadId(floatingIslandsRoleData.getRoleSimpleMessage().getHeadId());
            builder.setBorderId(floatingIslandsRoleData.getRoleSimpleMessage().getBorderId());
            builder.setServerId(floatingIslandsRoleData.getRoleSimpleMessage().getServerId());
        } else if (roleService.isRole(rank.getRankId())) {
            //当自己的名词超过50名之后，要获取数据
            Role role = roleService.getOrThrow(rank.getRankId());
            RoleFloatingIslands roleFloatingIslands = floatingIslandsService.get(rank.getRankId());
            builder.setSelfMaxDmg(roleFloatingIslands.getMaxDmg());
            builder.setName(role.getNick());
            builder.setLevel(role.getLevel());
            builder.setHeadId(role.getHeadId());
            builder.setBorderId(role.getBorderId());
            builder.setServerId(role.getServerId());
        }
        return builder.build();
    }

    @Override
    public FloatingIslandsGMsg.PSFloatingRankData builderForNotRank(long rankId) {
        Role role = roleService.getOrThrow(rankId);
        RoleFloatingIslands roleFloatingIslands = floatingIslandsService.get(rankId);
        FloatingIslandsGMsg.PSFloatingRankData.Builder builder = FloatingIslandsGMsg.PSFloatingRankData.newBuilder();
        builder.setBorderId(role.getBorderId());
        builder.setHeadId(role.getHeadId());
        builder.setLevel(role.getLevel());
        builder.setName(role.getNick());
        builder.setPlayerId(role.getId());
        builder.setRank(-1);
        builder.setServerId(role.getServerId());
        builder.setSelfMaxDmg(roleFloatingIslands.getMaxDmg());
        builder.setTotalDmg(roleFloatingIslands.getTotalDmg());
        return builder.build();
    }

    @Override
    public RankType getRankType() {
        return RankType.FLOATING_ISLANDS;
    }

    @RemoteMethod
    public void replaceRank(FloatingIslandsUpdateRankMessage message) {
        try {
            List<RankData> ranks = message.getRankDataList() == null ? new ArrayList<>() : message.getRankDataList();
            log.debug("跨服战力排行榜数据量:{}", ranks.size());
            crossRankData = ranks;
            if (message.getRoleDataMap() != null) {
                ConcurrentMap<Long, FloatingIslandsRoleData> roleDataMap_ = Maps.newConcurrentMap();
                roleDataMap_.putAll(message.getRoleDataMap());
                roleDataMap = roleDataMap_;
            } else {
                roleDataMap.clear();
            }
            start();
        } catch (Exception e) {
            log.error("重载排行榜异常", e);
        }
    }
}
