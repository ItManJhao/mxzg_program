package com.ayjs.mxzg.largecross.module.countryWar.service;

import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarTimeDao;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarTime;
import com.ayjs.mxzg.largecross.module.countryWar.struct.CountryWarGroup;
import com.ayjs.mxzg.largecross.servergroup.SessionManager;
import com.ayjs.rpc.RemoteMessage;
import com.ayjs.rpc.server.ConnectionManager;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Service
@Slf4j
public class CountryWarConnectService {

    @Autowired
    private ConnectionManager connectionManager;
    @Autowired
    private CountryWarTimeDao countryWarTimeDao;
    @Autowired
    private SessionManager sessionManager;

    /***
     * 推给组消息
     * @param group
     * @param remoteMessage
     */
    public void push(int group, RemoteMessage remoteMessage) {
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        CountryWarGroup groupData = countryWarTime.getGroupData().get(group);
        if (groupData == null || groupData.getServerIds().isEmpty()) {
            log.error("CountryWar推送组{}消息异常", group);
            return;
        }
        groupData.getServerIds().forEach(serverId -> {
            sendToServer(serverId, remoteMessage);
        });
    }

    /***
     * 推给组消息
     * @param serverId
     * @param remoteMessage
     */
    public void pushByServer(int serverId, RemoteMessage remoteMessage) {
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        Integer groupId = countryWarTime.getServer2Group().get(serverId);
        if (groupId == null) {
            log.error("CountryWar推送组{}消息异常", serverId);
            return;
        }
        CountryWarGroup groupData = countryWarTime.getGroupData().get(groupId);
        groupData.getServerIds().forEach(serverIdTemp -> {
            sendToServer(serverIdTemp, remoteMessage);
        });
    }

    public void sendToServer(int serverId, RemoteMessage message) {
        Integer clientId = sessionManager.getClientId(serverId);
        if (clientId != null) {
            connectionManager.send(clientId, message);
        } else {
            log.error("服务器：{}不存在链接id", serverId);
        }
    }
}
