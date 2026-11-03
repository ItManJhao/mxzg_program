package com.ayjs.mxzg.gameserver.module.hades.service;

import com.ayjs.mxzg.gameserver.module.hades.domain.Hades;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractRankService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.message.module.hades.message.HadesUpdateRankMessage;
import com.ayjs.mxzg.message.module.hades.struct.HadesRoleData;
import com.ayjs.mxzg.message.module.teamArena.domain.RoleSimpleMessage;
import com.ayjs.mxzg.protocol.HadesGMsg;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Slf4j
public abstract class AbstractHadesRankService extends AbstractRankService<HadesGMsg.PSHadesRankData> {

    private List<HadesRoleData> rankList = new ArrayList<>();
    private Map<Long, HadesRoleData> map = new HashMap<>();
    private HadesGMsg.HadesType hadesType;
    @Autowired
    private RoleService roleService;
    @Autowired
    private HadesService hadesService;

    @Override
    protected List<Rank> startLoadRank() {
        List<Rank> list = new ArrayList<>();
        map.values().forEach(hadesRoleData -> {
            Rank rank = new Rank();
            rank.setRankId(hadesRoleData.getRid());
            rank.setRankValue(hadesRoleData.getFloor());
            rank.setRankTime(hadesRoleData.getRankTime());
            list.add(rank);
        });
        return list;
    }

    @Override
    public HadesGMsg.PSHadesRankData builder(Rank rank) {
        HadesGMsg.PSHadesRankData.Builder builder = HadesGMsg.PSHadesRankData.newBuilder();
        builder.setFloor((int) rank.getRankValue());
        builder.setPlayerId(rank.getRankId());
        builder.setRank(topN.getRank(rank.getRankId()));
        HadesRoleData hadesRoleData = map.get(rank.getRankId());
        if (hadesRoleData != null) {
            RoleSimpleMessage simpleMessage = hadesRoleData.getRoleSimpleMessage();
            builder.setLevel(simpleMessage.getLevel());
            builder.setBorderId(simpleMessage.getBorderId());
            builder.setHeadId(simpleMessage.getHeadId());
            builder.setServerId(simpleMessage.getServerId());
            builder.setName(simpleMessage.getRoleName());
            builder.setImageId(simpleMessage.getImage());
            builder.setFighting(simpleMessage.getFighting());
        }

        return builder.build();
    }

    @Override
    public HadesGMsg.PSHadesRankData builderForNotRank(long rankId) {
        Role role = roleService.getOrThrow(rankId);
        Hades hades = hadesService.get(rankId);
        HadesGMsg.PSHadesRankData.Builder builder = HadesGMsg.PSHadesRankData.newBuilder();
        builder.setBorderId(role.getBorderId());
        builder.setHeadId(role.getHeadId());
        builder.setLevel(role.getLevel());
        builder.setName(role.getNick());
        builder.setPlayerId(role.getId());
        builder.setRank(-1);
        builder.setServerId(role.getServerId());
        builder.setFloor(hades.getFloorByType(getHadesType().getNumber()));
        builder.setFighting(role.getFighting());
        builder.setImageId(role.getImageId());
        return builder.build();
    }


    public HadesGMsg.HadesType getHadesType() {
        if (hadesType == null) {
            hadesType = hadesService.rankType2HadesType(getRankType());
        }
        return hadesType;
    }

    public void replaceRank(HadesUpdateRankMessage message) {
        try {
            if (message.getHadesType() != getHadesType().getNumber()) {
                return;
            }
            List<HadesRoleData> ranks = message.getRankDataList() == null ? new ArrayList<>() : message.getRankDataList();
            rankList = ranks;
            log.debug("冥域魔都排行榜更新数据量:{}", ranks.size());
            if (rankList.size() != 0) {
                Map<Long, HadesRoleData> collect = ranks.stream().collect(Collectors.toMap(HadesRoleData::getRid, Function.identity()));
                map = collect;
            } else {
                map.clear();
            }
            start();
        } catch (Exception e) {
            log.error("重载排行榜异常", e);
        }
    }

}
