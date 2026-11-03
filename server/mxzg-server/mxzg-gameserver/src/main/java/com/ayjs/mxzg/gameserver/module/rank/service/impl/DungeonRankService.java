package com.ayjs.mxzg.gameserver.module.rank.service.impl;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.annotation.Subscribe.AsyncType;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.module.dungeon.domain.DungeonInfo;
import com.ayjs.mxzg.gameserver.module.dungeon.event.DungeonStageEvent;
import com.ayjs.mxzg.gameserver.module.dungeon.service.DungeonInfoService;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractPlayerRankService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2019/10/16
 * 庇护所排行榜
 **/
@Service
@Observer
public class DungeonRankService extends AbstractPlayerRankService {

    @Autowired
    private DungeonInfoService dungeonInfoService;

    @Override
    public RankType getRankType() {
        return RankType.DUNGEON;
    }

    @Subscribe(async = AsyncType.Async)
    private void DungeonRankEvent(DungeonStageEvent event) {
        DungeonInfo dungeonInfo = dungeonInfoService.select(event.getRid());
        dungeonInfo.setRankTime(TimeDateUtil.getCurrentTimeInt());
        dungeonInfoService.update(dungeonInfo);

        topN.add(buildRankData(dungeonInfo));
    }

    @Override
    protected int getNotRankScore(Role role) {
        DungeonInfo dungeonInfo = dungeonInfoService.select(role.getId());
        return dungeonInfo.getStage();
    }

    @Override
    protected List<Rank> startLoadRank() {
        List<Rank> ranks = new ArrayList<>();
        dungeonInfoService.selectAll().stream().forEach(dungeonInfo -> {
            if (dungeonInfo.getStage() > 0) {
                ranks.add(buildRankData(dungeonInfo));
            }
        });
        return ranks;
    }

    private Rank buildRankData(DungeonInfo dungeonInfo) {
        Rank rank = new Rank();
        rank.setRankId(dungeonInfo.getRid());
        rank.setRankTime(DateTimeUtil.currentSecond());
        rank.setRankValue(dungeonInfo.getStage());
        return rank;
    }
}
