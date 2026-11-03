package com.ayjs.mxzg.largecross.module.countryWar.worker;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarCitySysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarRandomEventSysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarTimeSysCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarCity;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarRandomEvent;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarTime;
import com.ayjs.mxzg.config.excel.entity.countrywar.CountryWarStage;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarRoleDao;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarServerDao;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarServer;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarTime;
import com.ayjs.mxzg.largecross.module.countryWar.event.CountryWarServerAddScoreEvent;
import com.ayjs.mxzg.largecross.module.countryWar.rank.CountryWarDamageWarRankService;
import com.ayjs.mxzg.largecross.module.countryWar.rank.CountryWarHeroWarRankService;
import com.ayjs.mxzg.largecross.module.countryWar.rank.CountryWarKillRankService;
import com.ayjs.mxzg.largecross.module.countryWar.rank.CountryWarScoreWarRankService;
import com.ayjs.mxzg.largecross.module.countryWar.struct.CountryWarCity;
import com.ayjs.mxzg.largecross.module.countryWar.struct.CountryWarFaction;
import com.ayjs.mxzg.largecross.module.countryWar.struct.CountryWarGroup;
import com.ayjs.mxzg.message.module.countryWar.CountryWarMatchFailReqMessage;
import com.ayjs.mxzg.template.scheduler.service.SchedulerService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Service
@Slf4j
public class WarWorker extends AbstractStageWorker {

    @Autowired
    protected SchedulerService schedulerService;
    @Autowired
    protected CountryWarCitySysCache countryWarCitySysCache;
    @Autowired
    private CountryWarRandomEventSysCache countryWarRandomEventSysCache;
    @Autowired
    private CountryWarTimeSysCache countryWarTimeSysCache;
    @Autowired
    private CountryWarServerDao countryWarServerDao;
    @Autowired
    private CountryWarDamageWarRankService countryWarDamageWarRankService;
    @Autowired
    private CountryWarKillRankService countryWarKillRankService;
    @Autowired
    private CountryWarScoreWarRankService countryWarScoreWarRankService;
    @Autowired
    private CountryWarHeroWarRankService countryWarHeroWarRankService;
    @Autowired
    private CountryWarRoleDao countryWarRoleDao;
    @Autowired
    private EventBus eventBus;

    private LocalDateTime nextZero;

    @Override
    public CountryWarStage getStage() {
        return CountryWarStage.WAR;
    }

    @Override
    protected void processAfterChange(CountryWarTime countryWarTime) {
        countryWarTime.setGroupTime(LocalDate.of(1970, 1, 1));
        tryAnother(false);
    }

    public void tryAnother(boolean force) {
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        if (countryWarTime.getStage() != getStage().getValue()) {
            log.info("阶段不对，不允许分组");
            return;
        }
        if (force || !countryWarTime.getGroupTime().isEqual(LocalDate.now())) {
            doAnotherDay(countryWarTime, force);
            countryWarTime.setGroupTime(LocalDate.now());
            countryWarTimeDao.update(countryWarTime);
        }

        if (!force) {
            schedulerNext(countryWarTime);
        }
    }

    /***
     * 隔天
     * @param countryWarTime
     */
    protected void doAnotherDay(CountryWarTime countryWarTime, boolean force) {

        CCountryWarTime configTemp = countryWarTimeSysCache.getOrThrow(countryWarTime.getConfigIdx());
        if (force || LocalDateTime.now().isBefore(configTemp.getMatch_end_time())) {
            match(countryWarTime, configTemp);
        }


        countryWarTime.getGroupData().values().forEach(group -> {
            CCountryWarRandomEvent randomConfig = DropUtil.randomDrop(countryWarRandomEventSysCache.getAll());
            List<CCountryWarCity> list = countryWarCitySysCache.getAll().stream().filter(config -> config.getType() != 1).collect(Collectors.toList());
            Collections.shuffle(list);

            group.resetEvent(list.get(0).getIdx(), randomConfig.getIdx());
            //重置新的商城
            group.resetShop(list.get(1).getIdx());

        });
    }

    public void schedulerNext(CountryWarTime countryWarTime) {
        LocalDateTime next = LocalDateTime.now();
        next = next.plusDays(1);
        next = next.withSecond(0);
        next = next.withHour(0);
        next = next.withMinute(0);
        next = next.withNano(0);

        if (this.nextZero != null && next.isEqual(this.nextZero)) {
            return;
        }

        try {
            CCountryWarTime config = countryWarTimeSysCache.getById(countryWarTime.getConfigIdx() + 1);
            if (!config.getStart_time().isAfter(next)) {
                return;
            }
        } catch (Exception e) {
            log.error("config not exist", e);
            return;
        }
        this.nextZero = next;
        schedulerService.schedule("country_war_group", () -> tryAnother(false), LocalDateTimeUtil.toEpochSecond(next) -
                LocalDateTimeUtil.toEpochSecond(LocalDateTime.now()), TimeUnit.SECONDS);
        log.info("country war start next group server task! time:{}", next.toString());
    }

