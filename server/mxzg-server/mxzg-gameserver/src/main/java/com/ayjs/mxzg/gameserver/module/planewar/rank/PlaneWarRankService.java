package com.ayjs.mxzg.gameserver.module.planewar.rank;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.gameserver.module.planewar.dao.PlaneWarDao;
import com.ayjs.mxzg.gameserver.module.planewar.domain.PlaneWar;
import com.ayjs.mxzg.gameserver.module.planewar.event.PlaneWarPassEvent;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractPlayerRankService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/9/17
 **/
@Service
@Observer
public class PlaneWarRankService extends AbstractPlayerRankService {

    @Autowired
    private PlaneWarDao planeWarDao;

    @Override
    protected int getNotRankScore(Role role) {
        PlaneWar planeWar = planeWarDao.get(role.getId());
        return planeWar.getPassLevelInfo().values().stream().mapToInt(Integer::intValue).sum();
    }

    @Override
    protected List<Rank> startLoadRank() {
        List<Rank> list = Lists.newArrayList();
        planeWarDao.listAll().forEach(planeWar -> list.add(planeWar2Rank(planeWar)));
        return list;
    }

    private Rank planeWar2Rank(PlaneWar planeWar) {
        Rank rank = new Rank();
        rank.setRankId(planeWar.getRid());
        rank.setRankValue(planeWar.getPassLevelInfo().values().stream().mapToInt(Integer::intValue).sum());
        rank.setRankTime(LocalDateTimeUtil.toEpochSecond(planeWar.getRankTime()));
        return rank;
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(PlaneWarPassEvent event) {
        topN.add(planeWar2Rank(planeWarDao.get(event.getRid())));
    }


    @Override
    public RankType getRankType() {
        return RankType.PLANE_WAR;
    }
}
