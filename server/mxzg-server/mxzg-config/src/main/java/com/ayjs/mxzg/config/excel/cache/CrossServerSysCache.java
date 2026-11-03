package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CCrossServer;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * 跨服预配置
 */
@Component
public class CrossServerSysCache extends BaseExcelCache<CCrossServer> {
    // 分组隐射的服务器列表
    @Getter
    private Map<Integer, List<CCrossServer>> groupServer;
    @Getter
    private Map<Integer, CCrossServer> serverMap;

    @Override
    public String getFileName() {
        return "crossserver";
    }

    @Override
    protected void loadAfterReady() {
        this.groupServer = this.fillListMap(CCrossServer::getGroup_id);
        serverMap = getAll().stream().collect(Collectors.toMap(CCrossServer::getServer_id, Function.identity()));
    }

    /**
     * 根据分组id获取服务器id列表
     *
     * @param groupId
     * @return
     */
    public List<Integer> getGroupServer(int groupId) {
        return groupServer.get(groupId).stream().map(CCrossServer::getServer_id).collect(Collectors.toList());
    }

    /**
     * 获取分组id列表
     *
     * @return
     */
    public Collection<Integer> getGroupIds() {
        return this.groupServer.keySet();
    }

    /**
     * 获取最大的Group配置id
     *
     * @return
     */
    public Integer getMaxConfigGroupId() {
        Collection<Integer> groupIds = getGroupIds();
        return groupIds.isEmpty() ? 0 : groupIds.stream().max(Integer::compareTo).get();
    }

    public CCrossServer getByServerId(int serverId) {
        return serverMap.get(serverId);
    }

}
