package com.ayjs.mxzg.largecross.module.countryWar.service;

import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarConst;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarTimeSysCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarTime;
import com.ayjs.mxzg.config.excel.entity.countrywar.CountryWarStage;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarRoleDao;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarServerDao;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarTimeDao;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarRole;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarServer;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarTime;
import com.ayjs.mxzg.largecross.module.countryWar.pb.CountryWarPbConverter;
import com.ayjs.mxzg.largecross.module.countryWar.struct.CountryWarGroup;
import com.ayjs.mxzg.largecross.module.countryWar.worker.StageWorker;
import com.ayjs.mxzg.message.module.countryWar.CountryWarCityBroadcastMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarSmallCityBroadcastMessage;
import com.ayjs.mxzg.message.module.countryWar.dto.CountryWarLogInfo;
import com.ayjs.mxzg.protocol.CountryWarGMsg;
import com.ayjs.mxzg.template.scheduler.service.SchedulerService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Service
@Slf4j
public class CountryWarService implements Lifecycle, IRegister<StageWorker> {
    @Autowired
    private CountryWarTimeSysCache countryWarTimeSysCache;
    @Autowired
    private CountryWarTimeDao countryWarTimeDao;
    @Autowired
    private SchedulerService schedulerService;
    @Autowired
    private CountryWarServerDao countryWarServerDao;
    @Autowired
    private CountryWarRoleDao countryWarRoleDao;
    @Autowired
    private CountryWarConst countryWarConst;
    @Autowired
    private CountryWarPbConverter countryWarPbConverter;
    @Autowired
    private CountryWarConnectService countryWarConnectService;

    private Map<CountryWarStage, StageWorker> map = new HashMap<>();

    @Override
    public void registerBean(StageWorker bean) {
        StageWorker old = map.put(bean.getStage(), bean);
        if (old != null) {
            throw new RuntimeException(" same stage worker :" + bean.getStage());
        }
    }

