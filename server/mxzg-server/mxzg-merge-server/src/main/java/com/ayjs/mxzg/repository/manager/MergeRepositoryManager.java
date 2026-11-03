package com.ayjs.mxzg.repository.manager;

import com.ayjs.mxzg.common.persistence.repository.DataBaseAccessorManager;
import com.ayjs.mxzg.config.Config;
import com.ayjs.mxzg.repository.persister.MergeRepository;
import com.ayjs.mxzg.repository.platform.Server;
import com.google.common.collect.Maps;
import lombok.extern.slf4j.Slf4j;

import java.util.List;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/8/20
 **/
@Slf4j
public class MergeRepositoryManager {

    /***
     * 游戏库
     */
    public static final String DATA_SIGN = "data";
    /***
     * 日志库
     */
    public static final String LOG_SIGN = "log";

    private static MergeRepositoryManager instance;


    public static MergeRepositoryManager getInstance() {
        if (instance == null) {
            instance = new MergeRepositoryManager();
        }
        return instance;
    }

    private Map<String, MergeRepository> map = Maps.newHashMap();

    public void initPlatform() {
        addRepository(Config.getInstance().getPlatform(), Config.getInstance().getPlatform());
    }

    public MergeRepository getPlatform() {
        return get(Config.getInstance().getPlatform());
    }

    public void initServerGame(List<Server> servers) {
        servers.forEach(server -> {
            if (server.getParentId() != 0) {
                log.info("子服务器：{}不操作合服！", server.getId());
                return;
            }
            addRepository(buildSign(server.getId(), DATA_SIGN), server.getDbGameDatabase());
            addRepository(buildSign(server.getId(), LOG_SIGN), server.getDbLogDatabase());
        });
    }

    private void addRepository(String sign, String dbName) {
        log.info("{}", sign);
        map.put(sign, new MergeRepository(DataBaseAccessorManager.getInstance().get(sign), dbName));
    }

    private MergeRepository get(String sign) {
        return map.get(sign);
    }

    public MergeRepository get(int serverId, String source) {
        return get(buildSign(serverId, source));
    }


    public String buildSign(int serverId, String source) {
        return serverId + "_" + source;
    }


}
