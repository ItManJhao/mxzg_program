package com.ayjs.mxzg.config.excel.cache.crusadegroup;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupMap;
import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Table;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * 讨伐团npc
 */
@Slf4j
@Component
public class CrusadeGroupMapSysCache extends BaseExcelCache<CCrusadeGroupMap> {

    /** 通过坐标映射领地 */
    private Table<Integer, Integer, CCrusadeGroupMap> maps = HashBasedTable.create();
    /** 通过领地id映射地图 */
    private Map<Integer, CCrusadeGroupMap> territory = new HashMap<>();

    @Override
    public String getFileName() {
        return "crusadegroupmap";
    }

    @Override
    protected void loadAfterReady() {
        Collection<CCrusadeGroupMap> all = getAll();
        for (CCrusadeGroupMap cCrusadeGroupMap : all) {
            maps.put(cCrusadeGroupMap.getX(), cCrusadeGroupMap.getY(), cCrusadeGroupMap);
            territory.put(cCrusadeGroupMap.getGroup_id(), cCrusadeGroupMap);
        }
    }

    /**
     * 根据坐标获取讨伐团地图
     * @param x
     * @param y
     * @return
     */
    public CCrusadeGroupMap getMap(int x, int y){
        return maps.get(x, y);
    }

    /**
     * 根据领地id获取
     * @param groupId 对应领地id
     * @return
     */
    public CCrusadeGroupMap getMap(int groupId){
        return territory.get(groupId);
    }

    /**
     * 获取所有领地
     * @return
     */
    public Collection<CCrusadeGroupMap> getAllMap(){
        return territory.values();
    }

}
