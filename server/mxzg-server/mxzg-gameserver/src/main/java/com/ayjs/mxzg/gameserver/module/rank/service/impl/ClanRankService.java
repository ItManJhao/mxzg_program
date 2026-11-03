package com.ayjs.mxzg.gameserver.module.rank.service.impl;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.annotation.Subscribe.AsyncType;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanChangeEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanFightingUpdateEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.RoleFightChangeEvent;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractClanRankService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2019/10/16 公会战力排行榜
 **/
@Service
@Observer
public class ClanRankService extends AbstractClanRankService {

    @Override
    public RankType getRankType() {
        return RankType.CLAN;
    }

    @Subscribe(async = AsyncType.Async)
    public void clanMemberFighting(ClanFightingUpdateEvent event) {
        Rank rank = new Rank();
        rank.setRankValue(event.getFighting());
        rank.setRankId(event.getClanId());
        rank.setRankTime(TimeDateUtil.getCurrentTimeInt());

        topN.add(rank);
    }

    @Override
    protected long getNotRankScore(Clan clan, long fighting) {
        return fighting;
    }

    @Override
    protected List<Rank> startLoadRank() {
        List<Rank> ranks = new ArrayList<>();
        clanService.selectAll().stream().forEach(clan -> {
            ranks.add(buildRankData(clan));
        });
        return ranks;
    }

    private Rank buildRankData(Clan clan) {
        Rank rank = new Rank();
        rank.setRankValue(clan.getClanFighting());
        rank.setRankId(clan.getId());
        rank.setRankTime(clan.getFightingUpdateTime());
        return rank;
    }
}
