package com.ayjs.mxzg.largecross.module.promotion092.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.largecross.module.promotion092.dao.Promotion092Dao;
import com.ayjs.mxzg.largecross.module.promotion092.dao.Promotion092HeroDao;
import com.ayjs.mxzg.largecross.module.promotion092.dao.Promotion092StartTimeDao;
import com.ayjs.mxzg.largecross.module.promotion092.domain.Promotion092;
import com.ayjs.mxzg.largecross.module.promotion092.domain.Promotion092Hero;
import com.ayjs.mxzg.largecross.module.promotion092.domain.Promotion092StartTime;
import com.ayjs.mxzg.largecross.module.promotion092.event.DeliverFlowerEvent;
import com.ayjs.mxzg.largecross.module.promotion092.service.Promotion092CountRankService;
import com.ayjs.mxzg.largecross.module.promotion092.service.Promotion092HeroRankService;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.promotion092.message.Promotion092CountRankReqMessage;
import com.ayjs.mxzg.message.module.promotion092.message.Promotion092CountRankSettleReqMessage;
import com.ayjs.mxzg.message.module.promotion092.message.Promotion092CountRankSettleResMessage;
import com.ayjs.mxzg.message.module.promotion092.message.Promotion092DeliverReqMessage;
import com.ayjs.mxzg.message.module.promotion092.message.Promotion092HeroRankReqMessage;
import com.ayjs.mxzg.message.module.promotion092.message.Promotion092StatusReqMessage;
import com.ayjs.mxzg.message.module.promotion092.struct.Promotion092Data;
import com.ayjs.mxzg.message.module.promotion092.struct.Promotion092HeroData;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.mxzg.message.module.role.dao.CrossRoleRedisDao;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.rpc.annotation.Remote;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Collections;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/3/11
 **/
@Remote
@Slf4j
public class Promotion092Handler implements MessageHandler {
    @Autowired
    private Promotion092Dao promotion092Dao;
    @Autowired
    private Promotion092StartTimeDao promotion092StartTimeDao;
    @Autowired
    private Promotion092HeroDao promotion092HeroDao;
    @Autowired
    private CrossRoleRedisDao crossRoleRedisDao;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private Promotion092CountRankService promotion092CountRankService;
    @Autowired
    private Promotion092HeroRankService promotion092HeroRankService;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;

    @RemoteMethod
    public void deliver(Promotion092DeliverReqMessage message, Connection connection) {
        CrossRole crossRole = crossRoleRedisDao.get(message.getRid());
        if (crossRole == null) {
            return;
        }
        Promotion092 promotion092 = promotion092Dao.get(message.getRid());
        if (promotion092 == null) {
            promotion092 = new Promotion092();
            promotion092.setRid(message.getRid());
            promotion092.setServerId(crossRole.getServerId());
            promotion092Dao.add(promotion092);
        }
        Promotion092StartTime startTime = promotion092StartTimeDao.get(promotion092.getServerId());
        if (startTime == null) {
            log.error("活动数据不存在" + promotion092.getServerId());
            return;
        }

        promotion092.setStartTime(startTime.getTime());
        promotion092.setCount(message.getCount());
        promotion092.setRankTime(message.getRankTime());
        promotion092Dao.update(promotion092);

        heroTypeSysCache.getOrThrow(message.getHeroType());

        synchronized (message.getHeroType() + "-" + startTime.getTime()) {
            List<Promotion092Hero> promotion092Heroes = promotion092HeroDao.listByTime(startTime.getTime());
            Promotion092Hero promotion092Hero = promotion092Heroes.stream().filter(promotion092HeroTemp ->
                    promotion092HeroTemp.getHeroType() == message.getHeroType()).findFirst().orElse(null);
            if (promotion092Hero == null) {
                promotion092Hero = new Promotion092Hero();
                promotion092Hero.setServerId(promotion092.getServerId());
                promotion092Hero.setStartTime(startTime.getTime());
                promotion092Hero.setScore(message.getAddScore());
                promotion092Hero.setRankTime(message.getRankTime());
                promotion092Hero.setHeroType(message.getHeroType());
                promotion092HeroDao.add(promotion092Hero);
            } else {
                promotion092Hero.setScore(promotion092Hero.getScore() + message.getAddScore());
                promotion092Hero.setStartTime(startTime.getTime());
                promotion092Hero.setRankTime(message.getRankTime());
                promotion092HeroDao.update(promotion092Hero);
            }
        }

        eventBus.post(DeliverFlowerEvent.of(message.getRid(), message.getHeroType()));
    }

    @RemoteMethod
    public void updateStatus(Promotion092StatusReqMessage message) {
        if (message.getServerIds() != null) {
            message.getServerIds().forEach(serverId -> {
                Promotion092StartTime startTime = promotion092StartTimeDao.get(serverId);
                if (startTime == null) {
                    startTime = new Promotion092StartTime();
                    startTime.setServerId(serverId);
                    startTime.setStatus(message.getStatus());
                    startTime.setTime(message.getStartTime());
                    promotion092StartTimeDao.add(startTime);
                } else {
                    startTime.setStatus(message.getStatus());
                    startTime.setTime(message.getStartTime());
                    promotion092StartTimeDao.update(startTime);
                }
            });
        }
    }

    @RemoteMethod
    public void reqRank(Promotion092CountRankReqMessage message, Connection connection) {
        promotion092CountRankService.pullToGame(message.getServerId(), connection);
    }

    @RemoteMethod
    public void reqHeroRank(Promotion092HeroRankReqMessage message, Connection connection) {
        promotion092HeroRankService.pullToGame(message.getServerId(), connection);
    }

    @RemoteMethod
    public Promotion092CountRankSettleResMessage reqRankSettle(Promotion092CountRankSettleReqMessage message, Connection connection) {
        int serverId = message.getServerId();
        Promotion092StartTime startTime = promotion092StartTimeDao.get(serverId);
        if (startTime == null) {
            log.info("服务器未开启活动");
            return Promotion092CountRankSettleResMessage.of(Collections.emptyList(), Collections.emptyList());
        }

        List<RankData> ranks = promotion092CountRankService.topN(message.getServerId(),
                CrossRankType.PROMOTION_092_HERO_SCORE.getRankCount(), message.getStartTime());
        List<Promotion092Data> result = promotion092CountRankService.builderList(ranks);
        List<RankData> heroRanks = promotion092HeroRankService.topN(message.getServerId(),
                1, message.getStartTime());
        List<Promotion092HeroData> heroRankResult = promotion092HeroRankService.builderList(heroRanks);
        startTime.getCountRankRecord().clear();
        startTime.getCountRankRecord().addAll(ranks);
        startTime.getHeroRankRecord().clear();
        startTime.getHeroRankRecord().add(heroRanks.get(0));
        startTime.setRecordTime(message.getStartTime());
        promotion092StartTimeDao.update(startTime);

        return Promotion092CountRankSettleResMessage.of(result, heroRankResult);
    }


}
