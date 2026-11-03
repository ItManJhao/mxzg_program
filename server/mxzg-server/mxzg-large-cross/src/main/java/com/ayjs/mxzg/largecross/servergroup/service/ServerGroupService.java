package com.ayjs.mxzg.largecross.servergroup.service;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.stageMatch.cross.StageCrossServerSysCache;
import com.ayjs.mxzg.config.excel.entity.stageMatch.cross.CStageCrossServer;
import com.ayjs.mxzg.largecross.servergroup.dao.CrossServerGroupDao;
import com.ayjs.mxzg.largecross.servergroup.domain.CrossServerGroup;
import com.ayjs.mxzg.largecross.servergroup.event.CrossRegroupEvent;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.center.dto.GroupType;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/6/18
 **/
@Service
@Slf4j
public class ServerGroupService implements Lifecycle {

    @Autowired
    private CrossServerGroupDao crossServerGroupDao;

    @Autowired
    private StageCrossServerSysCache stageCrossServerSysCache;

    @Autowired
    private EventBus eventBus;

    public CrossServerGroup get() {
        return crossServerGroupDao.get();
    }

    public void updateCrossCluster(CrossServerGroup entity) {
        crossServerGroupDao.update(entity);
    }

    private synchronized void regroup() {
        log.info("赛跨服重组开始》》》》》");
        CrossServerGroup crossServerGroup = get();

        List<CStageCrossServer> configs = stageCrossServerSysCache.getAll();
        Map<Integer, List<CStageCrossServer>> groupServerConfigs = configs.stream().
                collect(Collectors.groupingBy(CStageCrossServer::getGroup_id));
        ConcurrentMap<Integer, CrossGroup> groupMap_ = new ConcurrentHashMap<>();
        ConcurrentMap<Integer, Integer> serverGroupMap_ = new ConcurrentHashMap<>();

        groupServerConfigs.forEach((groupId, serverConfigs) -> {
            List<Integer> serverIds = serverConfigs.stream().mapToInt(CStageCrossServer::getServer_id)
                    .collect(ArrayList::new, ArrayList::add, ArrayList::addAll);
            CrossGroup crossGroup = CrossGroup.createOf(groupId, 1, true, GroupType.OLD_SERVER, serverIds);
            groupMap_.put(groupId, crossGroup);
            serverIds.forEach(serverId -> serverGroupMap_.put(serverId, groupId));

        });
        crossServerGroup.setGroups(groupMap_);
        crossServerGroup.setRegroupingTime(LocalDateTime.now());
        crossServerGroup.setServerGroup(serverGroupMap_);
        crossServerGroup.setSerialNumber(TimeDateUtil.getCurrentTimeInt());
        crossServerGroup.setAssignation(true);
        updateCrossCluster(crossServerGroup);

        eventBus.post(CrossRegroupEvent.of());
        log.info("超凡段位赛跨服重组完毕》》》", JsonUtil.toJson(crossServerGroup));
    }

    /**
     * 开始重新分组
     */
    public void startRegroup() {
        try {
            log.info("跨服开始重新分组");
            regroup();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public CrossGroup getCrossGroup(int groupId) {
        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        return crossServerGroup.getGroupByGroupId(groupId);
    }


    public int getGroupId(int serverId) {
        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        CrossGroup crossGroup = crossServerGroup.getGroupByServerId(serverId);
        if (crossGroup == null) {
            return 0;
        }
        return crossGroup.getGroupId();
    }

    public CrossServerGroup getCrossServerGroup() {
        return crossServerGroupDao.get();
    }


    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf("large_cross_server");
    }

    @Override
    public void start() throws Exception {
        //起服时，没有分组，重新分配一下
        CrossServerGroup serverGroup = get();
        if (!serverGroup.isAssignation()) {
            regroup();
        }

        //查找是否有新服务器信息
        stageCrossServerSysCache.getAll().forEach(config -> {
            if (!serverGroup.getServerGroup().containsKey(config.getServer_id())) {
                CrossGroup group = serverGroup.getGroupByGroupId(config.getGroup_id());
                if (group == null) {
                    group = CrossGroup.createOf(config.getGroup_id(), 1, true, GroupType.NEW_SERVER, Arrays.asList(config.getServer_id()));
                    serverGroup.addGroup(group);
                }
                group.joinServer(config.getServer_id());
                serverGroup.getServerGroup().put(config.getServer_id(), group.getGroupId());
                //
                log.info("添加新服务器到组：{}", GsonUtils.toJson(config));
                updateCrossCluster(serverGroup);
            }
        });

    }
}
