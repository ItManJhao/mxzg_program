package com.ayjs.mxzg.gameserver.module.rank.service.impl;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.annotation.Subscribe.AsyncType;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractPlayerRankService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.tower.domain.Tower;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerPassEvent;
import com.ayjs.mxzg.gameserver.module.tower.service.TowerService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2019/10/16
 * 幻境之塔排行榜
 **/
@Slf4j
@Service
@Observer
public class TowerRankService extends AbstractPlayerRankService {

    @Autowired
    private TowerService towerService;

    @Override
    public RankType getRankType() {
        return RankType.TOWER;
    }

    @Subscribe(async = AsyncType.Async)
    private void passTower(TowerPassEvent event) {
        Tower tower = towerService.getTower(event.getRid());
        topN.add(buildRankData(tower));
    }

    @Override
    protected int getNotRankScore(Role role) {
        Tower tower = towerService.getTower(role.getId());
        return tower.getStage() - 1;
    }

    private Rank buildRankData(Tower tower) {
        Rank rank = new Rank();
        rank.setRankValue(tower.getStage() - 1);
        rank.setRankId(tower.getRid());
        rank.setRankTime(tower.getTime());
        return rank;
    }


    @Override
    protected List<Rank> startLoadRank() {
        List<Rank> ranks = new ArrayList<>();
        List<Tower> all = towerService.getAll();
        log.debug("tower rank all size:{}", all.size());
        all.stream().forEach(tower -> {
            if (tower.getStage() - 1 > 0) {
                ranks.add(buildRankData(tower));
            }

        });
        return ranks;
    }
}
