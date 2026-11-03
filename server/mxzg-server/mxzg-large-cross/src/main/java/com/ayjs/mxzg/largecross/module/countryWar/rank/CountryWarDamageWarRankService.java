package com.ayjs.mxzg.largecross.module.countryWar.rank;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.top.TopN;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarRoleDao;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarTimeDao;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarRole;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarTime;
import com.ayjs.mxzg.largecross.module.countryWar.event.CountryWarAttackCityEvent;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.mxzg.protocol.CountryWarGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/4/20
 **/
@Service
@Observer
public class CountryWarDamageWarRankService extends AbstractCountryWarRankService {

    @Autowired
    private CountryWarRoleDao countryWarRoleDao;
    @Autowired
    private CountryWarTimeDao countryWarTimeDao;

    @Override
    public CrossRankType getRankType() {
        return CrossRankType.COUNTRY_WAR_DAMAGE;
    }

    @Override
    public List<CountryWarGMsg.PSCountryWarRank> getAll(int group) {
        TopN<Long, RankData> topN = getGroupTopN(group);
        List<RankData> ranks = topN.top(getRankType().getRankCount());

        List<CountryWarGMsg.PSCountryWarRank> result = new ArrayList<>();

        for (int i = 0; i < ranks.size(); i++) {
            CountryWarGMsg.PSCountryWarRank.Builder builder = CountryWarGMsg.PSCountryWarRank.newBuilder();
            builder.setRank(i + 1);
            RankData rankData = ranks.get(i);
            CountryWarRole role = countryWarRoleDao.get(rankData.getRankId());
            builder.setServerId(role.getCountryWarRoleInfo().getServerId());
            builder.setName(role.getCountryWarRoleInfo().getName());
            builder.setRid(rankData.getRankId());
            builder.setDamage(rankData.getRankValue());

            result.add(builder.build());
        }
        return result;
    }


    @Override
    public CountryWarGMsg.PSCountryWarRank getOne(int group, long rankId) {
        TopN<Long, RankData> topN = getGroupTopN(group);
        int rank = topN.getRank(rankId);

        CountryWarRole role = countryWarRoleDao.get(rankId);

        CountryWarGMsg.PSCountryWarRank.Builder builder = CountryWarGMsg.PSCountryWarRank.newBuilder();
        if (rank == 0) {
            builder.setRank(-1);
            builder.setDamage(role.getDamage());
        } else {
            RankData rankData = topN.get(rank);
            builder.setRank(rank);
            builder.setDamage(rankData.getRankValue());
        }
        builder.setServerId(role.getCountryWarRoleInfo().getServerId());
        builder.setName(role.getCountryWarRoleInfo().getName());
        builder.setRid(rankId);
        return builder.build();
    }


    @Override
    protected Map<Integer, List<RankData>> startLoadRank() {
        CountryWarTime countryTime = countryWarTimeDao.getSingle();
        List<CountryWarRole> servers = countryWarRoleDao.listAll();
        servers = servers.stream().filter(server -> server.getRound() == countryTime.getRound()).collect(Collectors.toList());
        Map<Integer, List<RankData>> result = new HashMap<>();
        servers.forEach(role -> {
            Integer groupId = countryTime.getServer2Group().get(role.getMainServerId());
            if (groupId != null) {
                RankData rankData = new RankData();
                rankData.setRankId(role.getRid());
                rankData.setRankValue(role.getDamage());
                rankData.setRankTime(LocalDateTimeUtil.toEpochSecond(role.getDefeatCityRankTime()));
                result.computeIfAbsent(groupId, key -> new ArrayList<>()).add(rankData);
            }
        });
        return result;
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(CountryWarAttackCityEvent event) {
        CountryWarRole role = countryWarRoleDao.get(event.getRid());
        RankData rankData = new RankData();
        rankData.setRankId(role.getRid());
        rankData.setRankValue(role.getDamage());
        rankData.setRankTime(LocalDateTimeUtil.toEpochSecond(role.getDefeatCityRankTime()));
        addRank(rankData, event.getGroupId());
    }
}
