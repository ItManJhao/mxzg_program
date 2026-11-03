package com.ayjs.mxzg.config.excel.cache.stageMatch.cross;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.stageMatch.cross.CStageCrossServer;
import org.springframework.stereotype.Repository;

import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/6/19
 **/
@Repository
public class StageCrossServerSysCache extends BaseExcelCache<CStageCrossServer> {

    private Map<Integer, CStageCrossServer> map;

    @Override
    protected void loadAfterReady() {
        map = getAll().stream().collect(Collectors.toMap(CStageCrossServer::getServer_id, Function.identity()));
    }

    public CStageCrossServer getByServerId(int serverId) {
        return map.get(serverId);
    }

    @Override
    public String getFileName() {
        return "largecrossserver";
    }
}
