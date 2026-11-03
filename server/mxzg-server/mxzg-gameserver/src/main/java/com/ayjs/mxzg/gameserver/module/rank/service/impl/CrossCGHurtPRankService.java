package com.ayjs.mxzg.gameserver.module.rank.service.impl;

import com.ayjs.mxzg.common.top.TopN;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.RoleCrusadeGroup;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.service.GroupService;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractRankCGPlayerService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.message.module.rank.ResCrossCGHurtPRankMessage;
import com.ayjs.mxzg.message.module.rank.dto.CrossCruGroupHurtP;
import com.ayjs.mxzg.protocol.CrusadeGroupRankGMsg;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * 讨伐团玩家 boss伤害 排行
 **/
@Slf4j
@Service
public class CrossCGHurtPRankService extends AbstractRankCGPlayerService<CrusadeGroupRankGMsg.PSCrusadeGroupPRankData> implements MessageHandler {
    @Autowired
    protected RoleService roleService;
    @Autowired
    private GroupService groupService;

    private Map<Integer, Map<Long, CrossCruGroupHurtP>> cgPDataMap = new ConcurrentHashMap<>();

    @Override
    public RankType getRankType() {
        return RankType.CRUGROUP_HURTP;
    }

    @RemoteMethod
    public void replaceRank(ResCrossCGHurtPRankMessage message) {
        try {
            Map<Integer, List<CrossCruGroupHurtP>> cg_ranks = message.getCg_ranks() == null ? new ConcurrentHashMap<>() : message.getCg_ranks();
            if (cg_ranks.isEmpty()) {
                return;
            }
            for (Map.Entry<Integer, List<CrossCruGroupHurtP>> entry : cg_ranks.entrySet()) {
                int cgId = entry.getKey();
                List<CrossCruGroupHurtP> ranks = entry.getValue();
                //不直接全部赋值是因为 可能只更新部分需要更新的讨伐团数据
                Map<Long, CrossCruGroupHurtP> playerRank = ranks.stream().collect(Collectors.toMap(CrossCruGroupHurtP::getRankId, Function.identity()));
                cgPDataMap.put(cgId, playerRank);
            }
            log.debug("跨服讨伐团 玩家boss伤害榜 数据量:{}", cg_ranks.size());
            start();
        } catch (Exception e) {
            log.error("重载排行榜异常", e);
        }
    }

    @Override
    protected Map<Integer, List<Rank>> startLoadRank() {
//        messageDispatcher.dispatch();
//        if (!hadReq) {
//            messageDispatcher.dispatch(ReqCrossRankGetMessage.createOf(getRankType().getType(), serverConfig.getServerId()));
//            hadReq = true;
//        }
        Map<Integer, List<Rank>> map = new HashMap<>();
        if (cgPDataMap.isEmpty()) {
            return map;
        }
        for (Map.Entry<Integer, Map<Long, CrossCruGroupHurtP>> entry : cgPDataMap.entrySet()) {
            int cgId = entry.getKey();
            Map<Long, CrossCruGroupHurtP> ranks = entry.getValue();
            List<Rank> crossRanks = map.computeIfAbsent(cgId, key -> new ArrayList<>());
            for (Map.Entry<Long, CrossCruGroupHurtP> entry_ : ranks.entrySet()) {
                CrossCruGroupHurtP crossCruGroupHurtP = entry_.getValue();
                Rank rank = new Rank();
                rank.setRankId(crossCruGroupHurtP.getRankId());
                rank.setRankTime(crossCruGroupHurtP.getRankTime());
                rank.setRankValue(crossCruGroupHurtP.getBossHurt());
                crossRanks.add(rank);
            }
        }
        return map;
    }

    @Override
    public CrusadeGroupRankGMsg.PSCrusadeGroupPRankData builder(int cgId, Rank rank) {
        TopN<Long, Rank> topN = getGroupTopN(cgId);
        CrossCruGroupHurtP crossCruGroupItemP = cgPDataMap.get(cgId).get(rank.getRankId());
        CrusadeGroupRankGMsg.PSCrusadeGroupPRankData.Builder builder = CrusadeGroupRankGMsg.PSCrusadeGroupPRankData.newBuilder();
        builder.setCgId(cgId);
        builder.setPlayerId(rank.getRankId());
        builder.setName(crossCruGroupItemP.getRoleName());
        builder.setBorderId(crossCruGroupItemP.getBorderId());
        builder.setHeadId(crossCruGroupItemP.getHeadId());
        builder.setServerId(crossCruGroupItemP.getServerId());
        builder.setBossHurt(rank.getRankValue());
        builder.setRank(topN.getRank(rank.getRankId()));
        return builder.build();
    }

    @Override
    public CrusadeGroupRankGMsg.PSCrusadeGroupPRankData builderForNotRank(int cgId, long rankId) {
        if (rankId <= 0) {
            return CrusadeGroupRankGMsg.PSCrusadeGroupPRankData.getDefaultInstance();
        }
        Role role = roleService.getOrThrow(rankId);
        RoleCrusadeGroup roleCrusadeGroup = groupService.getRoleCrusadeGroup(rankId);
        CrusadeGroupRankGMsg.PSCrusadeGroupPRankData.Builder builder = CrusadeGroupRankGMsg.PSCrusadeGroupPRankData.newBuilder();
        builder.setCgId(cgId);
        builder.setPlayerId(rankId);
        builder.setName(role.getNick());
        builder.setBorderId(role.getBorderId());
        builder.setHeadId(role.getHeadId());
        builder.setServerId(role.getServerId());
        builder.setBossHurt(roleCrusadeGroup.getBossHurt());
        builder.setRank(-1);
        return builder.build();
    }
}
