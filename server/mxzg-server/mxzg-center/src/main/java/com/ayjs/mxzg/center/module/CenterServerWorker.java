package com.ayjs.mxzg.center.module;

import com.ayjs.mxzg.center.module.dao.CrossClusterDao;
import com.ayjs.mxzg.center.module.dao.CrossConfigDao;
import com.ayjs.mxzg.center.module.dao.ServerInfoDao;
import com.ayjs.mxzg.center.module.domain.CrossCluster;
import com.ayjs.mxzg.center.module.domain.CrossConfig;
import com.ayjs.mxzg.center.module.domain.ServerInfo;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.scheduler.CommonScheduledHolder;
import com.ayjs.mxzg.common.util.DateFormatConstants;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.config.excel.cache.CrossServerSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.message.center.PushServerCrossInfoMessage;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.center.dto.GroupType;
import com.ayjs.mxzg.message.cross.CrossRegroupMessage;
import com.ayjs.mxzg.message.cross.UpdateCrossGroupMessage;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoField;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

/**
 * 中心服工作者
 */
@Slf4j
@Component
public class CenterServerWorker implements Lifecycle {

    @Autowired
    private CrossClusterDao clusterDao;
    @Autowired
    private ServerInfoDao serverInfoDao;
    @Autowired
    private CrossConfigDao crossConfigDao;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private SessionManager sessionManager;
    @Autowired
    private CrossServerSysCache crossServerSysCache;

