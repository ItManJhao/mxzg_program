package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGodRelicLevel;
import com.ayjs.mxzg.config.struct.MonsterTeamCheck;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 诸神遗迹怪物
 *
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Component
public class GodRelicLevelSysCache extends BaseExcelCache<CGodRelicLevel> implements MonsterTeamCheck {

    private Map<Integer, Map<Integer, List<CGodRelicLevel>>> missionMap = null;

    @Override
    protected void loadAfterReady() {
        Map<Integer, List<CGodRelicLevel>> collect = getAll().stream().collect(Collectors.groupingBy(CGodRelicLevel::getMission_id));
        Map<Integer, Map<Integer, List<CGodRelicLevel>>> missionMap_ = new HashMap<>();
        for (Map.Entry<Integer, List<CGodRelicLevel>> entry : collect.entrySet()) {
            Map<Integer, List<CGodRelicLevel>> collect1 = entry.getValue().stream().collect(Collectors.groupingBy(CGodRelicLevel::getTeam));
            missionMap_.put(entry.getKey(), collect1);
        }
        missionMap = missionMap_;
    }

    @Override
    public String getFileName() {
        return "godreliclevel";
    }

    public Map<Integer, List<CGodRelicLevel>> getByMission(int mission) {
        return missionMap.get(mission);
    }

    @Override
    public List<List<CGodRelicLevel>> getAllTeams() {
        Collection<Map<Integer, List<CGodRelicLevel>>> values = missionMap.values();
        List<List<CGodRelicLevel>> result = new ArrayList<>();
        values.forEach(map -> {
            result.addAll(map.values());
        });
        return result;
    }
}
