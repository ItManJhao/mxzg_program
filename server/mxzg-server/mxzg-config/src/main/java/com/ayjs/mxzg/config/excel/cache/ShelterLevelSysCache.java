package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CShelterLevel;
import com.ayjs.mxzg.config.struct.MonsterTeamCheck;
import com.google.common.collect.ImmutableList;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
public class ShelterLevelSysCache extends BaseExcelCache<CShelterLevel> implements MonsterTeamCheck {

    private Map<Integer, List<CShelterLevel>> stageMap;

    @Override
    public String getFileName() {
        return "shelterlevel";
    }

    @Override
    protected void loadAfterReady() {
        this.stageMap = this.fillListMap(CShelterLevel::getShelter_stage);
    }


    public List<CShelterLevel> getByStage(int stage) {
        return stageMap.get(stage);
    }

    public int maxShelterLevel() {
        int maxStage = 0;
        for (CShelterLevel cModel : this.getAll()) {
            if (cModel.getShelter_stage() > maxStage) {
                maxStage = cModel.getShelter_stage();
            }
        }
        return maxStage;
    }

    @Override
    public List<List<CShelterLevel>> getAllTeams() {
        return ImmutableList.copyOf(stageMap.values());
    }
}