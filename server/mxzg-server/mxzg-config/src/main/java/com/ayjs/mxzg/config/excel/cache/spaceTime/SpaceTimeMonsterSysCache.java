package com.ayjs.mxzg.config.excel.cache.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeMonster;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Component
public class SpaceTimeMonsterSysCache extends BaseExcelCache<CSpaceTimeMonster> {

    /**
     * 获取航线某组怪物
     *
     * @param routeId
     * @param groupId
     * @return
     */
    private List<CSpaceTimeMonster> getMonsterGroups(int routeId, int groupId) {
        return getAll().stream().filter(config -> config.getRoute_id() == routeId && config.getGroup_id() == groupId).collect(Collectors.toList());
    }

    /**
     * 抽取某条航行的一组怪物数据
     *
     * @param routeId
     * @return
     */
    public List<CSpaceTimeMonster> getRoutedMonsters(int routeId) {
        Map<Integer, CSpaceTimeMonster> map = new HashMap<>();
        getAll().stream().filter(config -> config.getRoute_id() == routeId && map.get(config.getGroup_id()) == null).
                forEach(config -> {
                    map.put(config.getGroup_id(), config);
                });
        CSpaceTimeMonster cSpaceTimeMonster = DropUtil.randomDrop(new ArrayList<>(map.values()));
        return getMonsterGroups(routeId, cSpaceTimeMonster.getGroup_id());
    }

    @Override
    public String getFileName() {
        return "spacetimemonster";
    }
}
