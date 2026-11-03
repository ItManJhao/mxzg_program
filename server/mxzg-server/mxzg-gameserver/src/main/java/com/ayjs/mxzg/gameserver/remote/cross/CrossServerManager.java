package com.ayjs.mxzg.gameserver.remote.cross;

import com.ayjs.mxzg.gameserver.remote.cross.dao.CrossServerGroupDao;
import com.ayjs.mxzg.gameserver.remote.cross.domain.CrossServerGroup;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class CrossServerManager {

    @Autowired
    private CrossServerClient crossServerClient;
    @Autowired
    private CrossServerGroupDao crossServerGroupDao;

    /**
     * 重连
     */
    public synchronized void reconnection() {
        log.info("开始连接跨服服务器");
        CrossServerGroup group = crossServerGroupDao.get();
        if (group.getGroupId() == 0) {
            log.error("没有配置跨服连接，远程服务器连接失败");
            return;
        }

        if (crossServerClient.isConnecting()) {
            if (crossServerClient.isSameServer(group.getIp(), group.getPort())) {
                log.info("跨服服务器没有切换，保持连接address:{}:{}", group.getIp(), group.getPort());
                return;
            } else {
                log.info("跨服服务器已经切换，开始断开跨服服务器...");
                crossServerClient.shutdown();
                log.info("跨服服务器已经断开，开始重新连接跨服！");
            }
        }

        crossServerClient.start(group.getIp(), group.getPort());
    }

}
