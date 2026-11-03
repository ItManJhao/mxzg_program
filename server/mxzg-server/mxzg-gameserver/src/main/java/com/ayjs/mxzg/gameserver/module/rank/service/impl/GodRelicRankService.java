package com.ayjs.mxzg.gameserver.module.rank.service.impl;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.annotation.Subscribe.AsyncType;
import com.ayjs.mxzg.common.top.TopN;
import com.ayjs.mxzg.gameserver.module.godRelic.domain.GodRelic;
import com.ayjs.mxzg.gameserver.module.godRelic.event.GodRelicAddStarEvent;
import com.ayjs.mxzg.gameserver.module.godRelic.service.GodRelicService;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractPlayerRankService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.tower.domain.Tower;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerPassEvent;
import com.ayjs.mxzg.gameserver.module.tower.service.TowerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2019/10/16
 * 幻境之塔排行榜
 **/
@Service
@Observer
public class GodRelicRankService extends AbstractPlayerRankService {

    @Autowired
    private GodRelicService godRelicService;

    @Override
    public RankType getRankType() {
        return RankType.GOD_RELIC;
    }

    @Override
    protected int getNotRankScore(Role role) {
        GodRelic godRelic = godRelicService.load(role.getId());
        return godRelic.getSumStar();
    }

    private Rank buildRankData(GodRelic godRelic) {
        Rank rank = new Rank();
        rank.setRankValue(godRelic.getSumStar());
        rank.setRankId(godRelic.getRid());
        rank.setRankTime(godRelic.getRankTime());
        return rank;
    }

    @Override
    protected List<Rank> startLoadRank() {
        List<Rank> ranks = new ArrayList<>();
        godRelicService.getAll().stream().forEach(tower -> {
            Rank rank = buildRankData(tower);
            if (rank.getRankValue() > 0) {
                ranks.add(rank);
            }
        });
        return ranks;
    }

    @Subscribe(async = AsyncType.Async)
    public void listener(GodRelicAddStarEvent event) {
        GodRelic godRelic = godRelicService.load(event.getRid());
        topN.add(buildRankData(godRelic));
    }
}
