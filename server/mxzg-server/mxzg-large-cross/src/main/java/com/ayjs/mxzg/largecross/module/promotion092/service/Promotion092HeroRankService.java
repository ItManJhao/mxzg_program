package com.ayjs.mxzg.largecross.module.promotion092.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.largecross.module.promotion092.dao.Promotion092Dao;
import com.ayjs.mxzg.largecross.module.promotion092.dao.Promotion092HeroDao;
import com.ayjs.mxzg.largecross.module.promotion092.dao.Promotion092StartTimeDao;
import com.ayjs.mxzg.largecross.module.promotion092.domain.Promotion092;
import com.ayjs.mxzg.largecross.module.promotion092.domain.Promotion092Hero;
import com.ayjs.mxzg.largecross.module.promotion092.domain.Promotion092StartTime;
import com.ayjs.mxzg.largecross.module.promotion092.event.DeliverFlowerEvent;
import com.ayjs.mxzg.largecross.servergroup.SessionManager;
import com.ayjs.mxzg.largecross.servergroup.event.CrossRegroupEvent;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.promotion092.message.Promotion092HeroRankResMessage;
import com.ayjs.mxzg.message.module.promotion092.struct.Promotion092HeroData;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.rpc.server.Connection;
import com.ayjs.rpc.server.ConnectionManager;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/3/11
 **/
@Service
@Observer
@Slf4j
public class Promotion092HeroRankService extends Promotion092RankService {

    @Autowired
    private Promotion092Dao promotion092Dao;
    @Autowired
    private Promotion092StartTimeDao promotion092StartTimeDao;
    @Autowired
    private SessionManager sessionManager;
    @Autowired
    private ConnectionManager connectionManager;
    @Autowired
    private Promotion092HeroDao promotion092HeroDao;

    @Override
    public CrossRankType getRankType() {
        return CrossRankType.PROMOTION_092_HERO_SCORE;
    }

    @Override
    protected Map<Integer, Map<Integer, List<RankData>>> startLoadRank() {
        Map<Integer, Map<Integer, List<RankData>>> res = new HashMap<>();
        List<Promotion092StartTime> promotion092Times = promotion092StartTimeDao.listAll().stream().filter(startTimeTemp -> startTimeTemp.getStatus() == 0 &&
                startTimeTemp.getTime() > 0).collect(Collectors.toList());

        Map<Integer, List<Promotion092StartTime>> map = promotion092Times.stream().collect(Collectors.groupingBy(Promotion092StartTime::getTime));

        map.forEach((time, serverTimes) -> {
            List<Promotion092Hero> promotion092Heroes = promotion092HeroDao.listByTime(time);
            Map<Integer, List<Promotion092Hero>> mapTemp = new HashMap<>();
            promotion092Heroes.forEach(promotion092Hero -> {
                mapTemp.computeIfAbsent(getGroupId(promotion092Hero.getServerId()), key -> new ArrayList<>()).add(promotion092Hero);
            });

            mapTemp.forEach((group, listTemp) -> {
                Map<Integer, List<Promotion092Hero>> heroTypeMap = listTemp.stream().collect(Collectors.groupingBy(Promotion092Hero::getHeroType));
                for (Map.Entry<Integer, List<Promotion092Hero>> integerListEntry : heroTypeMap.entrySet()) {
                    Integer heroType = integerListEntry.getKey();
                    List<Promotion092Hero> list2 = integerListEntry.getValue();
                    int score = list2.stream().mapToInt(Promotion092Hero::getScore).sum();

                    RankData rankData = new RankData();
                    rankData.setRankId(heroType);
                    rankData.setRankTime(heroType);
                    rankData.setRankValue(score);

                    Map<Integer, List<RankData>> rankDataMap = res.computeIfAbsent(time, key -> new HashMap<>());
                    rankDataMap.computeIfAbsent(group, key -> new ArrayList<>()).add(rankData);
                }
            });

        });

        return res;
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(CrossRegroupEvent event) {
        resetRankList();
        pullToAllGame();
    }

    @Subscribe(async = Subscribe.AsyncType.Sync)
    private void listen(DeliverFlowerEvent event) {
        RankData rank = new RankData();
        Promotion092 promotion092 = promotion092Dao.get(event.getRid());
        int groupId = getGroupId(promotion092.getServerId());
        Promotion092StartTime startTime = promotion092StartTimeDao.get(promotion092.getServerId());
        List<Promotion092Hero> promotion092Heroes = promotion092HeroDao.listByTime(startTime.getTime());
        int score = promotion092Heroes.stream().filter(promotion092Hero -> getGroupId(promotion092Hero.getServerId()) == groupId &&
                promotion092Hero.getHeroType() == event.getHeroType()).mapToInt(Promotion092Hero::getScore).sum();
        rank.setRankId(event.getHeroType());
        rank.setRankTime(event.getHeroType());
        rank.setRankValue(score);
        addRank(rank, getGroupId(promotion092.getServerId()), startTime.getTime());

        Integer clientId = sessionManager.getClientId(promotion092.getServerId());
        connectionManager.send(clientId, builderRankUpdateMessage(getGroupTopN(getGroupId(promotion092.getServerId()),
                startTime.getTime()).top(getRankType().getRankCount())));
    }


    @Override
    public List<T> getAll(int serverGroup) {
        return null;
    }

    @Override
    public void pullToAllGame() {

    }

    @Override
    public void pullToGame(int serverId, Connection connection) {
        Promotion092StartTime startTime = promotion092StartTimeDao.get(serverId);
        if (startTime == null) {
            log.info("服务器未开启活动");
            connection.send(builderRankUpdateMessage(Collections.emptyList()));
            return;
        }

        CrossGroup group = crossServerGroupDao.get().getGroupByServerId(serverId);
        if (group != null) {
            connection.send(builderRankUpdateMessage(getGroupTopN(group.getGroupId(),
                    startTime.getTime()).top(getRankType().getRankCount())));
        }
    }

    private Promotion092HeroRankResMessage builderRankUpdateMessage(List<RankData> ranks) {
        List<Promotion092HeroData> result = builderList(ranks);
        return Promotion092HeroRankResMessage.of(result);
    }

    public List<Promotion092HeroData> builderList(List<RankData> ranks) {
        List<Promotion092HeroData> result = new ArrayList<>();
        int rank = 1;
        for (RankData rankData : ranks) {
            Promotion092HeroData promotion092Data = new Promotion092HeroData();
            promotion092Data.setRank(rank);
            promotion092Data.setRankId(rankData.getRankId());
            promotion092Data.setRankValue((int) rankData.getRankValue());
            promotion092Data.setHeroType(rankData.getRankId().intValue());
            result.add(promotion092Data);
            rank++;
        }
        return result;
    }
}
