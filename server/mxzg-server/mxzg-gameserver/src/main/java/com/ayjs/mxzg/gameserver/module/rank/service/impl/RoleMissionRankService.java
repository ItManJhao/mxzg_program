package com.ayjs.mxzg.gameserver.module.rank.service.impl;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.entity.COpenCondition;
import com.ayjs.mxzg.gameserver.module.battle.domain.RoleMission;
import com.ayjs.mxzg.gameserver.module.battle.event.ChapterBattleEvent;
import com.ayjs.mxzg.gameserver.module.battle.service.RoleMissionService;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractPlayerRankService;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/2/27
 **/
@Component
@Observer
public class RoleMissionRankService extends AbstractPlayerRankService {

    @Autowired
    private RoleMissionService roleMissionService;

    @Override
    protected int getNotRankScore(Role role) {
        return roleMissionService.getRoleMission(role.getId()).getChapterId();
    }

    @Override
    protected List<Rank> startLoadRank() {
        List<Rank> ranks = new ArrayList<>();
        roleMissionService.getAllRoleMission().forEach(role -> {
            ranks.add(buildRankData(role));
        });
        return ranks;
    }

    private Rank buildRankData(RoleMission role) {
        Rank rank = new Rank();
        rank.setRankValue(role.getChapterId());
        rank.setRankId(role.getRid());
        rank.setRankTime(role.getMissionRankTime());
        return rank;
    }

    @Override
    public RankType getRankType() {
        return RankType.ROLE_MISSION;
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ChapterBattleEvent event) {
        if (event.isWin()) {
            int now = DateTimeUtil.currentSecond();
            Rank rank = new Rank();
            rank.setRankValue(event.getMissionId());
            rank.setRankId(event.getRid());
            rank.setRankTime(now);
            topN.add(rank);
        }
    }
}