    /***
     * 低于定时器启动
     * @return
     */
    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.MEDIUM, Ordinal._10, "country_war");
    }

    @Override
    public void start() throws Exception {
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        CCountryWarTime timeConfig = countryWarTimeSysCache.getByTime(LocalDateTime.now());
        //所有的配置事件都在当前之后，设置第一个定时器设置第一个事件状态
        if (timeConfig == null) {
            if (countryWarTimeSysCache.getAll().isEmpty()) {
                log.error("CountryWarTimeSysCache is empty!");
                return;
            }
            throw new RuntimeException("不存在时间配置");
        } else {
//            理论上不可能停服时间操作一轮以上，所有没有做循环过滤
            if (countryWarTime.getConfigIdx() == 0) {
                //第一次启动，找到对应的轮次开始的配置
                setNewStage(timeConfig);
            } else {
                while (countryWarTime.getConfigIdx() < timeConfig.getIdx()) {
                    CCountryWarTime nextConfig = countryWarTimeSysCache.getById(countryWarTime.getConfigIdx() + 1);
                    setNewStage(nextConfig);
                }

                //正在开放的配置id大于当前配置,结束当前这一轮，重开为当前配置,这种情况只存在GM调整了下一个阶段
                if (countryWarTime.getConfigIdx() > timeConfig.getIdx()) {
                    while (countryWarTimeSysCache.getOrThrow(countryWarTime.getConfigIdx()).getStage() != CountryWarStage.SETTLE.getValue()) {
                        CCountryWarTime nextConfig = countryWarTimeSysCache.getById(countryWarTime.getConfigIdx() + 1);
                        if (nextConfig == null) {
                            break;
                        }
                        setNewStage(nextConfig);
                    }

                    setNewStage(timeConfig);
                }

            }
            map.get(CountryWarStage.valueOf(countryWarTime.getStage())).start();
            schedulerNext(timeConfig);
        }

    }

    public void setNewStage(CCountryWarTime config) {
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        if (countryWarTime.getConfigIdx() == config.getIdx()) {
            log.error("已经在该阶段,配置表idx:{}", config.getIdx());
            return;
        }
        log.info("set new stage，config idx:{}", config.getIdx());
        map.get(CountryWarStage.valueOf(config.getStage())).process(config);
    }

    public void schedulerNext(CCountryWarTime config) {
        if (config.getIdx() == countryWarTimeSysCache.getMaxId()) {
            log.error("next time config:{} not exist", config.getIdx());
            return;
        }
        CCountryWarTime nextConfig = countryWarTimeSysCache.getOrThrow(config.getIdx() + 1);
        schedulerService.schedule("country_war_stage_change", () -> {
            setNewStage(nextConfig);
            schedulerNext(nextConfig);
        }, LocalDateTimeUtil.toEpochSecond(nextConfig.getStart_time()) -
                LocalDateTimeUtil.toEpochSecond(LocalDateTime.now()), TimeUnit.SECONDS);
        log.info("country war 下一阶段{}定时器：{}", nextConfig.getStage(), nextConfig.getStart_time().toString());
    }

    public void serverAddLog(int serverId, CountryWarLogInfo countryWarLogInfo) {
        CountryWarServer countryWarServer = countryWarServerDao.get(serverId);
        countryWarServer.getLogs().add(countryWarLogInfo);
        while (countryWarServer.getLogs().size() > countryWarConst.getLogMaxNum()) {
            countryWarServer.getLogs().remove(0);
        }
        countryWarServerDao.update(countryWarServer);
    }

    public void roleAddLog(CountryWarRole role, CountryWarLogInfo countryWarLogInfo) {
        role.getLogs().add(countryWarLogInfo);
        while (role.getLogs().size() > countryWarConst.getLogMaxNum()) {
            role.getLogs().remove(0);
        }
        countryWarRoleDao.update(role);
    }

    /***
     * 客户端说所有操作都广播给所有人
     */
    public void broadAllRole(int groupId) {
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        for (CountryWarRole role : countryWarRoleDao.listAll()) {
            if (role.isOnline() && countryWarTime.getServer2Group().getOrDefault(role.getMainServerId(), -1) == groupId) {
                countryWarConnectService.sendToServer(role.getMainServerId(), CountryWarCityBroadcastMessage.of(
                        builderScanCity(role.getMainServerId(), role.getRid()).build().toByteArray(), role.getRid()));
            }
        }
    }

    /***
     * 客户端说所有操作都广播给所有人
     */
    public void broadSmallAllRole(int groupId, List<Integer> cityIds) {

        if (cityIds == null || cityIds.isEmpty()) {
            return;
        }
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        CountryWarGroup groupData = countryWarTime.getGroupData().get(groupId);
        for (CountryWarRole role : countryWarRoleDao.listAll()) {
            if (role.isOnline() && countryWarTime.getServer2Group().getOrDefault(role.getMainServerId(), -1) == groupId) {
                CountryWarSmallCityBroadcastMessage res = CountryWarSmallCityBroadcastMessage.of(role.getRid());
                cityIds.forEach(cityId -> {
                    res.getData().add(countryWarPbConverter.buildSmall(groupData.getCity(cityId)).toByteArray());
                });
                countryWarConnectService.sendToServer(role.getMainServerId(), res);
            }
        }
    }


    public CountryWarGMsg.GResCountryWarCity.Builder builderScanCity(int serverId, long rid) {
        CountryWarRole role = countryWarRoleDao.get(rid);
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        Integer groupId = countryWarTime.getServer2Group().get(serverId);
        CountryWarGMsg.GResCountryWarCity.Builder builder = CountryWarGMsg.GResCountryWarCity.newBuilder();
        CountryWarGroup groupData = countryWarTime.getGroupData().get(groupId);
        groupData.getCityMap().forEach((id, city) -> {
            builder.addCities(countryWarPbConverter.build(city, groupData));
        });

        List<Integer> list = groupData.getServerIds();
        for (Integer serverTemp : list) {
            builder.addServers(countryWarPbConverter.build(countryWarServerDao.get(serverTemp)));
        }
        builder.setCurrId(role.getDefendCity());
        return builder;
    }

}