    /**
     * 分組id生成器
     */
    private AtomicInteger groupIdBuilder = new AtomicInteger(1);
    /**
     * 开关
     */
    private AtomicBoolean open = new AtomicBoolean(false);
    /**
     * 跨服开启时间格式化对象
     */
    private DateTimeFormatter formatter = DateTimeFormatter.ofPattern(DateFormatConstants.FORMAT_NORMAL);
    /**
     * 调度器
     */
    private ScheduledExecutorService executorService = CommonScheduledHolder.getScheduledExecutorService();

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf("CENTER_SERVER_WORKER");
    }

    @Override
    public void start() throws Exception {
        log.info("启中心服数据检测...");
        crossStartChecker();
        CrossCluster crossCluster = clusterDao.get();
        int maxGroupId = crossCluster.getMaxGroupId();
        this.groupIdBuilder = new AtomicInteger(maxGroupId + 1);
        log.info("中心服检测完毕!!!");
    }

    /**
     * 跨服开启检测
     */
    public void crossStartChecker() {
        CrossCluster crossCluster = clusterDao.get();
        LocalDateTime nowDateTime = LocalDateTime.now();
        LocalDateTime nextRegroupTime = crossCluster.getRegroupingTime();
        log.info("当前刷新时间为:{}", nextRegroupTime);
        if (nowDateTime.isAfter(crossCluster.getRegroupingTime())) {
            log.info("重新计算刷新时间并刷新分组");
            crossCluster.setAssignation(false);
            nextRegroupTime = calNextRegroupTime();
            crossCluster.setRegroupingTime(nextRegroupTime);
        }

        if (!crossCluster.isAssignation()) {
            if (nextRegroupTime == null) {
                log.error("下次分组刷新时间计算失败，跨服功能关闭");
                return;
            }
            regroup();
            log.info("下次跨服重组时间为:{}", nextRegroupTime);
        }
        clusterDao.update(crossCluster);

        scheduleRegroupTime(nextRegroupTime);
    }

    /**
     * 重新分组
     */
    public synchronized void regroup() {

        CrossCluster crossCluster = clusterDao.get();
        try {
            crossCluster.reset();

            List<CrossConfig> crossConfigs = crossConfigDao.listAll();
            log.info("跨服服务器配置数为:{}", crossConfigs.size());
            if (CollectionUtils.isEmpty(crossConfigs)) {
                log.info("配置的跨服服务器数为0，重新分组失败");
                return;
            }

            List<CrossGroup> configGroups = crossServerConfigGroup(crossConfigs);
            log.info("配置分组数:{}", configGroups.size());
            crossCluster.addGroups(configGroups);

            Integer maxConfigGroupId = crossServerSysCache.getMaxConfigGroupId();
            this.groupIdBuilder = new AtomicInteger(maxConfigGroupId + 1);
            log.info("最大的分组配置id为:{}", maxConfigGroupId);

            Set<Integer> serverIds = crossCluster.getServerGroup().keySet();
            List<ServerInfo> serverInfos = serverInfoDao.getAllNotGroupServer(serverIds);
            if (CollectionUtils.isEmpty(serverInfos)) {
                log.info("配置外的服务器列表为空分组完毕");
                return;
            }

            log.info("服务器已连接的服务器数：{}", serverInfos.size());

            int oldWorldLevel = systemSysCache.getCrossServerOldGroupWorldLevel();
            log.info("世界等级分界线{}", oldWorldLevel);
            List<ServerInfo> oldServers = serverInfos.stream().filter(serverInfo -> serverInfo.isOldServer()).collect(Collectors.toList());
            log.info("旧服总数:{}", oldServers.size());
            int oldActivePlayerNum = systemSysCache.getOldGroupActivePlayers();
            List<CrossGroup> oldGroups = group(crossConfigs, GroupType.OLD_SERVER, oldServers, oldActivePlayerNum);
            log.info("旧服总分组数:{}", oldGroups.size());
            crossCluster.addGroups(oldGroups);

            List<ServerInfo> newServers = serverInfos.stream().filter(serverInfo -> !serverInfo.isOldServer()).collect(Collectors.toList());
            int newActivePlayerNum = systemSysCache.getNewGroupActivePlayers();
            List<CrossGroup> newGroups = group(crossConfigs, GroupType.NEW_SERVER, newServers, newActivePlayerNum);
            log.info("新服总分组数:{}", newGroups.size());
            crossCluster.addGroups(newGroups);

        } finally {
            clusterDao.update(crossCluster);
        }

        log.info("服务器重新分组完成!");
    }

    /**
     * 推送重组消息
     */
    public void pushRegroupMessage() {
        List<CrossConfig> crossConfigs = crossConfigDao.listAll();
        CrossCluster crossCluster = clusterDao.get();
        log.info("开始推送跨服分组数据到跨服...");
        for (CrossConfig cross : crossConfigs) {
            List<CrossGroup> groups = crossCluster.getCrossGroups(cross.getCrossServerId());
            sessionManager.pushMessageToCross(cross.getCrossServerId(), CrossRegroupMessage.of(crossCluster.getSerialNumber(), groups));
            log.info("推送跨服分组信息到跨服服务器:{}", cross.getCrossServerId());
            for (CrossGroup group : groups) {
                for (Integer serverId : group.getServerIds()) {
                    log.info("推送跨服信息到游戏服:{}", serverId);
                    sessionManager.pushMessageToServer(serverId, PushServerCrossInfoMessage.of(group.getGroupId(), cross.getIp(), cross.getPort()));
                }
            }
        }
    }

    /**
     * 添加定时重组任务
     * @param nextRegroupTime
     */
    public void scheduleRegroupTime(LocalDateTime nextRegroupTime){
        int intervalWeekNumber = systemSysCache.getCrossServerRegroupIntervalWeek();
        long oneCycleMillisSecond = intervalWeekNumber * TimeConstants.ONE_WEEK_SECOND;
        int nextRegroupMS = LocalDateTimeUtil.toEpochSecond(nextRegroupTime) - LocalDateTimeUtil.toEpochSecond(LocalDateTime.now());;
        log.info("距离下次重组剩余:{}", DateTimeUtil.toDhmsStyle(nextRegroupMS));
        executorService.scheduleAtFixedRate(() -> startRegroup(), nextRegroupMS, oneCycleMillisSecond, TimeUnit.SECONDS);
    }


    /**
     * 开始重新分组
     */
    public void startRegroup() {
        try {
            log.info("跨服开始重新分组");
            LocalDateTime nextRegroupTime = resetNextRegroupingTime();
            regroup();
            pushRegroupMessage();
            log.info("跨服重新分组完毕，下次重组时间:{}", nextRegroupTime);
        } catch (Exception ex){
            ex.printStackTrace();
        }
    }

    /**
     * 跨服配置分组
     * @param crossConfigs
     * @return
     */
    public List<CrossGroup> crossServerConfigGroup(List<CrossConfig> crossConfigs){
        List<CrossGroup> groups = new ArrayList<>();
        for (Integer groupId : crossServerSysCache.getGroupIds()) {
            List<Integer> serverIds = crossServerSysCache.getGroupServer(groupId);
            int crossServerId = crossConfigs.get(groupId % crossConfigs.size()).getCrossServerId();
            CrossGroup group = CrossGroup.createOf(groupId, crossServerId, true, GroupType.NEW_SERVER, serverIds);
            groups.add(group);
        }
        return groups;
    }

    /**
     * 重新设置重组刷新时间
     */
    public LocalDateTime resetNextRegroupingTime() {
        int intervalWeekNumber = systemSysCache.getCrossServerRegroupIntervalWeek();
        long oneCycleMillisSecond = intervalWeekNumber * TimeConstants.ONE_WEEK_SECOND;
        CrossCluster crossCluster = clusterDao.get();
        LocalDateTime regroupTime = crossCluster.getRegroupingTime();
        regroupTime = regroupTime.plusSeconds(oneCycleMillisSecond);
        crossCluster.setRegroupingTime(regroupTime);
        clusterDao.update(crossCluster);
        return regroupTime;
    }

    /**
     * 分組指定的列表
     *
     * @param crossConfigs
     * @param groupType
     * @param servers
     * @param activePlayerNumber
     */
    public List<CrossGroup> group(List<CrossConfig> crossConfigs, GroupType groupType, List<ServerInfo> servers, int activePlayerNumber) {
        log.info("服务器组:{}开始分组总服务器数:{}活跃人数:{}", groupType, servers.size(), activePlayerNumber);
        Collections.sort(servers);
        List<CrossGroup> crossGroups = new ArrayList<>();
        int groupNum = 0;
        int groupSize = getGroupSizeBy(groupType);
        while (servers.size() >= groupSize) {
            int endSize = Math.min(2 * groupSize, servers.size());
            List<ServerInfo> serverInfos = servers.subList(0, endSize);
            ServerInfo firstServer = serverInfos.remove(0);
            List<ServerInfo> groupServers = RandomUtil.randomList(serverInfos, groupSize - 1);
            groupServers.add(firstServer);
            Set<Integer> serverIds = addServerByActive(serverInfos, groupServers, activePlayerNumber);

            int crossServerId = crossConfigs.get(groupNum % crossConfigs.size()).getCrossServerId();
            CrossGroup group = CrossGroup.createOf(groupIdBuilder.getAndIncrement(), crossServerId, false, groupType, serverIds);
            checkGroupFull(group);
            crossGroups.add(group);
        }

        if(!CollectionUtils.isEmpty(servers)){
            List<Integer> serverIds = servers.stream().mapToInt(ServerInfo::getId).boxed().collect(Collectors.toList());
            crossGroups.add(CrossGroup.createOf(groupIdBuilder.getAndIncrement(), crossConfigs.get(0).getCrossServerId(), false, groupType, serverIds));
        }
        return crossGroups;
    }

    /**
     * 根据活跃添加服务器
     * @param serverInfos
     * @param groupServers
     * @param activePlayerNumber
     * @return
     */
    private Set<Integer> addServerByActive(List<ServerInfo> serverInfos, List<ServerInfo> groupServers, int activePlayerNumber){
        Set<Integer> serverIds = Collections.emptySet();
        do {
            serverInfos.removeAll(groupServers);
            serverIds = groupServers.stream().mapToInt(ServerInfo::getId).boxed().collect(Collectors.toSet());
            int groupActivePlayerNumber = getGroupServerActivePlayers(serverIds);
            if(groupActivePlayerNumber > activePlayerNumber){
                break;
            }

            List<ServerInfo> serverInfo = RandomUtil.randomList(serverInfos, 1);
            groupServers.addAll(serverInfo);
        } while (!serverInfos.isEmpty());
        return serverIds;
    }

    /**
     * 计算下一次重新分组的时间
     *
     * @return
     */
    private LocalDateTime calNextRegroupTime() {
        String crossServerStartTime = systemSysCache.getCrossServerStartTime();
        int intervalWeekNumber = systemSysCache.getCrossServerRegroupIntervalWeek();
        if (StringUtils.isBlank(crossServerStartTime)) {
            log.error("跨服开始时间未设置：{}", crossServerStartTime);
            return null;
        }

        if (intervalWeekNumber < 1) {
            log.error("跨服分配间隔未设置{}默认两周重组", intervalWeekNumber);
            return null;
        }

        long nowS = LocalDateTimeUtil.toEpochSecond(LocalDateTime.now());
        long startTimeS = DateTimeUtil.str2time(crossServerStartTime, false);
        log.info("跨服分组开始时间:{}每{}周重新分配一次", crossServerStartTime, intervalWeekNumber);

        long oneCycleMillisSecond = intervalWeekNumber * TimeConstants.ONE_WEEK_SECOND;
        int timeoutS = (int) ((nowS - startTimeS) % oneCycleMillisSecond);
        LocalDate localDate = null;
        if (startTimeS > nowS) {
            localDate = LocalDate.parse(crossServerStartTime, DateTimeFormatter.ofPattern(DateFormatConstants.FORMAT_NORMAL));
        } else {
            localDate = LocalDate.now();
            int plusWeek = intervalWeekNumber - (timeoutS / (int) TimeConstants.ONE_WEEK_SECOND);
            localDate = localDate.plusWeeks(plusWeek);
            int regroupWeek = systemSysCache.getCrossServerRegroupWeek();
            localDate = localDate.with(ChronoField.DAY_OF_WEEK, regroupWeek);
        }
        LocalTime localTime = LocalTime.of(0, 0, 0);
        return LocalDateTime.of(localDate, localTime);
    }

    /**
     * 添加游戏服信息到跨服集群
     *
     * @param serverInfo
     * @param crossCluster
     * @return
     */
    public CrossGroup joinToGroup(ServerInfo serverInfo, CrossCluster crossCluster) {
        List<CrossConfig> crossConfigs = crossConfigDao.listAll();
        int groupId = this.groupIdBuilder.get() + 1;
        int crossServerId = getCrossServerId(crossConfigs, groupId);
        CrossGroup group = crossCluster.joinToGroup(serverInfo, this.groupIdBuilder, crossServerId);
        checkGroupFull(group);
        clusterDao.update(crossCluster);
        sessionManager.pushMessageToCross(group.getCrossServerId(), UpdateCrossGroupMessage.of(group));
        log.info("推送跨服分组更新groupId[{}]到跨服[{}]", group.getGroupId(), group.getCrossServerId());
        return group;
    }

    /**
     * 检测分组是否满了
     * @param group
     */
    private void checkGroupFull(CrossGroup group){
        int groupSize = getGroupSizeBy(group.getGroupType());
        if(group.getServerIds().size() < groupSize){
            return;
        }

        int activePlayers = getActivePlayersBy(group.getGroupType());
        int groupServerActivePlayers = getGroupServerActivePlayers(group.getServerIds());
        if(groupServerActivePlayers < activePlayers){
            return;
        }
        group.setFull(true);
    }

    /**
     * 根据分组类型获取分组大小
     * @param groupType
     * @return
     */
    private int getGroupSizeBy(GroupType groupType){
        return groupType == GroupType.OLD_SERVER ? systemSysCache.getOldCrossServerGroupSize() : systemSysCache.getNewCrossServerGroupSize();
    }

    /**
     * 获取分组获取活跃玩家数量
     * @param serverIds
     * @return
     */
    private int getGroupServerActivePlayers(Set<Integer> serverIds){
        int totalActivePlayerNum = 0;
        for (Integer serverId : serverIds) {
            ServerInfo serverInfo = serverInfoDao.get(serverId);
            if(serverInfo != null){
                totalActivePlayerNum += serverInfo.getActivePlayersNumber();
            }
        }
        return totalActivePlayerNum;
    }

    /**
     * 根据分组类型获取活跃人数
     * @param groupType
     * @return
     */
    private int getActivePlayersBy(GroupType groupType){
        return groupType == GroupType.OLD_SERVER ? systemSysCache.getOldGroupActivePlayers() : systemSysCache.getNewGroupActivePlayers();
    }

    /**
     * 获取跨服id
     *
     * @param crossServers
     * @param groupId
     * @return
     */
    private int getCrossServerId(List<CrossConfig> crossServers, int groupId) {
        int serverIndex = groupId % crossServers.size();
        return crossServers.get(serverIndex).getCrossServerId();
    }

}
