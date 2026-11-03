package com.ayjs.mxzg.gameserver.module.rank.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.annotation.Subscribe.AsyncType;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.OpenConditionSysCache;
import com.ayjs.mxzg.config.excel.entity.COpenCondition;
import com.ayjs.mxzg.gameserver.module.pvp.domain.PvpInfo;
import com.ayjs.mxzg.gameserver.module.pvp.event.PvpDefEvent;
import com.ayjs.mxzg.gameserver.module.pvp.event.PvpEndEvent;
import com.ayjs.mxzg.gameserver.module.pvp.service.PvpInfoService;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.event.ArenaRankChangeEvent;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractPlayerRankService;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.protocol.PvpGMsg.PSRankPlayerData.Builder;

/**
 * @Author: CWJ
 * @Date: 2019/10/16
 * 竞技场排行榜
 **/
@Observer
@Service
public class ArenaRankService extends AbstractPlayerRankService {

    @Autowired
    private OpenConditionSysCache openConditionSysCache;
    @Autowired
    private PvpInfoService pvpInfoService;

    @Override
    public RankType getRankType() {
        return RankType.ARENA;
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(PvpEndEvent event) {
        long rid = event.getRid();
        int now = DateTimeUtil.currentSecond();
        Role role = roleService.getOrThrow(rid);
        role.setArenaRankTime(now);
        roleService.updateRole(role);

        eventBus.post(ArenaRankChangeEvent.of(event.getRid(), topN.add(buildRankData(role))));
    }

    private Rank buildRankData(Role role) {
        Rank rank = new Rank();
        rank.setRankValue(role.getArenaScore());
        rank.setRankId(role.getId());
        //不使用竞技场积分获得时间来做第二维的排序，而是使用战斗力为第二维度，
        //但因为基类中对第二维度的排序是使用顺序的，即越小的值排名越前，因此需要取战斗力的负数来排序
        rank.setRankTime(-role.getFighting());
        return rank;
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(PvpDefEvent event) {
        long rid = event.getRid();
        int now = DateTimeUtil.currentSecond();
        Role role = roleService.getOrThrow(rid);
        role.setArenaRankTime(now);
        roleService.updateRole(role);

        eventBus.post(ArenaRankChangeEvent.of(event.getRid(), topN.add(buildRankData(role))));
    }

    @Override
    protected int getNotRankScore(Role role) {
        return role.getArenaScore();
    }

    @Override
    protected List<Rank> startLoadRank() {
        List<Rank> ranks = new ArrayList<>();

        List<Role> roleList = new ArrayList<>(roleService.getAllRole());
        Collections.sort(roleList, SORTER);

        COpenCondition openCondition = openConditionSysCache.getCondition(EntryType.MAIN_PVP);

        for (Role role : roleList) {
            if (role.getArenaScore() <= 0 || role.getFighting() <= 0) {
                continue;
            }
            //没到竞技场开放等级的不进入竞技场排行榜
            if (role.getLevel() < openCondition.getCondition_value()) {
                continue;
            }
            ranks.add(buildRankData(role));
        }
        return ranks;
    }

    private static Comparator<Role> SORTER = new Comparator<Role>() {
        @Override
        public int compare(Role o1, Role o2) {
            if (o1.getArenaScore() > o2.getArenaScore()) {
                return -1;
            } else if (o1.getArenaScore() < o2.getArenaScore()) {
                return 1;
            } else {
                if (o1.getFighting() > o2.getFighting()) {
                    return -1;
                } else if (o1.getFighting() < o2.getFighting()) {
                    return 1;
                } else {
                    if (o1.getLevel() > o2.getLevel()) {
                        return -1;
                    } else if (o1.getLevel() < o2.getLevel()) {
                        return 1;
                    } else {
                        return 0;
                    }
                }
            }
        }
    };

    @Override
    public void builderSpecial(Role role, Builder builder) {
        PvpInfo pvpInfo = pvpInfoService.getPvpInfo(role.getId());
        builder.setBelike(pvpInfo.getBelike());
    }
}
