package com.ayjs.mxzg.largecross.module.countryWar.rank;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.top.TopN;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarCitySysCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarCity;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarServerDao;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarTimeDao;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarServer;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarTime;
import com.ayjs.mxzg.largecross.module.countryWar.event.CountryWarServerAddScoreEvent;
import com.ayjs.mxzg.largecross.module.countryWar.struct.CountryWarCity;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.mxzg.protocol.CountryWarGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/4/20
 **/
@Service
@Observer
public class CountryWarScoreWarRankService extends AbstractCountryWarRankService {

    @Autowired
    private CountryWarServerDao countryWarServerDao;
    @Autowired
    private CountryWarTimeDao countryWarTimeDao;
    @Autowired
    private CountryWarCitySysCache countryWarSysCache;

    @Override
    public CrossRankType getRankType() {
        return CrossRankType.COUNTRY_WAR_SCORE;
    }

    @Override
    public List<CountryWarGMsg.PSCountryWarRank> getAll(int group) {
        TopN<Long, RankData> topN = getGroupTopN(group);
        List<RankData> ranks = topN.top(getRankType().getRankCount());

        List<CountryWarGMsg.PSCountryWarRank> result = new ArrayList<>();

        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        Map<Integer, CountryWarCity> cityMap = countryWarTime.getGroupData().get(group).getCityMap();
        Collection<CountryWarCity> cities = cityMap.values();
        Map<Integer, List<CountryWarCity>> serverMap = cities.stream().collect(Collectors.groupingBy(CountryWarCity::getServerId));
        for (int i = 0; i < ranks.size(); i++) {
            CountryWarGMsg.PSCountryWarRank.Builder builder = CountryWarGMsg.PSCountryWarRank.newBuilder();
            builder.setRank(i + 1);
            RankData rankData = ranks.get(i);
            int serverId = rankData.getRankId().intValue();
            builder.setServerId(serverId);
            builder.setScore(rankData.getRankValue());

            List<CountryWarCity> occupyCities = serverMap.getOrDefault(serverId, Collections.emptyList());
            int hourScore = getHourScore(occupyCities);
            builder.setHourScore(hourScore);
            builder.setOccupyCount(occupyCities.size() - 1);
            result.add(builder.build());
        }
        return result;
    }

    private int getHourScore(List<CountryWarCity> cities) {
        int hourScore = 0;
        for (CountryWarCity serverCity : cities) {
            CCountryWarCity config = countryWarSysCache.getOrThrow(serverCity.getId());
            if (config.getReward_interval() > 0)
                hourScore += config.getScore() / (config.getReward_interval() / TimeUnit.HOURS.toSeconds(1));
        }
        return hourScore;
    }

    @Override
    public CountryWarGMsg.PSCountryWarRank getOne(int group, long rankId) {
        TopN<Long, RankData> topN = getGroupTopN(group);
        int serverId = (int) rankId;
        int rank = topN.getRank(rankId);

        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        Map<Integer, CountryWarCity> cityMap = countryWarTime.getGroupData().get(group).getCityMap();
        Collection<CountryWarCity> cities = cityMap.values();
        Map<Integer, List<CountryWarCity>> serverMap = cities.stream().collect(Collectors.groupingBy(CountryWarCity::getServerId));

        CountryWarGMsg.PSCountryWarRank.Builder builder = CountryWarGMsg.PSCountryWarRank.newBuilder();
        if (rank == 0) {
            CountryWarServer server = countryWarServerDao.get(serverId);
            builder.setRank(-1);
            builder.setServerId(serverId);
            builder.setScore(server.getScore());
        } else {
            RankData rankData = topN.get(rank);
            builder.setRank(rank);
            builder.setServerId(serverId);
            builder.setScore(rankData.getRankValue());
        }
        List<CountryWarCity> occupyCities = serverMap.getOrDefault(serverId, Collections.emptyList());
        int hourScore = getHourScore(occupyCities);
        builder.setHourScore(hourScore);
        builder.setOccupyCount(occupyCities.size() - 1);
        return builder.build();
    }


    @Override
    protected Map<Integer, List<RankData>> startLoadRank() {
        CountryWarTime countryTime = countryWarTimeDao.getSingle();
        List<CountryWarServer> servers = countryWarServerDao.listAll();
        servers = servers.stream().filter(server -> server.getRound() == countryTime.getRound()).collect(Collectors.toList());
        Map<Integer, List<RankData>> result = new HashMap<>();
        servers.forEach(server -> {
            Integer groupId = countryTime.getServer2Group().get(server.getServerId());
            if (groupId != null) {
                RankData rankData = new RankData();
                rankData.setRankId(server.getServerId());
                rankData.setRankValue(server.getScore());
                rankData.setRankTime(LocalDateTimeUtil.toEpochSecond(server.getRankTime()));
                result.computeIfAbsent(groupId, key -> new ArrayList<>()).add(rankData);
            }
        });
        return result;
    }

    protected TopN<Long, RankData> getGroupTopN(int groupId) {
        TopN<Long, RankData> topN = groupTopN.get(groupId);
        if (topN == null) {
            RankData threshold = new RankData();
            threshold.setRankValue(-1);
            threshold.setRankTime(Integer.MIN_VALUE);
            topN = TopN.orderedBy(comparator).maximumSize(getRankType().getRankCount()).build();
            groupTopN.putIfAbsent(groupId, topN);
            topN = groupTopN.get(groupId);
        }
        topHadChange.put(groupId, true);
        return topN;
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(CountryWarServerAddScoreEvent event) {
        CountryWarServer server = countryWarServerDao.get(event.getServerId());
        RankData rankData = new RankData();
        rankData.setRankId(server.getServerId());
        rankData.setRankValue(server.getScore());
        rankData.setRankTime(LocalDateTimeUtil.toEpochSecond(server.getRankTime()));
        addRank(rankData, event.getGroupId());
    }
}
