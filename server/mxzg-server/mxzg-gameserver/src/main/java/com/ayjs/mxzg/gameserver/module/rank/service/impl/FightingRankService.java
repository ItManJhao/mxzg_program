package com.ayjs.mxzg.gameserver.module.rank.service.impl;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.annotation.Subscribe.AsyncType;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.gameserver.module.hero.event.RoleFightChangeEvent;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractPlayerRankService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2019/10/16
 * 战斗力排行榜
 **/
@Service
@Observer
public class FightingRankService extends AbstractPlayerRankService {

    @Override
    public RankType getRankType() {
        return RankType.FIGTH_ING;
    }

    @Subscribe(async = AsyncType.Async)
    private void fightChange(RoleFightChangeEvent event) {
        long rid = event.getRid();
        int oldPower = event.getOriFighting();
        int newPower = event.getCurrFighting();
        if (oldPower == newPower)
            return;

        int now = DateTimeUtil.currentSecond();
        Role role = roleService.getOrThrow(rid);
        role.setFightRankTime(now);
        roleService.updateRole(role);

        topN.add(buildRankData(role));
    }

    @Override
    protected int getNotRankScore(Role role) {
        return role.getFighting();
    }


    private Rank buildRankData(Role role) {
        Rank rank = new Rank();
        rank.setRankValue(role.getFighting());
        rank.setRankId(role.getId());
        rank.setRankTime(role.getFightRankTime());
        return rank;
    }

    @Override
    protected List<Rank> startLoadRank() {
        List<Rank> ranks = new ArrayList<>();
        roleService.getAllRole().stream().forEach(role -> {
            ranks.add(buildRankData(role));
        });
        return ranks;
    }
}
