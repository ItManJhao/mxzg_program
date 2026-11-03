package com.ayjs.mxzg.config.excel.cache.hades;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.hades.CHadesMonster;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Repository
public class HadesMonsterSysCache extends BaseExcelCache<CHadesMonster> {

    private Map<Integer, List<CHadesMonster>> monsterMap;

    @Override
    protected void loadAfterReady() {
        monsterMap = getAll().stream().collect(Collectors.groupingBy(CHadesMonster::getFloor_idx));
    }

    public List<CHadesMonster> getByFloor(int floor) {
        return monsterMap.get(floor);
    }

    @Override
    public String getFileName() {
        return "hadesmonster";
    }
}
