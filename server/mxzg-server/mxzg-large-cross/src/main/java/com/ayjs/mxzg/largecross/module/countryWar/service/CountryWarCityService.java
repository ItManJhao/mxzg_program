package com.ayjs.mxzg.largecross.module.countryWar.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarCitySysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarRandomEventSysCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarCity;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarRandomEvent;
import com.ayjs.mxzg.config.excel.entity.countrywar.CountryWarStage;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarServerDao;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarTimeDao;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarServer;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarTime;
import com.ayjs.mxzg.largecross.module.countryWar.event.CountryWarBroadcastEvent;
import com.ayjs.mxzg.largecross.module.countryWar.event.CountryWarCityChangeServerEvent;
import com.ayjs.mxzg.largecross.module.countryWar.event.CountryWarServerAddScoreEvent;
import com.ayjs.mxzg.largecross.module.countryWar.struct.CountryWarCity;
import com.ayjs.mxzg.largecross.module.countryWar.struct.CountryWarCityEvent;
import com.ayjs.mxzg.largecross.module.countryWar.struct.CountryWarGroup;
import com.ayjs.mxzg.message.module.countryWar.CountryWarRewardRecordResMessage;
import com.ayjs.mxzg.template.scheduler.service.SchedulerService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/4/13
 **/
@Service
@Slf4j
@Observer
public class CountryWarCityService implements Lifecycle {

    @Autowired
    private CountryWarServerDao countryWarServerDao;
    @Autowired
    private CountryWarCitySysCache countryWarCitySysCache;
    @Autowired
    private SchedulerService schedulerService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private CountryWarTimeDao countryWarTimeDao;
    @Autowired
    private CountryWarRandomEventSysCache countryWarRandomEventSysCache;
    @Autowired
    private CountryWarConnectService countryWarConnectService;

    private Map<Integer, ScheduledFuture<?>> groupFuture = new ConcurrentHashMap<>();

