package com.ayjs.mxzg.gameserver.module.util;

import com.ayjs.mxzg.config.excel.cache.AreaSysCache;
import com.ayjs.mxzg.config.excel.entity.CArea;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.lionsoul.ip2region.DataBlock;
import org.lionsoul.ip2region.DbConfig;
import org.lionsoul.ip2region.DbSearcher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * ip获取地区城市
 */
@Slf4j
@Component
public class IPUtil {

    @Autowired
    private AreaSysCache areaSysCache;
    @Autowired
    private ServerConfig serverConfig;

    private DbSearcher dbSearcher;

    @Autowired
    public IPUtil(ServerConfig serverConfig) {
        try {
            if (StringUtils.isNotBlank(serverConfig.getIp2regionFile())){
                dbSearcher = new DbSearcher(new DbConfig(), serverConfig.getIp2regionFile());
                log.info("dbSearcher init:{}", dbSearcher);
            } else {
                log.info("dbSearcher init fail Ip2regionFile is null");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取城市id
     */
    public CArea getCityId(String ip) {
        // 调用外部数据，可能产生异常，所以捕获异常返回默认值
        try {
            DataBlock dataBlock = getCityDataBlock(ip);
            if (Objects.isNull(dataBlock)) {
                log.info("data block is null:{}", ip);
                return null;
            }

            String[] split = dataBlock.getRegion().split("\\|");
            String province = "";
            String cityName = "";
            if (split.length >= 4) {
                province = split[2];
                cityName = split[3];
            }
            CArea area = areaSysCache.getArea(province, cityName);
            if (Objects.isNull(area)) {
                log.info("area is null province:{},cityName:{}", province, cityName);
                return null;
            }
            return area;
        } catch (Exception e) {
            e.printStackTrace();
        }
        log.info("data block is null:{}", ip);
        return null;
    }

    private DataBlock getCityDataBlock(String ip) {
        try {
            if (Objects.nonNull(dbSearcher)) {
                DataBlock dataBlock = dbSearcher.memorySearch(ip);
                log.info("analysisRoleAreaId ip:{}, dataBlock:{}", ip, dataBlock);
                return dataBlock;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        log.info("getCityDataBlock data block is null:{}", ip);
        return null;
    }
}
