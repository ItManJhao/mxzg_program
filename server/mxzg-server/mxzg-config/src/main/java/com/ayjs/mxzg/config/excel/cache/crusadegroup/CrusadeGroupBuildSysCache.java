package com.ayjs.mxzg.config.excel.cache.crusadegroup;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupBuild;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.TerritoryType;
import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Table;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/**
 * 讨伐团建筑
 */
@Slf4j
@Component
public class CrusadeGroupBuildSysCache extends BaseExcelCache<CCrusadeGroupBuild> {

    /** 建筑映射 */
    private Table<Integer, Integer, Map<TerritoryType, CCrusadeGroupBuild>> maps = HashBasedTable.create();

    @Override
    public String getFileName() {
        return "crusadegroupbuild";
    }

    @Override
    protected void loadAfterReady() {
        Collection<CCrusadeGroupBuild> all = getAll();
        for (CCrusadeGroupBuild building : all) {
            Map<TerritoryType, CCrusadeGroupBuild> map = this.maps.get(building.getArea_level(), building.getBuilding_level());
            if(map == null){
                map = new HashMap<>();
                maps.put(building.getArea_level(), building.getBuilding_level(), map);
            }
            map.put(building.getType(), building);

        }
    }

    /**
     * 根据分区跟建筑等级获取建筑数据
     * @param areaLevel
     * @param buildLevel
     * @param type
     * @return
     */
    public CCrusadeGroupBuild getBuild(int areaLevel, int buildLevel, TerritoryType type){
        Map<TerritoryType, CCrusadeGroupBuild> map = this.maps.get(areaLevel, buildLevel);
        if(CollectionUtils.isEmpty(map)){
            log.info("地图建筑数据获取失败areaLevel = {}, buildLevel = {}, type = {}", areaLevel, buildLevel, type.getCode());
        }

        CCrusadeGroupBuild build = map.get(type);
        if (Objects.isNull(build)) {
            log.info("地图建筑数据获取失败areaLevel = {}, buildLevel = {}, type = {}", areaLevel, buildLevel, type.getCode());
        }

        return build;
    }

}