    protected void match(CountryWarTime countryWarTime, CCountryWarTime config) {
        List<CountryWarServer> warServers = countryWarServerDao.listAll();
        warServers = warServers.stream().filter((countryWarServer ->
                countryWarServer.getActiveFighting() > 0 &&
                        !countryWarTime.getServer2Group().containsKey(countryWarServer.getServerId()) &&
                        countryWarServer.isValidServer())).collect(Collectors.toList());
        warServers.sort(Comparator.comparingLong(CountryWarServer::getActiveFighting));

        List<CCountryWarCity> baseCamps = countryWarCitySysCache.getByType(1);
        log.info("待分组的服务器：" + GsonUtils.toJson(warServers.stream().mapToInt(CountryWarServer::getServerId)
                .boxed().collect(Collectors.toList())) + ",大本营数量：" + countryWarCitySysCache.getBaseCampNum());
        while (warServers.size() >= countryWarCitySysCache.getBaseCampNum()) {
            List<CountryWarServer> groupList = warServers.subList(warServers.size() - countryWarCitySysCache.getBaseCampNum(), warServers.size());
            doMatchGroup(countryWarTime, baseCamps, groupList);
            warServers.removeAll(groupList);
        }

        //今天是匹配的最后一天，匹配剩余服务器
        if (!LocalDate.now().plusDays(1).isBefore(config.getMatch_end_time().toLocalDate()) && warServers.size() > 0) {
            if (warServers.size() > 1) {
                doMatchGroup(countryWarTime, baseCamps, warServers);
            } else {
                log.info("服务器：{}匹配失败，补偿奖励：", warServers.get(0).getServerId());
                //补偿
                countryWarConnectService.sendToServer(warServers.get(0).getServerId(), new CountryWarMatchFailReqMessage());
            }
        }

    }

    private void doMatchGroup(CountryWarTime countryWarTime, List<CCountryWarCity> baseCamps, List<CountryWarServer> groupList) {
        int factionIndex = 0;
        List<Integer> serverIds = groupList.stream().mapToInt(CountryWarServer::getServerId).boxed().collect(Collectors.toList());
        Map<Integer, CountryWarCity> cityList = initAllCities();
        CountryWarGroup group = countryWarTime.addServerToGroup(serverIds);
        for (CountryWarServer server : groupList) {
            CCountryWarCity cityConfig = baseCamps.get(factionIndex);
            CountryWarCity city = cityList.get(cityConfig.getIdx());
            city.setServerId(server.getServerId());
            city.setOccupyTime(LocalDateTime.now());

            //客户端要求颜色对应
            server.setFaction(CountryWarFaction.valueOf(1 << (cityConfig.getCamp() - 1)).getValue());
            server.setRound(countryWarTime.getRound());
            server.getLogs().clear();
            server.setScore(0);
            server.getCityRewardCount().clear();
            server.getEventRewardCount().clear();
            server.setBaseCamp(city.getId());
            factionIndex++;
            countryWarServerDao.update(server);
        }

        groupList.forEach(server -> {
            eventBus.post(CountryWarServerAddScoreEvent.of(server.getServerId(), countryWarTime.getServer2Group().get(server.getServerId())));
        });

        log.info("分组服务器：" + GsonUtils.toJson(groupList.stream().mapToInt(CountryWarServer::getServerId)
                .boxed().collect(Collectors.toList())));
        group.getCityMap().putAll(cityList);
    }


    public Map<Integer, CountryWarCity> initAllCities() {
        Map<Integer, CountryWarCity> result = new ConcurrentHashMap<>();
        countryWarCitySysCache.getAll().forEach(config -> {
            CountryWarCity city = new CountryWarCity();
            city.setId(config.getIdx());
            result.put(city.getId(), city);
        });
        return result;
    }

    @Override
    protected void processBeforeChange(CountryWarTime countryWarTime) {
        countryWarTime.getServer2Group().clear();
        countryWarTime.getGroupData().clear();
        countryWarTime.setGroupIndex(1);
        countryWarTime.setHadSettle(false);

        countryWarDamageWarRankService.clear();
        countryWarScoreWarRankService.clear();
        countryWarHeroWarRankService.clear();
        countryWarKillRankService.clear();
    }

    @Override
    public void start() {
        tryAnother(false);
    }
}
