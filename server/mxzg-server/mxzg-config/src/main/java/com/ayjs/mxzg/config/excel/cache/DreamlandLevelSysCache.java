package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CDreamlandLevel;
import com.ayjs.mxzg.config.struct.MonsterTeamCheck;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2019/12/11
 **/
@Component
public class DreamlandLevelSysCache extends BaseExcelCache<CDreamlandLevel> implements MonsterTeamCheck {

    @Getter
    private Map<Integer, List<CDreamlandLevel>> missionMap = new HashMap<>();
    @Getter
    public int maxLv;

    @Override
    protected void loadAfterReady() {
        missionMap = getAll().stream().collect(Collectors.groupingBy(CDreamlandLevel::getMission_id));
        maxLv = getAll().stream().mapToInt(CDreamlandLevel::getMission_id).summaryStatistics().getMax();
    }

    @Override
    public String getFileName() {
        return "infinitelevel";
    }

    @Override
    public  List<List<CDreamlandLevel>> getAllTeams() {
        return ImmutableList.copyOf(missionMap.values());
    }
}