    /***
     * 低于定时器启动
     * @return
     */
    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.MEDIUM, Ordinal._10, "country_war_city");
    }

    @Override
    public void start() throws Exception {
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        countryWarTime.getGroupData().keySet().forEach(group -> {
            schedulerReward(group);
        });
    }

    private void schedulerReward(int group) {
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();

        if (countryWarTime.getStage() == CountryWarStage.CLOSE_ING.getValue()
                || countryWarTime.getStage() == CountryWarStage.SETTLE.getValue()) {
            return;
        }

        CountryWarGroup groupData = countryWarTime.getGroupData().get(group);
        Collection<CountryWarCity> all = groupData.getCityMap().values();
        LocalDateTime nextScheduler = null;
        all = all.stream().filter(entity -> entity.getServerId() > 0).collect(Collectors.toList());
        Map<Integer, Map<CCountryWarCity, Integer>> serverAdd = new HashMap<>();
        Map<Integer, Map<Integer, Integer>> eventAdd = new HashMap<>();
        CountryWarCityEvent event = groupData.getEvent();
        for (CountryWarCity city : all) {
            CCountryWarCity config = countryWarCitySysCache.getById(city.getId());
            if (config.getReward_interval() == 0) {
                continue;
            }
            LocalDateTime lastRewardTime = city.getLastRewardTime();
            int interval = LocalDateTimeUtil.toEpochSecond(LocalDateTime.now()) - LocalDateTimeUtil.toEpochSecond(lastRewardTime);
            int rewardTimes = interval / config.getReward_interval();
            if (rewardTimes > 0) {
                serverAdd.computeIfAbsent(city.getServerId(), key -> new HashMap<>()).put(config, rewardTimes);
                city.setLastRewardTime(lastRewardTime.plusSeconds(rewardTimes * config.getReward_interval()));
            }
            LocalDateTime nextRewardTime = city.getLastRewardTime().plusSeconds(config.getReward_interval());
            if (nextScheduler == null || nextScheduler.isAfter(nextRewardTime)) {
                nextScheduler = nextRewardTime;
            }

            if (event != null && event.getCityId() == city.getId()) {
                CCountryWarRandomEvent eventConfig = countryWarRandomEventSysCache.getById(event.getEventId());
                LocalDateTime lastEventTime = event.getRewardTime();
                int eventInterval = LocalDateTimeUtil.toEpochSecond(LocalDateTime.now()) - LocalDateTimeUtil.toEpochSecond(lastEventTime);
                int eventTimes = eventInterval / eventConfig.getInterval();
                if (eventTimes > 0) {
                    eventAdd.computeIfAbsent(city.getServerId(), key -> new HashMap<>()).put(eventConfig.getIdx(), eventTimes);
                    event.setRewardTime(lastRewardTime.plusSeconds(eventTimes * eventConfig.getInterval()));
                }
                LocalDateTime nextEventTime = event.getRewardTime().plusSeconds(eventConfig.getInterval());
                if (nextScheduler == null || nextScheduler.isAfter(nextEventTime)) {
                    nextScheduler = nextEventTime;
                }
            }
        }

        if (!serverAdd.isEmpty() || !eventAdd.isEmpty()) {
            Set<CountryWarServer> updateServers = new HashSet<>();
            serverAdd.forEach((serverId, add) -> {
                CountryWarServer server = countryWarServerDao.get(serverId);
                int totalScore = 0;
                for (Map.Entry<CCountryWarCity, Integer> entry : add.entrySet()) {
                    totalScore += entry.getKey().getScore() * entry.getValue();
                    server.addCityRewardCount(entry.getKey().getIdx(), entry.getValue());
                }
                server.setScore(server.getScore() + totalScore);
                server.setRankTime(LocalDateTime.now());
                countryWarServerDao.update(server);
                eventBus.post(CountryWarServerAddScoreEvent.of(serverId, group));
                updateServers.add(server);
            });

            eventAdd.forEach((serverId, add) -> {
                CountryWarServer server = countryWarServerDao.get(serverId);
                for (Map.Entry<Integer, Integer> entry : add.entrySet()) {
                    server.addEventRewardCount(entry.getKey(), entry.getValue());
                }
                countryWarServerDao.update(server);
                updateServers.add(server);
            });
            for (CountryWarServer server : updateServers) {
                CountryWarRewardRecordResMessage message = new CountryWarRewardRecordResMessage();
                message.getCityReward().putAll(server.getCityRewardCount());
                message.getEventReward().putAll(server.getEventRewardCount());
                countryWarConnectService.sendToServer(server.getServerId(), message);
            }
            eventBus.post(CountryWarBroadcastEvent.of(group, Collections.emptyList()));
        }

        if (nextScheduler != null) {
            scheduler(nextScheduler, group);
        }
    }

    private void scheduler(LocalDateTime nextScheduler, int group) {
        ScheduledFuture<?> future = schedulerService.schedule("city scheduler reward,group:" + group, () -> {
            schedulerReward(group);
        }, LocalDateTimeUtil.toEpochSecond(nextScheduler) - LocalDateTimeUtil.toEpochSecond(LocalDateTime.now()), TimeUnit.SECONDS);
        log.info("country city reward scheduler ,time:{}", nextScheduler.toString());
        groupFuture.put(group, future);

    }

    @Subscribe
    public void listen(CountryWarCityChangeServerEvent event) {
        CCountryWarCity config = countryWarCitySysCache.getById(event.getIdx());
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        CountryWarGroup groupData = countryWarTime.getGroupData().get(event.getGroupId());
        CountryWarCity city = groupData.getCity(config.getIdx());
        LocalDateTime nextRewardTime = city.getLastRewardTime().plusSeconds(config.getReward_interval());
        ScheduledFuture<?> future = groupFuture.get(event.getGroupId());
        if (future == null || future.getDelay(TimeUnit.SECONDS) < config.getReward_interval()) {
            if (future != null)
                future.cancel(false);
            scheduler(nextRewardTime, event.getGroupId());
        }
    }
}
