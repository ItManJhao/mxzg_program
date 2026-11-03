/**
 *
 */
package com.ayjs.mxzg.center.module.dao;

import com.ayjs.mxzg.center.module.domain.ServerInfo;
import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.message.center.dto.GroupType;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 服务器信息
 */
@Repository
public class ServerInfoDao extends CacheAllDelayedJDBCRepository<ServerInfo> {

    /**
     * 获取所有未分组的服务器列表
     * @param serverIds
     * @return
     */
    public List<ServerInfo> getAllNotGroupServer(Collection<Integer> serverIds){
        return listAll().stream().filter(serverInfo -> !serverIds.contains(serverInfo.getId())).collect(Collectors.toList());
    }

    /**
     * 添加服务器信息
     * @param serverId
     * @param worldLevel
     * @param activePlayersNumber
     * @param openServerTime
     * @param groupType
     */
    public void updateServerInfo(int serverId, int worldLevel, int activePlayersNumber, LocalDateTime openServerTime, GroupType groupType) {
        ServerInfo serverInfo = get(serverId);
        if (serverInfo != null) {
            serverInfo.update(worldLevel, activePlayersNumber, groupType, openServerTime);
            update(serverInfo);
        } else {
            serverInfo = ServerInfo.of(serverId, worldLevel, activePlayersNumber, groupType.ordinal(), openServerTime);
            add(serverInfo);
        }
    }

}
