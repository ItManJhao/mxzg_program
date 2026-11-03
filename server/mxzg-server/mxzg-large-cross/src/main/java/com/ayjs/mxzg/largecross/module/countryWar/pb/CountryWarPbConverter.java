package com.ayjs.mxzg.largecross.module.countryWar.pb;

import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarCitySysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarRandomEventSysCache;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarRoleDao;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarRole;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarServer;
import com.ayjs.mxzg.largecross.module.countryWar.struct.CountryWarCity;
import com.ayjs.mxzg.largecross.module.countryWar.struct.CountryWarCityEvent;
import com.ayjs.mxzg.largecross.module.countryWar.struct.CountryWarGroup;
import com.ayjs.mxzg.message.module.countryWar.dto.CountryWarLogInfo;
import com.ayjs.mxzg.protocol.CountryWarGMsg;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

/**
 * @Author: CWJ
 * @Date: 2021/4/15
 **/
@Component
public class CountryWarPbConverter {

    @Autowired
    private CountryWarRoleDao countryWarRoleDao;
    @Autowired
    private CountryWarCitySysCache countryWarCitySysCache;
    @Autowired
    private CountryWarRandomEventSysCache countryWarRandomEventSysCache;

    public CountryWarGMsg.PSCountryWarCity build(CountryWarCity city, CountryWarGroup groupData) {
        CountryWarGMsg.PSCountryWarCity.Builder builder = CountryWarGMsg.PSCountryWarCity.newBuilder();
        builder.setIdx(city.getId());
        builder.setServerId(city.getServerId());
        builder.setDefendNum(city.getDefendRid().size());
        if (city.getBattleTime() != null) {
            builder.setWarDuration(LocalDateTimeUtil.toEpochSecond(city.getBattleTime()) +
                    countryWarCitySysCache.getById(city.getId()).getWar_duration());
        } else {
            builder.setWarDuration(0);
        }
        builder.setIsolate(city.isIsolate());
        CountryWarCityEvent event = groupData.getEvent();
        int tomorrowBreak = LocalDateTimeUtil.toEpochSecond(LocalDateTime.now().withNano(0).withSecond(0).withMinute(0)
                .withHour(0).plusDays(1));
        if (event.getCityId() == city.getId()) {
            builder.setEventId(event.getEventId());
            builder.setEventDuration(tomorrowBreak);
        }
        if (groupData.getShopCityId() == city.getId()) {
            builder.setShopDuration(tomorrowBreak);
        }
        return builder.build();
    }

    public CountryWarGMsg.PSCountryWarServerFaction build(CountryWarServer server) {
        CountryWarGMsg.PSCountryWarServerFaction.Builder builder = CountryWarGMsg.PSCountryWarServerFaction.newBuilder();
        builder.setServerId(server.getServerId());
        for (CountryWarGMsg.Faction faction : CountryWarGMsg.Faction.values()) {
            if ((faction.getNumber() & server.getFaction()) > 0) {
                builder.addFaction(faction);
            }
        }
        return builder.build();
    }

    public CountryWarGMsg.GResCountryWarSmallCity buildSmall(CountryWarCity city) {
        CountryWarGMsg.GResCountryWarSmallCity.Builder builder = CountryWarGMsg.GResCountryWarSmallCity.newBuilder();
        city.getDefendRid().forEach((rid, place) -> {
            CountryWarRole role = countryWarRoleDao.get(rid);
            CountryWarGMsg.PSCountryWarSmallCity.Builder builderTemp = CountryWarGMsg.PSCountryWarSmallCity.newBuilder();
            builderTemp.setIdx(place);
            builderTemp.setRid(rid);
            builderTemp.setNick(role.getCountryWarRoleInfo().getName());
            builderTemp.setServerId(role.getCountryWarRoleInfo().getServerId());
            builder.addSmallCities(builderTemp);
        });
        builder.setIdx(city.getId());
        if (city.getOccupyTime() != null) {
            builder.setOccupyTime(LocalDateTimeUtil.toEpochSecond(city.getOccupyTime()));
        }

        return builder.build();
    }

    public CountryWarGMsg.PSCountryWarLog build(CountryWarLogInfo logInfo) {
        CountryWarGMsg.PSCountryWarLog.Builder builder = CountryWarGMsg.PSCountryWarLog.newBuilder();
        builder.setTime(LocalDateTimeUtil.toEpochSecond(logInfo.getLogTime()));
        if (logInfo.getParams() != null)
            builder.addAllParam(logInfo.getParams());
        builder.setType(logInfo.getType());
        return builder.build();
    }

}
