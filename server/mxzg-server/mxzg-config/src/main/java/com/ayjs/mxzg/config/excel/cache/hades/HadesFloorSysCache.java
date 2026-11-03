package com.ayjs.mxzg.config.excel.cache.hades;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.hades.CHadesFloor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Repository
public class HadesFloorSysCache extends BaseExcelCache<CHadesFloor> {

    private Map<Integer, List<CHadesFloor>> configMap;

    @Override
    protected void loadAfterReady() {
        configMap = getAll().stream().collect(Collectors.groupingBy(CHadesFloor::getType));
    }

    public CHadesFloor getByTypeAndFloor(int type, int floor) {
        List<CHadesFloor> hadesFloors = configMap.get(type);
        if (hadesFloors == null) {
            return null;
        }
        return hadesFloors.get(floor);
    }

    public List<CHadesFloor> listByType(int type) {
        return configMap.get(type);
    }

    @Override
    public String getFileName() {
        return "hadesfloor";
    }
}
