package com.ayjs.mxzg.largecross.servergroup;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.config.excel.cache.stageMatch.cross.StageCrossServerSysCache;
import com.ayjs.mxzg.config.excel.entity.stageMatch.cross.CStageCrossServer;
import com.ayjs.mxzg.largecross.servergroup.dao.CrossServerGroupDao;
import com.ayjs.mxzg.largecross.servergroup.domain.CrossServerGroup;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;
import com.google.common.collect.Multimaps;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.stream.Collectors;

/**
 * 服务器连接管理
 */
@Slf4j
@Component
public class SessionManager {

    @Autowired
    private CrossServerGroupDao crossServerGroupDao;
    @Autowired
    private StageCrossServerSysCache stageCrossServerSysCache;

    /**
     * 客户端映射的serverId列表<serverId,clientId>
     */
    private ConcurrentMap<Integer, Integer> serverClientId = new ConcurrentHashMap<>();
    /**
     * 客户端id服映射的务器id<clientId, serverIds>
     */
    private Multimap<Integer, Integer> clientServerId = Multimaps.synchronizedListMultimap(ArrayListMultimap.create());

    /**
     * 更新服务器的客户端连接
     *
     * @param serverIds
     * @param clientId
     */
    public void updateServerClientId(List<Integer> serverIds, int clientId) {
        log.info("更新链接clientId:{}的映射serverIds:{}", clientId, serverIds);
        this.clientServerId.putAll(clientId, serverIds);
        for (Integer serverId : serverIds) {
            Integer expiredClientId = this.serverClientId.put(serverId, clientId);
            if (expiredClientId != null && expiredClientId != clientId) {
                this.clientServerId.removeAll(expiredClientId);
            }
        }

    }

    /**
     * 服务器断开连接
     *
     * @param clientId
     */
    public void serverDisconnect(int clientId) {
        Collection<Integer> serverIds = this.clientServerId.removeAll(clientId);
        log.info("删除服务器链接信息clientId[{}]映射serverIds:{}", clientId, serverIds);
        if (serverIds != null) {
            this.serverClientId.remove(serverIds);
        }
    }

    public Integer getClientId(int serverId) {
        int mergeServerId = serverId;
        try {
            CStageCrossServer config = stageCrossServerSysCache.getByServerId(serverId);
            mergeServerId = config.getMerge_server_id() == 0 ? serverId : config.getMerge_server_id();
        } catch (Exception e) {
            log.error(String.format("服务器{%s}的合服后的server id 异常", serverId), e);
        }
        return this.serverClientId.get(mergeServerId);
    }

    /**
     * 根据ClientId获取服务器id列表
     *
     * @param clientId
     * @return
     */
    public Collection<Integer> getServerIdsBy(int clientId) {
        return this.clientServerId.get(clientId);
    }

    /**
     * 根据ClientId获取最小服务器id
     *
     * @param clientId
     * @return
     */
    public Integer getServerIdBy(int clientId) {
        Collection<Integer> serverIds = this.clientServerId.get(clientId);
        if (null == serverIds || serverIds.isEmpty()) {
            return 0;
        }
        return serverIds.stream().mapToInt(Integer::intValue).min().getAsInt();
    }

    /**
     * 根据服务器id获取客户端id
     *
     * @param serverId
     * @return
     */
    public Integer getClientIdBy(int serverId) {
        return getClientId(serverId);
    }

    /**
     * 根据服务器id获取所属的客户端id列表
     *
     * @param serverId
     * @return
     */
    public Set<Integer> getGroupClientIdsByServerId(int serverId) {
        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        CrossGroup group = crossServerGroup.getGroupByServerId(serverId);
        if (group == null) {
            log.error("根据serverId:{}获取跨服组连接失败", serverId);
            return Collections.emptySet();
        }
        return getGroupClientIds(group);
    }

    /**
     * 根据服务器组id获取服务客户端id列表
     *
     * @param groupId
     * @return
     */
    public Set<Integer> getGroupClientIdsByGroupId(int groupId) {
        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        CrossGroup group = crossServerGroup.getGroups().get(groupId);
        return getGroupClientIds(group);
    }

    /**
     * 根据服务器组id获取服务客户端id列表
     *
     * @param clientId
     * @return
     */
    public Set<Integer> getGroupClientIdsByClientId(int clientId) {
        CrossGroup group = getGroupByClientId(clientId);
        return group != null ? getGroupClientIds(group) : Collections.emptySet();
    }

    /**
     * 根据客户端id获取分组
     *
     * @param clientId
     * @return
     */
    public CrossGroup getGroupByClientId(int clientId) {
        Collection<Integer> serverIds = this.clientServerId.get(clientId);
        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        for (Integer serverId : serverIds) {
            CrossGroup group = crossServerGroup.getGroupByServerId(serverId);
            if (group != null) {
                return group;
            }
        }
        log.error("根据client:{}获取跨服组连接失败serverId:{}", clientId, serverIds);
        return null;
    }

    /**
     * 获取当前跨服所有已连接的客户端id
     *
     * @param group
     * @return
     */
    public Set<Integer> getGroupClientIds(CrossGroup group) {
        return group.getServerIds().stream().map(this.serverClientId::get).filter(clientId -> clientId != null).collect(Collectors.toSet());
    }

}
