package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CTower;
import com.ayjs.mxzg.config.struct.MonsterTeamCheck;
import com.google.common.collect.ImmutableList;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
public class TowerSysCache extends BaseExcelCache<CTower> implements MonsterTeamCheck {

    private Map<Integer, List<CTower>> layerMap;

    @Override
    public String getFileName() {
        return "tower";
    }

    @Override
    protected void loadAfterReady() {
        this.layerMap = this.fillListMap(CTower::getMission_id);
    }

    public List<CTower> getByMission(int mission) {
        return layerMap.get(mission);
    }

    @Override
    public List<List<CTower>> getAllTeams() {
        return ImmutableList.copyOf(layerMap.values());
    }
}
