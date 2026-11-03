/**
 *
 */
package com.ayjs.mxzg.gameserver.module.rank.service;

import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import org.springframework.beans.factory.annotation.Autowired;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.PvpGMsg.PSRankPlayerData;

/**
 * @author YY
 *
 */
public abstract class AbstractPlayerRankService extends AbstractRankService<PSRankPlayerData> {

    @Autowired
    protected RoleService roleService;
    @Autowired
    protected EventBus eventBus;
    @Autowired
    protected ServerConfig serverConfig;

    @Override
    public PSRankPlayerData builder(Rank rank) {
        PSRankPlayerData.Builder builder = PSRankPlayerData.newBuilder();
        Role role = roleService.getOrThrow(rank.getRankId());
        builder.setLevel(role.getLevel());
        builder.setName(role.getNick());
        builder.setPlayerId(rank.getRankId());
        builder.setRank(topN.getRank(rank.getRankId()));
        builder.setScore((int) rank.getRankValue());
        builder.setCombatNum(role.getFighting());
        builder.setHeadId(role.getHeadId());
        builder.setBorderId(role.getBorderId());
        builder.setServerId(role.getServerId());
        builderSpecial(role, builder);
        return builder.build();
    }
    
    public void builderSpecial(Role role, PSRankPlayerData.Builder builder) {}

    @Override
    public PSRankPlayerData builderForNotRank(long rankId) {
        PSRankPlayerData.Builder builder = PSRankPlayerData.newBuilder();
        Role role = roleService.getOrThrow(rankId);
        builder.setLevel(role.getLevel());
        builder.setName(role.getNick());
        builder.setPlayerId(rankId);
        builder.setRank(-1);
        builder.setScore(getNotRankScore(role));
        builder.setCombatNum(role.getFighting());
        builder.setHeadId(role.getHeadId());
        builder.setServerId(role.getServerId());
        builder.setBorderId(role.getBorderId());
        builderSpecial(role, builder);
        return builder.build();
    }
    
    /**
     * 获取未上榜的评分
     * @param role
     * @return
     */
    protected abstract int getNotRankScore(Role role);
}
