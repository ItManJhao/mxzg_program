/**
 *
 */
package com.ayjs.mxzg.gameserver.module.rank.service;

import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.PvpGMsg;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @author YY
 *
 */
public abstract class AbstractClanRankService extends AbstractRankService<PvpGMsg.PSClanRankData> {

    @Autowired
    protected ClanService clanService;
    @Autowired
    protected RoleService roleService;
    @Autowired
    protected ServerConfig serverConfig;

    @Override
    public PvpGMsg.PSClanRankData builder(Rank rank) {
        Clan clan = clanService.getOrThrow(rank.getRankId());

        PvpGMsg.PSClanRankData.Builder builder = PvpGMsg.PSClanRankData.newBuilder();
        builder.setRank(topN.getRank(rank.getRankId()));
        builder.setDamage(rank.getRankValue());

        builder.setClanId(clan.getId());
        builder.setClanLevel(clan.getClanLevel());
        builder.setClanName(clan.getClanName());
        builder.setClanPhoto(clan.getClanIcon());
        builder.setHeadName(roleService.getOrThrow(clan.getClanHeadRid()).getNick());
        builder.setServerId(clan.getServerId());
        builder.setScore(rank.getRankValue());
        return builder.build();
    }

    @Override
    public PvpGMsg.PSClanRankData builderForNotRank(long rankId) {
        if (rankId <= 0) {
            return PvpGMsg.PSClanRankData.getDefaultInstance();
        }

        Clan clan = clanService.getOrThrow(rankId);

        PvpGMsg.PSClanRankData.Builder builder = PvpGMsg.PSClanRankData.newBuilder();
        builder.setRank(topN.getRank(clan.getId()));
        long fighting = clanService.clanFightingAll(clan.getId());
        builder.setDamage(fighting);
        builder.setClanId(clan.getId());
        builder.setClanLevel(clan.getClanLevel());
        builder.setClanName(clan.getClanName());
        builder.setClanPhoto(clan.getClanIcon());
        builder.setHeadName(roleService.getOrThrow(clan.getClanHeadRid()).getNick());
        builder.setServerId(clan.getServerId());
        builder.setScore(getNotRankScore(clan, fighting));

        return builder.build();
    }

    protected abstract long getNotRankScore(Clan clan, long fighting);
}
