package com.ayjs.mxzg.gameserver.module.rank.service;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.module.rank.dao.RankWorshipDao;
import com.ayjs.mxzg.gameserver.module.rank.dao.RankWorshipRedisDao;
import com.ayjs.mxzg.gameserver.module.rank.domain.RankWorship;
import com.ayjs.mxzg.gameserver.module.rank.domain.RankWorshipRedis;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @Author: CWJ
 * @Date: 2019/10/18
 **/
@Service
public class RankWorshipService {

    @Autowired
    RankWorshipDao rankWorshipDao;
    @Autowired
    private RankWorshipRedisDao rankWorshipRedisDao;

    public RankWorship get(long rid) {
        RankWorship rankWorship = rankWorshipDao.get(rid);
        if (rankWorship == null) {
            rankWorship = new RankWorship();
            rankWorship.setRid(rid);
            rankWorshipDao.add(rankWorship);
        } else if (!TimeDateUtil.isToday(rankWorship.getWorshipTime())) {
            rankWorship.getWorshipTypes().clear();
            rankWorshipDao.update(rankWorship);
        }
        return rankWorship;
    }

    public void update(RankWorship rankWorship) {
        if (rankWorship != null)
            rankWorshipDao.update(rankWorship);
    }

//    private RankWorshipRedis getRankWorship(long rid)
}
