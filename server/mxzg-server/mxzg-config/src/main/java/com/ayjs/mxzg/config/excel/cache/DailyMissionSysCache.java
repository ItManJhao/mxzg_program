package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CDailyMission;
import com.ayjs.mxzg.config.struct.MonsterTeamCheck;
import com.google.common.collect.ImmutableList;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 日常副本配置
 */
@Component
public class DailyMissionSysCache extends BaseExcelCache<CDailyMission> implements MonsterTeamCheck {
    @Override
    public String getFileName() {
        return "dailymission";
    }

    public List<CDailyMission> getDailyMission(int missionType, int missionId) {
        return getAll().stream().filter(cDailyMission -> cDailyMission.getMission_type() == missionType
                && cDailyMission.getMission_id() == missionId).collect(Collectors.toList());
    }

    @Override
    public List<List<CDailyMission>> getAllTeams() {
        Map<String, List<CDailyMission>> collect = getAll().stream().collect(Collectors.groupingBy(config -> config.getMission_type() + "-" + config.getMission_id()));
        return ImmutableList.copyOf(collect.values());
    }
}
